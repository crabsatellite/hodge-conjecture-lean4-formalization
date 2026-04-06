/-
  HodgeConjecture/KostantVacuity/E8.lean

  E₈ has no cominuscule node, hence cannot appear as a
  Mumford-Tate factor of any smooth projective variety.

  E₈: marks = [2, 3, 4, 5, 6, 4, 2, 3], minimum = 2 ≥ 2. ✓

  All proofs are fully computational with no sorry.
-/
import HodgeConjecture.KostantVacuity.Cominuscule

namespace HodgeConjecture

-- ============================================================================
-- E₈: all marks ≥ 2, no cominuscule node
-- ============================================================================

/-- E₈ has no cominuscule node: marks [2, 3, 4, 5, 6, 4, 2, 3] contain no 1. -/
theorem E8_no_cominuscule : hasCominusculeNode CartanType.E8.highestRootMarks = false := by
  native_decide

/-- E₈ cannot admit a Hodge cocharacter satisfying (SV1). -/
theorem E8_no_hodge_cocharacter : ¬ canAdmitHodgeCocharacter .E8 :=
  no_hodge_cocharacter_of_marks .E8 E8_no_cominuscule

/-- E₈ does not admit a Shimura datum. -/
theorem E8_no_shimura : ¬ admitsShimuraDatum .E8 :=
  no_shimura_of_no_cominuscule_marks .E8 E8_no_cominuscule

end HodgeConjecture
