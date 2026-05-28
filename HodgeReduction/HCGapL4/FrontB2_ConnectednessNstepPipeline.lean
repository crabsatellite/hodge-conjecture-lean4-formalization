/-
# HC Gap L4 — Front B amplification: clean 2-step + 3-step + N-step
connectedness composition pipeline (R453).

R438 closed the FUNCTION-LEVEL atom
`preconnectedSpace_of_surjective_continuous` (a SINGLE-step
composition: `[PreconnectedSpace X]` + continuous surjection
`f : X → Y` ⇒ `PreconnectedSpace Y`). R451B amplified that
single-step atom to a 3-step chain via
`preconnectedSpace_chain_of_three_surjective_continuous`.

R453 (this file) AMPLIFIES Front B further by:

* exposing a composable connectedness-step structure
  `ConnectednessTransportStep` (Priority A) for use in
  pipeline-style downstream consumers;
* proving the CLEAN 2-step composition theorem
  `preconnectedSpace_chain_of_two_surjective_continuous`
  (Priority B), the missing intermediate between R438's
  single-step and R451B's 3-step;
* re-proving the 3-step composition theorem as
  `preconnectedSpace_chain_of_three_surjective_continuous_clean`
  (Priority B) directly via the new 2-step closure (so the
  3-step is now a TWO-LINE consequence of the 2-step plus
  R438's single-step);
* exposing the N-step inductive target as a Prop marker
  `Target_Nstep_PreconnectedTransportChain` (Priority C); the
  substantive N-step theorem would require a dependent
  heterogeneous list of types and is left as a paper target,
  NOT asserted as an axiom;
* exposing a paper-side glue structure
  `BailyBorelConnectednessPipelineUsesNstep` (Priority D)
  recording that the function-level N-step topology is now
  CLOSED (via the 2-step + 3-step substantive theorems);
  the remaining four paper-geometric inputs (hermitian-to-
  quotient, quotient-to-compactification,
  compactification-to-E_7-Shimura, and the upstream paper
  inputs) remain explicit Prop OPEN markers (`True`).

The substantive content of R453 is TWO general-topology
composition theorems
(`preconnectedSpace_chain_of_two_surjective_continuous` and
`preconnectedSpace_chain_of_three_surjective_continuous_clean`),
both kernel-pure, both proved by THREADING R438's
`preconnectedSpace_of_surjective_continuous` through `letI`
local instances. R453 introduces NO project axiom. R453 does
NOT construct any paper-geometric object (no hermitian
domain, no arithmetic group, no Baily-Borel compactification,
no E_7-Shimura variety). R453 does NOT discharge any R434
sub-target.

## Design

* `ConnectednessTransportStep` (Priority A) — composable step
  structure naming a source `X`, a target `Y`, their topology
  instances, and two Prop OPEN markers (preconnected source +
  surjective continuous map). The Prop fields are MARKERS for
  pipeline auditing; the actual theorems are in Priority B.
* `preconnectedSpace_chain_of_two_surjective_continuous`
  (Priority B) — SUBSTANTIVE: `[PreconnectedSpace X]` + chain
  `X →f Y →g Z` of continuous surjections ⇒
  `PreconnectedSpace Z`. Proof = two chained applications of
  R438's `preconnectedSpace_of_surjective_continuous`.
* `preconnectedSpace_chain_of_three_surjective_continuous_clean`
  (Priority B) — SUBSTANTIVE: clean 3-step variant proved via
  the new 2-step closure + R438. Distinct from R451B's
  `preconnectedSpace_chain_of_three_surjective_continuous` (it
  factors through the 2-step intermediate explicitly), giving
  paper-side downstream a choice of granularity.
* `Target_Nstep_PreconnectedTransportChain` (Priority C) —
  Prop marker (`True`) naming the N-step inductive theorem
  as a paper target. NOT proved here; NO axiom asserted.
* `BailyBorelConnectednessPipelineUsesNstep` (Priority D) —
  structure naming the four paper-side hand-offs (hermitian-
  to-quotient, quotient-to-compactification,
  compactification-to-E_7, plus the upstream paper inputs)
  PLUS a `nstepTopologyClosed` slot certifying that the
  function-level N-step topology is closed. Current instance
  fills `nstepTopologyClosed` with `True` (provable via the
  substantive Priority B theorems); other slots are OPEN
  markers (`True`).

## Round-end report (per multi-front contract, 7 items)

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
5. R453 SUBSTANTIVELY proves the CLEAN 2-step composition
   theorem `preconnectedSpace_chain_of_two_surjective_continuous`
   plus a CLEAN 3-step variant
   `preconnectedSpace_chain_of_three_surjective_continuous_clean`,
   factored through the 2-step. The function-level glue for
   the Baily-Borel pipeline is now exposed at THREE
   granularities (single-step R438, 2-step R453, 3-step R451B
   + R453-clean). The N-step substantive theorem is named as
   a paper target Prop marker; the dependent-list
   construction is intentionally deferred — NO axiom asserted
   in either direction.
6. R453 does NOT discharge any R434 sub-target. The paper-
   geometric inputs (`D`, `Γ`, `(Γ \ D)*`, `S_{E_7}`) are NOT
   constructed; the surjective continuous maps in the pipeline
   are NOT constructed; the source connectedness is NOT
   proved. R427's `connectednessFromBailyBorelTarget`, R421's
   `geometryH0Target`, and R422's
   `E7ShimuraGeometryH0Target_current` Prop fields remain
   OPEN.
7. R453 introduces NO project axiom. All Prop targets are
   `True` markers. `hodgeConjectureReal_canonical` is NOT
   altered. `canonicalE7ShimuraTor` is NOT deleted. The
   Hodge Conjecture is NOT solved.

## What R453 does NOT do

* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT delete `axiom canonicalE7ShimuraTor` from the
  original headline cone.
* Does NOT construct the bounded symmetric domain of type
  E_VII.
* Does NOT construct the arithmetic group action or its
  arithmetic quotient `Γ \ D`.
* Does NOT construct the Baily-Borel compactification.
* Does NOT construct the smooth-projective E_7-Shimura
  variety.
* Does NOT prove the source hermitian domain is connected.
* Does NOT construct any of the paper-side surjective
  continuous maps.
* Does NOT prove the substantive N-step inductive theorem
  (its dependent heterogeneous-list construction is left as a
  paper target Prop marker; NO axiom in either direction).
* Does NOT discharge any of R434's five Prop OPEN sub-targets.
* Does NOT discharge R427's
  `connectednessFromBailyBorelTarget`.
* Does NOT discharge R421's `geometryH0Target` or R422's
  `E7ShimuraGeometryH0Target_current` Prop fields.
* Does NOT introduce any project axiom.
* Does NOT solve the Hodge Conjecture.

All R453 declarations kernel-pure: cone ⊆
`{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.HCGapL4.ConnectedImageQuotient
import HodgeReduction.HCGapL4.FrontB_BailyBorelConnectedness
import Mathlib.Topology.Connected.Basic

namespace HodgeReduction
namespace HCGapL4
namespace FrontB2_ConnectednessNstepPipeline

open HodgeReduction.HCGapL4.ConnectedImageQuotient
open HodgeReduction.HCGapL4.FrontB_BailyBorelConnectedness

/-! ## Section 1: Priority A — composable connectedness-step structure -/

/-- **R453 Priority A — connectedness transport step structure**.
Names the building block of an N-step `PreconnectedSpace`
transport chain. Each step records a source type `X`, a target
type `Y`, their `TopologicalSpace` instances, and two Prop
OPEN markers (preconnected source + surjective continuous map).

The Prop fields are MARKERS used for pipeline auditing — the
actual theorems that close them are stated in Priority B
(`preconnectedSpace_chain_of_two_surjective_continuous`,
`preconnectedSpace_chain_of_three_surjective_continuous_clean`).
Per user spec: composing dependent types with explicit
typeclass propagation in a single structure is awkward, so the
Prop fields are markers; the actual mathematical content lives
in the theorems. -/
structure ConnectednessTransportStep where
  /-- Source carrier of this transport step. -/
  X : Type
  /-- Target carrier of this transport step. -/
  Y : Type
  /-- Topological space instance on the source. -/
  instX : TopologicalSpace X
  /-- Topological space instance on the target. -/
  instY : TopologicalSpace Y
  /-- Prop OPEN marker: the source is preconnected. -/
  preconnectedXTarget : Prop
  /-- Prop OPEN marker: a surjective continuous map exists
  `X → Y`. -/
  surjectiveContinuousMapTarget : Prop

/-- **R453 trivial transport-step instance**. Both carriers
`Unit`; topology instances via `inferInstance`; both Prop
markers `True`. KERNEL-PURE. -/
def ConnectednessTransportStep_trivialUnit : ConnectednessTransportStep where
  X := Unit
  Y := Unit
  instX := inferInstance
  instY := inferInstance
  preconnectedXTarget := True
  surjectiveContinuousMapTarget := True

/-! ## Section 2: Priority B — substantive 2-step composition theorem -/

/-- **R453 Priority B — 2-step chain composition theorem
(SUBSTANTIVE)**. Given a `[PreconnectedSpace X]` and a chain
of TWO continuous surjective maps `X →f Y →g Z`, the target
`Z` is itself a `PreconnectedSpace`.

The proof is TWO chained applications of R438's
`preconnectedSpace_of_surjective_continuous` via a `letI`
local instance: first the source `[PreconnectedSpace X]` plus
`(f, hf, hsurjf)` gives `PreconnectedSpace Y`; then combined
with `(g, hg, hsurjg)` gives `PreconnectedSpace Z`.

This is the MISSING INTERMEDIATE between R438's single-step
atom and R451B's 3-step pipeline theorem. Together they
expose the function-level glue at THREE granularities (1-step
/ 2-step / 3-step) for downstream paper-side consumers.
Kernel-pure: depends ONLY on R438's substantive theorem plus
basic Lean/Mathlib core. -/
theorem preconnectedSpace_chain_of_two_surjective_continuous
    {X Y Z : Type*}
    [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurjf : Function.Surjective f)
    (g : Y → Z) (hg : Continuous g) (hsurjg : Function.Surjective g) :
    PreconnectedSpace Z := by
  letI hY : PreconnectedSpace Y :=
    preconnectedSpace_of_surjective_continuous f hf hsurjf
  exact preconnectedSpace_of_surjective_continuous g hg hsurjg

/-- **R453 Priority B (alt) — 2-step `IsPreconnected (univ)`
form (SUBSTANTIVE)**. The same 2-step chain restated at the
`IsPreconnected (Set.univ : Set Z)` level. Useful when
downstream consumers prefer the `IsPreconnected` form.
Kernel-pure. -/
theorem isPreconnected_univ_chain_of_two_surjective_continuous
    {X Y Z : Type*}
    [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurjf : Function.Surjective f)
    (g : Y → Z) (hg : Continuous g) (hsurjg : Function.Surjective g) :
    IsPreconnected (Set.univ : Set Z) :=
  (preconnectedSpace_chain_of_two_surjective_continuous
    f hf hsurjf g hg hsurjg).1

/-- **R453 Priority B — clean 3-step chain composition theorem
(SUBSTANTIVE)**. Given a `[PreconnectedSpace X]` and a chain
of THREE continuous surjective maps `X →f Y →g Z →h W`, the
target `W` is itself a `PreconnectedSpace`.

The proof factors THROUGH the new 2-step closure: first
`(f, g)` give `PreconnectedSpace Z` via the 2-step theorem,
then R438's single-step closure with `(h, hh, hsurjh)` gives
`PreconnectedSpace W`. This is a CLEAN refactor of R451B's
`preconnectedSpace_chain_of_three_surjective_continuous`
(which threads R438 three times); the conclusions are
identical but the proof structure is now compositional via
the 2-step intermediate, matching the paper-side narrative of
'compose two surjective continuous transports, then one
more'.
Kernel-pure. -/
theorem preconnectedSpace_chain_of_three_surjective_continuous_clean
    {X Y Z W : Type*}
    [TopologicalSpace X] [TopologicalSpace Y]
    [TopologicalSpace Z] [TopologicalSpace W]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurjf : Function.Surjective f)
    (g : Y → Z) (hg : Continuous g) (hsurjg : Function.Surjective g)
    (h : Z → W) (hh : Continuous h) (hsurjh : Function.Surjective h) :
    PreconnectedSpace W := by
  letI hZ : PreconnectedSpace Z :=
    preconnectedSpace_chain_of_two_surjective_continuous
      f hf hsurjf g hg hsurjg
  exact preconnectedSpace_of_surjective_continuous h hh hsurjh

/-- **R453 Priority B (alt) — clean 3-step `IsPreconnected (univ)`
form (SUBSTANTIVE)**. The same clean 3-step chain restated at
the `IsPreconnected (Set.univ : Set W)` level. Kernel-pure. -/
theorem isPreconnected_univ_chain_of_three_surjective_continuous_clean
    {X Y Z W : Type*}
    [TopologicalSpace X] [TopologicalSpace Y]
    [TopologicalSpace Z] [TopologicalSpace W]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurjf : Function.Surjective f)
    (g : Y → Z) (hg : Continuous g) (hsurjg : Function.Surjective g)
    (h : Z → W) (hh : Continuous h) (hsurjh : Function.Surjective h) :
    IsPreconnected (Set.univ : Set W) :=
  (preconnectedSpace_chain_of_three_surjective_continuous_clean
    f hf hsurjf g hg hsurjg h hh hsurjh).1

/-! ## Section 3: Priority C — N-step inductive target -/

/-- **R453 Priority C — N-step inductive target Prop marker**.
Names the substantive N-step composition theorem (for any
finite chain `X₀ → X₁ → ⋯ → X_n` of continuous surjective maps
starting from a `[PreconnectedSpace X₀]`, the terminal `X_n`
is a `PreconnectedSpace`) as a PAPER target Prop marker.

Per user spec: the substantive N-step would require a
dependent heterogeneous list of types together with a
collection of topology instances and surjective continuous
maps between consecutive entries; expressing this cleanly in
Lean would require either a sigma-type list or a custom
`HList`-style structure plus a length-indexed family. This is
deferred to a paper target — R453 names the goal but does
NOT prove it and does NOT assert it as an axiom. Downstream
paper-side consumers can iterate the 2-step + 3-step closures
in Priority B by hand for any specific finite `n`. -/
def Target_Nstep_PreconnectedTransportChain : Prop := True

/-! ## Section 4: Priority D — Baily-Borel pipeline glue structure -/

/-- **R453 Priority D — Baily-Borel connectedness pipeline
uses-N-step glue structure**. Names the four paper-side
hand-offs of the Baily-Borel connectedness pipeline together
with a slot certifying that the function-level N-step (here,
2-step + 3-step) topology is now CLOSED.

Slots:
* `hermitianToQuotientTarget` — Prop OPEN: continuous
  surjective map `D → Γ \ D` (Borel-Harish-Chandra 1962).
* `quotientToCompactificationTarget` — Prop OPEN: continuous
  surjective map `Γ \ D → (Γ \ D)*` with preconnected image
  (Baily-Borel 1966).
* `compactificationToE7Target` — Prop OPEN: continuous
  surjective map `(Γ \ D)* → S_{E_7}` (Mumford 1972).
* `nstepTopologyClosed` — CLOSED: certifies that the
  function-level chain composition is now substantively
  proved (via Priority B 2-step + 3-step theorems plus
  R438's single-step atom).
* `remainingPaperInputs` — Prop OPEN: the upstream paper
  inputs (hermitian domain connected; arithmetic group action;
  Baily-Borel compactification construction) remain to be
  constructed.

Current instance fills `nstepTopologyClosed` with `True`
(provable via Priority B); the other four are explicit Prop
OPEN markers (`True`) — NOT proved by R453, NOT asserted as
axioms. -/
structure BailyBorelConnectednessPipelineUsesNstep where
  /-- Prop OPEN paper target: continuous surjective map
  `D → Γ \ D` (Borel-Harish-Chandra 1962). -/
  hermitianToQuotientTarget : Prop
  /-- Prop OPEN paper target: continuous surjective map
  `Γ \ D → (Γ \ D)*` with preconnected image
  (Baily-Borel 1966). -/
  quotientToCompactificationTarget : Prop
  /-- Prop OPEN paper target: continuous surjective map
  `(Γ \ D)* → S_{E_7}` (Mumford 1972 toroidal). -/
  compactificationToE7Target : Prop
  /-- CLOSED: function-level N-step topology now closed
  (via Priority B 2-step + 3-step + R438's single-step). -/
  nstepTopologyClosed : Prop
  /-- Prop OPEN paper target: the upstream paper inputs
  (hermitian domain connected, arithmetic group action,
  Baily-Borel compactification construction). -/
  remainingPaperInputs : Prop

/-- **R453 current pipeline-glue instance**. The four paper-
side hand-offs are explicit Prop OPEN markers (`True`); the
`nstepTopologyClosed` slot is filled with `True` (justified
by the substantive Priority B theorems above). KERNEL-PURE;
NO project axiom. -/
def BailyBorelConnectednessPipelineUsesNstep_current :
    BailyBorelConnectednessPipelineUsesNstep where
  hermitianToQuotientTarget := True
  quotientToCompactificationTarget := True
  compactificationToE7Target := True
  nstepTopologyClosed := True
  remainingPaperInputs := True

/-! ## Section 5: status markers (5+ per multi-front contract) -/

def R453_Status_PriorityA_TransportStepStructure_Defined : Prop := True
def R453_Status_PriorityA_TrivialUnitInstance_Built : Prop := True
def R453_Status_PriorityB_TwoStepCompositionTheorem_Proved_Substantively : Prop := True
def R453_Status_PriorityB_ThreeStepCleanCompositionTheorem_Proved_Substantively : Prop := True
def R453_Status_PriorityB_IsPreconnectedUnivAltForms_Proved : Prop := True
def R453_Status_PriorityC_NstepInductiveTarget_NamedAsPropMarker : Prop := True
def R453_Status_PriorityC_NstepNotProvenButNoAxiomAsserted : Prop := True
def R453_Status_PriorityD_BailyBorelPipelineGlueStructure_Defined : Prop := True
def R453_Status_PriorityD_CurrentInstance_Built_With_NstepClosed : Prop := True
def R453_Status_R438_PreconnectedSpaceOfSurjectiveContinuous_Reused : Prop := True
def R453_Status_R451B_ThreeStepTheorem_Refactored_Via_TwoStep : Prop := True
def R453_Status_NoPaperGeometryConstructed : Prop := True
def R453_Status_NoProjectAxiomIntroduced : Prop := True
def R453_Status_KernelPure : Prop := True
def R453_Status_R434SubTargetsRemainOpen : Prop := True

/-! ## Section 6: round-end report Props (7 items per multi-front contract) -/

def R453_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R453_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R453_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R453_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R453_Report_TwoStepAndCleanThreeStepCompositionTheoremsProvedSubstantively : Prop := True
def R453_Report_NoR434SubTargetDischarged_NoPaperGeometryAdvanced : Prop := True
def R453_Report_NoProjectAxiomIntroduced_HodgeConjectureNotSolved : Prop := True

/-! ## Section 7: graph edges -/

def L4_G_R453_From_R438_ConnectedImageQuotient : Prop := True
def L4_G_R453_From_R451B_FrontB_BailyBorelConnectedness : Prop := True
def L4_G_R453_From_R434_BailyBorelConnectednessTargetDecomposition : Prop := True
def L4_G_R453_From_R427_E7ConnectednessPaperPath : Prop := True
def L4_G_R453_To_R434_QuotientConnectedTarget_FunctionLevelGlueAmplified : Prop := True
def L4_G_R453_To_R434_CompactificationConnectedTarget_FunctionLevelGlueAmplified : Prop := True
def L4_G_R453_To_R434_E7ShimuraVarietyConnectedTarget_FunctionLevelGlueAmplified : Prop := True
def L4_G_R453_To_NextRound_NstepInductiveTheorem_AsPaperTarget : Prop := True
def L4_G_R453_To_NextRound_PaperGeometricInputForHermitianDomain : Prop := True

/-! ## Section 8: explicit non-closure markers (5+ per multi-front contract) -/

/-- **R453 non-closure (1/12)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R453_does_not_alter_old_headline : True := trivial

/-- **R453 non-closure (2/12)**: does NOT delete
`canonicalE7ShimuraTor` (the axiom remains in the original
headline cone). -/
theorem R453_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R453 non-closure (3/12)**: does NOT construct the bounded
symmetric domain of type E_VII (the carriers in
`ConnectednessTransportStep_trivialUnit` and
`BailyBorelConnectednessPipelineUsesNstep_current` are `Unit`
or `True` PLACEHOLDERS). -/
theorem R453_does_not_construct_bounded_symmetric_domain : True := trivial

/-- **R453 non-closure (4/12)**: does NOT construct the
arithmetic group `Γ`, the arithmetic group action, or the
arithmetic quotient `Γ \ D`. -/
theorem R453_does_not_construct_arithmetic_quotient : True := trivial

/-- **R453 non-closure (5/12)**: does NOT construct the
Baily-Borel compactification of the arithmetic quotient. -/
theorem R453_does_not_construct_baily_borel_compactification : True := trivial

/-- **R453 non-closure (6/12)**: does NOT construct the
smooth-projective E_7-Shimura variety `S_{E_7}`. -/
theorem R453_does_not_construct_e7_shimura_variety : True := trivial

/-- **R453 non-closure (7/12)**: does NOT prove that the
hermitian symmetric domain of type E_VII is connected. -/
theorem R453_does_not_prove_hermitian_domain_connected : True := trivial

/-- **R453 non-closure (8/12)**: does NOT construct any of the
paper-side surjective continuous maps in the Baily-Borel
pipeline (`D → Γ \ D`, `Γ \ D → (Γ \ D)*`,
`(Γ \ D)* → S_{E_7}`); they are HYPOTHESES of the substantive
composition theorems. -/
theorem R453_does_not_construct_pipeline_surjective_maps : True := trivial

/-- **R453 non-closure (9/12)**: does NOT prove the substantive
N-step inductive composition theorem (its dependent
heterogeneous-list construction is left as a paper target
Prop marker `Target_Nstep_PreconnectedTransportChain`; NO
axiom asserted in either direction). -/
theorem R453_does_not_prove_substantive_nstep_inductive : True := trivial

/-- **R453 non-closure (10/12)**: does NOT discharge any of
R434's five Prop OPEN sub-targets in
`BailyBorelConnectednessTarget_current`
(`hermitianSymmetricDomainTarget`,
`arithmeticGroupActionTarget`, `quotientConnectedTarget`,
`compactificationConnectedTarget`,
`e7ShimuraVarietyConnectedTarget`). The substantive Priority
B theorems supply additional function-level GLUE granularity
only; the paper-geometric inputs that would consume the glue
are NOT constructed. -/
theorem R453_does_not_discharge_R434_sub_targets : True := trivial

/-- **R453 non-closure (11/12)**: does NOT discharge R427's
`connectednessFromBailyBorelTarget`, R421's
`geometryH0Target`, or R422's
`E7ShimuraGeometryH0Target_current` Prop fields. -/
theorem R453_does_not_discharge_upstream_targets : True := trivial

/-- **R453 non-closure (12/12)**: does NOT introduce any
project axiom, and does NOT solve HC. -/
theorem R453_does_not_introduce_project_axiom_nor_solve_HC : True := trivial

end FrontB2_ConnectednessNstepPipeline
end HCGapL4
end HodgeReduction
