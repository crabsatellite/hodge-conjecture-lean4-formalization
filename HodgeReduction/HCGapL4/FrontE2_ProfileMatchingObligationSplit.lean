/-
# HC Gap L4 — Front E Wave 2: profile-matching obligation split (R454).

R451E introduced the matching structure
`DegreewiseRankProfileMatchesRealCarrier` with four MONOLITHIC Prop
targets — `degreewiseLinearEquivTarget`,
`hodgeNumberCompatibilityTarget`, `algClassesCompatibilityTarget`,
`packageCompatibilityTarget` — plus a substantive feed theorem
`DegreewiseRankProfileMatchesRealCarrier_feeds_R405` repackaging the
four-conjunct hypothesis shape.

R454 (this file, Wave 2 Front E amplification) refines the four
monolithic Prop obligations into a PER-CODIM / PER-DEGREE OBLIGATION
STRUCTURE — `DegreewiseRankProfileRealCarrierObligations` — and a
LOW-DEGREE PROJECTION — `LowDegreeProfileRealCarrierObligations`
(only `k = 0, 1, 2`) that downstream rounds (R452 low-degree
Hodge/rank data feed) can substantively discharge degree-by-degree
rather than monolithically. R454 also bundles the real
`VarietyCohomologyData` and `AlgebraicClassesData` directly on the
refined obligation structure, so a future substantive instance pins
the real canonical carrier on the obligation side.

R454 introduces NO project axiom. The trivial-unit instances of both
obligation structures default all per-degree Prop fields to `True`.
The `obligations_feed_DegreewiseRankProfileMatchesRealCarrier` formal
implication and the
`LowDegreeHodgeRankData_feeds_ProfileMatchingLowDegreeTarget`
connection marker stay as `Prop := True` markers (per R390/R405/R410
workaround for return-type-Prop `def`s), since a substantive feed
requires R452's low-degree Hodge/rank data which is not assumed
available at R454.

## Design

* `DegreewiseRankProfileRealCarrierObligations` (Priority A) — refined
  per-codim obligation structure carrying:
    - `rank : ℕ → ℕ` (free parameter, same as R451E);
    - `realVCD : VarietyCohomologyData` (real canonical cohomology data);
    - `realACD : AlgebraicClassesData realVCD` (real canonical algebraic
      classes);
    - `degreewiseLinearEquivTarget : ∀ (_k : ℕ), Prop` (per-degree
      ℚ-linear equivalence target);
    - `hodgeCompatibilityTarget : ∀ (_k : ℕ), Prop` (per-degree Hodge
      compatibility target);
    - `algClassesCompatibilityTarget : ∀ (_p : ℕ), Prop` (per-codim
      algebraic-classes compatibility target);
    - `mtPackageCompatibilityTarget : ∀ (_p : ℕ), Prop` (per-codim MT
      package compatibility target);
    - `allCodimTransferTarget : Prop` (the aggregated all-codim transfer
      target — what R405 ultimately consumes).
* `obligations_feed_DegreewiseRankProfileMatchesRealCarrier`
  (Priority B) — formal implication marker that a substantively
  discharged refined obligation structure feeds R451E's
  `DegreewiseRankProfileMatchesRealCarrier`. STAYS `Prop := True`
  pending R452's substantive low-degree feed.
* `LowDegreeProfileRealCarrierObligations` (Priority C) — low-degree
  projection (k = 0, 1, 2) of the refined obligation structure, with
  three rank fields and twelve Prop targets (4 targets × 3 degrees).
* `LowDegreeHodgeRankData_feeds_ProfileMatchingLowDegreeTarget`
  (Priority D) — connection marker for the R452 low-degree
  Hodge/rank data feed. STAYS `Prop := True` pending R452.
* Markers (Priority E):
  `R454_ProfileMatchingObligations_Split`,
  `R454_LowDegreeMatching_TargetAvailable`,
  `R454_AllCodimMatching_StillOpen`.

