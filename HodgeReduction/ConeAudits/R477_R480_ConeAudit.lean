import HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance
import HodgeReduction.HCGapL4.FrontE7_ConditionalTransferFromConcrete
import HodgeReduction.HCGapL4.FrontD7_Deligne1982ExpandedFragment
import HodgeReduction.HCGapL4.R480_MultiFrontWave7Audit
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance
open HodgeReduction.HCGapL4.FrontE7_ConditionalTransferFromConcrete
open HodgeReduction.HCGapL4.FrontD7_Deligne1982ExpandedFragment
open HodgeReduction

-- R477 SUBSTANTIVE EVII compact dual Betti theorems
#print axioms e7EVIICompactDual_betti0
#print axioms e7EVIICompactDual_betti2
#print axioms e7EVIICompactDual_betti4
#print axioms e7EVIICompactDual_betti6
#print axioms e7EVIICompactDual_betti8
#print axioms e7EVIICompactDual_hodgeSum0
#print axioms e7EVIICompactDual_hodgeSum2
#print axioms e7EVIICompactDual_hodgeSum4
#print axioms e7EVIICompactDual_hodgeSum8

-- R477 SUBSTANTIVE V_56 theorems
#print axioms v56Weight3_hodgeSum3
#print axioms v56Weight3_dimension_matches_hodgeSum
#print axioms v56Weight3HodgeDiamond_correct_proof

-- R478 SUBSTANTIVE transfer theorems
#print axioms e7EVIICompactDual_all_degree_rank_compat
#print axioms v56Weight3_dimension_matches_hodgeSum

-- R479 SUBSTANTIVE Deligne 1982 fragment theorems
#print axioms deligne1982_fragment_decomposition
#print axioms cm_abelian_hc_via_absolute_hodge
#print axioms perCodim_implies_motivicToAlgebraic

-- Wave 7 audit
#print axioms MultiFrontWave7Audit_current
#print axioms R480_Cumulative_SeventyNineSubstantive_AcrossSevenWaves

-- Headline guard (must remain unchanged)
#print axioms hodgeConjectureReal_canonical
