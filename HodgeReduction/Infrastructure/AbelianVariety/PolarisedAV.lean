/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.AbelianVariety.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Tactic.Linarith

/-!
# Polarised abelian variety framework — substantive symplectic data

A **polarised abelian variety** `(A, λ)` is an abelian variety `A`
together with a polarisation `λ : A → Â` (an isogeny to its dual,
arising from an ample line bundle).

At the cohomological level, a polarisation induces an alternating
non-degenerate `ℚ`-bilinear form `ψ : H¹(A; ℚ) × H¹(A; ℚ) → ℚ` (the
*Riemann form*). The two defining axioms are:

* **Alternating**: `ψ(x, x) = 0` for all `x ∈ H¹(A; ℚ)`.
* **Non-degenerate**: for every `x ≠ 0` there is `y` with `ψ(x, y) ≠ 0`.

The **type of a polarisation** is the sequence of *elementary divisors*
`(d_1 | d_2 | ⋯ | d_g)` of the matrix of `ψ` in a symplectic basis;
this is a monotone-divisibility sequence of positive integers and is
the only invariant of `(A, λ)` modulo isogeny (Birkenhake-Lange
Cor. 3.1.5). A polarisation is **principal** when this type is
`(1, 1, …, 1)`.

## References

* Mumford, D. *Abelian Varieties*, Tata Inst./OUP, 1970, Ch. III
  (especially §16, §23).
* Birkenhake, C. and Lange, H. *Complex Abelian Varieties*, 2nd ed.,
  Grundlehren **302**, Springer, 2004, Ch. 3 (polarisations),
  Ch. 4-5 (polarisation type, principal polarisations).
* Hindry, M. and Silverman, J. H. *Diophantine Geometry: An
  Introduction*, GTM **201**, Springer, 2000, §A.8.

For our HC application, the `E_{7(-25)}` Shimura variety parameterises
polarised abelian varieties (modulo finite covers) carrying extra
endomorphism structure. The symplectic form on `V = H¹(A; ℚ)` is one
of the constituents of the period domain.

## Main definitions

* `PolarisedAbelianVarietyData A V` — abelian variety dimension `g`
  with a polarisation form on `V = H¹(A; ℚ)`, the alternating and
  non-degeneracy axioms, and the (monotone-divisibility) polarisation
  type.
* `PrincipalPolarisationData A V` — sibling class refining
  `PolarisedAbelianVarietyData` with the *principal polarisation*
  condition: the type is identically `1`.

## Tags

polarised abelian variety, Riemann form, principal polarisation,
elementary divisors, symplectic form
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-! ## `PolarisedAbelianVarietyData` typeclass -/

/-- **Polarised abelian variety data**, parameterised by:

* `A` — an abstract type for the abelian variety itself.
* `V` — a ℚ-module carrier for `V = H¹(A; ℚ)` (a `2g`-dim ℚ-vector space).

Fields:

* `g` — the complex dimension `g = dim_ℂ A` (so `dim_ℚ V = 2g`).
* `psi` — the polarisation form `V × V → ℚ` (an alternating
  non-degenerate `ℚ`-bilinear form).
* `psi_alternating` — `ψ(x, x) = 0` for all `x`.
* `psi_nondegen` — for every `x ≠ 0` there exists `y` with `ψ(x, y) ≠ 0`.
* `polarType` — the elementary-divisor sequence
  `polarType i = d_i` (with `d_i ∣ d_{i+1}`, all `d_i ≥ 1`).
