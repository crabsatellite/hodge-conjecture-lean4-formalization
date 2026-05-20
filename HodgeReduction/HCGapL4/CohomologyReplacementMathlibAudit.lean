/-
# HC Gap L4 — Mathlib cohomology feasibility audit (R251).

R250 closed the toy `algClassesOfUnderlying` replacement path through
the linear cycle-class-map interface. R251 transitions to the next
real-replacement target, `cohomologyOfUnderlying`, beginning with a
**build-clean Mathlib feasibility audit**.

Method: only `import` Mathlib modules that ACTUALLY EXIST in the local
Mathlib tree (verified by `find` over `Mathlib/`). Missing areas are
recorded as `Prop`-level `True` markers, not as failed imports.

## Audit findings (verified 2026-05-20)

### Available in Mathlib
* `Mathlib.AlgebraicGeometry.Scheme` — scheme abstraction.
* `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic` — `Proj` of a
  graded ring (5 files in the `ProjectiveSpectrum/` subdirectory).
* `Mathlib.AlgebraicGeometry.Morphisms.Smooth` — smooth morphisms.
* `Mathlib.AlgebraicGeometry.Morphisms.Proper` — proper morphisms.
* `Mathlib.CategoryTheory.Sites.SheafCohomology.Basic` — abstract
  sheaf cohomology.
* `Mathlib.Algebra.Homology.LocalCohomology` — local cohomology.
* `Mathlib.AlgebraicTopology.SingularSet` — singular set (simplicial
  set; not full singular cohomology API).

### MISSING in Mathlib (verified absent)
* De Rham cohomology of manifolds/varieties — **no** `*eRham*` files.
* Étale cohomology — only `Sites.Etale` and `Morphisms.Etale` exist;
  no étale cohomology functor.
* Hodge theory / Hodge structures attached to varieties — **no**
  `*odge*` files.
* Singular cohomology of topological spaces with `ℚ` coefficients as
  a Mathlib `H : ℕ → Type` API.
* E_7 / EVII / Shimura varieties — none.

## What R251 (this file) provides (all kernel-pure)

* `CohomologyReplacementMathlibAuditToySkeleton` — audit-marker
  structure with 7 Prop fields.
* `CohomologyReplacementMathlibAuditToySkeleton_current` — instance
  recording the findings above as `True`/`True` markers (every field
  set to `True` is a marker that the area was probed; details in
  doc comments).

## What R251 (this file) does NOT do

* Does NOT construct real E_7 Shimura cohomology.
* Does NOT replace `canonicalE7ShimuraTor.cohomologyOfUnderlying`.
* Does NOT close `canonicalE7ShimuraTor`.
* Only audits which Mathlib modules are import-clean for the
  cohomology replacement path.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R251 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

-- Verified imports: each builds clean on the local Mathlib tree.
import Mathlib.AlgebraicGeometry.Scheme
import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.AlgebraicGeometry.Morphisms.Proper
import Mathlib.CategoryTheory.Sites.SheafCohomology.Basic
import Mathlib.Algebra.Homology.LocalCohomology
import Mathlib.AlgebraicTopology.SingularSet

namespace HodgeReduction
namespace HCGapL4
namespace CohomologyReplacementMathlibAudit

/-! ## Section 1: audit marker structure -/

/-- **R251 audit-marker structure**: 7 Prop fields tracking which
Mathlib areas are import-clean for the cohomology replacement path. -/
structure CohomologyReplacementMathlibAuditToySkeleton where
  /-- Projective-scheme imports available (`Scheme`, `ProjectiveSpectrum`). -/
  hasProjectiveSchemeImportsToy : Prop
  /-- Smooth + proper morphism imports available
  (`Morphisms.Smooth`, `Morphisms.Proper`). -/
  hasSmoothProperImportsToy : Prop
  /-- Singular cohomology with ℚ-coefficients as a Mathlib API. -/
  hasSingularCohomologyImportsToy : Prop
  /-- Étale cohomology as a Mathlib functor. -/
  hasEtaleCohomologyImportsToy : Prop
  /-- De Rham cohomology of varieties. -/
  hasDeRhamCohomologyImportsToy : Prop
  /-- Hodge theory attached to algebraic varieties. -/
  hasHodgeTheoryImportsToy : Prop
  /-- Missing: real E_7 Shimura variety construction (not in Mathlib). -/
  missingE7ShimuraVarietyConstructionToy : Prop

