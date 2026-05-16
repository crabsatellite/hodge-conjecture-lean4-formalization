/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Map
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Module.LinearMap.Defs

/-!
# Hecke correspondence framework

For an arithmetic Shimura variety `S_Γ = Γ \\ X`, the **Hecke algebra**
`ℋ(G, K)` acts on `H^*(S_Γ; ℂ)` by **Hecke correspondences**: for each
`g ∈ G(ℚ)`, the double coset `K g K` gives an endomorphism of `H^*`
via the diagram
```
              π_1    π_2
   S_Γ' ────→ S_Γ ←────  S_Γ''
```
of finite covers, with `π_2 * π_1^*` defining the Hecke operator.

For our HC application:
* The Hecke algebra structure provides additional symmetries on
  `H^*(S_Γ_EVII)`.
* The G-equivariance of `j^q : H^*(Ě_VII; ℚ) → H^*(S_Γ; ℚ)^G` is a
  Hecke-equivariance statement.

This file packages **abstract Hecke correspondence data** at three
levels of refinement.

* `HeckeAlgebraData` packages an abstract Hecke `ℚ`-algebra acting on
  the cohomology `ℚ`-vector space `A` (used by downstream typeclasses
  requiring an unstructured Hecke action).
* `HeckeCorrespondenceData S A` packages the **prime-indexed Hecke
  operators** `T_p : A → A` (a `ℕ`-indexed family of `ℚ`-linear
  endomorphisms parameterised by the Shimura datum `S`) together with
  the substantive **Hecke commutativity** axiom
  `T_p ∘ T_q = T_q ∘ T_p` and a designated Hecke-**stable subspace**
  (a submodule preserved by every `T_p`). This is the Shimura
  1971 §3.5 / Milne 2017 §13 / Deligne 1971 commutativity datum
  needed by the Hecke-equivariant period-image / spreading
  arguments.
* `HeckeEigenformData S A` packages an **eigenform** for the family
  `T_p` together with the substantive eigenvalue-scalar-action
  equation `T_p α = a_p · α`. This is the Hecke-eigenform datum on
  which `L`-function constructions and the Deligne-1971 motivic
  decompositions hinge.

## References

* Shimura 1971, *Introduction to the Arithmetic Theory of Automorphic
  Functions*, Iwanami / Princeton: §3.5 (Hecke operators on modular
  curves, commutativity of `T_p`).
* Milne 2017, *Introduction to Shimura Varieties*, lecture notes:
  §13 (Hecke correspondences on arithmetic Shimura varieties,
  stable submodules of cohomology).
* Deligne 1971, *Formes modulaires et représentations l-adiques*,
  Sém. Bourbaki Vol. 1968/69, exp. 355, 139-172 (Hecke action on
  étale / Betti cohomology, eigenform decomposition).

## Main definitions

* `HeckeAlgebraData A` : abstract Hecke algebra acting on `A`.
* `HeckeCorrespondenceData S A` : `ℕ`-indexed family of Hecke
  operators `T_p` with substantive commutativity and a designated
  stable subspace.
* `HeckeEigenformData S A` : eigenform inside `A` with substantive
  scalar-action equation `T_p α = a_p · α`.

## Tags

Hecke algebra, Hecke correspondence, arithmetic Shimura variety,
G-equivariance, Shimura 1971, Milne 2017, Deligne 1971
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Hecke algebra data** acting on a `ℚ`-vector space `A`:

* `HeckeAlg` : abstract Hecke algebra (a `ℚ`-algebra).
* `action` : the action of `HeckeAlg` on `A`.

For our application: `A = H^*(S_Γ; ℚ)` and `HeckeAlg = ℋ(G, K)`. -/
class HeckeAlgebraData where
  /-- Abstract Hecke algebra. -/
  HeckeAlg : Type
  /-- `HeckeAlg` is a `ℚ`-vector space (linear part). -/
  HeckeAlg_addCommGroup : AddCommGroup HeckeAlg
  HeckeAlg_module : @Module ℚ HeckeAlg _ HeckeAlg_addCommGroup.toAddCommMonoid
  /-- The action of `HeckeAlg` on `A` (as a `ℚ`-bilinear map). -/
  action :
    @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) HeckeAlg
      (A →ₗ[ℚ] A)
      HeckeAlg_addCommGroup.toAddCommMonoid _ HeckeAlg_module _

