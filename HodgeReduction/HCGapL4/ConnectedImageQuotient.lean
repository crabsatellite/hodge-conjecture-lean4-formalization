/-
# HC Gap L4 — Connected image / surjective-image topological lemma (R438).

R427 introduced the real-E_7 H⁰ rank-one PAPER PATH and named
the connectedness obligation via Baily-Borel as a single coarse
Prop OPEN slot (`connectednessFromBailyBorelTarget`). R434
decomposed that slot into a five-step connectedness chain
(hermitian symmetric domain → arithmetic group action →
quotient connected → compactification connected → E_7-Shimura
connected) via `BailyBorelConnectednessTarget` and exposed the
smallest topological lemma as `ConnectedQuotientLemmaInterface`
(connected `X` + surjective `X → Y` ⇒ connected `Y`). R434
left that interface as a Prop-only structure with a trivial
`Unit` instance, naming `R434_NextSmallLemma_ConnectedQuotient`
as the next attackable atom.

R438 (this file) DISCHARGES the function-level case of that
atom by translating the standard Mathlib facts into two
SUBSTANTIVE theorems:

* **Image version**: `[PreconnectedSpace X]` + continuous
  `f : X → Y` ⇒ `IsPreconnected (Set.range f)`.
* **Surjective version**: `[PreconnectedSpace X]` + continuous
  surjective `f : X → Y` ⇒ `IsPreconnected (Set.univ : Set Y)`.

Both theorems are proved using `IsPreconnected.image` /
`isPreconnected_univ` / `Set.image_univ_of_surjective` from
Mathlib (`Mathlib.Topology.Connected.Basic` /
`Mathlib.Data.Set.Image`). NO project axiom is introduced. The
proofs are kernel-pure.

R438 only closes the FUNCTION-LEVEL atom. It does NOT:

* construct the bounded symmetric domain of type E_VII;
* construct the arithmetic group action or its quotient;
* construct the Baily-Borel compactification;
* prove connectedness of any specific paper object
  (the bounded symmetric domain, the arithmetic quotient, etc.);
* discharge any of R434's five Prop OPEN sub-targets in
  `BailyBorelConnectednessTarget_current`;
* discharge R427's `connectednessFromBailyBorelTarget`,
  R421's `geometryH0Target`, or R422's
  `E7ShimuraGeometryH0Target_current` Prop fields;
* prove the Baily-Borel connectedness theorem in any form;
* solve the Hodge Conjecture.

R438 only supplies the GENERAL TOPOLOGICAL ATOM that, once a
real connected space `D` and a real continuous surjection
`D → Γ \ D` are constructed, would discharge the
`quotientConnectedTarget` step. Building the actual `D`,
the arithmetic group action, and the surjective continuous
quotient map are SEPARATE downstream rounds.

## Design

* `isPreconnected_range_of_continuous_of_preconnectedSpace`
  (Priority B) — SUBSTANTIVE theorem: for `[PreconnectedSpace X]`
  and continuous `f`, the range is preconnected. Proved via
  `Set.image_univ ▸ isPreconnected_univ.image f hf.continuousOn`.
* `isPreconnected_univ_of_surjective_continuous`
  (Priority C) — SUBSTANTIVE theorem: for `[PreconnectedSpace X]`
  and continuous surjective `f`, `(Set.univ : Set Y)` is
  preconnected. Proved via
  `Set.image_univ_of_surjective hsurj ▸ isPreconnected_univ.image f hf.continuousOn`.
* `connectedQuotient_functionLevel_closed_substantive`
  (Priority D) — wraps the Priority C theorem into an explicit
  package: given a `[PreconnectedSpace X]` and continuous
  surjective `f : X → Y`, exposes the conclusion that `Y` is a
  `PreconnectedSpace`.

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
5. Which rank / Hodge data closed? R438 DISCHARGES the
   FUNCTION-LEVEL case of R434's
   `R434_NextSmallLemma_ConnectedQuotient` atom by proving two
   substantive Mathlib-backed theorems
   (`isPreconnected_range_of_continuous_of_preconnectedSpace`
   and `isPreconnected_univ_of_surjective_continuous`). NO
   geometric paper target is discharged: the bounded symmetric
   domain, the arithmetic group action, and the surjective
   continuous quotient map are NOT constructed. R434's five
   Prop OPEN sub-targets, R427's
   `connectednessFromBailyBorelTarget`, R421's
   `geometryH0Target`, and R422's
   `E7ShimuraGeometryH0Target_current` Prop fields remain
   OPEN.

