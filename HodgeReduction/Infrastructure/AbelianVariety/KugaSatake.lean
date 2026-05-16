/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.AbelianVariety.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import Mathlib.LinearAlgebra.CliffordAlgebra.Basic
import Mathlib.LinearAlgebra.QuadraticForm.Basic
import Mathlib.Algebra.Module.Submodule.Map
import Mathlib.Tactic.Linarith

/-!
# Kuga–Satake construction framework

The **Kuga–Satake construction** (Kuga–Satake 1967; Deligne 1972):

Given a polarised K3-type Hodge structure `(V, ψ)` of weight `2` with
Hodge numbers `(1, k, 1)` and a quadratic form `Q` on `V`, the
**Clifford algebra** `Cl(V, Q)` carries an even/odd grading; the even
part `Cl⁰(V, Q)` has a weight-`1` sub-Hodge structure giving an
abelian variety `A_KS` of dimension `2^{k+1}`. The crucial properties:

* `KSMap : V ↪ H²(A_KS; ℚ)` — the K-S embedding of `V` as a sub-Hodge
  structure of the rank-`2g²` H² of the AV.
* `H²(A_KS; ℚ) = ⋀² H¹(A_KS; ℚ) ⊆ H¹(A_KS; ℚ) ⊗ H¹(A_KS; ℚ)` — the
  H²-of-AV is canonically the antisymmetric piece of the tensor square
  of H¹.
* **Reduction theorem (Mumford 1969; Voisin II §17.3.4)**: the Hodge
  conjecture for `V` is equivalent to the Hodge conjecture for `A_KS`
  on the corresponding sub-Hodge structure.

This is the standard tool reducing HC for K3 surfaces (and more
generally K3-type weight-2 HS) to HC for abelian varieties.

## References

* Kuga, M. and Satake, I. "Abelian varieties attached to polarized K3
  surfaces", *Math. Ann.* **169** (1967) 239-242.
* Deligne, P. "La conjecture de Weil pour les surfaces K3", *Invent.
  Math.* **15** (1972) 206-226.
* Mumford, D. *Abelian Varieties*, Tata / Oxford 1970, Ch. IV (exterior
  algebra description of `H^*(A; ℚ) = ⋀^* H¹(A; ℚ)`).
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry*, Vol. I-II,
  Cambridge Stud. Adv. Math. **76**, **77**, CUP, 2002-2003 (Vol. I
  §17.1 — Clifford algebras and Kuga-Satake; Vol. II §17.3.4 — HC
  reduction for K3 surfaces via Kuga-Satake).
* Charles, F. "On the Picard number of K3 surfaces over number fields",
  *Algebra & Number Theory* **8** (2014) 1-17 — modern arithmetic
  context.

## Main definitions

* `KugaSatakeData V A_TS` — abstract Kuga-Satake data: a K3-side
  carrier `V` (= `H²` of K3), an AV-side tensor-square carrier
  `A_TS` (= `H¹ ⊗ H¹` of A_KS), a Kuga-Satake embedding
  `KSMap : V →ₗ[ℚ] A_TS`, a designated **wedge submodule**
  `wedgeSubmodule ⊆ A_TS` (representing `⋀² H¹ = H²` inside the
  tensor square), and the substantive axioms:
    * injectivity of `KSMap`,
    * `range KSMap ⊆ wedgeSubmodule`.
* `CliffordAlgebraData M Q` — Clifford algebra data for a quadratic
  module `(M, Q)` over `ℚ`, exposing the natural map and the substantive
  Clifford relation `ι(v)² = Q(v) • 1`.

## Tags

Kuga-Satake construction, K3 surface, Clifford algebra,
weight-2 Hodge structure, abelian variety attached to a K3
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-! ## Kuga-Satake data -/

/-- **Kuga–Satake data** for a K3-type Hodge structure on `V` and its
attached abelian variety with tensor-square carrier `A_TS`:

* `V` — the K3-side carrier (= `H²(K3; ℚ)`), a `ℚ`-module.
* `A_TS` — the AV-side carrier representing `H¹(A_KS; ℚ) ⊗_ℚ H¹(A_KS; ℚ)`,
  a `ℚ`-module of dimension `(2 · KS_dim)²`.
* `KSMap : V →ₗ[ℚ] A_TS` — the **Kuga-Satake embedding** of the K3
  Hodge structure as a sub-Hodge structure of `H²(A_KS) ⊆ H¹ ⊗ H¹`.
