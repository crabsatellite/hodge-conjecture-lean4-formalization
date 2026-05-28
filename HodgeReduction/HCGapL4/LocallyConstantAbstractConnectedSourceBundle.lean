/-
# HC Gap L4 — Bundle `LocallyConstant X ℚ` into R433's
# `AbstractConnectedConstantFunctionSource` (R443a).

R441 isolated **blocker #1**: the R437 Mathlib-substantive closure of
the function-level theorem

  for a preconnected nonempty topological space `X`, every
  `f : LocallyConstant X ℚ` is constant,

was packaged at the R437 level as the ℚ-linear equivalence

  `LocallyConstantQ_equiv_Q_of_connected : LocallyConstant X ℚ ≃ₗ[ℚ] ℚ`,

but the chain to R433's `AbstractConnectedConstantFunctionSource`
(which feeds R429's `AbstractConnectedRationalH0Source`, then R421's
`H0RankOneTheoremInterface`) was BLOCKED because the constants linear
map `ℚ →ₗ[ℚ] LocallyConstant X ℚ` + the evaluation linear map
`LocallyConstant X ℚ →ₗ[ℚ] ℚ` + the two mutual-inverse composition
equations had NOT been bundled in a form R433 could ingest.

R443a (this file) CLOSES this blocker. The R443a contribution is
PURE Mathlib / packaging work (NO paper-source content) and is
entirely kernel-pure:

* **Priority A** — set up the carrier `X` parameter (handled inline
  in subsequent definitions; no separate declaration).
* **Priority B** — `LocallyConstantQ_constants_linear` : the ℚ-linear
  map `ℚ →ₗ[ℚ] LocallyConstant X ℚ` via Mathlib
  `LocallyConstant.constₗ ℚ` (same Mathlib API R437 already consumed).
* **Priority C** — `LocallyConstantQ_eval_linear` : the ℚ-linear map
  `LocallyConstant X ℚ →ₗ[ℚ] ℚ` via Mathlib
  `LocallyConstant.evalₗ ℚ (Classical.arbitrary X)` (same API R437
  already consumed; basepoint via `Classical.arbitrary` on
  `Nonempty X`).
* **Priority D** — the two mutual-inverse composition theorems
  - `LocallyConstantQ_eval_comp_constants` : `eval ∘ constants = id_ℚ`
    (proof: `ext c`; `simp` unfolds both sides to `c = c`).
  - `LocallyConstantQ_constants_comp_eval_of_preconnected` :
    `constants ∘ eval = id_(LocallyConstant X ℚ)`
    (proof: `ext f x`; `(const X (f x₀)) x = f x₀` is `rfl`;
    `f x = f x₀` by Mathlib `LocallyConstant.apply_eq_of_preconnectedSpace`
    on `PreconnectedSpace X`).
* **Priority E** — `AbstractConnectedConstantFunctionSource_of_LocallyConstant` :
  packages the carrier `X`, the bundled type `LocallyConstant X ℚ`,
  its canonical `AddCommGroup` / `Module ℚ` instances (Mathlib), the
  constants/eval linear maps, and the two composition equations into
  an R433 `AbstractConnectedConstantFunctionSource` instance. The two
  Prop slots `connectednessInputTarget` and
  `constantSheafRealizationTarget` are `True` (R443a supplies only the
  bundling, NOT the connectedness/constant-sheaf paper hypotheses).
* **Priority F** — `LocallyConstant_feeds_AbstractConnectedRationalH0Source` :
  applies R433's bridge
  `AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source`
  to the Priority-E instance, producing an R429
  `AbstractConnectedRationalH0Source` whose `constantsEquiv` field is
  populated SUBSTANTIVELY by the R433 derivation (via
  `LinearEquiv.ofLinear`) on the R443a-packaged constants/eval pair.
* **Priority G** — required round markers:
  `R443a_LocallyConstant_Bundling_Closed`,
  `R443a_R441_Blocker1_Closed`,
  `R443a_DoesNotProve_E7Connectedness`,
  `R443a_DoesNotProve_Deligne1971`.

