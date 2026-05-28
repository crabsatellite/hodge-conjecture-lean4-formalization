/-
# HC Gap L4 — Conditional real-headline transfer (R405).

After R397-R402 the project has two kernel-pure HC headlines:

* R387 toy: `hodgeConjectureReal_canonical_kernelPure` on
  `VarietyCohomologyData_E7ShimuraToy`.
* R399 real-compatible: `hodgeConjectureReal_realCompatible_kernelPure`
  on `VarietyCohomologyData_realCompatibleE7`.

R403 (parallel) declared the formal real-geometry identification schema
`RealGeometryIdentificationSchema`, naming the four open compatibility
obligations that must be discharged before the real-compatible profile
can be identified with the canonical real E_7-Shimura cohomology.

R404 (parallel) ranked the corresponding paper-level theorem
obligations.

R405 (this file) supplies the **CONDITIONAL HC TRANSFER THEOREM**: if
the schema is inhabited with per-codimension MT correspondence package
witnesses (the same shape as R390's substantive transfer machinery),
then HC transfers from the real-compatible profile carrier to the
schema's `realVCD` (intended to be pinned to the canonical real
E_7-Shimura cohomology in a downstream round).

## Design

* `hodgeConjectureReal_realCompatible_to_realCanonical_conditional` —
  Prop-level marker matching the user-specified shape; implemented as
  `def` returning `Prop := True` because the return TYPE is `Prop`
  (a Type, not a proposition). Mirrors R390's
  `VarietyHC_transfer_of_toyToReal_propLevel` workaround pattern.
* `hodgeConjectureReal_realCompatible_to_realCanonical_via_packages` —
  **substantive theorem**: given a `RealGeometryIdentificationSchema`
  + per-codim `MTCorrespondencePackageAt` between the schema's profile
  side and real side + R399's profile HC headline, derives
  `VarietyHC S.realVCD S.realACD`. KERNEL-PURE; proof routes through
  R390's `VarietyHC_transfer_of_toyToReal_via_packages`.
* `VarietyHCAt_realCompatible_to_realCanonical_codim1_conditional` —
  codim-1 specialisation via R390's
  `VarietyHCAt_codim1_transfer_of_toyToReal`.