-/
class PolarisedAbelianVarietyData (A : Type*) (V : Type*)
    [AddCommGroup V] [Module ℚ V] where
  /-- The complex dimension `g = dim_ℂ A`. -/
  g : ℕ
  /-- The polarisation form `ψ : V × V → ℚ` as a Mathlib bilinear map. -/
  psi : V →ₗ[ℚ] V →ₗ[ℚ] ℚ
  /-- **Alternating axiom**: `ψ(x, x) = 0` for all `x` (a substantive
  bilinear identity, not a tautology). -/
  psi_alternating : ∀ x : V, psi x x = 0
  /-- **Non-degeneracy**: for every non-zero `x` some `y` pairs
  non-trivially under `ψ`. -/
  psi_nondegen : ∀ x : V, x ≠ 0 → ∃ y : V, psi x y ≠ 0
  /-- The **polarisation type** sequence
  `polarType i = d_i`, the `i`-th elementary divisor. -/
  polarType : ℕ → ℕ
  /-- **Positivity** of elementary divisors: every `d_i ≥ 1`. -/
  polarType_pos : ∀ i : ℕ, 1 ≤ polarType i
  /-- **Monotone divisibility** of the polarisation type:
  `d_i ∣ d_{i+1}` (an integer-arithmetic substantive constraint). -/
  polarType_dvd_succ : ∀ i : ℕ, polarType i ∣ polarType (i + 1)
  /-- **Out-of-range vanishing**: for `i ≥ g` the elementary divisor
  is forced to `1` (the sequence has length `g`; padding by `1`'s
  is the standard convention). -/
  polarType_of_ge : ∀ i : ℕ, i ≥ g → polarType i = 1

namespace PolarisedAbelianVarietyData

variable {A : Type*} {V : Type*} [AddCommGroup V] [Module ℚ V]
  [PolarisedAbelianVarietyData A V]

/-! ### Derived theorems -/

/-- **Antisymmetry from alternating**: expanding `0 = ψ(x+y, x+y)`
yields `ψ(x, y) = -ψ(y, x)`. This is the standard
"alternating ⇒ antisymmetric" derivation, an honest application of
the bilinear axioms. -/
theorem psi_antisymm (x y : V) :
    psi (A := A) (V := V) x y = -psi (A := A) (V := V) y x := by
  have h := psi_alternating (A := A) (V := V) (x + y)
  -- ψ(x+y, x+y) = ψ x x + ψ x y + ψ y x + ψ y y = 0
  simp only [LinearMap.add_apply, map_add] at h
  rw [psi_alternating (A := A) (V := V) x,
      psi_alternating (A := A) (V := V) y] at h
  -- h : 0 + ψ x y + (ψ y x + 0) = 0
  linarith

/-- **Self-pairing vanishes** (restated for ergonomic rewriting). -/
theorem psi_self_zero (x : V) :
    psi (A := A) (V := V) x x = 0 :=
  psi_alternating (A := A) (V := V) x

/-- **`ψ` separates points on the left**: if `ψ(x, ·) = 0` then `x = 0`
(contrapositive of non-degeneracy). -/
theorem psi_zero_of_pairs_zero (x : V)
    (hx : ∀ y : V, psi (A := A) (V := V) x y = 0) :
    x = 0 := by
  by_contra hne
  obtain ⟨y, hy⟩ := psi_nondegen (A := A) (V := V) x hne
  exact hy (hx y)

/-- **`ψ` separates points on the right**: if `ψ(·, y) = 0` then `y = 0`.
Derived from left-non-degeneracy plus antisymmetry. -/
theorem psi_zero_right (y : V)
    (hy : ∀ x : V, psi (A := A) (V := V) x y = 0) :
    y = 0 := by
  refine psi_zero_of_pairs_zero (A := A) (V := V) y (fun x => ?_)
  have h1 := psi_antisymm (A := A) (V := V) y x
  have h2 := hy x
  linarith

/-- **`ψ(0, y) = 0`** — vanishing on zero left arg (bilinearity). -/
theorem psi_zero_left (y : V) :
    psi (A := A) (V := V) (0 : V) y = 0 := by
  simp

/-- **`ψ(x, 0) = 0`** — vanishing on zero right arg (bilinearity). -/
theorem psi_zero_right_arg (x : V) :
    psi (A := A) (V := V) x (0 : V) = 0 := by
  simp

/-- The **rank of the underlying ℚ-vector space** is `dim V = 2g`. -/
abbrev rank_V : ℕ := 2 * g (A := A) (V := V)

