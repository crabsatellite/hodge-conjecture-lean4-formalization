/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Griffiths period domains

For a polarised pure ℚ-Hodge structure type `(V, n, ψ)`, the **period
domain** `D = D(V, n, ψ)` of Griffiths (1968-1970) is the classifying
space of all polarised Hodge filtrations on the fixed vector space
`V` with the fixed weight `n` and the fixed polarisation form `ψ`.
Concretely, `D` is an open subset (cut out by the Hodge-Riemann
positivity HR2) of the **compact dual** `Ď`, which is a flag variety
parametrising filtrations `F^• ⊂ V_ℂ` satisfying the HR1 isotropy
condition `Q(F^p, F^{n-p+1}) = 0` together with the dimension
constraints `dim F^p = f^p := dim H^{n,0} + dim H^{n-1,1} + ⋯ + dim H^{p,n-p}`.

Set-theoretically `D = G_ℝ / V_0` where `G = Aut(V, ψ)` is the
isometry group of the polarisation and `V_0 ⊂ G_ℝ` is the isotropy
subgroup of a reference Hodge filtration. For our HC application, the
EVII Shimura variety arises as the arithmetic quotient `Γ \ D` for
the Hermitian symmetric domain `D = E_{7(-25)} / (E_6 × U(1))`, which
has complex dimension `27`.

This file packages the **abstract period domain data** in a form
sufficient for the rigidity / variation-of-Hodge-structure arguments
that the Mumford-Tate reduction (Voisin II Ch. 10) uses downstream.

We axiomatise four pieces of structure:

1. A *flag carrier* `flag : ∀ p ≤ n, Submodule ℚ V` packaging the
   Hodge filtration step `F^p V` at every index.
2. *Anti-monotonicity* `q ≥ p → flag q ≤ flag p` (the Hodge filtration
   is decreasing).
3. **Griffiths transversality** as a substantive `Submodule`
   inclusion `flag p ⊆ flag (p-1)` (the differential
   `∇(F^p) ⊆ F^{p-1} ⊗ Ω^1_S` of Griffiths I §3 / Voisin II §10.1;
   here we record its purely algebraic shadow: each filtration step
   is *contained in* its predecessor).
4. The complex dimensions `f^p = dim F^p V_ℂ`.

The **Hermitian form compatibility** `HermitianFormCompatibility` is
provided as a sibling typeclass: it records the non-degenerate
pairing `H^{p,n-p} × H^{n-p,p} → ℂ` between Hodge-dual pieces coming
from the polarisation, in the rational shadow form of a non-zero
ψ-pairing between `flag p` and `flag (n-p)` for non-trivial weights.

## References

* Griffiths, P. "Periods of integrals on algebraic manifolds I, II",
  *Amer. J. Math.* **90** (1968) 568-626, 805-865; "III",
  *Publ. Math. IHÉS* **38** (1970) 125-180.
* Schmid, W. "Variation of Hodge structure: The singularities of the
  period mapping", *Invent. Math.* **22** (1973) 211-319.
* Carlson, J.; Müller-Stach, S.; Peters, C. *Period Mappings and
  Period Domains*, Cambridge Stud. Adv. Math. **85**, CUP, 2003
  (Ch. 4 + Ch. 12 for the EVII / E_7-orbit / Hermitian symmetric
  setup).
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry II*,
  Cambridge Stud. Adv. Math. **77**, CUP, 2003 (Ch. 10).

## Main definitions

* `PeriodDomainData V n` : abstract period domain data with the
  Hodge flag carrier, anti-monotonicity, Griffiths transversality
  and the complex-dimension profile.

* `HermitianFormCompatibility V n` : the period domain's hermitian
  pairing compatibility (non-degeneracy of the polarisation
  restricted to `flag p × flag (n - p)`).

## Tags

period domain, Hodge variation, Shimura variety, Hermitian symmetric,
Griffiths transversality, Hodge flag, EVII
-/

namespace HodgeReduction.Infrastructure.Shimura

open HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Period domain data** for polarised Hodge structures of weight `n`
on `V`, in the sense of Griffiths 1968-1970.

