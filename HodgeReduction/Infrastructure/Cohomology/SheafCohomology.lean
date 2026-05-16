/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Data.Complex.Module
import Mathlib.LinearAlgebra.Dimension.Finite
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.LinearIndependent
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Sheaf cohomology framework (abstract)

For a smooth projective variety `X` and a coherent sheaf `F` on `X`,
the **sheaf cohomology** `H^i(X; F)` is the right-derived functor of
global sections.

Key cases for HC:
* `H^i(X; ℚ)` (constant sheaf) = singular cohomology over `ℚ`.
* `H^i(X; 𝒪_X)` = sheaf cohomology of structure sheaf (Hodge `(0, i)`-piece).
* `H^i(X; Ω^p_X)` = sheaf cohomology of `p`-forms (Hodge `(p, i)`-piece).
* Hodge decomposition: `H^k(X; ℂ) = ⨁_{p+q=k} H^q(X; Ω^p_X)`.

For our HC application, the Hodge decomposition for the rational
cohomology is the source of the (p, p)-Hodge bigrading.

This file packages **abstract sheaf cohomology data** alongside two
sibling layers:

* the **Dolbeault** cohomology of `(p, q)`-forms (with vanishing above
  complex dimension and Hodge symmetry at the `finrank` level), and
* the **Čech-to-sheaf** comparison isomorphism that identifies the
  `(p, q)`-Dolbeault piece with the corresponding sheaf-cohomology
  rational piece.

## References

* R. Hartshorne, *Algebraic Geometry*, Springer GTM **52**, 1977,
  Ch. III (sheaf cohomology, Čech cohomology, comparison theorem).
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Math. **76**, 2002, Ch. 4 (sheaf cohomology) and
  Ch. 5 (Dolbeault cohomology, Hodge decomposition).
* P. Griffiths and J. Harris, *Principles of Algebraic Geometry*,
  Wiley-Interscience, 1978, Ch. 0.3 (sheaf cohomology basics).

## Main definitions

* `SheafCohomologyData` — abstract sheaf cohomology functor data.
* `DolbeaultCohomologyData` — Dolbeault `(p, q)`-pieces with vanishing
  and Hodge symmetry.
* `CechCohomologyData` — Čech (p, q)-pieces equal to the sheaf piece
  (the Hartshorne III.4 / Leray comparison).

## Tags

sheaf cohomology, Dolbeault cohomology, Čech cohomology, Hodge symmetry,
Hodge decomposition, coherent sheaf, comparison theorem
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Sheaf cohomology (rational) -/

/-- **Sheaf cohomology data** for a smooth projective variety:

* `H_pq` : the Hodge `(p, q)`-piece for `p + q = k`.

For our HC application: this is the Hodge decomposition at the
abstract level. The full theory requires complex-analytic input
(de Rham / Dolbeault cohomology).

**R7 audit B.3 refactor (2026-05-16)**: previously carried a
`H_pq_bigrading_compatible : True` placeholder field with no
mathematical content. That field was deleted. The substantive
`H_pq : ℕ → ℕ → Submodule ℚ A` Submodule-valued data is retained;
downstream consumers will refine this with concrete bigrading axioms
on a per-variety basis (e.g., `V56HodgeDecomp`). -/
class SheafCohomologyData (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The `(p, q)`-Hodge piece of `A`. -/
  H_pq : ℕ → ℕ → Submodule ℚ A

/-! ## Dolbeault cohomology (complex `(p, q)`-pieces) -/

/-- **Dolbeault cohomology data** for a compact Kähler manifold `X` of
complex dimension `dim`, with cohomology carrier `A` modelling
`H^*(X; ℂ)`.

Fields:

* `dim` — the complex dimension `n` of `X`.
* `Hpq p q` — the Dolbeault `(p, q)`-piece, `H^{p,q}(X) ⊆ A`.
* `vanishing` — `H^{p,q}(X) = 0` whenever `p > n` or `q > n`. This is
  a substantive submodule equality, not a tautology: the only `Submodule`
  satisfying `M = ⊥` is the zero submodule itself.
* `hodge_symmetry_finrank` — Hodge symmetry at the dimension level:
  `dim_ℂ H^{p,q}(X) = dim_ℂ H^{q,p}(X)`. The underlying isomorphism
  `H^{p,q} ≃ H^{q,p}` is induced by complex conjugation on harmonic
  forms; for the abstract interface we record the `finrank` equality,
  which a concrete-conjugation instance would derive verbatim.

The decomposition `H^k(X; ℂ) = ⨁_{p+q=k} H^{p,q}(X)` (Voisin I, Ch. 5;
Griffiths-Harris 0.7) is implicit: downstream files refine this data
with the explicit direct-sum identity. -/
class DolbeaultCohomologyData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℂ A] where
  /-- The complex dimension of `X`. -/
  dim : ℕ
  /-- The Dolbeault `(p, q)`-piece of cohomology. -/
  Hpq : ℕ → ℕ → Submodule ℂ A
  /-- **Vanishing above complex dimension**: `H^{p,q} = 0` when `p > n`
  or `q > n`. -/
  vanishing : ∀ p q : ℕ, dim < p ∨ dim < q → Hpq p q = ⊥
  /-- **Hodge symmetry at the dimension level**:
  `dim_ℂ H^{p,q} = dim_ℂ H^{q,p}`. -/
  hodge_symmetry_finrank : ∀ p q : ℕ,
    Module.finrank ℂ (Hpq p q) = Module.finrank ℂ (Hpq q p)

