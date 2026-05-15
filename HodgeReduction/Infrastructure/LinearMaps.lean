/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56Freudenthal
import HodgeReduction.Infrastructure.V56Basis
import HodgeReduction.Infrastructure.J3OInnerProduct
import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.LinearAlgebra.Dual
import Mathlib.LinearAlgebra.Dimension.DivisionRing

/-!
# Linear / bilinear interfaces for `J₃(𝕆)` and `V₅₆`

This file packages the existing trace / inner-product / symplectic-form
operations as Mathlib `LinearMap` / `LinearMap.BilinForm` so they can be
used with the standard linear-algebra machinery (e.g. matrix
representations, dual spaces, kernel/range, etc.).

## Main definitions

* `J3O.traceLinear : J3O →ₗ[ℚ] ℚ` — trace as a `ℚ`-linear functional.
* `J3O.innerProdBilin : J3O →ₗ[ℚ] J3O →ₗ[ℚ] ℚ` — `⟨·,·⟩` as bilinear form.
* `V56.omegaBilin : V56 →ₗ[ℚ] V56 →ₗ[ℚ] ℚ` — symplectic form `ω` as
  antisymmetric bilinear form.

## Tags

LinearMap, BilinForm, trace, inner product, symplectic form, V_56, J_3(O)
-/

namespace HodgeReduction.Infrastructure

namespace J3O

/-- The trace `tr : J₃(𝕆) → ℚ` as a Mathlib `ℚ`-linear functional. -/
def traceLinear : J3O →ₗ[ℚ] ℚ where
  toFun := trace
  map_add' := trace_add
  map_smul' r X := trace_smul r X

@[simp] theorem traceLinear_apply (X : J3O) : traceLinear X = trace X := rfl

/-- The inner product `⟨·, ·⟩ : J₃(𝕆) × J₃(𝕆) → ℚ` as a Mathlib bilinear map. -/
def innerProdBilin : J3O →ₗ[ℚ] J3O →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ innerProd
    (fun X Y Z => innerProd_add_left X Y Z)
    (fun r X Y => innerProd_smul_left r X Y)
    (fun X Y Z => innerProd_add_right X Y Z)
    (fun r X Y => innerProd_smul_right r X Y)

@[simp] theorem innerProdBilin_apply (X Y : J3O) :
    innerProdBilin X Y = innerProd X Y := rfl

end J3O

namespace V56

/-- The symplectic form `ω : V₅₆ × V₅₆ → ℚ` as a Mathlib bilinear map.
This is the second `E₇`-invariant (after the quartic `q`). -/
def omegaBilin : V56 →ₗ[ℚ] V56 →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ omega
    (fun v v' w => omega_add_left v v' w)
    (fun r v w => omega_smul_left r v w)
    (fun v w w' => omega_add_right v w w')
    (fun r v w => omega_smul_right r v w)

@[simp] theorem omegaBilin_apply (v w : V56) :
    omegaBilin v w = omega v w := rfl

/-- The symplectic form `ω` is antisymmetric:
`omegaBilin v w = -omegaBilin w v`. -/
theorem omegaBilin_antisymm (v w : V56) :
    omegaBilin v w = -omegaBilin w v := by
  show omega v w = -omega w v
  exact omega_antisymm v w

/-- The symplectic form `ω` is **non-degenerate**: if `ω(v, w) = 0` for all `w`,
then `v = 0`. This realises `V₅₆` as a 56-dim symplectic `ℚ`-vector space,
matching the inclusion `E₇ ⊂ Sp(56, ℚ)`.

The proof tests `v` against the four Hodge-piece projectors:
* `ω(v, (0, 0, 0, 1)) = v.a ⇒ v.a = 0`;
* `ω(v, (1, 0, 0, 0)) = -v.b ⇒ v.b = 0`;
* `ω(v, (0, A', 0, 0)) = -⟨v.B, A'⟩` for all `A'`, with positive-definite
  `⟨·, ·⟩` ⇒ `v.B = 0`;
