/-
# HC Gap L4 -- Front C180: current exact Cartan image as surjectivity (R745).

R744 rewrites the current target-side gap as exact Cartan image:

  `Submodule.map j_q CartanH8 = trivialModulePart`.

Under the current H8-containment target, the forward inclusion

  `Submodule.map j_q CartanH8 <= trivialModulePart`

is automatic: Cartan H8 is the same source line as compact-dual H8, and
`H8 <= compactDual` places its Matsushima image inside target invariants,
which are the trivial-module part.

This file isolates the only remaining exact-image direction as the reverse
surjectivity containment

  `trivialModulePart <= Submodule.map j_q CartanH8`.

No boundary theorem, H8-containment theorem, reverse-containment theorem,
exact-image theorem, or full HC closure is proved here.
-/

import HodgeReduction.HCGapL4.FrontC179_H8ResidualCartanImageExactCurrentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC179_H8ResidualCartanImageExactCurrentRoute

section CartanImageSurjectivityCurrentRoute

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R745 substantive theorem (1/7)**: the current H8-containment target
supplies the easy inclusion from the Cartan H8 image into
`trivialModulePart`.
-/
theorem cartanImage_le_trivialModulePart_of_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) <=
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  intro beta hbeta
  obtain ⟨alpha, halpha_cartan, halpha_beta⟩ := hbeta
  have halpha_H8 : alpha ∈ CompactDualData.H8 (A := A) := by
    rw [← CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
    exact halpha_cartan
  have halpha_compact :
      alpha ∈ MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
    hH8 halpha_H8
  have htarget :
      MatsushimaData.j_q (A := A) (B := B) alpha ∈
        MatsushimaData.target_invariants (A := A) (B := B) :=
    MatsushimaCompactDualData.j_q_compactDual_in_target_invariants
      (A := A) (B := B) halpha_compact
  rw [← halpha_beta]
  rw [← target_invariants_eq_trivialModulePart (A := A) (B := B)]
  exact htarget

/-- **R745 substantive theorem (2/7)**: under the current H8-containment
target, exact Cartan image is exactly the reverse Cartan-image containment.
-/
theorem cartan_image_eq_trivialModulePart_iff_trivialModulePart_le_cartanImage_under_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B)) <->
      (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :=
  Iff.intro
    (fun hcartan_eq => by
      intro beta hbeta
      rw [hcartan_eq]
      exact hbeta)
    (fun hsurj =>
      le_antisymm
        (cartanImage_le_trivialModulePart_of_H8_le_compactDual
          (A := A) (B := B) hH8)
        hsurj)

/-- Boundary data, the current H8-containment target, and the reverse
Cartan-image containment.  R745 proves this is equivalent to the R744 exact
Cartan-image current route.
-/
structure EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract
    (A B : Type*)
    [CommRing A] [Algebra Rat A] [CohomologyRing A]
    [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B]
    [CuspidalCohomologyData B]
    [EisensteinVanishingDeg8 A B]
    [CuspidalGInvariantTrivialModuleDeg8 A B] where
  boundary : MatsushimaV56BoundaryData A B
  H8_le_compactDual :
    CompactDualData.H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  trivialModulePart_le_cartanImage :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))

/-- **R745 substantive theorem (3/7)**: exact Cartan image supplies the
reverse-containment route.
-/
def H8ContainmentCartanImageSurjectivityContract_of_H8ContainmentCartanImageExactContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_le_cartanImage :=
    (cartan_image_eq_trivialModulePart_iff_trivialModulePart_le_cartanImage_under_H8_le_compactDual
      (A := A) (B := B) O.H8_le_compactDual).1
      O.cartan_image_eq_trivialModulePart

/-- **R745 substantive theorem (4/7)**: the reverse containment recovers
exact Cartan image under the current H8-containment target.
-/
def H8ContainmentCartanImageExactContract_of_H8ContainmentCartanImageSurjectivityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  cartan_image_eq_trivialModulePart :=
    (cartan_image_eq_trivialModulePart_iff_trivialModulePart_le_cartanImage_under_H8_le_compactDual
      (A := A) (B := B) O.H8_le_compactDual).2
      O.trivialModulePart_le_cartanImage

/-- **R745 substantive theorem (5/7)**: the exact-Cartan-image contract and
the reverse-containment contract are the same inhabited current route.
-/
theorem residual_H8ContainmentCartanImageExact_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentCartanImageSurjectivityContract_of_H8ContainmentCartanImageExactContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentCartanImageExactContract_of_H8ContainmentCartanImageSurjectivityContract
            (A := A) (B := B) O)))

/-- **R745 substantive theorem (6/7)**: the source-H8 quotient route can now
be read as boundary data, H8 containment, and reverse Cartan-image
containment.
-/
theorem residual_sourceH8Quotient_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty :
    Nonempty
        (FrontC172_H8ResidualSourceH8QuotientMinimalRoute.EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) :=
  (residual_sourceH8Quotient_nonempty_iff_H8ContainmentCartanImageExact_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentCartanImageExact_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty
      (A := A) (B := B))

/-- **R745 substantive theorem (7/7)**: the current generator-geometry route
is equivalently boundary data, H8 containment, and reverse Cartan-image
containment.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentCartanImageExact_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentCartanImageExact_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty
      (A := A) (B := B))

end CartanImageSurjectivityCurrentRoute

/-- R745 target names for route summaries. -/
def currentR745CartanImageSurjectivityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove trivialModulePart <= Submodule.map j_q CartanH8; under H8 containment the opposite inclusion is automatic"
]

/-- Machine-readable status for the R745 reverse-Cartan-image current route. -/
structure R745CartanImageSurjectivitySnapshot where
  proofWorkObligationCount : Nat
  H8ContainmentSuppliesCartanImageLeTrivialModulePart : Bool
  exactCartanImageEquivalentToReverseContainmentUnderH8Containment : Bool
  currentRouteEquivalentToCartanSurjectivityRoute : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesReverseCartanImageContainment : Bool
  provesExactCartanImage : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R745 status: exact Cartan image has been reduced to the reverse
Cartan-image containment under the same H8-containment target.  All proof-work
targets remain open.
-/
def currentR745CartanImageSurjectivitySnapshot :
    R745CartanImageSurjectivitySnapshot where
  proofWorkObligationCount :=
    currentR745CartanImageSurjectivityTargetNames.length
  H8ContainmentSuppliesCartanImageLeTrivialModulePart := true
  exactCartanImageEquivalentToReverseContainmentUnderH8Containment := true
  currentRouteEquivalentToCartanSurjectivityRoute := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesReverseCartanImageContainment := false
  provesExactCartanImage := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R745 route. -/
theorem currentR745CartanImageSurjectivitySnapshot_eq_texStatus :
    currentR745CartanImageSurjectivitySnapshot =
      ({ proofWorkObligationCount := 3
         H8ContainmentSuppliesCartanImageLeTrivialModulePart := true
         exactCartanImageEquivalentToReverseContainmentUnderH8Containment := true
         currentRouteEquivalentToCartanSurjectivityRoute := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesReverseCartanImageContainment := false
         provesExactCartanImage := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R745CartanImageSurjectivitySnapshot) := by
  decide

/-- Kernel-checked target names for the R745 route. -/
theorem currentR745CartanImageSurjectivityTargetNames_eq_texStatus :
    currentR745CartanImageSurjectivityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove trivialModulePart <= Submodule.map j_q CartanH8; under H8 containment the opposite inclusion is automatic"
    ] := by
  rfl

def R745_substantiveTheoremCount : Nat := 7

end FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute
end HCGapL4
end HodgeReduction
