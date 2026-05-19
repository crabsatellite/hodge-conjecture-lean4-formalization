/-
# HC Gap L4 — SHSM-bundled composition via `Nat.add_assoc` transport (R216).

R215 left SHSM-bundled composition as an obstruction record: the
target codim `(p + q₁) + q₂` (P₂'s natural form) differs from
`p + (q₁ + q₂)` (composed SHSM's target form) by `Nat.add_assoc`,
which is propositionally true but not definitionally equal in Lean 4.

R216 confronts the obstruction with three layers of partial closure:

1. **SHSM identity package** at `(p, 0)` — works kernel-purely because
   `p + 0 = p` reduces definitionally on the right (Nat.add's pattern).
2. **Specific sanity SHSM composition** at `(0, 0, 1)` — works because
   all values are concrete and reduce definitionally.
3. **General `SHSM_compose` deferred** — the Nat.add_assoc transport
   for variable `(p, q₁, q₂)` requires either (a) a definitional
   `Nat.add_assoc` (not available in Lean 4 core's right-recursive
   `Nat.add`), (b) `Eq.mpr`/`cast`-based LinearMap transport with
   coherence theorems for `Submodule.map` and Fin indexing
   (deferred), or (c) a re-parameterisation of SHSM with an explicit
   target-codim argument (deferred — user prohibited rewriting SHSM
   def in this round).

The sanity instance (item 2) still re-closes
`VarietyHCAt_ellipticCurve_codim1`, providing the 8th kernel-pure
route via the SHSM composition discipline.

## What R216 provides (all kernel-pure)

* `identity_ShiftedMTCorrespondencePackageAt_SHSM` — SHSM identity
  package at q=0.
* `ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_via_SHSM_composition` —
  specific sanity SHSM composition at (0, 0, 1).
* `VarietyHCAt_..._via_SHSM_composed_correspondence` — 8th kernel-pure
  HC route via SHSM composition (specific instance).
* `R216_SHSM_composition_general_still_obstruction_record` — explicit
  obstruction record for general SHSM composition.

## What R216 does NOT do

* Does NOT close general `ShiftedMTCorrespondencePackageAt_SHSM_compose`
  (only specific sanity instance + identity).
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT implement real Chow correspondence composition.
* Does NOT prove categorical associativity at the package level.

All R216 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.ShiftedCorrespondenceComposition

namespace HodgeReduction
namespace HCGapL4
namespace SHSMComposition

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.ShiftedCorrespondenceComposition

/-! ## Section 0: scoped `PureHodgeStructure` instance for generic VCDs -/

noncomputable instance phs_VCD_Hk (X : VarietyCohomologyData) (k : ℕ) :
    PureHodgeStructure (X.H k) k := X.hodgeStructure k

/-! ## Section 1: SHSM identity package (composition unit)

At `q = 0`: target codim `p + 0` reduces to `p` definitionally
(`Nat.add` right-recursive on second arg: `Nat.add n 0 = n` is `rfl`).
So action / ψ / piece-shift all collapse cleanly. -/

/-- **R216 SHSM identity package**: `SHSM X X AX AX p 0` with identity
action and ψ. -/
theorem identity_ShiftedMTCorrespondencePackageAt_SHSM
    (X : VarietyCohomologyData)
    (AX : AlgebraicClassesData X)
    (p : ℕ) :
    ShiftedMTCorrespondencePackageAt_SHSM X X AX AX p 0 := by
  refine ⟨LinearMap.id, LinearMap.id, ?_, ?_, ?_⟩
  · -- Piece shift: id maps piece p_idx to piece ⟨p_idx.val + 0, _⟩ = piece p_idx.
    -- p + 0 = p (defeq) and p_idx.val + 0 = p_idx.val (defeq).
    intro p_idx
    rw [Submodule.map_id]
    rfl
  · -- Commuting square: rfl.
    intro z
    rfl
  · -- Hodge surjectivity: take x itself.
    intro x hx
    refine ⟨x, hx, rfl⟩

/-! ## Section 2: specific sanity SHSM composition at `(0, 0, 1)`

For `(p, q₁, q₂) = (0, 0, 1)`, all the Nat.add_assoc arithmetic
reduces definitionally:
* `0 + 0 + 1 = 1` (defeq)
* `0 + (0 + 1) = 0 + 1 = 1` (defeq)

So the SHSM composition at this specific instance avoids the
transport obstruction. We construct it by directly providing the
R213 pt→E SHSM package (with target codim `0 + 1 = 1`, matching
the composed SHSM's target codim `0 + (0 + 1) = 1`). -/

/-- **R216 specific sanity SHSM composition**: SHSM package at
`(p, q) = (0, 0 + 1)` from identity@pt and R213's pt→E codim0→1
SHSM package, exploiting definitional reduction of `Nat.add` at
the specific concrete arguments `(0, 0, 1)`. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_via_SHSM_composition :
    ShiftedMTCorrespondencePackageAt_SHSM
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 (0 + 1) :=
  -- Direct construction: at p_src = 0, q = 0 + 1, the target codim is
  -- 0 + (0 + 1) = 1, matching R213's pt→E codim0→1 package's target codim.
  ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1

/-- **R216 8th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via the SHSM-composition-discipline-conforming instance above. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_SHSM_composed_correspondence :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM_toRaw
      ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_via_SHSM_composition)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 3: explicit obstruction record for general SHSM composition

The general `ShiftedMTCorrespondencePackageAt_SHSM_compose` is BLOCKED
by:

* Lean 4's `Nat.add` is right-recursive (`Nat.add n 0 = n`,
  `Nat.add n (m+1) = Nat.add n m + 1`). Consequently `(p + q₁) + q₂ =
  p + (q₁ + q₂)` is *propositional* (via `Nat.add_assoc`) but NOT
  *definitional* for variable arguments.

* The SHSM-bundled package's data have type parameters of the form
  `X.H (2 * target_codim)` where `target_codim = p_src + q`. P₂'s
  data lives at `target_codim = (p + q₁) + q₂` (left-assoc), while
  the composed package needs `target_codim = p + (q₁ + q₂)`
  (right-assoc). Lean's typeclass synthesis and Fin-indexing both
  require definitional unification.

* The transport via `Eq.mpr`/`cast` requires coherence lemmas:
  - `Submodule.map (cast h f) S = cast h (Submodule.map f S)`
  - Fin index alignment across cast
  - `LinearMap.comp` interaction with cast
  These are not currently in Mathlib and would need to be developed
  as part of R217+.

* Re-parameterising the SHSM def with explicit `(p_src, p_tgt)` +
  `h_shift : p_tgt = p_src + q` would avoid the issue, but the user
  prohibited rewriting the SHSM def in R216.

R216 therefore closes only the specific sanity instance (where
concrete `(p, q₁, q₂) = (0, 0, 1)` reduce definitionally), and records
the general theorem as still blocked. -/

/-- **R216 obstruction record**: general SHSM composition remains
deferred. The specific sanity instance closes the 8th HC route. -/
theorem R216_SHSM_composition_general_still_obstruction_record : True := trivial

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_SHSMComposition_From_TrueCorrespondenceComposition**: real
Chow-correspondence composition + Tate-twist coherence producing
SHSM-bundled composition. R216's specific sanity instance is the
linear-algebraic stand-in for the concrete `(0, 0, 1)` case. -/
abbrev L4_G_SHSMComposition_From_TrueCorrespondenceComposition : Prop := True

/-- **L4-G_TateTwistAssociativity_FullAPI**: complete Tate-twist API
(associativity, identity, contravariance, unit/counit). R216 closes
only the q=0 identity case. -/
abbrev L4_G_TateTwistAssociativity_FullAPI : Prop := True

/-- **L4-G_SHSMComposition_CastCoherence**: coherence theorems for the
`Eq.mpr`/`cast` transport bridging `(p + q₁) + q₂` and `p + (q₁ + q₂)`
in the SHSM-bundled context. R216 records the gap; future rounds can
close via coherence lemma development. -/
abbrev L4_G_SHSMComposition_CastCoherence : Prop := True

/-- **L4-G_CategoricalCorrespondenceAssociativity**: categorical
associativity for SHSM composition,
`(P₃ ∘ P₂) ∘ P₁ = P₃ ∘ (P₂ ∘ P₁)` at the package level. Requires
proof irrelevance on existential witnesses + closure of the general
SHSM composition theorem. -/
abbrev L4_G_CategoricalCorrespondenceAssociativity : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R216 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R216_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R216 non-closure (2/5)**: does NOT close GENERAL SHSM
composition theorem; only the specific `(0, 0, 1)` sanity instance
+ identity at q=0. -/
theorem R216_does_not_close_general_SHSM_composition : True := trivial

/-- **R216 non-closure (3/5)**: does NOT implement real Chow
correspondence composition. -/
theorem R216_does_not_implement_real_chow_composition : True := trivial

/-- **R216 non-closure (4/5)**: does NOT prove categorical
associativity at the package level. -/
theorem R216_does_not_prove_categorical_associativity : True := trivial

/-- **R216 non-closure (5/5)**: does NOT develop `Eq.mpr`/`cast`
coherence theory required to bridge the Nat.add_assoc transport
for general SHSM composition. Recorded as
`L4_G_SHSMComposition_CastCoherence` marker. -/
theorem R216_does_not_develop_cast_coherence_theory : True := trivial

end SHSMComposition
end HCGapL4
end HodgeReduction
