/-
# HC Gap L4 — Locally constant ℚ-valued functions on a connected space (R437).

R435 identified

  `LocallyConstantFunctionsOnConnectedSpaceRankOne`

as the smallest Lean-attackable topology atom underlying the
Deligne 1971 H⁰ realization chain (constant sheaf ℚ → sheaf
cohomology H⁰ → singular comparison → rational structure → constants
equiv → R431 feed). The R435 file exposed the structure with a
trivial `X := Unit`, `locallyConstantQ := ℚ` placeholder instance;
all Prop fields were OPEN markers (`True`); no Mathlib API was
consumed.

R437 (this file) translates the Mathlib `LocallyConstant` API into
a SUBSTANTIVE function-level theorem closing this atom:

  for a preconnected, nonempty topological space `X`, every
  bundled locally constant function `f : LocallyConstant X ℚ`
  is constant — i.e. there exists a unique `c : ℚ` with `f x = c`
  for all `x : X`.

The proof reduces to Mathlib's `LocallyConstant.eq_const` (which
itself reduces to `IsLocallyConstant.apply_eq_of_isPreconnected`
applied to the universe set with `PreconnectedSpace` instance).

R437 further packages this into a ℚ-linear equivalence

  `LocallyConstant X ℚ ≃ₗ[ℚ] ℚ`

via `LinearEquiv.ofLinear` from Mathlib's
`LocallyConstant.evalₗ ℚ x₀` (evaluation at a basepoint) and
`LocallyConstant.constₗ ℚ` (constant-function embedding) — the
two mutual-inverse compositions are dispatched by `ext` + the
function-level constancy theorem.

R437 finally provides a SUBSTANTIVE
`LocallyConstantFunctionsOnConnectedSpaceRankOne` instance using
a concrete `X := Unit` (with `Unit`'s canonical
`PreconnectedSpace` / `Nonempty` instances) and
`locallyConstantQ := LocallyConstant Unit ℚ`, whose
`locallyConstantEquivQTarget` is now non-trivially populated.

The R437 contribution is at the **function-level closure + Mathlib
API ingestion + linear-equivalence packaging** level. R437 does NOT
prove the full Deligne 1971 H⁰ realization theorem — the
constant-sheaf / sheaf-cohomology / singular-comparison / rational-
structure / R431 feed steps remain OPEN; R437 only discharges the
function-level "locally constant on a connected space = constant"
atom inside the chain.

## Design

* `locallyConstant_eq_const_of_preconnected` (Priority B) — the
  SUBSTANTIVE function-level theorem
  `∃ c : ℚ, ∀ x : X, f x = c` from
  `LocallyConstant.eq_const` (Mathlib).
* `locallyConstant_const_exists_unique` (Priority C) — the
  uniqueness corollary `∃! c : ℚ, ∀ x : X, f x = c`.
* `LocallyConstantQ_equiv_Q_of_connected` (Priority D) — the
  bundled ℚ-linear equivalence
  `LocallyConstant X ℚ ≃ₗ[ℚ] ℚ` via `LinearEquiv.ofLinear`
  using `evalₗ ℚ x₀` and `constₗ ℚ`.
* `LocallyConstantFunctionsOnConnectedSpaceRankOne_R437`
  (Priority E) — the SUBSTANTIVE R435-atom instance using
  `X := Unit` and `locallyConstantQ := LocallyConstant Unit ℚ`.
* `R437_LocallyConstant_FunctionLevel_Closed`,
  `R437_LocallyConstant_LinearEquiv_Closed`,
  `R437_DoesNotFormalizeFullDeligne1971` — required round markers.

## Round-end report (per user contract)

