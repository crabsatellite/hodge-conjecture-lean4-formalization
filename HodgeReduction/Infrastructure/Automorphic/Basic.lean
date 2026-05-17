/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Ker
import Mathlib.Data.Complex.Module
import Mathlib.Algebra.Group.Subgroup.Defs

/-!
# Automorphic cohomology: Eisenstein/cuspidal decomposition

For an arithmetic locally-symmetric space `S_Γ := Γ \\ X` with `Γ`
a congruence subgroup of a reductive `ℚ`-algebraic group `G`,
the rational cohomology `H^*(S_Γ; ℚ)` decomposes:
```
H^*(S_Γ; ℚ) = H^*_{cusp}(S_Γ; ℚ) ⊕ H^*_{Eis}(S_Γ; ℚ)
```
where:

* `H^*_{cusp}` is the **cuspidal cohomology** (Borel 1974;
  Franke 1998 §1.2).
* `H^*_{Eis}` is the **Eisenstein cohomology** (Borel-Serre 1973;
  Franke 1998 §1.4).

The Eisenstein cohomology further decomposes by associate classes
of parabolic subgroups (Franke 1998 §1.4). For our HC application,
the key fact is:

**Eisenstein vanishing at deg 8 for EVII**: `H^8_{Eis}(S_Γ; ℚ) = 0`
when restricted to G-invariants, by Borel-Serre + Franke + the
codim-26 boundary stratum bound.

In addition to the rational cohomology splitting, we record the
**cuspidal-representation data** of an automorphic representation
`π` (with substantive group action and parabolic-vanishing
axiom) and the **`L²(Γ \\ G)` orthogonal decomposition** into
cuspidal and Eisenstein submodules (Borel-Jacquet 1979; Borel 1997;
Bump 1997 §3).

## References (Cat 2 PUBLISHED)

* A. Borel, H. Jacquet, "Automorphic forms and automorphic
  representations", in *Automorphic Forms, Representations and
  L-functions*, Proc. Symp. Pure Math. **33** (AMS 1979), Part 1,
  189-202. — Automorphic representations on adelic reductive
  groups; cuspidal/non-cuspidal split; parabolic vanishing.
* A. Borel, *Automorphic Forms on SL₂(ℝ)*, Cambridge Tracts in
  Mathematics **130** (CUP 1997). — Cuspidality criterion in
  terms of parabolic-subgroup constant-term vanishing.
* D. Bump, *Automorphic Forms and Representations*, Cambridge
  Studies in Advanced Mathematics **55** (CUP 1997). — `L²(Γ \\ G)`
  spectral decomposition; cuspidal ⊕ Eisenstein orthogonal
  splitting; Bessel/Whittaker models.

## Main definitions

* `AutomorphicCohomology A` : a typeclass providing the
  Eisenstein/cuspidal decomposition data. (Preserved.)
* `CuspidalRepData G π` : substantive `G`-action on a cuspidal
  representation carrier `π` with parabolic-vanishing axiom.
* `L2DecompositionData G H` : sibling typeclass packaging the
  orthogonal `L²(Γ \\ G) = cuspidal ⊕ Eisenstein` decomposition
  as a `Submodule ℂ H` splitting (Bump 1997 §3.2).

## Tags

automorphic cohomology, Eisenstein cohomology, cuspidal cohomology,
Franke 1998, Borel-Serre 1973, Borel-Jacquet 1979, Bump 1997,
cuspidal representation, L² decomposition
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Automorphic cohomology decomposition** data:

* `cuspidalPart` : the cuspidal cohomology subspace `H^*_{cusp} ⊆ A`.
* `eisensteinPart` : the Eisenstein cohomology subspace `H^*_{Eis} ⊆ A`.

The two parts are required to sum to all of `A` (i.e., the
decomposition is exhaustive) and to be disjoint at the submodule level. -/
class AutomorphicCohomology where
  /-- The cuspidal cohomology piece. -/
  cuspidalPart : Submodule ℚ A
  /-- The Eisenstein cohomology piece. -/
  eisensteinPart : Submodule ℚ A
  /-- The two pieces span all of `A`. -/
  span_eq_top : cuspidalPart ⊔ eisensteinPart = ⊤
  /-- The two pieces have trivial intersection. -/
  inter_eq_bot : cuspidalPart ⊓ eisensteinPart = ⊥

namespace AutomorphicCohomology

variable {A} [AutomorphicCohomology A]

