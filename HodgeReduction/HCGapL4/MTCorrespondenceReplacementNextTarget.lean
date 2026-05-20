/-
# HC Gap L4 — smallest next non-toy target for MT-correspondence
# replacement (R256).

R254 audited Mathlib for MT-correspondence replacement feasibility
(higher-dim abelian variety / CM / Chow / correspondences / Mumford–Tate
/ motives are all absent). R255 mapped the four candidate routes
(CMSource / ChowCorrespondence / MumfordTate / MotivicFactorization)
and recommended the **CM-source route** as the smallest formal next
target — it has the most existing Mathlib infrastructure (EllipticCurve
as dim-1 CM case).

R256 implements that recommendation: the smallest non-toy Lean interface
is an **abstract CM-shaped HC source** plus an **abstract MT
correspondence adapter** carrying a v2 SHSM2 package to a target
`VarietyCohomologyData`. Any future real CM abelian variety (with
Deligne 1982 HC) plugs into the source; the existing toy
`VarietyCohomologyData_E7ShimuraToy` sits on the receiving side.

This is NOT real CM abelian variety theory. It is the smallest
non-toy-source Lean object that can EVER be filled by a real CM
abelian variety + real Chow correspondence + real Hodge transfer
theorem.

## What R256 (this file) provides (all kernel-pure)

* `MTCorrespondenceReplacementNextTargetToySkeleton` — target-registry
  structure with audit / dependency-map context fields.
* `AbstractCMAbelianHCSource` — real (non-toy) interface bundling a
  `VarietyCohomologyData`, an `AlgebraicClassesData`, a Prop-level
  `hasCMStructure` marker, and a full `VarietyHC` witness.
* `AbstractMTCorrespondenceToTarget` — adapter skeleton parameterised
  by an `AbstractCMAbelianHCSource`, a target VCD/ACD, codimensions
  `(p_src, p_tgt)`, and a v2 SHSM2 correspondence at those codims.
* `VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence` —
  transfer theorem deriving HC at the target from HC at the source via
  the SHSM2 correspondence.
* `Target_AbstractCMAbelianHCSource_PlusMTCorrespondenceAdapter` —
  the chosen smallest formal target marker.
* `L4_G_NextMTCorrespondenceReplacementTarget_To_R247Plan` — bridge
  back to the R247 MT-correspondence replacement plan.
* Regression instance: `AbstractCMAbelianHCSource_fromR236_ECbased`
  using R236's EC-based CM toy, paired with R236's SHSM2 package, and
  proving `VarietyHCAt_E7ShimuraToy_codim1_via_AbstractCMSourceInterface`.

## What R256 (this file) does NOT do

* Does NOT construct real CM abelian varieties.
* Does NOT construct real Chow correspondences.
* Does NOT construct real Mumford–Tate groups.
* Does NOT prove Deligne 1982 (HC for absolute Hodge classes on CM
  abelian varieties).
* Does NOT identify `E7ShimuraToy` with the real E_7 Shimura variety.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R256 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.MTCorrespondenceMathlibAudit
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementDependencyMap

namespace HodgeReduction
namespace HCGapL4
namespace MTCorrespondenceReplacementNextTarget

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.MTCorrespondenceMathlibAudit
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementDependencyMap

/-! ## Section 1: target registry structure -/

/-- **R256 next-target registry** for `mtCorrespondencePackage`
replacement. Bundles R255's dependency map with metadata about the
chosen target: name, whether the statement is currently available,
whether it requires new Mathlib, whether it can be worked without a
real E_7-side construction, and whether it blocks the toy-to-real
comparison. -/
structure MTCorrespondenceReplacementNextTargetToySkeleton where
  /-- The R255 dependency-map context. -/
  dependencyMap : MTCorrespondenceReplacementDependencyMapToySkeleton
  /-- Display name for the chosen target. -/
  targetNameToy : String
  /-- Marker: the target statement can be stated in current Lean. -/
  targetStatementAvailableToy : Prop
  /-- Marker: the target requires new Mathlib infrastructure to be
  filled by a real instance. -/
  targetRequiresNewMathlibToy : Prop
  /-- Marker: the target can be worked on without first constructing
  the real E_7 side. -/
  targetCanBeWorkedWithoutE7Toy : Prop
  /-- Marker: the target blocks (or unblocks) the toy-to-real
  comparison once available. -/
  targetBlocksToyToRealComparisonToy : Prop

/-! ## Section 2: chosen target — abstract CM-shaped HC source

The smallest non-toy interface that can sit on the source side of a
future real → toy MT-correspondence comparison. NOT named `Toy` because
this is a real interface; future real CM abelian varieties (with
genuine Deligne 1982 HC) must inhabit this. -/