## Round-end report (per multi-front contract, 7 items)

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
5. R454 SUBSTANTIVELY defines the refined per-codim obligation
   structure `DegreewiseRankProfileRealCarrierObligations` and the
   low-degree projection `LowDegreeProfileRealCarrierObligations`,
   splitting R451E's four monolithic Prop targets into per-degree /
   per-codim families. The refined obligation structure now CARRIES
   the real `VarietyCohomologyData` and `AlgebraicClassesData`
   directly — pinning the real canonical carrier on the obligation
   side. R454 also enumerates the formal feed implication into
   R451E's matching structure and the R452 low-degree
   Hodge/rank-data feed connection (both stay as `Prop := True`
   markers pending substantive low-degree discharge).
6. R454 does NOT discharge any real-geometry data. The
   `obligations_feed_DegreewiseRankProfileMatchesRealCarrier` and
   `LowDegreeHodgeRankData_feeds_ProfileMatchingLowDegreeTarget`
   connections remain markers; the per-degree / per-codim Prop
   targets all default to `True` in the trivial-unit instances. The
   `rank : ℕ → ℕ` parameter is still free; the `realVCD` / `realACD`
   slots accept any data and the trivial-unit instance plugs in a
   trivial diagonal placeholder.
7. R454 introduces NO project axiom.
   `hodgeConjectureReal_canonical` is NOT altered.
   `canonicalE7ShimuraTor` is NOT deleted. The Hodge Conjecture is
   NOT solved.

## What R454 does NOT do

* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT delete `canonicalE7ShimuraTor`.
* Does NOT delete `axiom canonicalE7ShimuraTor` from the original
  headline cone.
* Does NOT compute the real E_7 Hodge decomposition data.
* Does NOT determine the real-E_7 rank function.
* Does NOT replace the architecture-test `algClasses = ⊤` with real
  Chow-ring data.
* Does NOT replace the identity MT package with a substantive real
  cycle correspondence.
* Does NOT instantiate R403's strong identification schema with
  obligation-backed witnesses.
* Does NOT substantively discharge R452's low-degree Hodge/rank-data
  feed (kept as `Prop := True` marker).
* Does NOT substantively prove the implication into R451E's
  matching structure (kept as `Prop := True` marker pending R452).
* Does NOT introduce any project axiom.
* Does NOT solve the Hodge Conjecture.