* `ω(v, (0, 0, B', 0)) = ⟨v.A, B'⟩` ⇒ `v.A = 0`. -/
theorem omega_nondegenerate (v : V56) (hv : ∀ w : V56, omega v w = 0) :
    v = 0 := by
  -- Test against (0, 0, 0, 1): omega v (0,0,0,1) = v.a.
  have ha : v.a = 0 := by
    have h := hv ⟨0, 0, 0, 1⟩
    unfold omega at h
    show v.a = 0
    rw [show ((⟨0, 0, 0, 1⟩ : V56).a : ℚ) = 0 from rfl,
        show ((⟨0, 0, 0, 1⟩ : V56).b : ℚ) = 1 from rfl,
        show ((⟨0, 0, 0, 1⟩ : V56).A : J3O) = 0 from rfl,
        show ((⟨0, 0, 0, 1⟩ : V56).B : J3O) = 0 from rfl,
        J3O.innerProd_zero_right, J3O.innerProd_zero_right] at h
    linarith
  -- Test against (1, 0, 0, 0): omega v (1,0,0,0) = -v.b.
  have hb : v.b = 0 := by
    have h := hv ⟨1, 0, 0, 0⟩
    unfold omega at h
    show v.b = 0
    rw [show ((⟨1, 0, 0, 0⟩ : V56).a : ℚ) = 1 from rfl,
        show ((⟨1, 0, 0, 0⟩ : V56).b : ℚ) = 0 from rfl,
        show ((⟨1, 0, 0, 0⟩ : V56).A : J3O) = 0 from rfl,
        show ((⟨1, 0, 0, 0⟩ : V56).B : J3O) = 0 from rfl,
        J3O.innerProd_zero_right, J3O.innerProd_zero_right] at h
    linarith
  -- Test against (0, 0, v.A, 0): omega v (0, 0, v.A, 0) = innerProd v.A v.A.
  have hA : v.A = 0 := by
    have h := hv ⟨0, 0, v.A, 0⟩
    unfold omega at h
    -- h : v.a * 0 - v.b * 0 + <v.A, v.A> - <v.B, 0> = 0
    show v.A = 0
    rw [show ((⟨0, 0, v.A, 0⟩ : V56).a : ℚ) = 0 from rfl,
        show ((⟨0, 0, v.A, 0⟩ : V56).b : ℚ) = 0 from rfl,
        show ((⟨0, 0, v.A, 0⟩ : V56).A : J3O) = 0 from rfl,
        show ((⟨0, 0, v.A, 0⟩ : V56).B : J3O) = v.A from rfl,
        J3O.innerProd_zero_right] at h
    have key : J3O.innerProd v.A v.A = 0 := by linarith
    exact (J3O.innerProd_self_eq_zero_iff v.A).mp key
  -- Test against (0, v.B, 0, 0): omega v (0, v.B, 0, 0) = -innerProd v.B v.B.
  have hB : v.B = 0 := by
    have h := hv ⟨0, v.B, 0, 0⟩
    unfold omega at h
    show v.B = 0
    rw [show ((⟨0, v.B, 0, 0⟩ : V56).a : ℚ) = 0 from rfl,
        show ((⟨0, v.B, 0, 0⟩ : V56).b : ℚ) = 0 from rfl,
        show ((⟨0, v.B, 0, 0⟩ : V56).A : J3O) = v.B from rfl,
        show ((⟨0, v.B, 0, 0⟩ : V56).B : J3O) = 0 from rfl,
        J3O.innerProd_zero_right] at h
    have key : J3O.innerProd v.B v.B = 0 := by linarith
    exact (J3O.innerProd_self_eq_zero_iff v.B).mp key
  refine V56.ext ?_ ?_ ?_ ?_
  · exact ha
  · exact hA
  · exact hB
  · exact hb

/-! ### Lagrangian polarization `V_{≥0} ⊕ V_{<0}`

Split `V₅₆` into "positive" `V_{≥0} = V^{3,0} ⊕ V^{2,1}` (charges `+3, +1`)
and "negative" `V_{<0} = V^{1,2} ⊕ V^{0,3}` (charges `-1, -3`). Each
piece is **Lagrangian** under `ω`: `ω` vanishes when both arguments are
in the same half-piece. This is the standard symplectic polarization
coming from the Hodge decomposition.
-/

