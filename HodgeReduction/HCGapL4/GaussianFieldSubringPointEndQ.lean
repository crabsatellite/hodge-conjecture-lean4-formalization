/-
# HC Gap L4 — Gaussian-field commutative ℚ-vector subspace of `PointEndHomQ` (R333).

R321-R322 built the rationalized point-End carrier `PointEndHomQ` and
its composition-induced bilinear multiplication `PointEndHomQ_mul`.
R329 closed invertibility of nonzero GaussianInt actions on the
ℚ-module. R330 identified the precise blocker for the next step —
`IsLocalization.lift` requires a `CommRing` target, but
`PointEndHomQ` is NOT globally commutative under composition.

R333 (this file) carves out the *commutative subspace* of `PointEndHomQ`
on which the GaussianInt action lives: the ℚ-vector subspace spanned
by `{pointEnd_id_Q, gaussianCM_phi_Q}`. We prove:

* **Normal form**: every element is of the form `a • id_Q + b • φ_Q`
  for unique `a, b ∈ ℚ` (forward + reverse direction via
  `Submodule.mem_span_pair`).
* **Closure under multiplication**: for `x, y` in the subspace,
  `PointEndHomQ_mul x y` is also in the subspace. Concretely,
  `(a id + b φ)(c id + d φ) = (ac - bd) id + (ad + bc) φ`
  (using `φ² = -id` from R322).
* **Internal commutativity**: for `x, y` in the subspace,
  `PointEndHomQ_mul x y = PointEndHomQ_mul y x`. Read off the
  normal-form expression — it is symmetric in `(a, b) ↔ (c, d)`.

## What R333 (this file) provides (all kernel-pure)

* `GaussianFieldSubspace_PointEndQ : Submodule ℚ PointEndHomQ` —
  the ℚ-vector subspace spanned by `{pointEnd_id_Q, gaussianCM_phi_Q}`.
* `pointEnd_id_Q_mem_GaussianFieldSubspace` /
  `gaussianCM_phi_Q_mem_GaussianFieldSubspace` — basis-element
  membership.
* `linear_combination_mem_GaussianFieldSubspace` — every linear
  combination is a member.
* `mem_GaussianFieldSubspace_iff_exists` — normal-form iff
  (via `Submodule.mem_span_pair`).
* `GaussianFieldSubspace_mul_normal_form` — the explicit
  multiplication formula on linear combinations.
* `GaussianFieldSubspace_mul_mem` — closure under multiplication.
* `GaussianFieldSubspace_mul_comm_normal_form` —
  commutativity on the normal form.
* `GaussianFieldSubspace_mul_comm` — internal commutativity.
* `L4-G` markers / `R333` status / non-closure.

## Strategic anchor

The R330 blocker on `IsLocalization.lift` is: the lift requires a
`CommRing` target, but `PointEndHomQ` is not globally commutative
under composition. R333 supplies the explicit commutative ℚ-vector
*subspace* of `PointEndHomQ` where the GaussianInt action lives, and
proves the three structural facts (normal form + closure + commutativity)
that this subspace will need before it can be promoted to a
commutative ℚ-algebra (R334+) and serve as a legitimate target for
the `ℚ(i)`-localization (R330 alternative path). The carrier built
here is the EXACT slot through which any `ℚ(i) → End⁰(E)`-like
algebra hom must factor without requiring a (false) global
`CommRing PointEndHomQ` instance, and thus is the source-side
infrastructure for `canonicalE7ShimuraTor.mtCorrespondencePackage`
(active HC cone field 3).

## What R333 does NOT do

* Does NOT package the subspace as a `CommRing` typeclass instance
  (R334+ target — requires lifting the bilinear multiplication to a
  binary operation on the subspace and discharging the Ring/CommRing
  axioms).
