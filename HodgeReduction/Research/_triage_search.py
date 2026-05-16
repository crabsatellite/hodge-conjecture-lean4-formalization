"""Search master-proof.tex for evidence of each gapOpen entry."""
import json, re, os
from pathlib import Path

ROOT = Path('e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture')
RESEARCH = ROOT / 'lean4-formalization/HodgeReduction/Research'
MASTER = ROOT / 'contributions/hodge-conjecture-master-proof.tex'
CONTRIB = ROOT / 'contributions'

with open(RESEARCH / '_gaps.json', 'r', encoding='utf-8') as f:
    gaps = json.load(f)

with open(MASTER, 'r', encoding='utf-8') as f:
    master = f.read()

# Build a quick line index for master
master_lines = master.split('\n')

# For each gap, search master + r*.tex for: name fragments + key terms from scope
search_keywords = {
    'gap_H8_compactDualEVII_is_44_bigrading': ['compact dual.*EVII', 'Hodge bigrading.*\(4', 'Bott-BBW'],
    'gap_cohomologyIso_at_deg8': ['cohomology.*iso.*deg', 'Borel.*1974', 'Borel74'],
    'gap_freudenthal_H8_auto_G_invariant': ['Freudenthal.*G-invariant', 'auto-G-invariant', 'H\^8.*G-invariant'],
    'gap_formLevel_HM_proportionality_EVII': ['form-level HM', 'Hirzebruch.*Mumford', 'form.*proportionality'],
    'gap_freudenthal_realized_by_G_invariant': ['Freudenthal.*realized', 'realization.*G-invariant'],
    'gap_ih_pullback_freudenthal': ['IH.*pullback', 'intersection homology.*pullback', 'BBD.*Saito'],
    'gap_freudenthal_extends_compatibly_deg8': ['Freudenthal.*extends', 'extends compatibly'],
    'gap_goreskyPardon_extension_to_EVII': ['Goresky-Pardon', 'G-P.*EVII', 'Goresky.*Pardon'],
    'gap_section16_2_E6_rep_compat': ['§16.2', 'E_6-rep-compat', 'V_27 vacuity'],
    'gap_evii_codim1_boundary_is_eiii': ['EVII.*boundary.*EIII', 'codim.*1.*boundary'],
    'gap_chernV27_generates_BE6': ['V_27.*BE_6', 'V_27.*generates', 'Toda.*1975'],
    'gap_chernV56_generates_BE7': ['V_56.*BE_7', 'V_56.*generates', 'Kono-Mimura'],
    'gap_borelHirzebruch_presentation': ['Borel.*Hirzebruch.*presentation', 'BE_6.*polynomial'],
    'gap_gpAbstract_group_agnostic': ['G-P.*abstract', 'group-agnostic', 'Looijenga 2017'],
    'gap_mumford_canonical_extension_framework': ['Mumford 1977', 'Mumford.*canonical extension', 'Mumford77'],
    'gap_voganZuckerman_1984_framework': ['Vogan.*Zuckerman', 'A_q\(\\\\lambda\)', 'V-Z 1984'],
    'gap_knappVogan_1995_induction': ['Knapp.*Vogan', 'Knapp-Vogan 1995'],
    'gap_franke_1998_framework': ['Franke 1998', 'Franke98', 'Eisenstein decomposition'],
    'gap_polynomial_identity_freudenthal': ['polynomial identity', 'P\(c_1', '-48 c_2'],
    'gap_cartan_1929_compact_dual_iso': ['Cartan 1929', 'Cartan.*compact dual', 'g, K.*cohomology'],
    'gap_cattani_kaplan_schmid_1986_hodge_norm_estimates': ['Cattani.*Kaplan.*Schmid', 'CKS 1986', 'CKS86'],
    'gap_J_3_O_cubic_norm_form_zorn_basis': ['J_3\(O\)', 'cubic norm form', 'Tits.*Jacobson'],
    'gap_freudenthal_triple_product_T': ['Freudenthal triple', 'triple product', 'Sato-Kimura'],
    'gap_W_E7_invariant_degrees_2_6_8_10_12_14_18': ['invariant degrees.*E_7', '2,6,8,10,12,14,18', '{2, 6, 8, 10, 12, 14, 18}'],
    'gap_H8_G_invariant_equals_cuspidal': ['G-invariant.*cuspidal', 'H\^8.*cuspidal', 'cuspidal G-invariant'],
    'gap_H8_cuspidal_G_invariant_equals_trivial_module': ['cuspidal G-invariant', 'trivial.*Cartan', 'trivial-module Cartan'],
    'gap_HC_for_freudenthal_target': ['HC.*Freudenthal', 'Hodge Conjecture.*Freudenthal'],
    'gap_higher_rank_good_metric': ['higher-rank.*good metric', 'higher rank.*automorphic'],
    'gap_canonical_Phi_lands_in_W_E7_augmentation_ideal': ['augmentation ideal', 'canonical.*Phi', 'q.*W.*E_7.*invariant'],
    'gap_V56_hodge_decomposition_under_E6_U1': ['V_{56}.*decomp', 'V_56.*decomp', '1_{+3} \\\\oplus', '1_{\\\\pm 3}'],
    'gap_twisted_Phi_L_well_defined': ['twisted.*Phi', 'twisted.*\\\\Phi', 'Phi_filt'],
    'gap_freudenthal_scalar_piece_maps_to_81_h4': ['81 h\^4', '\(ab\)\^2', 'ab.*81'],
    'gap_E6_compactness_gives_form_proportionality': ['E_6.*compact.*form', 'compactness.*proportional'],
    'gap_schmid_deligne_hodge_filtration_extends': ['Schmid.*Deligne', 'Hodge filtration.*extends', 'canonical extension'],
    'gap_eisenstein_franke_layer_decomposition': ['Eisenstein.*layer', 'Franke.*1.4', 'Franke98.*1.4'],
    'gap_E7_proper_Q_parabolic_min_BS_codim': ['Borel-Serre.*codim', 'proper.*parabolic.*E_7', 'codim.*26'],
    # Cat 2 published
    'gap_bott_borel_weil': ['Bott.*Borel.*Weil', 'BBW', 'Bott 1957'],
    'gap_borel_1974': ['Borel 1974', 'Borel74', 'stable range'],
    'gap_bbd_saito_gm': ['BBD', 'Beilinson.*Bernstein.*Deligne', 'Goresky.*MacPherson', 'Saito'],
    'gap_goresky_pardon_2002_looijenga': ['Goresky.*Pardon', 'Looijenga'],
    'gap_wolf_satake_borel_ji': ['Wolf', 'Satake', 'Borel.*Ji'],
    'gap_mumford_1977': ['Mumford 1977', 'Mumford77'],
    'gap_vogan_zuckerman': ['Vogan.*Zuckerman 1984', 'V-Z 1984'],
    'gap_knapp_vogan_1995': ['Knapp.*Vogan 1995', 'Knapp-Vogan'],
    'gap_franke_1998': ['Franke 1998', 'Franke98'],
    'gap_cartan_1929_PUBLISHED': ['Cartan 1929', 'Cartan.*compact dual'],
    'gap_salamanca_riba_1999_PUBLISHED': ['Salamanca.*Riba', 'Salamanca-Riba 1999'],
    'gap_vz_1984_holo_discrete_lowest_deg_PUBLISHED': ['Vogan.*Zuckerman', 'holo-discrete', 'holomorphic discrete'],
    'gap_cattani_kaplan_schmid_1986_PUBLISHED': ['CKS 1986', 'CKS86', 'Cattani.*Kaplan.*Schmid 1986'],
    'gap_schlafli_graph_PUBLISHED': ['Schlafli graph', 'Schl\\u00e4fli', 'srg(27,10,1,5)', 'srg\\\\(27'],
    'gap_tits_jacobson_J_3_O_PUBLISHED': ['Tits.*Jacobson', 'J_3\\\\(O\\\\)', 'cubic norm'],
    'gap_freudenthal_1954_brown_1969_sato_kimura_PUBLISHED': ['Freudenthal 1954', 'Brown 1969', 'Sato.*Kimura'],
    'gap_bourbaki_E7_W_invariants_PUBLISHED': ['Bourbaki.*E_7.*invariant', 'invariant degrees.*E_7', 'Planche.*VI'],
    'gap_borel_toda_E6_U1': ['Toda 1975', 'Borel.*Toda', 'B(E_6'],
    'gap_toda_1975_V27_BE6': ['Toda 1975', 'V_27.*BE_6'],
    'gap_kono_mimura_1976_V56_BE7': ['Kono.*Mimura', 'V_56.*BE_7'],
    'gap_chern_pairing_deg4_PUBLISHED': ['Chern.*pairing.*deg', 'c_4.*c_1.*c_3.*c_2', '2c_4'],
    'gap_borel_hirzebruch_coinvariant_augmentation': ['Borel.*Hirzebruch.*coinvariant', 'augmentation ideal.*W', 'Weyl-coinvariant'],
    'gap_V56_hodge_decomposition': ['V_56 = 1_', 'V_{56}.*= 1_', '1_{+3} \\\\oplus 27'],
    'gap_e6_compactness_form_proportionality': ['compact.*Chern-Weil.*proportional', 'compact group.*homogeneous'],
    'gap_schmid_1973_deligne_1970': ['Schmid 1973', 'Schmid73', 'Deligne 1970'],
    'gap_borel_serre_1973_franke_1998_eisenstein_layer': ['Borel-Serre 1973', 'Franke.*Eisenstein', 'Eisenstein layer'],
    'gap_e7_min_parabolic_BS_codim': ['proper.*parabolic.*codim', 'E_7.*codim.*26'],
    # cat3 derived
    'gap_canonical_Phi_vanishes_by_augmentation': ['canonical Phi vanishes', 'augmentation.*W\\\\(E_7\\\\)', 'q.*augmentation'],
    'gap_paper_twisted_Phi_L_reduction': ['twisted Phi', 'Hodge.*filtration.*projection', 'Phi_filt'],
    'gap_freudenthal_scalar_piece_computation': ['leading.*normal jet', '(ab)\\\\^2', 'q_2.*b\\\\^2'],
    'gap_paper_chern_weil_form_L_refinement': ['Chern-Weil.*L.*refinement', 'L-refined.*Chern-Weil'],
    'gap_mumford_L_block_diagonal_via_schmid': ['L-block.*diagonal', 'Mumford.*L-block', 'Mumford extension.*L-block'],
    'gap_eisenstein_vanishing_at_deg8_via_franke_layer': ['Eisenstein vanishing.*deg 8', 'Eisenstein.*deg.*8'],
    'gap_paper_hodge44': ['Hodge.*(4,4)', 'Hodge-(4,4)', '\\\\(4,4\\\\).*bigrading'],
    'gap_paper_iia': ['\\(ii.a\\)', '(ii.a)', 'paper.*ii\\\\.a'],
    'gap_paper_iia_step_A_eisenstein_to_cusp': ['Step A.*Eisenstein', 'Eisenstein.*cusp', '(ii.a).*Step A'],
    'gap_paper_iia_step_B_cuspidal_to_trivial': ['Step B.*cuspidal', 'cuspidal.*trivial.*module', '(ii.a).*Step B'],
    'gap_paper_iib': ['\\(ii.b\\)', '(ii.b)', 'paper.*ii\\\\.b'],
    'gap_paper_formHM': ['form-HM-EVII', 'form-level HM.*EVII', 'form.*HM.*proportionality'],
    'gap_paper_section16_2': ['§16.2', 'section.*16\\\\.2'],
    'gap_paper_placement_reduction': ['Freudenthal.*placement', 'placement reduction', 'j\\\\^8.*placement'],
    'gap_paper_GP_EVII': ['G-P.*EVII', 'Goresky-Pardon.*EVII'],
    'gap_paper_HC_equals_algebraicity': ['HC.*algebraicity', 'Hodge Conjecture.*algebraic'],
}

