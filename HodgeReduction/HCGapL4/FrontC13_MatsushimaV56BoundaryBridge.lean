/-
# HC Gap L4 -- Front C13: Matsushima boundary bridge to the V56 input (R554).

R553 tied the finite V56 profile used by the Shimura expected Betti
calculation to the actual `PureHodgeStructure V56 3` infrastructure.
This file advances the adjacent Matsushima/Borel--Wallach side without
claiming the concrete EVII isomorphism:

* below complex dimension 27, the existing Borel--Wallach low-degree
  framework rewrites `(g,K)` cohomology to compact-dual cohomology;
* Eisenstein-vanishing plus cuspidal trivial-module reduction rewrites
  the Matsushima target invariants to the trivial-module part;
* if the Matsushima surjectivity source/target are the compact-dual and
  target-invariant subspaces, the image of compact-dual cohomology is
  exactly the trivial-module part.

The last "if" is the honest remaining EVII-specific boundary condition.
It is recorded as equalities of submodules, not as a `True` marker.
-/

import Mathlib.Tactic
import HodgeReduction.HCGapL4.FrontC12_V56InfrastructureProfileBridge
import HodgeReduction.Infrastructure.Automorphic.CuspidalCohomology
import HodgeReduction.Infrastructure.Automorphic.GKCohomology

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC13_MatsushimaV56BoundaryBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC12_V56InfrastructureProfileBridge

/-! ## Low-degree `(g,K)` to compact-dual rewrites -/

section GKLowDegree

variable {A : Type*} [CommRing A] [Algebra ℚ A]
  [BorelWallachLowDegreeVanishing A]

/-- **R554 substantive theorem (1/5)**: if the Hermitian symmetric
pair has complex dimension 27, then degree 3 is in the low-degree range
and the `(g,K)` cohomology submodule equals the compact-dual image. -/
theorem gk_cohomology_eq_compactDual_deg3_of_complexDim27
    (hdim : BorelWallachLowDegreeVanishing.complexDimGmodK A = 27) :
    GKCohomologyData.cohomology (A := A) 3 =
      GKCohomologyData.compactDualImage (A := A) 3 := by
  exact BorelWallachLowDegreeVanishing.cohomology_eq_compactDualImage_below_complex_dim
    (A := A) 3 (by
      rw [hdim]
      omega)

/-- **R554 substantive theorem (2/5)**: the same low-degree rewrite at
degree 8, the degree used by the stable Matsushima injection in the
existing infrastructure. -/
theorem gk_cohomology_eq_compactDual_deg8_of_complexDim27
    (hdim : BorelWallachLowDegreeVanishing.complexDimGmodK A = 27) :
    GKCohomologyData.cohomology (A := A) 8 =
      GKCohomologyData.compactDualImage (A := A) 8 := by
  exact BorelWallachLowDegreeVanishing.cohomology_eq_compactDualImage_below_complex_dim
    (A := A) 8 (by
      rw [hdim]
      omega)

end GKLowDegree

/-! ## Matsushima target invariants to trivial-module part -/

section MatsushimaTarget

variable {A B : Type*}
  [AddCommGroup A] [Module ℚ A]
  [AddCommGroup B] [Module ℚ B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R554 substantive theorem (3/5)**: Franke/Eisenstein reduction and
the Salamanca-Riba/Vogan-Zuckerman low-degree trivial-module reduction
combine to identify the Matsushima target invariants with the cuspidal
trivial-module part. -/
theorem target_invariants_eq_trivialModulePart :
    MatsushimaData.target_invariants (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have htarget :
      MatsushimaData.target_invariants (A := A) (B := B) =
        CuspidalCohomologyData.cuspidalSubspace (A := B) :=
    EisensteinVanishingDeg8.target_invariants_eq_cuspidal
      (A := A) (B := B)
  have htriv :
      CuspidalCohomologyData.cuspidalSubspace (A := B) ⊓
          MatsushimaData.target_invariants (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B) :=
    CuspidalGInvariantTrivialModuleDeg8.cuspidal_G_invariant_eq_trivial_module
      (A := A) (B := B)
  rw [← htarget] at htriv
  simpa using htriv

end MatsushimaTarget

/-! ## Boundary data for the honest EVII-specific Matsushima step -/

/-- Boundary equalities needed to consume the abstract Matsushima
surjectivity package in the EVII/V56 route.

This is deliberately not an instance and not inhabited here.  A concrete
EVII proof must show these two submodule equalities:

* the surjectivity source is the compact-dual subspace;
* the surjectivity target is the Matsushima target-invariant subspace.
-/
structure MatsushimaV56BoundaryData
    (A B : Type*)
    [AddCommGroup A] [Module ℚ A]
    [AddCommGroup B] [Module ℚ B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B] where
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  target_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B)

section MatsushimaBoundary

variable {A B : Type*}
  [AddCommGroup A] [Module ℚ A]
  [AddCommGroup B] [Module ℚ B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R554 substantive theorem (4/5)**: once the EVII-specific boundary
equalities identify the Matsushima source/target with compact-dual and
target-invariant subspaces, the Matsushima image of compact-dual
cohomology is exactly the cuspidal trivial-module part. -/
theorem matsushima_compactDual_image_eq_trivialModulePart
    (D : MatsushimaV56BoundaryData A B) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
        rw [← D.source_eq_compactDual]
    _ = MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
      MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)
    _ = MatsushimaData.target_invariants (A := A) (B := B) :=
      D.target_eq_invariants
    _ = CuspidalCohomologyData.trivialModulePart (A := B) :=
      target_invariants_eq_trivialModulePart (A := A) (B := B)

/-- R554 certification package: an abstract Matsushima boundary
certificate plus the already-closed R553 V56 infrastructure profile.
It does not fill the EVII boundary data; it records exactly what a
future concrete EVII step must provide. -/
structure MatsushimaV56BoundaryCertification where
  boundary : MatsushimaV56BoundaryData A B
  targetEqTrivial :
    MatsushimaData.target_invariants (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B)
  compactDualImageEqTrivial :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B)
  v56Profile : V56InfrastructureProfileCertification

/-- **R554 substantive theorem (5/5)**: any honest EVII boundary data
can be combined with the R553 V56 profile certification to produce the
next bridge certificate. -/
def matsushimaV56BoundaryCertification_from_boundary
    (D : MatsushimaV56BoundaryData A B) :
    MatsushimaV56BoundaryCertification (A := A) (B := B) where
  boundary := D
  targetEqTrivial := target_invariants_eq_trivialModulePart (A := A) (B := B)
  compactDualImageEqTrivial :=
    matsushima_compactDual_image_eq_trivialModulePart (A := A) (B := B) D
  v56Profile := v56InfrastructureProfileCertification_current

end MatsushimaBoundary

def R554_substantiveTheoremCount : Nat := 5

end FrontC13_MatsushimaV56BoundaryBridge
end HCGapL4
end HodgeReduction