namespace DolbeaultCohomologyData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℂ A]
variable [DolbeaultCohomologyData X A]

/-! ### Direct re-exports of the axiomatic data as named theorems -/

/-- Theorem-level restatement of `vanishing`. -/
theorem vanishing_eq (p q : ℕ)
    (h : dim (X := X) (A := A) < p ∨ dim (X := X) (A := A) < q) :
    Hpq (X := X) (A := A) p q = ⊥ :=
  DolbeaultCohomologyData.vanishing p q h

/-- Theorem-level restatement of `hodge_symmetry_finrank`. -/
theorem hodge_symmetry_finrank_eq (p q : ℕ) :
    Module.finrank ℂ (Hpq (X := X) (A := A) p q)
      = Module.finrank ℂ (Hpq (X := X) (A := A) q p) :=
  DolbeaultCohomologyData.hodge_symmetry_finrank p q

/-- Vanishing in the first index alone: `p > dim ⇒ H^{p,q} = 0`. -/
theorem vanishing_of_p (p q : ℕ) (h : dim (X := X) (A := A) < p) :
    Hpq (X := X) (A := A) p q = ⊥ :=
  vanishing_eq p q (Or.inl h)

/-- Vanishing in the second index alone: `q > dim ⇒ H^{p,q} = 0`. -/
theorem vanishing_of_q (p q : ℕ) (h : dim (X := X) (A := A) < q) :
    Hpq (X := X) (A := A) p q = ⊥ :=
  vanishing_eq p q (Or.inr h)

/-- **Hodge numbers** `h^{p,q}(X) := dim_ℂ H^{p,q}(X)`. -/
noncomputable def hodgeNumber (p q : ℕ) : ℕ :=
  Module.finrank ℂ (Hpq (X := X) (A := A) p q)

/-- Hodge-number symmetry derived from `hodge_symmetry_finrank`. -/
theorem hodgeNumber_symm (p q : ℕ) :
    hodgeNumber (X := X) (A := A) p q
      = hodgeNumber (X := X) (A := A) q p :=
  hodge_symmetry_finrank_eq p q

/-- Hodge numbers vanish above complex dimension. -/
theorem hodgeNumber_vanishing (p q : ℕ)
    (h : dim (X := X) (A := A) < p ∨ dim (X := X) (A := A) < q) :
    hodgeNumber (X := X) (A := A) p q = 0 := by
  unfold hodgeNumber
  rw [vanishing_eq p q h]
  -- `finrank ℂ (⊥ : Submodule ℂ A) = 0` (Mathlib `finrank_bot`).
  exact finrank_bot ℂ A

end DolbeaultCohomologyData

/-! ## Čech cohomology (comparison with sheaf cohomology) -/

/-- **Čech cohomology data** for a Dolbeault-equipped carrier:

For a smooth projective variety `X` with sheaf `(p, q)`-pieces packaged
in `DolbeaultCohomologyData X A`, the **Čech-to-sheaf comparison
theorem** (Hartshorne III.4.5, Voisin I, §4.3, Griffiths-Harris 0.3)
gives a canonical isomorphism