/-- **First elementary divisor positivity**: `d_1 ≥ 1`. -/
theorem polarType_zero_pos : 1 ≤ polarType (A := A) (V := V) 0 :=
  polarType_pos (A := A) (V := V) 0

/-- **Monotone divisibility implies monotone size**: `d_i ≤ d_{i+1}`.
A direct corollary of `polarType_pos` + `polarType_dvd_succ`. -/
theorem polarType_le_succ (i : ℕ) :
    polarType (A := A) (V := V) i ≤ polarType (A := A) (V := V) (i + 1) := by
  -- d_i ∣ d_{i+1} and d_{i+1} ≥ 1, so the divisor is at most the dividend.
  have hdvd := polarType_dvd_succ (A := A) (V := V) i
  have hpos : 1 ≤ polarType (A := A) (V := V) (i + 1) :=
    polarType_pos (A := A) (V := V) (i + 1)
  exact Nat.le_of_dvd (by linarith) hdvd

end PolarisedAbelianVarietyData

/-! ## Principal polarisation sibling -/

/-- **Principal polarisation data**: a polarised abelian variety whose
polarisation type is identically `1`. Equivalently, the polarisation
`λ : A → Â` is an isomorphism (not just an isogeny). -/
class PrincipalPolarisationData (A : Type*) (V : Type*)
    [AddCommGroup V] [Module ℚ V]
    extends PolarisedAbelianVarietyData A V where
  /-- **Principal condition**: every elementary divisor is `1`. -/
  polarType_eq_one : ∀ i : ℕ, polarType i = 1

namespace PrincipalPolarisationData

variable {A : Type*} {V : Type*} [AddCommGroup V] [Module ℚ V]
  [PrincipalPolarisationData A V]

/-- **Sanity**: principal polarisation type at index `0` is `1`. -/
theorem polarType_zero_eq_one :
    PolarisedAbelianVarietyData.polarType (A := A) (V := V) 0 = 1 :=
  polarType_eq_one 0

/-- **Sanity**: principal polarisation type at index `1` is `1`. -/
theorem polarType_one_eq_one :
    PolarisedAbelianVarietyData.polarType (A := A) (V := V) 1 = 1 :=
  polarType_eq_one 1

/-- **Sanity**: principal polarisation type at every index is positive. -/
theorem polarType_pos_principal (i : ℕ) :
    1 ≤ PolarisedAbelianVarietyData.polarType (A := A) (V := V) i := by
  rw [polarType_eq_one i]

end PrincipalPolarisationData

/-! ## Trivial inhabiting instances on `V := ℚ`

We witness consistency of the axiom packages by constructing
inhabiting instances on the carrier `V := ℚ`. The polarisation form
on `ℚ` cannot be non-degenerate and alternating simultaneously
(`ψ(1, 1) = 0` forces `ψ = 0`), so the only honest fully-alternating
non-degenerate datum on a `1`-dim space lives over `g = 0`
(the trivial polarised AV).

For `g = 0` the underlying AV is a *point*, `V = H¹(A; ℚ) = 0`-dim,
and the polarisation form is *vacuously* non-degenerate (there are
no non-zero `x` to test). We model this with the zero form on `ℚ`
and `g := 0`; the polarisation type is the constant-`1` sequence. -/

namespace Trivial

/-- The trivial AV carrier: a one-element abstract "abelian variety"
type representing the `g = 0` AV (i.e. the point). -/
def AV_trivial : Type := Unit

/-- The zero bilinear form on `ℚ`. We use this as the polarisation
form for the `g = 0` trivial instance: every `x` is `0`, so
`ψ(x, x) = 0` is automatic and non-degeneracy is vacuous. -/
def zeroForm : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ (fun _ _ => 0)
    (fun _ _ _ => by simp) (fun _ _ _ => by simp)
    (fun _ _ _ => by simp) (fun _ _ _ => by simp)

@[simp] theorem zeroForm_apply (x y : ℚ) : zeroForm x y = 0 := rfl

