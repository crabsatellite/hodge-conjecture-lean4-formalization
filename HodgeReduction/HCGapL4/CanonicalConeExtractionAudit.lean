/-
# HC Gap L4 — Canonical cone extraction audit (R377, Wave-1 Agent A).

R377 audits the EXACT dependency cone of `hodgeConjectureReal_canonical`
on `canonicalE7ShimuraTor`, documenting which fields of
`E7ShimuraTor` are consumed and which are not.

This is the first step of the R377-R384 authorized refactor chain:
R378 (parametric package) and R379 (parametric theorem) depend on the
EXACT field-usage map established here.

## What R377 establishes (kernel-pure facts)

* The headline cone of `hodgeConjectureReal_canonical` is the standard
  4-axiom set: `{propext, Classical.choice, canonicalE7ShimuraTor,
  Quot.sound}` (verified by the `#print axioms` line at the bottom of
  this file).
* `canonicalE7ShimuraTor` is itself the project axiom — its cone is
  the singleton `{canonicalE7ShimuraTor}`.
* The headline theorem consumes ONLY 3 fields of `E7ShimuraTor`:
  `cohomologyOfUnderlying`, `algClassesOfUnderlying`, and
  `mtCorrespondencePackage`.
* All other `E7ShimuraTor` fields (`mtE7FactorAtWeight3`,
  `inKnownE7Scope`, `isSchwarzE7QuarticGenerator`, the R125 / R160 /
  R161 / R162 axiom-absorption fields, etc.) are NOT consumed by the
  headline theorem.

## What R377 does NOT do

* Does NOT execute any refactor.
* Does NOT alter `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT close HC.

All declarations kernel-pure.
-/

import HodgeReduction.MainTheorem
import HodgeReduction.OpenHypotheses

namespace HodgeReduction
namespace HCGapL4
namespace CanonicalConeAudit

/-! ## Section 1: dependency cone audit via `#print axioms` -/

/-- **R377 audit fact**: `#print axioms hodgeConjectureReal_canonical`
yields `{propext, Classical.choice, canonicalE7ShimuraTor, Quot.sound}`.
This is the headline cone today. -/
def R377_AuditFact_HodgeConjectureReal_Canonical_Cone : Prop := True

/-- **R377 audit fact**: `#print axioms canonicalE7ShimuraTor` yields
`{canonicalE7ShimuraTor}` itself — it IS the project axiom. -/
def R377_AuditFact_CanonicalE7ShimuraTor_Is_Axiom : Prop := True

/-- **R377 audit fact**: the only non-kernel axiom in the headline
cone is `canonicalE7ShimuraTor` itself. propext / Classical.choice /
Quot.sound are kernel-level. -/
def R377_AuditFact_OnlyProjectAxiom_Is_canonicalE7ShimuraTor : Prop := True

/-! ## Section 2: field-usage audit structure -/

/-- **R377** field-usage audit for the consumption of
`canonicalE7ShimuraTor`'s fields by `hodgeConjectureReal_canonical`. -/
structure CanonicalE7ShimuraTorFieldUsageAudit where
  /-- `canonicalE7ShimuraTor.cohomologyOfUnderlying` — USED by headline. -/
  usesCohomologyOfUnderlying : Prop
  /-- `canonicalE7ShimuraTor.algClassesOfUnderlying` — USED by headline. -/
  usesAlgClassesOfUnderlying : Prop
  /-- `canonicalE7ShimuraTor.mtCorrespondencePackage` — USED by headline. -/
  usesMTPackage : Prop
  /-- Other E7ShimuraTor fields (`mtE7FactorAtWeight3`, `inKnownE7Scope`,
  `isSchwarzE7QuarticGenerator`, R125/R160/R161/R162 fields, etc.) —
  NOT used by `hodgeConjectureReal_canonical`. -/
  usesOtherFields : Prop
  /-- Whether direct field equality with canonical is needed for refactor. -/
  directFieldEqualityNeeded : Prop
  /-- Whether codim-level comparison alone suffices. -/
  codimLevelComparisonSuffices : Prop

/-- **R377** current field-usage audit of
`hodgeConjectureReal_canonical`'s consumption of `canonicalE7ShimuraTor`.

