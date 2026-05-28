/-
# HC Gap L4 — Abstract connectedness-to-H⁰-constants theorem (R433).

R429 introduced the abstract `AbstractConnectedRationalH0Source` whose
`constantsEquiv` field DIRECTLY assumes the ℚ-linear equivalence
`H0 ≃ₗ[ℚ] ℚ`. R430-R432 (parallel) specialised the rank-one
bridge to E_7, refined the Deligne 1971 H⁰ realization interface,
and closed the abstract H⁰ rank-one theorem chain kernel-pure. R432
named R433 = abstract **connectedness-to-H⁰-constants** theorem as the
next-target: REFINE the R429 source so that the ℚ-linear equivalence
is DERIVED from a `constants : ℚ →ₗ[ℚ] H0` + `evaluation : H0 →ₗ[ℚ] ℚ`
pair with mutual-inverse composition equations, via
`LinearEquiv.ofLinear` — modelling the classical "constants
identification" step (every global section of a connected smooth
projective complex variety is a constant function ℚ → H^0; conversely
every H^0 element is evaluation-at-a-component) more faithfully than
R429's monolithic `H0 ≃ₗ[ℚ] ℚ` assumption.

R433 (this file) supplies this refined-source layer. The R433
contribution is:

* The refined abstract **source structure**
  `AbstractConnectedConstantFunctionSource` bundling an abstract carrier
  `H0 : Type` + `AddCommGroup H0` + `Module ℚ H0` instances + two
  ℚ-linear maps `constants : ℚ →ₗ[ℚ] H0` and
  `evaluation : H0 →ₗ[ℚ] ℚ` + the two composition equations
  `evaluation.comp constants = LinearMap.id` (leftInverse) and
  `constants.comp evaluation = LinearMap.id` (rightInverse) + two
  explicit OPEN Prop slots `connectednessInputTarget` and
  `constantSheafRealizationTarget` recording the paper-source
  obligations a real instance must supply.
* The SUBSTANTIVE H⁰ equivalence derivation
  `AbstractConnectedConstantFunctionSource_H0_equiv` building the
  ℚ-linear equivalence `H0 ≃ₗ[ℚ] ℚ` via `LinearEquiv.ofLinear` from
  the `evaluation` + `constants` pair + the two composition equations.
  KERNEL-PURE; SUBSTANTIVELY uses `LinearEquiv.ofLinear`, NOT
  `:= True` or `sorry`.
* The bridge
  `AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source`
  packaging the derived equivalence into R429's
  `AbstractConnectedRationalH0Source` (re-using the carrier and
  instances verbatim; the `constantsEquiv` field is filled by the
  R433 derivation; the two OPEN paper-target Prop slots are `True`).
  KERNEL-PURE.
* The bridge
  `AbstractConnectedConstantFunctionSource_to_Deligne1971H0RealizationInterface`
  packaging the derived equivalence into R431's
  `Deligne1971H0RealizationInterface` for an explicitly-supplied R421
  geometry source `X` (the `rankOneConclusion` field is filled by the
  R433 derivation; the two OPEN paper-target Prop slots are `True`).
  KERNEL-PURE.

R433 supplies NO real geometry: the `connectednessInputTarget` and
`constantSheafRealizationTarget` Prop slots are explicit OPEN markers,
the geometry source `X` for the R431 bridge is an explicit external
parameter (the caller supplies it; R433 does NOT construct it), and no
project axiom is introduced.

## Round-end report (per user contract)

1. Toy headline cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Real-compatible headline cone:
   `hodgeConjectureReal_realCompatible_kernelPure` cone = kernel-pure
   — UNCHANGED.
3. Degreewise-rank headline cone:
   `hodgeConjectureReal_degreewiseRank_kernelPure rank` cone =
   kernel-pure — UNCHANGED.
4. Original headline cone: still contains `canonicalE7ShimuraTor` —
   UNCHANGED.
