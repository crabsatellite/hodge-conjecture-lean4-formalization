/-
# HC Gap L4 — Mathlib MT-correspondence feasibility audit (R254).

R250 closed the toy `algClassesOfUnderlying` replacement path through
the linear cycle-class-map interface, and R251–R253 audited Mathlib
for the cohomology-replacement target, recommending a scheme-agnostic
abstract rational cohomology source as the smallest formal next target.

R254 begins the parallel audit for the third active field of
`canonicalE7ShimuraTor`: `mtCorrespondencePackage`. Per R247's plan,
this is the toy CM/MT-correspondence side, and the audit here probes
Mathlib for what is available to replace it with real infrastructure.

Method: only `import` Mathlib modules that ACTUALLY EXIST in the local
Mathlib tree (verified by `find` over `Mathlib/`). Missing areas are
recorded as `Prop`-level `True` markers and as `AuditMissing_*`
declarations, not as failed imports.

## Audit findings (verified 2026-05-20)

### Available in Mathlib
* `Mathlib.AlgebraicGeometry.Scheme` — scheme abstraction (recall from R251).
* `Mathlib.AlgebraicGeometry.Morphisms.Smooth` — smooth morphisms.
* `Mathlib.AlgebraicGeometry.Morphisms.Proper` — proper morphisms.
* `Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass` — elliptic curve
  as Weierstrass model (1-dim CM case lives here).
* `Mathlib.AlgebraicGeometry.EllipticCurve.Group` — elliptic-curve group
  structure (the dim-1 abelian variety group law).
* `Mathlib.AlgebraicGeometry.EllipticCurve.Jacobian` — Jacobian model of
  an elliptic curve.
* `Mathlib.FieldTheory.AbsoluteGaloisGroup` — absolute Galois group of
  a field (relevant to CM via reflex field action).
* `Mathlib.Algebra.Algebra.RestrictScalars` — restriction of scalars at
  module/algebra level (NOT Weil restriction of schemes).

### MISSING in Mathlib (verified absent)
* **Abelian variety** as a higher-dimensional bundle —
  no `AbelianVariety.lean`. Only elliptic curves (dim 1) are present.
* **Complex multiplication** structure on abelian varieties —
  no `ComplexMultiplication*` or `CM*` files.
* **Endomorphism algebra** of an abelian variety —
  `CategoryTheory.Endomorphism` exists but only as the categorical
  notion; no `End⁰(A) ⊗ ℚ` style API for abelian varieties.
* **Algebraic group / group scheme** as a bundled typeclass —
  no `AlgebraicGroup.lean` / `GroupScheme.lean`. Group object structure
  on `Scheme` is not packaged.
* **Algebraic torus** — no `Torus.lean` for algebraic tori
  (`MeasureTheory.Integral.TorusIntegral` is unrelated).
* **Mumford–Tate group** — no `MumfordTate.lean` outside of our
  local `HodgeReduction.Infrastructure.HodgeStructure.MumfordTate`.
* **Hodge structures** as a Mathlib bundle — covered by R251; absent.
* **Chow groups / algebraic cycles** — no `Chow*` / `Cycle*` files
  in `AlgebraicGeometry` (the `Cycle` hits in Mathlib are `List.Cycle`
  / permutation cycles, irrelevant).
* **Algebraic correspondences** — no `Correspondences*` files.
* **Weil restriction** of schemes — no `WeilRestriction.lean`;
  `Algebra.Algebra.RestrictScalars` is the module-level restriction
  only.
* **Motives** — no `Motive*` files; no motivic category infrastructure.
* **Albanese / Picard scheme** — no `Albanese.lean`. `Picard*` hits
  are Picard–Lindelöf (ODE) only.

## What R254 (this file) provides (all kernel-pure)

* `MTCorrespondenceMathlibAuditToySkeleton` — audit-marker structure
  with 10 Prop fields.
* `MTCorrespondenceMathlibAuditToySkeleton_current` — instance
  recording the findings above as `True`/`True` markers.
* `AuditMissing_*` markers for each missing area.

## What R254 (this file) does NOT do

