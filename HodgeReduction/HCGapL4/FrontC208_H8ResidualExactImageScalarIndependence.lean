/-
# HC Gap L4 -- Front C208: exact image remains independent after R772 (R773).

R772 proves that the two non-exact R771 fields

* `CartanH8 <= compactDual`;
* the target-line scalar certificate

close the carrier side: `compactDual = CartanH8` and `compactDual = H8`.
This file records the matching guardrail.  Even with those two fields and the
resulting carrier closure, exact image

  `Submodule.map j_q source_invariants = surjectivity_target`

is still not forced by the current abstract Matsushima interface.  Therefore
the next attack cannot replace exact image by the R772 carrier/scalar side; it
must prove exact image from genuine Matsushima source geometry, or add a
separate theorem that implies it.
-/

import HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence
import HodgeReduction.HCGapL4.FrontC207_H8ResidualCartanScalarCarrierClosure

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC208_H8ResidualExactImageScalarIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC98_H8ResidualExactImageIndependence
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC207_H8ResidualCartanScalarCarrierClosure

/-- **R773 obstruction theorem (1/5)**: the R662 exact-image countermodel
also has the current R772 scalar certificate.  In this one-dimensional model,
every target-invariant class is a rational multiple of `j_q(h^4) = 1`. -/
def counterexample_targetInvariantLineScalarCertificate :
    TargetInvariantLineScalarCertificate
      ExactImageObstructionSource ExactImageObstructionTarget where
  scalar_preimage := by
    intro beta _hbeta
    refine Exists.intro (show Rat from beta) ?_
    change
      SMul.smul (show Rat from beta)
        (MatsushimaData.j_q
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget)
          ((KaehlerClass.h : ExactImageObstructionSource) ^ 4)) =
        beta
    change SMul.smul (show Rat from beta) (1 : Rat) = beta
    change (show Rat from beta) * (1 : Rat) = beta
    ring

/-- **R773 obstruction theorem (2/5)**: Cartan containment plus the scalar
certificate do not force exact image in the current abstract interface. -/
theorem current_interface_with_cartanContainment_scalarCertificate_does_not_force_exactImage :
    (LE.le (CartanCompactDualIso.trivialModuleGK_H8
        (A := ExactImageObstructionSource))
      (MatsushimaCompactDualData.compactDual
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget))) /\
    TargetInvariantLineScalarCertificate
      ExactImageObstructionSource ExactImageObstructionTarget /\
    Not (sourceInvariantExactImageTarget
      ExactImageObstructionSource ExactImageObstructionTarget) :=
  And.intro
    counterexample_cartanH8_le_compactDual
    (And.intro
      counterexample_targetInvariantLineScalarCertificate
      counterexample_not_sourceInvariantExactImageTarget)

/-- **R773 obstruction theorem (3/5)**: in the same model, the R772
carrier closure really is available. -/
theorem counterexample_compactDual_eq_H8_from_R772_fields :
    MatsushimaCompactDualData.compactDual
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) =
      CompactDualData.H8 (A := ExactImageObstructionSource) :=
  compactDual_eq_H8_of_cartanH8_le_compactDual_scalarCertificate
    (A := ExactImageObstructionSource)
    (B := ExactImageObstructionTarget)
    counterexample_cartanH8_le_compactDual
    counterexample_targetInvariantLineScalarCertificate

/-- **R773 obstruction theorem (4/5)**: even after recording the R772
carrier closure explicitly, exact image remains independent. -/
theorem current_R772_carrier_closed_interface_does_not_force_exactImage :
    (LE.le (CartanCompactDualIso.trivialModuleGK_H8
        (A := ExactImageObstructionSource))
      (MatsushimaCompactDualData.compactDual
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget))) /\
    TargetInvariantLineScalarCertificate
      ExactImageObstructionSource ExactImageObstructionTarget /\
    MatsushimaCompactDualData.compactDual
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) =
      CompactDualData.H8 (A := ExactImageObstructionSource) /\
    Not (sourceInvariantExactImageTarget
      ExactImageObstructionSource ExactImageObstructionTarget) :=
  And.intro
    counterexample_cartanH8_le_compactDual
    (And.intro
      counterexample_targetInvariantLineScalarCertificate
      (And.intro
        counterexample_compactDual_eq_H8_from_R772_fields
        counterexample_not_sourceInvariantExactImageTarget))

/-- Machine-readable status for the R773 exact-image guardrail. -/
structure R773ExactImageScalarIndependenceSnapshot where
  cartanContainmentAvailable : Bool
  scalarCertificateAvailable : Bool
  carrierClosureAvailable : Bool
  exactImageForcedByCartanScalar : Bool
  exactImageStillIndependentAfterR772 : Bool
  provesExactImage : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R773 status: R772 closes the carrier side, but exact image is
still a separate live Matsushima source-geometry target. -/
def currentR773ExactImageScalarIndependenceSnapshot :
    R773ExactImageScalarIndependenceSnapshot where
  cartanContainmentAvailable := true
  scalarCertificateAvailable := true
  carrierClosureAvailable := true
  exactImageForcedByCartanScalar := false
  exactImageStillIndependentAfterR772 := true
  provesExactImage := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R773 obstruction theorem (5/5)**: kernel-checked status for the
R773 exact-image guardrail. -/
theorem currentR773ExactImageScalarIndependenceSnapshot_eq_texStatus :
    currentR773ExactImageScalarIndependenceSnapshot =
      ({ cartanContainmentAvailable := true
         scalarCertificateAvailable := true
         carrierClosureAvailable := true
         exactImageForcedByCartanScalar := false
         exactImageStillIndependentAfterR772 := true
         provesExactImage := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R773ExactImageScalarIndependenceSnapshot) := by
  decide

def R773_substantiveTheoremCount : Nat := 5

end FrontC208_H8ResidualExactImageScalarIndependence
end HCGapL4
end HodgeReduction