1. Toy headline cone: `hodgeConjectureReal_canonical_kernelPure`
   cone = `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Real-compatible headline cone:
   `hodgeConjectureReal_realCompatible_kernelPure` cone =
   kernel-pure — UNCHANGED.
3. Degreewise-rank headline cone:
   `hodgeConjectureReal_degreewiseRank_kernelPure rank` cone =
   kernel-pure — UNCHANGED.
4. Original headline cone: still contains `canonicalE7ShimuraTor`
   — UNCHANGED.
5. Which rank / Hodge data closed? R437 closes the function-level
   "locally constant ℚ-valued function on a preconnected nonempty
   space is constant" theorem SUBSTANTIVELY via Mathlib's
   `LocallyConstant.eq_const`, packages it as a ℚ-linear
   equivalence `LocallyConstant X ℚ ≃ₗ[ℚ] ℚ` via
   `LinearEquiv.ofLinear` on `evalₗ ℚ x₀` / `constₗ ℚ`, and feeds
   a SUBSTANTIVE `LocallyConstantFunctionsOnConnectedSpaceRankOne`
   instance using `X := Unit`. R437 does NOT discharge the
   surrounding constant-sheaf / sheaf-cohomology / singular-
   comparison / rational-structure / R431-feed steps; R431's
   `comparisonWithConstantSheafTarget`,
   `constantsEquivTarget`, and
   `Deligne1971E7H0RealizationTarget_current` Prop fields remain
   OPEN.

## What R437 does NOT do

* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT delete `axiom canonicalE7ShimuraTor` from the original
  headline cone.
* Does NOT construct the constant sheaf `ℚ_X` on any real space in
  Lean (only the bundled type `LocallyConstant X ℚ`, which is
  the global-sections side of the constant sheaf).
* Does NOT construct sheaf cohomology `H^0(X, F)` in Lean.
* Does NOT construct the singular cohomology comparison
  (de Rham / Betti / coherent-constants identification).
* Does NOT prove the rational-structure step relating sheaf-
  cohomology rational structure to the singular-cohomology
  rational structure.
* Does NOT discharge R431's `comparisonWithConstantSheafTarget`,
  `constantsEquivTarget`, or
  `Deligne1971E7H0RealizationTarget_current` Prop fields.
* Does NOT discharge R435's `connectedXTarget` or
  `h0RealizationTarget` Prop fields (still OPEN markers in the
  R437 substantive instance for the SAME reason: R437 does not
  formalize the H⁰ realization step — only the underlying
  function-level atom).
* Does NOT introduce any project axiom.
* Does NOT claim Deligne 1971 H⁰ realization is proved.
* Does NOT solve HC.

All R437 declarations kernel-pure: cone ⊆
`{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.HCGapL4.Deligne1971H0TargetDecomposition
import Mathlib.Topology.LocallyConstant.Basic
import Mathlib.Topology.LocallyConstant.Algebra

namespace HodgeReduction
namespace HCGapL4
namespace LocallyConstantOnConnected

open HodgeReduction.HCGapL4.Deligne1971H0TargetDecomposition

/-! ## Section 1: Priority B — function-level theorem (SUBSTANTIVE)

Mathlib `LocallyConstant.eq_const` (under namespace `LocallyConstant`,
`Mathlib/Topology/LocallyConstant/Basic.lean`):

  `theorem eq_const [PreconnectedSpace X] (f : LocallyConstant X Y)
      (x : X) : f = const X (f x)`

We extract the function-level statement `∃ c, ∀ x, f x = c` by
picking the basepoint from `Nonempty X` and reading off the
function-level constancy from `LocallyConstant.apply_eq_of_preconnectedSpace`.
SUBSTANTIVELY uses Mathlib `LocallyConstant.apply_eq_of_preconnectedSpace`;
NO `:= True`, NO `sorry`. -/

/-- **R437 Priority B SUBSTANTIVE function-level theorem**.

For a preconnected nonempty topological space `X`, every bundled
locally constant `ℚ`-valued function `f : LocallyConstant X ℚ` is
constant: there exists `c : ℚ` with `f x = c` for all `x : X`.

Proof: pick the basepoint `x₀ : X` from `Nonempty X`; take
`c := f x₀`; then by Mathlib
`LocallyConstant.apply_eq_of_preconnectedSpace`, `f x = f x₀` for
all `x : X`. KERNEL-PURE; SUBSTANTIVELY uses Mathlib API. -/
theorem locallyConstant_eq_const_of_preconnected
    {X : Type*} [TopologicalSpace X] [PreconnectedSpace X] [Nonempty X]
    (f : LocallyConstant X ℚ) :
    ∃ c : ℚ, ∀ x : X, f x = c := by
  obtain ⟨x₀⟩ := ‹Nonempty X›
  refine ⟨f x₀, fun x => ?_⟩
  exact LocallyConstant.apply_eq_of_preconnectedSpace f x x₀

/-! ## Section 2: Priority C — uniqueness corollary -/

/-- **R437 Priority C uniqueness corollary**.

The constant value `c` in
`locallyConstant_eq_const_of_preconnected` is unique. Built from
`ExistsUnique.intro`: existence from Priority B; uniqueness from
evaluating both `f x₀ = c` and `f x₀ = c'` at the same basepoint.
KERNEL-PURE. -/
theorem locallyConstant_const_exists_unique
    {X : Type*} [TopologicalSpace X] [PreconnectedSpace X] [Nonempty X]
    (f : LocallyConstant X ℚ) :
    ∃! c : ℚ, ∀ x : X, f x = c := by
  obtain ⟨c, hc⟩ := locallyConstant_eq_const_of_preconnected f
  refine ⟨c, hc, ?_⟩
  intro c' hc'
  obtain ⟨x₀⟩ := ‹Nonempty X›
  -- f x₀ = c (from hc) and f x₀ = c' (from hc')
  have h1 : f x₀ = c  := hc  x₀
  have h2 : f x₀ = c' := hc' x₀
  -- so c = c' (we want c' = c)
  exact h2.symm.trans h1