* Does NOT construct real CM abelian varieties.
* Does NOT construct real algebraic correspondences.
* Does NOT construct real Mumford–Tate groups.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Only audits which Mathlib modules are import-clean for the
  MT-correspondence replacement path.

All R254 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

-- Verified imports: each builds clean on the local Mathlib tree.
import Mathlib.AlgebraicGeometry.Scheme
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.AlgebraicGeometry.Morphisms.Proper
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass
import Mathlib.AlgebraicGeometry.EllipticCurve.Group
import Mathlib.AlgebraicGeometry.EllipticCurve.Jacobian
import Mathlib.FieldTheory.AbsoluteGaloisGroup
import Mathlib.Algebra.Algebra.RestrictScalars

namespace HodgeReduction
namespace HCGapL4
namespace MTCorrespondenceMathlibAudit

/-! ## Section 1: audit marker structure -/

/-- **R254 audit-marker structure**: 10 Prop fields tracking which
Mathlib areas are import-clean for the MT-correspondence replacement
path. -/
structure MTCorrespondenceMathlibAuditToySkeleton where
  /-- Scheme + smooth + proper morphism imports available
  (`Scheme`, `Morphisms.Smooth`, `Morphisms.Proper`). -/
  hasSchemeAndMorphismsImportsToy : Prop
  /-- Elliptic curve infrastructure available
  (`EllipticCurve.Weierstrass`, `EllipticCurve.Group`,
  `EllipticCurve.Jacobian`) as the dim-1 CM case. -/
  hasEllipticCurveImportsToy : Prop
  /-- Field-theoretic absolute Galois group available
  (`FieldTheory.AbsoluteGaloisGroup`). -/
  hasAbsoluteGaloisGroupImportsToy : Prop
  /-- Module-level restriction of scalars available
  (`Algebra.Algebra.RestrictScalars`). -/
  hasModuleRestrictScalarsImportsToy : Prop
  /-- Higher-dimensional abelian variety bundle as a Mathlib typeclass. -/
  hasAbelianVarietyBundleToy : Prop
  /-- Complex multiplication structure on abelian varieties. -/
  hasComplexMultiplicationToy : Prop
  /-- Algebraic group / group scheme bundle. -/
  hasAlgebraicGroupBundleToy : Prop
  /-- Algebraic torus / Mumford–Tate group infrastructure. -/
  hasMumfordTateInfrastructureToy : Prop
  /-- Algebraic cycles / Chow groups / correspondences. -/
  hasChowCorrespondenceInfrastructureToy : Prop
  /-- Weil restriction of schemes (NOT module-level RestrictScalars). -/
  hasWeilRestrictionOfSchemesToy : Prop

/-! ## Section 2: current audit instance

All fields below are `True`. To distinguish "imports succeeded" from
"area is absent", consult the documentation comment at the top of this
file (R254 audit findings 2026-05-20):

* `hasSchemeAndMorphismsImportsToy := True` — **imports succeeded**.
* `hasEllipticCurveImportsToy := True` — **imports succeeded**.
* `hasAbsoluteGaloisGroupImportsToy := True` — **imports succeeded**.
* `hasModuleRestrictScalarsImportsToy := True` — **imports succeeded**.
* `hasAbelianVarietyBundleToy := True` — **absent in Mathlib**
  (no `AbelianVariety.lean`; only dim-1 EC is present).
* `hasComplexMultiplicationToy := True` — **absent in Mathlib**.
* `hasAlgebraicGroupBundleToy := True` — **absent in Mathlib**
  (no `AlgebraicGroup.lean` / `GroupScheme.lean`).
* `hasMumfordTateInfrastructureToy := True` — **absent in Mathlib**
  (algebraic torus + MT group both absent).
* `hasChowCorrespondenceInfrastructureToy := True` — **absent in Mathlib**
  (no `Chow*` / `Cycle*` AG files; no `Correspondences*`).
* `hasWeilRestrictionOfSchemesToy := True` — **absent in Mathlib**
  (only module-level `RestrictScalars` available).

The Prop-marker convention is that `True` means "marker was set"; the
actual finding is documented above and in section 4 below. -/

