#!/usr/bin/env python3
# Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
"""
ChainAudit post-processor.

Reads `chain-status/raw.json` (emitted by `ChainAudit.Status.runAudit`)
and renders the human-readable Markdown reports:

  chain-status/onchain.md          -- on-chain files + decls in closure
  chain-status/offchain.md         -- off-chain (orphan / quarantine / infra)
  chain-status/orphans.md          -- WARNING list: orphan + on-disk-unloaded
  chain-status/cuts.md             -- axiom / open-Prop cut ledger
  chain-status/axioms.md           -- full per-endpoint axiom sets + diff vs baseline
  chain-status/trick-audit.md      -- axiom/Prop/trivial-premise trick checks
  chain-status/underscore-audit.md -- `_h_*` / `_x` param hits
  chain-status/import-audit.md     -- unused-import warnings
  chain-status/graph.md            -- Mermaid graph (kernel -> targets)
  chain-status/research-map.md     -- main/support/exploration/gap route map
  chain-status/route-index.md      -- decision-first route/gap/branch index
  chain-status/route-map.md        -- legacy route-map alias generated from route-index data
  chain-status/orphan-debt.md      -- import-connected orphan debt ledger
  chain-status/findings.md         -- merged invariant findings

Usage:
    python3 ChainAudit/Postprocess/post_process.py \\
        --raw chain-status/raw.json \\
        --out chain-status

The post-processor is project-agnostic: host-project route semantics
come from `ProjectConfig` fields serialized into `raw.json`.
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import sys
from collections import defaultdict
from functools import lru_cache
from pathlib import Path
from typing import Any


def load_raw(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_md(out_dir: Path, name: str, content: str) -> None:
    p = out_dir / name
    p.write_text(content, encoding="utf-8")


def render_onchain(data: dict[str, Any]) -> str:
    cfg = data["config"]
    files = data["files"]
    onchain = sorted([f for f in files if f["class"] == "on-chain"], key=lambda f: f["path"])
    cuts = sorted([f for f in files if f["class"] == "cut"], key=lambda f: f["path"])
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- on-chain files\n")
    lines.append(
        f"Files whose declarations are transitively reached from "
        f"`config.endpoints` (and are not in the quarantine list).\n"
    )
    lines.append(
        f"\n* on-chain: **{len(onchain)}**"
        f"  *  cut: **{len(cuts)}**"
        f"  *  total reached: **{len(onchain) + len(cuts)}**"
    )
    lines.append(
        f"\n* closure constants: {data['summary']['closureConstants']}"
        f"  *  closure modules: {data['summary']['closureModules']}\n"
    )
    lines.append("\n## On-chain files\n")
    lines.append("| file | decls | on-chain decls (sample) |")
    lines.append("|------|------:|--------------------------|")
    for f in onchain:
        sample = ", ".join(d.split(".")[-1] for d in f["closureDecls"][:3])
        more = f" (+{len(f['closureDecls'])-3} more)" if len(f["closureDecls"]) > 3 else ""
        lines.append(f"| `{f['path']}` | {f['decls']} | {sample}{more} |")
    lines.append("\n## Cut files (on-chain + declares axiom)\n")
    lines.append("| file | decls | axioms |")
    lines.append("|------|------:|-------:|")
    for f in cuts:
        lines.append(f"| `{f['path']}` | {f['decls']} | {f['axioms']} |")
    return "\n".join(lines) + "\n"


def render_offchain(data: dict[str, Any]) -> str:
    cfg = data["config"]
    files = data["files"]
    quarantine = sorted([f for f in files if f["class"] == "quarantine"], key=lambda f: f["path"])
    infra = sorted([f for f in files if f["class"] == "infra"], key=lambda f: f["path"])
    registered = sorted([f for f in files if f["class"] == "registered"], key=lambda f: f["path"])
    orphan = sorted([f for f in files if f["class"] == "orphan"], key=lambda f: f["path"])

    # Disk files not in env = on-disk but never imported.
    in_env_modules = {f["module"] for f in files}
    disk = data.get("diskFiles", [])
    unloaded = []
    for p in disk:
        mod = p.replace(".lean", "").replace("/", ".")
        if mod not in in_env_modules:
            unloaded.append(p)
    unloaded.sort()

    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- off-chain files\n")
    lines.append(
        "Files NOT transitively reached from any endpoint, grouped by\n"
        "five-way classification:\n"
    )
    lines.append(
        f"\n* quarantine: **{len(quarantine)}** (explicit failed-route list)\n"
        f"* infra:      **{len(infra)}** (standalone tools, audit scripts)\n"
        f"* registered: **{len(registered)}** (configured research route/gap files, off endpoint closure)\n"
        f"* orphan:     **{len(orphan)}** (loaded but unreachable - investigate)\n"
        f"* on-disk-unloaded: **{len(unloaded)}** (file exists but not imported by any chain)\n"
    )

    def section(title: str, group: list[dict[str, Any]]) -> None:
        lines.append(f"\n## {title} ({len(group)})\n")
        if not group:
            lines.append("(none)\n")
            return
        lines.append("| file | decls | axioms |")
        lines.append("|------|------:|-------:|")
        for f in group:
            lines.append(f"| `{f['path']}` | {f['decls']} | {f['axioms']} |")

    section("Quarantine", quarantine)
    section("Infra (standalone)", infra)
    section("Registered research routes/gaps", registered)
    section("Orphan (warning - investigate)", orphan)

    lines.append(f"\n## On-disk-unloaded ({len(unloaded)})\n")
    lines.append(
        "Files present in the source tree but NOT imported by the "
        "entry script.  Either wire them into the chain, mark them "
        "quarantine, or delete them.\n"
    )
    if unloaded:
        for p in unloaded:
            lines.append(f"- `{p}`")
    else:
        lines.append("(none)")
    return "\n".join(lines) + "\n"


def render_orphans(data: dict[str, Any]) -> str:
    cfg = data["config"]
    files = data["files"]
    orphan = sorted([f for f in files if f["class"] == "orphan"], key=lambda f: f["path"])

    in_env_modules = {f["module"] for f in files}
    disk = data.get("diskFiles", [])
    unloaded = []
    for p in disk:
        mod = p.replace(".lean", "").replace("/", ".")
        if mod not in in_env_modules:
            unloaded.append(p)
    unloaded.sort()

    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- orphan report (W1)\n")
    lines.append(
        "Orphans are files that EXIST but are NOT wired into the chain.\n"
        "For each orphan, the user should either:\n"
        "1. Wire it in (add an import from an on-chain file).\n"
        "2. Quarantine it (add to the host project's `config.quarantine`).\n"
        "3. Delete it.\n"
    )
    lines.append(
        f"\n* loaded-but-orphan: **{len(orphan)}**\n"
        f"* on-disk-but-unloaded: **{len(unloaded)}**\n"
    )
    lines.append("\n## Loaded-but-orphan (the env has them, no closure)\n")
    if orphan:
        for f in orphan:
            lines.append(
                f"- `{f['path']}` -- {f['decls']} decl(s)"
                + (f", {f['axioms']} axiom(s)" if f["axioms"] else "")
            )
    else:
        lines.append("(none)")
    lines.append("\n## On-disk-but-unloaded (file exists, never imported)\n")
    if unloaded:
        for p in unloaded:
            lines.append(f"- `{p}`")
    else:
        lines.append("(none)")
    return "\n".join(lines) + "\n"


def render_cuts(data: dict[str, Any]) -> str:
    cfg = data["config"]
    cuts = data["cuts"]
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- cut ledger\n")
    lines.append(
        "Every `axiom` reached from an endpoint.  Whitelisted cuts are\n"
        "open by design; non-whitelisted cuts are I1 hard-failures.\n"
    )
    if not cuts:
        lines.append("\n(no cuts in the closure)\n")
        return "\n".join(lines) + "\n"
    lines.append("\n| axiom | file | status |")
    lines.append("|-------|------|--------|")
    for c in sorted(cuts, key=lambda c: (not c["whitelisted"], c["name"])):
        status = "OPEN (whitelisted)" if c["whitelisted"] else "**DRIFT (not whitelisted)**"
        lines.append(f"| `{c['name']}` | `{c['path']}` | {status} |")
    return "\n".join(lines) + "\n"


def _axioms_body(data: dict[str, Any]) -> str:
    """Substantive body of axioms.md (without baseline trailer).
    Used for both rendering and baseline-diff comparison."""
    cfg = data["config"]
    sets = data["axiomSets"]
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- per-endpoint axioms\n")
    lines.append("Equivalent to running `#print axioms <endpoint>` for each endpoint.\n")
    for entry in sets:
        lines.append(f"\n## `{entry['endpoint']}`\n")
        if not entry["axioms"]:
            lines.append("(no axioms)")
        else:
            for ax in entry["axioms"]:
                lines.append(f"- `{ax}`")
    return "\n".join(lines) + "\n"


def _baseline_body(text: str) -> str:
    """Strip the trailing baseline / DRIFT section from a baseline file
    so the comparison is on substantive content only."""
    markers = ["\n## Baseline\n", "\n## DRIFT vs baseline\n"]
    for m in markers:
        idx = text.find(m)
        if idx >= 0:
            text = text[:idx]
    return text


def render_axioms(data: dict[str, Any], baseline_path: Path | None) -> str:
    body = _axioms_body(data)
    lines = [body.rstrip()]
    if baseline_path and baseline_path.exists():
        baseline_raw = baseline_path.read_text(encoding="utf-8")
        baseline_substantive = _baseline_body(baseline_raw).strip()
        current_substantive = body.strip()
        if baseline_substantive != current_substantive:
            lines.append("\n## DRIFT vs baseline\n")
            lines.append(
                "The axiom report differs from `axioms.baseline.md`.  Review\n"
                "the diff and update the baseline if the change is\n"
                "intentional.\n"
            )
        else:
            lines.append("\n## Baseline\n")
            lines.append("Matches `axioms.baseline.md`.\n")
    else:
        lines.append("\n## Baseline\n")
        lines.append("No `axioms.baseline.md` yet.  Run `cp axioms.md axioms.baseline.md`\n")
        lines.append("to lock the current axiom set.\n")
    return "\n".join(lines) + "\n"


def render_underscore(data: dict[str, Any]) -> str:
    cfg = data["config"]
    files = data["files"]
    on_chain_mods = {
        f["module"] for f in files if f["class"] in ("on-chain", "cut")
    }
    entries = data["underscores"]
    on_chain_hits = sorted(
        [u for u in entries if u["module"] in on_chain_mods],
        key=lambda u: (u["path"], u["decl"]),
    )
    other_hits = sorted(
        [u for u in entries if u["module"] not in on_chain_mods],
        key=lambda u: (u["path"], u["decl"]),
    )
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- underscore-param audit (W7)\n")
    lines.append(
        "Theorem / axiom surfaces with `_`-prefixed pi-binders.  These are\n"
        "review warnings: they can hide the `_h_atom` deception pattern, but\n"
        "some projects also use `_h` names as ordinary binder style.\n"
    )
    lines.append(
        f"\n* on-chain hits: **{len(on_chain_hits)}** (WARN)\n"
        f"* off-chain hits: **{len(other_hits)}** (informational)\n"
    )
    lines.append("\n## On-chain hits (review debt)\n")
    if on_chain_hits:
        lines.append("| file | decl | params |")
        lines.append("|------|------|--------|")
        for u in on_chain_hits:
            ps = ", ".join(u["params"])
            lines.append(f"| `{u['path']}` | `{u['decl']}` | `{ps}` |")
    else:
        lines.append("(none)")
    lines.append("\n## Off-chain hits (informational)\n")
    if other_hits:
        lines.append("| file | decl | params |")
        lines.append("|------|------|--------|")
        for u in other_hits:
            ps = ", ".join(u["params"])
            lines.append(f"| `{u['path']}` | `{u['decl']}` | `{ps}` |")
    else:
        lines.append("(none)")
    return "\n".join(lines) + "\n"


def render_trick_audit(data: dict[str, Any]) -> str:
    cfg = data["config"]
    rules = {
        "I1.forbidden-axiom",
        "I4.assumption-as-goal",
        "I5.vacuous-prop-def",
        "I6.vacuous-theorem",
        "W5.prop-def",
        "W5.suspicious-prop-def",
        "W6.vacuous-theorem",
    }
    findings = [f for f in data["findings"] if f["rule"] in rules]
    fail_n = sum(1 for f in findings if f["severity"] == "FAIL")
    warn_n = sum(1 for f in findings if f["severity"] == "WARN")
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- trick-surface audit\n")
    lines.append(
        "Focused audit for proof-engineering escape hatches: unapproved "
        "axioms, direct assumption-as-goal theorems, vacuous Prop placeholders, "
        "and Prop-valued definitions that may hide stronger premises. "
        "Scope is audit-visible Lean modules; W3 on-disk-orphan files must be "
        "imported or quarantined before their declarations can be inspected."
    )
    lines.append("")
    lines.append(f"* findings: **{len(findings)}**  *  FAIL: **{fail_n}**  *  WARN: **{warn_n}**")
    if fail_n == 0:
        lines.append("* hard trick failures: **none detected**")
    lines.append("* review priority: hard failures, then `W5.suspicious-prop-def`, then the full `W5.prop-def` ledger")
    lines.append("")
    lines.append("## Rule Meanings\n")
    lines.append("- `I1.forbidden-axiom`: endpoint-reached axiom not whitelisted.")
    lines.append("- `I4.assumption-as-goal`: theorem has a premise syntactically identical to its conclusion.")
    lines.append("- `I5.vacuous-prop-def`: on-chain `def : Prop` is a literal True/False/Unit-style placeholder.")
    lines.append("- `I6.vacuous-theorem`: on-chain theorem conclusion is literally True/Unit-style.")
    lines.append("- `W5.prop-def`: audit-visible `def : Prop`; check it is definitional infrastructure.")
    lines.append("- `W5.suspicious-prop-def`: `def : Prop` name suggests hypothesis/strengthening/placeholder risk.")
    lines.append("- `W6.vacuous-theorem`: off-chain theorem with a literal True/Unit-style conclusion.")
    if not findings:
        lines.append("\n(no trick-surface findings)\n")
        return "\n".join(lines) + "\n"
    by_rule: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for f in findings:
        by_rule[f["rule"]].append(f)
    rule_order = [
        "I1.forbidden-axiom",
        "I4.assumption-as-goal",
        "I5.vacuous-prop-def",
        "W5.suspicious-prop-def",
        "W5.prop-def",
    ]
    ordered_rules = [r for r in rule_order if r in by_rule]
    ordered_rules += sorted(r for r in by_rule if r not in set(rule_order))
    for rule in ordered_rules:
        items = sorted(by_rule[rule], key=lambda f: (f.get("loc") or "", f.get("message") or ""))
        sev = items[0]["severity"]
        lines.append(f"\n## {rule} ({sev}) -- {len(items)}\n")
        for f in items:
            loc = f.get("loc") or ""
            suffix = f"  ({loc})" if loc else ""
            lines.append(f"- {f['message']}{suffix}")
    return "\n".join(lines) + "\n"


def render_import_audit(data: dict[str, Any]) -> str:
    cfg = data["config"]
    findings = [f for f in data["findings"] if f["rule"] == "W2.unused-import"]
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- import audit (W2)\n")
    lines.append(
        "On-chain import compile-prune candidates.  These are static signals:\n"
        "the reflected declarations do not consume project declarations from\n"
        "the imported module closure, but theorem proof/elaboration can still\n"
        "require the import.  Only remove a candidate after compile verification.\n"
    )
    if not findings:
        lines.append("\n(none)\n")
        return "\n".join(lines) + "\n"
    lines.append(f"\n**{len(findings)}** finding(s):\n")
    for f in sorted(findings, key=lambda f: f.get("loc") or ""):
        loc = f.get("loc") or ""
        lines.append(f"- {loc}: {f['message']}")
    return "\n".join(lines) + "\n"


def render_graph(data: dict[str, Any], max_nodes: int = 80) -> str:
    cfg = data["config"]
    endpoints = cfg["endpoints"]
    cuts = data["cuts"]
    kernel = set(cfg["kernelAxioms"]) | set(cfg.get("trustedAxioms", []))
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- chain DAG (Mermaid)\n")
    lines.append(
        "Source nodes = kernel axioms (squares).  Sink nodes = endpoints\n"
        "(hexagons).  Cuts = whitelisted open axioms (diamonds).  Drift\n"
        "axioms = unwhitelisted axioms in the closure (highlighted).\n"
    )

    def safe_id(name: str) -> str:
        # Mermaid node IDs: ASCII alnum + underscore; replace others.
        return "".join(c if c.isalnum() else "_" for c in name)

    lines.append("\n```mermaid")
    lines.append("graph TD")
    lines.append("  classDef kernel fill:#eef,stroke:#557")
    lines.append("  classDef cut fill:#ffd,stroke:#a80")
    lines.append("  classDef drift fill:#fdd,stroke:#a00,stroke-width:3px")
    lines.append("  classDef endpoint fill:#dfd,stroke:#080")

    declared_ids: set[str] = set()

    # Cut axioms.  Kernel axioms (e.g. propext) appear in the cuts list;
    # we render them with the `cut` shape (whitelisted) but skip the
    # separate `kernel` square to avoid duplicate node IDs.
    cut_names = {c["name"] for c in cuts}
    for c in cuts:
        sid = safe_id(c["name"])
        if sid in declared_ids:
            continue
        declared_ids.add(sid)
        cls = "cut" if c["whitelisted"] else "drift"
        label = c["name"].split(".")[-1]
        lines.append(f'  {sid}{{{{ "{label}" }}}}:::{cls}')

    # Trusted-but-not-in-closure kernel axioms (rare; usually for
    # documentation -- shown as squares).
    for k in sorted(kernel - cut_names):
        sid = safe_id(k)
        if sid in declared_ids:
            continue
        declared_ids.add(sid)
        label = k.split(".")[-1]
        lines.append(f'  {sid}["{label}"]:::kernel')

    # Endpoint nodes (hexagons via >"..."]).
    for ep in endpoints:
        sid = safe_id(ep)
        if sid in declared_ids:
            continue
        declared_ids.add(sid)
        label = ep.split(".")[-1]
        lines.append(f'  {sid}>"{label}"]:::endpoint')

    # Edges: endpoint -> each axiom it transitively uses.
    sets = data.get("axiomSets", [])
    seen_edges: set[tuple[str, str]] = set()
    for entry in sets:
        ep_sid = safe_id(entry["endpoint"])
        for ax in entry["axioms"]:
            ax_sid = safe_id(ax)
            edge = (ep_sid, ax_sid)
            if edge in seen_edges:
                continue
            seen_edges.add(edge)
            lines.append(f"  {ep_sid} --> {ax_sid}")

    lines.append("```\n")

    chains = cfg.get("researchChains", [])
    gaps = cfg.get("researchGaps", [])
    if chains or gaps:
        gap_by_id = {g["id"]: g for g in gaps}

        def node_id(prefix: str, raw: str) -> str:
            return safe_id(prefix + "_" + raw)

        def short_label(raw: str, max_len: int = 64) -> str:
            text = raw.replace('"', "'")
            if len(text) <= max_len:
                return text
            return text[: max_len - 3] + "..."

        def chain_class(chain: dict[str, Any]) -> str:
            kind = (chain.get("kind") or "").lower()
            status = (chain.get("status") or "").lower()
            if kind == "main":
                return "routeMain"
            if kind == "dead" or "quarantine" in status:
                return "routeDead"
            if kind == "support" or "closed" in status:
                return "routeSupport"
            return "routeActive"

        def gap_class(gap: dict[str, Any]) -> str:
            status = (gap.get("status") or "").lower()
            if any(token in status for token in ["dead", "false", "quarantine", "refuted", "bypass-only"]):
                return "gapDead"
            if "closed" in status:
                return "gapClosed"
            if "legacy" in status:
                return "gapLegacy"
            return "gapOpen"

        priority_label = {
            gid: f"P{i}"
            for i, gid in enumerate(cfg.get("gapPriority", []), start=1)
        }

        lines.append("\n## Route Overlay (Generated)\n")
        lines.append(
            "The first graph is the endpoint/axiom trust DAG.  This overlay is "
            "generated from `researchChains` and `researchGaps`; use it to choose "
            "the next proof attack.  When `primaryGapId` and "
            "`replacementRouteId` are configured, the replacement edge is drawn "
            "explicitly and priority labels come from `gapPriority`."
        )
        lines.append("\n```mermaid")
        lines.append("graph TD")
        lines.append("  classDef routeMain fill:#dfd,stroke:#080,stroke-width:2px")
        lines.append("  classDef routeActive fill:#e7f0ff,stroke:#246,stroke-width:2px")
        lines.append("  classDef routeSupport fill:#eef,stroke:#557")
        lines.append("  classDef routeDead fill:#fdd,stroke:#a00,stroke-width:2px")
        lines.append("  classDef gapOpen fill:#ffd,stroke:#a80,stroke-width:2px")
        lines.append("  classDef gapClosed fill:#eee,stroke:#777")
        lines.append("  classDef gapLegacy fill:#eee,stroke:#777,stroke-dasharray:3 3")
        lines.append("  classDef gapDead fill:#fdd,stroke:#a00,stroke-dasharray:4 2")

        for chain in chains:
            cid = node_id("chain", chain["id"])
            label = short_label(f"chain:{chain['id']}\\n{chain.get('status', '-')}")
            lines.append(f'  {cid}["{label}"]:::{chain_class(chain)}')
        for gap in gaps:
            gid = node_id("gap", gap["id"])
            label = short_label(f"gap:{gap['id']}\\n{gap.get('status', '-')}")
            lines.append(f'  {gid}{{{{"{label}"}}}}:::{gap_class(gap)}')

        for chain in chains:
            cid = node_id("chain", chain["id"])
            for dep in chain.get("dependsOn", []):
                lines.append(f"  {node_id('chain', dep)} --> {cid}")
            for gid in chain.get("gapIds", []):
                if gid not in gap_by_id:
                    continue
                gap_node = node_id("gap", gid)
                if (
                    cfg.get("replacementRouteId") == chain["id"]
                    and cfg.get("primaryGapId") == gid
                ):
                    lines.append(f"  {gap_node} -->|replacement route| {cid}")
                    continue
                edge_label = priority_label.get(gid)
                if edge_label:
                    lines.append(f"  {cid} -->|{edge_label}| {gap_node}")
                else:
                    lines.append(f"  {cid} --> {gap_node}")

        lines.append("```\n")

    # Drift highlight.
    drift = [c for c in cuts if not c["whitelisted"]]
    if drift:
        lines.append(f"\n## DRIFT axioms ({len(drift)})\n")
        for c in drift:
            lines.append(f"- `{c['name']}` at `{c['path']}` (NOT whitelisted)")
    return "\n".join(lines) + "\n"


def _safe_mermaid_id(name: str) -> str:
    return "".join(c if c.isalnum() else "_" for c in name)


def _escape_mermaid_label(label: str) -> str:
    return label.replace('"', "'")


def _postprocess_cache(data: dict[str, Any]) -> dict[str, Any]:
    return data.setdefault("_postprocessCache", {})


def _path_class_lookup(data: dict[str, Any]) -> tuple[dict[str, str], set[str]]:
    cache = _postprocess_cache(data)
    if "path_class_lookup" in cache:
        return cache["path_class_lookup"]
    file_classes = {
        f["path"].replace("\\", "/"): f["class"]
        for f in data.get("files", [])
    }
    disk = {p.replace("\\", "/") for p in data.get("diskFiles", [])}
    result = (file_classes, disk)
    cache["path_class_lookup"] = result
    return result


def _classify_path(path: str, file_classes: dict[str, str], disk: set[str]) -> str:
    p = path.replace("\\", "/")
    if p in file_classes:
        return file_classes[p]
    if p in disk:
        return "on-disk-unloaded"
    return "missing"


def _format_path_class_counts(paths: list[str], data: dict[str, Any]) -> str:
    file_classes, disk = _path_class_lookup(data)
    counts: dict[str, int] = defaultdict(int)
    for p in paths:
        counts[_classify_path(p, file_classes, disk)] += 1
    if not counts:
        return "(none)"
    return ", ".join(f"{k}: {v}" for k, v in sorted(counts.items()))


def _path_to_module(path: str) -> str:
    p = path.replace("\\", "/")
    if p.endswith(".lean"):
        p = p[:-5]
    return p.replace("/", ".")


def _module_to_path(module: str) -> str:
    return module.replace(".", "/") + ".lean"


def _file_mtime(path: str) -> float:
    try:
        return Path(path).stat().st_mtime
    except OSError:
        return 0.0


def _fmt_mtime(ts: float) -> str:
    if ts <= 0:
        return "missing"
    return dt.datetime.fromtimestamp(ts).strftime("%Y-%m-%d %H:%M")


def _fmt_date(ts: float) -> str:
    if ts <= 0:
        return "missing"
    return dt.datetime.fromtimestamp(ts).strftime("%Y-%m-%d")


def _read_imports_from_file(path: str) -> list[str]:
    try:
        text = Path(path).read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = Path(path).read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return []
    imports: list[str] = []
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped.startswith("import "):
            continue
        for part in stripped.split()[1:]:
            if part.startswith("--"):
                break
            imports.append(part)
    return imports


def _import_map(data: dict[str, Any]) -> dict[str, list[str]]:
    cache = _postprocess_cache(data)
    if "import_map" in cache:
        return cache["import_map"]
    imports: dict[str, list[str]] = {
        edge["importer"]: edge.get("imports", [])
        for edge in data.get("importEdges", [])
    }
    for p in data.get("diskFiles", []):
        mod = _path_to_module(p)
        if mod not in imports:
            imports[mod] = _read_imports_from_file(p)
    cache["import_map"] = imports
    return imports


def _taxonomy_path_labels(cfg: dict[str, Any]) -> dict[str, list[str]]:
    labels: dict[str, list[str]] = defaultdict(list)
    for chain in cfg.get("researchChains", []):
        for p in chain.get("files", []):
            labels[p.replace("\\", "/")].append(f"chain:{chain['id']}")
    for gap in cfg.get("researchGaps", []):
        for p in gap.get("files", []):
            labels[p.replace("\\", "/")].append(f"gap:{gap['id']}")
    return labels


@lru_cache(maxsize=None)
def _read_source_text(path: str) -> str:
    try:
        return Path(path).read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return Path(path).read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return ""


def _taxonomy_module_labels(cfg: dict[str, Any]) -> dict[str, list[str]]:
    labels: dict[str, list[str]] = defaultdict(list)
    for p, labs in _taxonomy_path_labels(cfg).items():
        labels[_path_to_module(p)].extend(labs)
    return labels


def _infer_owner_labels(path: str, imports: list[str], cfg: dict[str, Any]) -> list[str]:
    taxonomy_modules = _taxonomy_module_labels(cfg)
    labels: set[str] = set()
    for imp in imports:
        for label in taxonomy_modules.get(imp, []):
            labels.add(f"rule:{label}")

    text = _read_source_text(path)
    hay = "\n".join([path, " ".join(imports), text]).lower()

    def add(*xs: str) -> None:
        for x in xs:
            labels.add("rule:" + x)

    for rule in cfg.get("routeKeywordRules", []):
        keywords = [k.lower() for k in rule.get("keywords", []) if k]
        if not keywords:
            continue
        if any(token in hay for token in keywords):
            add(*rule.get("labels", []))

    return sorted(labels)


def _rounds_in_path(path: str) -> list[int]:
    return [int(r) for r in re.findall(r"R(\d{3})", Path(path).stem)]


def _debt_bucket(path: str) -> str:
    name = Path(path).stem
    low = name.lower()
    if "r169" in low:
        return "dead-r169"
    if any(
        token in low
        for token in [
            "kill",
            "inconsistent",
            "obstruction",
            "missingedges",
            "false",
            "vacuous",
            "eliminated",
            "reducedtoatoms",
        ]
    ):
        return "failed-pattern"
    if "etg" in low or "cntop" in low or "witnessidx" in low:
        return "dead-cn-etg"
    rounds = _rounds_in_path(path)
    if "route4" in low:
        if not rounds:
            return "route4-unrounded"
        r = max(rounds)
        if r >= 160:
            return "route4-r160-r168"
        if r >= 150:
            return "route4-r150-r159"
        if r >= 130:
            return "route4-r130-r149"
        return "route4-r100-r129"
    if any(token in low for token in ["narayana", "dyck", "catalan", "vandermonde"]):
        return "counting-bypass-support"
    if any(token in low for token in ["hamiltonpath", "computable", "adjacency", "ncrfin"]):
        return "computable-graph-support"
    return "core-support"


def _debt_items(data: dict[str, Any]) -> dict[str, dict[str, Any]]:
    cache = _postprocess_cache(data)
    if "debt_items" in cache:
        return cache["debt_items"]
    cfg = data["config"]
    file_classes, disk = _path_class_lookup(data)
    quarantine = {p.replace("\\", "/") for p in cfg.get("quarantine", [])}
    explicit_infra = {p.replace("\\", "/") for p in cfg.get("infraFiles", [])}
    taxonomy_labels_by_path = _taxonomy_path_labels(cfg)
    paths: set[str] = set()
    for p, cls in file_classes.items():
        if cls == "orphan":
            paths.add(p)
    for p in disk:
        p = p.replace("\\", "/")
        if "/Scripts/" in p:
            continue
        if p not in file_classes and p not in quarantine and p not in explicit_infra:
            paths.add(p)
    for p in taxonomy_labels_by_path:
        cls = _classify_path(p, file_classes, disk)
        if cls in {"orphan", "on-disk-unloaded", "missing"}:
            paths.add(p)

    imports_by_module = _import_map(data)
    items: dict[str, dict[str, Any]] = {}
    for p in paths:
        cls = _classify_path(p, file_classes, disk)
        mtime = _file_mtime(p)
        taxonomy_labels = sorted(set(taxonomy_labels_by_path.get(p, [])))
        imports = imports_by_module.get(_path_to_module(p), [])
        rule_labels = [
            label for label in _infer_owner_labels(p, imports, cfg)
            if _display_label(label) not in taxonomy_labels
        ]
        labels = sorted(set(taxonomy_labels + rule_labels))
        rounds = _rounds_in_path(p)
        items[p] = {
            "path": p,
            "class": cls,
            "mtime": mtime,
            "date": _fmt_date(mtime),
            "directlyLabelled": bool(taxonomy_labels),
            "taxonomyLabels": taxonomy_labels,
            "ruleLabels": rule_labels,
            "labels": labels,
            "bucket": _debt_bucket(p),
            "rounds": rounds,
        }
    cache["debt_items"] = items
    return items


def _debt_edges(data: dict[str, Any]) -> tuple[
    dict[str, set[str]],
    dict[str, set[str]],
    dict[str, set[str]],
]:
    cache = _postprocess_cache(data)
    if "debt_edges" in cache:
        return cache["debt_edges"]
    cfg = data["config"]
    root = cfg["rootNamespace"]
    items = _debt_items(data)
    debt_paths = set(items)
    file_classes, disk = _path_class_lookup(data)
    quarantine = {p.replace("\\", "/") for p in cfg.get("quarantine", [])}
    explicit_infra = {p.replace("\\", "/") for p in cfg.get("infraFiles", [])}
    imports = _import_map(data)
    edges: dict[str, set[str]] = defaultdict(set)
    reverse: dict[str, set[str]] = defaultdict(set)
    anchors: dict[str, set[str]] = defaultdict(set)
    for p in sorted(debt_paths):
        mod = _path_to_module(p)
        for imp in imports.get(mod, []):
            if not (imp == root or imp.startswith(root + ".")):
                continue
            ip = _module_to_path(imp)
            if ip in debt_paths:
                edges[p].add(ip)
                reverse[ip].add(p)
                continue
            if ip in file_classes:
                anchors[p].add(file_classes[ip])
            elif ip in quarantine:
                anchors[p].add("quarantine")
            elif ip in explicit_infra:
                anchors[p].add("infra")
            elif ip in disk:
                anchors[p].add("project-unloaded")
    result = (edges, reverse, anchors)
    cache["debt_edges"] = result
    return result


class _DSU:
    def __init__(self, items: list[str]) -> None:
        self.parent = {x: x for x in items}

    def find(self, x: str) -> str:
        p = self.parent[x]
        if p != x:
            self.parent[x] = self.find(p)
        return self.parent[x]

    def union(self, a: str, b: str) -> None:
        ra = self.find(a)
        rb = self.find(b)
        if ra != rb:
            self.parent[rb] = ra


def _component_sort_key(comp: dict[str, Any]) -> tuple[float, int, str]:
    return (-comp["maxMtime"], -len(comp["paths"]), comp["id"])


def _orphan_components(data: dict[str, Any]) -> list[dict[str, Any]]:
    cache = _postprocess_cache(data)
    if "orphan_components" in cache:
        return cache["orphan_components"]
    items = _debt_items(data)
    debt_paths = set(items)
    edges, _, anchors = _debt_edges(data)
    dsu = _DSU(sorted(debt_paths))

    for p, imports in edges.items():
        for ip in imports:
            dsu.union(p, ip)

    grouped: dict[str, list[str]] = defaultdict(list)
    for p in sorted(debt_paths):
        grouped[dsu.find(p)].append(p)

    comps: list[dict[str, Any]] = []
    for idx, paths in enumerate(grouped.values(), start=1):
        path_items = [items[p] for p in paths]
        class_counts: dict[str, int] = defaultdict(int)
        bucket_counts: dict[str, int] = defaultdict(int)
        anchor_counts: dict[str, int] = defaultdict(int)
        labels: set[str] = set()
        taxonomy_labels: set[str] = set()
        rule_labels: set[str] = set()
        rounds: list[int] = []
        mtimes: list[float] = []
        for item in path_items:
            class_counts[item["class"]] += 1
            bucket_counts[item["bucket"]] += 1
            labels.update(item["labels"])
            taxonomy_labels.update(item["taxonomyLabels"])
            rule_labels.update(item["ruleLabels"])
            rounds.extend(item["rounds"])
            mtimes.append(item["mtime"])
            for anchor in anchors.get(item["path"], set()):
                anchor_counts[anchor] += 1
        dominant_bucket = sorted(bucket_counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]
        min_mtime = min(mtimes) if mtimes else 0.0
        max_mtime = max(mtimes) if mtimes else 0.0
        comps.append({
            "id": f"C{idx:03d}",
            "paths": sorted(paths, key=lambda p: (-items[p]["mtime"], p)),
            "classCounts": dict(sorted(class_counts.items())),
            "bucketCounts": dict(sorted(bucket_counts.items())),
            "dominantBucket": dominant_bucket,
            "anchorCounts": dict(sorted(anchor_counts.items())),
            "labels": sorted(labels),
            "taxonomyLabels": sorted(taxonomy_labels),
            "ruleLabels": sorted(rule_labels),
            "roundMin": min(rounds) if rounds else None,
            "roundMax": max(rounds) if rounds else None,
            "minMtime": min_mtime,
            "maxMtime": max_mtime,
            "minTime": _fmt_mtime(min_mtime),
            "maxTime": _fmt_mtime(max_mtime),
            "taxonomyCount": sum(1 for item in path_items if item["directlyLabelled"]),
            "ruleCount": sum(1 for item in path_items if item["ruleLabels"]),
            "connectableCount": sum(1 for item in path_items if item["labels"]),
        })

    comps.sort(key=_component_sort_key)
    for idx, comp in enumerate(comps, start=1):
        comp["id"] = f"C{idx:03d}"
    cache["orphan_components"] = comps
    return comps


def _reachable_from(head: str, edges: dict[str, set[str]]) -> set[str]:
    seen: set[str] = set()
    stack = [head]
    while stack:
        p = stack.pop()
        if p in seen:
            continue
        seen.add(p)
        stack.extend(sorted(edges.get(p, set()) - seen))
    return seen


def _orphan_branch_heads(data: dict[str, Any]) -> list[dict[str, Any]]:
    cache = _postprocess_cache(data)
    if "orphan_branch_heads" in cache:
        return cache["orphan_branch_heads"]
    items = _debt_items(data)
    edges, reverse, anchors = _debt_edges(data)
    heads = [p for p in items if not reverse.get(p)]
    result: list[dict[str, Any]] = []
    for p in heads:
        closure = _reachable_from(p, edges)
        class_counts: dict[str, int] = defaultdict(int)
        bucket_counts: dict[str, int] = defaultdict(int)
        anchor_counts: dict[str, int] = defaultdict(int)
        labels: set[str] = set()
        taxonomy_labels: set[str] = set()
        rule_labels: set[str] = set()
        taxonomy_file_count = 0
        rule_file_count = 0
        mtimes: list[float] = []
        for q in closure:
            item = items[q]
            class_counts[item["class"]] += 1
            bucket_counts[item["bucket"]] += 1
            labels.update(item["labels"])
            taxonomy_labels.update(item["taxonomyLabels"])
            rule_labels.update(item["ruleLabels"])
            if item["taxonomyLabels"]:
                taxonomy_file_count += 1
            if item["ruleLabels"]:
                rule_file_count += 1
            mtimes.append(item["mtime"])
            for anchor in anchors.get(q, set()):
                anchor_counts[anchor] += 1
        dominant_bucket = sorted(bucket_counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]
        result.append({
            "path": p,
            "closure": closure,
            "closureSize": len(closure),
            "classCounts": dict(sorted(class_counts.items())),
            "bucketCounts": dict(sorted(bucket_counts.items())),
            "dominantBucket": dominant_bucket,
            "anchorCounts": dict(sorted(anchor_counts.items())),
            "labels": sorted(labels),
            "taxonomyLabels": sorted(taxonomy_labels),
            "ruleLabels": sorted(rule_labels),
            "taxonomyFileCount": taxonomy_file_count,
            "ruleFileCount": rule_file_count,
            "mtime": items[p]["mtime"],
            "time": _fmt_mtime(items[p]["mtime"]),
            "minTime": _fmt_mtime(min(mtimes) if mtimes else 0.0),
            "maxTime": _fmt_mtime(max(mtimes) if mtimes else 0.0),
        })
    result.sort(key=lambda h: (-h["mtime"], -h["closureSize"], h["path"]))
    cache["orphan_branch_heads"] = result
    return result


def _fmt_counts(counts: dict[str, int]) -> str:
    if not counts:
        return "-"
    return ", ".join(f"{k}: {v}" for k, v in sorted(counts.items()))


def _component_mermaid_class(comp: dict[str, Any]) -> str:
    bucket = comp["dominantBucket"]
    if bucket.startswith("dead") or bucket == "failed-pattern":
        return "debtDead"
    if comp["taxonomyCount"] > 0:
        return "debtTaxonomy"
    if comp.get("ruleCount", 0) > 0:
        return "debtRule"
    return "debt"


def _owner_key(label: str, *, allow_rule: bool = True) -> tuple[str, str] | None:
    if label.startswith("rule:") and not allow_rule:
        return None
    body = _display_label(label)
    if body.startswith("chain:"):
        return ("chain", body[len("chain:"):])
    if body.startswith("gap:"):
        return ("gap", body[len("gap:"):])
    return None


def _fmt_labels(labels: list[str], *, limit: int = 6) -> str:
    if not labels:
        return "-"
    shown = labels[:limit]
    suffix = f", +{len(labels) - limit} more" if len(labels) > limit else ""
    return ", ".join(f"`{x}`" for x in shown) + suffix


def _display_label(label: str) -> str:
    return label.removeprefix("rule:")


def _fmt_route_labels(labels: list[str], *, limit: int = 6) -> str:
    display = sorted({_display_label(x) for x in labels})
    return _fmt_labels(display, limit=limit)


def _route_state_from_labels(
    labels: list[str],
    bucket: str = "",
    cfg: dict[str, Any] | None = None,
) -> str:
    body = " ".join(_display_label(x).lower() for x in labels)
    bucket_text = bucket.lower()
    dead_words = ["dead", "false", "vacuous", "kill", "failed", "quarantine", "refuted", "bypass-only", "legacy"]
    active_words = ["active", "open", "exploring", "conditional", "reduced"]
    closed_words = ["closed", "support", "native"]
    dead = any(token in body for token in dead_words) or bucket_text.startswith("dead") or bucket_text == "failed-pattern"
    active = any(token in body for token in active_words)
    main = "main" in body or "primary" in body
    closed = any(token in body for token in closed_words)

    if cfg is not None:
        chains = {c["id"]: c for c in cfg.get("researchChains", [])}
        gaps = {g["id"]: g for g in cfg.get("researchGaps", [])}
        primary_gap = cfg.get("primaryGapId")
        for label in labels:
            shown = _display_label(label)
            if shown.startswith("chain:"):
                chain = chains.get(shown[len("chain:"):])
                if not chain:
                    continue
                kind = (chain.get("kind") or "").lower()
                status = (chain.get("status") or "").lower()
                text = f"{kind} {status}"
                dead = dead or any(t in text for t in dead_words)
                active = active or kind == "active" or any(t in text for t in active_words)
                main = main or kind == "main"
                closed = closed or kind == "support" or any(t in text for t in closed_words)
            elif shown.startswith("gap:"):
                gid = shown[len("gap:"):]
                gap = gaps.get(gid)
                if not gap:
                    continue
                status = (gap.get("status") or "").lower()
                dead = dead or any(t in status for t in dead_words)
                active = active or any(t in status for t in active_words)
                main = main or gid == primary_gap or "main" in gid.lower() or "legacy" in status
                closed = closed or any(t in status for t in closed_words)
    if dead and active:
        return "mixed-active/dead"
    if dead and main:
        return "mixed-main/dead"
    if dead and closed:
        return "mixed-closed/dead"
    if dead:
        return "dead/blocked"
    if active:
        return "active/exploring"
    if main:
        return "main-gap-support"
    if closed:
        return "closed/support"
    if bucket_text.startswith("route"):
        return "active/exploring"
    if labels:
        return "classified"
    return "unclassified"


def _route_state_order(state: str) -> int:
    order = {
        "main-gap-support": 0,
        "active/exploring": 1,
        "mixed-active/dead": 2,
        "mixed-main/dead": 3,
        "mixed-closed/dead": 4,
        "dead/blocked": 5,
        "closed/support": 6,
        "classified": 7,
        "unclassified": 8,
    }
    return order.get(state, 99)


def _route_label_counts(items: dict[str, dict[str, Any]], cfg: dict[str, Any]) -> list[dict[str, Any]]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for item in items.values():
        for label in sorted({_display_label(x) for x in item["labels"]}):
            grouped[label].append(item)
    rows: list[dict[str, Any]] = []
    for label, vals in grouped.items():
        bucket_counts: dict[str, int] = defaultdict(int)
        class_counts: dict[str, int] = defaultdict(int)
        mtimes: list[float] = []
        for item in vals:
            bucket_counts[item["bucket"]] += 1
            class_counts[item["class"]] += 1
            mtimes.append(item["mtime"])
        dominant_bucket = sorted(bucket_counts.items(), key=lambda kv: (-kv[1], kv[0]))[0][0]
        rows.append({
            "label": label,
            "state": _route_state_from_labels([label], dominant_bucket, cfg),
            "count": len(vals),
            "dominantBucket": dominant_bucket,
            "classCounts": dict(sorted(class_counts.items())),
            "latest": _fmt_mtime(max(mtimes) if mtimes else 0.0),
        })
    rows.sort(key=lambda r: (_route_state_order(r["state"]), -r["count"], r["label"]))
    return rows


def _is_mathematical_cut_name(name: str, cfg: dict[str, Any]) -> bool:
    builtin = set(cfg.get("kernelAxioms", [])) | set(cfg.get("trustedAxioms", []))
    if name in builtin:
        return False
    if "_native.native_decide" in name:
        return False
    return True


def _mathematical_cuts(data: dict[str, Any]) -> list[dict[str, Any]]:
    cfg = data["config"]
    result: list[dict[str, Any]] = []
    for cut in data.get("cuts", []):
        name = cut["name"]
        if not _is_mathematical_cut_name(name, cfg):
            continue
        result.append(cut)
    return sorted(result, key=lambda c: c["name"])


def _chain_class(chain: dict[str, Any]) -> str:
    text = f"{chain.get('kind', '')} {chain.get('status', '')}".lower()
    if "main" in text:
        return "main"
    if "dead" in text or "false" in text or "quarantine" in text:
        return "dead"
    if "closed" in text:
        return "closed"
    if "active" in text or "conditional" in text or "open" in text:
        return "active"
    return "support"


def _gap_class(gap: dict[str, Any]) -> str:
    text = gap.get("status", "").lower()
    if any(token in text for token in ["dead", "false", "quarantine", "refuted", "bypass-only", "legacy"]):
        return "gapDead"
    if "closed" in text:
        return "gapClosed"
    return "gapOpen"


def render_research_map(data: dict[str, Any]) -> str:
    cfg = data["config"]
    chains = cfg.get("researchChains", [])
    gaps = cfg.get("researchGaps", [])
    gap_by_id = {g["id"]: g for g in gaps}
    chain_by_id = {c["id"]: c for c in chains}
    file_classes, disk = _path_class_lookup(data)
    debt_items = _debt_items(data)
    debt_components = _orphan_components(data)
    debt_heads = _orphan_branch_heads(data)
    math_cuts = _mathematical_cuts(data)
    taxonomy_debt_files = sum(1 for item in debt_items.values() if item["taxonomyLabels"])
    rule_debt_files = sum(1 for item in debt_items.values() if item["ruleLabels"])
    connectable_debt_files = sum(1 for item in debt_items.values() if item["labels"])

    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- research map\n")
    lines.append(
        "Audit-generated route map overlaid on the automatic endpoint-closure "
        "audit.  The infra output is the single research truth source: use "
        "this report to distinguish the main chain, active exploration "
        "branches, named gaps, and dead or quarantined routes.\n"
    )
    lines.append(
        f"* research chains: **{len(chains)}**"
        f"  *  named gaps: **{len(gaps)}**"
        f"  *  endpoint count: **{len(cfg.get('endpoints', []))}**"
        f"  *  orphan debt files: **{len(debt_items)}**"
        f"  *  taxonomy-labelled debt files: **{taxonomy_debt_files}**"
        f"  *  rule-labelled debt files: **{rule_debt_files}**"
        f"  *  connectable debt files: **{connectable_debt_files}**"
        f"  *  build components: **{len(debt_components)}**"
        f"  *  branch heads: **{len(debt_heads)}**\n"
    )

    if not chains and not gaps:
        lines.append("(no route taxonomy entries configured)\n")
        return "\n".join(lines) + "\n"

    lines.append("## Decision Summary\n")
    lines.append(
        "This is the research base view.  Endpoint closure, route labels, "
        "and route states are generated by the audit infra from the Lean "
        "import graph, file content, file names, and the route taxonomy in "
        "the audit configuration."
    )
    lines.append("")
    if math_cuts:
        lines.append("Open mathematical cut(s):")
        for cut in math_cuts:
            lines.append(f"- `{cut['name']}` at `{cut['path']}`")
    else:
        lines.append("Open mathematical cut(s): none beyond kernel/native trust.")
    active = [c for c in chains if _chain_class(c) == "active"]
    dead = [c for c in chains if _chain_class(c) == "dead"]
    lines.append("")
    lines.append("Active route(s) to work on:")
    if active:
        for chain in active:
            gids = ", ".join(f"`{g}`" for g in chain.get("gapIds", [])) or "-"
            lines.append(f"- `{chain['id']}` ({chain['status']}): gaps {gids}")
    else:
        lines.append("- none")
    lines.append("")
    lines.append("Dead/quarantined route(s):")
    if dead:
        for chain in dead:
            gids = ", ".join(f"`{g}`" for g in chain.get("gapIds", [])) or "-"
            lines.append(f"- `{chain['id']}` ({chain['status']}): gaps {gids}")
    else:
        lines.append("- none")
    lines.append("")

    lines.append("## Route Graph\n")
    lines.append("```mermaid")
    lines.append("graph TD")
    lines.append("  classDef main fill:#dfd,stroke:#080,stroke-width:3px")
    lines.append("  classDef active fill:#e8f3ff,stroke:#2670b8")
    lines.append("  classDef support fill:#eef,stroke:#557")
    lines.append("  classDef closed fill:#eee,stroke:#777")
    lines.append("  classDef dead fill:#fdd,stroke:#a00,stroke-width:2px")
    lines.append("  classDef gapOpen fill:#ffd,stroke:#a80")
    lines.append("  classDef gapClosed fill:#eee,stroke:#777")
    lines.append("  classDef gapDead fill:#fdd,stroke:#a00")
    lines.append("  classDef debt fill:#fff7e6,stroke:#b87514")
    lines.append("  classDef debtTaxonomy fill:#e8f3ff,stroke:#2670b8,stroke-dasharray:3 3")
    lines.append("  classDef debtRule fill:#eefbea,stroke:#398439,stroke-dasharray:3 3")
    lines.append("  classDef debtDead fill:#fdd,stroke:#a00,stroke-dasharray:3 3")

    for chain in chains:
        sid = "chain_" + _safe_mermaid_id(chain["id"])
        label = _escape_mermaid_label(f"{chain['title']}\\n{chain['status']}")
        lines.append(f'  {sid}["{label}"]:::{_chain_class(chain)}')
    for gap in gaps:
        sid = "gap_" + _safe_mermaid_id(gap["id"])
        label = _escape_mermaid_label(f"{gap['title']}\\n{gap['status']}")
        lines.append(f'  {sid}{{{{"{label}"}}}}:::{_gap_class(gap)}')
    for chain in chains:
        src = "chain_" + _safe_mermaid_id(chain["id"])
        for dep in chain.get("dependsOn", []):
            if dep in chain_by_id:
                dst = "chain_" + _safe_mermaid_id(dep)
                lines.append(f"  {src} --> {dst}")
        for gid in chain.get("gapIds", []):
            if gid in gap_by_id:
                dst = "gap_" + _safe_mermaid_id(gid)
                lines.append(f"  {src} --> {dst}")
    lines.append(
        f'  debt_all["Orphan debt by actual imports\\n{len(debt_items)} files / {len(debt_components)} components / {len(debt_heads)} heads"]:::debt'
    )
    for chain in chains:
        if chain.get("kind") == "active":
            src = "chain_" + _safe_mermaid_id(chain["id"])
            lines.append(f"  {src} --> debt_all")
    lines.append("```\n")

    lines.append("## Orphan Build Graph\n")
    lines.append(
        "This graph is derived from the actual Lean import graph restricted "
        "to off-chain debt files.  Each component is a connected build "
        "subgraph; files inside a component are listed chronologically in "
        "`orphan-debt.md`.  Owner edges are automatic route labels generated "
        "from imports, names, source text, and route taxonomy rules."
    )
    lines.append("")
    lines.append("```mermaid")
    lines.append("graph TD")
    lines.append("  classDef debt fill:#fff7e6,stroke:#b87514")
    lines.append("  classDef debtTaxonomy fill:#e8f3ff,stroke:#2670b8,stroke-dasharray:3 3")
    lines.append("  classDef debtRule fill:#eefbea,stroke:#398439,stroke-dasharray:3 3")
    lines.append("  classDef debtDead fill:#fdd,stroke:#a00,stroke-dasharray:3 3")
    lines.append("  classDef anchor fill:#eef,stroke:#557")
    lines.append("  classDef ownerChain fill:#e8f3ff,stroke:#2670b8")
    lines.append("  classDef ownerGap fill:#ffd,stroke:#a80")
    lines.append(f'  debt_root["All off-chain debt\\n{len(debt_items)} files / {len(debt_heads)} heads"]:::debt')
    for anchor in ["on-chain", "cut", "quarantine", "infra", "project-unloaded"]:
        sid = "anchor_" + _safe_mermaid_id(anchor)
        lines.append(f'  {sid}["imports {anchor}"]:::anchor')
    owner_nodes: dict[tuple[str, str], str] = {}
    for comp in debt_components:
        for label in comp["labels"]:
            key = _owner_key(label)
            if key is None:
                continue
            kind, oid = key
            if kind == "chain" and oid not in chain_by_id:
                continue
            if kind == "gap" and oid not in gap_by_id:
                continue
            owner_nodes[key] = f"owner_{kind}_{_safe_mermaid_id(oid)}"
    for (kind, oid), sid in sorted(owner_nodes.items()):
        cls = "ownerChain" if kind == "chain" else "ownerGap"
        lines.append(f'  {sid}["{kind}:{oid}"]:::{cls}')
    seen_graph_edges: set[tuple[str, str]] = set()
    for comp in debt_components:
        sid = "debt_" + comp["id"]
        label = _escape_mermaid_label(
            f"{comp['id']}\\n{len(comp['paths'])} files\\n"
            f"{comp['maxTime']}\\n{comp['dominantBucket']}"
        )
        lines.append(f'  {sid}["{label}"]:::{_component_mermaid_class(comp)}')
        lines.append(f"  debt_root --> {sid}")
        for anchor in comp["anchorCounts"]:
            if anchor in {"on-chain", "cut", "quarantine", "infra", "project-unloaded"}:
                lines.append(f"  {sid} --> anchor_{_safe_mermaid_id(anchor)}")
        for label in comp["labels"]:
            key = _owner_key(label)
            if key in owner_nodes:
                edge = (owner_nodes[key], sid)
                if edge not in seen_graph_edges:
                    lines.append(f"  {owner_nodes[key]} --> {sid}")
                    seen_graph_edges.add(edge)
    lines.append("```\n")

    lines.append("## Chains\n")
    lines.append("| id | kind | status | gaps | file classes |")
    lines.append("|----|------|--------|------|--------------|")
    for chain in chains:
        gap_text = ", ".join(f"`{g}`" for g in chain.get("gapIds", [])) or "-"
        class_text = _format_path_class_counts(chain.get("files", []), data)
        lines.append(
            f"| `{chain['id']}` | {chain['kind']} | {chain['status']} | "
            f"{gap_text} | {class_text} |"
        )

    lines.append("\n## Gaps\n")
    lines.append("| id | status | title | files |")
    lines.append("|----|--------|-------|-------|")
    for gap in gaps:
        class_text = _format_path_class_counts(gap.get("files", []), data)
        lines.append(f"| `{gap['id']}` | {gap['status']} | {gap['title']} | {class_text} |")

    taxonomy_offchain: list[tuple[str, str, str]] = []
    unlabelled_debt: list[str] = []
    for p, item in sorted(debt_items.items()):
        if item["directlyLabelled"]:
            labels = _fmt_route_labels(item["labels"], limit=12)
            taxonomy_offchain.append((p, labels, item["class"]))
        else:
            unlabelled_debt.append(p)

    lines.append("\n## Off-Chain Split\n")
    lines.append(
        "Route-labelled off-chain files are assigned by the audit infra but "
        "are not consumed by an endpoint closure yet.  Unlabelled debt is "
        "grouped by actual Lean import connectivity in `orphan-debt.md`."
    )
    lines.append("")
    lines.append(f"* taxonomy-entry off-chain files: **{len(taxonomy_offchain)}**")
    lines.append(f"* taxonomy-labelled debt files: **{taxonomy_debt_files}**")
    lines.append(f"* rule-labelled debt files: **{rule_debt_files}**")
    lines.append(f"* unconnected debt files: **{len(debt_items) - connectable_debt_files}**")
    lines.append(f"* unlabelled off-chain debt files: **{len(unlabelled_debt)}**")
    lines.append(f"* build-connected debt components: **{len(debt_components)}**")
    if taxonomy_offchain:
        lines.append("\n| path | audit route labels | audit class |")
        lines.append("|------|----------------|-------------|")
        for p, labels, cls in taxonomy_offchain:
            lines.append(f"| `{p}` | {labels} | {cls} |")

    lines.append("\n## Chain Details\n")
    for chain in chains:
        lines.append(f"### `{chain['id']}` -- {chain['title']}\n")
        lines.append(chain.get("summary", "").strip() or "(no summary)")
        if chain.get("entryDecls"):
            lines.append("\nEntry declarations:")
            for d in chain["entryDecls"]:
                lines.append(f"- `{d}`")
        if chain.get("dependsOn"):
            deps = ", ".join(f"`{d}`" for d in chain["dependsOn"])
            lines.append(f"\nDepends on: {deps}")
        if chain.get("gapIds"):
            gids = ", ".join(f"`{g}`" for g in chain["gapIds"])
            lines.append(f"\nGaps: {gids}")
        if chain.get("files"):
            lines.append("\nFiles:")
            for p in chain["files"]:
                cls = _classify_path(p, file_classes, disk)
                lines.append(f"- `{p}` -- {cls}")
        lines.append("")

    lines.append("## Gap Details\n")
    for gap in gaps:
        lines.append(f"### `{gap['id']}` -- {gap['title']}\n")
        lines.append(gap.get("summary", "").strip() or "(no summary)")
        if gap.get("decls"):
            lines.append("\nDeclarations:")
            for d in gap["decls"]:
                lines.append(f"- `{d}`")
        if gap.get("files"):
            lines.append("\nFiles:")
            for p in gap["files"]:
                cls = _classify_path(p, file_classes, disk)
                lines.append(f"- `{p}` -- {cls}")
        lines.append("")

    return "\n".join(lines) + "\n"


def render_route_index(data: dict[str, Any]) -> str:
    cfg = data["config"]
    chains = cfg.get("researchChains", [])
    gaps = cfg.get("researchGaps", [])
    file_classes, disk = _path_class_lookup(data)
    debt_items = _debt_items(data)
    comps = _orphan_components(data)
    heads = _orphan_branch_heads(data)
    math_cuts = _mathematical_cuts(data)
    route_rows = _route_label_counts(debt_items, cfg)
    route_row_by_label = {row["label"]: row for row in route_rows}
    gap_by_id = {g["id"]: g for g in gaps}
    chain_by_id = {c["id"]: c for c in chains}

    gap_to_chains: dict[str, list[str]] = defaultdict(list)
    for chain in chains:
        for gid in chain.get("gapIds", []):
            gap_to_chains[gid].append(chain["id"])
    state_counts: dict[str, int] = defaultdict(int)
    state_closure: dict[str, int] = defaultdict(int)
    for head in heads:
        state = _route_state_from_labels(head["labels"], head["dominantBucket"], cfg)
        state_counts[state] += 1
        state_closure[state] += head["closureSize"]

    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- route index\n")
    lines.append(
        "Decision-first index for the next research round.  Treat this as "
        "the base map: the proof spine is the endpoint closure, route "
        "labels are generated automatically from the Lean import graph, "
        "file names, source text, and audit route taxonomy.  The goal is to "
        "show which proof routes are active, blocked, closed, or orphaned "
        "before a new agent starts editing."
    )
    lines.append("")
    lines.append(
        f"* endpoints: **{len(cfg.get('endpoints', []))}**"
        f"  *  open mathematical cuts: **{len(math_cuts)}**"
        f"  *  route taxonomy chains: **{len(chains)}**"
        f"  *  route taxonomy gaps: **{len(gaps)}**"
        f"  *  debt components: **{len(comps)}**"
        f"  *  branch heads: **{len(heads)}**"
    )

    lines.append("\n## Audit Truth Contract\n")
    lines.append(
        "This file is generated.  Future agents should update Lean files, "
        "audit rules, or the route taxonomy config, then regenerate the "
        "reports.  Do not maintain a separate hand-written route ledger."
    )

    configured_primary_gap = cfg.get("primaryGapId")
    primary_gap = gap_by_id.get(configured_primary_gap) if configured_primary_gap else None
    if primary_gap is None:
        primary_gap = next((
            g for g in gaps
            if "open" in g.get("status", "").lower()
            and "dead" not in g.get("status", "").lower()
            and "legacy" not in g.get("status", "").lower()
        ), None)
    active_main_routes = []
    if primary_gap:
        configured_replacement = cfg.get("replacementRouteId")
        if configured_replacement and configured_replacement in chain_by_id:
            active_main_routes = [configured_replacement]
        else:
            active_main_routes = [
                cid for cid in gap_to_chains.get(primary_gap["id"], [])
                if chain_by_id.get(cid, {}).get("kind") == "active"
            ]

    lines.append("\n## Next Agent Brief\n")
    lines.append("Research attack target:")
    if primary_gap:
        owners = _fmt_labels([f"chain:{c}" for c in sorted(gap_to_chains.get(primary_gap["id"], []))])
        lines.append(
            f"- Primary proof gap: `gap:{primary_gap['id']}` -- "
            f"{primary_gap.get('summary', '').strip() or primary_gap.get('title', '')}"
        )
        lines.append(f"- Route owner(s): {owners}")
    if active_main_routes:
        lines.append(
            "- Current constructive attack route: "
            + _fmt_labels([f"chain:{c}" for c in sorted(active_main_routes)])
            + ".  Use it to replace the primary cut; do not route around the "
            "configured gap ledger."
        )
        for cid in active_main_routes:
            chain = chain_by_id.get(cid, {})
            if chain.get("successCriterion"):
                lines.append(f"- Success criterion: {chain['successCriterion']}")
    if math_cuts:
        lines.append(
            "\nKernel cut ledger.  These are audit-visible unresolved constants on "
            "the endpoint closure; use the configured route/gap above to decide "
            "the next research attack, not this flat list alone:"
        )
        for cut in math_cuts:
            lines.append(f"- `{cut['name']}` in `{cut['path']}`")
    else:
        lines.append("\nKernel cut ledger: none beyond kernel/native trust.")
    if state_counts.get("active/exploring", 0) == 0 and state_counts.get("mixed-active/dead", 0) > 0:
        lines.append(
            "- Branch-head warning: there are **0** pure `active/exploring` heads and "
            f"**{state_counts['mixed-active/dead']}** `mixed-active/dead` heads.  "
            "Treat mixed heads as triage targets: split away dead-route imports/labels "
            "before promoting any theorem into the live chain."
        )

    live_gap_ids: list[str] = []
    for chain in chains:
        if chain.get("kind") != "active":
            continue
        for gid in chain.get("gapIds", []):
            gap = gap_by_id.get(gid)
            if gap is None:
                continue
            status = gap.get("status", "").lower()
            if gid == (primary_gap or {}).get("id") or "dead" in status or "legacy" in status:
                continue
            if gid not in live_gap_ids:
                live_gap_ids.append(gid)
    configured_priority = [gid for gid in cfg.get("gapPriority", []) if gid in live_gap_ids]
    remaining_priority = sorted(
        [gid for gid in live_gap_ids if gid not in configured_priority],
        key=lambda gid: (
            route_row_by_label.get(f"gap:{gid}", {}).get("count", 10**9),
            gid,
        ),
    )
    live_gap_ids = configured_priority + remaining_priority
    if live_gap_ids:
        lines.append("\nLive subgaps exposed by the current route:")
        lines.append("| priority | gap | labelled debt files | declarations | taxonomy files |")
        lines.append("|---------:|-----|--------------------:|--------------|----------------|")
        for idx, gid in enumerate(live_gap_ids, start=1):
            gap = gap_by_id[gid]
            row = route_row_by_label.get(f"gap:{gid}", {})
            lines.append(
                f"| {idx} | `gap:{gid}` ({gap.get('status', '-')}) | "
                f"{row.get('count', 0)} | {_fmt_labels(gap.get('decls', []), limit=3)} | "
                f"{_fmt_labels(gap.get('files', []), limit=3)} |"
            )
        lines.append(
            "\nPriority uses the project-configured `gapPriority` order first; "
            "remaining active subgaps are sorted mechanically by labelled debt "
            "file count.  It is a triage order, not a mathematical proof of "
            "easiest-first."
        )

    lines.append("\n## New Agent Attack Cards\n")
    if math_cuts and primary_gap and active_main_routes:
        mixed_heads = state_counts.get("mixed-active/dead", 0)
        dead_heads = state_counts.get("dead/blocked", 0)
        if mixed_heads > 0:
            lines.append(
                "Readiness verdict: **actionable with caveat**.  The main cut and "
                "replacement route are clear, but the active branch-head queue has "
                f"**{mixed_heads}** mixed active/dead head(s).  Start from the gap "
                "cards and taxonomy files below; use the mixed heads only for "
                "import triage until their labels are split."
            )
        elif dead_heads > 0:
            lines.append(
                "Readiness verdict: **actionable**.  The main cut and replacement "
                "route are clear, and dead/blocked branch heads are separated from "
                "the live attack queue.  Start from the priority gap cards below."
            )
        else:
            lines.append(
                "Readiness verdict: **actionable**.  The main cut and replacement "
                "route are clear.  Start from the priority gap cards below."
            )
    elif math_cuts:
        lines.append(
            "Readiness verdict: **incomplete**.  There are open mathematical cuts, "
            "but no active replacement route is attached by the route taxonomy."
        )
    else:
        lines.append(
            "Readiness verdict: **no open mathematical cut detected** beyond "
            "kernel/native trust."
        )

    attack_plan_lines: list[str] = []
    for cid in active_main_routes:
        attack_plan_lines.extend(chain_by_id.get(cid, {}).get("attackPlan", []))
    if attack_plan_lines:
        lines.append("\nCurrent replacement plan:")
        for item in attack_plan_lines:
            lines.append(f"- {item}")
        for cid in active_main_routes:
            success = chain_by_id.get(cid, {}).get("successCriterion", "")
            if success:
                lines.append(f"- Final success criterion: {success}")

    if live_gap_ids:
        findings_by_path: dict[str, list[dict[str, Any]]] = defaultdict(list)
        for f in data.get("findings", []):
            loc = (f.get("loc") or "").replace("\\", "/")
            if loc:
                findings_by_path[loc].append(f)

        for idx, gid in enumerate(live_gap_ids, start=1):
            gap = gap_by_id[gid]
            owner_ids = sorted(gap_to_chains.get(gid, []))
            owner_labels = _fmt_labels([f"chain:{c}" for c in owner_ids])
            gap_files = [p.replace("\\", "/") for p in gap.get("files", [])]
            suspicious = [
                f for p in gap_files for f in findings_by_path.get(p, [])
                if f.get("rule") == "W5.suspicious-prop-def"
            ]
            prop_defs = [
                f for p in gap_files for f in findings_by_path.get(p, [])
                if f.get("rule") == "W5.prop-def"
            ]
            labelled_heads = [
                h for h in heads
                if f"gap:{gid}" in h["labels"]
            ]
            labelled_heads.sort(
                key=lambda h: (
                    _route_state_order(_route_state_from_labels(h["labels"], h["dominantBucket"], cfg)),
                    -h["mtime"],
                    -h["closureSize"],
                    h["path"],
                )
            )

            lines.append(f"\n### Priority {idx}: `gap:{gid}` -- {gap.get('title', '')}\n")
            lines.append(gap.get("summary", "").strip() or "(no summary)")
            lines.append("")
            lines.append(f"- status: `{gap.get('status', '-')}`")
            lines.append(f"- owner route(s): {owner_labels}")
            lines.append(f"- prove/provide declaration(s): {_fmt_labels(gap.get('decls', []), limit=6)}")
            lines.append(
                "- start files: "
                + _fmt_labels(
                    [f"{p} [{_classify_path(p, file_classes, disk)}]" for p in gap_files],
                    limit=6,
                )
            )
            gap_file_classes = [_classify_path(p, file_classes, disk) for p in gap_files]
            if any(c in ("orphan", "on-disk-unloaded") for c in gap_file_classes):
                lines.append(
                    "- classification note: `orphan` / `on-disk-unloaded` here means the file is not "
                    "endpoint-reached yet.  For an active replacement route this is expected until a "
                    "new theorem consumes the branch and removes the main cut; it is not by itself a "
                    "quarantine signal."
                )
            if suspicious:
                lines.append(
                    f"- trick-audit priority: **{len(suspicious)} suspicious Prop definition(s)** "
                    "in the listed start files; inspect `trick-audit.md` before promotion."
                )
            elif prop_defs:
                lines.append(
                    f"- trick-audit priority: {len(prop_defs)} Prop definition surface(s) "
                    "in the listed start files; verify they are definitional infrastructure."
                )
            else:
                lines.append("- trick-audit priority: no W5 Prop-definition finding in the listed start files.")
            if labelled_heads:
                lines.append("- import-graph heads touching this gap:")
                for head in labelled_heads[:5]:
                    state = _route_state_from_labels(head["labels"], head["dominantBucket"], cfg)
                    lines.append(
                        f"  - `{head['path']}` -- {state}, closure {head['closureSize']}, "
                        f"{head['dominantBucket']}"
                    )
                if len(labelled_heads) > 5:
                    lines.append(f"  - ... +{len(labelled_heads) - 5} more")
            else:
                lines.append("- import-graph heads touching this gap: none labelled yet; start from taxonomy files.")

    dead_gaps = [g for g in gaps if _gap_class(g) == "gapDead"]
    if dead_gaps:
        lines.append("\nDo-not-attack inactive routes:")
        lines.append("| gap | reason | evidence files |")
        lines.append("|-----|--------|----------------|")
        for gap in dead_gaps:
            lines.append(
                f"| `gap:{gap['id']}` | {gap.get('summary', '').strip() or gap.get('status', '-')} | "
                f"{_fmt_labels(gap.get('files', []), limit=3)} |"
            )

    lines.append("\n## Main Proof Spine\n")
    lines.append("| endpoint | mathematical cuts | full axiom count |")
    lines.append("|----------|-------------------|-----------------:|")
    for entry in data.get("axiomSets", []):
        math = [a for a in entry.get("axioms", []) if _is_mathematical_cut_name(a, cfg)]
        lines.append(
            f"| `{entry['endpoint']}` | {_fmt_labels(math, limit=5)} | "
            f"{len(entry.get('axioms', []))} |"
        )
    if math_cuts:
        lines.append("\nOpen mathematical cut ledger:")
        for cut in math_cuts:
            lines.append(f"- `{cut['name']}` in `{cut['path']}`")
    else:
        lines.append("\nOpen mathematical cut ledger: none beyond kernel/native trust.")

    lines.append("\n## Route Taxonomy\n")
    lines.append("| id | role | status | depends on | gaps | files |")
    lines.append("|----|------|--------|------------|------|-------|")
    for chain in chains:
        deps = _fmt_labels([f"chain:{d}" for d in chain.get("dependsOn", [])], limit=4)
        gids = _fmt_labels([f"gap:{g}" for g in chain.get("gapIds", [])], limit=5)
        file_summary = _format_path_class_counts(chain.get("files", []), data)
        lines.append(
            f"| `chain:{chain['id']}` | {chain.get('kind', '-')} | "
            f"{chain.get('status', '-')} | {deps} | {gids} | {file_summary} |"
        )

    lines.append("\n## Gap Ledger\n")
    lines.append("| gap | status | route owners | declarations | files |")
    lines.append("|-----|--------|--------------|--------------|-------|")
    for gap in gaps:
        owners = _fmt_labels([f"chain:{c}" for c in sorted(gap_to_chains.get(gap["id"], []))])
        decls = _fmt_labels(gap.get("decls", []), limit=3)
        file_summary = _format_path_class_counts(gap.get("files", []), data)
        lines.append(
            f"| `gap:{gap['id']}` | {gap.get('status', '-')} | {owners} | "
            f"{decls} | {file_summary} |"
        )

    lines.append("\n## Automatic Route Labels\n")
    lines.append(
        "These labels are generated for debt files from imports, names, "
        "source text, and the audit route taxonomy.  They are the route map an agent "
        "should use before opening individual files."
    )
    lines.append("")
    if route_rows:
        lines.append("| route label | state | files | dominant bucket | classes | latest |")
        lines.append("|-------------|-------|------:|-----------------|---------|--------|")
        for row in route_rows:
            lines.append(
                f"| `{row['label']}` | {row['state']} | {row['count']} | "
                f"{row['dominantBucket']} | {_fmt_counts(row['classCounts'])} | {row['latest']} |"
            )
    else:
        lines.append("(no automatic route labels)")

    lines.append("\n## Branch Head State Summary\n")
    if state_counts:
        lines.append("| state | heads | closure files |")
        lines.append("|-------|------:|--------------:|")
        for state in sorted(state_counts, key=_route_state_order):
            lines.append(f"| {state} | {state_counts[state]} | {state_closure[state]} |")
    else:
        lines.append("(no branch heads)")

    lines.append("\n## Branch Work Queue\n")
    lines.append(
        "Branch heads are off-chain files that no other off-chain debt file "
        "imports.  Their closure follows real Lean imports downward.  This "
        "table is sorted by generated state, recency, and size so live, mixed, "
        "and blocked attempts are visible without opening the files first."
    )
    lines.append("")
    queue = [h for h in heads if h["labels"]]
    queue.sort(
        key=lambda h: (
            _route_state_order(_route_state_from_labels(h["labels"], h["dominantBucket"], cfg)),
            -h["mtime"],
            -h["closureSize"],
            h["path"],
        )
    )
    if not queue:
        lines.append("(no automatically labelled branch heads)")
    else:
        lines.append("| head | state | closure | bucket | automatic route labels |")
        lines.append("|------|-------|--------:|--------|------------------------|")
        for head in queue:
            state = _route_state_from_labels(head["labels"], head["dominantBucket"], cfg)
            lines.append(
                f"| `{head['path']}` | {state} | {head['closureSize']} | "
                f"{head['dominantBucket']} | {_fmt_route_labels(head['labels'], limit=8)} |"
            )

    lines.append("\n## Component Triage\n")
    lines.append(
        "Components are connected by actual Lean imports.  Large components "
        "should be split by strengthening automatic route rules, renaming "
        "ambiguous files, or quarantining failed tracks."
    )
    lines.append("")
    lines.append("| component | state | files | bucket | automatic route labels | anchors |")
    lines.append("|-----------|-------|------:|--------|------------------------|---------|")
    for comp in comps:
        state = _route_state_from_labels(comp["labels"], comp["dominantBucket"], cfg)
        lines.append(
            f"| `{comp['id']}` | {state} | {len(comp['paths'])} | {comp['dominantBucket']} | "
            f"{_fmt_route_labels(comp['labels'], limit=10)} | "
            f"{_fmt_counts(comp['anchorCounts'])} |"
        )

    unowned = [p for p, item in sorted(debt_items.items()) if not item["labels"]]
    lines.append("\n## Unowned Debt\n")
    lines.append(
        "Files with no automatic route label.  These are the safest next "
        "candidates for comment-only classification, naming cleanup, "
        "quarantine, or deletion after a compile check."
    )
    lines.append("")
    if unowned:
        for p in unowned[:80]:
            item = debt_items[p]
            lines.append(f"- `{p}` -- {item['class']}, {item['bucket']}, {item['date']}")
        if len(unowned) > 80:
            lines.append(f"- ... +{len(unowned) - 80} more")
    else:
        lines.append("(none)")

    lines.append("\n## Route Details\n")
    for chain in chains:
        lines.append(f"### `chain:{chain['id']}` -- {chain['title']}\n")
        lines.append(chain.get("summary", "").strip() or "(no summary)")
        if chain.get("entryDecls"):
            lines.append("\nEntry declarations:")
            for d in chain["entryDecls"]:
                lines.append(f"- `{d}`")
        if chain.get("files"):
            lines.append("\nTaxonomy files:")
            for p in chain["files"]:
                lines.append(f"- `{p}` -- {_classify_path(p, file_classes, disk)}")
        lines.append("")

    return "\n".join(lines) + "\n"


def render_route_map(data: dict[str, Any]) -> str:
    """Render a generated compatibility surface for older route-map readers.

    Some projects previously carried a hand-maintained `route-map.md`. Keeping
    that file stale creates a second route ledger, so the post-processor now
    overwrites it from the same serialized config/closure data as
    `route-index.md`.
    """
    text = render_route_index(data)
    first, rest = text.split("\n", 1)
    first = first.replace("route index", "route map")
    note = (
        "\n> AUTOGEN compatibility view. The source of truth is the Lean "
        "`ProjectConfig` serialized in `raw.json`; update Lean/audit config and "
        "rerun postprocess, not this file by hand.\n"
    )
    return first + note + rest


def render_orphan_debt(data: dict[str, Any]) -> str:
    cfg = data["config"]
    items = _debt_items(data)
    comps = _orphan_components(data)
    heads = _orphan_branch_heads(data)
    taxonomy_count = sum(1 for item in items.values() if item["taxonomyLabels"])
    rule_count = sum(1 for item in items.values() if item["ruleLabels"])
    connectable_count = sum(1 for item in items.values() if item["labels"])
    class_counts: dict[str, int] = defaultdict(int)
    bucket_counts: dict[str, int] = defaultdict(int)
    for item in items.values():
        class_counts[item["class"]] += 1
        bucket_counts[item["bucket"]] += 1

    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- orphan debt by build graph\n")
    lines.append(
        "This report treats the Lean import graph as the source of truth.  "
        "Debt files are `.lean` files that are loaded-but-orphan or "
        "on-disk-but-unloaded, excluding explicit quarantine and explicit "
        "infra files.  Components below are connected components of that "
        "restricted import graph; within each component, files are sorted "
        "newest first so the agent timeline is visible."
    )
    lines.append("")
    lines.append(f"* debt files: **{len(items)}**")
    lines.append(f"* build-connected components: **{len(comps)}**")
    lines.append(f"* directed branch heads: **{len(heads)}**")
    lines.append(f"* taxonomy-labelled files: **{taxonomy_count}**")
    lines.append(f"* rule-labelled files: **{rule_count}**")
    lines.append(f"* unconnected debt files: **{len(items) - connectable_count}**")
    lines.append(f"* class split: {_fmt_counts(dict(class_counts))}")
    lines.append(f"* bucket split: {_fmt_counts(dict(bucket_counts))}")

    lines.append("\n## Component Summary\n")
    lines.append("| component | files | latest | earliest | rounds | dominant bucket | classes | anchors | taxonomy | rule | connected |")
    lines.append("|-----------|-------|--------|----------|--------|-----------------|---------|---------|----------|------|-----------|")
    for comp in comps:
        rounds = "-"
        if comp["roundMin"] is not None:
            rounds = f"R{comp['roundMin']}..R{comp['roundMax']}"
        lines.append(
            f"| `{comp['id']}` | {len(comp['paths'])} | {comp['maxTime']} | "
            f"{comp['minTime']} | {rounds} | {comp['dominantBucket']} | "
            f"{_fmt_counts(comp['classCounts'])} | {_fmt_counts(comp['anchorCounts'])} | "
            f"{comp['taxonomyCount']} | {comp['ruleCount']} | {comp['connectableCount']} |"
        )

    lines.append("\n## Directed Branch Heads\n")
    lines.append(
        "A branch head is an off-chain debt file that no other off-chain "
        "debt file imports.  Its closure follows real Lean imports downward.  "
        "This is the most useful view for seeing which agent branches are "
        "actually connected by build logic."
    )
    lines.append("")
    lines.append("| head mtime | closure files | state | dominant bucket | classes | anchors | automatic route labels | head path |")
    lines.append("|------------|---------------|-------|-----------------|---------|---------|------------------------|-----------|")
    for head in heads:
        labels = _fmt_route_labels(head["labels"], limit=8)
        state = _route_state_from_labels(head["labels"], head["dominantBucket"], cfg)
        lines.append(
            f"| {head['time']} | {head['closureSize']} | {state} | {head['dominantBucket']} | "
            f"{_fmt_counts(head['classCounts'])} | {_fmt_counts(head['anchorCounts'])} | "
            f"{labels} | `{head['path']}` |"
        )

    item_by_path = items
    lines.append("\n## Component Details\n")
    for comp in comps:
        lines.append(f"### `{comp['id']}` -- {comp['dominantBucket']}\n")
        lines.append(
            f"* files: **{len(comp['paths'])}**"
            f"  *  time: **{comp['minTime']} -> {comp['maxTime']}**"
            f"  *  classes: **{_fmt_counts(comp['classCounts'])}**"
            f"  *  anchors: **{_fmt_counts(comp['anchorCounts'])}**"
        )
        if comp["labels"]:
            lines.append("* automatic route labels: " + _fmt_route_labels(comp["labels"], limit=14))
        lines.append("")
        lines.append("| mtime | class | state | bucket | automatic route labels | path |")
        lines.append("|-------|-------|-------|--------|------------------------|------|")
        for p in comp["paths"]:
            item = item_by_path[p]
            state = _route_state_from_labels(item["labels"], item["bucket"], cfg)
            lines.append(
                f"| {_fmt_mtime(item['mtime'])} | {item['class']} | {state} | "
                f"{item['bucket']} | {_fmt_route_labels(item['labels'], limit=8)} | `{p}` |"
            )
        lines.append("")

    return "\n".join(lines) + "\n"


def render_findings(data: dict[str, Any]) -> str:
    cfg = data["config"]
    findings = data["findings"]
    by_rule = defaultdict(list)
    for f in findings:
        by_rule[f["rule"]].append(f)
    lines: list[str] = []
    lines.append(f"# {cfg['projectName']} -- all audit findings\n")
    fail_n = sum(1 for f in findings if f["severity"] == "FAIL")
    warn_n = sum(1 for f in findings if f["severity"] == "WARN")
    lines.append(
        f"\n* total: **{len(findings)}**"
        f"  *  FAIL: **{fail_n}**"
        f"  *  WARN: **{warn_n}**\n"
    )
    for rule in sorted(by_rule):
        items = by_rule[rule]
        sev = items[0]["severity"]
        lines.append(f"\n## {rule} ({sev}) -- {len(items)}\n")
        for f in items:
            loc = f.get("loc") or ""
            loc_str = f"  ({loc})" if loc else ""
            lines.append(f"- {f['message']}{loc_str}")
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="ChainAudit post-processor")
    parser.add_argument("--raw", required=True, help="Path to raw.json")
    parser.add_argument("--out", required=True, help="Output directory for *.md")
    args = parser.parse_args()

    raw_path = Path(args.raw)
    out_dir = Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)

    if not raw_path.exists():
        print(f"ERROR: {raw_path} does not exist; run `lake exe *-status` first", file=sys.stderr)
        return 2

    data = load_raw(raw_path)
    baseline = out_dir / "axioms.baseline.md"

    write_md(out_dir, "onchain.md", render_onchain(data))
    write_md(out_dir, "offchain.md", render_offchain(data))
    write_md(out_dir, "orphans.md", render_orphans(data))
    write_md(out_dir, "cuts.md", render_cuts(data))
    write_md(out_dir, "axioms.md", render_axioms(data, baseline))
    write_md(out_dir, "trick-audit.md", render_trick_audit(data))
    write_md(out_dir, "underscore-audit.md", render_underscore(data))
    write_md(out_dir, "import-audit.md", render_import_audit(data))
    write_md(out_dir, "graph.md", render_graph(data))
    write_md(out_dir, "research-map.md", render_research_map(data))
    write_md(out_dir, "route-index.md", render_route_index(data))
    write_md(out_dir, "route-map.md", render_route_map(data))
    write_md(out_dir, "orphan-debt.md", render_orphan_debt(data))
    write_md(out_dir, "findings.md", render_findings(data))

    cfg = data["config"]
    summary = data["summary"]
    print(f"[{cfg['projectName']}] wrote 14 markdown reports to {out_dir}/")
    print(f"  on-chain: {summary['onChainCount']}  cut: {summary['cutCount']}"
          f"  quarantine: {summary['quarantineCount']}  infra: {summary['infraCount']}"
          f"  orphan: {summary['orphanCount']}")
    print(f"  findings: {len(data['findings'])}"
          f"  (FAIL: {sum(1 for f in data['findings'] if f['severity'] == 'FAIL')}"
          f", WARN: {sum(1 for f in data['findings'] if f['severity'] == 'WARN')})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