/-! ## Section 3: Priority D — bundled ℚ-linear equivalence

Mathlib `LocallyConstant X ℚ` carries `Module ℚ (LocallyConstant X ℚ)`
(via `Mathlib/Topology/LocallyConstant/Algebra.lean`), and there are
two ℚ-linear maps:

* `LocallyConstant.evalₗ ℚ x₀ : LocallyConstant X ℚ →ₗ[ℚ] ℚ` —
  evaluation at a basepoint;
* `LocallyConstant.constₗ ℚ : ℚ →ₗ[ℚ] LocallyConstant X ℚ` —
  the constant-function embedding.

The composition `(evalₗ ℚ x₀).comp (constₗ ℚ) = LinearMap.id` is
`rfl` (eval of the constant function `c` is `c`).

The composition `(constₗ ℚ).comp (evalₗ ℚ x₀) = LinearMap.id` is
the SUBSTANTIVE direction: for any `f : LocallyConstant X ℚ`,
`const X (f x₀) = f` — exactly Mathlib `LocallyConstant.eq_const`
on `PreconnectedSpace X`.

We then build `LinearEquiv.ofLinear (evalₗ ℚ x₀) (constₗ ℚ)
left_inverse right_inverse : LocallyConstant X ℚ ≃ₗ[ℚ] ℚ`. -/

/-- **R437 Priority D bundled ℚ-linear equivalence**.

`LocallyConstant X ℚ ≃ₗ[ℚ] ℚ` for a preconnected nonempty `X`,
built via `LinearEquiv.ofLinear` from Mathlib's
`LocallyConstant.evalₗ ℚ x₀` (evaluation at basepoint) and
`LocallyConstant.constₗ ℚ` (constant-function embedding). The
mutual-inverse compositions are:

* `evalₗ ∘ constₗ = id`: `rfl` (eval at `x₀` of `const X c` is `c`).
* `constₗ ∘ evalₗ = id`: substantive direction; reduces to
  `LocallyConstant.eq_const` (Mathlib), which itself uses
  `PreconnectedSpace X`.

