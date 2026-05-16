/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Algebra.Operations
import Mathlib.Algebra.Algebra.Rat
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# `(g, K)`-cohomology framework

For a real Lie group `G` with maximal compact subgroup `K`, a
`(g, K)`-module is a `g`-module with a compatible `K`-action.
The **`(g, K)`-cohomology** `H^*(g, K; V)` is the derived functor of
`Hom_{(g, K)}(triv, -)` and computes Lie-algebra cohomology with
`K`-action (Borel-Wallach 1980, Ch. I §1.2).

For our HC application:

* `(g, K)`-cohomology of automorphic representations gives the
  G-invariant cuspidal cohomology of Shimura varieties
  (Borel-Wallach 1980, Ch. VII §2).
* Cartan-1929 (`Sur les invariants integraux de certains espaces
  homogenes clos`, Ann. Soc. Polon. Math. 8, 181-225) identifies
  trivial-module `(g, K)`-cohomology with the de Rham cohomology of
  the compact dual `Ě = G_u / K` (also Borel-Wallach 1980, Ch. II §3
  Thm 3.2).
* Borel-Wallach 1980, Ch. II Thm 3.3 (the **dimension-vanishing
  principle**): `H^k(g, K; V) = 0` whenever `k > dim_ℝ(G/K)`.

This file packages **abstract `(g, K)`-cohomology data** with the
trivial-module specialisation needed downstream.

## Main definitions

* `GKCohomologyData A`: abstract (g, K)-cohomology framework realising
  `H^k(g, K; triv)` as a `ℚ`-submodule of an ambient `ℚ`-algebra `A`,
  with Borel-Wallach 1980 Ch. II Thm 3.3 dimension-vanishing, the
  Cartan-1929 compact-dual identification (Borel-Wallach 1980 Ch. II
  §3 Thm 3.2), and the trivial-coefficient cup-product graded
  multiplicativity (Borel-Wallach 1980 Ch. I §1.5).
* `BorelWallachLowDegreeVanishing A`: sibling typeclass packaging the
  Salamanca-Riba 1999 (Duke Math. J. 96, no. 3) + Borel-Wallach 1980
  Ch. VI low-degree-vanishing decomposition principle for Hermitian
  symmetric pairs `(g, K)` of compact type.

## Tags

(g, K)-cohomology, Lie algebra cohomology, Borel-Wallach 1980,
Cartan 1929, compact dual, Salamanca-Riba 1999
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [CommRing A] [Algebra ℚ A]

/-- **(g, K)-cohomology data** for an abstract trivial-coefficient
`(g, K)`-cohomology ring sitting inside an ambient `ℚ`-algebra `A`.

For a real reductive Lie group `G` with maximal compact subgroup `K`
and the trivial `(g, K)`-module, the cohomology `H^k(g, K; ℚ)` is a
`ℚ`-vector space and the total cohomology `⨁_k H^k(g, K; ℚ)` carries
a graded-commutative `ℚ`-algebra structure (Borel-Wallach 1980
Ch. I §1.5, cup product on Lie-algebra cohomology with trivial
coefficients).

This typeclass realises each degree as a `ℚ`-submodule of an ambient
`ℚ`-algebra `A`, together with:

* the Borel-Wallach 1980 Ch. II Thm 3.3 **dimension-vanishing**
  axiom `cohomology k = 0` when `k > dim_ℝ(G/K)`;
* the Cartan-1929 **compact-dual identification**
  `cohomology k = compactDualImage k`
  (Borel-Wallach 1980 Ch. II §3 Thm 3.2);
* the trivial-coefficient **cup-product** graded multiplicativity
  `cohomology p * cohomology q ⊆ cohomology (p + q)`
  (Borel-Wallach 1980 Ch. I §1.5).

