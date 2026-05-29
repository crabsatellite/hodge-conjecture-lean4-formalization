/-
# CY3 E7 vacuous closure support (R512, revised R525/R530).

This file provides the low-level bridge from
`hasSimpleFactor G E7_neg25` to the exact `G = E7_neg25` formulation used
by `cy3_e7_nonexistence_paper_axiom`, once the relevant CY3 structural
exclusivity facts are supplied.

No broad HC conclusion is assumed here.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults

namespace HodgeReduction

/-! ## Step 1: `hasSimpleFactor` characterization for `E7_neg25` -/

/-- For the concrete `E7_neg25` real form, `hasSimpleFactor` is exactly
the `IsE7Type` field of `G`. -/
theorem hasSimpleFactor_E7_iff_isE7Type (G : MumfordTateGroupType) :
    hasSimpleFactor G E7_neg25 ↔ G.IsE7Type := by
  unfold hasSimpleFactor E7_neg25
  simp

/-- Forward direction of `hasSimpleFactor_E7_iff_isE7Type`. -/
theorem hasSimpleFactor_E7_implies_isE7Type
    (G : MumfordTateGroupType)
    (h : hasSimpleFactor G E7_neg25) :
    G.IsE7Type :=
  (hasSimpleFactor_E7_iff_isE7Type G).mp h

/-- If the MT-derived group equals `E7_neg25`, it has the E7 simple factor. -/
theorem eq_E7_neg25_implies_hasSimpleFactor
    (G : MumfordTateGroupType)
    (h : G = E7_neg25) :
    hasSimpleFactor G E7_neg25 := by
  subst h
  exact (hasSimpleFactor_E7_iff_isE7Type E7_neg25).mpr E7_neg25_isE7Type

/-! ## Step 2: exact-type reconstruction from structural exclusivity -/

/-- If an MT group is E7-type, not torus, and not E6-type, then it is the
project's `E7_neg25` record.  The equality of Prop-valued fields uses
`propext`, which is already audit-visible in theorem cones that compare
structure records with Prop fields. -/
theorem e7_unique_under_exclusivity
    (G : MumfordTateGroupType)
    (h7 : G.IsE7Type = True)
    (h_not_torus : G.IsTorus = False)
    (h_not_e6 : G.IsE6Type = False) :
    G = E7_neg25 := by
  cases G with
  | mk isTorus isE6Type isE7Type =>
      simp [E7_neg25] at h7 h_not_torus h_not_e6 ⊢
      exact ⟨h_not_torus, h_not_e6, h7⟩

/-- The three exclusivity fields of `E7_neg25` by construction. -/
theorem E7_neg25_exclusivity :
    E7_neg25.IsTorus = False ∧
    E7_neg25.IsE6Type = False ∧
    E7_neg25.IsE7Type = True := by
  exact ⟨rfl, rfl, rfl⟩

/-- Combined exact reconstruction plus the recovered simple-factor fact. -/
theorem isE7_with_exclusivity_implies_eq_E7_neg25
    (G : MumfordTateGroupType)
    (h7 : G.IsE7Type = True)
    (h_not_torus : G.IsTorus = False)
    (h_not_e6 : G.IsE6Type = False) :
    G = E7_neg25 ∧ hasSimpleFactor G E7_neg25 := by
  have hEq : G = E7_neg25 :=
    e7_unique_under_exclusivity G h7 h_not_torus h_not_e6
  exact ⟨hEq, eq_E7_neg25_implies_hasSimpleFactor G hEq⟩

/-- R530 support count: 6 kernel-pure theorems, 0 new axioms in this file. -/
def R525_theorem_count : Nat := 6
def R525_new_axiom_count : Nat := 0

end HodgeReduction
