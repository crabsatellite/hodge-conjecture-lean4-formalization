/-
# HC Gap L4 — `AlgebraicClassesData` reconciliation (R208).

R201–R203 supplied `AlgebraicClassesData` via hand-declared
case-split submodules (`algClasses 0 := ⊤`, `algClasses p := ⊥`
for `p ≥ 1`, etc.). R207 introduced a generator-based alternative
via `AlgebraicClassesData.ofCycleClassFamily`. Both routes are
kernel-pure and produce `AlgebraicClassesData X` values, but they
are SEPARATE Lean objects.

R208 establishes that the two routes give the **same algClasses**
at every codimension in our internal models, and provides a
**generic transport theorem** allowing `VarietyHCAt` results to
move freely between them.

## What R208 does NOT do

* It does NOT prove the two `AlgebraicClassesData` STRUCTURES
  themselves are equal (`A_old = A_family`). The `algClasses` fields
  agree at every codim, but the `algClasses_le_hodgeClasses` proof
  fields are different terms; structure equality would require
  proof irrelevance, which is not the main result here.
* It does NOT introduce real Chow group / cycle class map.
* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT implement product varieties or correspondence actions.

All R208 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.CycleClassPresentation

namespace HodgeReduction
namespace HCGapL4
namespace ACDReconciliation

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.CycleClassPresentation

/-! ## Section 0: scoped typeclass instances

Same pattern as R205: parameterised instances so `AddCommGroup` /
`Module ℚ` on `(X.H k)` resolves at every `k`, including `2 * (n+1)`
/ `2 * (n+2)` that arise inside the all-codims agreement proofs. -/

noncomputable instance acg_point_Hk (k : ℕ) :
    AddCommGroup (TrivialPoint.varietyCohomology_point.H k) :=
  TrivialPoint.varietyCohomology_point.addCommGroup k

noncomputable instance mod_point_Hk (k : ℕ) :
    Module ℚ (TrivialPoint.varietyCohomology_point.H k) :=
  TrivialPoint.varietyCohomology_point.module k

noncomputable instance acg_ellipticCurve_Hk (k : ℕ) :
    AddCommGroup (EllipticCurve.VarietyCohomologyData_ellipticCurve.H k) :=
  EllipticCurve.VarietyCohomologyData_ellipticCurve.addCommGroup k

noncomputable instance mod_ellipticCurve_Hk (k : ℕ) :
    Module ℚ (EllipticCurve.VarietyCohomologyData_ellipticCurve.H k) :=
  EllipticCurve.VarietyCohomologyData_ellipticCurve.module k

/-! ## Section 1: generic transport theorem

If two `AlgebraicClassesData` for the same `X` agree on `algClasses p`,
then `VarietyHCAt X _ p` agrees as a `Prop` (`Iff`). This is the
infrastructure that lets us move freely between hand-written and
family-derived ACDs at a fixed codim.

The proof is one-liner once we unfold `VarietyHCAt`: both sides
become `hodgeClasses ≤ algClasses`, and substituting the equality
makes them syntactically identical. -/

/-- **R208 generic transport theorem**: at codim `p`, `VarietyHCAt`
depends only on `algClasses p`. -/
theorem VarietyHCAt_transport_of_algClasses_eq
    {X : VarietyCohomologyData}
    {A B : AlgebraicClassesData X}
    {p : ℕ}
    (h : A.algClasses p = B.algClasses p) :
    VarietyHCAt X A p ↔ VarietyHCAt X B p := by
  unfold VarietyHCAt
  rw [h]

/-- Sibling one-direction form of the transport theorem. -/
theorem VarietyHCAt_transfer_of_algClasses_eq
    {X : VarietyCohomologyData}
    {A B : AlgebraicClassesData X}
    {p : ℕ}
    (h : A.algClasses p = B.algClasses p)
    (hA : VarietyHCAt X A p) :
    VarietyHCAt X B p :=
  (VarietyHCAt_transport_of_algClasses_eq h).mp hA