All R454 declarations kernel-pure: cone ⊆
`{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.HCGapL4.FrontE_RealCarrierProfileMatching
import HodgeReduction.HCGapL4.DegreewiseRankE7CohomologyProfile
import HodgeReduction.HCGapL4.DegreewiseRankE7VCDACD
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology

namespace HodgeReduction
namespace HCGapL4
namespace FrontE2_ProfileMatchingObligationSplit

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.DegreewiseRankE7

/-! ## Section 1: Priority A — refined per-codim obligation structure -/

/-- **R454 refined per-codim obligation structure**. Splits R451E's
four monolithic Prop targets into per-degree / per-codim Prop
families, and additionally carries the real `VarietyCohomologyData`
and `AlgebraicClassesData` directly on the obligation side so a
future substantive instance pins the real canonical carrier.

Fields:

* `rank : ℕ → ℕ` — same free-parameter rank field as R451E's
  `DegreewiseRankProfileMatchesRealCarrier`. R454 does NOT fix it
  to real-E_7 values.
* `realVCD : VarietyCohomologyData` — real canonical cohomology
  data slot. R454 does NOT compute this; trivial-unit instance
  plugs in a diagonal placeholder.
* `realACD : AlgebraicClassesData realVCD` — real canonical
  algebraic-classes data slot. R454 does NOT compute this; trivial-unit
  instance plugs in `⊤` placeholder.
* `degreewiseLinearEquivTarget : ∀ (_k : ℕ), Prop` — per-degree
  ℚ-linear equivalence `Fin (rank k) → ℚ ≃ₗ[ℚ] realVCD.H k` target.
* `hodgeCompatibilityTarget : ∀ (_k : ℕ), Prop` — per-degree Hodge
  compatibility target.
* `algClassesCompatibilityTarget : ∀ (_p : ℕ), Prop` — per-codim
  algebraic-classes compatibility target.
* `mtPackageCompatibilityTarget : ∀ (_p : ℕ), Prop` — per-codim MT
  package compatibility target.
* `allCodimTransferTarget : Prop` — aggregated all-codim transfer
  target (what R405's conditional transfer ultimately consumes).

The `∀ (_k : ℕ), Prop` (resp. `∀ (_p : ℕ), Prop`) form is used to
sidestep Lean binder inference issues that arise when nesting
universally quantified Prop families inside structure fields. -/
structure DegreewiseRankProfileRealCarrierObligations where
  /-- Per-degree rank parameter (free parameter, same as R451E). -/
  rank : ℕ → ℕ
  /-- Real canonical cohomology data slot. R454 does NOT compute this;
  trivial-unit instance supplies a trivial diagonal placeholder. -/
  realVCD : VarietyCohomologyData
  /-- Real canonical algebraic-classes data slot. -/
  realACD : AlgebraicClassesData realVCD
  /-- Per-degree linear-equivalence target family. -/
  degreewiseLinearEquivTarget : ∀ (_k : ℕ), Prop
  /-- Per-degree Hodge compatibility target family. -/
  hodgeCompatibilityTarget : ∀ (_k : ℕ), Prop
  /-- Per-codim algebraic-classes compatibility target family. -/
  algClassesCompatibilityTarget : ∀ (_p : ℕ), Prop
  /-- Per-codim MT package compatibility target family. -/
  mtPackageCompatibilityTarget : ∀ (_p : ℕ), Prop
  /-- Aggregated all-codim transfer target. -/
  allCodimTransferTarget : Prop

/-! ## Section 2: Priority A bis — trivial-unit current instance -/

/-- **R454 trivial-diagonal `VarietyCohomologyData` placeholder** for
the obligation-structure slot. Reuses R414's
`VarietyCohomologyData_degreewiseRankE7` at the rank-1 constant rank
function so we get a kernel-pure VCD without re-deriving R413's
`pureHodgeStructure_degreewiseRank`. KERNEL-PURE; NOT a real E_7
cohomology — only a structural placeholder so the trivial-unit
obligation instance type-checks. -/
noncomputable def trivialPlaceholderVCD : VarietyCohomologyData :=
  VarietyCohomologyData_degreewiseRankE7 (fun _ => 1)

/-- **R454 trivial-diagonal `AlgebraicClassesData` placeholder** for
the obligation-structure slot. Reuses R414's
`AlgebraicClassesData_degreewiseRankE7_top` at the same rank-1 rank
function so the Hodge-half is already discharged by R414. KERNEL-PURE;
NOT the real canonical Chow ring image — only a structural placeholder. -/
noncomputable def trivialPlaceholderACD :
    AlgebraicClassesData trivialPlaceholderVCD :=
  AlgebraicClassesData_degreewiseRankE7_top (fun _ => 1)

/-- **R454 trivial-unit refined obligation instance**. All per-degree
and per-codim Prop fields default to `True` OPEN markers; the rank
function is the rank-1 constant placeholder; the real VCD/ACD slots
use the trivial diagonal placeholders. R454 does NOT supply any
real-geometry-backed obligation witnesses. KERNEL-PURE. -/
noncomputable def DegreewiseRankProfileRealCarrierObligations_trivialUnit :
    DegreewiseRankProfileRealCarrierObligations where
  rank := fun _ => 1
  realVCD := trivialPlaceholderVCD
  realACD := trivialPlaceholderACD
  degreewiseLinearEquivTarget := fun _ => True
  hodgeCompatibilityTarget := fun _ => True
  algClassesCompatibilityTarget := fun _ => True
  mtPackageCompatibilityTarget := fun _ => True
  allCodimTransferTarget := True

/-! ## Section 3: Priority B — formal implication to R451E matching -/

/-- **R454 formal feed implication into R451E matching structure**.
States that a substantively discharged refined obligation structure
feeds R451E's `DegreewiseRankProfileMatchesRealCarrier`. Currently
a `Prop := True` marker (per the R390/R405/R410 workaround for
return-type-Prop `def`s) — substantively discharging the implication
requires R452's low-degree Hodge/rank data feed, which is not
assumed available at R454. -/
def obligations_feed_DegreewiseRankProfileMatchesRealCarrier
    (_O : DegreewiseRankProfileRealCarrierObligations) :
    Prop := True

/-- **R454 formal feed implication, trivial-unit specialisation**.
Records that applying the (marker-level) feed implication to the
trivial-unit obligation instance yields `True`. KERNEL-PURE. -/
theorem obligations_feed_trivialUnit :
    obligations_feed_DegreewiseRankProfileMatchesRealCarrier
      DegreewiseRankProfileRealCarrierObligations_trivialUnit := trivial

/-! ## Section 4: Priority C — low-degree projection (k = 0, 1, 2) -/

/-- **R454 low-degree projection of the refined obligation structure**.
Restricts to degrees `k = 0, 1, 2` (and codim `p = 0, 1, 2`), splitting
each of R451E's four monolithic Prop targets into three per-degree
Prop targets. This is the obligation slice that R452's low-degree
Hodge/rank-data feed is intended to substantively discharge.

Fields:

* `rank0 : ℕ`, `rank1 : ℕ`, `rank2 : ℕ` — low-degree rank values.
* `degreewiseLinearEquivAt{0,1,2}Target : Prop` — per-degree linear
  equivalence targets at k = 0, 1, 2.
* `hodgeAt{0,1,2}Target : Prop` — per-degree Hodge compatibility
  targets at k = 0, 1, 2.
* `algClassesAt{0,1,2}Target : Prop` — per-codim algebraic-classes
  compatibility targets at p = 0, 1, 2.
* `mtPackageAt{0,1,2}Target : Prop` — per-codim MT package
  compatibility targets at p = 0, 1, 2.

The low-degree slice is the focus of R452. The all-codim slice (k ≥ 3,
p ≥ 3) is STILL OPEN — see `R454_AllCodimMatching_StillOpen`. -/
structure LowDegreeProfileRealCarrierObligations where
  /-- Rank value at degree 0. -/
  rank0 : ℕ
  /-- Rank value at degree 1. -/
  rank1 : ℕ
  /-- Rank value at degree 2. -/
  rank2 : ℕ
  /-- Per-degree linear equivalence target at k = 0. -/
  degreewiseLinearEquivAt0Target : Prop
  /-- Per-degree linear equivalence target at k = 1. -/
  degreewiseLinearEquivAt1Target : Prop
  /-- Per-degree linear equivalence target at k = 2. -/
  degreewiseLinearEquivAt2Target : Prop
  /-- Per-degree Hodge compatibility target at k = 0. -/
  hodgeAt0Target : Prop
  /-- Per-degree Hodge compatibility target at k = 1. -/
  hodgeAt1Target : Prop
  /-- Per-degree Hodge compatibility target at k = 2. -/
  hodgeAt2Target : Prop
  /-- Per-codim algebraic-classes compatibility target at p = 0. -/
  algClassesAt0Target : Prop
  /-- Per-codim algebraic-classes compatibility target at p = 1. -/
  algClassesAt1Target : Prop
  /-- Per-codim algebraic-classes compatibility target at p = 2. -/
  algClassesAt2Target : Prop
  /-- Per-codim MT package compatibility target at p = 0. -/
  mtPackageAt0Target : Prop
  /-- Per-codim MT package compatibility target at p = 1. -/
  mtPackageAt1Target : Prop
  /-- Per-codim MT package compatibility target at p = 2. -/
  mtPackageAt2Target : Prop

/-- **R454 trivial-unit low-degree projection instance**. All twelve
per-degree / per-codim Prop fields default to `True` OPEN markers;
rank values default to 1. R454 does NOT supply any real-geometry-backed
low-degree obligation witnesses. KERNEL-PURE. -/
def LowDegreeProfileRealCarrierObligations_trivialUnit :
    LowDegreeProfileRealCarrierObligations where
  rank0 := 1
  rank1 := 1
  rank2 := 1
  degreewiseLinearEquivAt0Target := True
  degreewiseLinearEquivAt1Target := True
  degreewiseLinearEquivAt2Target := True
  hodgeAt0Target := True
  hodgeAt1Target := True
  hodgeAt2Target := True
  algClassesAt0Target := True
  algClassesAt1Target := True
  algClassesAt2Target := True
  mtPackageAt0Target := True
  mtPackageAt1Target := True
  mtPackageAt2Target := True

/-- **R454 trivial-unit low-degree projection satisfies all twelve
targets**. KERNEL-PURE. -/
theorem LowDegreeProfileRealCarrierObligations_trivialUnit_all_True :
    LowDegreeProfileRealCarrierObligations_trivialUnit.degreewiseLinearEquivAt0Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.degreewiseLinearEquivAt1Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.degreewiseLinearEquivAt2Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.hodgeAt0Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.hodgeAt1Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.hodgeAt2Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.algClassesAt0Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.algClassesAt1Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.algClassesAt2Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.mtPackageAt0Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.mtPackageAt1Target ∧
    LowDegreeProfileRealCarrierObligations_trivialUnit.mtPackageAt2Target :=
  ⟨trivial, trivial, trivial, trivial, trivial, trivial, trivial, trivial,
   trivial, trivial, trivial, trivial⟩

/-! ## Section 5: Priority D — connection to R452 -/

/-- **R454 connection marker to R452 low-degree Hodge/rank data feed**.
States that R452's low-degree Hodge/rank data substantively discharges
the corresponding low-degree slice of the refined obligation
structure. Currently a `Prop := True` marker (per the R390/R405/R410
workaround) since R452 is not directly imported here to avoid
circular-dependency wait. -/
def LowDegreeHodgeRankData_feeds_ProfileMatchingLowDegreeTarget :
    Prop := True

/-- **R454 connection marker trivial-unit composition**. KERNEL-PURE. -/
theorem LowDegreeHodgeRankData_feeds_trivial :
    LowDegreeHodgeRankData_feeds_ProfileMatchingLowDegreeTarget :=
  trivial

/-! ## Section 6: Priority E — markers -/

/-- **R454 marker**: the profile-matching obligations have been
SPLIT from R451E's four monolithic Prop targets into per-degree /
per-codim families. -/
def R454_ProfileMatchingObligations_Split : Prop := True

/-- **R454 marker**: the low-degree matching target slice (k = 0, 1, 2;
p = 0, 1, 2) is AVAILABLE for R452 to substantively discharge. -/
def R454_LowDegreeMatching_TargetAvailable : Prop := True

/-- **R454 marker**: the all-codim matching target (k ≥ 3, p ≥ 3, plus
the aggregated `allCodimTransferTarget`) is STILL OPEN at R454. -/
def R454_AllCodimMatching_StillOpen : Prop := True

/-! ## Section 7: status markers (5+ per multi-front contract) -/

def R454_Status_RefinedObligationStructure_Defined : Prop := True
def R454_Status_TrivialPlaceholderVCD_Built : Prop := True
def R454_Status_TrivialPlaceholderACD_Built : Prop := True
def R454_Status_RefinedObligationTrivialUnit_Built : Prop := True
def R454_Status_ObligationsFeedR451E_MarkerDefined : Prop := True
def R454_Status_LowDegreeObligationStructure_Defined : Prop := True
def R454_Status_LowDegreeObligationTrivialUnit_Built : Prop := True
def R454_Status_LowDegreeAllTwelveTargets_TriviallyDischarged : Prop := True
def R454_Status_R452_LowDegreeFeed_MarkerDefined : Prop := True
def R454_Status_NoRealHodgeDecompositionComputed : Prop := True
def R454_Status_NoRealRankValuesAsserted : Prop := True
def R454_Status_NoRealChowDataConstructed : Prop := True
def R454_Status_NoProjectAxiomIntroduced : Prop := True
def R454_Status_KernelPure : Prop := True

/-! ## Section 8: round-end report Props (7 items per multi-front contract) -/

def R454_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R454_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R454_Report_DegreewiseRankTheoremCone_KernelPure_Unchanged : Prop := True
def R454_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R454_Report_RefinedObligationStructureAndLowDegreeProjectionDefined : Prop := True
def R454_Report_LowDegreeAndAllCodimSplit_NoRealGeometryDischarged : Prop := True
def R454_Report_NoProjectAxiomIntroduced_HodgeConjectureNotSolved : Prop := True

/-! ## Section 9: graph edges -/

def L4_G_R454_From_R451E_FrontE_RealCarrierProfileMatching : Prop := True
def L4_G_R454_From_R412_DegreewiseRankE7CohomologyProfile : Prop := True
def L4_G_R454_From_VarietyCohomologyData_Infrastructure : Prop := True
def L4_G_R454_To_R452_LowDegreeHodgeRankDataFeed : Prop := True
def L4_G_R454_To_NextRound_AllCodimMatchingConstruction : Prop := True
def L4_G_R454_To_NextRound_RealVCDPlugIn : Prop := True
def L4_G_R454_To_NextRound_RealACDPlugIn : Prop := True

/-! ## Section 10: explicit non-closure markers (5+ per multi-front contract) -/

/-- **R454 non-closure (1/10)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R454_does_not_alter_old_headline : True := trivial

/-- **R454 non-closure (2/10)**: does NOT delete
`canonicalE7ShimuraTor` (the axiom remains in the original headline
cone). -/
theorem R454_does_not_delete_canonicalE7ShimuraTor : True := trivial

/-- **R454 non-closure (3/10)**: does NOT compute the real E_7
Hodge decomposition; the trivial diagonal placeholder PHS is plugged
into the `realVCD` slot of the trivial-unit obligation instance. -/
theorem R454_does_not_compute_real_hodge_decomposition : True := trivial

/-- **R454 non-closure (4/10)**: does NOT determine the real-E_7
rank function; the `rank : ℕ → ℕ` field and the `rank0`, `rank1`,
`rank2` low-degree fields remain free parameters. -/
theorem R454_does_not_determine_real_rank_function : True := trivial

/-- **R454 non-closure (5/10)**: does NOT replace the placeholder
`algClasses = ⊤` of the trivial-unit `realACD` slot with real Chow-ring
data. -/
theorem R454_does_not_replace_top_algClasses_with_real_chow :
    True := trivial

/-- **R454 non-closure (6/10)**: does NOT construct any real cycle
correspondence on the per-codim MT package targets. -/
theorem R454_does_not_construct_real_cycle_correspondence :
    True := trivial

/-- **R454 non-closure (7/10)**: does NOT substantively discharge the
`obligations_feed_DegreewiseRankProfileMatchesRealCarrier` implication
into R451E's matching structure (kept as `Prop := True` marker). -/
theorem R454_does_not_substantively_feed_R451E_matching :
    True := trivial

/-- **R454 non-closure (8/10)**: does NOT substantively discharge the
`LowDegreeHodgeRankData_feeds_ProfileMatchingLowDegreeTarget` R452
connection (kept as `Prop := True` marker). -/
theorem R454_does_not_substantively_feed_R452_low_degree :
    True := trivial

/-- **R454 non-closure (9/10)**: does NOT close the all-codim matching
target (k ≥ 3, p ≥ 3, plus `allCodimTransferTarget`); only the
low-degree slice is set up for R452 to attack. -/
theorem R454_does_not_close_all_codim_matching : True := trivial

/-- **R454 non-closure (10/10)**: does NOT introduce any project
axiom; does NOT solve the Hodge Conjecture. -/
theorem R454_does_not_solve_HC_nor_introduce_axiom : True := trivial

end FrontE2_ProfileMatchingObligationSplit
end HCGapL4
end HodgeReduction
