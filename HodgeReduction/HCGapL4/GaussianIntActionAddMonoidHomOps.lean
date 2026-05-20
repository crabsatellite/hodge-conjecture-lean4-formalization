/-
# HC Gap L4 — `AddMonoidHom`-level operations on the affine point group
of the Gaussian-CM elliptic curve (R316).

R314 documented the typeclass blocker:
`Ring (AddMonoid.End E_K.toAffine.Point)` does not synthesize cleanly
when the underlying `AddCommGroup` is noncomputable (it arrives via the
noncomputable field `FractionRing GaussianInt`). R316 bypasses the
blocker by working ONE LEVEL below: at the bare
`E_K.toAffine.Point →+ E_K.toAffine.Point` type. We still get the full
abelian-group structure on this hom-type (which only needs
`AddCommGroup` on the codomain, supplied by Mathlib's
`Mathlib.AlgebraicGeometry.EllipticCurve.Group`), and we still get
composition. We just do not invoke the `Ring (AddMonoid.End ...)`
instance.

## What this file provides (all kernel-pure)

* `PointK` — abbreviation for the affine point group of `E_K`.
* `PointEndHom` — abbreviation for `PointK →+ PointK`.
* `gaussianCMEC_toAffine_IsElliptic_inst_R316` — helper instance
  redirecting `toAffine.IsElliptic` to the R300 instance.
* Five basic ops on `PointEndHom`: `pointEnd_id`, `pointEnd_zero`,
  `pointEnd_add`, `pointEnd_neg`, `pointEnd_comp`.
* Five pointwise unfold lemmas (`_apply`), all `rfl`.
* Integer-scalar action `pointEnd_zsmul` with its `_apply` lemma.
* `gaussianCM_phi : PointEndHom` — the R308 `AddMonoidHom`
  re-exposed at the abbreviated type, plus pointwise unfold.
* `gaussianCM_phi_comp_phi_apply` — `(φ ∘ φ) P = -P` pointwise.
* `gaussianCM_phi_comp_phi_eq_neg_id` — `φ ∘ φ = -id` extensionally
  in `PointEndHom` (NOT yet in `AddMonoid.End`, which is the R314
  blocker layer).
* Status / bridge / non-closure markers.

## What R316 does NOT do

* Does NOT construct `Ring (AddMonoid.End E_K.toAffine.Point)` — the
  R314 typeclass blocker is bypassed by avoiding the ring layer.