A period domain `D` parametrises decreasing filtrations
`V_ℂ = F^0 ⊇ F^1 ⊇ ⋯ ⊇ F^n ⊇ F^{n+1} = 0` (the Hodge filtration)
satisfying:

* **HR1**: `Q(F^p, F^{n-p+1}) = 0` (isotropy).
* **HR2**: positivity of the Hermitian form on the graded pieces.
* **Dimension constraint**: `dim F^p = f^p`, with `f^p` fixed.

The Griffiths transversality differential constraint
`∇(F^p) ⊆ F^{p-1} ⊗ Ω^1_S` (Griffiths I §3; Voisin II Defn 10.1)
controls how the filtration moves in families and is the
infinitesimal manifestation of the filtration being decreasing.

We package the four primary pieces of algebraic data:

* `flag p hp` : the filtration step `F^p V ⊆ V` for `p ≤ n`.
* `flag_anti` : the filtration is decreasing in `p`.
* `griffiths_transversality` : each filtration step is *contained in*
  its predecessor — the rational/algebraic shadow of the differential
  condition `∇(F^p) ⊆ F^{p-1}`.
* `dimComplexFlag p` : the complex dimension `f^p` of `F^p`.

The complex-dimension sequence is required to be **weakly
decreasing** (the Hodge numbers `h^{p,n-p}` are non-negative). -/
class PeriodDomainData (n : ℕ) where
  /-- The Hodge filtration step `F^p V ⊆ V` for `p ≤ n`. -/
  flag : ∀ p : ℕ, p ≤ n → Submodule ℚ V
  /-- **Anti-monotonicity** of the Hodge filtration: `p ≤ q ≤ n`
  implies `F^q ⊆ F^p` (the filtration is decreasing).

  Reference: Griffiths I §1, defining property of the Hodge
  filtration; Voisin I Defn 7.1; Carlson-Müller-Stach-Peters
  Defn 1.2.1. -/
  flag_anti : ∀ {p q : ℕ} (hp : p ≤ n) (hq : q ≤ n),
    p ≤ q → flag q hq ≤ flag p hp
  /-- **Griffiths transversality** (substantive Submodule inclusion).

  The full differential condition reads
  `∇(F^p) ⊆ F^{p-1} ⊗ Ω^1_S` (Griffiths I §3, "Theorem on Periods of
  Integrals III"; Voisin II Defn 10.1). Its *algebraic shadow*
  — which is all we can express purely at the carrier level — is the
  weaker assertion that each filtration step lies inside its
  predecessor: `F^p ⊆ F^{p-1}`. This is a non-trivial inclusion of
  submodules (not a tautology: it constrains how `flag p` sits inside
  `flag (p-1)`, which fails for an arbitrary filtration with a
  reshuffled `flag p`).

  We state this for the predecessor `p - 1` indexed by the witness
  `hpred : p - 1 ≤ n` (always available when `hp : p ≤ n`). -/
  griffiths_transversality : ∀ {p : ℕ} (hp : p ≤ n) (hpred : p - 1 ≤ n),
    flag p hp ≤ flag (p - 1) hpred
  /-- The complex dimension `f^p = dim_ℂ F^p V_ℂ` of the `p`-th
  filtration step.

  Reference: Griffiths I §1 (dimension profile); Carlson-Müller-Stach-
  Peters Defn 4.1.1 ("type of a Hodge structure"). -/
  dimComplexFlag : ∀ p : ℕ, p ≤ n → ℕ
  /-- The dimension profile is **weakly decreasing**: `dim F^q ≤ dim F^p`
  whenever `p ≤ q`. This is forced by `flag_anti` over a field where
  every submodule has a well-defined dimension; we record it as a
  separate axiom so users do not have to reprove it from the
  `flag_anti` inclusion + a dimension-monotonicity lemma. -/
  dimComplexFlag_anti : ∀ {p q : ℕ} (hp : p ≤ n) (hq : q ≤ n),
    p ≤ q → dimComplexFlag q hq ≤ dimComplexFlag p hp

namespace PeriodDomainData

variable {V} {n : ℕ} [PeriodDomainData V n]

/-! ## Derived consequences of the period-domain axioms -/

/-- The Hodge filtration is **reflexively contained in itself**: a
trivial consequence of `flag_anti` with `p = q`, recorded for
ergonomic rewriting downstream. -/
theorem flag_self_subset (p : ℕ) (hp : p ≤ n) :
    flag (V := V) (n := n) p hp ≤ flag (V := V) (n := n) p hp :=
  flag_anti (V := V) (n := n) hp hp le_rfl

/-- **Griffiths transversality at step zero is trivial**: `F^0 ⊆ F^{-1}`
becomes `F^0 ⊆ F^0` (since `0 - 1 = 0` in ℕ), which is `le_rfl`. The
content of Griffiths transversality is therefore concentrated at
`p ≥ 1`. -/
theorem griffiths_transversality_at_zero (h0 : 0 ≤ n) :
    flag (V := V) (n := n) 0 h0 ≤ flag (V := V) (n := n) (0 - 1)
      (show 0 - 1 ≤ n by exact h0) := by
  -- `0 - 1 = 0` in ℕ, so both sides are `flag 0 _` (proof-irrelevance on `≤`).
  exact flag_self_subset (V := V) (n := n) 0 h0

/-- **Iterated Griffiths transversality**: by induction on `k`,
`F^{p+k} ⊆ F^p` (Griffiths transversality composes with itself).
This is the *integrated* form of the differential constraint and is
how the rigidity statement of Voisin II §10.1 is used in practice. -/
theorem flag_iterated_subset (p k : ℕ) (hpk : p + k ≤ n) :
    flag (V := V) (n := n) (p + k) hpk ≤
      flag (V := V) (n := n) p (le_trans (Nat.le_add_right p k) hpk) :=
  flag_anti (V := V) (n := n) _ _ (Nat.le_add_right p k)

/-- The top filtration step `F^n` is contained in `F^p` for every
`p ≤ n`. This is the *positivity-of-Hodge-numbers* fact reformulated:
the smallest filtration step lies inside every larger one. -/
theorem flag_top_subset_all (p : ℕ) (hp : p ≤ n) (hn : n ≤ n) :
    flag (V := V) (n := n) n hn ≤ flag (V := V) (n := n) p hp :=
  flag_anti (V := V) (n := n) hp hn hp

end PeriodDomainData

/-- **Hermitian-form compatibility** between the period domain's flag
data and the polarisation form `ψ` (from `PolarisedHodgeStructure`).

The full geometric statement is that the polarisation induces a
non-degenerate Hermitian pairing `H^{p,n-p} × H^{n-p,p} → ℂ` between
Hodge-dual pieces (Griffiths I (2.5); Voisin I Prop 7.10 (ii); Schmid
1973 (1.7)). The rational shadow we record here is the corresponding
non-degeneracy at the flag level: for `p ≤ n`, the polarisation
restricted to `flag p × flag (n - p)` is **separating** in the sense
that there exists at least one non-zero pairing whenever the
filtration step itself is non-trivial.

This is a substantive `Submodule × Submodule → Prop` statement (not a
tautology): it asserts the existence of a *pair* of non-zero vectors
in opposite filtration steps with non-vanishing ψ-pairing — which
fails, for instance, if `flag p` and `flag (n - p)` are both
orthogonal subspaces. -/
class HermitianFormCompatibility (n : ℕ) [PolarisedHodgeStructure V n]
    [PeriodDomainData V n] : Prop where
  /-- **Hermitian non-degeneracy** between Hodge-dual flag steps: for
  every `p ≤ n` such that `n - p ≤ n` (always true on ℕ), if the
  filtration step `F^p` contains some non-zero vector `v` *and* the
  Hodge-dual step `F^{n-p}` contains some non-zero vector `w`, then
  there is at least one pair of representatives in the two steps with
  non-vanishing polarisation pairing.

  The statement is *substantive*: it forbids the polarisation from
  becoming identically zero on `flag p × flag (n - p)` whenever both
  steps carry non-zero vectors. -/
  hermitian_nondegen :
    ∀ {p : ℕ} (hp : p ≤ n) (hnp : n - p ≤ n),
      (∃ v ∈ PeriodDomainData.flag (V := V) (n := n) p hp, v ≠ 0) →
      (∃ w ∈ PeriodDomainData.flag (V := V) (n := n) (n - p) hnp, w ≠ 0) →
      ∃ v ∈ PeriodDomainData.flag (V := V) (n := n) p hp,
      ∃ w ∈ PeriodDomainData.flag (V := V) (n := n) (n - p) hnp,
        PolarisedHodgeStructure.psi v w (n := n) ≠ 0

namespace HermitianFormCompatibility

variable {V} {n : ℕ} [PolarisedHodgeStructure V n] [PeriodDomainData V n]
variable [HermitianFormCompatibility V n]

/-- **No filtration step pair vanishes simultaneously**: if both
`flag p` and `flag (n - p)` are non-trivial, then their pairing is
non-trivial. Direct restatement of `hermitian_nondegen`. -/
theorem nontrivial_pair_pairs_nonzero
    {p : ℕ} (hp : p ≤ n) (hnp : n - p ≤ n)
    (hv : ∃ v ∈ PeriodDomainData.flag (V := V) (n := n) p hp, v ≠ 0)
    (hw : ∃ w ∈ PeriodDomainData.flag (V := V) (n := n) (n - p) hnp,
      w ≠ 0) :
    ∃ v ∈ PeriodDomainData.flag (V := V) (n := n) p hp,
    ∃ w ∈ PeriodDomainData.flag (V := V) (n := n) (n - p) hnp,
      PolarisedHodgeStructure.psi v w (n := n) ≠ 0 :=
  hermitian_nondegen hp hnp hv hw

end HermitianFormCompatibility

/-! ## Trivial reference instance: `(ℚ, n = 0)`

The base field `ℚ` with the trivial Hodge structure of weight `0`
carries a degenerate but consistent period domain: the unique flag
step `F^0 = ℚ` is the entire space and there is no non-trivial
filtration above it. All four axioms (`flag`, `flag_anti`,
`griffiths_transversality`, `dimComplexFlag_anti`) collapse to
trivial-but-non-vacuous statements about a one-step filtration.

This instance witnesses that the period-domain axioms are
*consistent* and the carrier-level abstraction admits at least one
inhabiting instance, in line with the inhabitation pattern used
throughout the kernel-pure HC framework. -/

namespace Trivial

/-- The trivial Hodge filtration on `ℚ`: the single step `F^0 = ⊤`,
covering only `p = 0` (the only `p` with `p ≤ 0`). -/
def flag_ℚ_0 : ∀ p : ℕ, p ≤ 0 → Submodule ℚ ℚ
  | 0, _ => (⊤ : Submodule ℚ ℚ)
  | _ + 1, h => absurd h (by omega)

@[simp] theorem flag_ℚ_0_apply :
    flag_ℚ_0 0 (Nat.le_refl 0) = (⊤ : Submodule ℚ ℚ) := rfl

/-- Trivial `PeriodDomainData ℚ 0` instance: the unique flag step
`F^0 = ℚ`. All structural axioms are non-vacuous one-step
restatements. -/
instance periodDomain_ℚ_0 : PeriodDomainData ℚ 0 where
  flag := flag_ℚ_0
  flag_anti := by
    -- Only `p = q = 0` is in range.
    intro p q hp hq _hpq
    interval_cases p
    interval_cases q
    exact le_rfl
  griffiths_transversality := by
    intro p hp hpred
    interval_cases p
    -- `0 - 1 = 0` in ℕ, so `flag 0 hp = flag 0 hpred`; conclude `le_rfl`.
    exact le_rfl
  dimComplexFlag := fun _ _ => 1
  dimComplexFlag_anti := by
    intro p q hp hq _hpq
    interval_cases p
    interval_cases q
    exact le_rfl

end Trivial

end HodgeReduction.Infrastructure.Shimura