# Collect r*.tex
contributions = [p for p in CONTRIB.glob('r*.tex')]
print(f'Found {len(contributions)} round contributions')

results = {}
for g in gaps:
    name = g['name']
    keywords = search_keywords.get(name, [])
    if not keywords:
        # Fallback: use scope's distinctive phrases
        scope = g.get('scope', '')
        ps = g.get('paperSource', '')
        keywords = []
        # Strip P-numbers
        for w in re.findall(r'[A-Za-z][\w\-]+(?:\s+\d{4})?', scope[:200])[:5]:
            keywords.append(w)
    found_in = []
    # Search master
    for kw in keywords:
        try:
            if re.search(kw, master):
                found_in.append(('master', kw))
                break
        except re.error:
            if kw.replace('\\','').lower() in master.lower():
                found_in.append(('master', kw))
                break
    # Search round files
    if not found_in:
        for r in contributions:
            try:
                txt = r.read_text(encoding='utf-8', errors='ignore')
            except Exception:
                continue
            for kw in keywords:
                try:
                    if re.search(kw, txt):
                        found_in.append((r.name, kw))
                        break
                except re.error:
                    pass
            if found_in:
                break
    results[name] = {
        'keywords': keywords,
        'found_in': found_in,
        'scope': g['scope'],
        'paperSource': g['paperSource'],
        'cat': g['cat'],
        'sub': g['sub'],
    }

with open(RESEARCH / '_triage_search.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

# Print summary
print(f'Searched {len(results)} gaps')
nfound = sum(1 for r in results.values() if r['found_in'])
print(f'Found evidence in some file: {nfound}/{len(results)}')
notfound = [n for n,r in results.items() if not r['found_in']]
print(f'\nNot found ({len(notfound)}):')
for n in notfound:
    print(f'  {n}')