/-! ## Section 2: codim-level agreement for the point

`TrivialPoint.algClasses_point.algClasses 0 = ⊤` (hand-declared).
`(ofCycleClassFamily pointCycleClassFamily).algClasses 0 = span ℚ
(range (fun _ : Unit => 1)) = ⊤`. Both sides equal `⊤`; the
agreement is the symmetric form of `span_unit_const_one_eq_top`. -/

/-- **R208 codim-0 agreement (point)**: the hand-written and
family-derived `algClasses 0` for the point coincide. -/
theorem agreement_point_codim0 :
    TrivialPoint.algClasses_point.algClasses 0 =
    (AlgebraicClassesData.ofCycleClassFamily pointCycleClassFamily).algClasses 0 := by
  rw [ofCycleClassFamily_algClasses_eq_span]
  -- LHS reduces to `⊤` (algClassesPoint 0 = ⊤ via pattern match).
  -- RHS = span (range (pointCycleClass 0)) = span (range (fun _ => 1)) = ⊤.
  exact span_unit_const_one_eq_top.symm

/-- **R208 agreement at all codims (point)**: hand-written and
family-derived `algClasses` for the point coincide at every codim. -/
theorem agreement_point_all_codims (p : ℕ) :
    TrivialPoint.algClasses_point.algClasses p =
    (AlgebraicClassesData.ofCycleClassFamily pointCycleClassFamily).algClasses p := by
  rw [ofCycleClassFamily_algClasses_eq_span]
  match p with
  | 0 =>
    -- LHS = ⊤, RHS = span (range (fun _ => 1)) = ⊤
    exact span_unit_const_one_eq_top.symm
  | n + 1 =>
    -- LHS = ⊥ (algClassesPoint (n+1) = ⊥ via pattern match).
    -- RHS = span (range (pointCycleClassFamily.cycleClass (n+1))) = ⊥
    --   since the range is empty (PEmpty domain) and span ∅ = ⊥.
    have hSpan :
        Submodule.span ℚ (Set.range (pointCycleClassFamily.cycleClass (n + 1)))
        = (⊥ : Submodule ℚ (TrivialPoint.varietyCohomology_point.H (2 * (n + 1)))) := by
      apply Submodule.span_eq_bot.mpr
      rintro x ⟨g, _⟩
      exact g.elim
    rw [hSpan]
    -- Goal: algClasses_point.algClasses (n+1) = ⊥; def-equal by pattern match.
    rfl

/-! ## Section 3: codim-level agreement for the elliptic curve -/

/-- **R208 codim-0 agreement (elliptic curve)**. -/
theorem agreement_ellipticCurve_codim0 :
    EllipticCurve.AlgebraicClassesData_ellipticCurve.algClasses 0 =
    (AlgebraicClassesData.ofCycleClassFamily ellipticCurveCycleClassFamily).algClasses 0 := by
  rw [ofCycleClassFamily_algClasses_eq_span]
  exact span_unit_const_one_eq_top.symm

/-- **R208 codim-1 agreement (elliptic curve)**. -/
theorem agreement_ellipticCurve_codim1 :
    EllipticCurve.AlgebraicClassesData_ellipticCurve.algClasses 1 =
    (AlgebraicClassesData.ofCycleClassFamily ellipticCurveCycleClassFamily).algClasses 1 := by
  rw [ofCycleClassFamily_algClasses_eq_span]
  exact span_unit_const_one_eq_top.symm