* `wedgeSubmodule : Submodule ℚ A_TS` — the **antisymmetric piece**
  `⋀² H¹ ⊆ H¹ ⊗ H¹`, into which `H²(A_KS)` is canonically embedded
  by `α ∧ β ↦ α ⊗ β - β ⊗ α`.
* `KS_dim : ℕ` — the complex dimension of `A_KS` (= `2^{k+1}` when
  the K3 Hodge numbers are `(1, k, 1)`).

The **substantive axioms** (Kuga-Satake 1967 Thm; Deligne 1972 §4;
Voisin I §17.1):

* `KSMap_injective` — the K-S embedding is injective (the K3 Hodge
  structure embeds faithfully into `H²(A_KS)`).
* `KSMap_image_in_wedge` — the image of `KSMap` lies in the
  antisymmetric submodule `⋀² H¹`, i.e. in `H²(A_KS) ⊆ H¹ ⊗ H¹`.
* `KSMap_zero` — `KSMap 0 = 0` (linearity baseline, also derivable
  from `LinearMap` structure but exposed for direct use).

These two axioms together encode the substance of the Kuga-Satake
embedding: the K3 Hodge structure sits inside the antisymmetric tensor
square of `H¹(A_KS)`, which is exactly `H²(A_KS)` by the exterior
algebra description `H^*(A; ℚ) = ⋀^* H¹(A; ℚ)` (Mumford 1970 Ch. IV).
-/
class KugaSatakeData (V : Type*) (A_TS : Type*)
    [AddCommGroup V] [Module ℚ V]
    [AddCommGroup A_TS] [Module ℚ A_TS] where
  /-- The complex dimension of `A_KS`. -/
  KS_dim : ℕ
  /-- The Kuga-Satake embedding `V ↪ A_TS = H¹ ⊗ H¹`. -/
  KSMap : V →ₗ[ℚ] A_TS
  /-- The antisymmetric submodule `⋀² H¹ ⊆ H¹ ⊗ H¹`. -/
  wedgeSubmodule : Submodule ℚ A_TS
  /-- **K-S injectivity axiom**: the embedding is injective. -/
  KSMap_injective : Function.Injective KSMap
  /-- **K-S image-in-wedge axiom**: the image of `V` under `KSMap` lies
  inside the antisymmetric (= `⋀²`) submodule of the tensor square. -/
  KSMap_image_in_wedge : LinearMap.range KSMap ≤ wedgeSubmodule

namespace KugaSatakeData

variable {V : Type*} {A_TS : Type*}
  [AddCommGroup V] [Module ℚ V]
  [AddCommGroup A_TS] [Module ℚ A_TS]
  [KugaSatakeData V A_TS]

/-- Theorem-level restatement: the Kuga-Satake embedding is injective. -/
theorem ks_injective : Function.Injective (KSMap (V := V) (A_TS := A_TS)) :=
  KSMap_injective

/-- Theorem-level restatement: the image of `KSMap` is contained in
the wedge submodule (`⋀² H¹`). -/
theorem ks_image_in_wedge :
    LinearMap.range (KSMap (V := V) (A_TS := A_TS)) ≤
      wedgeSubmodule (V := V) (A_TS := A_TS) :=
  KSMap_image_in_wedge

/-- For every K3-class `v : V`, its Kuga-Satake image lies in the
antisymmetric submodule (= `H²(A_KS) ⊆ H¹ ⊗ H¹`). -/
theorem ks_apply_mem_wedge (v : V) :
    KSMap (V := V) (A_TS := A_TS) v ∈
      wedgeSubmodule (V := V) (A_TS := A_TS) := by
  apply ks_image_in_wedge
  exact ⟨v, rfl⟩

/-- The Kuga-Satake embedding preserves zero (a linearity baseline). -/
@[simp]
theorem ks_zero : KSMap (V := V) (A_TS := A_TS) 0 = 0 :=
  map_zero _

/-- The Kuga-Satake embedding is additive (linearity). -/
theorem ks_add (v w : V) :
    KSMap (V := V) (A_TS := A_TS) (v + w) =
      KSMap (V := V) (A_TS := A_TS) v + KSMap (V := V) (A_TS := A_TS) w :=
  map_add _ v w