## What R438 does NOT do

* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT delete `axiom canonicalE7ShimuraTor` from the
  original headline cone.
* Does NOT construct the bounded symmetric domain of type
  E_VII.
* Does NOT construct the arithmetic group action or its
  quotient.
* Does NOT construct the Baily-Borel compactification.
* Does NOT prove connectedness of any specific paper object.
* Does NOT discharge any of R434's five Prop OPEN sub-targets.
* Does NOT discharge R427's
  `connectednessFromBailyBorelTarget`.
* Does NOT discharge R421's `geometryH0Target` or R422's
  `E7ShimuraGeometryH0Target_current` Prop fields.
* Does NOT prove the Baily-Borel theorem in any form.
* Does NOT introduce any project axiom.
* Does NOT solve the Hodge Conjecture.

All R438 declarations kernel-pure: substantive theorems use
only `propext`, `Classical.choice`, `Quot.sound`, and the
Mathlib library cone.
-/

import HodgeReduction.HCGapL4.BailyBorelConnectednessTargetDecomposition
import Mathlib.Topology.Connected.Basic

namespace HodgeReduction
namespace HCGapL4
namespace ConnectedImageQuotient

open Set Function

/-! ## Section 1: Priority A — Mathlib search audit (recorded as Prop markers) -/

/-- **R438 Mathlib API audit (1/4)**: `IsPreconnected.image` exists in
`Mathlib.Topology.Connected.Basic` (Mathlib v4.16.0, line ~276):
```
protected theorem IsPreconnected.image [TopologicalSpace β]
    {s : Set α} (H : IsPreconnected s)
    (f : α → β) (hf : ContinuousOn f s) : IsPreconnected (f '' s)
```
-/
def R438_MathlibAudit_IsPreconnected_image_exists : Prop := True

/-- **R438 Mathlib API audit (2/4)**: `isPreconnected_univ` exists as
the `PreconnectedSpace` field:
```
class PreconnectedSpace (α : Type u) [TopologicalSpace α] : Prop where
  isPreconnected_univ : IsPreconnected (univ : Set α)
```
-/
def R438_MathlibAudit_isPreconnected_univ_exists : Prop := True

/-- **R438 Mathlib API audit (3/4)**: `isPreconnected_range` already
exists in `Mathlib.Topology.Connected.Basic` (line ~633):
```
theorem isPreconnected_range [TopologicalSpace β] [PreconnectedSpace α]
    {f : α → β} (h : Continuous f) : IsPreconnected (range f) :=
  @image_univ _ _ f ▸ isPreconnected_univ.image _ h.continuousOn
```
R438 provides a renamed wrapper for paper-side citation
clarity, with the same proof. -/
def R438_MathlibAudit_isPreconnected_range_exists : Prop := True

/-- **R438 Mathlib API audit (4/4)**:
`Set.image_univ_of_surjective` exists in
`Mathlib.Data.Set.Image` (line ~275):
```
theorem image_univ_of_surjective {ι : Type*} {f : ι → β}
    (H : Surjective f) : f '' univ = univ
```
-/
def R438_MathlibAudit_image_univ_of_surjective_exists : Prop := True

/-! ## Section 2: Priority B — image theorem (SUBSTANTIVE, kernel-pure) -/

/-- **R438 Priority B — image theorem (SUBSTANTIVE)**. For any
`PreconnectedSpace X` and any continuous map `f : X → Y`, the
range `Set.range f` is preconnected as a subset of `Y`.

This is the FUNCTION-LEVEL closure of the standard topological
fact that continuous images of (pre)connected spaces are
(pre)connected. The proof uses Mathlib's
`IsPreconnected.image` (taking `s := Set.univ` and
`H := isPreconnected_univ`) together with the identity
`f '' Set.univ = Set.range f`.

This theorem alone does NOT construct or prove anything about
the bounded symmetric domain of type E_VII, the arithmetic
quotient, or any other Baily-Borel object. It is the
FUNCTION-LEVEL atom; the paper-geometric input
(connected `X`, continuous `f`, real space `Y`) is
separate. -/
theorem isPreconnected_range_of_continuous_of_preconnectedSpace
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) :
    IsPreconnected (Set.range f) := by
  rw [← Set.image_univ]
  exact isPreconnected_univ.image f hf.continuousOn

