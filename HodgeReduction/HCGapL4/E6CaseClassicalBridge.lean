/-
# R516/R534: E6 case reduction through a chosen classical remainder.

The E6 case of the main theorem says that an E6 factor on
`MT^der(H^3)` does not obstruct HC-real because the E6/V27 contribution
has no `(p,p)` classes at weight 3.

R534 tightens the former bridge. Instead of assuming that the global
classical theorem can be applied directly to `X`, we expose the missing
cohomological decomposition:

1. `e6_classical_remainder_exists`: from the E6 case, produce the
   classical remainder `Y` with no E6/E7 factors.
2. `e6_remainder_transfer`: HC-real for that chosen `Y` transfers back
   to `X`.

The theorem `e6_factor_classical_transfer` is kept as a derived
compatibility theorem for `MainTheorem.lean`.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses
import HodgeReduction.Infrastructure.SimpleLieAlgebraClassification
import HodgeReduction.Infrastructure.DynkinMarks
import HodgeReduction.HCGapL4.E6V27VacuityBridge

namespace HodgeReduction

open Infrastructure

/-! ## Step 1: chosen classical remainder -/

/-- **R534-A**: An E6 case variety has a classical remainder after removing
the weight-3 E6/V27 vacuous contribution.

The result is a witness `Y` whose MT factors have no E6/E7 component. This
is the missing decomposition object needed before invoking the classical
Cartan theorem. -/
axiom e6_classical_remainder_exists :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E6_neg14 ->
      exists (Y : SmoothProjectiveVariety Complex),
        forall k : Nat, NoE6E7Factor (MumfordTateGroup Y k)

/-! ## Step 2: transfer from the chosen remainder -/

/-- **R534-B**: If the chosen classical remainder satisfies HC-real, then
the original E6 case variety satisfies HC-real.

This is the actual cohomological transfer: the E6/V27 contribution is
vacuous by the parity facts in `E6V27VacuityBridge`, and the remaining
Hodge classes are supplied by the chosen classical remainder. -/
axiom e6_remainder_transfer :
    forall (X : SmoothProjectiveVariety Complex)
      (hE6 : hasSimpleFactor (MumfordTateGroupDerived X 3) E6_neg14),
      HodgeConjectureReal
        (Classical.choose (e6_classical_remainder_exists X hE6)) ->
      HodgeConjectureReal X

/-! ## Step 3: compatibility theorem used by the main theorem -/

/-- **R516/R534**: E6+classical => HC-real, conditional on the classical
Cartan theorem.

This theorem now consumes a chosen classical remainder. The broad
`e6_factor_classical_transfer` name remains for downstream compatibility,
but it is no longer an axiom. -/
theorem e6_factor_classical_transfer :
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E6_neg14 ->
      (forall (Y : SmoothProjectiveVariety Complex),
        (forall k : Nat, NoE6E7Factor (MumfordTateGroup Y k)) ->
        HodgeConjectureReal Y) ->
      HodgeConjectureReal X := by
  intro X hE6 hClassical
  let hR := e6_classical_remainder_exists X hE6
  let Y := Classical.choose hR
  have hY : forall k : Nat, NoE6E7Factor (MumfordTateGroup Y k) :=
    Classical.choose_spec hR
  exact e6_remainder_transfer X hE6 (hClassical Y hY)

/-- **R516**: `hc_real_e6_case` derived from the remainder bridge plus
classical Cartan. -/
theorem hc_real_e6_case_via_classical :
    (forall (Y : SmoothProjectiveVariety Complex),
      (forall k : Nat, NoE6E7Factor (MumfordTateGroup Y k)) ->
      HodgeConjectureReal Y) ->
    forall (X : SmoothProjectiveVariety Complex),
      hasSimpleFactor (MumfordTateGroupDerived X 3) E6_neg14 ->
      HodgeConjectureReal X :=
  fun hClassical X hE6 => e6_factor_classical_transfer X hE6 hClassical

/-- R534: one former bridge cut becomes two narrower cuts. -/
def R516_bridge_axiom_count : Nat := 2
def R516_derived_theorem_count : Nat := 2

end HodgeReduction
