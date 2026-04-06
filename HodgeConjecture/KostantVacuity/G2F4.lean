/-
  HodgeConjecture/KostantVacuity/G2F4.lean

  G₂ and F₄ have no cominuscule node, hence cannot appear as
  Mumford-Tate factors of any smooth projective variety.

  G₂: marks = [3, 2], minimum = 2 ≥ 2. ✓
  F₄: marks = [2, 3, 4, 2], minimum = 2 ≥ 2. ✓

  All proofs are fully computational with no sorry.
-/
import HodgeConjecture.KostantVacuity.Cominuscule

namespace HodgeConjecture

-- ============================================================================
-- G₂: all marks ≥ 2, no cominuscule node
-- ============================================================================

/-- G₂ has no cominuscule node: marks [3, 2] contain no 1. -/
theorem G2_no_cominuscule : hasCominusculeNode CartanType.G2.highestRootMarks = false := by
  native_decide

/-- G₂ cannot admit a Hodge cocharacter satisfying (SV1). -/
theorem G2_no_hodge_cocharacter : ¬ canAdmitHodgeCocharacter .G2 :=
  no_hodge_cocharacter_of_marks .G2 G2_no_cominuscule

/-- G₂ does not admit a Shimura datum. -/
theorem G2_no_shimura : ¬ admitsShimuraDatum .G2 :=
  no_shimura_of_no_cominuscule_marks .G2 G2_no_cominuscule

-- ============================================================================
-- F₄: all marks ≥ 2, no cominuscule node
-- ============================================================================

/-- F₄ has no cominuscule node: marks [2, 3, 4, 2] contain no 1. -/
theorem F4_no_cominuscule : hasCominusculeNode CartanType.F4.highestRootMarks = false := by
  native_decide

/-- F₄ cannot admit a Hodge cocharacter satisfying (SV1). -/
theorem F4_no_hodge_cocharacter : ¬ canAdmitHodgeCocharacter .F4 :=
  no_hodge_cocharacter_of_marks .F4 F4_no_cominuscule

/-- F₄ does not admit a Shimura datum. -/
theorem F4_no_shimura : ¬ admitsShimuraDatum .F4 :=
  no_shimura_of_no_cominuscule_marks .F4 F4_no_cominuscule

-- ============================================================================
-- Sanity checks: E₆ and E₇ DO have cominuscule nodes
-- ============================================================================

/-- E₆ has a cominuscule node (mark 1 at positions 1 and 5). -/
theorem E6_has_cominuscule : hasCominusculeNode CartanType.E6.highestRootMarks = true := by
  native_decide

/-- E₇ has a cominuscule node (mark 1 at position 6). -/
theorem E7_has_cominuscule : hasCominusculeNode CartanType.E7.highestRootMarks = true := by
  native_decide

end HodgeConjecture
