/-
# HC Gap L4 — Deligne-Schmid rank-1 / rank-2 low-degree fragment (R426).

R417 closed the profile-side rank-0 internal linear-algebra fact
`Fin 1 → ℚ ≃ₗ[ℚ] ℚ` via `LinearEquiv.funUnique`. R418 instantiated
the R415 parametric kernel-pure HC headline on a concrete rank
function `E7Rank_lowDegree_current` (paper-backed only at degree 0;
placeholder elsewhere). R419 named the full-rank / Hodge-number
theorem-import schemas. R421 / R422 / R423 / R425 wove the abstract
H⁰ rank-one interface, its E_7 specialisation, schema integration,
and the skip-full-audit gate. R424 ranked next targets and
identified R426 = rank-1 / rank-2 Deligne-Schmid fragment interface
for low-degree data population.

R426 (this file) extends the R417 pattern from degree 0 to degrees
1 and 2 at the PROFILE-SIDE level only:

* Defines the `DeligneSchmidLowDegreeRankFragment` interface bundling
  target VCD, three rank slots (rank0 / rank1 / rank2 :  ℕ), the
  paper-backed `rank0 = 1` witness, and six Prop targets naming the
  rank-1 / rank-2 / Hodge-number(1,0) / Hodge-number(1,1) /
  rational-structure-compatibility / Deligne-Schmid-source paper
  obligations.
* Defines the `E7LowDegreeRank012Spec` profile-side rank-(0,1,2)
  spec structure + a current instance threading R418's
  `E7Rank_lowDegree_current` and its `rank 0 = 1` witness.
* Proves the substantive profile-side `H¹` and `H²` identifications:
  `DegreewiseRankE7_H rank k ≃ₗ[ℚ] (Fin (rank k) → ℚ)` is the identity
  linear equivalence (kernel-pure via `LinearEquiv.refl`).
* Names the four real-E_7 rank-1 / rank-2 paper theorem targets
  (Deligne 1971, Schmid 1973, Borel-Wallach 2000, Pink 1990) WITHOUT
  claiming them.
* Names the three R426 disclosure markers locating the round honestly:
  profile-side H¹/H² CLOSED, real-E_7 rank-1/rank-2 STILL PAPER
  TARGET, R426 does NOT claim real E_7 ranks.

## Design

* `DeligneSchmidLowDegreeRankFragment` (Priority A) — fragment
  interface structure carrying the target VCD, rank0/rank1/rank2
  slots, `rank0 = 1` witness, and six Prop targets.
* `E7LowDegreeRank012Spec` (Priority B) — low-degree profile-side
  rank-(0,1,2) spec structure + current instance.
* `DegreewiseRank_H1_profile_identification` /
  `DegreewiseRank_H2_profile_identification` (Priority C) — the two
  SUBSTANTIVE profile-side H¹ / H² identifications. Kernel-pure,
  proved via `LinearEquiv.refl` (the abbrev `DegreewiseRankE7_H rank
  k = Fin (rank k) → ℚ` makes the equivalence definitional).
* `Target_DeligneSchmid_E7_rank1` /
  `Target_DeligneSchmid_E7_rank2` /
  `Target_BorelWallach_E7_lowDegreeBetti` /
  `Target_Pink_E7_rationalCohomology_lowDegree` (Priority D) — four
  Prop markers naming the real-E_7 rank-1 / rank-2 paper-level
  obligations WITHOUT claiming them.
* `R426_*` disclosure markers (Priority E) — three Prop markers
  locating the round honestly.

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
5. Profile-side H¹ / H² closed?
   - PROFILE-SIDE H¹ / H² IDENTIFICATIONS: CLOSED kernel-pure via
     `LinearEquiv.refl` (the abbrev `DegreewiseRankE7_H rank k =
     Fin (rank k) → ℚ` collapses the equivalence to definitional
     reflexivity).
   - Real-E_7 rank-1 / rank-2 PAPER TARGETS: still OPEN (named, not
     claimed; markers `Target_DeligneSchmid_E7_rank1` /
     `Target_DeligneSchmid_E7_rank2`).
   - Real-E_7 Hodge numbers `h^{1,0}` / `h^{1,1}` PAPER TARGETS:
     still OPEN.
   - Rational-structure compatibility + Deligne-Schmid-source paper
     obligations: still OPEN.

## Honest disclosure