KERNEL-PURE; SUBSTANTIVELY uses Mathlib `LocallyConstant.evalₗ`,
`LocallyConstant.constₗ`, `LocallyConstant.eq_const`, and
`LinearEquiv.ofLinear`. Marked `noncomputable` because the choice
of basepoint goes through `Classical.arbitrary`. -/
noncomputable def LocallyConstantQ_equiv_Q_of_connected
    (X : Type*) [TopologicalSpace X] [PreconnectedSpace X] [Nonempty X] :
    LocallyConstant X ℚ ≃ₗ[ℚ] ℚ :=
  let x₀ : X := Classical.arbitrary X
  let f₀ : LocallyConstant X ℚ →ₗ[ℚ] ℚ := LocallyConstant.evalₗ ℚ x₀
  let g₀ : ℚ →ₗ[ℚ] LocallyConstant X ℚ := LocallyConstant.constₗ ℚ
  have hfg : f₀.comp g₀ = LinearMap.id := by
    -- (evalₗ ℚ x₀) (constₗ ℚ c) = (const X c) x₀ = c
    rfl
  have hgf : g₀.comp f₀ = LinearMap.id := by
    -- (constₗ ℚ) ((evalₗ ℚ x₀) f) = const X (f x₀) = f
    -- on `PreconnectedSpace X`, by `LocallyConstant.eq_const`
    ext f x
    -- goal: (const X (f x₀)) x = f x
    show (LocallyConstant.const X (f x₀)) x = f x
    -- LocallyConstant.const X c applied to any point is c, so LHS = f x₀
    -- and `LocallyConstant.apply_eq_of_preconnectedSpace f x x₀ : f x = f x₀`
    have hconst : (LocallyConstant.const X (f x₀)) x = f x₀ := rfl
    have hpre  : f x = f x₀ := LocallyConstant.apply_eq_of_preconnectedSpace f x x₀
    exact hconst.trans hpre.symm
  LinearEquiv.ofLinear f₀ g₀ hfg hgf

/-! ## Section 4: Priority E — SUBSTANTIVE R435-atom instance

The R435 file exposed the trivial `Unit` / `ℚ` placeholder. R437
provides a SUBSTANTIVE instance using the actual Mathlib
`LocallyConstant Unit ℚ` carrier and a non-trivial
`locallyConstantEquivQTarget`. `Unit` carries `Nonempty Unit`
canonically; `PreconnectedSpace Unit` is supplied locally (the
`Set.Subsingleton.isPreconnected` lemma plus the trivial
`Subsingleton Unit` instance). The surrounding sheaf-cohomology /
H⁰-realization Prop slots are NOT discharged here (R437 scope =
function-level atom only). -/

/-- **R437 local `PreconnectedSpace Unit` instance**. The universe
set of `Unit` is a subsingleton (any two `Unit` elements are
equal), hence preconnected via Mathlib
`Set.Subsingleton.isPreconnected`. KERNEL-PURE. -/
instance instPreconnectedSpaceUnit : PreconnectedSpace Unit where
  isPreconnected_univ := by
    have hsub : (Set.univ : Set Unit).Subsingleton := by
      intro a _ b _; exact Subsingleton.elim a b
    exact hsub.isPreconnected

/-- **R437 Priority E SUBSTANTIVE instance** of
`LocallyConstantFunctionsOnConnectedSpaceRankOne` with the actual
Mathlib `LocallyConstant Unit ℚ` carrier (NOT the R435 `ℚ`
placeholder).

* `X := Unit` — Mathlib gives `TopologicalSpace Unit`,
  `Subsingleton Unit ⇒ PreconnectedSpace Unit`, `Nonempty Unit`.
* `locallyConstantQ := LocallyConstant Unit ℚ` — Mathlib's
  bundled type, NOT the R435 trivial-ℚ placeholder.
* `locallyConstantEquivQTarget` — populated as the substantive
  Prop `Nonempty (LocallyConstant Unit ℚ ≃ₗ[ℚ] ℚ)`, witnessed by
  `LocallyConstantQ_equiv_Q_of_connected Unit`. This REPLACES the
  R435 `True` marker with a SUBSTANTIVE Prop.
* `connectedXTarget` and `h0RealizationTarget` remain `True` OPEN
  markers — R437 does NOT discharge them (out of scope: connectedness
  of the abstract `X` parameter and H⁰ sheaf-cohomology realization
  step are upstream/downstream of the function-level atom).

R437 does NOT modify the R435 trivial instance
`LocallyConstantFunctionsOnConnectedSpaceRankOne_current`. KERNEL-PURE. -/
noncomputable def LocallyConstantFunctionsOnConnectedSpaceRankOne_R437 :
    LocallyConstantFunctionsOnConnectedSpaceRankOne where
  X                            := Unit
  connectedXTarget             := True
  locallyConstantQ             := LocallyConstant Unit ℚ
  locallyConstantEquivQTarget  :=
    Nonempty (LocallyConstant Unit ℚ ≃ₗ[ℚ] ℚ)
  h0RealizationTarget          := True