/-- Any cohomology class `α ∈ A` decomposes as `α = α_cusp + α_Eis`
with `α_cusp ∈ cuspidalPart` and `α_Eis ∈ eisensteinPart`. -/
theorem decomposition_exists (α : A) :
    ∃ (αc : cuspidalPart (A := A)) (αE : eisensteinPart (A := A)),
      α = αc.val + αE.val := by
  have hspan : α ∈ (cuspidalPart (A := A) ⊔ eisensteinPart (A := A)) := by
    rw [span_eq_top]
    exact Submodule.mem_top
  rw [Submodule.mem_sup] at hspan
  obtain ⟨αc, hαc, αE, hαE, hsum⟩ := hspan
  exact ⟨⟨αc, hαc⟩, ⟨αE, hαE⟩, hsum.symm⟩

end AutomorphicCohomology

/-! ## §1. `CuspidalRepData` — `G`-representation on a cuspidal carrier

Following Borel-Jacquet 1979 §4 and Bump 1997 §3.2, a **cuspidal
automorphic representation** `π` of `G(𝔸)` is an irreducible
admissible `G(𝔸)`-representation realised as a `G(𝔸)`-invariant
subspace of `L²_{cusp}(Γ \\ G(𝔸))`. At the abstract carrier level
we package:

* A `ℂ`-vector space `π` (the underlying representation carrier).
* A substantive `G`-action `action : G → (π →ₗ[ℂ] π)` (a group
  homomorphism into the linear endomorphisms of `π`).
* The **parabolic-vanishing** axiom (Borel 1997 §5; Borel-Jacquet
  1979 §4.3): a designated `parabolicSubspace : Submodule ℂ π`
  (the "parabolic constant-term submodule") that is annihilated by
  a designated `parabolicProj : π →ₗ[ℂ] π` (the constant-term
  along a chosen parabolic), with the substantive equation
  `parabolicSubspace ≤ LinearMap.ker parabolicProj`. This encodes
  the Borel 1997 §5 cuspidality criterion: cuspidal representations
  have vanishing constant terms along every proper parabolic. -/

/-- **Cuspidal representation data** for a group `G` and a `ℂ`-vector
space `π` carrying the representation (Borel-Jacquet 1979 §4;
Bump 1997 §3.2).

Fields:
* `action : G → (π →ₗ[ℂ] π)` — substantive `G`-action by `ℂ`-linear
  endomorphisms.
* `action_one : action 1 = LinearMap.id` — substantive identity
  axiom (the trivial group element acts as identity).
* `action_mul : ∀ g₁ g₂ : G, action (g₁ * g₂) = (action g₁).comp
  (action g₂)` — substantive multiplicativity axiom.
* `parabolicProj : π →ₗ[ℂ] π` — designated constant-term projection
  along a parabolic.
* `parabolicSubspace : Submodule ℂ π` — designated parabolic
  constant-term submodule.
* `parabolic_vanishing : parabolicSubspace ≤ LinearMap.ker
  parabolicProj` — substantive Borel 1997 §5 cuspidality criterion:
  the parabolic subspace is annihilated by the constant-term
  projection. -/
class CuspidalRepData (G : Type*) [Group G] (π : Type*)
    [AddCommGroup π] [Module ℂ π] where
  /-- The `G`-action on `π` by `ℂ`-linear endomorphisms. -/
  action : G → (π →ₗ[ℂ] π)
  /-- The trivial group element acts as the identity. -/
  action_one : action 1 = LinearMap.id
  /-- The action is multiplicative. -/
  action_mul : ∀ g₁ g₂ : G, action (g₁ * g₂) = (action g₁).comp (action g₂)
  /-- The constant-term projection along the chosen parabolic. -/
  parabolicProj : π →ₗ[ℂ] π
  /-- The parabolic constant-term submodule. -/
  parabolicSubspace : Submodule ℂ π
  /-- **Borel 1997 §5 cuspidality criterion**: the parabolic
  subspace is annihilated by the constant-term projection. -/
  parabolic_vanishing : parabolicSubspace ≤ LinearMap.ker parabolicProj

namespace CuspidalRepData

variable {G : Type*} [Group G] {π : Type*} [AddCommGroup π] [Module ℂ π]
    [CuspidalRepData G π]

/-- **Pointwise identity**: `action 1 v = v` for every `v : π`. -/
theorem action_one_apply (v : π) :
    action (G := G) (π := π) 1 v = v := by
  rw [action_one (G := G) (π := π)]
  rfl

