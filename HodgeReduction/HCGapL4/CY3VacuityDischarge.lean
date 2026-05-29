/-
# CY3+E7 Vacuity Discharge (R514, refined R530).

This file reduces `hc_real_cy3_reducible` from a broad HC axiom to a
theorem conditional on a decomposed CY3/E7 bridge.

R530 removes the overstrong `cy3_inherits_e7_factor_exact` cut.  The
discharge now routes through the R525 bridge in `CY3E7Bridge`:

* `cy3_inherits_e7_factor`: a CY3 reduction inherits an E7 simple factor.
* `cy3_mtd_isSemisimple`: a CY3 weight-3 MT-derived group is not a torus.
* `e7_excludes_e6`: E7 type excludes E6 type.

Those three narrower premises imply the exact E7 type required by
`cy3_e7_nonexistence_paper_axiom`.  No HC conclusion is assumed in the
bridge layer.

NO sorry, NO `True.intro`, NO placeholder closure.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses
import HodgeReduction.HCGapL4.CY3E7Bridge

namespace HodgeReduction

/-! ## Step 1: Vacuous discharge via the decomposed R525 bridge -/

/-- The vacuous discharge: E7 + CY3 gives `False` via the R525 bridge
and the CY3/E7 nonexistence paper axiom. -/
theorem cy3_e7_vacuity_via_bridge
    (X : SmoothProjectiveVariety Complex)
    (hE7 : hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25)
    (hCY3 : ExistsCY3Reduction X) :
    False :=
  cy3_e7_vacuous_discharge X hE7 hCY3

/-! ## Step 2: Replace `hc_real_cy3_reducible` -/

/-- DERIVED THEOREM replacing the former broad `hc_real_cy3_reducible`
axiom.  The implication E7 + CY3 => HC-real is vacuous because the
antecedent contradicts CY3/E7 nonexistence.

Dependency chain:
`hc_real_cy3_reducible_via_vacuity`
  <- `cy3_e7_vacuity_via_bridge`
  <- `cy3_inherits_e7_factor`, `cy3_mtd_isSemisimple`, `e7_excludes_e6`
  <- `cy3_e7_nonexistence_paper_axiom`

KERNEL-PURE. -/
theorem hc_real_cy3_reducible_via_vacuity :
    forall (X : SmoothProjectiveVariety Complex),
    hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ->
    ExistsCY3Reduction X ->
    HodgeConjectureReal X :=
  fun X hE7 hCY3 => False.elim (cy3_e7_vacuity_via_bridge X hE7 hCY3)

/-- R530 CY3 vacuity discharge: two kernel-pure endpoint theorems, with
three narrower bridge cuts replacing the former exact-equality cut. -/
def R514_cy3_theorem_count : Nat := 2
def R514_cy3_bridge_axiom_count : Nat := 3

end HodgeReduction
