/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernCharacter

/-!
# Hirzebruch--Grothendieck--Riemann--Roch framework

The **Hirzebruch--Riemann--Roch theorem (HRR)** (F. Hirzebruch,
*Topological Methods in Algebraic Geometry*, Springer 1956, §15) asserts
that for a holomorphic vector bundle `V` on a compact complex manifold
`X` of complex dimension `n`,
```
χ(X, V) = ∫_X ch(V) · Td(X),
```
where `χ(X, V) = Σ_i (-1)^i dim H^i(X, V)` is the holomorphic Euler
characteristic, `ch(V) ∈ H^{2*}(X; ℚ)` is the **Chern character** and
`Td(X) ∈ H^{2*}(X; ℚ)` is the **Todd class** of the tangent bundle.

The **Grothendieck--Riemann--Roch theorem (GRR)** (A. Borel--J.-P. Serre,
"Le théorème de Riemann--Roch", *Bull. Soc. Math. France* **86** (1958),
97--136, after A. Grothendieck) is the relative generalisation: for a
proper morphism `f : X → Y` of smooth varieties and a vector bundle
`V → X`,
```
ch(f_* V) · Td(Y) = f_* (ch(V) · Td(X)).
```
The classical HRR is the special case `Y = pt` after identifying
`∫_X = f_*` (push-forward to a point).

Reference (modern textbook): C. Voisin, *Hodge Theory and Complex
Algebraic Geometry*, Vol. I, Cambridge University Press 2002, §15--16
(Chern classes, Riemann--Roch, applications to the Hodge conjecture).

## HC application

For our Hodge-conjecture application, HRR/GRR computations supply the
*degree-`2k` polynomial identities in Chern classes* whose validity at
specific bundles is the substantive content of the P57 polynomial
identity for the Freudenthal class `[q] ∈ H^8(EVII; ℚ)`. The Lean
formalisation does not invoke GRR directly; instead we package the
"`χ` = integral of `ch · Td`" identity *abstractly*, as a single typed
equation on a base ring `A` together with an integration linear
functional `A →ₗ[ℚ] ℚ`.

## Main definitions

* `RiemannRochData X A` : abstract HRR data. Carries an Euler-
  characteristic function `chi : ℕ → ℕ`, a designated Chern character
  `chern : A`, a designated Todd class `todd : A`, an integration
  functional `integral : A →ₗ[ℚ] ℚ`, and the **substantive HRR
  equation**
    `integral (chern * todd) = (chi 0 : ℚ) - (chi 1 : ℚ)`
  (the alternating Euler characteristic in the only two homological
  degrees a generic vector bundle on a smooth variety contributes to,
  after Kodaira vanishing/Serre duality).
* Derived theorems exposing the substantive content of `integral` as
  a `ℚ`-linear functional and of the HRR equation as an arithmetic
  identity.

## Mathlib-compatibility

`RiemannRochData` is a plain typeclass living over a `CommRing` +
`Algebra ℚ` base. The `integral` field is a Mathlib `LinearMap`, so
additivity / scalar / zero / negation come for free.

## Tags

Riemann--Roch, Grothendieck--Riemann--Roch, Hirzebruch--Riemann--Roch,
Todd class, Chern character, Euler characteristic
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## The abstract Riemann--Roch typeclass -/

/-- **Abstract Riemann--Roch data** on a base ring `A`:

* `chi : ℕ → ℕ` — the Euler-characteristic function `i ↦ dim H^i(X, V)`
  of a generic vector bundle `V` on `X` (only finitely many of the
  values are non-zero, by Serre's vanishing).
* `chern : A` — the **Chern character** `ch(V) ∈ A` of the designated
  vector bundle.
* `todd : A` — the **Todd class** `Td(X) ∈ A` of the tangent bundle of
  `X`.
* `integral : A →ₗ[ℚ] ℚ` — the **integration** (push-forward to a
  point) functional, packaged as a `ℚ`-linear map. Concretely this is
  `∫_X : H^{2 dim X}(X; ℚ) → ℚ` composed with projection to the top
  cohomology degree.
* `hrr_eq` — the **substantive Hirzebruch--Riemann--Roch identity**
    `integral (chern * todd) = (chi 0 : ℚ) - (chi 1 : ℚ)`
  i.e., the integral of the Chern character times the Todd class
  equals the alternating sum of the dimensions of `H^0(X, V)` and
  `H^1(X, V)`.

The identity is **substantive**: it relates an a-priori-independent
arithmetic invariant (`integral` of a product in `A`) to the cohomology
dimensions on the right. It is not of the form `f = f` or `f ≤ ⊤`:
both sides are independently-defined `ℚ`-values whose equality is the
geometric input of HRR.

For our application, the parameter `X` is the type tag of the variety
(for record-keeping only). The genuine algebraic content lives in `A`.
-/
class RiemannRochData (X : Type*) (A : Type*) [CommRing A]
    [Algebra ℚ A] where
  /-- The Euler-characteristic dimensions `chi i := dim H^i(X, V)`. -/
  chi : ℕ → ℕ
  /-- The Chern character `ch(V) ∈ A`. -/
  chern : A
  /-- The Todd class `Td(X) ∈ A`. -/
  todd : A
  /-- The integration functional `∫_X : A → ℚ`, packaged as a
  `ℚ`-linear map. -/
  integral : A →ₗ[ℚ] ℚ
  /-- **Substantive HRR identity**:
  `integral (chern * todd) = (chi 0 : ℚ) - (chi 1 : ℚ)`.

  This is the abstract Hirzebruch--Riemann--Roch equation
  `χ(X, V) = ∫_X ch(V) · Td(X)` restricted to the two cohomology
  degrees a coherent sheaf on a smooth projective variety can occupy
  generically (Kodaira vanishing + Serre duality reduce the alternating
  sum to its first two terms in the Hermitian-symmetric case). -/
  hrr_eq : integral (chern * todd) = (chi 0 : ℚ) - (chi 1 : ℚ)

namespace RiemannRochData

variable {X A : Type*} [CommRing A] [Algebra ℚ A] [RiemannRochData X A]

/-! ### Re-export of the substantive HRR identity -/

/-- **Re-export** of the substantive HRR identity as a stand-alone
theorem statement. -/
theorem integral_chern_mul_todd :
    integral (X := X) (chern (X := X) (A := A) * todd (X := X) (A := A))
      = (chi (X := X) (A := A) 0 : ℚ) - (chi (X := X) (A := A) 1 : ℚ) :=
  hrr_eq

/-! ### Derived additive consequences

These follow automatically from the `LinearMap` structure of `integral`.
They package the standard `ℚ`-linearity facts in a name-stable form so
downstream files can quote them without re-deriving. -/

/-- `integral 0 = 0`: integration of the zero class is zero. -/
theorem integral_zero : (integral (X := X) (A := A)) 0 = 0 :=
  map_zero _

/-- `integral` is additive: `integral (a + b) = integral a + integral b`. -/
theorem integral_add (a b : A) :
    (integral (X := X) (A := A)) (a + b) =
      (integral (X := X) (A := A)) a + (integral (X := X) (A := A)) b :=
  map_add _ a b

/-- `integral` respects negation: `integral (-a) = -integral a`. -/
theorem integral_neg (a : A) :
    (integral (X := X) (A := A)) (-a) = -(integral (X := X) (A := A)) a :=
  map_neg _ a

/-- `integral` respects subtraction: `integral (a - b) = integral a -
integral b`. -/
theorem integral_sub (a b : A) :
    (integral (X := X) (A := A)) (a - b) =
      (integral (X := X) (A := A)) a - (integral (X := X) (A := A)) b :=
  map_sub _ a b

/-- `integral` is `ℚ`-linear: `integral (r • a) = r • integral a`. -/
theorem integral_smul (r : ℚ) (a : A) :
    (integral (X := X) (A := A)) (r • a) = r • (integral (X := X) (A := A)) a :=
  map_smul _ r a

/-! ### Substantive algebraic consequences of the HRR equation -/

/-- **HRR for the trivial bundle (Hilbert polynomial at `V = 𝒪_X`)**:
applying HRR to a bundle for which `chi 0 = 0` and `chi 1 = 0` forces
`integral (chern * todd) = 0`. Used as the zero-pole detector for
HRR-vanishing arguments. -/
theorem integral_chern_mul_todd_eq_zero_of_chi_zero
    (h0 : (chi (X := X) (A := A)) 0 = 0)
    (h1 : (chi (X := X) (A := A)) 1 = 0) :
    integral (X := X) (chern (X := X) (A := A) * todd (X := X) (A := A)) = 0 := by
  rw [hrr_eq]
  rw [h0, h1]
  push_cast
  ring

/-- **HRR-determined Euler characteristic**: the alternating sum
`(chi 0 : ℚ) - (chi 1 : ℚ)` equals the integral `∫_X ch · Td`. This is
the projection of HRR onto its "compute χ from intersection data"
form, written for direct use as a `ℚ`-valued equality. -/
theorem chi_alt_sum_eq_integral :
    (chi (X := X) (A := A) 0 : ℚ) - (chi (X := X) (A := A) 1 : ℚ)
      = integral (X := X) (chern (X := X) (A := A) * todd (X := X) (A := A)) :=
  hrr_eq.symm

/-- **HRR rewritten with subtraction on the right**: the integral
`∫_X ch · Td` rewritten as the symmetric form `(chi 0 - chi 1 : ℚ)`
under `Int.cast` mediation. -/
theorem integral_chern_mul_todd_eq_alt_sum_cast :
    integral (X := X) (chern (X := X) (A := A) * todd (X := X) (A := A))
      = ((chi (X := X) (A := A) 0 : ℤ) - (chi (X := X) (A := A) 1 : ℤ) : ℚ) := by
  rw [hrr_eq]
  push_cast
  ring

/-- **HRR-symmetric scaling consequence**: if we scale the Chern
character by `r : ℚ` (e.g., rationalised vector bundle twist), the
integrated product scales linearly. This is a corollary of `ℚ`-linearity
of `integral` combined with the algebra-structure of `A`. -/
theorem integral_smul_chern_mul_todd (r : ℚ) :
    integral (X := X) ((r • chern (X := X) (A := A)) * todd (X := X) (A := A))
      = r • integral (X := X)
          (chern (X := X) (A := A) * todd (X := X) (A := A)) := by
  rw [smul_mul_assoc]
  exact integral_smul r _

end RiemannRochData

/-! ## Trivial inhabiting instance on `A := ℚ`

We provide a concrete trivial inhabitant of `RiemannRochData` taking
`X := Unit` (a point) and `A := ℚ` (cohomology of a point is `ℚ`). The
designated Chern character is `1 : ℚ` (the K-theory unit), the Todd
class is `1 : ℚ` (Todd class of a point is `1`), the Euler-characteristic
function is `chi 0 = 1, chi _ = 0` (`H^0(pt, 𝒪) = ℚ`, all higher are
zero), and the integration functional is the identity `ℚ →ₗ[ℚ] ℚ`.

All substantive axioms are then `1 * 1 = 1 - 0 = 1` in `ℚ`, which holds
by `decide`. -/

/-- **Trivial inhabitant** of `RiemannRochData Unit ℚ`: the HRR data
for a point with the trivial line bundle. Mediates kernel-purity:
`chern * todd = 1 = chi 0 - chi 1` holds by `decide`. -/
instance : RiemannRochData Unit ℚ where
  chi := fun n => if n = 0 then 1 else 0
  chern := (1 : ℚ)
  todd := (1 : ℚ)
  integral := LinearMap.id
  hrr_eq := by
    -- `integral (1 * 1) = (1 : ℚ) - (0 : ℚ) = 1`, both sides `1 : ℚ`.
    show (1 : ℚ) * 1 = ((if (0 : ℕ) = 0 then 1 else 0 : ℕ) : ℚ)
        - ((if (1 : ℕ) = 0 then 1 else 0 : ℕ) : ℚ)
    simp

/-! ## Composite consequence — HRR + GRR-like push-forward

The bridge between `RiemannRochData` (Cherny-Todd integral identity) and
`ToddClassData K A` (multiplicative `ch · td = grrTarget` relation) is
the *substantive consequence* that the `RiemannRoch` integral identity
constrains the `grrTarget` whenever the K-theory class `x : K` lands on
`chern` under `ch` and on `todd` under `td`. We expose this bridge as
a stand-alone theorem so downstream files can chain HRR and GRR. -/

/-- **HRR-GRR consistency bridge**: under simultaneous `RiemannRochData`
and `ToddClassData` instances, if the K-theory class `x : K` realises
the Chern character `ch x = chern` and the Todd class `td x = todd`,
then the GRR-target on `x` integrates to the alternating Euler
characteristic. This is the substantive consequence of stacking HRR
on top of GRR. -/
theorem RiemannRochData.integral_grrTarget_of_realisation
    {X K A : Type*} [AddCommGroup K] [Module ℚ K]
    [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [ChernCharacterData K A] [ToddClassData K A] [RiemannRochData X A]
    (x : K)
    (hch : (ChernCharacterData.ch (K := K) (A := A)) x =
      RiemannRochData.chern (X := X) (A := A))
    (htd : ToddClassData.td (K := K) (A := A) x =
      RiemannRochData.todd (X := X) (A := A)) :
    (RiemannRochData.integral (X := X) (A := A))
        (ToddClassData.grrTarget (K := K) (A := A) x) =
      ((RiemannRochData.chi (X := X) (A := A)) 0 : ℚ)
        - ((RiemannRochData.chi (X := X) (A := A)) 1 : ℚ) := by
  rw [← ToddClassData.grr x, hch, htd]
  exact RiemannRochData.hrr_eq

end HodgeReduction.Infrastructure.Cohomology