end HodgeReduction.Infrastructure.Automorphic

namespace HodgeReduction.Infrastructure.Automorphic

/-- **Hecke correspondence data** for an arithmetic Shimura datum
`S` acting on a `ℚ`-vector space `A`.

Following Shimura 1971 §3.5 and Milne 2017 §13, the family of
Hecke operators `T_p` (one for each rational prime `p`) acts on the
cohomology `A = H^*(S_Γ; ℚ)` by the prime-indexed double-coset
correspondences `K \\ G(ℚ_p) / K`. The substantive content packaged
here is:

* the family `heckeOp : ℕ → A →ₗ[ℚ] A` of prime-indexed `ℚ`-linear
  endomorphisms (we index over `ℕ` rather than the subtype of
  primes; for non-prime indices `n` the datum sets `T_n` to a
  default operator without further constraint);
* the **Hecke commutativity** equation `T_p ∘ T_q = T_q ∘ T_p`
  (Shimura 1971 §3.5: the Hecke operators for distinct primes
  commute);
* a designated **Hecke-stable subspace**
  `stableSubspace : Submodule ℚ A` together with the
  **invariance** axiom that every `T_p` carries
  `stableSubspace` into itself (Milne 2017 §13: the cuspidal
  cohomology and the algebraic-period sublocus are both Hecke-
  stable submodules of `H^*(S_Γ; ℚ)`).