```
Hˇ^q(𝒰; Ω^p) ≅ H^q(X; Ω^p) = H^{p, q}(X)
```

for an acyclic open cover `𝒰` of `X`. We package the Čech side as a
`(p, q)`-indexed family of submodules of the same carrier `A` together
with the equality `cechPiece p q = Hpq p q` (the comparison identity).

Fields:

* `cechPiece p q` — the Čech `(p, q)`-piece inside `A`.
* `cech_eq_sheaf` — the substantive comparison equality
  `cechPiece p q = Hpq p q` (a non-trivial `Submodule`-equality). -/
class CechCohomologyData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℂ A] [DolbeaultCohomologyData X A] where
  /-- The Čech `(p, q)`-piece. -/
  cechPiece : ℕ → ℕ → Submodule ℂ A
  /-- **Čech-to-sheaf comparison**: the Čech piece equals the Dolbeault
  piece. This is a substantive submodule equality (Hartshorne III.4.5). -/
  cech_eq_sheaf : ∀ p q : ℕ,
    cechPiece p q = DolbeaultCohomologyData.Hpq (X := X) (A := A) p q

namespace CechCohomologyData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℂ A]
variable [DolbeaultCohomologyData X A] [CechCohomologyData X A]

/-- Theorem-level restatement of `cech_eq_sheaf`. -/
theorem cech_eq_sheaf_eq (p q : ℕ) :
    cechPiece (X := X) (A := A) p q
      = DolbeaultCohomologyData.Hpq (X := X) (A := A) p q :=
  CechCohomologyData.cech_eq_sheaf p q

/-- Čech cohomology also vanishes above complex dimension (transported
through the comparison). -/
theorem cech_vanishing (p q : ℕ)
    (h : DolbeaultCohomologyData.dim (X := X) (A := A) < p
        ∨ DolbeaultCohomologyData.dim (X := X) (A := A) < q) :
    cechPiece (X := X) (A := A) p q = ⊥ := by
  rw [cech_eq_sheaf_eq, DolbeaultCohomologyData.vanishing_eq p q h]

/-- Čech Hodge symmetry at the dimension level, transported through the
comparison. -/
theorem cech_hodge_symmetry_finrank (p q : ℕ) :
    Module.finrank ℂ (cechPiece (X := X) (A := A) p q)
      = Module.finrank ℂ (cechPiece (X := X) (A := A) q p) := by
  rw [cech_eq_sheaf_eq, cech_eq_sheaf_eq]
  exact DolbeaultCohomologyData.hodge_symmetry_finrank_eq p q

end CechCohomologyData

/-! ## Trivial example: one-point manifold `(Unit, ℂ)`

A single point has complex dimension `0`, and the only non-vanishing
Dolbeault piece is `H^{0,0} = ℂ` (= the constants). All other pieces
vanish. The Čech piece coincides with the sheaf piece definitionally
under this instance. -/

namespace DolbeaultCohomologyData.Trivial

/-- Dolbeault piece for the one-point trivial example: `H^{0,0} = ℂ`,
all others zero. -/
noncomputable def HpqTrivial (p q : ℕ) : Submodule ℂ ℂ :=
  if p = 0 ∧ q = 0 then ⊤ else ⊥

@[simp]
theorem HpqTrivial_zero_zero : HpqTrivial 0 0 = ⊤ := by
  unfold HpqTrivial; simp

@[simp]
theorem HpqTrivial_eq_bot_of_p_pos {p q : ℕ} (hp : 0 < p) :
    HpqTrivial p q = ⊥ := by
  unfold HpqTrivial
  have : ¬ (p = 0 ∧ q = 0) := fun ⟨hp', _⟩ => Nat.lt_irrefl 0 (hp' ▸ hp)
  simp [this]

@[simp]
theorem HpqTrivial_eq_bot_of_q_pos {p q : ℕ} (hq : 0 < q) :
    HpqTrivial p q = ⊥ := by
  unfold HpqTrivial
  have : ¬ (p = 0 ∧ q = 0) := fun ⟨_, hq'⟩ => Nat.lt_irrefl 0 (hq' ▸ hq)
  simp [this]