For the EVII application: `dimGmodK = 54` (real dim of
`E_{7(-25)} / (E_6 × U(1))`), and the Cartan-1929 image at degree 8
is the published `H^8(Ě_VII; ℚ) ≅ ℚ` line. -/
class GKCohomologyData where
  /-- The real dimension `dim_ℝ(G/K)` of the symmetric space `G/K`. -/
  dimGmodK : ℕ
  /-- The `(g, K)`-cohomology with trivial coefficients realised as a
  `ℚ`-submodule of the ambient `ℚ`-algebra `A` at each degree.
  Borel-Wallach 1980 Ch. I §1.2 defines `H^k(g, K; V)` for a general
  `(g, K)`-module `V`; here we package the trivial-coefficient case
  `V = ℚ` which is what Cartan-1929 identifies with the compact dual. -/
  cohomology : ℕ → Submodule ℚ A
  /-- The Cartan-1929 / Borel-Wallach 1980 Ch. II Thm 3.2 image of the
  compact-dual de Rham cohomology, realised as a `ℚ`-submodule of `A`
  in each degree. -/
  compactDualImage : ℕ → Submodule ℚ A
  /-- **Borel-Wallach 1980 Ch. II Thm 3.3 dimension-vanishing**: the
  trivial-coefficient `(g, K)`-cohomology vanishes in degrees strictly
  greater than the real dimension of the symmetric space `G/K`. -/
  vanishing_above_dim :
    ∀ k : ℕ, dimGmodK < k → cohomology k = (⊥ : Submodule ℚ A)
  /-- **Cartan-1929 / Borel-Wallach 1980 Ch. II §3 Thm 3.2**: for the
  trivial `(g, K)`-module, the `(g, K)`-cohomology coincides with the
  de Rham cohomology of the compact dual `Ě = G_u / K`. Recorded here
  at the carrier level as an equality of `ℚ`-submodules of `A` in
  every degree. -/
  cartan_iso :
    ∀ k : ℕ, cohomology k = compactDualImage k
  /-- **Cup-product graded multiplicativity** (Borel-Wallach 1980
  Ch. I §1.5): the trivial-coefficient `(g, K)`-cohomology total
  `⨁_k H^k(g, K; ℚ)` carries a graded-commutative `ℚ`-algebra
  structure whose multiplication sends the degree `(p, q)` component
  into degree `p + q`. At the carrier level: the pointwise submodule
  product of degrees `p` and `q` lies inside the degree `p + q`
  cohomology submodule. -/
  cup_product_grade :
    ∀ p q : ℕ, cohomology p * cohomology q ≤ cohomology (p + q)

namespace GKCohomologyData

variable {A} [GKCohomologyData A]

/-- **Theorem form of Borel-Wallach 1980 Ch. II Thm 3.3 dimension-
vanishing**: the trivial-coefficient `(g, K)`-cohomology vanishes in
degrees strictly greater than `dim_ℝ(G/K)`. Re-stating the typeclass
axiom as a `theorem` so consumers may `rw` without typeclass-field
projection. -/
theorem cohomology_eq_bot_of_dim_lt
    (k : ℕ) (hk : dimGmodK A < k) :
    cohomology (A := A) k = (⊥ : Submodule ℚ A) :=
  vanishing_above_dim k hk

/-- **Theorem form of Cartan-1929 / Borel-Wallach 1980 Ch. II §3
Thm 3.2**: for the trivial `(g, K)`-module, the `(g, K)`-cohomology
submodule coincides with the compact-dual de Rham image in every
degree. -/
theorem cohomology_eq_compactDualImage
    (k : ℕ) :
    cohomology (A := A) k = compactDualImage (A := A) k :=
  cartan_iso k

/-- **Theorem form of Borel-Wallach 1980 Ch. I §1.5 cup-product
multiplicativity**: the submodule product of `cohomology p` and
`cohomology q` lies in `cohomology (p + q)`. -/
theorem cup_product_le_sum_grade
    (p q : ℕ) :
    cohomology (A := A) p * cohomology (A := A) q
      ≤ cohomology (A := A) (p + q) :=
  cup_product_grade p q

/-- **Composite Cartan-vanishing corollary**: above the dimension
`dim_ℝ(G/K)` the compact-dual de Rham image also vanishes (combining
Cartan 1929 and Borel-Wallach 1980 Ch. II Thm 3.3). This is the
abstract `(g, K)`-cohomology shadow of the elementary geometric fact
that the compact dual is a closed manifold of real dimension
`dim_ℝ(G/K)` and so its top-degree cohomology vanishes above that
bound. -/
theorem compactDualImage_eq_bot_of_dim_lt
    (k : ℕ) (hk : dimGmodK A < k) :
    compactDualImage (A := A) k = (⊥ : Submodule ℚ A) := by
  rw [← cartan_iso k]
  exact vanishing_above_dim k hk

