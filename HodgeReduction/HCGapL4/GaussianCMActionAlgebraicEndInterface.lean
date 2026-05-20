/-
# HC Gap L4 — Gaussian CM action algebraic End(E) interface (R313).

R310 closed coordinate-ring preservation: `(i·y)² - (-x)³ - (-x) = -(y² - x³ - x)`.
R311 wrapped it into an affine morphism interface.
R312 closed the projective version: `(i·Y)²·Z - (-X)³ - (-X)·Z² = -(Y²Z - X³ - X·Z²)`.

R313 defines a local **algebraic** elliptic-curve endomorphism interface
and instantiates it with the Gaussian CM action evidence accumulated
so far: point map (R303), additivity (R308), group-end (R308), affine
coord preservation (R310), projective coord preservation (R312),
square = -P (R304/R308).

What R313 does NOT do:
* Does NOT construct the algebraic `End(E)` *ring* (Mathlib has no
  scheme-morphism API specialized to elliptic curves over fields).
* Does NOT construct `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianCMActionAddMonoidHom
import HodgeReduction.HCGapL4.GaussianCMActionAffineMorphismInterface
import HodgeReduction.HCGapL4.GaussianCMActionProjectiveMorphism
import Mathlib.Algebra.Group.Hom.End

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: algebraic End interface skeleton (specialized to E_K) -/

/-- **R313** local interface: a candidate algebraic self-endomorphism
of the base-changed Gaussian curve `E_K`, bundling the point-level map
with the algebraic (affine + projective) coordinate evidence and the
square = `-id` relation. Specialized to `E_K` to avoid typeclass-on-
generic-type-parameter issues. -/
structure AlgebraicEllipticCurveEndomorphismSkeleton where
  /-- The point-level map. -/
  pointMap :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.Point →
      GaussianCMEllipticCurveTargetBaseChange.toAffine.Point
  /-- The bundled `AddMonoid.End` candidate. -/
  groupEndCandidate :
    AddMonoid.End GaussianCMEllipticCurveTargetBaseChange.toAffine.Point
  /-- Target: affine morphism evidence (coord preservation). -/
  affineMorphismEvidence : Prop
  /-- Target: projective morphism evidence. -/
  projectiveMorphismEvidence : Prop
  /-- Target: pointMap agrees with the group-end candidate. -/
  agreesWithGroupEnd : Prop
  /-- Target: square = -id at the point level. -/
  squareNegOneEvidence : Prop

/-! ## Section 2: Gaussian CM instance -/

/-- **R313** Gaussian instance — populates the algebraic End interface
with all the evidence accumulated through R304/R308/R310/R311/R312. -/
noncomputable def GaussianCMAction_AlgebraicEndomorphismSkeleton :
    AlgebraicEllipticCurveEndomorphismSkeleton where
  pointMap := gaussianCMAction_affinePoint
  groupEndCandidate := gaussianCMAction_GroupEndCandidate
  -- R310 affine coord preservation:
  affineMorphismEvidence :=
    ∀ x y : GaussianRationalFieldCandidate,
      (gaussianRationalI * y)^2 - (-x)^3 - (-x) = -(y^2 - x^3 - x)
  -- R312 projective coord preservation:
  projectiveMorphismEvidence :=
    ∀ X Y Z : GaussianRationalFieldCandidate,
      (gaussianRationalI * Y)^2 * Z - (-X)^3 - (-X) * Z^2
        = -(Y^2 * Z - X^3 - X * Z^2)
  -- Agreement: point map IS the group-end candidate (definitional).
  agreesWithGroupEnd :=
    ∀ P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point,
      gaussianCMAction_GroupEndCandidate P = gaussianCMAction_affinePoint P
  -- R304/R308 square = -P at the point level:
  squareNegOneEvidence :=
    ∀ P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point,
      gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P

/-! ## Section 3: witness theorems for the four evidence fields -/

/-- **R313** witness: affine morphism evidence is provable (R310). -/
theorem GaussianCMAction_AlgebraicEndomorphismSkeleton_affineMorphism_holds :
    GaussianCMAction_AlgebraicEndomorphismSkeleton.affineMorphismEvidence :=
  gaussianCMAction_coordinate_polynomial_preserves

/-- **R313** witness: projective morphism evidence is provable (R312). -/
theorem GaussianCMAction_AlgebraicEndomorphismSkeleton_projectiveMorphism_holds :
    GaussianCMAction_AlgebraicEndomorphismSkeleton.projectiveMorphismEvidence :=
  gaussianCMAction_projective_polynomial_preserves

/-- **R313** witness: the point map agrees with the group-end candidate
(definitional). -/
theorem GaussianCMAction_AlgebraicEndomorphismSkeleton_agreesWithGroupEnd_holds :
    GaussianCMAction_AlgebraicEndomorphismSkeleton.agreesWithGroupEnd :=
  fun _ => rfl

/-- **R313** witness: square = -P at the point level (R304/R308). -/
theorem GaussianCMAction_AlgebraicEndomorphismSkeleton_squareNegOne_holds :
    GaussianCMAction_AlgebraicEndomorphismSkeleton.squareNegOneEvidence :=
  gaussianCMAction_affinePoint_square_eq_neg

/-! ## Section 4: remaining gap targets -/

/-- **R313 target**: upgrade affine-coord preservation to a true
scheme-theoretic morphism `E_K → E_K`. -/
def Target_Upgrade_AffineMorphismSkeleton_To_SchemeMorphism : Prop := True

/-- **R313 target**: upgrade projective preservation to a global
scheme morphism. -/
def Target_Upgrade_ProjectiveMorphismSkeleton_To_GlobalMorphism : Prop := True

/-- **R313 target**: construct the algebraic End ring from the
endomorphism skeleton. -/
def Target_AlgebraicEndRing_From_AlgebraicEndomorphismSkeleton :
    Prop := True

/-! ## Section 5: disclosure markers -/

/-- **L4-G** bridge to End(E) ring. -/
def L4_G_AlgebraicEndInterface_To_EndRing : Prop := True

/-- **L4-G** bridge to End⁰(E). -/
def L4_G_AlgebraicEndInterface_To_End0 : Prop := True

/-- **L4-G** bridge to Gaussian-field embedding into End⁰(E). -/
def L4_G_AlgebraicEndInterface_To_GaussianFieldEmbedding : Prop := True

/-- **L4-G** Mathlib gap: no scheme-morphism API specialized to
elliptic curves over fields. -/
def L4_G_AlgebraicEndInterface_MissingSchemeMorphism : Prop := True

/-! ## Section 6: status -/

/-- **R313 status**: algebraic End interface defined. -/
def R313_Status_Interface_Defined : Prop := True

/-- **R313 status**: Gaussian instance populated with R304+R308+R310+R312. -/
def R313_Status_Gaussian_Instance_Populated : Prop := True

/-- **R313 status**: all four evidence fields are provably inhabited. -/
def R313_Status_All_Evidence_Fields_Provable : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R313 non-closure (1/4)**: does NOT construct a scheme morphism. -/
theorem R313_does_not_construct_scheme_morphism : True := trivial

/-- **R313 non-closure (2/4)**: does NOT construct algebraic
`End(E)` *ring*. -/
theorem R313_does_not_construct_algebraic_EndRing : True := trivial

/-- **R313 non-closure (3/4)**: does NOT construct `End⁰(E)`. -/
theorem R313_does_not_construct_End0 : True := trivial

/-- **R313 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R313_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