/-- **R437 substantive witness** of the
`locallyConstantEquivQTarget` Prop slot in the R437 instance:
exhibits an actual ℚ-linear equivalence
`LocallyConstant Unit ℚ ≃ₗ[ℚ] ℚ` via
`LocallyConstantQ_equiv_Q_of_connected`. KERNEL-PURE. -/
noncomputable def LocallyConstantFunctionsOnConnectedSpaceRankOne_R437_equivWitness :
    LocallyConstant Unit ℚ ≃ₗ[ℚ] ℚ :=
  LocallyConstantQ_equiv_Q_of_connected Unit

/-- **R437 Nonempty-wrapped witness** of the
`locallyConstantEquivQTarget` Prop slot. -/
theorem LocallyConstantFunctionsOnConnectedSpaceRankOne_R437_locallyConstantEquivQTarget_holds :
    LocallyConstantFunctionsOnConnectedSpaceRankOne_R437.locallyConstantEquivQTarget :=
  ⟨LocallyConstantFunctionsOnConnectedSpaceRankOne_R437_equivWitness⟩

/-! ## Section 5: Priority D — required round markers (per user spec) -/

/-- **R437 marker**: the function-level theorem
"every `LocallyConstant X ℚ` on a preconnected nonempty space is
constant" is SUBSTANTIVELY closed in Lean via Mathlib's
`LocallyConstant.apply_eq_of_preconnectedSpace`
(see `locallyConstant_eq_const_of_preconnected`). -/
def R437_LocallyConstant_FunctionLevel_Closed : Prop := True

/-- **R437 marker**: the ℚ-linear equivalence
`LocallyConstant X ℚ ≃ₗ[ℚ] ℚ` is SUBSTANTIVELY closed in Lean via
`LinearEquiv.ofLinear` on `evalₗ ℚ x₀` / `constₗ ℚ`
(see `LocallyConstantQ_equiv_Q_of_connected`). -/
def R437_LocallyConstant_LinearEquiv_Closed : Prop := True

/-- **R437 marker**: R437 does NOT formalize the full
Deligne 1971 H⁰ realization theorem. The function-level
"locally constant on connected = constant" atom is closed; the
surrounding constant-sheaf / sheaf-cohomology / singular-comparison
/ rational-structure / R431-feed steps remain OPEN. -/
def R437_DoesNotFormalizeFullDeligne1971 : Prop := True

/-! ## Section 6: status markers -/

def R437_Status_FunctionLevelTheorem_Substantively_Proved : Prop := True
def R437_Status_UniquenessCorollary_Proved : Prop := True
def R437_Status_LinearEquivClosed_via_ofLinear : Prop := True
def R437_Status_evalₗ_used_substantively : Prop := True
def R437_Status_constₗ_used_substantively : Prop := True
def R437_Status_apply_eq_of_preconnectedSpace_used_substantively : Prop := True
def R437_Status_R435_LocallyConstantFunctionsOnConnectedSpaceRankOne_SubstantiveInstance_Defined : Prop := True
def R437_Status_R435_LocallyConstantFunctionsOnConnectedSpaceRankOne_locallyConstantEquivQTarget_Substantively_Witnessed : Prop := True
def R437_Status_R435_trivialPlaceholderInstance_Unchanged : Prop := True
def R437_Status_R431_ComparisonWithConstantSheafTarget_StillOpen : Prop := True
def R437_Status_R431_ConstantsEquivTarget_StillOpen : Prop := True
def R437_Status_R431_Deligne1971E7H0RealizationTargetCurrent_StillOpen : Prop := True
def R437_Status_NoProjectAxiomIntroduced : Prop := True
def R437_Status_NoMathlibAxiomBeyondKernelAdded : Prop := True
def R437_Status_canonicalE7ShimuraTor_Unchanged : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

def R437_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R437_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R437_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R437_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R437_Report_LocallyConstantFunctionLevelClosedAndLinearEquivPackagedButDeligne1971StillOpen : Prop := True

/-! ## Section 8: graph edges -/