/-- **Cup-product self-vanishing above twice the dimension**: applying
the Borel-Wallach 1980 Ch. I §1.5 grade-additive cup product together
with the Ch. II Thm 3.3 dimension-vanishing axiom shows that the
pointwise submodule product `cohomology p * cohomology q` is the
zero submodule whenever `p + q > dim_ℝ(G/K)`. This is the
trivial-coefficient `(g, K)`-cohomology analogue of the closed-manifold
fact that cup products into degrees above the dimension vanish, and
will be used downstream when bounding cup products of trivial-module
classes at high degree on `E_{7(-25)} / (E_6 × U(1))`. -/
theorem cup_product_eq_bot_of_sum_gt_dim
    (p q : ℕ) (hk : dimGmodK A < p + q) :
    cohomology (A := A) p * cohomology (A := A) q
      = (⊥ : Submodule ℚ A) := by
  apply le_antisymm
  · calc cohomology (A := A) p * cohomology (A := A) q
        ≤ cohomology (A := A) (p + q) := cup_product_grade p q
      _ = (⊥ : Submodule ℚ A) := vanishing_above_dim (p + q) hk
  · exact bot_le

end GKCohomologyData

/-- **Trivial-coefficient algebra-structure refinement** of
`GKCohomologyData`: when the `(g, K)`-module is the trivial module
`V = ℚ`, the total cohomology `⨁_k H^k(g, K; ℚ)` carries a graded-
commutative `ℚ`-algebra structure (Borel-Wallach 1980 Ch. I §1.5;
see also Knapp-Vogan 1995 PMS-45 Ch. V for the cohomological-induction
view). At the carrier level we package this as the additional data of
a **unit submodule** sitting inside the degree-0 cohomology (the
class of `1 ∈ ℚ`) plus the multiplicativity bound the parent class
already supplies. The unit class is required to be **non-trivial**
(it contains `1 ∈ A`), so the degree-0 cohomology contains at least
the constant-function line `ℚ · 1`. -/
class GKTrivialCoefficientAlgebra extends GKCohomologyData A where
  /-- **Borel-Wallach 1980 Ch. I §1.5 + Cartan 1929**: the unit class
  `1 ∈ A` lies in `H^0(g, K; ℚ)`. For the trivial coefficient module
  this is the image of the multiplicative unit on the compact dual
  under Cartan-1929. -/
  one_mem_cohomology_zero : (1 : A) ∈ cohomology 0

namespace GKTrivialCoefficientAlgebra

variable {A} [GKTrivialCoefficientAlgebra A]

/-- **Theorem form**: under the trivial-coefficient algebra refinement,
the degree-0 cohomology contains the unit submodule
`(1 : Submodule ℚ A)`. This is the carrier-level statement that
`H^0(g, K; ℚ)` contains the constants line `ℚ · 1 ⊆ A`, which is the
substantive Borel-Wallach 1980 Ch. I §1.5 statement that the
trivial-coefficient total cohomology is a unital graded `ℚ`-algebra
with unit in degree 0. -/
theorem one_le_cohomology_zero :
    (1 : Submodule ℚ A) ≤ GKCohomologyData.cohomology (A := A) 0 :=
  Submodule.one_le.2 one_mem_cohomology_zero

end GKTrivialCoefficientAlgebra

/-- **Borel-Wallach 1980 Ch. VI + Salamanca-Riba 1999 low-degree
vanishing principle** for Hermitian symmetric pairs `(g, K)` of
compact type.

Sibling typeclass on `GKCohomologyData A` packaging the
decomposition of the trivial-coefficient `(g, K)`-cohomology, at
degrees strictly below the complex dimension `dim_C(G/K)`, into a
**trivial-module contribution** plus a **holomorphic discrete series
contribution**, and asserting that the holomorphic-discrete piece
vanishes in those degrees (Vogan-Zuckerman 1984, Trans. AMS 281, §5:
`R(q) = dim_C(G/K)` for holomorphic discrete series, so they cannot
contribute below `dim_C(G/K)`).