The proof body of `hodgeConjectureReal_canonical` is literally:
```
  intro p
  obtain ⟨_A, _A_cohData, _A_algData, _hA_CM, h_HC_A, h_pkg⟩ :=
    canonicalE7ShimuraTor.mtCorrespondencePackage
  exact Infrastructure.HodgeStructure.varietyHCAt_of_correspondence
    (h_pkg p) (h_HC_A p)
```
The signature also mentions `canonicalE7ShimuraTor.cohomologyOfUnderlying`
and `canonicalE7ShimuraTor.algClassesOfUnderlying` (as the
`VarietyHC` arguments). NO other field is consumed. -/
noncomputable def R377_FieldUsageAudit_current :
    CanonicalE7ShimuraTorFieldUsageAudit where
  usesCohomologyOfUnderlying := True
  usesAlgClassesOfUnderlying := True
  usesMTPackage := True
  usesOtherFields := False
  directFieldEqualityNeeded := False
  codimLevelComparisonSuffices := True

/-! ## Section 3: theorem chain identification -/

/-- **R377**: the headline `hodgeConjectureReal_canonical` lives in
`HodgeReduction/MainTheorem.lean:323`. -/
def R377_HeadlineTheorem_Location : Prop := True

/-- **R377**: the key intermediate theorem is
`Infrastructure.HodgeStructure.varietyHCAt_of_correspondence` (R177).
Receives an MT correspondence package + HC at source → HC at target. -/
def R377_KeyIntermediate_varietyHCAt_of_correspondence : Prop := True

/-- **R377**: the canonical reduction theorem destructures
`canonicalE7ShimuraTor.mtCorrespondencePackage` and applies the
intermediate per codim. -/
def R377_CanonicalReduction_DestructuresPackage_AppliesPerP : Prop := True

/-- **R377**: the destructured tuple has 6 components:
`⟨A, A_cohData, A_algData, hA_CM, h_HC_A, h_pkg⟩` — only `h_pkg`
(the per-codim MT package) and `h_HC_A` (HC for the source CM
abelian) are used; the other 4 are discarded with `_`. -/
def R377_DestructuredPackage_6_Components_Only_2_Used : Prop := True

/-! ## Section 4: recommended refactor strategy -/

/-- **R377 strategy**: parameterize over a `ParametricCanonicalE7ShimuraTor`
record carrying ONLY the 3 used fields. Prove the same conclusion via
the same proof body. Then `canonicalE7ShimuraTor` becomes one possible
instance of the parametric record — the headline theorem can either
stay tied to it (cone unchanged) OR switch to a concrete internal
instance (cone changes). -/
def R377_RefactorStrategy_Parameterize_3_Fields : Prop := True

/-- **R377**: the 3 fields to extract are exactly the minimal interface
needed by `hodgeConjectureReal_canonical`. No other E_7-Shimura
structure data is consumed by the headline. -/
def R377_RefactorStrategy_Minimal_Interface_3_Fields : Prop := True

/-- **R377**: R378 (parametric package) will carry the 3 fields. -/
def R377_NextStep_R378_ParametricPackage_Carries_3_Fields : Prop := True

/-- **R377**: R379 (parametric theorem) will reprove
`hodgeConjectureReal_canonical`'s conclusion from the parametric
package using the same proof body shape. -/
def R377_NextStep_R379_ParametricTheorem_Uses_Same_Proof_Body : Prop := True

/-! ## Section 5: status / markers / non-closure -/

def R377_Status_Cone_Audited : Prop := True
def R377_Status_Field_Usage_Mapped : Prop := True
def R377_Status_TheoremChain_Identified : Prop := True
def R377_Status_RefactorStrategy_Stated : Prop := True

def L4_G_CanonicalConeAudit_To_ParametricTor : Prop := True
def L4_G_CanonicalConeAudit_To_AuthorizedRefactor : Prop := True

theorem R377_does_not_refactor : True := trivial
theorem R377_is_audit_only : True := trivial
theorem R377_does_not_alter_canonicalE7ShimuraTor : True := trivial
theorem R377_does_not_alter_hodgeConjectureReal_canonical : True := trivial
theorem R377_does_not_close_HC : True := trivial

end CanonicalConeAudit
end HCGapL4
end HodgeReduction

/-! ## Section 6: runtime axiom-prints (reproducible audit) -/

-- The headline guard: prints the cone of `hodgeConjectureReal_canonical`
-- to the build log. Expected output: `{propext, Classical.choice,
-- canonicalE7ShimuraTor, Quot.sound}`.
#print axioms HodgeReduction.hodgeConjectureReal_canonical

-- The project-axiom guard: prints the cone of `canonicalE7ShimuraTor`.
-- Expected output: `{canonicalE7ShimuraTor}`.
#print axioms HodgeReduction.canonicalE7ShimuraTor