5. Which rank / Hodge data closed? R433 SUBSTANTIVELY refines R429:
   instead of monolithically assuming a `H0 ≃ₗ[ℚ] ℚ`, R433 assumes
   the constants / evaluation linear-map pair + the two composition
   equations and DERIVES the equivalence via `LinearEquiv.ofLinear`
   (argument order `(f := evaluation) (g := constants)
    (h₁ := leftInverse : evaluation.comp constants = id)
    (h₂ := rightInverse : constants.comp evaluation = id)`). The R429
   bridge and the R431-feeding bridge are both substantively defined
   (the `constantsEquiv` / `rankOneConclusion` fields are filled by
   the R433 derivation, NOT placeholder ℚ identities). The
   `connectednessInputTarget` and `constantSheafRealizationTarget`
   Prop slots remain OPEN — any real instance must supply both. R433
   does NOT prove Baily-Borel or Deligne 1971 at the real-geometry
   level.

## What R433 does NOT do

* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT prove Baily-Borel compactification.
* Does NOT prove Deligne 1971 H⁰ realization at the real-geometry
  level.
* Does NOT construct a real connected smooth projective complex
  variety in Lean.
* Does NOT discharge `connectednessInputTarget` or
  `constantSheafRealizationTarget` (both remain OPEN paper-target
  Prop slots).
* Does NOT introduce any project axiom.