/-- The "positive" half `V^{3,0} ⊕ V^{2,1}` is **isotropic** under `ω`:
for `v, w` both with `v.B = w.B = 0` and `v.b = w.b = 0`, `ω(v, w) = 0`. -/
theorem omega_eq_zero_on_pos_half (v w : V56)
    (hv : v.B = 0 ∧ v.b = 0) (hw : w.B = 0 ∧ w.b = 0) :
    omega v w = 0 := by
  obtain ⟨hvB, hvb⟩ := hv
  obtain ⟨hwB, hwb⟩ := hw
  unfold omega
  rw [hvB, hvb, hwB, hwb, J3O.innerProd_zero_right, J3O.innerProd_zero_left]
  ring

/-- The "negative" half `V^{1,2} ⊕ V^{0,3}` is **isotropic** under `ω`:
for `v, w` both with `v.a = w.a = 0` and `v.A = w.A = 0`, `ω(v, w) = 0`. -/
theorem omega_eq_zero_on_neg_half (v w : V56)
    (hv : v.a = 0 ∧ v.A = 0) (hw : w.a = 0 ∧ w.A = 0) :
    omega v w = 0 := by
  obtain ⟨hva, hvA⟩ := hv
  obtain ⟨hwa, hwA⟩ := hw
  unfold omega
  rw [hva, hvA, hwa, hwA, J3O.innerProd_zero_right, J3O.innerProd_zero_left]
  ring

/-! ### Discrete symmetry `(a, A, B, b) ↔ (b, B, A, a)`

The Freudenthal quartic is invariant under the swap involution exchanging
charge `+3 ↔ -3` and charge `+1 ↔ -1`. This is the Cartan involution
realising `E_7` from its compact dual `EVII`.
-/

/-- The **swap involution** `σ : V₅₆ → V₅₆` exchanging `+3 ↔ -3` and
`+1 ↔ -1` pieces. -/
def swap : V56 →ₗ[ℚ] V56 where
  toFun v := ⟨v.b, v.B, v.A, v.a⟩
  map_add' _ _ := by refine V56.ext ?_ ?_ ?_ ?_ <;> rfl
  map_smul' _ _ := by refine V56.ext ?_ ?_ ?_ ?_ <;> rfl

@[simp] theorem swap_swap (v : V56) : swap (swap v) = v := by
  refine V56.ext ?_ ?_ ?_ ?_ <;> rfl

/-- `q` is **invariant under `swap`**: `q(σ v) = q(v)`. This is the
involutive symmetry of the Freudenthal triple system. -/
theorem freudenthalQuartic_swap (v : V56) :
    freudenthalQuartic (swap v) = freudenthalQuartic v := by
  unfold freudenthalQuartic swap
  show (v.b * v.a - J3O.innerProd v.B v.A)^2
       + 4 * (v.b * J3O.cubicNorm v.A + v.a * J3O.cubicNorm v.B
              - J3O.innerProd (J3O.sharp v.B) (J3O.sharp v.A)) = _
  rw [J3O.innerProd_symm v.B v.A, J3O.innerProd_symm (J3O.sharp v.B)]
  ring

/-- `ω` is **anti-invariant under `swap`**: `ω(σ v, σ w) = -ω(v, w)`. -/
theorem omega_swap (v w : V56) :
    omega (swap v) (swap w) = -omega v w := by
  unfold omega swap
  show v.b * w.a - v.a * w.b + J3O.innerProd v.B w.A - J3O.innerProd v.A w.B
       = -(v.a * w.b - v.b * w.a + J3O.innerProd v.A w.B - J3O.innerProd v.B w.A)
  ring

/-! ### The contraction `ω(v, ·) : V_56 → ℚ`

Non-degeneracy of `ω` gives an injective `ℚ`-linear map
`v ↦ ω(v, ·) : V_56 → V_56*`. By dimension count (56 = 56), this is in
fact a linear isomorphism `V_56 ≃ V_56^*`.
-/

