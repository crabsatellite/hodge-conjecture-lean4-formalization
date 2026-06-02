/-
# HC Gap L4 -- Front C179: current scalar target as exact Cartan image (R744).

R743 rewrites the current target-side gap as the element-level theorem that
every class in `trivialModulePart` is `j_q (r * h^4)`.

This file turns that target into the more structural exact-image equality

  `Submodule.map j_q CartanH8 = trivialModulePart`.

Under boundary data and the current containment `H8 <= compactDual`, this is
equivalent to the R743 scalar-preimage target.  The proof is not a closure
claim: it uses scalar preimages to recover the target line, then R733 gives
the reverse compact-dual containment, so the compact-dual carrier is the
Cartan H8 line and the old Cartan-image/scalar-preimage equivalence applies.

No boundary theorem, H8-containment theorem, Cartan image exactness theorem,
scalar-preimage theorem, or full HC closure is proved here.
-/

import HodgeReduction.HCGapL4.FrontC178_H8ResidualFiniteMultiplicityScalarPreimageCurrentRoute
import HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC179_H8ResidualCartanImageExactCurrentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC27_CartanImageScalarPreimage
open FrontC83_H8ResidualCartanImageScalarPreimage
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC168_H8ResidualNoExtraTargetLineEquivalence
open FrontC178_H8ResidualFiniteMultiplicityScalarPreimageCurrentRoute

section CartanImageExactCurrentRoute

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

/-- **R744 substantive theorem (1/6)**: with boundary data and the current
H8-containment target fixed, exact Cartan-image equality is exactly the R743
Cartan scalar-preimage theorem.
-/
theorem cartan_image_eq_trivialModulePart_iff_scalar_preimage_under_boundary_H8_le_compactDual
    (D : MatsushimaV56BoundaryData A B)
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B)) <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) := by
  constructor
  · intro hcartan_image
    have hle :
        CuspidalCohomologyData.trivialModulePart (A := B) <=
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
      intro beta hbeta
      rw [hcartan_image]
      exact hbeta
    exact
      (trivialModulePart_le_cartanImage_iff_scalar_preimage
        (A := A) (B := B)).1 hle
  · intro hscalar
    have hline :
        CuspidalCohomologyData.trivialModulePart (A := B) <=
          Submodule.span Rat
            {MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)} :=
      (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
        (A := A) (B := B)).1 hscalar
    have hcompact_le_H8 :
        MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
          CompactDualData.H8 (A := A) :=
      compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
        (A := A) (B := B) D hH8 hline
    have hcompact_cartan :
        MatsushimaCompactDualData.compactDual (A := A) (B := B) =
          CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
      rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
      exact le_antisymm hcompact_le_H8 hH8
    exact
      (cartan_image_eq_trivialModulePart_iff_scalar_preimage
        (A := A) (B := B) hcompact_cartan).2 hscalar

/-- Boundary data, the current H8-containment target, and exact Cartan image
onto `trivialModulePart`.  R744 proves this is equivalent to the R743
scalar-preimage current route.
-/
structure EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract
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
  cartan_image_eq_trivialModulePart :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B)

/-- **R744 substantive theorem (2/6)**: the R743 scalar-preimage route
supplies exact Cartan image.
-/
def H8ContainmentCartanImageExactContract_of_H8ContainmentScalarPreimageContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  cartan_image_eq_trivialModulePart :=
    (cartan_image_eq_trivialModulePart_iff_scalar_preimage_under_boundary_H8_le_compactDual
      (A := A) (B := B) O.boundary O.H8_le_compactDual).2
      O.cartan_scalar_preimage

/-- **R744 substantive theorem (3/6)**: exact Cartan image recovers the R743
scalar-preimage current route.
-/
def H8ContainmentScalarPreimageContract_of_H8ContainmentCartanImageExactContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  cartan_scalar_preimage :=
    (cartan_image_eq_trivialModulePart_iff_scalar_preimage_under_boundary_H8_le_compactDual
      (A := A) (B := B) O.boundary O.H8_le_compactDual).1
      O.cartan_image_eq_trivialModulePart