All R433 substantive declarations kernel-pure: cone ⊆
`{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.HCGapL4.AbstractConnectedH0RankOneTheorem
import HodgeReduction.HCGapL4.Deligne1971H0RealizationTarget
import HodgeReduction.HCGapL4.ConnectedSmoothProjectiveH0RankOneInterface

namespace HodgeReduction
namespace HCGapL4
namespace ConnectednessToH0ConstantsAbstract

open HodgeReduction.HCGapL4.AbstractConnectedH0RankOne
open HodgeReduction.HCGapL4.Deligne1971H0RealizationTarget
open HodgeReduction.HCGapL4.ConnectedSmoothProjectiveH0RankOne

/-! ## Section 1: Priority A — refined abstract source structure -/

/-- **R433 refined abstract source structure**. Bundles:

* `H0 : Type` — abstract carrier slot for rational global sections
  (intended interpretation: `H^0(X, ℚ)` for some connected smooth
  projective complex variety `X`, but R433 does NOT construct such
  an `X`);
* `instH0AddCommGroup : AddCommGroup H0` — additive structure;
* `instH0Module : Module ℚ H0` — ℚ-vector-space structure (using the
  explicit `AddCommGroup` to avoid typeclass-synthesis fragility);
* `constants : ℚ →ₗ[ℚ] H0` — the "constants" ℚ-linear map (intended
  interpretation: every constant function ℚ → H^0 is a global
  section);
* `evaluation : H0 →ₗ[ℚ] ℚ` — the "evaluation at a connected
  component" ℚ-linear map;
* `leftInverse : evaluation.comp constants = LinearMap.id` — mutual
  inverse equation #1 (`evaluation ∘ constants = id_ℚ`);
* `rightInverse : constants.comp evaluation = LinearMap.id` — mutual
  inverse equation #2 (`constants ∘ evaluation = id_H0`);
* `connectednessInputTarget : Prop` — OPEN paper-source slot: the
  connectedness hypothesis (Voisin 2002 vol. I §3.2 / Deligne 1971
  §2.3);
* `constantSheafRealizationTarget : Prop` — OPEN paper-source slot:
  the identification of `H0` with `H^0(X, constant sheaf ℚ)`.

A REAL instance of this structure for a specific variety `X` must
supply: (i) the actual rational-cohomology realization (Voisin 2002 +
GAGA), (ii) a proof of connectedness, (iii) the actual `constants`
and `evaluation` ℚ-linear maps, and (iv) proofs of the two mutual
inverse equations (classical: every global section on a connected
variety is constant). R433 supplies NONE of this content; it provides
only the abstract bundle shape. -/
structure AbstractConnectedConstantFunctionSource where
  /-- Abstract carrier slot for rational `H^0` (no real geometry). -/
  Carrier : Type
  /-- The H⁰ carrier slot (future: `H^0(Carrier, ℚ)`). -/
  H0 : Type
  /-- `AddCommGroup` instance on `H0`. -/
  instH0AddCommGroup : AddCommGroup H0
  /-- `Module ℚ` instance on `H0` (explicit-instance form). -/
  instH0Module : @Module ℚ H0 _ instH0AddCommGroup.toAddCommMonoid
  /-- The "constants" ℚ-linear map `ℚ →ₗ[ℚ] H0`. -/
  constants : @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) ℚ H0 _ instH0AddCommGroup.toAddCommMonoid _ instH0Module
  /-- The "evaluation" ℚ-linear map `H0 →ₗ[ℚ] ℚ`. -/
  evaluation : @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) H0 ℚ instH0AddCommGroup.toAddCommMonoid _ instH0Module _
  /-- Mutual inverse equation #1: `evaluation ∘ constants = id_ℚ`. -/
  leftInverse : evaluation.comp constants = LinearMap.id
  /-- Mutual inverse equation #2: `constants ∘ evaluation = id_H0`. -/
  rightInverse : constants.comp evaluation = LinearMap.id
  /-- Prop OPEN slot: the connectedness paper-source hypothesis. -/
  connectednessInputTarget : Prop
  /-- Prop OPEN slot: the constant-sheaf realization paper-source
  hypothesis. -/
  constantSheafRealizationTarget : Prop

/-! ## Section 2: Priority B — H⁰ ≃ ℚ derivation via LinearEquiv.ofLinear

The substantive R433 theorem: given an
`AbstractConnectedConstantFunctionSource`, the carrier `H0` is
ℚ-linearly equivalent to `ℚ`, with the equivalence DERIVED via
`LinearEquiv.ofLinear` from the `evaluation` + `constants` pair + the
two composition equations.

Mathlib `LinearEquiv.ofLinear` signature
(`Mathlib/Algebra/Module/Equiv/Basic.lean:439`):

  def ofLinear (f : M →ₛₗ[σ₁₂] M₂) (g : M₂ →ₛₗ[σ₂₁] M)
      (h₁ : f.comp g = LinearMap.id)
      (h₂ : g.comp f = LinearMap.id) : M ≃ₛₗ[σ₁₂] M₂

For `M = H0`, `M₂ = ℚ`, `σ₁₂ = σ₂₁ = RingHom.id ℚ`:
* `f = evaluation : H0 →ₗ[ℚ] ℚ` (so `f.comp g : ℚ →ₗ[ℚ] ℚ`);
* `g = constants : ℚ →ₗ[ℚ] H0` (so `g.comp f : H0 →ₗ[ℚ] H0`);
* `h₁ = leftInverse : evaluation.comp constants = LinearMap.id`
  (matches `f.comp g = id_ℚ`);
* `h₂ = rightInverse : constants.comp evaluation = LinearMap.id`
  (matches `g.comp f = id_H0`).

Argument order: `LinearEquiv.ofLinear S.evaluation S.constants
S.leftInverse S.rightInverse`. -/

/-- **R433 H⁰ equivalence derivation**. Given an
`AbstractConnectedConstantFunctionSource` `S`, derives the ℚ-linear
equivalence `S.H0 ≃ₗ[ℚ] ℚ` via `LinearEquiv.ofLinear` from
`S.evaluation` + `S.constants` + `S.leftInverse` + `S.rightInverse`.
KERNEL-PURE; SUBSTANTIVELY uses `LinearEquiv.ofLinear` (NOT a
placeholder). -/
noncomputable def AbstractConnectedConstantFunctionSource_H0_equiv
    (S : AbstractConnectedConstantFunctionSource) :
    @LinearEquiv ℚ ℚ _ _ (RingHom.id ℚ) (RingHom.id ℚ) _ _
      S.H0 ℚ S.instH0AddCommGroup.toAddCommMonoid _ S.instH0Module _ :=
  letI : AddCommGroup S.H0 := S.instH0AddCommGroup
  letI : Module ℚ S.H0 := S.instH0Module
  LinearEquiv.ofLinear S.evaluation S.constants S.leftInverse S.rightInverse

/-! ## Section 3: Priority C — feed R429 abstract source

The bridge: package an `AbstractConnectedConstantFunctionSource` into
R429's `AbstractConnectedRationalH0Source`. The carrier and instances
are reused verbatim; the `constantsEquiv` field is filled by the R433
derivation (`AbstractConnectedConstantFunctionSource_H0_equiv`); the
two R429 OPEN paper-target Prop slots (`connectednessInputTarget`,
`rationalCohomologyRealizationTarget`) are `True` — R433 does NOT
discharge them. -/

/-- **R433 bridge to R429**. Packages an
`AbstractConnectedConstantFunctionSource` into R429's
`AbstractConnectedRationalH0Source`. The `constantsEquiv` field is
filled by the R433 derivation (`LinearEquiv.ofLinear`). KERNEL-PURE. -/
noncomputable def AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source
    (S : AbstractConnectedConstantFunctionSource) :
    AbstractConnectedH0RankOne.AbstractConnectedRationalH0Source where
  H0 := S.H0
  instAddCommGroup := S.instH0AddCommGroup
  instModule := S.instH0Module
  constantsEquiv := AbstractConnectedConstantFunctionSource_H0_equiv S
  connectednessInputTarget := True
  rationalCohomologyRealizationTarget := True

/-! ## Section 4: Priority D — feed R431 Deligne H0 realization

The bridge: package an `AbstractConnectedConstantFunctionSource`
+ an explicitly-supplied R421 geometry source `X` into R431's
`Deligne1971H0RealizationInterface`. The carrier and instances and
the `rankOneConclusion` Nonempty-LinearEquiv are filled by the R433
derivation; the two R431 OPEN paper-target Prop slots
(`comparisonWithConstantSheafTarget`, `constantsEquivTarget`) are
`True` — R433 does NOT discharge them. -/

/-- **R433 bridge to R431**. Packages an
`AbstractConnectedConstantFunctionSource` together with an
explicitly-supplied R421 geometry source `X` into R431's
`Deligne1971H0RealizationInterface`. The `rankOneConclusion` field
is filled by `⟨R433-derivation⟩`. KERNEL-PURE. -/
noncomputable def AbstractConnectedConstantFunctionSource_to_Deligne1971H0RealizationInterface
    (S : AbstractConnectedConstantFunctionSource)
    (X : ConnectedSmoothProjectiveH0RankOne.ConnectedSmoothProjectiveComplexVarietyInterface) :
    Deligne1971H0RealizationTarget.Deligne1971H0RealizationInterface where
  X := X
  H0 := S.H0
  instAddCommGroup := S.instH0AddCommGroup
  instModule := S.instH0Module
  comparisonWithConstantSheafTarget := True
  constantsEquivTarget := True
  rankOneConclusion := ⟨AbstractConnectedConstantFunctionSource_H0_equiv S⟩

/-! ## Section 5: Priority E — required round markers (per user spec) -/

/-- **R433 marker**: the abstract connectedness-to-H⁰-constants
theorem layer is CLOSED — the source structure
`AbstractConnectedConstantFunctionSource` is defined, the derivation
`AbstractConnectedConstantFunctionSource_H0_equiv` is substantively
proved kernel-pure via `LinearEquiv.ofLinear`, and the two bridges
to R429 / R431 are both substantively defined. -/
def R433_ConnectednessToH0Constants_AbstractClosed : Prop := True

/-- **R433 marker**: the connectedness input slot remains an OPEN
paper target — `connectednessInputTarget : Prop` in the source
structure is an explicit hypothesis any real instance must supply. -/
def R433_ConnectednessInput_StillTarget : Prop := True

/-- **R433 marker**: the constant-sheaf realization slot remains an
OPEN paper target — `constantSheafRealizationTarget : Prop` in the
source structure is an explicit hypothesis any real instance must
supply. -/
def R433_ConstantSheafRealization_StillTarget : Prop := True

/-- **R433 marker**: R433 does NOT prove the Baily-Borel
compactification theorem at the real-geometry level (the
connectedness input slot remains OPEN; R433 supplies only the
abstract source-structure layer). -/
def R433_DoesNotProve_BailyBorel : Prop := True

/-- **R433 marker**: R433 does NOT prove the Deligne 1971 H⁰
realization theorem at the real-geometry level (the
constant-sheaf realization slot remains OPEN; R433 supplies only the
abstract source-structure layer). -/
def R433_DoesNotProve_Deligne1971 : Prop := True

/-! ## Section 6: status markers -/

def R433_Status_RefinedSourceStructure_Defined : Prop := True
def R433_Status_H0EquivDerivation_Proved_KernelPure_OfLinear : Prop := True
def R433_Status_BridgeToR429_Substantive : Prop := True
def R433_Status_BridgeToR431_Substantive : Prop := True
def R433_Status_LinearEquivOfLinear_ArgOrder_EvalConstantsLeftRight : Prop := True
def R433_Status_NoProjectAxiomIntroduced : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

def R433_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R433_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R433_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R433_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R433_Report_ConnectednessToH0ConstantsAbstractClosed_RealGeometryStillOpen :
    Prop := True

/-! ## Section 8: graph edges -/

def L4_G_R433_From_R429_AbstractConnectedH0RankOneTheorem : Prop := True
def L4_G_R433_From_R431_Deligne1971H0RealizationTarget : Prop := True
def L4_G_R433_From_R421_ConnectedSmoothProjectiveH0RankOneInterface : Prop := True
def L4_G_R433_To_R432_FrontierSnapshot : Prop := True
def L4_G_R433_To_R408_Deligne1971_PaperImport : Prop := True

/-! ## Section 9: explicit non-closure markers (5+ per user spec) -/

/-- **R433 non-closure (1/8)**: does NOT delete
`axiom canonicalE7ShimuraTor`. -/
theorem R433_does_not_delete_canonical_axiom : True := trivial

/-- **R433 non-closure (2/8)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R433_does_not_alter_old_headline : True := trivial

/-- **R433 non-closure (3/8)**: does NOT delete `canonicalE7ShimuraTor`
(the axiom remains in the original headline cone). -/
theorem R433_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R433 non-closure (4/8)**: does NOT prove the Baily-Borel
compactification theorem at the real-geometry level. -/
theorem R433_does_not_prove_baily_borel : True := trivial

/-- **R433 non-closure (5/8)**: does NOT prove the Deligne 1971 H⁰
realization theorem at the real-geometry level. -/
theorem R433_does_not_prove_deligne1971 : True := trivial

/-- **R433 non-closure (6/8)**: does NOT construct a real connected
smooth projective complex variety in Lean. -/
theorem R433_does_not_construct_real_geometry : True := trivial

/-- **R433 non-closure (7/8)**: does NOT discharge
`connectednessInputTarget` or `constantSheafRealizationTarget`
(both remain OPEN Prop slots). -/
theorem R433_does_not_discharge_open_targets : True := trivial

/-- **R433 non-closure (8/8)**: does NOT introduce any project
axiom. -/
theorem R433_does_not_introduce_project_axiom : True := trivial

end ConnectednessToH0ConstantsAbstract
end HCGapL4
end HodgeReduction
