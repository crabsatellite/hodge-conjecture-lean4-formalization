# Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
"""
Prune ChainAudit unused-import candidates with compile verification.

Input is `chain-status/raw.json` emitted by ChainAudit.  The script reads the
actual Lean source files, removes only exact `import <module>` lines named by
selected unused-import rules, and compiles the importer plus direct reverse
dependents after each change.  That second validation step matters because Lean
imports are transitive: a module may compile after an import deletion while its
downstream consumers relied on the deleted import being re-exported.

This is intentionally conservative:

* no raw.json warning -> no edit
* no exact top-level import line -> no edit
* failed importer/dependent compile -> restore the file

Run from the Lean project root, for example:

    python ChainAudit/Postprocess/prune_unused_orphan_imports.py \
      --raw chain-status/raw.json \
      --apply \
      --rules W2.unused-import,W4.unused-orphan-import \
      --limit-files 20
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass(frozen=True)
class Candidate:
    importer: str
    imported: str
    path: Path


def _parse_findings(raw: dict[str, Any], rules: set[str]) -> list[Candidate]:
    tick = chr(96)
    candidates: list[Candidate] = []
    for finding in raw.get("findings", []):
        if finding.get("rule") not in rules:
            continue
        message = finding.get("message", "")
        parts = message.split(tick)
        if len(parts) < 4:
            continue
        loc = finding.get("loc")
        if not loc:
            continue
        candidates.append(Candidate(importer=parts[1], imported=parts[3], path=Path(loc)))
    return candidates


def _compile_lean(path: Path, timeout: int) -> tuple[bool, str]:
    cmd = ["lake", "env", "lean", str(path)]
    try:
        proc = subprocess.run(
            cmd,
            text=True,
            encoding="utf-8",
            errors="replace",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired as exc:
        output = exc.stdout or ""
        if isinstance(output, bytes):
            output = output.decode("utf-8", errors="replace")
        return False, output + f"\n[TIMEOUT] {' '.join(cmd)} timed out after {timeout}s"
    return proc.returncode == 0, proc.stdout


def _compile_targets(path: Path, targets: list[str], timeout: int) -> tuple[bool, str]:
    if not targets:
        return _compile_lean(path, timeout)
    cmd = ["lake", "build", *targets]
    try:
        proc = subprocess.run(
            cmd,
            text=True,
            encoding="utf-8",
            errors="replace",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired as exc:
        output = exc.stdout or ""
        if isinstance(output, bytes):
            output = output.decode("utf-8", errors="replace")
        return False, output + f"\n[TIMEOUT] {' '.join(cmd)} timed out after {timeout}s"
    return proc.returncode == 0, proc.stdout


def _reverse_import_index(raw: dict[str, Any]) -> dict[str, set[str]]:
    reverse: dict[str, set[str]] = defaultdict(set)
    for edge in raw.get("importEdges", []):
        importer = edge.get("importer")
        imports = edge.get("imports", [])
        if not isinstance(importer, str) or not isinstance(imports, list):
            continue
        for imported in imports:
            if isinstance(imported, str):
                reverse[imported].add(importer)
    return reverse


def _validation_targets(importer: str, reverse: dict[str, set[str]], depth: int) -> list[str]:
    targets = [importer]
    seen = {importer}
    frontier = {importer}
    for _ in range(max(0, depth)):
        next_frontier: set[str] = set()
        for module in frontier:
            for dependent in reverse.get(module, set()):
                if dependent in seen:
                    continue
                seen.add(dependent)
                targets.append(dependent)
                next_frontier.add(dependent)
        frontier = next_frontier
        if not frontier:
            break
    return targets


def _remove_import_lines(text: str, imports: set[str]) -> tuple[str, list[str]]:
    removed: list[str] = []
    kept: list[str] = []
    for line in text.splitlines(keepends=True):
        stripped = line.strip()
        if stripped.startswith("import "):
            mod = stripped.removeprefix("import ").strip()
            if mod in imports:
                removed.append(mod)
                continue
        kept.append(line)
    return "".join(kept), removed


def _try_write_and_compile(
    path: Path,
    original: str,
    new_text: str,
    timeout: int,
    apply: bool,
    targets: list[str],
) -> tuple[bool, str]:
    if not apply:
        return True, "(dry run)"
    path.write_text(new_text, encoding="utf-8")
    ok, output = _compile_targets(path, targets, timeout)
    if not ok:
        path.write_text(original, encoding="utf-8")
    return ok, output


def _mtime(path: Path) -> float:
    try:
        return path.stat().st_mtime
    except OSError:
        return 0.0


def main(argv: list[str]) -> int:
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", type=Path, default=Path("chain-status/raw.json"))
    ap.add_argument("--apply", action="store_true", help="write verified edits")
    ap.add_argument("--limit-files", type=int, default=0, help="newest importer files to process; 0 means all")
    ap.add_argument("--timeout", type=int, default=120, help="seconds per Lean compile")
    ap.add_argument(
        "--rules",
        default="W4.unused-orphan-import",
        help="comma-separated finding rules to prune; supported: W2.unused-import,W4.unused-orphan-import",
    )
    ap.add_argument(
        "--validate-reverse-depth",
        type=int,
        default=1,
        help="also lake-build reverse dependents of the edited module to this depth",
    )
    args = ap.parse_args(argv)

    raw = json.loads(args.raw.read_text(encoding="utf-8"))
    rules = {r.strip() for r in args.rules.split(",") if r.strip()}
    reverse = _reverse_import_index(raw)
    by_path: dict[Path, list[Candidate]] = defaultdict(list)
    for candidate in _parse_findings(raw, rules):
        by_path[candidate.path].append(candidate)

    paths = sorted(by_path, key=lambda p: (-_mtime(p), str(p)))
    if args.limit_files > 0:
        paths = paths[: args.limit_files]

    mode = "APPLY" if args.apply else "DRY-RUN"
    print(
        f"[prune-imports] mode={mode} rules={','.join(sorted(rules))} "
        f"files={len(paths)} candidates={sum(len(by_path[p]) for p in paths)}"
    )

    total_removed: list[tuple[Path, str]] = []
    total_failed: list[tuple[Path, str]] = []
    total_missing: list[tuple[Path, str]] = []

    for path in paths:
        if not path.exists():
            for c in by_path[path]:
                total_missing.append((path, c.imported))
            print(f"[missing] {path}")
            continue

        original = path.read_text(encoding="utf-8")
        imports = {c.imported for c in by_path[path]}
        batch_text, batch_removed = _remove_import_lines(original, imports)
        if not batch_removed:
            for imp in sorted(imports):
                total_missing.append((path, imp))
            print(f"[no-exact-line] {path}")
            continue

        importer = by_path[path][0].importer
        targets = _validation_targets(importer, reverse, args.validate_reverse_depth)
        print(
            f"[read] {path} candidate_imports={len(imports)} "
            f"exact_lines={len(batch_removed)} validate_targets={len(targets)}"
        )

        ok, output = _try_write_and_compile(path, original, batch_text, args.timeout, args.apply, targets)
        if ok:
            for imp in batch_removed:
                total_removed.append((path, imp))
            print(f"[kept] {path} removed={len(batch_removed)}")
            continue

        print(f"[batch-failed] {path}; retrying one import at a time")
        current = original
        for imp in batch_removed:
            next_text, removed = _remove_import_lines(current, {imp})
            if not removed:
                total_missing.append((path, imp))
                continue
            ok, output = _try_write_and_compile(path, current, next_text, args.timeout, args.apply, targets)
            if ok:
                current = next_text
                total_removed.append((path, imp))
                print(f"  [kept] {imp}")
            else:
                total_failed.append((path, imp))
                last_lines = "\n".join(output.strip().splitlines()[-6:])
                print(f"  [restore] {imp}")
                if last_lines:
                    print(last_lines)
        if args.apply:
            path.write_text(current, encoding="utf-8")

    print(
        "[prune-imports] summary "
        f"removed={len(total_removed)} failed={len(total_failed)} missing={len(total_missing)}"
    )
    if total_failed:
        print("[prune-imports] failed imports:")
        for path, imp in total_failed:
            print(f"  {path} <- {imp}")
    if total_missing:
        print("[prune-imports] missing exact import lines:")
        for path, imp in total_missing:
            print(f"  {path} <- {imp}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