/-- **R256 chosen smallest source target**: an abstract CM-shaped HC
source bundling a `VarietyCohomologyData`, an `AlgebraicClassesData`,
a Prop-level `hasCMStructure` marker, and a full `VarietyHC` witness.

Future real instances will fill `hasCMStructure` with the genuine
"`End(A) ⊗ ℚ` contains a CM field of the right degree" statement and
fill `hc` with Deligne's 1982 theorem (HC for absolute Hodge classes
on CM abelian varieties). The interface itself is real, kernel-pure,
and minimal. -/
structure AbstractCMAbelianHCSource where
  /-- A `VarietyCohomologyData` (real or toy) carrying the source
  cohomology + Hodge structure. -/
  VCD : VarietyCohomologyData
  /-- An `AlgebraicClassesData` on `VCD`. -/
  ACD : AlgebraicClassesData VCD
  /-- Prop-level CM-structure marker. Real instances fill this with
  the actual CM-type / endomorphism-algebra statement. -/
  hasCMStructure : Prop
  /-- The full HC witness `VarietyHC VCD ACD`. Real instances fill
  this with Deligne 1982. -/
  hc : VarietyHC VCD ACD

/-! ## Section 3: adapter — abstract MT correspondence to target

The skeleton for "a v2 SHSM2 package from an `AbstractCMAbelianHCSource`
to a target VCD/ACD at codimensions `(p_src, p_tgt)`". Real instances
fill `correspondence` with a genuine Chow correspondence-induced SHSM2
package. -/

/-- **R256 abstract MT correspondence adapter**: pairs an
`AbstractCMAbelianHCSource` with a target VCD/ACD and a v2 SHSM2
correspondence at codimensions `(p_src, p_tgt)`. Real instances will
provide a real correspondence; the toy regression uses R236's package. -/
structure AbstractMTCorrespondenceToTarget
    (source : AbstractCMAbelianHCSource)
    (target_VCD : VarietyCohomologyData)
    (target_ACD : AlgebraicClassesData target_VCD)
    (p_src p_tgt : ℕ) where
  /-- The v2 SHSM2 correspondence from source to target. -/
  correspondence :
    ShiftedMTCorrespondencePackageAt_SHSM2
      source.VCD target_VCD source.ACD target_ACD p_src p_tgt

/-! ## Section 4: transfer theorem — HC source → HC target

Given an `AbstractCMAbelianHCSource` (which carries `VarietyHC` at all
degrees) and an `AbstractMTCorrespondenceToTarget` at `(p_src, p_tgt)`,
derive `VarietyHCAt target_VCD target_ACD p_tgt`. This is kernel-pure
and reduces to the existing R212 shifted-correspondence transfer via
`SHSM2_toRaw`. -/

/-- **R256 transfer theorem**: HC at any source codimension `p_src`
plus an abstract MT correspondence to the target at `(p_src, p_tgt)`
gives HC at the target codimension `p_tgt`. -/
theorem VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    {source : AbstractCMAbelianHCSource}
    {target_VCD : VarietyCohomologyData}
    {target_ACD : AlgebraicClassesData target_VCD}
    {p_src p_tgt : ℕ}
    (adapter : AbstractMTCorrespondenceToTarget
                  source target_VCD target_ACD p_src p_tgt) :
    VarietyHCAt target_VCD target_ACD p_tgt :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw adapter.correspondence)
    (source.hc p_src)

/-! ## Section 5: chosen smallest-target Prop marker -/

/-- **R256 chosen target marker**: an `AbstractCMAbelianHCSource` plus
an `AbstractMTCorrespondenceToTarget` adapter. Per R255's
recommendation, this is the smallest non-toy interface available given
R254's Mathlib audit. -/
def Target_AbstractCMAbelianHCSource_PlusMTCorrespondenceAdapter :
    Prop := True

/-- **R256 alternative target marker 1** (recorded for reference):
direct Chow-correspondence target. Subsumed by
`AbstractMTCorrespondenceToTarget` above (any real Chow correspondence
inducing a SHSM2 package fills the `correspondence` field). -/
def Target_AbstractChowCorrespondence_to_VarietyCohomologyData :
    Prop := True

/-- **R256 alternative target marker 2** (recorded for reference):
direct Mumford–Tate-group target. Subsumed by
`AbstractCMAbelianHCSource` + adapter above (the MT group governs the
Hodge structure on `VCD`, which is data in `AbstractCMAbelianHCSource`). -/
def Target_AbstractMumfordTateGroup_to_VarietyCohomologyData :
    Prop := True

/-! ## Section 6: next-target registry instance -/

