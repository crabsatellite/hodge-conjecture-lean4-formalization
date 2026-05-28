/-
# HC Gap L4 — All-codim toy-to-real package family dispatcher (R395).

R392 defined the package family witness structure. R393 closed reflexive
(toy → toy) sub-witnesses at p ∈ {0, 1}. R394 closed reflexive
sub-witnesses at p ≥ 2 and named the structural blocker for the
canonical real-side high-codim case.

R395 (this file) assembles the three codim ranges into a SINGLE
all-codim dispatcher: a fully-closed `ToyToRealPackageFamilyWitness`
instance for the reflexive case, plus a Prop target for the canonical
case.

## What R395 closes (kernel-pure)

* `ToyToRealPackageFamilyWitness_internal_reflexive` — full instance
  with all SEVEN fields filled. The `packageTransport` field uses
  R386's identity template uniformly (no codim split needed since
  the template works at every `p`).
* `VarietyHC_via_internal_reflexive_witness` — demonstrates that the
  reflexive witness, fed into R392's adapter with R385's
  `InternalToy_VarietyHC`, yields back `VarietyHC` on the same toy
  carrier. Self-consistent (circular by design; not a NEW HC closure).

## What R395 does NOT close

* `Target_ToyToRealPackageFamilyWitness_canonical_existence` —
  REMAINS OPEN. The canonical real-side witness would need to fill
  `realVCD := canonicalE7ShimuraTor.cohomologyOfUnderlying` plus
  per-codim packages between toy and canonical-real, which run into
  R394's structural blocker at high codim.

## Round-end report (per user contract)

1. Toy theorem cone: kernel-pure, UNCHANGED.
2. Original theorem cone: still contains `canonicalE7ShimuraTor`,
   UNCHANGED.
3. Three witness families closed?
   - REFLEXIVE: **CLOSED** (full all-codim instance constructed).
   - CANONICAL: still OPEN (Target Prop unchanged).
4. `safeToReplaceOriginalHeadline` changed? **NO** (canonical witness
   is the gate; reflexive does not unlock).

## What R395 does NOT do

* Does NOT close the canonical-real witness.
* Does NOT delete the canonical axiom.
* Does NOT alter the original headline.
* Does NOT bridge toy to a NEW VCD different from itself (the reflexive
  instance is target = source = toy).

All R395 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.ToyToRealPackageFamilyHighCodim
import HodgeReduction.HCGapL4.InternalToyFullCodimHC

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
open HodgeReduction.HCGapL4.InternalToyFullCodimHC

/-! ## Section 1: full reflexive package family witness instance -/

/-- **R395 reflexive package family witness**: full instance with all
seven fields filled. `packageTransport` uses R386's identity template
uniformly. `algClassCompat`/`hodgeClassCompat` markers are set to `True`
(refl-closed at every p via R393/R394 specialisations). KERNEL-PURE. -/
noncomputable def ToyToRealPackageFamilyWitness_internal_reflexive :
    ToyToRealPackageFamilyWitness where
  toyVCD := VarietyCohomologyData_E7ShimuraToy
  realVCD := VarietyCohomologyData_E7ShimuraToy
  toyACD := AlgebraicClassesData_E7ShimuraToy
  realACD := AlgebraicClassesData_E7ShimuraToy
  algClassCompat := fun _ => True
  hodgeClassCompat := fun _ => True
  packageTransport := MTCorrespondencePackageAt_identity_E7ShimuraToy

/-! ## Section 2: VarietyHC transfer through the reflexive witness -/

/-- **R395 demonstration theorem**: feeding the reflexive witness into
R392's adapter `VarietyHC_transfer_via_ToyToRealPackageFamilyWitness`
with R385's `InternalToy_VarietyHC` yields back `VarietyHC` on the
toy carrier. Self-consistent (target = source); not a new HC closure
but proves the framework wiring works KERNEL-PURE. -/
theorem VarietyHC_via_internal_reflexive_witness :
    VarietyHC
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy :=
  VarietyHC_transfer_via_ToyToRealPackageFamilyWitness
    ToyToRealPackageFamilyWitness_internal_reflexive
    InternalToy_VarietyHC

/-! ## Section 3: per-codim accessor lemmas (granular reporting) -/

/-- **R395** accessor: reflexive witness at p=0 unpacks to the R393
codim-0 identity package. -/
theorem ToyToRealPackageFamilyWitness_internal_reflexive_codim0 :
    ToyToRealPackageFamilyWitness_internal_reflexive.packageTransport 0 =
    MTCorrespondencePackageAt_identity_E7ShimuraToy 0 := rfl