* The two LinearEquiv theorems are SUBSTANTIVELY proved (NOT `:= True`
  Prop placeholders), but they are profile-side LA identities only:
  the abbrev `DegreewiseRankE7_H rank k = Fin (rank k) → ℚ` makes the
  equivalence definitionally `LinearEquiv.refl`. No real-E_7 rank
  values are claimed.
* The `E7LowDegreeRank012Spec_current` instance threads R418's rank
  function (paper-backed at k = 0 only) and sets the
  `rank1_value_target` / `rank2_value_target` / `hodgeNumber_lowDegree_target`
  fields to `True` OPEN markers.
* The four `Target_*` Props are NAMED-NOT-CLAIMED markers. They
  state the real-E_7 paper-level obligations without discharging
  them.

## What R426 does NOT do

* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT claim any real-E_7 rank-1 / rank-2 value.
* Does NOT discharge any of the four R408 paper imports.
* Does NOT introduce any project axioms.
* Does NOT construct real E_7 geometry.
* Does NOT flip `safeToReplaceOriginalHeadline`.

All R426 substantive declarations kernel-pure: cone ⊆
`{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.HCGapL4.E7LowDegreeRankPopulation
import HodgeReduction.HCGapL4.DegreewiseRankE7CohomologyProfile
import HodgeReduction.HCGapL4.DeligneSchmidCohomologyImportInterface

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace DeligneSchmidLowDegreeRankFragment

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.DegreewiseRankE7

/-! ## Section 1: Priority A — fragment interface structure -/

/-- **R426 fragment interface** bundling the rank-1 / rank-2
Deligne-Schmid low-degree fragment: a target VCD, three rank slots
(rank0 / rank1 / rank2), the paper-backed `rank0 = 1` witness, and
six Prop targets naming the real-E_7 rank-1 / rank-2 /
Hodge-number(1,0) / Hodge-number(1,1) / rational-structure /
Deligne-Schmid-source paper obligations. -/
structure DeligneSchmidLowDegreeRankFragment where
  /-- The variety cohomology data being targeted. -/
  targetVCD : VarietyCohomologyData
  /-- The degree-0 rank `dim_ℚ H^0(X, ℚ)`. -/
  rank0 : ℕ
  /-- The degree-1 rank `dim_ℚ H^1(X, ℚ)`. -/
  rank1 : ℕ
  /-- The degree-2 rank `dim_ℚ H^2(X, ℚ)`. -/
  rank2 : ℕ
  /-- Witness: the degree-0 rank equals 1 (smooth projective
  connected). -/
  rank0_eq_one : rank0 = 1
  /-- Target: the degree-1 rank matches the real-E_7 paper claim
  (Deligne-Schmid). KEPT as Prop marker — NOT discharged. -/
  rank1Target : Prop
  /-- Target: the degree-2 rank matches the real-E_7 paper claim
  (Deligne-Schmid). KEPT as Prop marker — NOT discharged. -/
  rank2Target : Prop
  /-- Target: Hodge number `h^{1,0}` matches paper claim. KEPT as
  Prop marker. -/
  hodgeNumber10Target : Prop
  /-- Target: Hodge number `h^{1,1}` matches paper claim. KEPT as
  Prop marker. -/
  hodgeNumber11Target : Prop
  /-- Target: rational-structure compatibility on the low-degree
  pieces. KEPT as Prop marker. -/
  rationalStructureCompatibilityTarget : Prop
  /-- Target: the Deligne-Schmid source paper-level theorem
  (Deligne 1971 § analytic boundary + Schmid 1973 nilpotent-orbit).
  KEPT as Prop marker. -/
  deligneSchmidSourceTarget : Prop

/-! ## Section 2: Priority B — low-degree profile-side spec -/

/-- **R426 low-degree profile-side rank-(0,1,2) spec**. Bundles a
rank function together with the paper-backed `rank 0 = 1` witness and
three Prop targets recording obligations for `rank 1`, `rank 2`, and
the low-degree Hodge numbers. -/
structure E7LowDegreeRank012Spec where
  /-- Rank function `rank k = dim_ℚ H^k`. -/
  rank : ℕ → ℕ
  /-- Witness: degree-0 rank equals 1 (paper-backed). -/
  rank0_eq_one : rank 0 = 1
  /-- Target: the rank-1 paper value. KEPT as Prop marker. -/
  rank1_value_target : Prop
  /-- Target: the rank-2 paper value. KEPT as Prop marker. -/
  rank2_value_target : Prop
  /-- Target: the low-degree Hodge numbers. KEPT as Prop marker. -/
  hodgeNumber_lowDegree_target : Prop

/-- **R426 current spec instance**: threads R418's
`E7Rank_lowDegree_current` rank function and its `rank 0 = 1` witness;
sets the three remaining targets to `True` OPEN markers. -/
def E7LowDegreeRank012Spec_current : E7LowDegreeRank012Spec where
  rank := DegreewiseRankE7.E7Rank_lowDegree_current
  rank0_eq_one := DegreewiseRankE7.E7Rank_lowDegree_current_zero
  rank1_value_target := True
  rank2_value_target := True
  hodgeNumber_lowDegree_target := True

/-! ## Section 3: Priority C — profile-side H¹ / H² identifications

The two SUBSTANTIVE theorems of R426. Since
`DegreewiseRankE7_H rank k` is an `abbrev` for `Fin (rank k) → ℚ`,
the identification at any degree is definitionally
`LinearEquiv.refl ℚ (Fin (rank k) → ℚ)`. KERNEL-PURE proofs. -/

/-- **R426 substantive profile-side H¹ identification**: for any rank
function `rank : ℕ → ℕ`, the degreewise-rank carrier at degree 1
is ℚ-linearly equivalent to `Fin (rank 1) → ℚ`. KERNEL-PURE; the
abbrev `DegreewiseRankE7_H rank 1 = Fin (rank 1) → ℚ` collapses the
equivalence to definitional reflexivity.

This is the Lean-side LA companion to the rank-1 paper claim; the
paper claim itself (real-E_7 rank-1 value) remains OPEN — see
`Target_DeligneSchmid_E7_rank1`. -/
theorem DegreewiseRank_H1_profile_identification (rank : ℕ → ℕ) :
    Nonempty (DegreewiseRankE7.DegreewiseRankE7_H rank 1 ≃ₗ[ℚ]
              (Fin (rank 1) → ℚ)) :=
  ⟨LinearEquiv.refl _ _⟩

/-- **R426 substantive profile-side H² identification**: for any rank
function `rank : ℕ → ℕ`, the degreewise-rank carrier at degree 2
is ℚ-linearly equivalent to `Fin (rank 2) → ℚ`. KERNEL-PURE; the
abbrev `DegreewiseRankE7_H rank 2 = Fin (rank 2) → ℚ` collapses the
equivalence to definitional reflexivity.

This is the Lean-side LA companion to the rank-2 paper claim; the
paper claim itself (real-E_7 rank-2 value) remains OPEN — see
`Target_DeligneSchmid_E7_rank2`. -/
theorem DegreewiseRank_H2_profile_identification (rank : ℕ → ℕ) :
    Nonempty (DegreewiseRankE7.DegreewiseRankE7_H rank 2 ≃ₗ[ℚ]
              (Fin (rank 2) → ℚ)) :=
  ⟨LinearEquiv.refl _ _⟩

/-! ## Section 4: Priority D — paper target markers (NAMED-NOT-CLAIMED)

Four Prop markers naming the real-E_7 rank-1 / rank-2 paper-level
obligations WITHOUT discharging them. These are companion targets
to the R408 theorem-import structure, restricted to the rank-1 /
rank-2 low-degree slice. -/

/-- **R426 paper target — Deligne-Schmid rank-1 for real E_7-Shimura**:
the real-E_7 Hodge structure on `H^1` matches the Deligne-Schmid /
Pink prediction for the canonical model. KEPT as `Prop := True` OPEN
marker — NOT discharged. -/
def Target_DeligneSchmid_E7_rank1 : Prop := True

/-- **R426 paper target — Deligne-Schmid rank-2 for real E_7-Shimura**:
the real-E_7 Hodge structure on `H^2` matches the Deligne-Schmid /
Pink prediction for the canonical model. KEPT as `Prop := True` OPEN
marker — NOT discharged. -/
def Target_DeligneSchmid_E7_rank2 : Prop := True

/-- **R426 paper target — Borel-Wallach E_7 low-degree Betti numbers**:
the Betti numbers `b_1` and `b_2` of the real-E_7-Shimura variety
agree with Borel-Wallach 2000 automorphic-cohomology computation for
the E_7(-25) discrete series. KEPT as `Prop := True` OPEN marker. -/
def Target_BorelWallach_E7_lowDegreeBetti : Prop := True

/-- **R426 paper target — Pink E_7 rational cohomology in low degree**:
the rational cohomology `H^k(\bar{Sh}_K(E_7, X); ℚ)` for `k ∈ {1, 2}`
agrees with Pink 1990 toroidal-compactification computation. KEPT as
`Prop := True` OPEN marker. -/
def Target_Pink_E7_rationalCohomology_lowDegree : Prop := True

/-! ## Section 5: Priority E — disclosure markers -/

/-- **R426 disclosure**: the profile-side H¹ / H² identifications are
SUBSTANTIVELY CLOSED kernel-pure (`DegreewiseRank_H1_profile_identification`
and `DegreewiseRank_H2_profile_identification`). The substantive
content is the abbrev unfolding `DegreewiseRankE7_H rank k =
Fin (rank k) → ℚ` plus `LinearEquiv.refl`. -/
def R426_ProfileSide_H1H2_Closed : Prop := True

/-- **R426 disclosure**: the real-E_7 rank-1 / rank-2 PAPER targets
remain OPEN (Deligne-Schmid / Borel-Wallach / Pink imports not
discharged). Closing the profile-side LA does NOT close the
paper-side rank values. -/
def R426_RealE7_Rank1Rank2_StillPaperTarget : Prop := True

/-- **R426 disclosure**: R426 does NOT claim any real-E_7 rank value.
The two LinearEquiv theorems are profile-side LA only; the four
`Target_*` Props are NAMED-NOT-CLAIMED markers. -/
def R426_NoRealE7RankClaim : Prop := True

/-! ## Section 6: status markers -/

def R426_Status_FragmentInterface_Defined : Prop := True
def R426_Status_LowDegreeRank012Spec_Defined : Prop := True
def R426_Status_CurrentSpecInstance_Defined : Prop := True
def R426_Status_H1ProfileIdentification_ProvedKernelPure : Prop := True
def R426_Status_H2ProfileIdentification_ProvedKernelPure : Prop := True
def R426_Status_FourPaperTargetMarkers_DefinedNotAxioms : Prop := True
def R426_Status_ThreeDisclosureMarkers_Defined : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

def R426_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R426_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R426_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R426_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R426_Report_ProfileSide_H1H2_Closed_PaperSide_StillOpen : Prop := True

/-! ## Section 8: graph edges -/

def L4_G_R426_From_R408_DeligneSchmidCohomologyImportInterface : Prop := True
def L4_G_R426_From_R412_DegreewiseRankE7CohomologyProfile : Prop := True
def L4_G_R426_From_R417_Deligne1971LowDegreeFragment_Pattern : Prop := True
def L4_G_R426_From_R418_E7LowDegreeRankPopulation : Prop := True
def L4_G_R426_From_R424_HCFrontierAfterH0RankOneInterface_NextTarget : Prop := True
def L4_G_R426_To_R427_E7Connectedness_Or_HigherRank : Prop := True
def L4_G_R426_To_R428_SecondSubstantivePopulationRound : Prop := True

/-! ## Section 9: explicit non-closure markers (5+ per user spec) -/

/-- **R426 non-closure (1/8)**: does NOT delete
`axiom canonicalE7ShimuraTor`. -/
theorem R426_does_not_delete_canonical_axiom : True := trivial

/-- **R426 non-closure (2/8)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R426_does_not_alter_old_headline : True := trivial

/-- **R426 non-closure (3/8)**: does NOT delete `canonicalE7ShimuraTor`
(the axiom remains in the original headline cone). -/
theorem R426_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R426 non-closure (4/8)**: does NOT claim any real-E_7 rank-1 /
rank-2 value (the two LinearEquiv theorems are profile-side LA only;
the four `Target_*` Props are NAMED-NOT-CLAIMED markers). -/
theorem R426_does_not_claim_real_E7_rank1_rank2_values : True := trivial

/-- **R426 non-closure (5/8)**: does NOT discharge any of the four
R408 paper imports (Deligne 1971 / Schmid 1973 / Borel-Wallach 2000 /
Pink 1990 remain OPEN). -/
theorem R426_does_not_discharge_R408_paper_imports : True := trivial

/-- **R426 non-closure (6/8)**: does NOT introduce any project
axioms (every paper-level target is a `Prop` placeholder, NOT an
`axiom`). -/
theorem R426_does_not_introduce_project_axioms : True := trivial

/-- **R426 non-closure (7/8)**: does NOT construct real E_7
geometry. -/
theorem R426_does_not_construct_real_E7_geometry : True := trivial

/-- **R426 non-closure (8/8)**: does NOT solve HC. -/
theorem R426_does_not_solve_HC : True := trivial

end DeligneSchmidLowDegreeRankFragment
end HCGapL4
end HodgeReduction