/-- **R208 agreement at all codims (elliptic curve)**. -/
theorem agreement_ellipticCurve_all_codims (p : ℕ) :
    EllipticCurve.AlgebraicClassesData_ellipticCurve.algClasses p =
    (AlgebraicClassesData.ofCycleClassFamily ellipticCurveCycleClassFamily).algClasses p := by
  rw [ofCycleClassFamily_algClasses_eq_span]
  match p with
  | 0 =>
    exact span_unit_const_one_eq_top.symm
  | 1 =>
    exact span_unit_const_one_eq_top.symm
  | n + 2 =>
    have hSpan :
        Submodule.span ℚ (Set.range (ellipticCurveCycleClassFamily.cycleClass (n + 2)))
        = (⊥ : Submodule ℚ
              (EllipticCurve.VarietyCohomologyData_ellipticCurve.H (2 * (n + 2)))) := by
      apply Submodule.span_eq_bot.mpr
      rintro x ⟨g, _⟩
      exact g.elim
    rw [hSpan]
    rfl

/-! ## Section 4: re-derived `VarietyHCAt` closures via reconciliation

These theorems are NOT new HC information — `VarietyHCAt_point 0`
(R201) and `VarietyHCAt_ellipticCurve_codim1` (R203) were already
proven directly. R208's contribution is that they can ALSO be
derived by combining the family-based closure from R207 with the
generic transport theorem from Section 1, demonstrating that the
two ACD routes give compatible HC results. -/

/-- **R208 reconciliation closure 1**: HC at codim 0 for the point,
derived from the family-based version (R207) via the transport
theorem and the codim-0 agreement. -/
theorem VarietyHCAt_point_codim0_via_reconciled_family :
    VarietyHCAt TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0 := by
  exact VarietyHCAt_transfer_of_algClasses_eq
    agreement_point_codim0.symm
    VarietyHCAt_point_codim0_via_ofCycleClassFamily

/-- **R208 reconciliation closure 2**: HC at codim 1 for the
elliptic curve, derived from the family-based version (R207) via
the transport theorem and the codim-1 agreement. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_reconciled_family :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 := by
  exact VarietyHCAt_transfer_of_algClasses_eq
    agreement_ellipticCurve_codim1.symm
    VarietyHCAt_ellipticCurve_codim1_via_ofCycleClassFamily

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ACDReconciliation_HandVsFamily**: hand-written and
family-derived `AlgebraicClassesData` agree on `algClasses` at every
codim for our internal models. R208 PROVES this; the marker remains
to record that this is a feature of the internal-model class only —
for a true Mathlib-AG variety, the "hand-written" path does not exist
and the family-based path is the only sensible one. -/
abbrev L4_G_ACDReconciliation_HandVsFamily : Prop := True

/-- **L4-G_ACDReconciliation_GlobalStructureEquality**: stronger
statement that `A_old = A_family` as structures (not just
algClasses-wise). Would require proof irrelevance on the
`algClasses_le_hodgeClasses` field. Explicitly OUT OF SCOPE for
R208 per the round mandate. -/
abbrev L4_G_ACDReconciliation_GlobalStructureEquality : Prop := True

/-- **L4-G_ACDReconciliation_FromRealChow**: once a real Chow group
`CH^p(X)_ℚ` exists with the actual cycle class map, the
"hand-written" ACD route disappears entirely and the family-derived
ACD becomes the canonical kernel-pure construction. The
reconciliation theorems then become unnecessary. -/
abbrev L4_G_ACDReconciliation_FromRealChow : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R208 non-closure (1/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R208_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R208 non-closure (2/3)**: does NOT prove `A_old = A_family`
as structure values. The codim-wise agreement on `algClasses` is the
substantive content; proof irrelevance on `algClasses_le_hodgeClasses`
is explicitly OUT OF SCOPE. -/
theorem R208_does_not_prove_structure_equality : True := trivial

/-- **R208 non-closure (3/3)**: does NOT implement real Chow group,
real cycle class map, product varieties, or correspondence actions.
R208 only unifies the two existing internal-model ACD routes. -/
theorem R208_does_not_implement_chow_or_product : True := trivial

end ACDReconciliation
end HCGapL4
end HodgeReduction