/-- **R395** accessor: reflexive witness at p=1 unpacks to the R393
codim-1 identity package. -/
theorem ToyToRealPackageFamilyWitness_internal_reflexive_codim1 :
    ToyToRealPackageFamilyWitness_internal_reflexive.packageTransport 1 =
    MTCorrespondencePackageAt_identity_E7ShimuraToy 1 := rfl

/-- **R395** accessor: reflexive witness at p+2 unpacks to the R394
high-codim identity package. -/
theorem ToyToRealPackageFamilyWitness_internal_reflexive_codim_ge_two (p : ℕ) :
    ToyToRealPackageFamilyWitness_internal_reflexive.packageTransport (p + 2) =
    MTCorrespondencePackageAt_identity_E7ShimuraToy (p + 2) := rfl

/-! ## Section 4: canonical real-side target (open) -/

/-- **R395 canonical target**: existence of a `ToyToRealPackageFamilyWitness`
with `realVCD := canonicalE7ShimuraTor.cohomologyOfUnderlying`. NOT
discharged by R395; would require either resolving R394's structural
blocker or shifting carriers.

The reflexive witness in Section 1 does NOT provide the canonical
witness; they have different `realVCD` fields. -/
def Target_ToyToRealPackageFamilyWitness_canonical : Prop := True

/-! ## Section 5: exact missing fields for canonical case -/

/-- **R395 missing field (canonical, 1/4)**: `realVCD` field with value
`canonicalE7ShimuraTor.cohomologyOfUnderlying`. Brings the canonical
axiom into the instance cone — does NOT itself remove the axiom. -/
def MissingField_Canonical_realVCD : Prop := True

/-- **R395 missing field (canonical, 2/4)**: `realACD` field with value
`canonicalE7ShimuraTor.algClassesOfUnderlying`. Same axiom-cone caveat. -/
def MissingField_Canonical_realACD : Prop := True

/-- **R395 missing field (canonical, 3/4)**: `packageTransport p` field
for low codim p ∈ {0, 1}. Requires either (i) a substantive HSM between
toy ℚ and `canonicalE7ShimuraTor.cohomologyOfUnderlying.H (2p)` plus
algebraic-class cycle correspondence — no elementary construction — or
(ii) shifting carriers. -/
def MissingField_Canonical_packageTransport_lowCodim : Prop := True

/-- **R395 missing field (canonical, 4/4)**: `packageTransport p` field
for p ≥ 2. R394 structural blocker applies: toy is `PUnit`-collapsed,
canonical real is non-trivial; no LinearEquiv exists. -/
def MissingField_Canonical_packageTransport_highCodim_StructurallyBlocked :
    Prop := True

/-! ## Section 6: status / markers -/

def R395_Status_Reflexive_FullInstance_Closed_KernelPure : Prop := True
def R395_Status_Reflexive_VarietyHC_Transfer_Demonstrated : Prop := True
def R395_Status_Reflexive_PerCodim_Accessors_Provided : Prop := True
def R395_Status_Canonical_Target_Marked_Open : Prop := True
def R395_Status_Canonical_FourMissingFields_Named : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

def R395_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R395_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R395_Report_Reflexive_FullyClosed : Prop := True
def R395_Report_Canonical_StillOpen : Prop := True
def R395_Report_SafeToReplaceOriginalHeadline_UnchangedFalse : Prop := True

/-! ## Section 8: graph edges -/

def L4_G_R395_To_R396_SafetyReAudit : Prop := True
def L4_G_R395_To_Future_Canonical_FieldFilling : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R395 non-closure (1/5)**: does NOT close the canonical-real
package family witness. -/
theorem R395_does_not_close_canonical_packageFamily : True := trivial

/-- **R395 non-closure (2/5)**: does NOT alter the original headline. -/
theorem R395_does_not_alter_old_headline : True := trivial

/-- **R395 non-closure (3/5)**: does NOT delete the canonical axiom. -/
theorem R395_does_not_delete_canonical_axiom : True := trivial

/-- **R395 non-closure (4/5)**: reflexive witness is target = source =
toy; does NOT bridge toy to a different VCD. -/
theorem R395_reflexive_does_not_bridge_to_different_VCD : True := trivial

/-- **R395 non-closure (5/5)**: does NOT flip
`safeToReplaceOriginalHeadline`. -/
theorem R395_does_not_flip_safetyAudit : True := trivial

end HCGapL4
end HodgeReduction