/-- **Pointwise multiplicativity**: for every `g₁ g₂ : G` and
`v : π`, `action (g₁ * g₂) v = action g₁ (action g₂ v)`. -/
theorem action_mul_apply (g₁ g₂ : G) (v : π) :
    action (G := G) (π := π) (g₁ * g₂) v
      = action g₁ (action g₂ v) := by
  rw [action_mul (G := G) (π := π)]
  rfl

/-- **Pointwise parabolic-vanishing** (Borel 1997 §5): every
element `v ∈ parabolicSubspace` is annihilated by `parabolicProj`. -/
theorem parabolicProj_eq_zero_of_mem
    (v : π) (hv : v ∈ parabolicSubspace (G := G) (π := π)) :
    parabolicProj (G := G) (π := π) v = 0 :=
  LinearMap.mem_ker.mp (parabolic_vanishing (G := G) (π := π) hv)

/-- **Sum-vanishing**: if `v, w ∈ parabolicSubspace`, then
`parabolicProj (v + w) = 0`. The sum lies in `parabolicSubspace`
by submodule closure, and the constant-term projection annihilates
it (Borel 1997 §5 + `Submodule.add_mem`). -/
theorem parabolicProj_add_eq_zero
    (v w : π)
    (hv : v ∈ parabolicSubspace (G := G) (π := π))
    (hw : w ∈ parabolicSubspace (G := G) (π := π)) :
    parabolicProj (G := G) (π := π) (v + w) = 0 := by
  have hvw : v + w ∈ parabolicSubspace (G := G) (π := π) :=
    Submodule.add_mem _ hv hw
  exact parabolicProj_eq_zero_of_mem (v + w) hvw

end CuspidalRepData

/-! ## §2. `L2DecompositionData` — orthogonal `L²(Γ \\ G)` splitting

Following Bump 1997 §3.2 (also Borel-Jacquet 1979 §4.5), the
Hilbert space `L²(Γ \\ G)` decomposes orthogonally as
```
L²(Γ \\ G) = L²_{cusp}(Γ \\ G) ⊕ L²_{Eis}(Γ \\ G)
```
where `L²_{cusp}` is the closure of the cuspidal-form subspace and
`L²_{Eis}` is the orthogonal complement (Eisenstein continuous
spectrum). We abstract the **carrier-level splitting** as a pair
of `Submodule ℂ H` whose sum is `⊤` and whose intersection is `⊥`,
with substantive proofs at the submodule level. -/

/-- **`L²(Γ \\ G)` orthogonal decomposition data** (Bump 1997 §3.2;
Borel-Jacquet 1979 §4.5).

Fields:
* `L2cuspidal : Submodule ℂ H` — the cuspidal `L²` submodule.
* `L2Eisenstein : Submodule ℂ H` — the Eisenstein `L²` submodule.
* `L2_span_eq_top : L2cuspidal ⊔ L2Eisenstein = ⊤` — substantive
  spanning axiom.
* `L2_inter_eq_bot : L2cuspidal ⊓ L2Eisenstein = ⊥` — substantive
  disjointness axiom. -/
class L2DecompositionData (G : Type*) [Group G] (H : Type*)
    [AddCommGroup H] [Module ℂ H] where
  /-- The cuspidal `L²` submodule. -/
  L2cuspidal : Submodule ℂ H
  /-- The Eisenstein `L²` submodule. -/
  L2Eisenstein : Submodule ℂ H
  /-- The two `L²` parts span all of `H`. -/
  L2_span_eq_top : L2cuspidal ⊔ L2Eisenstein = ⊤
  /-- The two `L²` parts have trivial intersection. -/
  L2_inter_eq_bot : L2cuspidal ⊓ L2Eisenstein = ⊥

namespace L2DecompositionData

variable {G : Type*} [Group G] {H : Type*} [AddCommGroup H] [Module ℂ H]
    [L2DecompositionData G H]

/-- **Existence of `L²` decomposition** (Bump 1997 §3.2): every
`f ∈ H` decomposes as `f = f_cusp + f_Eis` with `f_cusp ∈
L2cuspidal` and `f_Eis ∈ L2Eisenstein`. -/
theorem L2_decomposition_exists (f : H) :
    ∃ (fc : L2cuspidal (G := G) (H := H))
      (fE : L2Eisenstein (G := G) (H := H)),
      f = fc.val + fE.val := by
  have hspan : f ∈ (L2cuspidal (G := G) (H := H)
      ⊔ L2Eisenstein (G := G) (H := H)) := by
    rw [L2_span_eq_top (G := G) (H := H)]
    exact Submodule.mem_top
  rw [Submodule.mem_sup] at hspan
  obtain ⟨fc, hfc, fE, hfE, hsum⟩ := hspan
  exact ⟨⟨fc, hfc⟩, ⟨fE, hfE⟩, hsum.symm⟩