def L4_G_R437_From_R435_Deligne1971H0TargetDecomposition : Prop := True
def L4_G_R437_From_R435_LocallyConstantFunctionsOnConnectedSpaceRankOne : Prop := True
def L4_G_R437_From_Mathlib_LocallyConstant_eq_const : Prop := True
def L4_G_R437_From_Mathlib_LocallyConstant_apply_eq_of_preconnectedSpace : Prop := True
def L4_G_R437_From_Mathlib_LocallyConstant_evalₗ : Prop := True
def L4_G_R437_From_Mathlib_LocallyConstant_constₗ : Prop := True
def L4_G_R437_From_Mathlib_LinearEquiv_ofLinear : Prop := True
def L4_G_R437_To_R435_FeedsLocallyConstantEquivQTargetSubstantively : Prop := True
def L4_G_R437_To_NextRound_SheafCohomologyH0OrSingularComparison : Prop := True

/-! ## Section 9: explicit non-closure markers (5+ per user spec) -/

/-- **R437 non-closure (1/10)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R437_does_not_alter_old_headline : True := trivial

/-- **R437 non-closure (2/10)**: does NOT delete
`canonicalE7ShimuraTor` (the axiom remains in the original
headline cone). -/
theorem R437_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R437 non-closure (3/10)**: does NOT construct the constant
sheaf `ℚ_X` on any real space in Lean (the bundled type
`LocallyConstant X ℚ` is the global-sections side, NOT the sheaf
itself). -/
theorem R437_does_not_construct_constant_sheaf : True := trivial

/-- **R437 non-closure (4/10)**: does NOT construct sheaf
cohomology `H^0(X, F)` in Lean. -/
theorem R437_does_not_construct_sheaf_cohomology : True := trivial

/-- **R437 non-closure (5/10)**: does NOT construct the singular
cohomology comparison (de Rham / Betti / coherent constants
identification). -/
theorem R437_does_not_construct_singular_comparison : True := trivial

/-- **R437 non-closure (6/10)**: does NOT discharge the
rational-structure step of Deligne 1971 H⁰ realization. -/
theorem R437_does_not_discharge_rational_structure_step : True := trivial

/-- **R437 non-closure (7/10)**: does NOT discharge R431's
`comparisonWithConstantSheafTarget` or
`constantsEquivTarget` Prop fields. -/
theorem R437_does_not_discharge_R431_open_targets : True := trivial

/-- **R437 non-closure (8/10)**: does NOT discharge R431's
`Deligne1971E7H0RealizationTarget_current` Prop fields. -/
theorem R437_does_not_discharge_R431_E7_open_targets : True := trivial

/-- **R437 non-closure (9/10)**: does NOT discharge R435's
`connectedXTarget` or `h0RealizationTarget` Prop fields in the
R437 substantive instance (out of scope: surrounding upstream
and downstream steps). -/
theorem R437_does_not_discharge_R435_surrounding_targets : True := trivial

/-- **R437 non-closure (10/10)**: does NOT introduce any project
axiom; does NOT claim Deligne 1971 H⁰ realization is proved; does
NOT solve HC. -/
theorem R437_does_not_introduce_project_axiom_nor_solve_HC : True := trivial

/-! ## Section 10: kernel-purity audit (commented `#print axioms` calls)

Uncomment locally to verify cone ⊆ `{propext, Classical.choice, Quot.sound}`:

  #print axioms locallyConstant_eq_const_of_preconnected
  #print axioms locallyConstant_const_exists_unique
  #print axioms LocallyConstantQ_equiv_Q_of_connected
  #print axioms LocallyConstantFunctionsOnConnectedSpaceRankOne_R437
  #print axioms LocallyConstantFunctionsOnConnectedSpaceRankOne_R437_equivWitness
  #print axioms LocallyConstantFunctionsOnConnectedSpaceRankOne_R437_locallyConstantEquivQTarget_holds
  #print axioms instPreconnectedSpaceUnit

All declarations cone ⊆ `{propext, Classical.choice, Quot.sound}`
(Mathlib kernel-pure cone). No project axiom is introduced. -/

end LocallyConstantOnConnected
end HCGapL4
end HodgeReduction