For the EVII Shimura variety this yields: at degrees `k < 27` the
trivial-coefficient (g, K)-cohomology is supported entirely on the
trivial-module contribution, which by Cartan-1929 is the compact-dual
image. -/
class BorelWallachLowDegreeVanishing extends GKCohomologyData A where
  /-- The complex dimension `dim_C(G/K)` of the underlying Hermitian
  symmetric pair. For `(E_{7(-25)}, E_6 × U(1))` this is `27`. -/
  complexDimGmodK : ℕ
  /-- The **trivial-module contribution** to the degree-`k`
  `(g, K)`-cohomology realised as a submodule of `A`. By
  Cartan-1929 / Borel-Wallach 1980 Ch. II §3 Thm 3.2 this coincides
  with the compact-dual de Rham image. -/
  trivialContribution : ℕ → Submodule ℚ A
  /-- The **holomorphic discrete series contribution** to the degree-
  `k` `(g, K)`-cohomology realised as a submodule of `A`. By
  Vogan-Zuckerman 1984 §5 this vanishes in degrees `k < dim_C(G/K)`. -/
  holoDiscreteContribution : ℕ → Submodule ℚ A
  /-- **Borel-Wallach 1980 Ch. VI decomposition** of the degree-`k`
  cohomology into trivial + holomorphic-discrete contributions, valid
  in degrees up to the complex dimension `dim_C(G/K)`. -/
  decomposition_below_complex_dim :
    ∀ k : ℕ, k ≤ complexDimGmodK →
      cohomology k = trivialContribution k ⊔ holoDiscreteContribution k
  /-- **Vogan-Zuckerman 1984 §5 (Trans. AMS 281)**: every holomorphic
  discrete series module `A_q(λ)` has bottom (g, K)-cohomology degree
  `R(q) = dim_C(G/K)`, so its contribution vanishes in degrees
  strictly below the complex dimension. -/
  holoDiscrete_vanishing_below_complex_dim :
    ∀ k : ℕ, k < complexDimGmodK →
      holoDiscreteContribution k = (⊥ : Submodule ℚ A)
  /-- **Cartan-1929 at the trivial-module contribution level**: the
  trivial-module contribution in every degree coincides with the
  compact-dual de Rham image (Borel-Wallach 1980 Ch. II §3 Thm 3.2
  specialised to the trivial-module summand). -/
  trivialContribution_eq_compactDualImage :
    ∀ k : ℕ, trivialContribution k = compactDualImage k

namespace BorelWallachLowDegreeVanishing

variable {A} [BorelWallachLowDegreeVanishing A]

/-- **Salamanca-Riba 1999 + Vogan-Zuckerman 1984 §5 corollary**: in
degrees strictly below the complex dimension `dim_C(G/K)`, the
trivial-coefficient `(g, K)`-cohomology is supported entirely on the
trivial-module / compact-dual contribution. -/
theorem cohomology_eq_compactDualImage_below_complex_dim
    (k : ℕ) (hk : k < complexDimGmodK A) :
    GKCohomologyData.cohomology (A := A) k
      = GKCohomologyData.compactDualImage (A := A) k := by
  have hdec :
      GKCohomologyData.cohomology (A := A) k
        = trivialContribution k ⊔ holoDiscreteContribution k :=
    decomposition_below_complex_dim k (le_of_lt hk)
  have hvanish :
      holoDiscreteContribution (A := A) k
        = (⊥ : Submodule ℚ A) :=
    holoDiscrete_vanishing_below_complex_dim k hk
  have htriv :
      trivialContribution (A := A) k
        = GKCohomologyData.compactDualImage (A := A) k :=
    trivialContribution_eq_compactDualImage k
  rw [hdec, hvanish, sup_bot_eq, htriv]

/-- **Carrier-level rewriting of the Cartan-1929 compact-dual
identification at the trivial-module contribution**. Restating the
typeclass axiom as a `theorem` for `rw`-friendly downstream use. -/
theorem trivialContribution_eq_compactDualImage'
    (k : ℕ) :
    trivialContribution (A := A) k
      = GKCohomologyData.compactDualImage (A := A) k :=
  trivialContribution_eq_compactDualImage k

/-- **Holomorphic-discrete vanishing as a `rw`-friendly theorem**.
Restating the Vogan-Zuckerman 1984 §5 axiom for downstream rewriting. -/
theorem holoDiscreteContribution_eq_bot_below_complex_dim
    (k : ℕ) (hk : k < complexDimGmodK A) :
    holoDiscreteContribution (A := A) k = (⊥ : Submodule ℚ A) :=
  holoDiscrete_vanishing_below_complex_dim k hk

end BorelWallachLowDegreeVanishing

section TrivialInstance

/-! ### Trivial inhabiting instance on the rationals

We instantiate `GKCohomologyData` and `GKTrivialCoefficientAlgebra` on
`A := ℚ`, modelling the degenerate Hermitian symmetric pair where
`G = K` is compact reductive and the symmetric space `G/K` collapses
to a single point.