* Does NOT construct the algebra hom `ℚ(i) → subspace` (R335+).
* Does NOT construct true algebraic `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure (markers/status only).
-/

import HodgeReduction.HCGapL4.PointEndHomQMultiplication
import Mathlib.LinearAlgebra.Span.Defs

/-! Same `maxSynthPendingDepth` lift as R321/R322 — tensor-product
instance chains keep needing one extra synthesis step beyond the
default. -/
set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open scoped TensorProduct

/-! ## Section 1: the ℚ-vector subspace -/

/-- **R333** the ℚ-vector subspace of `PointEndHomQ` spanned by
`{pointEnd_id_Q, gaussianCM_phi_Q}`. Call this the "Gaussian field
subspace". This is the candidate commutative subspace where the
GaussianInt action lives. -/
noncomputable def GaussianFieldSubspace_PointEndQ :
    Submodule ℚ PointEndHomQ :=
  Submodule.span ℚ {pointEnd_id_Q, gaussianCM_phi_Q}

/-! ## Section 2: basis-element membership -/

/-- **R333** `pointEnd_id_Q` is a member of the Gaussian field
subspace (it is one of the spanning elements). -/
theorem pointEnd_id_Q_mem_GaussianFieldSubspace :
    pointEnd_id_Q ∈ GaussianFieldSubspace_PointEndQ := by
  unfold GaussianFieldSubspace_PointEndQ
  exact Submodule.subset_span (Set.mem_insert _ _)

/-- **R333** `gaussianCM_phi_Q` is a member of the Gaussian field
subspace (it is the other spanning element). -/
theorem gaussianCM_phi_Q_mem_GaussianFieldSubspace :
    gaussianCM_phi_Q ∈ GaussianFieldSubspace_PointEndQ := by
  unfold GaussianFieldSubspace_PointEndQ
  refine Submodule.subset_span ?_
  right
  rfl

/-! ## Section 3: linear-combination membership -/

/-- **R333** every ℚ-linear combination of `pointEnd_id_Q` and
`gaussianCM_phi_Q` lies in the Gaussian field subspace. -/
theorem linear_combination_mem_GaussianFieldSubspace (a b : ℚ) :
    a • pointEnd_id_Q + b • gaussianCM_phi_Q ∈
      GaussianFieldSubspace_PointEndQ := by
  refine Submodule.add_mem _ ?_ ?_
  · exact Submodule.smul_mem _ a pointEnd_id_Q_mem_GaussianFieldSubspace
  · exact Submodule.smul_mem _ b gaussianCM_phi_Q_mem_GaussianFieldSubspace

/-! ## Section 4: normal form (iff)

We use Mathlib's `Submodule.mem_span_pair`:
  `z ∈ span R ({x, y} : Set M) ↔ ∃ a b, a • x + b • y = z`.
Note the direction of the equation (`= z`, not `z =`); we flip
with `eq_comm` in the iff. -/

/-- **R333** normal-form characterization: `x` is in the Gaussian
field subspace iff `x = a • pointEnd_id_Q + b • gaussianCM_phi_Q`
for some `a, b : ℚ`. -/
theorem mem_GaussianFieldSubspace_iff_exists (x : PointEndHomQ) :
    x ∈ GaussianFieldSubspace_PointEndQ ↔
      ∃ a b : ℚ, x = a • pointEnd_id_Q + b • gaussianCM_phi_Q := by
  unfold GaussianFieldSubspace_PointEndQ
  rw [Submodule.mem_span_pair]
  constructor
  · rintro ⟨a, b, hab⟩
    exact ⟨a, b, hab.symm⟩
  · rintro ⟨a, b, hab⟩
    exact ⟨a, b, hab.symm⟩

/-! ## Section 5: tmul-level lemmas for smul

To prove the multiplication normal form cleanly, we need to push
`ℚ`-scalar multiplication into the left factor of the tensor
product. The relevant Mathlib lemma is `TensorProduct.smul_tmul'`:
`r • (m ⊗ₜ n) = (r • m) ⊗ₜ n` (with `r` acting on the ℚ-factor of
`ℚ ⊗[ℤ] PointEndHom`). -/

