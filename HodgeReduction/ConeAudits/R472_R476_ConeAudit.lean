import HodgeReduction.HCGapL4.FrontC6_AllDegreeRankAdapter
import HodgeReduction.HCGapL4.FrontE6_DispatcherFeedsConditionalTransfer
import HodgeReduction.HCGapL4.FrontD6_Deligne1982MinimalFragment_FinalGoalCompat
import HodgeReduction.HCGapL4.R476_MultiFrontWave6Audit
import HodgeReduction.MainTheorem

open HodgeReduction
open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.FrontC6_AllDegreeRankAdapter
open HodgeReduction.HCGapL4.FrontE6_DispatcherFeedsConditionalTransfer
open HodgeReduction.HCGapL4.FrontD6_Deligne1982MinimalFragment

-- R472 FINAL_GOAL exact-name surface.
#print axioms rank_eq_hodgeSum_all_degrees
#print axioms rank1_eq_two_mul_h10_from_allDegree
#print axioms rank_odd_is_even

-- R473 FINAL_GOAL all-degree dispatcher feed surface.
#print axioms AllCodimMatchingData_from_AllDegreeAdapter
#print axioms betti_target_discharged_all_k
#print axioms R405FeedPackage.transfers_to_realCanonical

-- R474 FINAL_GOAL minimal Deligne-facing surface.
#print axioms internal_elliptic_absoluteHodge_implies_algebraic_codim1
#print axioms Deligne1982_full_statement

-- R476 wave audit and headline guard.
#print axioms MultiFrontWave6Audit_current
#print axioms hodgeConjectureReal_canonical