/-- Contraction of `ω` with a fixed first argument: `v ↦ ω(v, ·)`. -/
def omegaContract : V56 →ₗ[ℚ] (V56 →ₗ[ℚ] ℚ) := omegaBilin

@[simp] theorem omegaContract_apply (v w : V56) :
    omegaContract v w = omega v w := rfl

/-- The contraction `v ↦ ω(v, ·)` is **injective**: if `ω(v, ·) = 0` as a
linear functional, then `v = 0`. This is just `omega_nondegenerate`
re-packaged at the LinearMap level. -/
theorem omegaContract_injective :
    Function.Injective (omegaContract : V56 → (V56 →ₗ[ℚ] ℚ)) := by
  intro v w hvw
  -- `ω(v, ·) = ω(w, ·)` implies `ω(v - w, ·) = 0`, hence `v - w = 0` by
  -- non-degeneracy.
  have h : ∀ x, omega (v - w) x = 0 := by
    intro x
    rw [show v - w = v + -w from sub_eq_add_neg v w, omega_add_left, omega_neg_left]
    have h1 : omega v x = omega w x := by
      have := congrArg (fun (f : V56 →ₗ[ℚ] ℚ) => f x) hvw
      exact this
    linarith
  have hvw' : v - w = 0 := omega_nondegenerate (v - w) h
  exact sub_eq_zero.mp hvw'

/-- The symplectic-form contraction is a **linear equivalence**
`V_56 ≃ₗ[ℚ] V_56*`. From injectivity + dim equality + finite-dim, the
omega-contraction is automatically surjective, giving a canonical
identification of `V_56` with its `ℚ`-linear dual.

Built via `LinearEquiv.ofBijective`: injectivity is `omegaContract_injective`;
surjectivity follows from injectivity + dim equality (both sides are
56-dim by `Module.finrank_dual_eq_finrank`). -/
noncomputable def omegaContractEquiv : V56 ≃ₗ[ℚ] Module.Dual ℚ V56 :=
  LinearEquiv.ofBijective omegaContract
    ⟨omegaContract_injective,
     LinearMap.injective_iff_surjective_of_finrank_eq_finrank
       (Subspace.dual_finrank_eq.symm) |>.mp omegaContract_injective⟩

/-! ### `q` vanishes on the Hodge polarization halves `V_±`

For any `v ∈ V_+` (positive Hodge half: `v.B = v.b = 0`) or `v ∈ V_-`
(negative: `v.a = v.A = 0`), the Freudenthal quartic `q(v) = 0`.

Geometrically: the closed `E_7`-orbit `Ě_VII = {[v] | q(v) = 0} ⊂ ℙ(V_56)`
contains both projective Lagrangians `ℙ(V_+)` and `ℙ(V_-)`.

This is the structural reason `Ě_VII` (the rank-`≤ 1` locus) has 28-dim
families of points (one for each Lagrangian half), with the actual
rank-1 stratum being a much smaller 27-dim subvariety.
-/

/-- The Freudenthal quartic **vanishes on the positive Hodge half**:
for any `(a, A, 0, 0) ∈ V₅₆`, `q(a, A, 0, 0) = 0`. -/
theorem freudenthalQuartic_vanishes_on_pos_half (v : V56)
    (hB : v.B = 0) (hb : v.b = 0) :
    freudenthalQuartic v = 0 := by
  unfold freudenthalQuartic
  rw [hB, hb, J3O.innerProd_zero_right, J3O.cubicNorm_zero,
      J3O.sharp_zero, J3O.innerProd_zero_right]
  ring

/-- The Freudenthal quartic **vanishes on the negative Hodge half**:
for any `(0, 0, B, b) ∈ V₅₆`, `q(0, 0, B, b) = 0`. -/
theorem freudenthalQuartic_vanishes_on_neg_half (v : V56)
    (ha : v.a = 0) (hA : v.A = 0) :
    freudenthalQuartic v = 0 := by
  unfold freudenthalQuartic
  rw [ha, hA, J3O.innerProd_zero_left, J3O.cubicNorm_zero,
      J3O.sharp_zero, J3O.innerProd_zero_left]
  ring

end V56

end HodgeReduction.Infrastructure