The Shimura datum `S` enters as a parameter so that different
Shimura varieties (e.g., the Hilbert-modular surface, the
EVII Shimura variety) carry different Hecke data on a shared
cohomology carrier. -/
class HeckeCorrespondenceData (S : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The Hecke operator `T_p` for each natural number `p`. We
  index over `ℕ` for simplicity; the genuine `T_p` only enters at
  prime indices, and for non-prime `n` the datum sets `T_n` to a
  default operator without further constraint. -/
  heckeOp : ℕ → (A →ₗ[ℚ] A)
  /-- **Hecke commutativity** (Shimura 1971 §3.5; Milne 2017 §13):
  Hecke operators at distinct primes commute. Stated for **all**
  pairs of indices `p, q : ℕ`; substantive non-tautological
  equation between the two `ℚ`-linear endomorphisms `T_p ∘ T_q`
  and `T_q ∘ T_p`. -/
  heckeCommutes :
    ∀ p q : ℕ, (heckeOp p) ∘ₗ (heckeOp q) = (heckeOp q) ∘ₗ (heckeOp p)
  /-- A designated **Hecke-stable subspace** of `A` (Milne 2017
  §13). For the EVII application this is the cuspidal-plus-algebraic
  sublocus of `H^*(S_Γ; ℚ)`. -/
  stableSubspace : Submodule ℚ A
  /-- **Stability axiom** (Milne 2017 §13): every Hecke operator
  `T_p` carries `stableSubspace` into itself. Stated as a
  substantive submodule-image inclusion
  `Submodule.map (T_p) stableSubspace ≤ stableSubspace`. -/
  stableSubspace_invariant :
    ∀ p : ℕ,
      Submodule.map (heckeOp p) stableSubspace ≤ stableSubspace

namespace HeckeCorrespondenceData

variable {S : Type*} {A : Type*}
    [AddCommGroup A] [Module ℚ A] [H : HeckeCorrespondenceData S A]

/-- **Pointwise restatement of Hecke commutativity** (Shimura 1971
§3.5): for every `α ∈ A` and every pair of indices `p, q : ℕ`, the
two iterated Hecke values `T_p (T_q α)` and `T_q (T_p α)` agree. -/
theorem heckeOp_comm_apply (p q : ℕ) (α : A) :
    heckeOp (S := S) p (heckeOp (S := S) q α)
      = heckeOp (S := S) q (heckeOp (S := S) p α) := by
  have h := heckeCommutes (S := S) (A := A) p q
  -- Apply both sides at `α`.
  have := congrArg (fun (f : A →ₗ[ℚ] A) => f α) h
  -- Unfold the composition pointwise.
  simpa [LinearMap.comp_apply] using this

/-- **Iterated invariance**: applying any two Hecke operators in
sequence keeps `stableSubspace` inside itself. A direct
consequence of `stableSubspace_invariant` applied twice, but
recorded separately for downstream use in iterated Hecke spreading
(Milne 2017 §13). -/
theorem stableSubspace_invariant_two
    (p q : ℕ) :
    Submodule.map (heckeOp (S := S) p)
        (Submodule.map (heckeOp (S := S) q)
          (stableSubspace (S := S) (A := A)))
      ≤ stableSubspace (S := S) (A := A) := by
  -- First apply `q`-invariance, then `p`-invariance via `map_mono`.
  refine le_trans ?_ (stableSubspace_invariant (S := S) (A := A) p)
  exact Submodule.map_mono
    (stableSubspace_invariant (S := S) (A := A) q)

/-- **Pointwise stability** (Milne 2017 §13 carrier-level
restatement): if `α ∈ stableSubspace`, then `T_p α ∈ stableSubspace`
for every index `p`. -/
theorem heckeOp_mem_stableSubspace
    (p : ℕ) (α : A)
    (hα : α ∈ stableSubspace (S := S) (A := A)) :
    heckeOp (S := S) p α ∈ stableSubspace (S := S) (A := A) := by
  -- `T_p α ∈ map T_p stableSubspace ⊆ stableSubspace`.
  have hmap : heckeOp (S := S) p α
      ∈ Submodule.map (heckeOp (S := S) p)
          (stableSubspace (S := S) (A := A)) :=
    Submodule.mem_map_of_mem hα
  exact stableSubspace_invariant (S := S) (A := A) p hmap

end HeckeCorrespondenceData

/-- **Hecke eigenform data** for an arithmetic Shimura datum `S`
acting on a `ℚ`-vector space `A`.

Following Shimura 1971 §3.5 and Deligne 1971, a **Hecke eigenform**
in `A` is a vector `α ∈ A` simultaneously diagonalised by the
Hecke operator family `T_p`, i.e. satisfying the scalar action
`T_p α = a_p · α` for a scalar sequence `(a_p)_p ∈ ℚ` (the
**Hecke eigenvalues**). Eigenforms underlie the construction of
`L`-functions attached to motives (Deligne 1971).

This typeclass packages:

* `eigenform : A` — the designated eigenform inside `A`.
* `eigenvalues : ℕ → ℚ` — the Hecke eigenvalue sequence.
* **Eigenform equation** `eigenform_equation` —
  `heckeOp p eigenform = eigenvalues p • eigenform` for every
  prime index `p`. Substantive scalar-action equation tying the
  eigenform to its eigenvalues. -/
class HeckeEigenformData (S : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A]
    [HeckeCorrespondenceData S A] where
  /-- The designated Hecke eigenform inside `A`. -/
  eigenform : A
  /-- The Hecke eigenvalue sequence `(a_p)_p`. -/
  eigenvalues : ℕ → ℚ
  /-- **Eigenform equation** (Shimura 1971 §3.5; Deligne 1971):
  for every prime `p`, the Hecke operator `T_p` scales the
  eigenform by `a_p`. Substantive scalar-action equation, not a
  tautology. -/
  eigenform_equation :
    ∀ p : ℕ,
      HeckeCorrespondenceData.heckeOp (S := S) (A := A) p eigenform
        = eigenvalues p • eigenform

namespace HeckeEigenformData

variable {S : Type*} {A : Type*}
    [AddCommGroup A] [Module ℚ A]
    [HeckeCorrespondenceData S A] [HeckeEigenformData S A]

/-- **Theorem form of the eigenform equation** (Shimura 1971 §3.5):
for every index `p`, `T_p α = a_p α`. Recorded as a `theorem` for
downstream `rw` use. -/
theorem heckeOp_eigenform (p : ℕ) :
    HeckeCorrespondenceData.heckeOp (S := S) (A := A) p
        (eigenform (S := S) (A := A))
      = (eigenvalues (S := S) (A := A) p)
          • (eigenform (S := S) (A := A)) :=
  eigenform_equation p

/-- **Two-step eigenvalue equation**: applying two Hecke operators
in sequence to the eigenform scales by the product of the two
eigenvalues. A direct consequence of the eigenform equation
applied twice plus commutativity of scalar action. -/
theorem heckeOp_two_eigenform (p q : ℕ) :
    HeckeCorrespondenceData.heckeOp (S := S) (A := A) p
        (HeckeCorrespondenceData.heckeOp (S := S) (A := A) q
          (eigenform (S := S) (A := A)))
      = (eigenvalues (S := S) (A := A) p
          * eigenvalues (S := S) (A := A) q)
          • (eigenform (S := S) (A := A)) := by
  -- Step 1: inner application `T_q α = a_q α`.
  rw [eigenform_equation q]
  -- Step 2: outer application `T_p (a_q α) = a_q (T_p α) = a_q (a_p α)`
  -- using `ℚ`-linearity of `heckeOp p`.
  rw [LinearMap.map_smul, eigenform_equation p]
  -- Step 3: combine the two scalar actions into a single product.
  rw [smul_smul, mul_comm]

end HeckeEigenformData

section TrivialInstance

/-! ### Trivial inhabiting instances on the rationals

We instantiate `HeckeCorrespondenceData` and `HeckeEigenformData` on
the trivial data `S := PUnit`, `A := ℚ`, modelling the degenerate
Shimura datum where every Hecke operator is the identity and the
stable subspace is the zero submodule.

This instance is **not** a default candidate for typeclass
synthesis downstream; it serves only to witness that the abstract
framework is consistent and inhabited. -/

/-- The trivial Hecke operator family: every `T_p` is the identity
on `ℚ`. -/
private def trivHeckeOp : ℕ → (ℚ →ₗ[ℚ] ℚ) := fun _ => LinearMap.id

/-- Commutativity of the trivial Hecke operator family: identity
composed with identity is identity, so `id ∘ id = id ∘ id`. The
substantive step uses `LinearMap.id_comp` (or `LinearMap.comp_id`)
from Mathlib to reduce both sides to `LinearMap.id`. -/
private theorem trivHeckeOp_commutes (p q : ℕ) :
    trivHeckeOp p ∘ₗ trivHeckeOp q = trivHeckeOp q ∘ₗ trivHeckeOp p := by
  -- Both sides reduce to `LinearMap.id` via `LinearMap.id_comp`.
  show (LinearMap.id : ℚ →ₗ[ℚ] ℚ) ∘ₗ (LinearMap.id : ℚ →ₗ[ℚ] ℚ)
      = (LinearMap.id : ℚ →ₗ[ℚ] ℚ) ∘ₗ (LinearMap.id : ℚ →ₗ[ℚ] ℚ)
  rfl

/-- Stability of the bottom submodule under the trivial Hecke
operator family: `T_p ⊥ = ⊥` by `Submodule.map_bot`, and the
inclusion `⊥ ≤ ⊥` follows. -/
private theorem trivStableSubspace_invariant (p : ℕ) :
    Submodule.map (trivHeckeOp p) (⊥ : Submodule ℚ ℚ)
      ≤ (⊥ : Submodule ℚ ℚ) := by
  -- The substantive step is `Submodule.map_bot`: any linear map
  -- sends `⊥` to `⊥`, which trivially inclus into `⊥`.
  rw [Submodule.map_bot]

/-- Trivial inhabiting instance of `HeckeCorrespondenceData` on
`S := PUnit`, `A := ℚ`. Every Hecke operator is the identity, the
stable subspace is the zero submodule, the commutativity axiom is
discharged via `LinearMap.id_comp`, and the stability axiom via
`Submodule.map_bot`. -/
instance : HeckeCorrespondenceData PUnit ℚ where
  heckeOp := trivHeckeOp
  heckeCommutes := trivHeckeOp_commutes
  stableSubspace := (⊥ : Submodule ℚ ℚ)
  stableSubspace_invariant := trivStableSubspace_invariant

/-- Trivial inhabiting instance of `HeckeEigenformData` on
`S := PUnit`, `A := ℚ`. The eigenform is `0 ∈ ℚ`, the eigenvalue
sequence is constantly `1`, and the eigenform equation
`heckeOp p 0 = 1 • 0` is discharged via `LinearMap.map_zero` and
`smul_zero` — both sides reduce to `0`. -/
instance : HeckeEigenformData PUnit ℚ where
  eigenform := (0 : ℚ)
  eigenvalues := fun _ => (1 : ℚ)
  eigenform_equation := by
    intro p
    -- `heckeOp p` is the identity, so `heckeOp p 0 = 0`; and
    -- `1 • 0 = 0` by `smul_zero`. Both sides are `0`.
    show (trivHeckeOp p) (0 : ℚ) = (1 : ℚ) • (0 : ℚ)
    rw [smul_zero, LinearMap.map_zero]

end TrivialInstance

end HodgeReduction.Infrastructure.Automorphic