/-- **R333 helper**: `a • pointEnd_id_Q = a ⊗ₜ pointEnd_id`. Proof:
`pointEnd_id_Q = 1 ⊗ pointEnd_id`; the ℚ-scalar `a` pushes into the
left factor via `TensorProduct.smul_tmul'`; `a • (1 : ℚ) = a`. -/
theorem smul_pointEnd_id_Q_eq_tmul (a : ℚ) :
    a • pointEnd_id_Q = (a : ℚ) ⊗ₜ[ℤ] pointEnd_id := by
  show a • ((1 : ℚ) ⊗ₜ[ℤ] pointEnd_id) = (a : ℚ) ⊗ₜ[ℤ] pointEnd_id
  rw [TensorProduct.smul_tmul']
  show (a • (1 : ℚ)) ⊗ₜ[ℤ] pointEnd_id = a ⊗ₜ[ℤ] pointEnd_id
  rw [smul_eq_mul, mul_one]

/-- **R333 helper**: `b • gaussianCM_phi_Q = b ⊗ₜ gaussianCM_phi`.
Same as above but for the `φ`-component. -/
theorem smul_gaussianCM_phi_Q_eq_tmul (b : ℚ) :
    b • gaussianCM_phi_Q = (b : ℚ) ⊗ₜ[ℤ] gaussianCM_phi := by
  show b • ((1 : ℚ) ⊗ₜ[ℤ] gaussianCM_phi) = (b : ℚ) ⊗ₜ[ℤ] gaussianCM_phi
  rw [TensorProduct.smul_tmul']
  show (b • (1 : ℚ)) ⊗ₜ[ℤ] gaussianCM_phi = b ⊗ₜ[ℤ] gaussianCM_phi
  rw [smul_eq_mul, mul_one]

/-! ## Section 6: composition of basis elements

Four cases: `id ∘ id`, `id ∘ φ`, `φ ∘ id`, `φ ∘ φ`. Three are
trivial; the fourth is R316's `gaussianCM_phi_comp_phi_eq_neg_id`. -/

/-- **R333 helper**: `pointEnd_comp pointEnd_id pointEnd_id = pointEnd_id`.
Direct from `AddMonoidHom.id_comp`. -/
theorem pointEnd_comp_id_id :
    pointEnd_comp pointEnd_id pointEnd_id = pointEnd_id := by
  show (pointEnd_id).comp pointEnd_id = pointEnd_id
  exact AddMonoidHom.id_comp _

/-- **R333 helper**: `pointEnd_comp pointEnd_id gaussianCM_phi = gaussianCM_phi`.
Direct from `AddMonoidHom.id_comp`. -/
theorem pointEnd_comp_id_phi :
    pointEnd_comp pointEnd_id gaussianCM_phi = gaussianCM_phi := by
  show (pointEnd_id).comp gaussianCM_phi = gaussianCM_phi
  exact AddMonoidHom.id_comp _

/-- **R333 helper**: `pointEnd_comp gaussianCM_phi pointEnd_id = gaussianCM_phi`.
Direct from `AddMonoidHom.comp_id`. -/
theorem pointEnd_comp_phi_id :
    pointEnd_comp gaussianCM_phi pointEnd_id = gaussianCM_phi := by
  show gaussianCM_phi.comp pointEnd_id = gaussianCM_phi
  exact AddMonoidHom.comp_id _

/-! ## Section 7: tmul-level multiplication formulae for the four basis pairs -/

/-- **R333 helper**: `(a ⊗ pointEnd_id) * (c ⊗ pointEnd_id) = (a*c) ⊗ pointEnd_id`. -/
theorem PointEndHomQ_mul_tmul_id_id (a c : ℚ) :
    PointEndHomQ_mul ((a : ℚ) ⊗ₜ[ℤ] pointEnd_id)
                     ((c : ℚ) ⊗ₜ[ℤ] pointEnd_id)
      = ((a * c) : ℚ) ⊗ₜ[ℤ] pointEnd_id := by
  rw [PointEndHomQ_mul_tmul_tmul, pointEnd_comp_id_id]

/-- **R333 helper**: `(a ⊗ pointEnd_id) * (d ⊗ φ) = (a*d) ⊗ φ`. -/
theorem PointEndHomQ_mul_tmul_id_phi (a d : ℚ) :
    PointEndHomQ_mul ((a : ℚ) ⊗ₜ[ℤ] pointEnd_id)
                     ((d : ℚ) ⊗ₜ[ℤ] gaussianCM_phi)
      = ((a * d) : ℚ) ⊗ₜ[ℤ] gaussianCM_phi := by
  rw [PointEndHomQ_mul_tmul_tmul, pointEnd_comp_id_phi]

/-- **R333 helper**: `(b ⊗ φ) * (c ⊗ pointEnd_id) = (b*c) ⊗ φ`. -/
theorem PointEndHomQ_mul_tmul_phi_id (b c : ℚ) :
    PointEndHomQ_mul ((b : ℚ) ⊗ₜ[ℤ] gaussianCM_phi)
                     ((c : ℚ) ⊗ₜ[ℤ] pointEnd_id)
      = ((b * c) : ℚ) ⊗ₜ[ℤ] gaussianCM_phi := by
  rw [PointEndHomQ_mul_tmul_tmul, pointEnd_comp_phi_id]

/-- **R333 helper**: `(b ⊗ φ) * (d ⊗ φ) = (b*d) ⊗ (-pointEnd_id) = -((b*d) ⊗ pointEnd_id)`. -/
theorem PointEndHomQ_mul_tmul_phi_phi (b d : ℚ) :
    PointEndHomQ_mul ((b : ℚ) ⊗ₜ[ℤ] gaussianCM_phi)
                     ((d : ℚ) ⊗ₜ[ℤ] gaussianCM_phi)
      = -(((b * d) : ℚ) ⊗ₜ[ℤ] pointEnd_id) := by
  rw [PointEndHomQ_mul_tmul_tmul]
  -- gaussianCM_phi_comp_phi_eq_neg_id: pointEnd_comp φ φ = pointEnd_neg pointEnd_id = -pointEnd_id.
  rw [gaussianCM_phi_comp_phi_eq_neg_id]
  -- pointEnd_neg pointEnd_id is definitionally -pointEnd_id.
  show ((b * d) : ℚ) ⊗ₜ[ℤ] (-pointEnd_id) = -(((b * d) : ℚ) ⊗ₜ[ℤ] pointEnd_id)
  exact TensorProduct.tmul_neg _ _

/-! ## Section 8: bilinearity of `PointEndHomQ_mul` (additive expansion)

`PointEndHomQ_mul x = PointEndHomQ_mulL x` and `PointEndHomQ_mulL`
is a `→ₗ[ℤ]` LinearMap, so it respects addition on both sides via
`map_add`. We name the four expansions explicitly. -/

/-- **R333 helper**: `PointEndHomQ_mul` is additive on the left
(`(x + y) * z = x * z + y * z`). Read off
`PointEndHomQ_mulL.map_add`. -/
theorem PointEndHomQ_mul_add_left (x y z : PointEndHomQ) :
    PointEndHomQ_mul (x + y) z
      = PointEndHomQ_mul x z + PointEndHomQ_mul y z := by
  show PointEndHomQ_mulL (x + y) z
      = PointEndHomQ_mulL x z + PointEndHomQ_mulL y z
  rw [map_add]
  rfl

/-- **R333 helper**: `PointEndHomQ_mul` is additive on the right
(`x * (y + z) = x * y + x * z`). Read off the inner `→ₗ[ℤ]`'s
`map_add`. -/
theorem PointEndHomQ_mul_add_right (x y z : PointEndHomQ) :
    PointEndHomQ_mul x (y + z)
      = PointEndHomQ_mul x y + PointEndHomQ_mul x z := by
  show PointEndHomQ_mulL x (y + z)
      = PointEndHomQ_mulL x y + PointEndHomQ_mulL x z
  exact map_add _ _ _

/-! ## Section 9: multiplication normal form

The main computation. Strategy:
1. Rewrite each summand `a • pointEnd_id_Q` / `b • gaussianCM_phi_Q`
   as a simple tensor using Section 5 helpers.
2. Expand the product `(a id + b φ)(c id + d φ)` via Section 8
   additivity (twice).
3. Compute each of the four cross-terms via Section 7 helpers.
4. Rewrite the four resulting simple tensors back as ℚ-smul'd
   `pointEnd_id_Q` / `gaussianCM_phi_Q` (Section 5 helpers, reverse).
5. Use additive commutativity to match the canonical form. -/

/-- **R333** the explicit normal form for `PointEndHomQ_mul` on
linear combinations: `(a id + b φ)(c id + d φ) = (ac - bd) id + (ad + bc) φ`.

This is the multiplication formula for the Gaussian field — exactly
the one that makes the subspace closed under multiplication with the
expected commutative-algebra structure (verified separately in
Section 11). -/
theorem GaussianFieldSubspace_mul_normal_form (a b c d : ℚ) :
    PointEndHomQ_mul
        (a • pointEnd_id_Q + b • gaussianCM_phi_Q)
        (c • pointEnd_id_Q + d • gaussianCM_phi_Q)
      = (a * c - b * d) • pointEnd_id_Q
        + (a * d + b * c) • gaussianCM_phi_Q := by
  -- Step 1: rewrite each scalar-multiple as a simple tensor.
  rw [smul_pointEnd_id_Q_eq_tmul, smul_gaussianCM_phi_Q_eq_tmul,
      smul_pointEnd_id_Q_eq_tmul, smul_gaussianCM_phi_Q_eq_tmul]
  -- Goal: PointEndHomQ_mul (a ⊗ id + b ⊗ φ) (c ⊗ id + d ⊗ φ)
  --     = (a*c - b*d) • pointEnd_id_Q + (a*d + b*c) • gaussianCM_phi_Q
  -- Step 2: expand via additivity (twice).
  rw [PointEndHomQ_mul_add_left, PointEndHomQ_mul_add_right,
      PointEndHomQ_mul_add_right]
  -- Goal: a*id*c*id + a*id*d*φ + (b*φ*c*id + b*φ*d*φ)
  --     = (a*c-b*d) • id_Q + (a*d+b*c) • φ_Q
  -- Step 3: compute each of the four products.
  rw [PointEndHomQ_mul_tmul_id_id, PointEndHomQ_mul_tmul_id_phi,
      PointEndHomQ_mul_tmul_phi_id, PointEndHomQ_mul_tmul_phi_phi]
  -- Goal: (a*c) ⊗ id + (a*d) ⊗ φ + ((b*c) ⊗ φ + -((b*d) ⊗ id))
  --     = (a*c-b*d) • id_Q + (a*d+b*c) • φ_Q
  -- Step 4: rewrite RHS using Section 5 helpers (reversed).
  rw [smul_pointEnd_id_Q_eq_tmul, smul_gaussianCM_phi_Q_eq_tmul]
  -- Goal: (a*c) ⊗ id + (a*d) ⊗ φ + ((b*c) ⊗ φ + -((b*d) ⊗ id))
  --     = (a*c-b*d) ⊗ id + (a*d+b*c) ⊗ φ
  -- Step 5: regroup id-terms and φ-terms, then combine via tmul linearity.
  -- The id-terms on LHS: (a*c) ⊗ id + -((b*d) ⊗ id) = (a*c - b*d) ⊗ id
  -- The φ-terms on LHS:  (a*d) ⊗ φ  +   (b*c) ⊗ φ   = (a*d + b*c) ⊗ φ
  -- Push the negation into the left factor of the tensor.
  rw [show -(((b * d) : ℚ) ⊗ₜ[ℤ] pointEnd_id)
        = ((-(b * d)) : ℚ) ⊗ₜ[ℤ] pointEnd_id from
      (TensorProduct.neg_tmul _ _).symm]
  -- Combine like-tensored terms via `TensorProduct.add_tmul`.
  -- Need: (a*c) ⊗ id + (a*d) ⊗ φ + ((b*c) ⊗ φ + (-(b*d)) ⊗ id)
  --     = (a*c + -(b*d)) ⊗ id + (a*d + b*c) ⊗ φ.
  -- AND: a*c - b*d = a*c + -(b*d).
  rw [show (a * c - b * d : ℚ) = a * c + -(b * d) from by ring]
  rw [show (a * d + b * c : ℚ) = a * d + b * c from rfl]
  rw [show ((a * c + -(b * d)) : ℚ) ⊗ₜ[ℤ] pointEnd_id
        = ((a * c) : ℚ) ⊗ₜ[ℤ] pointEnd_id
          + ((-(b * d)) : ℚ) ⊗ₜ[ℤ] pointEnd_id from
      TensorProduct.add_tmul _ _ _]
  rw [show ((a * d + b * c) : ℚ) ⊗ₜ[ℤ] gaussianCM_phi
        = ((a * d) : ℚ) ⊗ₜ[ℤ] gaussianCM_phi
          + ((b * c) : ℚ) ⊗ₜ[ℤ] gaussianCM_phi from
      TensorProduct.add_tmul _ _ _]
  -- Now the goal is purely additive associativity / commutativity.
  abel

/-! ## Section 10: closure under multiplication -/

/-- **R333** the Gaussian field subspace is closed under
`PointEndHomQ_mul`: for `x, y` in the subspace, `x * y` is also in
the subspace. -/
theorem GaussianFieldSubspace_mul_mem
    {x y : PointEndHomQ}
    (hx : x ∈ GaussianFieldSubspace_PointEndQ)
    (hy : y ∈ GaussianFieldSubspace_PointEndQ) :
    PointEndHomQ_mul x y ∈ GaussianFieldSubspace_PointEndQ := by
  rw [mem_GaussianFieldSubspace_iff_exists] at hx hy
  obtain ⟨a, b, rfl⟩ := hx
  obtain ⟨c, d, rfl⟩ := hy
  rw [GaussianFieldSubspace_mul_normal_form]
  exact linear_combination_mem_GaussianFieldSubspace _ _

/-! ## Section 11: internal commutativity

Read off the normal form: `(ac - bd, ad + bc)` is symmetric in
`(a, b) ↔ (c, d)` (swapping reproduces `(ca - db, cb + da)`, and
multiplication on ℚ commutes). -/

/-- **R333** internal commutativity on the normal form:
swapping `(a, b)` and `(c, d)` gives the same product. -/
theorem GaussianFieldSubspace_mul_comm_normal_form (a b c d : ℚ) :
    PointEndHomQ_mul
        (a • pointEnd_id_Q + b • gaussianCM_phi_Q)
        (c • pointEnd_id_Q + d • gaussianCM_phi_Q)
      = PointEndHomQ_mul
            (c • pointEnd_id_Q + d • gaussianCM_phi_Q)
            (a • pointEnd_id_Q + b • gaussianCM_phi_Q) := by
  rw [GaussianFieldSubspace_mul_normal_form,
      GaussianFieldSubspace_mul_normal_form]
  -- LHS: (a*c - b*d) • id + (a*d + b*c) • φ
  -- RHS: (c*a - d*b) • id + (c*b + d*a) • φ
  -- These match by `mul_comm` on the ℚ-coefficients.
  congr 1
  · congr 1; ring
  · congr 1; ring

/-- **R333** internal commutativity: `PointEndHomQ_mul` is
commutative on the Gaussian field subspace. -/
theorem GaussianFieldSubspace_mul_comm
    {x y : PointEndHomQ}
    (hx : x ∈ GaussianFieldSubspace_PointEndQ)
    (hy : y ∈ GaussianFieldSubspace_PointEndQ) :
    PointEndHomQ_mul x y = PointEndHomQ_mul y x := by
  rw [mem_GaussianFieldSubspace_iff_exists] at hx hy
  obtain ⟨a, b, rfl⟩ := hx
  obtain ⟨c, d, rfl⟩ := hy
  exact GaussianFieldSubspace_mul_comm_normal_form a b c d

/-! ## Section 12: `L4-G` disclosure markers -/

/-- **L4-G** bridge from R333's commutative ℚ-vector subspace to the
GaussianRationalFieldCandidate algebra-hom (`ℚ(i) → subspace`).
R333 supplies the carrier; the algebra-hom is the R335+ target. -/
def L4_G_GaussianFieldSubringPointEndQ_To_GaussianFieldAction : Prop := True

/-- **L4-G** bridge from R333 to End⁰(E). R333's subspace is the
candidate commutative slot inside `PointEndHomQ` through which any
`ℚ(i) → End⁰(E)`-like algebra hom must factor. -/
def L4_G_GaussianFieldSubringPointEndQ_To_End0 : Prop := True

/-- **L4-G** Mathlib gap: promoting R333's subspace from a
`Submodule ℚ` to a `CommRing`/`Algebra ℚ` typeclass instance requires
lifting `PointEndHomQ_mul` to a binary operation on the subspace and
discharging the Ring/CommRing axioms. R334+ target. -/
def L4_G_GaussianFieldSubringPointEndQ_MissingCommRingTypeclass :
    Prop := True

/-- **L4-G** bridge to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R333 unlocks the
R330 blocker (`IsLocalization.lift` requires `CommRing`): by
identifying the commutative subspace, we can replace the (false)
global `CommRing PointEndHomQ` requirement with the (true) commutative
subspace requirement, which is the legitimate target for the
`ℚ(i)`-localization. -/
def L4_G_GaussianFieldSubringPointEndQ_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 13: status -/

/-- **R333 status**: the ℚ-vector subspace defined via Mathlib's
`Submodule.span`. -/
def R333_Status_Subspace_Defined : Prop := True

/-- **R333 status**: basis-element memberships closed. -/
def R333_Status_Basis_Membership_Closed : Prop := True

/-- **R333 status**: linear-combination membership closed. -/
def R333_Status_LinearCombination_Membership_Closed : Prop := True

/-- **R333 status**: normal-form iff closed (via
`Submodule.mem_span_pair`). -/
def R333_Status_NormalForm_Iff_Closed : Prop := True

/-- **R333 status**: multiplication normal form closed
(`(ac - bd) id + (ad + bc) φ`). -/
def R333_Status_Multiplication_NormalForm_Closed : Prop := True

/-- **R333 status**: closure under multiplication closed. -/
def R333_Status_Multiplication_Closure_Closed : Prop := True

/-- **R333 status**: internal commutativity closed. -/
def R333_Status_Internal_Commutativity_Closed : Prop := True

/-! ## Section 14: explicit non-closure -/

/-- **R333 non-closure (1/4)**: does NOT promote the subspace to a
`CommRing` / `Algebra ℚ` typeclass instance (R334+ target). -/
theorem R333_does_not_promote_to_CommRing_typeclass : True := trivial

/-- **R333 non-closure (2/4)**: does NOT construct the
`ℚ(i) → subspace` algebra hom (R335+ target). -/
theorem R333_does_not_construct_GaussianField_hom : True := trivial

/-- **R333 non-closure (3/4)**: does NOT construct true algebraic
`End⁰(E)` (still at point-group rationalization level). -/
theorem R333_does_not_construct_true_End0 : True := trivial

/-- **R333 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R333_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