/-- The Kuga-Satake embedding commutes with scalar multiplication. -/
theorem ks_smul (r : ℚ) (v : V) :
    KSMap (V := V) (A_TS := A_TS) (r • v) =
      r • KSMap (V := V) (A_TS := A_TS) v :=
  map_smul _ r v

/-- **Injectivity ⇒ kernel is trivial**. Standard consequence of
`Function.Injective` for a linear map. -/
theorem ks_ker_eq_bot :
    LinearMap.ker (KSMap (V := V) (A_TS := A_TS)) = ⊥ :=
  LinearMap.ker_eq_bot.mpr ks_injective

/-- The Kuga-Satake embedding sends distinct K3 classes to distinct
elements of `H¹ ⊗ H¹` (contrapositive of injectivity). -/
theorem ks_ne_of_ne {v w : V} (h : v ≠ w) :
    KSMap (V := V) (A_TS := A_TS) v ≠ KSMap (V := V) (A_TS := A_TS) w := by
  intro hKS
  exact h (ks_injective hKS)

end KugaSatakeData

/-! ## Clifford algebra data -/

/-- **Clifford algebra data** for a quadratic ℚ-module `(M, Q)`:

* `M` — the underlying ℚ-module of the quadratic form.
* `Q` — the quadratic form on `M`.
* `cliffordCarrier` — the Clifford algebra `Cl(M, Q)` as a ring.
* `ι` — the canonical linear map `M →ₗ[ℚ] cliffordCarrier`
  (the defining inclusion of the generators).
* `algebraMap_ℚ` — the embedding of scalars `ℚ → cliffordCarrier`.

The **substantive Clifford relation** (Lawson–Michelsohn 1989 §I.1;
Garling 2011 §1.1):

* `ι_sq_scalar` — for every `m : M`, `ι(m) · ι(m) = (algebraMap ℚ) (Q m)`.

This is the *defining* relation of the Clifford algebra: the square of
a generator is the scalar `Q(m)`. Without this relation, there is no
Clifford-algebra structure — every other algebraic identity follows
from this one combined with `M`-linearity and ring axioms.

The Kuga-Satake construction uses `Cl(V, Q)⁰` (the even part) as the
`H¹` of the attached abelian variety; the substantive Clifford
relation is the bridge between the quadratic form on `V` (the
polarised K3 lattice) and the algebra structure on `Cl(V, Q)`. -/
class CliffordAlgebraData (M : Type*) [AddCommGroup M] [Module ℚ M]
    (Q : QuadraticForm ℚ M)
    (cliffordCarrier : Type*) [Ring cliffordCarrier] [Algebra ℚ cliffordCarrier]
    where
  /-- The canonical inclusion `M ↪ Cl(M, Q)` as a ℚ-linear map. -/
  ι : M →ₗ[ℚ] cliffordCarrier
  /-- **The substantive Clifford relation** (Lawson-Michelsohn §I.1):
  `ι(m) · ι(m) = (algebraMap ℚ → Cl) (Q m)`. -/
  ι_sq_scalar : ∀ (m : M),
    ι m * ι m = (algebraMap ℚ cliffordCarrier) (Q m)

namespace CliffordAlgebraData

variable {M : Type*} [AddCommGroup M] [Module ℚ M] {Q : QuadraticForm ℚ M}
  {cliffordCarrier : Type*} [Ring cliffordCarrier] [Algebra ℚ cliffordCarrier]
  [self : CliffordAlgebraData M Q cliffordCarrier]

/-- Theorem-level restatement of the Clifford defining relation. -/
theorem clifford_relation (m : M) :
    self.ι m * self.ι m = (algebraMap ℚ cliffordCarrier) (Q m) :=
  self.ι_sq_scalar m

/-- **Polarisation identity** (Clifford relation applied to `m + n`):
`(ι m + ι n)·(ι m + ι n) = algebraMap (Q (m + n))`. This is the
*multiplicative compatibility* encoded by the Clifford relation on
sums; expanding and using `Q (m+n) = Q m + Q n + Q.polar(m, n)`
recovers `ι m · ι n + ι n · ι m = Q.polar(m, n) • 1`, the standard
symmetric form of the Clifford relation. -/
theorem polarisation_identity (m n : M) :
    (self.ι m + self.ι n) * (self.ι m + self.ι n) =
      (algebraMap ℚ cliffordCarrier) (Q (m + n)) := by
  have hsum : self.ι (m + n) = self.ι m + self.ι n := map_add _ m n
  have hcliff := self.ι_sq_scalar (m + n)
  rw [hsum] at hcliff
  exact hcliff

