"""Cross-check each gapOpen entry's NAME against concrete `def NAME : Prop :=` wiring."""
import re, json
from pathlib import Path

ROOT = Path('e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization')
STRICT = ROOT / 'HodgeReduction/Strict.lean'
RESEARCH = ROOT / 'HodgeReduction/Research'

with open(RESEARCH / '_gaps.json', 'r', encoding='utf-8') as f:
    gaps = json.load(f)

text = STRICT.read_text(encoding='utf-8')

# Find concrete defs `def NAME : Prop :=`
concrete_defs = set(re.findall(r'^def ([a-zA-Z_]\w*)\s*:\s*Prop\s*:=', text, re.MULTILINE))
print(f'Concrete defs (Prop): {len(concrete_defs)}')

# Find OPEN axioms still in axiom form
open_axioms = set(re.findall(r'^axiom ([a-zA-Z_]\w*_OPEN)\s*:', text, re.MULTILINE))
print(f'Open axioms: {len(open_axioms)}')

# Find theorems
open_theorems = set(re.findall(r'^theorem ([a-zA-Z_]\w*_OPEN)\b', text, re.MULTILINE))
print(f'OPEN-named theorems: {len(open_theorems)}')

# For each gap, parse "name := \"X\"" — the literal Lean-level NAME field of StrictGapEntry
# The convention: this name is sometimes (gapname without "gap_" prefix), sometimes with _OPEN suffix
out = []
for g in gaps:
    name = g['name']  # e.g. gap_freudenthal_H8_auto_G_invariant
    base = name[4:] if name.startswith('gap_') else name  # strip gap_ prefix
    # Get the literal name from Strict.lean (we already have line+text in JSON; re-parse)
    # Read the text snippet around g['line']
    # g['line'] is the line of `def gap_X : StrictGapEntry :=`; the
    # subsequent `{ name := "..."` should be the FIRST `name := "..."` block
    snippet_lines = text.split('\n')[g['line']:g['line']+8]
    snippet = '\n'.join(snippet_lines)
    m = re.search(r'name\s*:=\s*"([^"]+)"', snippet)
    lean_name = m.group(1) if m else base

    # Check various wiring states
    is_concrete_def = lean_name in concrete_defs
    is_open_axiom = (lean_name + '_OPEN') in open_axioms or lean_name in open_axioms
    is_open_theorem = (lean_name + '_OPEN') in open_theorems or lean_name in open_theorems
    # Also try the base name with potential _OPEN suffix
    is_concrete_def_with_open = (lean_name.replace('_OPEN','')) in concrete_defs

    out.append({
        'name': lean_name,
        'gap_name': name,
        'concrete_def': is_concrete_def or is_concrete_def_with_open,
        'open_axiom': is_open_axiom,
        'open_theorem': is_open_theorem,
        'cat': g.get('cat', ''),
        'sub': g.get('sub', ''),
        'paperSource_short': g.get('paperSource', '')[:80],
        'scope': g.get('scope', '')[:100],
    })

with open(RESEARCH / '_lean_triage.json', 'w', encoding='utf-8') as f:
    json.dump(out, f, ensure_ascii=False, indent=2)

# Quick stats
n_def = sum(1 for x in out if x['concrete_def'])
n_axiom = sum(1 for x in out if x['open_axiom'] and not x['concrete_def'])
n_theorem = sum(1 for x in out if x['open_theorem'])
print(f'\nOut of {len(out)} gapOpen entries:')
print(f'  Concrete def already exists: {n_def}')
print(f'  Open axiom (no concrete def): {n_axiom}')
print(f'  OPEN-named theorem exists: {n_theorem}')

# Print first 20 entries for sanity
print('\nFirst 20:')
for x in out[:20]:
    flags = []
    if x['concrete_def']: flags.append('DEF')
    if x['open_axiom']: flags.append('AX')
    if x['open_theorem']: flags.append('THM')
    print(f"  [{','.join(flags) or '???'}] {x['name'][:55]:55s} cat={x['cat'][:18]} sub={x['sub'][:25]}")

print('\nThose with NO def, NO axiom, NO theorem (truly bare hypothesisPredicate):')
bare = [x for x in out if not x['concrete_def'] and not x['open_axiom'] and not x['open_theorem']]
print(f'  count: {len(bare)}')
for x in bare[:30]:
    print(f"  {x['name']}  cat={x['cat']}  sub={x['sub']}")