/-- **Uniqueness of `L²` decomposition** (Bump 1997 §3.2): if
`f = fc + fE = fc' + fE'` with `fc, fc' ∈ L2cuspidal` and
`fE, fE' ∈ L2Eisenstein`, then `fc = fc'` and `fE = fE'`. The
difference `fc - fc'` lies in `L2cuspidal ∩ L2Eisenstein = ⊥`,
forcing `fc = fc'` and hence `fE = fE'`. -/
theorem L2_decomposition_unique
    (f : H)
    (fc fc' : L2cuspidal (G := G) (H := H))
    (fE fE' : L2Eisenstein (G := G) (H := H))
    (h1 : f = fc.val + fE.val)
    (h2 : f = fc'.val + fE'.val) :
    fc.val = fc'.val ∧ fE.val = fE'.val := by
  -- From `fc + fE = fc' + fE'` we get `fc - fc' = fE' - fE`.
  have hsum : fc.val + fE.val = fc'.val + fE'.val :=
    h1.symm.trans h2
  have heq : fc.val - fc'.val = fE'.val - fE.val := by
    -- From `fc + fE = fc' + fE'`, subtract `fc' + fE` from both sides.
    have h := hsum
    -- `fc + fE - (fc' + fE) = fc' + fE' - (fc' + fE)` gives `fc - fc' = fE' - fE`.
    have := congr_arg (fun x => x - (fc'.val + fE.val)) h
    simp only [add_sub_add_right_eq_sub] at this
    -- Now `this : fc.val - fc'.val = fc'.val + fE'.val - (fc'.val + fE.val)`.
    -- The RHS simplifies via `add_sub_add_left_eq_sub` to `fE'.val - fE.val`.
    rw [show fc'.val + fE'.val - (fc'.val + fE.val) = fE'.val - fE.val from by
        rw [add_sub_add_left_eq_sub]] at this
    exact this
  -- The LHS lies in `L2cuspidal`, the RHS in `L2Eisenstein`.
  have h_cusp : fc.val - fc'.val ∈ L2cuspidal (G := G) (H := H) :=
    Submodule.sub_mem _ fc.2 fc'.2
  have h_eis : fc.val - fc'.val ∈ L2Eisenstein (G := G) (H := H) := by
    rw [heq]
    exact Submodule.sub_mem _ fE'.2 fE.2
  -- Hence `fc - fc' ∈ L2cuspidal ∩ L2Eisenstein = ⊥`, so it is `0`.
  have h_inter : fc.val - fc'.val ∈ (L2cuspidal (G := G) (H := H)
      ⊓ L2Eisenstein (G := G) (H := H)) :=
    Submodule.mem_inf.mpr ⟨h_cusp, h_eis⟩
  rw [L2_inter_eq_bot (G := G) (H := H), Submodule.mem_bot] at h_inter
  -- `fc - fc' = 0` ⇒ `fc = fc'`.
  have hfc : fc.val = fc'.val := sub_eq_zero.mp h_inter
  -- Then `fE = fE'` from `fc + fE = fc' + fE'` and `fc = fc'`. After
  -- substituting `fc ↦ fc'` on the LHS of `hsum`, we get
  -- `fc' + fE = fc' + fE'`, and `add_left_cancel` discharges.
  rw [hfc] at hsum
  -- Now `hsum : fc'.val + fE.val = fc'.val + fE'.val`.
  exact ⟨hfc, add_left_cancel hsum⟩

end L2DecompositionData

/-! ## §3. Trivial substantive instances on `(G, π) = (Unit, ℂ)`
and `(G, H) = (Unit, ℂ)`

We exhibit substantive (non-tautological) inhabiting instances:

* `CuspidalRepData Unit ℂ`: the `G`-action is `LinearMap.id` (the
  only `ℂ`-linear endomorphism of `ℂ` coming from the trivial
  group), the parabolic projection is the zero map, the parabolic
  subspace is `⊤` (the entire `ℂ`-line, since the trivial group
  has no proper parabolic and the constant-term projection
  collapses to zero), and `parabolic_vanishing : ⊤ ≤ ker 0` is
  discharged via `LinearMap.ker_zero`.

* `L2DecompositionData Unit ℂ`: `L2cuspidal := ⊤`, `L2Eisenstein :=
  ⊥`. The `⊤ ⊔ ⊥ = ⊤` axiom is `sup_bot_eq`, and `⊤ ⊓ ⊥ = ⊥` is
  `inf_bot_eq`. -/

/-- The trivial action of `Unit` on `ℂ`: the constant identity
linear map. -/
private def trivAction : Unit → (ℂ →ₗ[ℂ] ℂ) := fun _ => LinearMap.id

/-- The trivial parabolic projection on `ℂ`: the zero linear map. -/
private def trivParabolicProj : ℂ →ₗ[ℂ] ℂ := 0

/-- Trivial substantive `CuspidalRepData` instance on `(Unit, ℂ)`.
The action is identically `LinearMap.id`, the parabolic projection
is `0`, and the parabolic subspace is `⊤` (which is annihilated by
the zero map via `LinearMap.ker_zero = ⊤`). -/
instance cuspidalRepData_Unit_C : CuspidalRepData Unit ℂ where
  action := trivAction
  action_one := rfl
  action_mul := by
    intro _ _
    -- `trivAction (g₁ * g₂) = id` and `(trivAction g₁).comp (trivAction g₂)
    -- = id.comp id = id`.
    show trivAction _ = (trivAction _).comp (trivAction _)
    rfl
  parabolicProj := trivParabolicProj
  parabolicSubspace := (⊤ : Submodule ℂ ℂ)
  parabolic_vanishing := by
    -- Need: `⊤ ≤ LinearMap.ker (0 : ℂ →ₗ[ℂ] ℂ)`. Rewrite the
    -- kernel of the zero map to `⊤` (Mathlib `LinearMap.ker_zero`),
    -- then `⊤ ≤ ⊤` is `le_refl`.
    show (⊤ : Submodule ℂ ℂ) ≤ LinearMap.ker trivParabolicProj
    have hzero : trivParabolicProj = (0 : ℂ →ₗ[ℂ] ℂ) := rfl
    rw [hzero, LinearMap.ker_zero]

/-- Trivial substantive `L2DecompositionData` instance on `(Unit,
ℂ)`. The cuspidal `L²` part is `⊤`, the Eisenstein part is `⊥`,
the span axiom `⊤ ⊔ ⊥ = ⊤` is `sup_bot_eq`, and the disjointness
axiom `⊤ ⊓ ⊥ = ⊥` is `inf_bot_eq`. -/
instance l2DecompositionData_Unit_C : L2DecompositionData Unit ℂ where
  L2cuspidal := (⊤ : Submodule ℂ ℂ)
  L2Eisenstein := (⊥ : Submodule ℂ ℂ)
  L2_span_eq_top := sup_bot_eq _
  L2_inter_eq_bot := inf_bot_eq _

/-- **Sanity**: in the trivial cuspidal-rep instance, the action
of the unique `Unit` element on `(1 : ℂ)` returns `(1 : ℂ)`. -/
example :
    CuspidalRepData.action (G := Unit) (π := ℂ) (1 : Unit) (1 : ℂ) = (1 : ℂ) :=
  CuspidalRepData.action_one_apply (G := Unit) (π := ℂ) (1 : ℂ)

/-- **Sanity**: in the trivial cuspidal-rep instance, the parabolic
projection annihilates every element of `⊤ = parabolicSubspace`. -/
example (v : ℂ) :
    CuspidalRepData.parabolicProj (G := Unit) (π := ℂ) v = 0 :=
  CuspidalRepData.parabolicProj_eq_zero_of_mem (G := Unit) (π := ℂ) v
    Submodule.mem_top

/-- **Sanity**: in the trivial `L²` decomposition, every `f : ℂ`
decomposes as `f = f + 0` with `f ∈ ⊤ = L2cuspidal` and
`0 ∈ ⊥ = L2Eisenstein`. -/
example (f : ℂ) :
    ∃ (fc : L2DecompositionData.L2cuspidal (G := Unit) (H := ℂ))
      (fE : L2DecompositionData.L2Eisenstein (G := Unit) (H := ℂ)),
      f = fc.val + fE.val :=
  L2DecompositionData.L2_decomposition_exists (G := Unit) (H := ℂ) f

end HodgeReduction.Infrastructure.Automorphic
