/-
# HC Gap L4 — Toy → Real E_7-Shimura HC transfer (R390).

R389 declared the toy-to-real VCD identification bridge structure
(`ToyToRealE7VCDIdentification`) and a Prop-only weak variant; no
instance of the strong bridge was constructed (would require real
geometric content for the canonical E_7-Shimura variety).

R390 (this file) supplies the **HC TRANSFER MACHINERY** along the
bridge. The transfer is proved KERNEL-PURE via the existing R177
`varietyHCAt_of_correspondence` — given per-codimension
`MTCorrespondencePackageAt` witnesses between toy and real, a full
`VarietyHC` on the toy carrier lifts to `VarietyHC` on the real
carrier.

The missing piece (NOT discharged here) is the per-codimension
`MTCorrespondencePackageAt` between toy and real. R390 explicitly
isolates the three missing geometric witnesses.

## Design

* `ToyToRealHCTransferData` — Prop-only bundle tracking the bridge +
  three open obligations (algebraic-class image compatibility, Hodge-class
  image compatibility, all-codim transport).
* `VarietyHC_transfer_of_toyToReal_propLevel` — trivial Prop-level
  marker (matches the user-specified shape).
* `VarietyHC_transfer_of_toyToReal_via_packages` — **substantive
  theorem**: per-p `MTCorrespondencePackageAt` hypothesis + toy HC
  yields real HC. KERNEL-PURE proof via R177.
* `MissingWitness_*` markers — the three sub-witnesses that R389's
  weak bridge does NOT yet supply.

## Round-end report (per user contract)

1. Toy theorem cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Original theorem cone: `hodgeConjectureReal_canonical` cone still
   contains `canonicalE7ShimuraTor` — UNCHANGED.
3. Toy ↔ real bridge closed? **NO**. The substantive transfer is
   conditional on per-p MT packages; those packages are still missing.
4. Original headline switchable? **NO**. R391 will audit explicitly.

## What R390 does NOT do

* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT construct any per-codimension `MTCorrespondencePackageAt`
  between toy and real carriers.
* Does NOT instantiate the strong R389 bridge.

All R390 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.ToyToRealE7VCDIdentification

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: HC transfer data bundle (Prop-only) -/

/-- **R390 HC transfer data bundle**: tracks the weak VCD bridge + three
substantive geometric obligations needed for HC transfer. Prop-only:
this structure does NOT execute the transfer, only records the
obligation slots. -/
structure ToyToRealHCTransferData where
  vcdBridge : ToyToRealE7VCDIdentificationWeak
  /-- Open obligation: algebraic class image compatibility along the
  bridge (ψ_p maps toyACD.algClasses p into realACD.algClasses p
  consistently with the underlying VCD identification). -/
  algClassesBridgeTarget : Prop
  /-- Open obligation: Hodge class image compatibility along the bridge
  (real.hodgeClasses p ⊆ image of toy.hodgeClasses p under φ_p). -/
  hodgeClassesBridgeTarget : Prop
  /-- Open obligation: ∀-codim per-p MT correspondence package
  existence between toy and real. -/
  allCodimTransferTarget : Prop

/-! ## Section 2: pin to R389 weak bridge + open obligations -/

/-- **R390 default transfer data pin**: uses R389's weak bridge
(`toy = E7ShimuraToy`, `real = canonicalE7ShimuraTor.cohomologyOfUnderlying`)
and leaves all three substantive obligations OPEN. -/
noncomputable def ToyToRealHCTransferData_pin :
    ToyToRealHCTransferData where
  vcdBridge := ToyToRealE7VCDIdentificationWeak_pin
  algClassesBridgeTarget := True   -- open
  hodgeClassesBridgeTarget := True  -- open
  allCodimTransferTarget := True    -- open

/-! ## Section 3: Prop-level transfer theorem (user-specified shape) -/

/-- **R390 Prop-level transfer marker**: matches the user-specified
shape `… : Prop := True`. Used to TRACK the transfer obligation at the
marker level; the substantive theorem is in Section 4.

Implemented as `def` (not `theorem`) because the return TYPE is `Prop`
(a Type, not a proposition), so this defines a Prop-valued function. -/
def VarietyHC_transfer_of_toyToReal_propLevel
    {toyVCD : VarietyCohomologyData}
    {toyACD : AlgebraicClassesData toyVCD}
    (_hToy : VarietyHC toyVCD toyACD)
    (_bridge : ToyToRealHCTransferData) :
    Prop := True

/-! ## Section 4: substantive transfer theorem (KERNEL-PURE via R177) -/

/-- **R390 substantive HC transfer**: given a per-codimension
`MTCorrespondencePackageAt` between two VCDs (the "all-codim transfer"
target packaged) + HC on the source VCD, the target VCD also satisfies
HC. KERNEL-PURE proof via the existing R177
`varietyHCAt_of_correspondence`.

This isolates the OPEN WITNESS: a per-p `MTCorrespondencePackageAt`
between `bridge.toyVCD` and `bridge.realVCD`. R390 does NOT construct
this witness for the R389-pinned weak bridge (toy → real).

