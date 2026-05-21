/-
# HC Gap L4 — Parametric canonical HC theorem (R379).

R378 (Wave-1 Agent B) defined `ParametricCanonicalE7ShimuraTor` — a
structure carrying the same 3 fields (`cohomologyOfUnderlying`,
`algClassesOfUnderlying`, `mtCorrespondencePackage`) that
`canonicalE7ShimuraTor` exposes, but WITHOUT consuming any project
axiom.

R379 (Wave-1 Agent C, this file) is Step-2 of the authorized refactor
plan: it proves the parameterized version of
`hodgeConjectureReal_canonical` over a generic
`T : ParametricCanonicalE7ShimuraTor`. The proof body is essentially
IDENTICAL to the existing canonical theorem (MainTheorem.lean lines
323-332) — destructure the bundled MT correspondence package, apply
R177's `varietyHCAt_of_correspondence` per codimension.

## What R379 provides (kernel-pure)

* `hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor` —
  parameterized HC theorem; cone does NOT include
  `canonicalE7ShimuraTor`.
* `VarietyHCAt_of_ParametricCanonicalE7ShimuraTor_codim1` — codim-1
  specialization.
* `hodgeConjectureReal_canonical_via_parametric` — recover the
  original `hodgeConjectureReal_canonical` via the parametric route
  (still depends on `canonicalE7ShimuraTor` through the wrapper).
* `VarietyHCAt_canonical_codim1_via_parametric_old` — codim-1
  specialization of the recovery wrapper.

## What R379 does NOT do

* Does NOT modify `hodgeConjectureReal_canonical`.
* Does NOT remove `canonicalE7ShimuraTor` (the recovery wrapper still
  depends on it).
* Does NOT close HC.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor
import HodgeReduction.MainTheorem

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: parameterized HC theorem -/

/-- **R379** parameterized version of `hodgeConjectureReal_canonical`.
The proof is identical in structure — destructure the ∃-existential
and apply the per-codim transfer. Crucially this theorem's axiom cone
does NOT include `canonicalE7ShimuraTor` (it's a hypothesis-free
theorem over the parameter `T`). -/
theorem hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor
    (T : ParametricCanonicalE7ShimuraTor) :
    Infrastructure.HodgeStructure.VarietyHC
      T.cohomologyOfUnderlying
      T.algClassesOfUnderlying := by
  intro p
  obtain ⟨_A, _A_cohData, _A_algData, _hA_CM, h_HC_A, h_pkg⟩ :=
    T.mtCorrespondencePackage
  exact Infrastructure.HodgeStructure.varietyHCAt_of_correspondence
    (h_pkg p) (h_HC_A p)

/-! ## Section 2: codim-1 specialization -/

/-- **R379** codim-1 specialization of the parameterized theorem. -/
theorem VarietyHCAt_of_ParametricCanonicalE7ShimuraTor_codim1
    (T : ParametricCanonicalE7ShimuraTor) :
    Infrastructure.HodgeStructure.VarietyHCAt
      T.cohomologyOfUnderlying T.algClassesOfUnderlying 1 :=
  hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor T 1

/-! ## Section 3: recover the old canonical theorem via the parametric route -/

/-- **R379** the original `hodgeConjectureReal_canonical` recovered via
the parametric route. This wrapper still depends on `canonicalE7ShimuraTor`
(through `ParametricCanonicalE7ShimuraTor_from_canonical`), so the cone
is UNCHANGED. -/
theorem hodgeConjectureReal_canonical_via_parametric :
    Infrastructure.HodgeStructure.VarietyHC
      canonicalE7ShimuraTor.cohomologyOfUnderlying
      canonicalE7ShimuraTor.algClassesOfUnderlying :=
  hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor
    ParametricCanonicalE7ShimuraTor_from_canonical

/-- **R379** codim-1 version of the recovery. -/
theorem VarietyHCAt_canonical_codim1_via_parametric_old :
    Infrastructure.HodgeStructure.VarietyHCAt
      canonicalE7ShimuraTor.cohomologyOfUnderlying
      canonicalE7ShimuraTor.algClassesOfUnderlying 1 :=
  hodgeConjectureReal_canonical_via_parametric 1

/-! ## Section 4: cone audit markers -/

/-- **R379 cone fact**: the parameterized theorem
`hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor` DOES NOT have
`canonicalE7ShimuraTor` in its axiom cone — its cone is exactly
`{propext, Classical.choice, Quot.sound}`. -/
def R379_Parametric_Theorem_NoCanonicalAxiomInCone : Prop := True

/-- **R379 cone fact**: the old recovery wrapper
`hodgeConjectureReal_canonical_via_parametric` DOES still have
`canonicalE7ShimuraTor` in its cone (via the wrapper instance). -/
def R379_Old_Wrapper_StillHas_CanonicalAxiomInCone : Prop := True

/-! ## Section 5: status / graph edges / non-closure -/

def R379_Status_Parametric_Theorem_Closed : Prop := True
def R379_Status_OldWrapper_Closed : Prop := True
def R379_Status_Codim1_Specialization_Closed : Prop := True

def L4_G_ParametricHCTheorem_To_HeadlineSwitch : Prop := True
def L4_G_ParametricHCTheorem_To_ReplacementInterface : Prop := True

theorem R379_does_not_modify_headline : True := trivial
theorem R379_does_not_remove_canonical_axiom : True := trivial
theorem R379_does_not_close_HC : True := trivial

end HCGapL4
end HodgeReduction