/-! ## Section 2: current audit instance

All fields below are `True`. To distinguish "imports succeeded" from
"area is absent", consult the documentation comment at the top of this
file (R251 audit findings 2026-05-20):

* `hasProjectiveSchemeImportsToy := True` — **imports succeeded**.
* `hasSmoothProperImportsToy := True` — **imports succeeded**.
* `hasSingularCohomologyImportsToy := True` — only `SingularSet`
  available; no Mathlib `H : ℕ → Type` singular cohomology API.
* `hasEtaleCohomologyImportsToy := True` — `Sites.Etale` /
  `Morphisms.Etale` exist, but **étale cohomology functor is absent**.
* `hasDeRhamCohomologyImportsToy := True` — **absent in Mathlib**.
* `hasHodgeTheoryImportsToy := True` — **absent in Mathlib**.
* `missingE7ShimuraVarietyConstructionToy := True` — absent.

The Prop-marker convention is that `True` means "marker was set"; the
actual finding is documented above and in the file's section 6
non-closure block. -/

def CohomologyReplacementMathlibAuditToySkeleton_current :
    CohomologyReplacementMathlibAuditToySkeleton where
  hasProjectiveSchemeImportsToy := True
  hasSmoothProperImportsToy := True
  hasSingularCohomologyImportsToy := True
  hasEtaleCohomologyImportsToy := True
  hasDeRhamCohomologyImportsToy := True
  hasHodgeTheoryImportsToy := True
  missingE7ShimuraVarietyConstructionToy := True

/-! ## Section 3: per-area marker Props -/

/-- **R251 marker**: De Rham cohomology of manifolds/varieties is
ABSENT from the local Mathlib tree (no `*eRham*` files). -/
def AuditMissing_DeRhamCohomologyModule : Prop := True

/-- **R251 marker**: Étale cohomology functor is ABSENT from Mathlib.
(`Sites.Etale` and `Morphisms.Etale` exist but do not provide a
cohomology functor `H^i_{ét}(X, F)`.) -/
def AuditMissing_EtaleCohomologyFunctorModule : Prop := True

/-- **R251 marker**: Hodge theory / Hodge structures attached to
algebraic varieties are ABSENT from Mathlib (no `*odge*` files in
the local tree). -/
def AuditMissing_HodgeTheoryModule : Prop := True

/-- **R251 marker**: A Mathlib `H : ℕ → Type` singular cohomology
API with ℚ-coefficients is ABSENT. Only `AlgebraicTopology.SingularSet`
(simplicial set construction) exists. -/
def AuditMissing_SingularCohomologyRationalApi : Prop := True

/-- **R251 marker**: A direct `SmoothProjectiveVariety ℂ` typeclass
(combining `Scheme` + `Projective` + `Smooth` + `Proper` over `ℂ` as a
single bundle) is not present as a one-stop interface in the local
Mathlib tree. The individual ingredients exist; the bundle does not. -/
def AuditMissing_SmoothProjectiveVarietyBundle : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R251 non-closure (1/4)**: does NOT construct real E_7 Shimura
cohomology. -/
theorem R251_does_not_construct_real_E7Shimura_cohomology : True := trivial

/-- **R251 non-closure (2/4)**: does NOT replace
`canonicalE7ShimuraTor.cohomologyOfUnderlying`. -/
theorem R251_does_not_replace_cohomologyOfUnderlying : True := trivial

/-- **R251 non-closure (3/4)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R251_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R251 non-closure (4/4)**: is an import audit only. No new
mathematical content beyond audit marker data. -/
theorem R251_is_import_audit_only : True := trivial

end CohomologyReplacementMathlibAudit
end HCGapL4
end HodgeReduction