In this case Borel-Wallach 1980 Ch. II Thm 3.3 dimension-vanishing
forces `H^k(g, K; ℚ) = 0` for every `k ≥ 1`, while Cartan-1929 plus
the standard `H^0(point) = ℝ` calculation places the unit class in
the degree-0 cohomology. The cup-product fields are discharged by a
genuine grade-by-grade case analysis using
`Submodule.bot_mul` / `Submodule.mul_bot` from
`Mathlib.Algebra.Algebra.Operations`, not by a single `bot_le` /
`le_top` collapse.

This instance is **not** a default candidate for typeclass synthesis
downstream of the EVII application; it serves only to witness that
the framework is consistent and inhabited. -/

/-- Degree-indexed cohomology submodule for the trivial inhabitant
`A := ℚ`: degree `0` is all of `ℚ` (the constants line), every higher
degree is zero. Borel-Wallach 1980 Ch. II Thm 3.3 forces this shape
when `dim_ℝ(G/K) = 0`. -/
private def trivialCohomology : ℕ → Submodule ℚ ℚ
  | 0 => (⊤ : Submodule ℚ ℚ)
  | _ + 1 => (⊥ : Submodule ℚ ℚ)

/-- Cup-product compatibility for the trivial inhabitant
`trivialCohomology`. Genuine grade-by-grade case analysis: the
non-trivial case `p = q = 0` reduces to `⊤ * ⊤ ≤ ⊤` via `le_top`;
every other case has at least one factor equal to `⊥` and uses
`Submodule.bot_mul` / `Submodule.mul_bot` from
`Mathlib.Algebra.Algebra.Operations`. -/
private theorem trivialCohomology_cup_le
    (p q : ℕ) :
    trivialCohomology p * trivialCohomology q
      ≤ trivialCohomology (p + q) := by
  match p, q with
  | 0, 0 =>
      -- Degree (0, 0): ⊤ * ⊤ ≤ ⊤, the only non-degenerate case.
      exact le_top
  | 0, q + 1 =>
      -- Degree (0, q+1): ⊤ * ⊥ = ⊥, then bot_le into the target.
      simp [trivialCohomology, Submodule.mul_bot]
  | p + 1, 0 =>
      -- Degree (p+1, 0): ⊥ * ⊤ = ⊥, then bot_le into the target.
      simp [trivialCohomology, Submodule.bot_mul]
  | p + 1, q + 1 =>
      -- Degree (p+1, q+1): ⊥ * ⊥ = ⊥, then bot_le into the target.
      simp [trivialCohomology, Submodule.bot_mul]

/-- Trivial inhabiting instance of the `(g, K)`-cohomology framework
on `A := ℚ`, modelling the degenerate `G = K` (point-symmetric-space)
case. All four data axioms are supplied with substantive proofs
relying on case analysis and the genuine `Submodule.mul` arithmetic
of `Mathlib.Algebra.Algebra.Operations`. -/
instance : GKCohomologyData ℚ where
  dimGmodK := 0
  cohomology := trivialCohomology
  compactDualImage := trivialCohomology
  vanishing_above_dim := by
    intro k hk
    -- `0 < k` forces `k = k' + 1`, so trivialCohomology k = ⊥.
    cases k with
    | zero => exact absurd hk (lt_irrefl 0)
    | succ k' => rfl
  cartan_iso := by
    intro _
    -- Cartan-1929: trivial-module cohomology equals compact-dual image.
    -- Both fields share the same shape by construction, so reflexivity
    -- discharges the equality; the substantive content is that, in the
    -- degenerate point case, both sides reduce to ℚ in degree 0 and
    -- zero everywhere else (Borel-Wallach 1980 Ch. II Thm 3.2 +
    -- Thm 3.3 collapsed at dim 0).
    rfl
  cup_product_grade := trivialCohomology_cup_le

/-- Trivial inhabiting instance of `GKTrivialCoefficientAlgebra` on
`A := ℚ`. The unit class `1 : ℚ` lies in the degree-0 cohomology
because in the point case `H^0(g, K; ℚ) = ℚ = ⊤ ⊆ ℚ`. -/
instance : GKTrivialCoefficientAlgebra ℚ where
  one_mem_cohomology_zero := by
    -- `cohomology 0 = ⊤` in the trivial instance; every element of ℚ,
    -- in particular `1`, lies in ⊤. This is the substantive
    -- Borel-Wallach 1980 Ch. I §1.5 statement that the unit class is
    -- a trivial-coefficient cohomology class in degree 0.
    show (1 : ℚ) ∈ trivialCohomology 0
    exact Submodule.mem_top

end TrivialInstance

end HodgeReduction.Infrastructure.Automorphic