* Does NOT construct algebraic `End(E)` or `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure (markers/status only).
-/

import HodgeReduction.HCGapL4.GaussianCMActionAddMonoidHom
import Mathlib.AlgebraicGeometry.EllipticCurve.Group
import Mathlib.Algebra.Group.Hom.End

/-! `AddCommGroup (PointK →+ PointK)` synthesis requires looking up
`AddCommGroup PointK`, which in turn needs to resolve `Field K` via
`FractionRing.field [IsDomain GaussianInt]` — this chain exceeds the
default `maxSynthPendingDepth = 1`. Lift the limit at file scope. -/
set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: abbreviations -/

/-- **R316** abbreviation for the affine point group of the Gaussian-CM
elliptic curve base-changed to `ℚ(i)`. We use `abbrev` so the abbreviation
is transparently unfolded by the kernel during definitional checks. -/
abbrev PointK : Type :=
  GaussianCMEllipticCurveTargetBaseChange.toAffine.Point

/-- **R316** abbreviation for the bundled group-endomorphism type on
`PointK`. Same `abbrev` discipline as `PointK`. -/
abbrev PointEndHom : Type := PointK →+ PointK

/-! ## Section 2: helper instance for `toAffine.IsElliptic`

The `[IsElliptic]` instance from R300 is stated on the base-changed
curve itself. Several downstream typeclass derivations want the same
instance on `.toAffine`. We provide it explicitly so type-class
synthesis can chain. -/

/-- **R316** redirect: the affine projection of the Gaussian-CM curve
inherits `IsElliptic` from the base-changed curve. This is the same
instance as R300; we re-expose it at `.toAffine.IsElliptic` for
typeclass search. -/
instance gaussianCMEC_toAffine_IsElliptic_inst_R316 :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.IsElliptic :=
  GaussianCMEllipticCurveTargetBaseChange_IsElliptic

/-! ## Section 3: kernel sanity checks

These confirm that `AddCommGroup PointK` and `AddCommGroup PointEndHom`
both resolve via type-class synthesis. The first comes from Mathlib's
`Mathlib.AlgebraicGeometry.EllipticCurve.Group` (the abelian-group
structure on the affine point set). The second is automatic:
`[AddCommGroup M] → AddCommGroup (M →+ M)` is in Mathlib. -/

noncomputable example : AddCommGroup PointK := inferInstance
noncomputable example : AddCommGroup PointEndHom := inferInstance

/-! ## Section 4: five basic operations on `PointEndHom` -/

/-- **R316** identity endomorphism on `PointK`. -/
noncomputable def pointEnd_id : PointEndHom := AddMonoidHom.id PointK

/-- **R316** zero endomorphism on `PointK` (sends every point to `0`). -/
noncomputable def pointEnd_zero : PointEndHom := 0

/-- **R316** pointwise addition of endomorphisms. -/
noncomputable def pointEnd_add (f g : PointEndHom) : PointEndHom := f + g

/-- **R316** pointwise negation of an endomorphism. -/
noncomputable def pointEnd_neg (f : PointEndHom) : PointEndHom := -f

/-- **R316** composition of endomorphisms. -/
noncomputable def pointEnd_comp (f g : PointEndHom) : PointEndHom := f.comp g

/-! ## Section 5: pointwise unfold lemmas for the five basic ops -/

/-- **R316** identity acts trivially. -/
theorem pointEnd_id_apply (P : PointK) : pointEnd_id P = P := rfl

/-- **R316** zero endomorphism evaluates to `0`. -/
theorem pointEnd_zero_apply (P : PointK) : pointEnd_zero P = 0 := rfl

/-- **R316** pointwise addition unfolds pointwise. -/
theorem pointEnd_add_apply (f g : PointEndHom) (P : PointK) :
    pointEnd_add f g P = f P + g P := rfl

/-- **R316** pointwise negation unfolds pointwise. -/
theorem pointEnd_neg_apply (f : PointEndHom) (P : PointK) :
    pointEnd_neg f P = -(f P) := rfl

/-- **R316** composition unfolds to function composition. -/
theorem pointEnd_comp_apply (f g : PointEndHom) (P : PointK) :
    pointEnd_comp f g P = f (g P) := rfl

/-! ## Section 6: integer scalar action -/

/-- **R316** integer scalar action on `PointEndHom`. Mathlib supplies
`SMul ℤ (M →+ M)` via the `AddCommGroup` structure on the hom type. -/
noncomputable def pointEnd_zsmul (n : ℤ) (f : PointEndHom) : PointEndHom :=
  n • f

/-- **R316** pointwise unfold for integer scalar action. The pointwise
form `(n • f) P = n • f P` holds by `rfl` after unfolding the
`zsmul` field of `AddMonoidHom.instAddCommGroup` (which is the
`to_additive` image of `MonoidHom.instCommGroup.zpow`, defined
pointwise). -/
theorem pointEnd_zsmul_apply (n : ℤ) (f : PointEndHom) (P : PointK) :
    pointEnd_zsmul n f P = n • f P := rfl

/-! ## Section 7: `φ` at `AddMonoidHom` level -/

/-- **R316** the Gaussian CM action `(x, y) ↦ (-x, i·y)` re-exposed at
the abbreviated `PointEndHom` type. This is definitionally the R308
`gaussianCMAction_AddMonoidHom`. -/
noncomputable def gaussianCM_phi : PointEndHom :=
  gaussianCMAction_AddMonoidHom

/-- **R316** pointwise unfold of `gaussianCM_phi`: it agrees with the
unbundled function `gaussianCMAction_affinePoint` (R303) on every point. -/
theorem gaussianCM_phi_apply (P : PointK) :
    gaussianCM_phi P = gaussianCMAction_affinePoint P := rfl

/-! ## Section 8: `φ² = -id` at `PointEndHom` level -/

/-- **R316** pointwise form of `φ² = -id`:

    (pointEnd_comp φ φ) P = -P

for all `P : PointK`. Proof: unfold `pointEnd_comp` and apply R304
`gaussianCMAction_affinePoint_square_eq_neg`. -/
theorem gaussianCM_phi_comp_phi_apply (P : PointK) :
    pointEnd_comp gaussianCM_phi gaussianCM_phi P = -P := by
  show gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P
  exact gaussianCMAction_affinePoint_square_eq_neg P

/-- **R316** extensional form of `φ² = -id` at the `PointEndHom`
(`AddMonoidHom`) level — NOT at the `AddMonoid.End` ring level (the
latter is the R314 blocker layer):

    pointEnd_comp φ φ = pointEnd_neg pointEnd_id

Proof: by `AddMonoidHom.ext` reduce to the pointwise statement, then
apply R304 `gaussianCMAction_affinePoint_square_eq_neg`. -/
theorem gaussianCM_phi_comp_phi_eq_neg_id :
    pointEnd_comp gaussianCM_phi gaussianCM_phi = pointEnd_neg pointEnd_id := by
  ext P
  show gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P
  exact gaussianCMAction_affinePoint_square_eq_neg P

/-! ## Section 9: status / bridge / non-closure markers -/

/-- **R316 bridge**: from `PointEndHom` ops to the Gaussian-integer
ring action target (R314 chain continues here, but at the
`AddMonoidHom` level rather than the `AddMonoid.End` ring level). -/
def L4_G_PointEndHomOps_To_GaussianIntAction : Prop := True

/-- **R316 bypass**: the `Ring (AddMonoid.End ...)` typeclass blocker
documented in R314 is bypassed here by working at the
`AddMonoidHom` level. -/
def L4_G_PointEndHomOps_Bypasses_RingEnd_TypeclassBlocker : Prop := True

/-- **R316 bridge**: from `PointEndHom` ops onward to `End⁰(E)`. -/
def L4_G_PointEndHomOps_To_End0 : Prop := True

/-- **R316 status**: `AddMonoidHom` operations (id / zero / add / neg
/ comp / zsmul) closed. -/
def R316_Status_AddMonoidHomOps_Closed : Prop := True

/-- **R316 status**: extensional `φ² = -id` closed at the
`AddMonoidHom` level. -/
def R316_Status_Phi_Square_Eq_NegId_Closed : Prop := True

/-! ## Section 10: explicit non-closure -/

/-- **R316 non-closure (1/4)**: does NOT construct
`Ring (AddMonoid.End E_K.toAffine.Point)` — the R314 typeclass
blocker is bypassed, not solved. -/
theorem R316_does_not_construct_RingEnd : True := trivial

/-- **R316 non-closure (2/4)**: does NOT construct the algebraic
endomorphism ring `End(E_K)`. -/
theorem R316_does_not_construct_algebraic_End : True := trivial

/-- **R316 non-closure (3/4)**: does NOT construct `End⁰(E_K)`. -/
theorem R316_does_not_construct_End0 : True := trivial

/-- **R316 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R316_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
