import HodgeReduction.HCGapL4.FrontC6_AllDegreeHodgeRankAdapter
import HodgeReduction.HCGapL4.FrontE6_FeedR405ConditionalTransfer
import HodgeReduction.HCGapL4.FrontD6_Deligne1982MinimalFragment
import HodgeReduction.HCGapL4.FrontB6_MaintenanceOnly
import HodgeReduction.HCGapL4.R476_MultiFrontWave6Audit
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.FrontC6_AllDegreeHodgeRankAdapter
open HodgeReduction.HCGapL4.FrontE6_FeedR405ConditionalTransfer
open HodgeReduction

-- R472 SUBSTANTIVE all-degree adapter theorems
#print axioms allDegree_rank_eq_hodgeSum_at_k
#print axioms allDegree_implies_rank0_eq_h00
#print axioms allDegree_implies_rank1_eq_h01_add_h10
#print axioms allDegree_implies_rank2_eq_h02_add_h11_add_h20

-- R473 SUBSTANTIVE E6 feed theorems/constructors
#print axioms profileMatching_provides_lowDegreeRankCompat
#print axioms allCodimMatching_from_profileMatching

-- R474 Front D6 activation markers
#print axioms Deligne1982Fragment_feeds_FrontD_current

-- R476 Wave 6 audit
#print axioms MultiFrontWave6Audit_current
#print axioms R476_Cumulative_FiftyOneSubstantive_AcrossSixWaves

-- Headline guard (must remain unchanged)
#print axioms hodgeConjectureReal_canonical