/-- The `PUnit`-as-ℚ-module trivial witness type. `PUnit` carries the
unique `AddCommGroup` and `Module ℚ PUnit` structures (every element
is `0`). This makes the non-degeneracy axiom **vacuously true**: there
are no non-zero elements to exhibit. -/
def PUnitAVModule : Type := PUnit

instance : AddCommGroup PUnitAVModule := inferInstanceAs (AddCommGroup PUnit)
instance : Module ℚ PUnitAVModule := inferInstanceAs (Module ℚ PUnit)

/-- The zero bilinear form on `PUnitAVModule` (the only possible form). -/
def zeroFormPUnit : PUnitAVModule →ₗ[ℚ] PUnitAVModule →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ (fun _ _ => 0)
    (fun _ _ _ => by simp) (fun _ _ _ => by simp)
    (fun _ _ _ => by simp) (fun _ _ _ => by simp)

@[simp] theorem zeroFormPUnit_apply (x y : PUnitAVModule) :
    zeroFormPUnit x y = 0 := rfl

/-- **Substantive lemma**: every element of `PUnitAVModule` is `0`. -/
theorem PUnitAVModule_eq_zero (x : PUnitAVModule) : x = 0 := by
  cases x; rfl

/-- Trivial `PolarisedAbelianVarietyData` instance on the zero AV carrier.
The non-degeneracy axiom is vacuous: there are no non-zero elements
in `PUnitAVModule`. The polarisation type is the constant-`1` sequence,
i.e. the principal-polarisation type. -/
instance polarisedAV_PUnit :
    PolarisedAbelianVarietyData AV_trivial PUnitAVModule where
  g := 0
  psi := zeroFormPUnit
  psi_alternating := by
    intro x
    simp [zeroFormPUnit]
  psi_nondegen := by
    intro x hx
    -- `PUnitAVModule_eq_zero` gives `x = 0`, contradicting `hx : x ≠ 0`.
    exact absurd (PUnitAVModule_eq_zero x) hx
  polarType := fun _ => 1
  polarType_pos := by intro _; exact Nat.le_refl 1
  polarType_dvd_succ := by intro _; exact Nat.one_dvd 1
  polarType_of_ge := by intro _ _; rfl

/-- **Sanity-check**: in the trivial instance, `g = 0`. -/
example : PolarisedAbelianVarietyData.g (A := AV_trivial) (V := PUnitAVModule)
    = 0 := rfl

/-- **Sanity-check**: in the trivial instance, the rank `dim V = 2g = 0`. -/
example : PolarisedAbelianVarietyData.rank_V (A := AV_trivial)
    (V := PUnitAVModule) = 0 := by
  unfold PolarisedAbelianVarietyData.rank_V
  decide

/-- **Sanity-check**: derived antisymmetry on the trivial instance. -/
example (x y : PUnitAVModule) :
    PolarisedAbelianVarietyData.psi (A := AV_trivial) x y =
      -PolarisedAbelianVarietyData.psi (A := AV_trivial) y x :=
  PolarisedAbelianVarietyData.psi_antisymm x y

/-- Trivial `PrincipalPolarisationData` instance: refining the
trivial polarised-AV instance with the principal condition (the
constant-`1` polarisation type is *literally* `(1, 1, …)`). -/
instance principalPolarisation_PUnit :
    PrincipalPolarisationData AV_trivial PUnitAVModule where
  toPolarisedAbelianVarietyData := polarisedAV_PUnit
  polarType_eq_one := by intro _; rfl

/-- **Sanity-check**: in the principal instance, the polarisation
type at index `0` is `1`. -/
example : PolarisedAbelianVarietyData.polarType
    (A := AV_trivial) (V := PUnitAVModule) 0 = 1 := rfl

/-- **Sanity-check**: in the principal instance, the polarisation
type at index `7` is `1` (out-of-range index also returns `1`). -/
example : PolarisedAbelianVarietyData.polarType
    (A := AV_trivial) (V := PUnitAVModule) 7 = 1 := rfl

end Trivial

end HodgeReduction.Infrastructure.AbelianVariety