Note: the strong R389 bridge's `degreewiseLinearEquiv` field would
DIRECTLY supply `φ` for each per-p package, but the remaining package
fields (`ψ` on algebraic classes, the commuting square, and Hodge-class
surjectivity) still require independent witnesses. Even with a strong
bridge instance, the per-p packages do not assemble automatically. -/
theorem VarietyHC_transfer_of_toyToReal_via_packages
    {toyVCD realVCD : VarietyCohomologyData}
    {toyACD : AlgebraicClassesData toyVCD}
    {realACD : AlgebraicClassesData realVCD}
    (hPkg : ∀ p, MTCorrespondencePackageAt toyVCD realVCD toyACD realACD p)
    (hToy : VarietyHC toyVCD toyACD) :
    VarietyHC realVCD realACD := by
  intro p
  exact varietyHCAt_of_correspondence (hPkg p) (hToy p)

/-! ## Section 5: codim-1 specialisation -/

/-- **R390 codim-1 specialisation**: if a single-codim
`MTCorrespondencePackageAt` exists at p=1 and toy HC at p=1 holds,
then real HC at p=1 holds. Direct R177 application. -/
theorem VarietyHCAt_codim1_transfer_of_toyToReal
    {toyVCD realVCD : VarietyCohomologyData}
    {toyACD : AlgebraicClassesData toyVCD}
    {realACD : AlgebraicClassesData realVCD}
    (hPkg : MTCorrespondencePackageAt toyVCD realVCD toyACD realACD 1)
    (hToy : VarietyHCAt toyVCD toyACD 1) :
    VarietyHCAt realVCD realACD 1 :=
  varietyHCAt_of_correspondence hPkg hToy

/-! ## Section 6: missing-witness markers (per R390 contract) -/

/-- **R390 missing witness (1/3)**: algebraic class image compatibility.
For each codim p, need a ℚ-linear `ψ_p : toyACD.algClasses p →ₗ[ℚ]
realACD.algClasses p` consistent with the chosen `φ_p` (whether
identity-like from a strong bridge or an arbitrary HSM). -/
def MissingWitness_AlgClassImageCompatibility_PerCodim : Prop := True

/-- **R390 missing witness (2/3)**: Hodge class image compatibility.
For each codim p, need `real.hodgeClasses p ≤ Submodule.map φ_p
toy.hodgeClasses p`. This is the surjectivity-on-Hodge-classes leg of
the R165/R176 correspondence machinery. -/
def MissingWitness_HodgeClassImageCompatibility_PerCodim : Prop := True

/-- **R390 missing witness (3/3)**: all-codim package transport.
The per-p packages must assemble ∀ p ∈ ℕ. Without restricting to
finitely-many non-trivial codims (which would require knowing the
geometric dimension of the real carrier), this is an infinite family
of obligations. -/
def MissingWitness_AllCodim_PackageFamily_Transport : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

/-- **R390 report (1/4)**: toy theorem cone = kernel-pure, UNCHANGED. -/
def R390_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True

/-- **R390 report (2/4)**: original theorem cone still contains
`canonicalE7ShimuraTor`, UNCHANGED. -/
def R390_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged :
    Prop := True

/-- **R390 report (3/4)**: toy ↔ real bridge CLOSED? NO. The
substantive transfer theorem is conditional on per-p MT packages
which are still missing. -/
def R390_Report_ToyToRealBridge_NotClosed : Prop := True

/-- **R390 report (4/4)**: original headline SWITCHABLE? NO. R391
will audit explicitly. -/
def R390_Report_OriginalHeadline_NotSwitchable : Prop := True

/-! ## Section 8: status / markers -/

def R390_Status_TransferDataStructure_Defined : Prop := True
def R390_Status_TransferDataPin_Created : Prop := True
def R390_Status_PropLevelMarker_Available : Prop := True
def R390_Status_SubstantiveTransferTheorem_Closed_KernelPure : Prop := True
def R390_Status_Codim1_Specialisation_Closed : Prop := True
def R390_Status_ThreeMissingWitnesses_Isolated : Prop := True

def L4_G_R390_To_R391_HeadlineReplacementSafetyAudit : Prop := True
def L4_G_R390_To_Future_RealCanonical_MTPackage_Construction : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R390 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R390_does_not_delete_canonical_axiom : True := trivial

/-- **R390 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R390_does_not_alter_old_headline : True := trivial

/-- **R390 non-closure (3/5)**: does NOT construct per-codim
`MTCorrespondencePackageAt` between toy and real. -/
theorem R390_does_not_construct_toyToReal_MTPackages : True := trivial

/-- **R390 non-closure (4/5)**: does NOT identify toy carrier with real
E_7-Shimura variety. -/
theorem R390_does_not_identify_toy_with_real : True := trivial

/-- **R390 non-closure (5/5)**: does NOT instantiate the strong R389
bridge `ToyToRealE7VCDIdentification`. -/
theorem R390_does_not_instantiate_strong_bridge : True := trivial

end HCGapL4
end HodgeReduction