def MTCorrespondenceMathlibAuditToySkeleton_current :
    MTCorrespondenceMathlibAuditToySkeleton where
  hasSchemeAndMorphismsImportsToy := True
  hasEllipticCurveImportsToy := True
  hasAbsoluteGaloisGroupImportsToy := True
  hasModuleRestrictScalarsImportsToy := True
  hasAbelianVarietyBundleToy := True
  hasComplexMultiplicationToy := True
  hasAlgebraicGroupBundleToy := True
  hasMumfordTateInfrastructureToy := True
  hasChowCorrespondenceInfrastructureToy := True
  hasWeilRestrictionOfSchemesToy := True

/-! ## Section 3: per-area marker Props for MISSING items -/

/-- **R254 marker**: A higher-dimensional `AbelianVariety` bundle is
ABSENT from Mathlib. Only the dim-1 case (`EllipticCurve.*`) is
present. -/
def AuditMissing_AbelianVarietyBundle : Prop := True

/-- **R254 marker**: A `ComplexMultiplication` structure on abelian
varieties is ABSENT from Mathlib. -/
def AuditMissing_ComplexMultiplicationStructure : Prop := True

/-- **R254 marker**: An `End⁰(A) ⊗ ℚ` style endomorphism-algebra API
for abelian varieties is ABSENT. (`CategoryTheory.Endomorphism` is the
generic categorical notion, not the abelian-variety endomorphism
algebra.) -/
def AuditMissing_AbelianVarietyEndomorphismAlgebra : Prop := True

/-- **R254 marker**: A `GroupScheme` / `AlgebraicGroup` bundled
typeclass is ABSENT from Mathlib. -/
def AuditMissing_AlgebraicGroupBundle : Prop := True

/-- **R254 marker**: An algebraic-torus (as algebraic group)
infrastructure is ABSENT. `MeasureTheory.Integral.TorusIntegral` is
unrelated. -/
def AuditMissing_AlgebraicTorus : Prop := True

/-- **R254 marker**: A `MumfordTate` group construction is ABSENT
from Mathlib (outside of our local
`HodgeReduction.Infrastructure.HodgeStructure.MumfordTate` toy
namespace). -/
def AuditMissing_MumfordTateGroupModule : Prop := True

/-- **R254 marker**: `Chow` groups / `AlgebraicCycle` API in
`AlgebraicGeometry` is ABSENT. -/
def AuditMissing_ChowGroupModule : Prop := True

/-- **R254 marker**: `AlgebraicCorrespondence` (degree-graded) / Chow
correspondences API is ABSENT. -/
def AuditMissing_AlgebraicCorrespondenceModule : Prop := True

/-- **R254 marker**: `WeilRestriction` of schemes is ABSENT.
`Algebra.Algebra.RestrictScalars` is module-level only. -/
def AuditMissing_WeilRestrictionOfSchemes : Prop := True

/-- **R254 marker**: A `Motive` / motivic category bundle is ABSENT
from Mathlib. -/
def AuditMissing_MotiveCategory : Prop := True

/-- **R254 marker**: `Albanese` / `PicardScheme` of a variety are
ABSENT (the `Picard*` hits in Mathlib are Picard–Lindelöf for ODEs,
unrelated). -/
def AuditMissing_AlbanesePicardScheme : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R254 non-closure (1/5)**: does NOT construct real CM abelian
varieties. -/
theorem R254_does_not_construct_CMAbelianVariety : True := trivial

/-- **R254 non-closure (2/5)**: does NOT construct real algebraic
correspondences. -/
theorem R254_does_not_construct_real_AlgebraicCorrespondences : True := trivial

/-- **R254 non-closure (3/5)**: does NOT construct real Mumford–Tate
groups. -/
theorem R254_does_not_construct_real_MumfordTate : True := trivial

/-- **R254 non-closure (4/5)**: does NOT replace
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R254_does_not_replace_mtCorrespondencePackage : True := trivial

/-- **R254 non-closure (5/5)**: is an import audit only. No new
mathematical content beyond audit marker data. -/
theorem R254_is_import_audit_only : True := trivial

end MTCorrespondenceMathlibAudit
end HCGapL4
end HodgeReduction