/-- **R744 substantive theorem (4/6)**: the R743 scalar-preimage contract and
the exact-Cartan-image contract are the same inhabited current route.
-/
theorem residual_H8ContainmentScalarPreimage_nonempty_iff_H8ContainmentCartanImageExact_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentCartanImageExactContract_of_H8ContainmentScalarPreimageContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentScalarPreimageContract_of_H8ContainmentCartanImageExactContract
            (A := A) (B := B) O)))

/-- **R744 substantive theorem (5/6)**: the source-H8 quotient route can now
be read as boundary data, H8 containment, and exact Cartan image.
-/
theorem residual_sourceH8Quotient_nonempty_iff_H8ContainmentCartanImageExact_nonempty :
    Nonempty
        (FrontC172_H8ResidualSourceH8QuotientMinimalRoute.EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B) :=
  (residual_sourceH8Quotient_nonempty_iff_H8ContainmentScalarPreimage_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentScalarPreimage_nonempty_iff_H8ContainmentCartanImageExact_nonempty
      (A := A) (B := B))

/-- **R744 substantive theorem (6/6)**: the current generator-geometry route
is equivalently boundary data, H8 containment, and exact Cartan image.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentCartanImageExact_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageExactContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentScalarPreimage_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentScalarPreimage_nonempty_iff_H8ContainmentCartanImageExact_nonempty
      (A := A) (B := B))

end CartanImageExactCurrentRoute

/-- R744 target names for route summaries. -/
def currentR744CartanImageExactTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove Submodule.map j_q CartanH8 = trivialModulePart; under boundary data and H8 containment this is exactly the scalar-preimage target"
]

/-- Machine-readable status for the R744 exact-Cartan-image current route. -/
structure R744CartanImageExactSnapshot where
  proofWorkObligationCount : Nat
  scalarPreimageEquivalentToExactCartanImageUnderBoundaryH8Containment : Bool
  scalarPreimageSuppliesNoExtraCompactDualContainment : Bool
  exactCartanImageEquivalentToCurrentRoute : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesScalarPreimage : Bool
  provesExactCartanImage : Bool
  provesCompactDualEqCartanH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R744 status: the R743 scalar-preimage target has been rewritten as
exact Cartan image under the same boundary and H8-containment targets.  All
proof-work targets remain open.
-/
def currentR744CartanImageExactSnapshot :
    R744CartanImageExactSnapshot where
  proofWorkObligationCount := currentR744CartanImageExactTargetNames.length
  scalarPreimageEquivalentToExactCartanImageUnderBoundaryH8Containment := true
  scalarPreimageSuppliesNoExtraCompactDualContainment := true
  exactCartanImageEquivalentToCurrentRoute := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesScalarPreimage := false
  provesExactCartanImage := false
  provesCompactDualEqCartanH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R744 route. -/
theorem currentR744CartanImageExactSnapshot_eq_texStatus :
    currentR744CartanImageExactSnapshot =
      ({ proofWorkObligationCount := 3
         scalarPreimageEquivalentToExactCartanImageUnderBoundaryH8Containment := true
         scalarPreimageSuppliesNoExtraCompactDualContainment := true
         exactCartanImageEquivalentToCurrentRoute := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesScalarPreimage := false
         provesExactCartanImage := false
         provesCompactDualEqCartanH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R744CartanImageExactSnapshot) := by
  decide

/-- Kernel-checked target names for the R744 route. -/
theorem currentR744CartanImageExactTargetNames_eq_texStatus :
    currentR744CartanImageExactTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove Submodule.map j_q CartanH8 = trivialModulePart; under boundary data and H8 containment this is exactly the scalar-preimage target"
    ] := by
  rfl

def R744_substantiveTheoremCount : Nat := 6

end FrontC179_H8ResidualCartanImageExactCurrentRoute
end HCGapL4
end HodgeReduction