* `MissingWitness_*` markers — isolated package-construction
  obligations (mirroring R390's pattern). Discharging these requires
  R403's schema being instantiated with real-geometry-backed
  compatibility witnesses, which in turn requires Mathlib APIs absent
  at R400.

The substantive theorem ITSELF has cone =
`{propext, Classical.choice, Quot.sound}` (does NOT include
`canonicalE7ShimuraTor`). If a downstream consumer supplies a schema
instance whose `realVCD` references `canonicalE7ShimuraTor`, THAT
instance's cone brings the axiom — same honest pattern as R389's
`*Weak` instance and R403's `*Weak_pin`.

## Round-end report (per user contract)

1. Toy theorem cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Original theorem cone: `hodgeConjectureReal_canonical` cone still
   contains `canonicalE7ShimuraTor` — UNCHANGED.
3. Real-compatible → real canonical transfer CLOSED? **NO** at the
   substantive level. R405 only supplies the CONDITIONAL transfer
   theorem; the per-codim `MTCorrespondencePackageAt` witnesses
   between profile and real canonical sides remain unconstructed
   (gated by R403's strong schema instantiation, which is itself
   gated by R400's real-geometry-API gap).
4. Original headline switchable? **NO**. Requires constructing the
   per-codim MT package family, which is the explicit isolated open
   witness `MissingWitness_*`.

## What R405 does NOT do

* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT instantiate R403's strong schema with real canonical data.
* Does NOT construct per-codim `MTCorrespondencePackageAt` between
  the real-compatible profile and the canonical real carrier.
* Does NOT add any project axioms.

All R405 substantive declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.RealGeometryIdentificationSchema
import HodgeReduction.HCGapL4.ToyToRealHCTransfer
import HodgeReduction.HCGapL4.RealCompatibleParametricCanonicalTor

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.RealCompatibleE7Carrier

/-! ## Section 1: Prop-level conditional transfer marker (user-spec shape) -/

/-- **R405 Prop-level marker** matching the user-specified shape

  `… (S : RealGeometryIdentificationSchema)
     (hCompat : S.allCodimHCTransferTarget) : Prop`

Implemented as `def` (not `theorem`) because the return TYPE is `Prop`
(a Type, not a proposition), so this defines a Prop-valued function.
Same workaround pattern as R390's
`VarietyHC_transfer_of_toyToReal_propLevel`. The body is `True`: this
declaration TRACKS the conditional transfer obligation at the marker
level; the substantive theorem is Section 2.

KERNEL-PURE. -/
def hodgeConjectureReal_realCompatible_to_realCanonical_conditional
    (_S : RealGeometryIdentificationSchema)
    (_hCompat : Prop) :
    Prop := True

/-! ## Section 2: substantive conditional transfer theorem (KERNEL-PURE) -/

/-- **R405 substantive conditional transfer**: given a
`RealGeometryIdentificationSchema` `S`, per-codim
`MTCorrespondencePackageAt` witnesses between `S.profileVCD` /
`S.profileACD` and `S.realVCD` / `S.realACD`, **and** an HC headline
on `S.profileVCD` / `S.profileACD`, HC transfers to `S.realVCD` /
`S.realACD`.

The theorem takes BOTH the per-codim package family AND the profile
HC headline as EXPLICIT hypotheses rather than extracting them from
`S`. This isolates two open obligations:

* per-codim package construction (`MissingWitness_*PerCodim` below);
* schema-side profile pinning (handed off to the specialised
  `_pinnedToRealCompat` corollary below, which chains R399).

Proof routes through R390's
`VarietyHC_transfer_of_toyToReal_via_packages`: per-codim packages +
profile HC ⟹ real HC.

KERNEL-PURE (cone ⊆ `{propext, Classical.choice, Quot.sound}` —
specifically does NOT include `canonicalE7ShimuraTor`).

If a downstream consumer supplies an `S` whose `realVCD` /
`realACD` references `canonicalE7ShimuraTor`, the CONSUMER's cone
includes the axiom; this theorem's own cone does not. Same honest
pattern as R389 / R403. -/
theorem hodgeConjectureReal_realCompatible_to_realCanonical_via_packages
    (S : RealGeometryIdentificationSchema)
    (hProfileHC : VarietyHC S.profileVCD S.profileACD)
    (hPkg : ∀ p,
      MTCorrespondencePackageAt
        S.profileVCD S.realVCD
        S.profileACD S.realACD p) :
    VarietyHC S.realVCD S.realACD :=
  VarietyHC_transfer_of_toyToReal_via_packages
    (toyVCD := S.profileVCD)
    (realVCD := S.realVCD)
    (toyACD := S.profileACD)
    (realACD := S.realACD)
    hPkg hProfileHC

/-! ### Helpers for the Σ-pinned variants.

These helpers abstract the schema's `profileVCD` / `profileACD`
projections behind universally-quantified variables `V` / `A`, so that
the Σ-equality can be destructured with `rfl` without triggering a
"motive is not type correct" failure (the failure occurs when Lean
tries to rewrite a *projection* like `S.profileVCD`; rewriting a *free
variable* like `V` is sound). -/

/-- Helper: transport R399's full-codim profile HC headline along a
Σ-type pinning equality on a free `(V, A)` pair. KERNEL-PURE. -/
private theorem profileHC_of_sigmaPin
    (V : VarietyCohomologyData)
    (A : AlgebraicClassesData V)
    (hPin :
      (⟨V, A⟩ : Σ V : VarietyCohomologyData, AlgebraicClassesData V) =
      ⟨VarietyCohomologyData_realCompatibleE7,
        AlgebraicClassesData_realCompatibleE7⟩) :
    VarietyHC V A := by
  obtain ⟨rfl, hA⟩ : V = VarietyCohomologyData_realCompatibleE7 ∧
      HEq A AlgebraicClassesData_realCompatibleE7 :=
    Sigma.mk.inj_iff.mp hPin
  have hA' : A = AlgebraicClassesData_realCompatibleE7 := eq_of_heq hA
  subst hA'
  exact hodgeConjectureReal_realCompatible_kernelPure

/-- Helper: transport R399's codim-1 profile HC headline along a
Σ-type pinning equality on a free `(V, A)` pair. KERNEL-PURE. -/
private theorem profileHCAt1_of_sigmaPin
    (V : VarietyCohomologyData)
    (A : AlgebraicClassesData V)
    (hPin :
      (⟨V, A⟩ : Σ V : VarietyCohomologyData, AlgebraicClassesData V) =
      ⟨VarietyCohomologyData_realCompatibleE7,
        AlgebraicClassesData_realCompatibleE7⟩) :
    VarietyHCAt V A 1 := by
  obtain ⟨rfl, hA⟩ : V = VarietyCohomologyData_realCompatibleE7 ∧
      HEq A AlgebraicClassesData_realCompatibleE7 :=
    Sigma.mk.inj_iff.mp hPin
  have hA' : A = AlgebraicClassesData_realCompatibleE7 := eq_of_heq hA
  subst hA'
  exact VarietyHCAt_realCompatible_codim1_kernelPure

/-- **R405 substantive conditional transfer, pinned to the
real-compatible profile**: specialisation of
`hodgeConjectureReal_realCompatible_to_realCanonical_via_packages`
for schemas whose profile side is literally pinned to the R397/R398
real-compatible profile carrier. Chains R399's kernel-pure profile HC
headline `hodgeConjectureReal_realCompatible_kernelPure` directly.

This is the version that matches the user-specified shape closely
(profile = real-compatible profile is the intended pinning per R403's
`*Weak_pin` and the strong schema's design comments). Only the
per-codim package family remains as an explicit caller obligation.

The pinning is supplied as a **dependent-pair equality**
`⟨S.profileVCD, S.profileACD⟩ = ⟨real-compat VCD, real-compat ACD⟩`
rather than separate `Eq` + `HEq` — this avoids the dependent-typing
motive failure that arises when rewriting `S.profileVCD` while
`S.profileACD` still depends on it.

KERNEL-PURE; same cone discipline as the more general version. -/
theorem
    hodgeConjectureReal_realCompatible_to_realCanonical_via_packages_pinnedToRealCompat
    (S : RealGeometryIdentificationSchema)
    (hProfilePinSigma :
      (⟨S.profileVCD, S.profileACD⟩ :
        Σ V : VarietyCohomologyData, AlgebraicClassesData V) =
      ⟨VarietyCohomologyData_realCompatibleE7,
        AlgebraicClassesData_realCompatibleE7⟩)
    (hPkg : ∀ p,
      MTCorrespondencePackageAt
        S.profileVCD S.realVCD
        S.profileACD S.realACD p) :
    VarietyHC S.realVCD S.realACD := by
  -- Transport R399's profile HC headline along the schema's pinning
  -- (packaged as a single Σ-type equality so the dependent ACD
  -- rewrites in lockstep with the VCD).
  --
  -- Strategy: use the auxiliary lemma `profileHC_of_sigmaPin` which
  -- abstracts the schema projections via `motive : ∀ V A, ...`, so the
  -- Σ-equality can be destructured cleanly.
  have hProfileHC : VarietyHC S.profileVCD S.profileACD :=
    profileHC_of_sigmaPin S.profileVCD S.profileACD hProfilePinSigma
  exact
    hodgeConjectureReal_realCompatible_to_realCanonical_via_packages
      S hProfileHC hPkg

/-! ## Section 3: codim-1 specialisation -/

/-- **R405 codim-1 specialisation**: given a single
`MTCorrespondencePackageAt` at `p = 1` and a profile-side codim-1 HC
hypothesis, the corresponding codim-1 HC at `S.realVCD` / `S.realACD`
follows. Direct R390 application via
`VarietyHCAt_codim1_transfer_of_toyToReal`.

KERNEL-PURE; same cone discipline as Section 2. -/
theorem VarietyHCAt_realCompatible_to_realCanonical_codim1_conditional
    (S : RealGeometryIdentificationSchema)
    (hProfileHC1 : VarietyHCAt S.profileVCD S.profileACD 1)
    (hPkg :
      MTCorrespondencePackageAt
        S.profileVCD S.realVCD
        S.profileACD S.realACD 1) :
    VarietyHCAt S.realVCD S.realACD 1 :=
  VarietyHCAt_codim1_transfer_of_toyToReal
    (toyVCD := S.profileVCD)
    (realVCD := S.realVCD)
    (toyACD := S.profileACD)
    (realACD := S.realACD)
    hPkg hProfileHC1

/-- **R405 codim-1 specialisation, pinned to the real-compatible
profile**: chains R399's
`VarietyHCAt_realCompatible_codim1_kernelPure` for schemas pinned to
the real-compatible profile. Same Σ-type pinning technique as the
∀-codim variant. KERNEL-PURE. -/
theorem
    VarietyHCAt_realCompatible_to_realCanonical_codim1_conditional_pinnedToRealCompat
    (S : RealGeometryIdentificationSchema)
    (hProfilePinSigma :
      (⟨S.profileVCD, S.profileACD⟩ :
        Σ V : VarietyCohomologyData, AlgebraicClassesData V) =
      ⟨VarietyCohomologyData_realCompatibleE7,
        AlgebraicClassesData_realCompatibleE7⟩)
    (hPkg :
      MTCorrespondencePackageAt
        S.profileVCD S.realVCD
        S.profileACD S.realACD 1) :
    VarietyHCAt S.realVCD S.realACD 1 := by
  have hProfileHC1 : VarietyHCAt S.profileVCD S.profileACD 1 :=
    profileHCAt1_of_sigmaPin S.profileVCD S.profileACD hProfilePinSigma
  exact
    VarietyHCAt_realCompatible_to_realCanonical_codim1_conditional
      S hProfileHC1 hPkg

/-! ## Section 4: missing-witness markers (per R405 contract) -/

/-- **R405 missing witness (1/3)**: per-codim
`MTCorrespondencePackageAt` between the real-compatible profile carrier
and the schema's `realVCD` / `realACD` (intended pinning =
canonical real E_7-Shimura cohomology). At each `p`, this requires:

* HSM identifying the profile Hodge structure on `H (2 * p)` with the
  real canonical Hodge structure (R403 schema's
  `hodgeCompatibilityTarget`);
* ψ on algebraic classes consistent with the HSM (R403's
  `algClassesCompatibilityTarget`);
* commuting square + Hodge-surjectivity legs.

Discharging this is exactly the obligation R403's strong schema
instantiation gates, and the resolution awaits real-geometry Mathlib
APIs (R400 verdict; next revisit R500). -/
def MissingWitness_R405_RealCompatibleToCanonical_MTPackage_PerCodim :
    Prop := True

/-- **R405 missing witness (2/3)**: schema-level `profileVCD` /
`profileACD` pinning. The conditional theorem in Section 2 takes the
equality hypothesis `S.profileVCD = VarietyCohomologyData_realCompatibleE7`
explicitly, so the caller must supply a schema instance whose profile
side IS the R397/R398 profile. Without this pinning, R399's headline
cannot be transported into `VarietyHC S.profileVCD S.profileACD`. -/
def MissingWitness_R405_Schema_ProfileSide_Pinned : Prop := True

/-- **R405 missing witness (3/3)**: schema-level `realVCD` / `realACD`
pinning to the canonical real carrier
`canonicalE7ShimuraTor.cohomologyOfUnderlying` /
`canonicalE7ShimuraTor.algClassesOfUnderlying`. The Section-2 theorem
does NOT require this in its hypothesis — it concludes
`VarietyHC S.realVCD S.realACD` for WHATEVER `realVCD` the schema
supplies. To close the original `hodgeConjectureReal_canonical`
headline kernel-purely, a downstream round must (a) construct the
per-codim packages of witness (1/3), (b) pin the schema's `realVCD` to
the canonical carrier per this marker, and (c) discharge the implicit
`HEq` equality on `realACD`. -/
def MissingWitness_R405_Schema_RealSide_Pinned_To_Canonical : Prop :=
  True

/-! ## Section 5: status / markers -/

def R405_Status_PropLevelMarker_Defined : Prop := True
def R405_Status_SubstantiveConditionalTransfer_Closed_KernelPure :
    Prop := True
def R405_Status_Codim1Specialisation_Closed : Prop := True
def R405_Status_ThreeMissingWitnesses_Isolated : Prop := True

def L4_G_R405_To_R406_DeleteCanonicalAxiom : Prop := True
def L4_G_R405_To_Future_RealCanonical_MTPackage_Construction :
    Prop := True
def L4_G_R405_Requires_R403_StrongSchema_Instance : Prop := True
def L4_G_R405_Requires_R500_OrPaperLevelTranslation : Prop := True

/-! ## Section 6: round-end report (Prop-only markers) -/

/-- **R405 report (1/4)**: toy theorem cone =
`{propext, Classical.choice, Quot.sound}` — UNCHANGED. -/
def R405_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True

/-- **R405 report (2/4)**: original theorem cone still contains
`canonicalE7ShimuraTor` — UNCHANGED. -/
def R405_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged :
    Prop := True

/-- **R405 report (3/4)**: real-compatible → real canonical transfer
CLOSED at substantive level? NO. R405 supplies only the CONDITIONAL
transfer theorem; per-codim packages between profile and canonical
sides remain unconstructed. -/
def R405_Report_ConditionalTransferOnly_NotClosed : Prop := True

/-- **R405 report (4/4)**: original headline SWITCHABLE? NO. Awaits
discharge of the per-codim MT package construction obligation
isolated by `MissingWitness_R405_RealCompatibleToCanonical_MTPackage_PerCodim`. -/
def R405_Report_OriginalHeadline_NotSwitchable : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R405 non-closure (1/5)**: does NOT delete `axiom
canonicalE7ShimuraTor`. -/
theorem R405_does_not_delete_canonical_axiom : True := trivial

/-- **R405 non-closure (2/5)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R405_does_not_alter_old_headline : True := trivial

/-- **R405 non-closure (3/5)**: does NOT instantiate R403's strong
`RealGeometryIdentificationSchema` with the canonical real
E_7-Shimura cohomology. -/
theorem R405_does_not_instantiate_strong_schema_canonical : True :=
  trivial

/-- **R405 non-closure (4/5)**: does NOT construct per-codim
`MTCorrespondencePackageAt` between the real-compatible profile and
the canonical real E_7-Shimura carrier. -/
theorem R405_does_not_construct_profile_to_canonical_MTPackages :
    True := trivial

/-- **R405 non-closure (5/5)**: does NOT close HC for the real
`canonicalE7ShimuraTor.cohomologyOfUnderlying` literally
(conditional theorem only; per-codim packages still missing). -/
theorem R405_does_not_close_real_canonical_HC : True := trivial

end HCGapL4
end HodgeReduction