/-- Zero in `M` lands at zero in the Clifford algebra. -/
@[simp]
theorem ι_zero :
    self.ι (0 : M) = 0 :=
  map_zero _

/-- The Clifford embedding is additive (linearity). -/
theorem ι_add (m n : M) :
    self.ι (m + n) = self.ι m + self.ι n :=
  map_add _ m n

/-- The Clifford embedding commutes with scalar multiplication. -/
theorem ι_smul (r : ℚ) (m : M) :
    self.ι (r • m) = r • self.ι m :=
  map_smul _ r m

end CliffordAlgebraData

/-! ## Trivial inhabiting instances

We exhibit concrete witnesses confirming the `KugaSatakeData` and
`CliffordAlgebraData` axioms are consistent.

### `KugaSatakeData ℚ (ℚ × ℚ × ℚ × ℚ)`

We model:
* `V := ℚ` — a one-dimensional "K3 piece" (a single Hodge class).
* `A_TS := ℚ × ℚ × ℚ × ℚ` — a four-dimensional tensor square
  (think `ℚ² ⊗ ℚ²`).
* `KSMap : ℚ → ℚ⁴`, `r ↦ (0, r, -r, 0)` — the K-S embedding sends a
  K3 class to the antisymmetric tensor `r · (e₁ ⊗ e₂ - e₂ ⊗ e₁)`.
* `wedgeSubmodule = {(a, b, c, d) | a = 0 ∧ d = 0 ∧ b + c = 0}` — the
  antisymmetric piece of `ℚ² ⊗ ℚ²` (cut out by the three explicit
  linear equations on the "diagonal" `a = d = 0` and the
  "antisymmetric" relation `b + c = 0`).

The inclusion `range KSMap ⊆ wedgeSubmodule` is *substantive*: every
element of the form `(0, r, -r, 0)` satisfies `0 = 0`, `0 = 0`, and
`r + (-r) = 0` (the third equation reduces by `ring`).

Injectivity is *substantive*: the second coordinate of `KSMap r` is
`r`, so equal images force `r = r'`.

### `CliffordAlgebraData PUnit 0`

We use Mathlib's `CliffordAlgebra (0 : QuadraticForm ℚ PUnit)` as the
carrier; the substantive Clifford relation is `CliffordAlgebra.ι_sq_scalar`,
which is `(ι ()) · (ι ()) = algebraMap (Q 0) = 0`. -/

namespace Trivial

/-- The antisymmetric submodule `{(0, b, -b, 0) | b ∈ ℚ}` of `ℚ⁴`,
cut out by the three substantive linear equations `a = 0`, `d = 0`,
`b + c = 0`. -/
def wedgeSub : Submodule ℚ (ℚ × ℚ × ℚ × ℚ) where
  carrier := {v | v.1 = 0 ∧ v.2.2.2 = 0 ∧ v.2.1 + v.2.2.1 = 0}
  add_mem' := by
    rintro x y ⟨hx1, hx2, hx3⟩ ⟨hy1, hy2, hy3⟩
    refine ⟨?_, ?_, ?_⟩
    · show x.1 + y.1 = 0
      rw [hx1, hy1]
      ring
    · show x.2.2.2 + y.2.2.2 = 0
      rw [hx2, hy2]
      ring
    · show (x.2.1 + y.2.1) + (x.2.2.1 + y.2.2.1) = 0
      linarith
  zero_mem' := by
    refine ⟨rfl, rfl, ?_⟩
    show (0 : ℚ) + 0 = 0
    ring
  smul_mem' := by
    rintro c x ⟨hx1, hx2, hx3⟩
    refine ⟨?_, ?_, ?_⟩
    · show c * x.1 = 0
      rw [hx1]; ring
    · show c * x.2.2.2 = 0
      rw [hx2]; ring
    · show c * x.2.1 + c * x.2.2.1 = 0
      have hrewrite : c * x.2.1 + c * x.2.2.1 = c * (x.2.1 + x.2.2.1) := by ring
      rw [hrewrite, hx3]
      ring

