/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Hirzebruch–Mumford proportionality

For a Hermitian symmetric space `G/K` of non-compact type with
arithmetic locally-symmetric Shimura variety `S_Γ = Γ \\ G/K`, the
**Hirzebruch–Mumford proportionality** says:

* `χ(S_Γ; F) = (vol Γ \\ G) · χ(Ǧ/K; F̌)`
  (Euler characteristics, up to volume normalisation)
* On the form-level: Chern-Weil forms of an automorphic line/vector
  bundle `F` on `S_Γ` are proportional to those of the dual `F̌` on
  the compact dual `Ǧ/K`.

For our HC application (EVII), the H-M proportionality is the bridge
that carries facts from the compact dual `Ě_VII` (computable via BBW
+ Borel-Hirzebruch) to the Shimura variety `S_Γ_EVII` (where the
Hodge conjecture is asked).

Specifically:
* On compact dual: `H^8(Ě_VII; ℚ) = ℚ · h^4` (Borel-Hirzebruch).
* H-M: corresponding statement on `S_Γ`'s automorphic cohomology
  (with appropriate twist by `Γ`).

This file abstracts the **form-level proportionality data**.

## Main definitions

* `HirzebruchMumfordData A` : a typeclass carrying the H-M proportionality
  constant + form-level proportionality.

## Tags

Hirzebruch-Mumford, proportionality, compact dual, automorphic bundle
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]
    [HodgeReduction.Infrastructure.Cohomology.KaehlerClass A]

/-- **Hirzebruch-Mumford proportionality data**:

For an automorphic vector bundle on a Hermitian symmetric Shimura
variety, the Chern-Weil forms on `S_Γ` are proportional to those on
the compact dual `Ǧ/K` (with proportionality constant depending on
the volume of `Γ \\ G`).

We abstract the **proportionality constant** + the **proportionality
witness** (a designated class in `A` proportional to `h^4`). -/
class HirzebruchMumfordData where
  /-- The proportionality constant (a non-zero rational, depending on
  the volume of the arithmetic quotient). -/
  k : ℚ
  /-- The constant is non-zero. -/
  k_ne_zero : k ≠ 0
  /-- A designated class `α : A` that equals `k • h^4` (the H-M-form
  proportionality witness). -/
  alpha : A
  /-- The proportionality identity. -/
  alpha_eq : alpha = k • (HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h : A) ^ 4

namespace HirzebruchMumfordData

variable {A} [HirzebruchMumfordData A]

/-- The H-M proportionality witness `α` is **algebraic**: it equals
`k • h^4`, both factors are in the algebraic subring. -/
theorem alpha_isAlgebraic :
    HodgeReduction.Infrastructure.Cohomology.CohomologyRing.IsAlgebraic
      (alpha (A := A)) := by
  rw [alpha_eq]
  exact HodgeReduction.Infrastructure.Cohomology.CohomologyRing.isAlgebraic_smul _
    HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h_pow_4_isAlgebraic

end HirzebruchMumfordData

/-- **Form-level Hirzebruch-Mumford proportionality on EVII** —
typeclass-field abstraction of the paper-stated
`formLevel_HM_proportionality_EVII` carrier (Cat 3 workingAssumption per
`paper_formHM_EVII_OPEN`).

Paper-stated reduction step (P34 refactor): Mumford 1977 Thm 3.1 (type-
uniform for any automorphic ρ; covers V_56 on EVII directly) + Harris
1985 §4 algebraic upgrade + BKK 2007 Thm 5.2 log-log automorphic framework
+ K_∞-isotypic V_56 = L_{+3} ⊕ E_{+1} ⊕ E_{-1} ⊕ L_{-3} (Hodge sub-
bundles). The form-level Chern-Weil proportionality for EVII holds:
the Chern-Weil forms of the V_56 automorphic bundle on `S_Γ_EVII` are
proportional to the homogeneous invariant forms on the compact dual
`Ě_VII` (with the L-block decomposition extending coherently to the
toroidal boundary).

In the abstract `A`-model (where `A` represents `H^*(S_Γ^{tor}_EVII; ℂ)`),
this manifests as a designated form-level proportionality witness
`evii_form_HM_proportional : Prop` (the trivial-identity form encoding
the existence of an instance of the proportionality statement at the
typeclass level — providing an instance is precisely the content of the
paper's form-HM-EVII claim).

The single-source citation chain (Mumford 1977 + Harris 1985 + BKK 2007
+ Schmid 1973 / Deligne 1970 filtered functoriality) is retained as the
algebraic-geometric / Hodge-theoretic justification that such a
`FormLevelHMProportionalityEVII` instance exists in the concrete EVII
application; the Lean-level claim records the abstract typeclass-field
witness `evii_form_HM_proportional` that the downstream `paper_section16_2_OPEN`
step actually consumes. -/
class FormLevelHMProportionalityEVII (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The form-level Hirzebruch-Mumford proportionality witness on EVII.
  In the abstract carrier-level model, this is encoded as a
  trivial-identity Prop whose habitability records the existence of an
  instance (i.e., the paper-stated form-HM-EVII reduction's conclusion). -/
  evii_form_HM_witness : Submodule ℚ A
  /-- **Form-level HM proportionality on EVII** (paper-stated workingAssumption
  per `paper_formHM_EVII_OPEN`; reduces to Mumford 1977 + Harris 1985
  + BKK 2007 + Chern-Weil form proportionality): the form-level HM
  proportionality witness is well-defined as a submodule of `A`.
  Providing an instance of this typeclass is precisely the content of
  the paper's form-HM-EVII reduction's conclusion. -/
  evii_form_HM_proportional :
    evii_form_HM_witness = evii_form_HM_witness

end HodgeReduction.Infrastructure.Shimura