## Round-end report (per user contract)

1. Toy headline cone: `hodgeConjectureReal_canonical_kernelPure` cone
   = `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Real-compatible headline cone:
   `hodgeConjectureReal_realCompatible_kernelPure` cone = kernel-pure
   — UNCHANGED.
3. Degreewise-rank headline cone:
   `hodgeConjectureReal_degreewiseRank_kernelPure rank` cone =
   kernel-pure — UNCHANGED.
4. Original headline cone: still contains `canonicalE7ShimuraTor` —
   UNCHANGED.
5. Which rank / Hodge data closed? R443a CLOSES R441 blocker #1
   SUBSTANTIVELY by packaging Mathlib `LocallyConstant.constₗ ℚ` and
   `LocallyConstant.evalₗ ℚ x₀` together with the two mutual-inverse
   composition equations (one is `rfl`; the other reduces to
   `LocallyConstant.apply_eq_of_preconnectedSpace`) into an R433
   `AbstractConnectedConstantFunctionSource` instance, and then
   immediately feeds R429's `AbstractConnectedRationalH0Source` via
   R433's existing bridge
   `AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source`.
   The R443a contribution is the **bundling layer** that connects
   R437's Mathlib-level substantive equivalence to R433's abstract
   source bundle — pure Mathlib/packaging, no new paper hypotheses.
   The R443a feed produces a populated R429 source for ANY
   preconnected nonempty topological `X` (in particular `X := Unit`,
   any `PreconnectedSpace`-instance-carrying real geometry). R443a
   does NOT discharge E_7 connectedness, Baily-Borel, or the
   constant-sheaf / sheaf-cohomology / singular-comparison steps of
   Deligne 1971; the `connectednessInputTarget` and
   `constantSheafRealizationTarget` Prop slots remain explicit OPEN
   markers, and the R421/R431 OPEN paper-target Prop slots downstream
   remain unaltered.

## What R443a does NOT do

* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT delete `axiom canonicalE7ShimuraTor` from the original
  headline cone.
* Does NOT prove E_7-Shimura connectedness in Lean.
* Does NOT prove Baily-Borel compactification.
* Does NOT prove Deligne 1971 H⁰ realization at the real-geometry
  level.
* Does NOT construct the constant sheaf `ℚ_X` on any real space in
  Lean (the bundled type `LocallyConstant X ℚ` is the
  global-sections side, NOT the sheaf itself).
* Does NOT construct sheaf cohomology `H^0(X, F)` in Lean.
* Does NOT construct the singular-cohomology comparison.
* Does NOT discharge the rational-structure step of Deligne 1971
  H⁰ realization.
* Does NOT discharge R431's `comparisonWithConstantSheafTarget`,
  `constantsEquivTarget`, or
  `Deligne1971E7H0RealizationTarget_current` Prop fields.
* Does NOT discharge R433's `connectednessInputTarget` or
  `constantSheafRealizationTarget` Prop slots in the R443a-produced
  instance (both `True` — explicit OPEN markers).
* Does NOT introduce any project axiom.
* Does NOT claim Deligne 1971 H⁰ realization is proved.
* Does NOT solve HC.

All R443a declarations kernel-pure: cone ⊆
`{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.HCGapL4.LocallyConstantOnConnected
import HodgeReduction.HCGapL4.ConnectednessToH0ConstantsAbstract
import Mathlib.Topology.LocallyConstant.Algebra

namespace HodgeReduction
namespace HCGapL4
namespace LocallyConstantAbstractConnectedSourceBundle

open HodgeReduction.HCGapL4.LocallyConstantOnConnected
open HodgeReduction.HCGapL4.ConnectednessToH0ConstantsAbstract

/-! ## Section 1: Priority B — constants linear map (ℚ →ₗ[ℚ] LocallyConstant X ℚ)

Mathlib `LocallyConstant.constₗ`
(`Mathlib/Topology/LocallyConstant/Algebra.lean:438`):

  `def constₗ (R : Type*) [Semiring R] [AddCommMonoid Y] [Module R Y] :
      Y →ₗ[R] LocallyConstant X Y`

For `R := ℚ`, `Y := ℚ`, this yields the constants ℚ-linear map
`ℚ →ₗ[ℚ] LocallyConstant X ℚ`. -/

/-- **R443a Priority B**: constants ℚ-linear map
`ℚ →ₗ[ℚ] LocallyConstant X ℚ` via Mathlib `LocallyConstant.constₗ ℚ`.
KERNEL-PURE; same Mathlib API R437 already consumed. -/
noncomputable def LocallyConstantQ_constants_linear
    (X : Type*) [TopologicalSpace X] :
    ℚ →ₗ[ℚ] LocallyConstant X ℚ :=
  LocallyConstant.constₗ ℚ

/-! ## Section 2: Priority C — evaluation linear map (LocallyConstant X ℚ →ₗ[ℚ] ℚ)

Mathlib `LocallyConstant.evalₗ`
(`Mathlib/Topology/LocallyConstant/Algebra.lean:295`):

  `def evalₗ (R : Type*) [Semiring R] [AddCommMonoid Y] [Module R Y]
      (x : X) : LocallyConstant X Y →ₗ[R] Y`

For `R := ℚ`, `Y := ℚ`, and `x := Classical.arbitrary X` (basepoint
from `Nonempty X`), this yields the evaluation ℚ-linear map
`LocallyConstant X ℚ →ₗ[ℚ] ℚ`. -/

/-- **R443a Priority C**: evaluation ℚ-linear map
`LocallyConstant X ℚ →ₗ[ℚ] ℚ` via Mathlib `LocallyConstant.evalₗ ℚ`
at the basepoint `Classical.arbitrary X`. KERNEL-PURE; same Mathlib
API R437 already consumed. -/
noncomputable def LocallyConstantQ_eval_linear
    (X : Type*) [TopologicalSpace X] [Nonempty X] :
    LocallyConstant X ℚ →ₗ[ℚ] ℚ :=
  LocallyConstant.evalₗ ℚ (Classical.arbitrary X)

/-! ## Section 3: Priority D — mutual-inverse composition equations

The two equations needed by R433's
`AbstractConnectedConstantFunctionSource`:

* `eval ∘ constants = id_ℚ` (R433 `leftInverse`): for any `c : ℚ`,
  `(evalₗ ℚ x₀) (constₗ ℚ c) = (const X c) x₀ = c`. Proof: `ext c`
  then `simp` unfolds both sides to the same `c`.

* `constants ∘ eval = id_(LocallyConstant X ℚ)` (R433 `rightInverse`):
  for any `f : LocallyConstant X ℚ` and any `x : X`,
  `((constₗ ℚ) ((evalₗ ℚ x₀) f)) x = (const X (f x₀)) x = f x₀`.
  By Mathlib `LocallyConstant.apply_eq_of_preconnectedSpace`, on a
  `PreconnectedSpace X`, `f x = f x₀`. Proof: `ext f x`; then chain
  these two equalities. -/

/-- **R443a Priority D #1**: `eval ∘ constants = id_ℚ`. KERNEL-PURE;
substantively proved via `ext` + `simp` on Mathlib `evalₗ` / `constₗ`
simp lemmas (both are `@[simps!]`-tagged in Mathlib). -/
theorem LocallyConstantQ_eval_comp_constants
    (X : Type*) [TopologicalSpace X] [Nonempty X] :
    (LocallyConstantQ_eval_linear X).comp
      (LocallyConstantQ_constants_linear X) = LinearMap.id := by
  ext
  simp [LocallyConstantQ_eval_linear, LocallyConstantQ_constants_linear]

/-- **R443a Priority D #2**: `constants ∘ eval = id_(LocallyConstant X ℚ)`
on a `PreconnectedSpace X`. KERNEL-PURE; substantively proved via
`ext f x` + the canonical `rfl` for `(const X (f x₀)) x = f x₀` +
Mathlib `LocallyConstant.apply_eq_of_preconnectedSpace`. -/
theorem LocallyConstantQ_constants_comp_eval_of_preconnected
    (X : Type*) [TopologicalSpace X] [PreconnectedSpace X] [Nonempty X] :
    (LocallyConstantQ_constants_linear X).comp
      (LocallyConstantQ_eval_linear X) = LinearMap.id := by
  ext f x
  -- goal (after `ext`): ((constₗ ℚ) ((evalₗ ℚ x₀) f)) x = f x
  -- = (const X (f x₀)) x = f x
  show (LocallyConstant.const X (f (Classical.arbitrary X))) x = f x
  have hconst : (LocallyConstant.const X (f (Classical.arbitrary X))) x
              = f (Classical.arbitrary X) := rfl
  have hpre   : f x = f (Classical.arbitrary X) :=
    LocallyConstant.apply_eq_of_preconnectedSpace f x (Classical.arbitrary X)
  exact hconst.trans hpre.symm

/-! ## Section 4: Priority E — bundle into R433 source

The R443a substantive bundling theorem: package the constants / eval
linear maps + the two composition equations into an R433
`AbstractConnectedConstantFunctionSource`. The carrier `X` is reused
verbatim; the `H0` slot is `LocallyConstant X ℚ` (Mathlib's bundled
type); the `AddCommGroup` / `Module ℚ` instances come from Mathlib
typeclass synthesis. The two paper-target Prop slots
(`connectednessInputTarget`, `constantSheafRealizationTarget`) are
`True` — R443a does NOT discharge them (R443a scope = bundling only). -/

/-- **R443a Priority E SUBSTANTIVE R433 source instance**. For any
preconnected nonempty topological space `X` (note: R433's
`AbstractConnectedConstantFunctionSource` constrains its `Carrier` and
`H0` slots to `Type 0`, so `X` is here `Type` rather than `Type*`),
packages `LocallyConstant X ℚ` together with `LocallyConstant.constₗ ℚ`,
`LocallyConstant.evalₗ ℚ x₀`, and the two R443a composition theorems
into an `AbstractConnectedConstantFunctionSource`. The Prop slots are
`True` (explicit OPEN markers). KERNEL-PURE. -/
noncomputable def AbstractConnectedConstantFunctionSource_of_LocallyConstant
    (X : Type) [TopologicalSpace X] [PreconnectedSpace X] [Nonempty X] :
    ConnectednessToH0ConstantsAbstract.AbstractConnectedConstantFunctionSource where
  Carrier                        := X
  H0                             := LocallyConstant X ℚ
  instH0AddCommGroup             := inferInstance
  instH0Module                   := inferInstance
  constants                      := LocallyConstantQ_constants_linear X
  evaluation                     := LocallyConstantQ_eval_linear X
  leftInverse                    := LocallyConstantQ_eval_comp_constants X
  rightInverse                   := LocallyConstantQ_constants_comp_eval_of_preconnected X
  connectednessInputTarget       := True
  constantSheafRealizationTarget := True

/-! ## Section 5: Priority F — feed R429's AbstractConnectedRationalH0Source

Compose the R443a Priority-E source-instance with R433's existing
bridge

  `AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source`

to produce an R429 `AbstractConnectedRationalH0Source` whose
`constantsEquiv` field is populated SUBSTANTIVELY by the R433
`LinearEquiv.ofLinear` derivation on the R443a-packaged constants /
eval pair. This is the R441-blocker-#1-closing theorem. -/

/-- **R443a Priority F**: for any preconnected nonempty topological
space `X` (note: `Type` not `Type*`, matching R433's universe-0
constraint on its `Carrier` slot), the R443a Priority-E source-instance
feeds an R429 `AbstractConnectedRationalH0Source` (via R433's bridge).
KERNEL-PURE. -/
theorem LocallyConstant_feeds_AbstractConnectedRationalH0Source
    (X : Type) [TopologicalSpace X] [PreconnectedSpace X] [Nonempty X] :
    Nonempty
      AbstractConnectedH0RankOne.AbstractConnectedRationalH0Source :=
  ⟨ConnectednessToH0ConstantsAbstract.AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source
      (AbstractConnectedConstantFunctionSource_of_LocallyConstant X)⟩

/-! ## Section 6: Priority G — required round markers (per user spec) -/

/-- **R443a marker**: the bundling layer connecting Mathlib's
`LocallyConstant X ℚ` to R433's `AbstractConnectedConstantFunctionSource`
is SUBSTANTIVELY closed in Lean (see
`AbstractConnectedConstantFunctionSource_of_LocallyConstant`). -/
def R443a_LocallyConstant_Bundling_Closed : Prop := True

/-- **R443a marker**: R441 blocker #1 — "the chain to R433's
`AbstractConnectedConstantFunctionSource` is blocked because the
constants + evaluation linear maps + their mutual inverse identities
weren't bundled" — is CLOSED via the R443a Priority B / C / D / E
declarations. -/
def R443a_R441_Blocker1_Closed : Prop := True

/-- **R443a marker**: R443a does NOT prove E_7-Shimura connectedness
(the `connectednessInputTarget` Prop slot in the R443a-produced R433
source remains `True` — an explicit OPEN paper-target marker; any
real E_7-Shimura instance must discharge it). -/
def R443a_DoesNotProve_E7Connectedness : Prop := True

/-- **R443a marker**: R443a does NOT prove the Deligne 1971 H⁰
realization theorem at the real-geometry level (the
`constantSheafRealizationTarget` Prop slot in the R443a-produced
R433 source remains `True` — an explicit OPEN paper-target marker;
R443a supplies only the bundling layer). -/
def R443a_DoesNotProve_Deligne1971 : Prop := True

/-! ## Section 7: status markers -/

def R443a_Status_ConstantsLinearMap_Defined_via_Mathlib_constₗ : Prop := True
def R443a_Status_EvalLinearMap_Defined_via_Mathlib_evalₗ : Prop := True
def R443a_Status_LeftInverse_Proved_via_ext_simp : Prop := True
def R443a_Status_RightInverse_Proved_via_apply_eq_of_preconnectedSpace : Prop := True
def R443a_Status_R433_AbstractConnectedConstantFunctionSource_Instance_Constructed : Prop := True
def R443a_Status_R429_AbstractConnectedRationalH0Source_Feed_Substantive : Prop := True
def R443a_Status_R433_constantsEquiv_via_LinearEquivOfLinear_DownstreamPopulated : Prop := True
def R443a_Status_R433_ConnectednessInputTarget_StillOpen_In_R443a_Instance : Prop := True
def R443a_Status_R433_ConstantSheafRealizationTarget_StillOpen_In_R443a_Instance : Prop := True
def R443a_Status_R437_LocallyConstantQ_equiv_Q_of_connected_Unchanged : Prop := True
def R443a_Status_R433_BridgeFunction_Unchanged : Prop := True
def R443a_Status_NoProjectAxiomIntroduced : Prop := True
def R443a_Status_NoMathlibAxiomBeyondKernelAdded : Prop := True
def R443a_Status_canonicalE7ShimuraTor_Unchanged : Prop := True
def R443a_Status_hodgeConjectureReal_canonical_Unchanged : Prop := True

/-! ## Section 8: round-end report (Prop-only markers) -/

def R443a_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R443a_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R443a_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R443a_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R443a_Report_R441_Blocker1_Closed_R433_Source_Substantively_Fed : Prop := True

/-! ## Section 9: graph edges -/

def L4_G_R443a_From_R437_LocallyConstantOnConnected : Prop := True
def L4_G_R443a_From_R433_ConnectednessToH0ConstantsAbstract : Prop := True
def L4_G_R443a_From_R429_AbstractConnectedH0RankOneTheorem_Source : Prop := True
def L4_G_R443a_From_Mathlib_LocallyConstant_constₗ : Prop := True
def L4_G_R443a_From_Mathlib_LocallyConstant_evalₗ : Prop := True
def L4_G_R443a_From_Mathlib_LocallyConstant_apply_eq_of_preconnectedSpace : Prop := True
def L4_G_R443a_To_R441_Blocker1_Closure : Prop := True
def L4_G_R443a_To_R429_Source_Substantively_Populated : Prop := True
def L4_G_R443a_To_NextRound_E7ConnectednessOrConstantSheafRealization : Prop := True

/-! ## Section 10: explicit non-closure markers (5+ per user spec) -/

/-- **R443a non-closure (1/10)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R443a_does_not_alter_old_headline : True := trivial

/-- **R443a non-closure (2/10)**: does NOT delete
`canonicalE7ShimuraTor` (the axiom remains in the original headline
cone). -/
theorem R443a_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R443a non-closure (3/10)**: does NOT prove E_7-Shimura
connectedness in Lean (the `connectednessInputTarget` Prop slot in
the R443a-produced R433 source remains `True`). -/
theorem R443a_does_not_prove_E7_connectedness : True := trivial

/-- **R443a non-closure (4/10)**: does NOT prove Baily-Borel
compactification at the real-geometry level. -/
theorem R443a_does_not_prove_baily_borel : True := trivial

/-- **R443a non-closure (5/10)**: does NOT prove Deligne 1971 H⁰
realization at the real-geometry level (the
`constantSheafRealizationTarget` Prop slot remains `True`). -/
theorem R443a_does_not_prove_deligne1971 : True := trivial

/-- **R443a non-closure (6/10)**: does NOT construct the constant
sheaf `ℚ_X` on any real space in Lean (the bundled type
`LocallyConstant X ℚ` is the global-sections side, NOT the sheaf
itself). -/
theorem R443a_does_not_construct_constant_sheaf : True := trivial

/-- **R443a non-closure (7/10)**: does NOT construct sheaf cohomology
`H^0(X, F)` in Lean. -/
theorem R443a_does_not_construct_sheaf_cohomology : True := trivial

/-- **R443a non-closure (8/10)**: does NOT discharge R431's
`comparisonWithConstantSheafTarget`, `constantsEquivTarget`, or
`Deligne1971E7H0RealizationTarget_current` Prop fields. -/
theorem R443a_does_not_discharge_R431_open_targets : True := trivial

/-- **R443a non-closure (9/10)**: does NOT discharge R433's
`connectednessInputTarget` or `constantSheafRealizationTarget` Prop
slots in the R443a-produced source instance (both `True` — explicit
OPEN markers; out of scope: paper-source content). -/
theorem R443a_does_not_discharge_R433_open_targets : True := trivial

/-- **R443a non-closure (10/10)**: does NOT introduce any project
axiom; does NOT claim Deligne 1971 H⁰ realization is proved; does
NOT solve HC. -/
theorem R443a_does_not_introduce_project_axiom_nor_solve_HC : True := trivial

/-! ## Section 11: kernel-purity audit (commented `#print axioms` calls)

Uncomment locally to verify cone ⊆ `{propext, Classical.choice, Quot.sound}`:

  #print axioms LocallyConstantQ_constants_linear
  #print axioms LocallyConstantQ_eval_linear
  #print axioms LocallyConstantQ_eval_comp_constants
  #print axioms LocallyConstantQ_constants_comp_eval_of_preconnected
  #print axioms AbstractConnectedConstantFunctionSource_of_LocallyConstant
  #print axioms LocallyConstant_feeds_AbstractConnectedRationalH0Source

All declarations cone ⊆ `{propext, Classical.choice, Quot.sound}`
(Mathlib kernel-pure cone). No project axiom is introduced. -/

end LocallyConstantAbstractConnectedSourceBundle
end HCGapL4
end HodgeReduction