/-! ## Section 3: Priority C — surjective version (SUBSTANTIVE, kernel-pure) -/

/-- **R438 Priority C — surjective version (SUBSTANTIVE)**. For
any `PreconnectedSpace X`, any continuous map `f : X → Y`, and
any surjectivity hypothesis `Function.Surjective f`, the entire
target `(Set.univ : Set Y)` is preconnected.

This refines Priority B by combining the range-preconnectedness
with `Set.image_univ_of_surjective` to convert
`f '' Set.univ = Set.univ`. The proof is kernel-pure (uses
only Mathlib's `IsPreconnected.image`,
`isPreconnected_univ`, `Set.image_univ_of_surjective`).

This is the EXACT function-level shape of the R434
`ConnectedQuotientLemmaInterface` conclusion
(`connectedYTarget`), modulo the distinction between
`IsPreconnected` and `IsConnected` (which differ only by
non-emptiness, easily added via `PreconnectedSpace` instance
plus `Nonempty Y` from surjectivity if needed). -/
theorem isPreconnected_univ_of_surjective_continuous
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurj : Function.Surjective f) :
    IsPreconnected (Set.univ : Set Y) := by
  rw [← Set.image_univ_of_surjective hsurj]
  exact isPreconnected_univ.image f hf.continuousOn

/-! ## Section 4: Priority D — function-level closure package -/

/-- **R438 Priority D — function-level closure (SUBSTANTIVE)**.
The two Priority B / Priority C theorems together suffice to
discharge the function-level form of R434's
`ConnectedQuotientLemmaInterface`: given a
`[PreconnectedSpace X]` and a continuous surjection
`f : X → Y`, the target type `Y` is a `PreconnectedSpace`.

This is the strongest function-level statement R438 commits to:
NO paper-geometric input is constructed (no `D`, no `Γ`, no
quotient map), so this does NOT discharge any sub-target of
`BailyBorelConnectednessTarget`. It only certifies that
the topological-atom side of the R434 decomposition is now
CLOSED at the function level. -/
theorem preconnectedSpace_of_surjective_continuous
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurj : Function.Surjective f) :
    PreconnectedSpace Y :=
  ⟨isPreconnected_univ_of_surjective_continuous f hf hsurj⟩

/-- **R438 wrapper marker**: function-level closure is complete.
The substantive content is the three theorems above
(`isPreconnected_range_of_continuous_of_preconnectedSpace`,
`isPreconnected_univ_of_surjective_continuous`,
`preconnectedSpace_of_surjective_continuous`). This Prop is a
nameable witness used downstream. -/
theorem ConnectedQuotient_FunctionLevel_Closed : True := trivial

/-! ## Section 5: Priority D continued — explicit R434 interface instance -/

/-- **R438 substantive R434 interface instance**. Given an
explicit `PreconnectedSpace` source `X`, a `TopologicalSpace`
target `Y`, a continuous surjection `f : X → Y`, this builds
the R434 `ConnectedQuotientLemmaInterface` with REAL Prop
witnesses (`PreconnectedSpace X` as
`connectedXTarget`, `Function.Surjective f` as
`surjectiveTarget`, `IsPreconnected (Set.univ : Set Y)` as
`connectedYTarget`) — not the `True` placeholder of R434's
`_current`.

The `quotientMapTarget` field is filled with `Continuous f`
(NOT the stronger Mathlib `QuotientMap`/`IsQuotientMap`
predicate, since R438's substantive theorem only needs
continuity, not quotient-map structure). The R434 paper target
of constructing the actual quotient map is a SEPARATE
downstream round.

The carriers `X` and `Y` are passed in as parameters; R438
does NOT construct them. -/
def ConnectedQuotientLemmaInterface_R438_substantive
    {X Y : Type} [TopologicalSpace X] [TopologicalSpace Y]
    [PreconnectedSpace X]
    (f : X → Y) (hf : Continuous f) (hsurj : Function.Surjective f) :
    BailyBorelConnectednessTargetDecomposition.ConnectedQuotientLemmaInterface where
  X                := X
  Y                := Y
  connectedXTarget := PreconnectedSpace X
  quotientMapTarget := Continuous f
  surjectiveTarget := Function.Surjective f
  connectedYTarget := IsPreconnected (Set.univ : Set Y)

/-! ## Section 6: required R438 markers -/

/-- **R438 marker**: the function-level image theorem
`isPreconnected_range_of_continuous_of_preconnectedSpace`
is CLOSED (kernel-pure, Mathlib-backed). -/
def R438_ConnectedImage_Closed : Prop := True