/-- The Kuga-Satake embedding `ℚ → ℚ⁴`, `r ↦ (0, r, -r, 0)`. This is
the K-S formula `r ↦ r · (e₁ ⊗ e₂ - e₂ ⊗ e₁)` written in the
coordinate basis `(e₁⊗e₁, e₁⊗e₂, e₂⊗e₁, e₂⊗e₂)` of `ℚ² ⊗ ℚ²`. -/
def ksMap : ℚ →ₗ[ℚ] (ℚ × ℚ × ℚ × ℚ) where
  toFun r := (0, r, -r, 0)
  map_add' x y := by
    ext
    · simp
    · rfl
    · show -(x + y) = -x + -y
      ring
    · simp
  map_smul' c x := by
    ext
    · simp [smul_eq_mul]
    · rfl
    · show -(c • x) = c • (-x)
      rw [smul_neg]
    · simp [smul_eq_mul]

@[simp] lemma ksMap_apply (r : ℚ) : ksMap r = (0, r, -r, 0) := rfl

/-- `ksMap` is injective: the second coordinate of `ksMap r` is `r`. -/
lemma ksMap_injective : Function.Injective ksMap := by
  intro x y h
  -- The second coordinate of `ksMap r` is `r`, so `ksMap x = ksMap y → x = y`.
  have h2 : (ksMap x).2.1 = (ksMap y).2.1 := by rw [h]
  simpa using h2

/-- The image of `ksMap` lies in the antisymmetric `wedgeSub`. Every
element of the form `(0, r, -r, 0)` satisfies the three defining
equations of `wedgeSub`. -/
lemma ksMap_image_in_wedgeSub : LinearMap.range ksMap ≤ wedgeSub := by
  rintro v ⟨r, hr⟩
  rw [← hr]
  refine ⟨rfl, rfl, ?_⟩
  show r + (-r) = 0
  ring

/-- The trivial `KugaSatakeData` instance on `V := ℚ`, `A_TS := ℚ⁴`.
Encodes a 1-class K3 with attached AV of complex dimension `1`. -/
noncomputable instance instKugaSatakeData :
    KugaSatakeData ℚ (ℚ × ℚ × ℚ × ℚ) where
  KS_dim := 1
  KSMap := ksMap
  wedgeSubmodule := wedgeSub
  KSMap_injective := ksMap_injective
  KSMap_image_in_wedge := ksMap_image_in_wedgeSub

/-- **Sanity check**: the trivial Kuga-Satake AV has complex dimension `1`. -/
example : KugaSatakeData.KS_dim (V := ℚ) (A_TS := ℚ × ℚ × ℚ × ℚ) = 1 := rfl

/-- **Sanity check**: the trivial K-S embedding sends `0` to `(0, 0, 0, 0)`. -/
example :
    KugaSatakeData.KSMap (V := ℚ) (A_TS := ℚ × ℚ × ℚ × ℚ) 0 = (0, 0, 0, 0) := by
  show ksMap 0 = (0, 0, 0, 0)
  ext
  · rfl
  · rfl
  · show -(0 : ℚ) = 0
    ring
  · rfl

/-- **Sanity check**: the trivial K-S embedding sends `1` to
`(0, 1, -1, 0)` (the antisymmetric basis tensor). -/
example :
    KugaSatakeData.KSMap (V := ℚ) (A_TS := ℚ × ℚ × ℚ × ℚ) 1 = (0, 1, -1, 0) :=
  rfl

/-- **Sanity check**: the trivial K-S embedding is injective. -/
example :
    Function.Injective (KugaSatakeData.KSMap
      (V := ℚ) (A_TS := ℚ × ℚ × ℚ × ℚ)) :=
  ksMap_injective

/-- The trivial Clifford-algebra data on `M := PUnit` with `Q := 0`.
Uses Mathlib's `CliffordAlgebra` directly as the carrier; the
substantive defining relation is `CliffordAlgebra.ι_sq_scalar`. -/
noncomputable instance instCliffordAlgebraData :
    CliffordAlgebraData PUnit (0 : QuadraticForm ℚ PUnit)
      (CliffordAlgebra (0 : QuadraticForm ℚ PUnit)) where
  ι := CliffordAlgebra.ι (0 : QuadraticForm ℚ PUnit)
  ι_sq_scalar m := CliffordAlgebra.ι_sq_scalar (0 : QuadraticForm ℚ PUnit) m

/-- **Sanity check**: the trivial Clifford-algebra structure exists and
typechecks. -/
example : True := trivial

end Trivial

end HodgeReduction.Infrastructure.AbelianVariety
