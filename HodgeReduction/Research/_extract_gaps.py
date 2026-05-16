"""Extract gapOpen entries from Strict.lean to JSON for triage."""
import re, json

STRICT = 'e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Strict.lean'

with open(STRICT, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
entries = []
i = 0
while i < len(lines):
    line = lines[i]
    m = re.match(r'def (gap_\S+)\s*:\s*StrictGapEntry\s*:=', line)
    if m:
        name = m.group(1)
        start_line = i + 1
        block = []
        i += 1
        depth = 0
        if i < len(lines) and '{' in lines[i]:
            block.append(lines[i])
            depth = lines[i].count('{') - lines[i].count('}')
            i += 1
        while i < len(lines) and depth > 0:
            block.append(lines[i])
            depth += lines[i].count('{') - lines[i].count('}')
            i += 1
        text = '\n'.join(block)
        entries.append({'name': name, 'line': start_line, 'text': text})
    else:
        i += 1

def field_str(text, fname):
    """Match `fname := "..."` allowing escaped quotes and newlines."""
    # Build pattern without f-string to avoid escape issues
    pat = fname + r'\s*:=\s*"((?:[^"\\]|\\.)*)"'
    m = re.search(pat, text, re.DOTALL)
    if m:
        return m.group(1).replace('\n', ' ')
    return ''

def field_ident(text, fname):
    """Match `fname := .someIdent` or `fname := someExpr` until next field."""
    pat = fname + r'\s*:=\s*([^\n]+)'
    m = re.search(pat, text)
    if m:
        return m.group(1).strip().rstrip(',')
    return ''

open_data = []
for e in entries:
    if 'status := .gapOpen' in e['text']:
        open_data.append({
            'name': e['name'],
            'line': e['line'],
            'cat': field_ident(e['text'], 'inputCategory'),
            'sub': field_ident(e['text'], 'cat3SubType'),
            'paperSource': field_str(e['text'], 'paperSource'),
            'scope': field_str(e['text'], 'scope'),
        })

with open('e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Research/_gaps.json', 'w', encoding='utf-8') as f:
    json.dump(open_data, f, ensure_ascii=False, indent=2)

print(f'Wrote {len(open_data)} gapOpen entries')
for d in open_data[:10]:
    print('NAME:', d['name'])
    print('  cat:', d['cat'], '/', d['sub'])
    print('  paperSource:', d['paperSource'][:120])
    print('  scope:', d['scope'][:140])
    print()