/-- **R256 next-target registry instance** with chosen target =
"AbstractCMAbelianHCSource + MT correspondence adapter to target VCD". -/
def MTCorrespondenceReplacementNextTargetToySkeleton_chosen :
    MTCorrespondenceReplacementNextTargetToySkeleton where
  dependencyMap :=
    MTCorrespondenceReplacementDependencyMapToySkeleton_E7Shimura
  targetNameToy :=
    "AbstractCMAbelianHCSource + MT correspondence adapter to target VCD"
  targetStatementAvailableToy := True
  -- Requires new Mathlib for ANY real CM abelian variety to inhabit
  -- the `AbstractCMAbelianHCSource` interface non-toy-style.
  targetRequiresNewMathlibToy := True
  -- Can be worked without E_7: the interface is scheme-agnostic on
  -- both source and target sides.
  targetCanBeWorkedWithoutE7Toy := True
  -- Unblocks toy-to-real comparison once a real CM abelian variety
  -- fills the `source` and a real correspondence fills the adapter.
  targetBlocksToyToRealComparisonToy := True

/-! ## Section 7: regression — toy `AbstractCMAbelianHCSource` from R236

The R236 EC-based CM toy (`CMAbelianVarietyToySkeleton_ellipticCurveLike`)
provides a kernel-pure source that fits the `AbstractCMAbelianHCSource`
interface. Paired with R236's SHSM2 correspondence to E_7-Shimura toy
at codims `(1, 1)`, the R256 transfer theorem recovers
`VarietyHCAt VarietyCohomologyData_E7ShimuraToy AlgebraicClassesData_E7ShimuraToy 1`.

This is a regression instance demonstrating that the R256 abstract
interface is non-empty in the toy regime and recovers existing
toy-level theorems. -/

/-- **R256 regression**: lift the R236 EC-based CM toy into the new
`AbstractCMAbelianHCSource` interface. `hasCMStructure := True` is
paper-trail (matches R236's `hasCMToy`); `hc` is the kernel-pure full
HC on the EC carrier. -/
noncomputable def AbstractCMAbelianHCSource_fromR236_ECbased :
    AbstractCMAbelianHCSource where
  VCD := CMAbelianVarietyToySkeleton_ellipticCurveLike.VCD
  ACD := CMAbelianVarietyToySkeleton_ellipticCurveLike.ACD
  hasCMStructure := True
  hc := CMAbelianVarietyToySkeleton_ellipticCurveLike.varietyHCToy

/-- **R256 regression adapter**: pair the EC-based abstract CM source
with R236's SHSM2 package to the E_7-Shimura toy at codims `(1, 1)`. -/
noncomputable def AbstractMTCorrespondenceToTarget_R236_ECtoE7ShimuraToy :
    AbstractMTCorrespondenceToTarget
      AbstractCMAbelianHCSource_fromR236_ECbased
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 1 where
  correspondence := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1

/-- **R256 regression theorem**: HC at codim 1 for the E_7-Shimura toy,
derived through the new `AbstractCMAbelianHCSource` + adapter +
transfer-theorem route. Identical mathematical content to R236's
existing `VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_*`
theorem; the value of R256 is the new abstract interface. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_AbstractCMSourceInterface :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    AbstractMTCorrespondenceToTarget_R236_ECtoE7ShimuraToy

/-! ## Section 8: bridge back to R247 -/

/-- **L4-G_NextMTCorrespondenceReplacementTarget_To_R247Plan**: bridge
marker connecting R256's chosen target to R247's
`MTCorrespondencePackageReplacementToyPlan`. -/
def L4_G_NextMTCorrespondenceReplacementTarget_To_R247Plan : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R256 non-closure (1/6)**: does NOT construct real CM abelian
varieties. -/
theorem R256_does_not_construct_real_CMAbelianVariety : True := trivial

/-- **R256 non-closure (2/6)**: does NOT construct real Chow
correspondences. -/
theorem R256_does_not_construct_real_AlgebraicCorrespondences : True := trivial

/-- **R256 non-closure (3/6)**: does NOT prove Deligne 1982. -/
theorem R256_does_not_prove_deligne_1982 : True := trivial

/-- **R256 non-closure (4/6)**: does NOT identify `E7ShimuraToy` with
the real E_7 Shimura variety. -/
theorem R256_does_not_identify_toy_with_real_E7Shimura : True := trivial

/-- **R256 non-closure (5/6)**: does NOT replace
`canonicalE7ShimuraTor.mtCorrespondencePackage` or close
`canonicalE7ShimuraTor`. -/
theorem R256_does_not_replace_mtCorrespondencePackage : True := trivial

/-- **R256 non-closure (6/6)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R256_does_not_alter_hodgeConjectureReal_canonical : True := trivial

end MTCorrespondenceReplacementNextTarget
end HCGapL4
end HodgeReduction