/-- **R438 marker**: the function-level surjective target
theorem
`isPreconnected_univ_of_surjective_continuous` is CLOSED
(kernel-pure, Mathlib-backed). -/
def R438_ConnectedQuotient_Target_Closed : Prop := True

/-- **R438 marker**: R438 does NOT prove the Baily-Borel
connectedness theorem. The substantive R438 closures are
PURELY at the function-level topological atom layer;
constructing the actual paper-geometric input (`D`, `Γ`, the
quotient map) is a separate downstream round. -/
def R438_DoesNotProveBailyBorel : Prop := True

/-! ## Section 7: status markers -/

def R438_Status_PriorityA_MathlibAuditRecorded : Prop := True
def R438_Status_PriorityB_ImageTheoremProved : Prop := True
def R438_Status_PriorityC_SurjectiveTheoremProved : Prop := True
def R438_Status_PriorityD_FunctionLevelClosurePackaged : Prop := True
def R438_Status_PriorityD_R434InterfaceInstanceBuilt : Prop := True
def R438_Status_NoProjectAxiomIntroduced : Prop := True
def R438_Status_NoPaperGeometryConstructed : Prop := True
def R438_Status_R434AtomClosedAtFunctionLevel : Prop := True
def R438_Status_R434PaperSubTargetsRemainOpen : Prop := True
def R438_Status_KernelPure : Prop := True

/-! ## Section 8: round-end report (Prop-only markers) -/

def R438_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R438_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R438_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R438_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R438_Report_R434FunctionLevelAtomDischargedNoPaperGeometryAdvanced : Prop := True

/-! ## Section 9: graph edges -/

def L4_G_R438_From_R434_ConnectedQuotientLemmaInterface : Prop := True
def L4_G_R438_From_R427_E7ConnectednessPaperPath : Prop := True
def L4_G_R438_To_R434_ConnectedQuotientLemmaInterface_FunctionLevelClosed : Prop := True
def L4_G_R438_To_NextRound_PaperGeometricInput : Prop := True

/-! ## Section 10: explicit non-closure markers (5+ per user spec) -/

/-- **R438 non-closure (1/9)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R438_does_not_alter_old_headline : True := trivial

/-- **R438 non-closure (2/9)**: does NOT delete
`canonicalE7ShimuraTor`. -/
theorem R438_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R438 non-closure (3/9)**: does NOT construct the bounded
symmetric domain of type E_VII. -/
theorem R438_does_not_construct_bounded_symmetric_domain : True := trivial

/-- **R438 non-closure (4/9)**: does NOT construct the
arithmetic group action or the arithmetic quotient
`Γ \ D`. -/
theorem R438_does_not_construct_arithmetic_quotient : True := trivial

/-- **R438 non-closure (5/9)**: does NOT construct the
Baily-Borel compactification of the arithmetic quotient. -/
theorem R438_does_not_construct_baily_borel_compactification : True := trivial

/-- **R438 non-closure (6/9)**: does NOT prove the Baily-Borel
connectedness theorem in any form (the function-level atom is
the ONLY R438 closure; the paper-geometric input — connected
real space `D`, continuous quotient `D → Γ\D`, etc. — is NOT
constructed). -/
theorem R438_does_not_prove_baily_borel_connectedness : True := trivial

/-- **R438 non-closure (7/9)**: does NOT discharge any of
R434's five Prop OPEN sub-targets in
`BailyBorelConnectednessTarget_current`
(`hermitianSymmetricDomainTarget`,
`arithmeticGroupActionTarget`, `quotientConnectedTarget`,
`compactificationConnectedTarget`,
`e7ShimuraVarietyConnectedTarget`). -/
theorem R438_does_not_discharge_R434_sub_targets : True := trivial

/-- **R438 non-closure (8/9)**: does NOT discharge R427's
`connectednessFromBailyBorelTarget`, R421's
`geometryH0Target`, or R422's
`E7ShimuraGeometryH0Target_current` Prop fields. -/
theorem R438_does_not_discharge_upstream_targets : True := trivial

/-- **R438 non-closure (9/9)**: does NOT introduce any project
axiom, and does NOT solve HC. -/
theorem R438_does_not_introduce_project_axiom_nor_solve_HC : True := trivial

end ConnectedImageQuotient
end HCGapL4
end HodgeReduction