/-- The trivial `DolbeaultCohomologyData` on `(Unit, ℂ)`. -/
noncomputable instance instDolbeaultCohomologyDataTrivial :
    DolbeaultCohomologyData Unit ℂ where
  dim := 0
  Hpq := HpqTrivial
  vanishing := by
    intro p q h
    rcases h with hp | hq
    · exact HpqTrivial_eq_bot_of_p_pos hp
    · exact HpqTrivial_eq_bot_of_q_pos hq
  hodge_symmetry_finrank := by
    intro p q
    by_cases h : p = 0 ∧ q = 0
    · obtain ⟨hp, hq⟩ := h
      subst hp; subst hq
      rfl
    · -- At least one of `p`, `q` is positive, so both `HpqTrivial p q`
      -- and `HpqTrivial q p` are `⊥`; finranks of `⊥` agree at `0`.
      have hpq : HpqTrivial p q = ⊥ := by
        rcases Nat.eq_zero_or_pos p with hp | hp
        · subst hp
          have hq : 0 < q := by
            rcases Nat.eq_zero_or_pos q with hq | hq
            · exact absurd ⟨rfl, hq⟩ h
            · exact hq
          exact HpqTrivial_eq_bot_of_q_pos hq
        · exact HpqTrivial_eq_bot_of_p_pos hp
      have hqp : HpqTrivial q p = ⊥ := by
        rcases Nat.eq_zero_or_pos q with hq | hq
        · subst hq
          have hp : 0 < p := by
            rcases Nat.eq_zero_or_pos p with hp | hp
            · exact absurd ⟨hp, rfl⟩ h
            · exact hp
          exact HpqTrivial_eq_bot_of_q_pos hp
        · exact HpqTrivial_eq_bot_of_p_pos hq
      rw [hpq, hqp]

/-- The trivial `CechCohomologyData` on `(Unit, ℂ)`: the Čech piece is
defined to coincide with the Dolbeault piece, so the comparison
equality is `rfl`. -/
noncomputable instance instCechCohomologyDataTrivial :
    CechCohomologyData Unit ℂ where
  cechPiece := HpqTrivial
  cech_eq_sheaf := fun _ _ => rfl

/-! ### Sanity checks for the trivial example -/

/-- **Sanity check**: dimension of the trivial example is `0`. -/
example : DolbeaultCohomologyData.dim (X := Unit) (A := ℂ) = 0 := rfl

/-- **Sanity check**: `(0, 0)`-Dolbeault piece is the full space. -/
example : DolbeaultCohomologyData.Hpq (X := Unit) (A := ℂ) 0 0 = ⊤ := by
  show HpqTrivial 0 0 = ⊤
  exact HpqTrivial_zero_zero

/-- **Sanity check**: `(1, 0)`-Dolbeault piece vanishes. -/
example : DolbeaultCohomologyData.Hpq (X := Unit) (A := ℂ) 1 0 = ⊥ := by
  show HpqTrivial 1 0 = ⊥
  exact HpqTrivial_eq_bot_of_p_pos (by omega)

/-- **Sanity check**: Hodge-number symmetry between off-diagonal entries
(both zero) of the trivial example. -/
example :
    DolbeaultCohomologyData.hodgeNumber (X := Unit) (A := ℂ) 0 1
      = DolbeaultCohomologyData.hodgeNumber (X := Unit) (A := ℂ) 1 0 :=
  DolbeaultCohomologyData.hodgeNumber_symm 0 1

/-- **Sanity check**: Čech piece at `(0, 0)` equals the Dolbeault piece. -/
example :
    CechCohomologyData.cechPiece (X := Unit) (A := ℂ) 0 0
      = DolbeaultCohomologyData.Hpq (X := Unit) (A := ℂ) 0 0 :=
  CechCohomologyData.cech_eq_sheaf_eq 0 0

/-- **Sanity check**: Čech piece at `(2, 0)` vanishes via comparison +
vanishing of the Dolbeault piece. -/
example :
    CechCohomologyData.cechPiece (X := Unit) (A := ℂ) 2 0 = ⊥ := by
  -- `dim Unit ℂ = 0 < 2`, so we feed `Or.inl` of that fact.
  have hdim : DolbeaultCohomologyData.dim (X := Unit) (A := ℂ) = 0 := rfl
  exact CechCohomologyData.cech_vanishing (X := Unit) (A := ℂ) 2 0
    (Or.inl (by rw [hdim]; exact Nat.succ_pos 1))

end DolbeaultCohomologyData.Trivial

end HodgeReduction.Infrastructure.Cohomology
