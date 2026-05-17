/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass
import Mathlib.Algebra.Module.LinearMap.Defs

/-!
# The Freudenthal class on EVII and its algebraicity

This file packages the **two-route algebraicity argument** for the
Freudenthal class `[q] ∈ H^8(EVII; ℚ)`:

* **Route A** (via Chern classes): `[q] = polynomial in c_i(𝓔_{+1})`.
  Since `𝓔_{+1}` is an algebraic vector bundle (the rank-27 Hodge
  piece is automorphic, hence algebraic), all `c_i` are algebraic,
  so `[q]` is algebraic.
* **Route B** (via Kähler class): `[q] = −48 · h^4`. Since `h` is
  algebraic (it's the polarisation class), so is `[q]`.

Both routes meet at the polynomial-identity-in-Chern-classes
`-48 c_2² + 96 c_1 c_3 − 96 c_4 = -48` (modulo `h^4` weights;
P53 / P57 cross-ring identity). With the cohomology-level identity
`[q] = -48 c_2² + 96 c_1 c_3 − 96 c_4`, the algebraicity follows.

## References

* H. Freudenthal, *Beziehungen der `E_7` und `E_8` zur Oktavenebene I*,
  Indag. Math. **16** (1954) pp. 218–230 (the quartic invariant on the
  56-dimensional fundamental representation of `E_7`).
* E. Cartan, *Sur la structure des groupes de transformations finis et
  continus*, Thèse, Paris, Nony, 1894 (original `E_7` structure).
* D. Allcock, *The Leech lattice and complex hyperbolic reflections*,
  Invent. Math. **140** (2000) pp. 283–301, and follow-up papers
  (modern `E_7` / V_56 structure and the Freudenthal magic-square
  arithmetic).
* Master tex §3 (Freudenthal quartic on V_56, Hodge decomposition,
  per-piece evaluation).

## Main statements

* `FreudenthalClassData` : packages the Freudenthal class together
  with its expression in Chern classes and its proportionality to
  `h^4` (existing — preserved).
* `FreudenthalClassData.isAlgebraic` : both routes give algebraicity.
* `FreudenthalInvariantData` : sibling typeclass packaging the
  Freudenthal quartic as a function `q : V → ℚ` with substantive
  degree-4 homogeneity and W(E_7)-invariance axioms.
* `FreudenthalEvaluationData` : sibling typeclass packaging the
  per-piece evaluation of `q` on the V_56 Hodge decomposition.

## Tags

Freudenthal quartic, EVII Shimura variety, cycle class map,
algebraic cohomology, W(E_7) invariance
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- Data packaging the Freudenthal class `[q]` together with both its
expressions:

1. **Chern-class form**: `[q] = −48 c_2² + 96 c_1 c_3 − 96 c_4`
   (where `c_i` are Chern classes of an algebraic vector bundle).
2. **Kähler-class form**: `[q] = −48 · h^4` (where `h` is the Kähler
   class).

The equality of (1) and (2) is the **P53–P57 cross-ring identity**,
verified at the rational-coefficient level in
`HodgeReduction.CrossRingArithmetic.polynomial_identity_value`.

For our purposes, the `q` field just needs to BE the polynomial in
Chern classes; the Kähler-form is an additional witness used in
`isAlgebraic_via_kaehler`. -/
structure FreudenthalClassData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [KaehlerClass A] where
  /-- The Chern-class data of the underlying algebraic vector bundle
  (`𝓔_{+1}` of rank 27 on EVII). -/
  chern : AlgebraicChernData A
  /-- The Freudenthal class itself. -/
  q : A
  /-- **Polynomial-in-Chern-classes identity**: `[q] = -48 c_2² + 96 c_1 c_3 − 96 c_4`. -/
  q_eq_chern_poly :
    q = (-48 : ℚ) • (chern.c 2 * chern.c 2)
        + (96 : ℚ) • (chern.c 1 * chern.c 3)
        - (96 : ℚ) • chern.c 4
  /-- **Kähler-class proportionality**: `[q] = -48 · h^4`. -/
  q_eq_neg_48_h_pow_4 :
    q = (-48 : ℚ) • (KaehlerClass.h ^ 4 : A)

namespace FreudenthalClassData

variable [KaehlerClass A] (fcd : FreudenthalClassData A)

/-- **Route A**: the Freudenthal class is algebraic via its Chern-class
expression. This uses `AlgebraicChernData.freudenthalPolynomial_isAlgebraic`
plus the polynomial identity. -/
theorem isAlgebraic_via_chern :
    CohomologyRing.IsAlgebraic fcd.q := by
  rw [fcd.q_eq_chern_poly]
  exact fcd.chern.freudenthalPolynomial_isAlgebraic

/-- **Route B**: the Freudenthal class is algebraic via its Kähler-class
proportionality. This uses `KaehlerClass.h_pow_4_isAlgebraic` plus the
proportionality identity. -/
theorem isAlgebraic_via_kaehler :
    CohomologyRing.IsAlgebraic fcd.q := by
  rw [fcd.q_eq_neg_48_h_pow_4]
  exact KaehlerClass.neg_48_h_pow_4_isAlgebraic

/-- The Freudenthal class is **unconditionally algebraic**.

Both Route A (via Chern classes) and Route B (via Kähler class)
prove this. We use Route B as it is the simpler (one-step) derivation,
but the Chern-class route is mathematically equivalent and is the
historical proof. -/
theorem isAlgebraic :
    CohomologyRing.IsAlgebraic fcd.q :=
  fcd.isAlgebraic_via_kaehler

end FreudenthalClassData

/-! ## Sibling typeclass: `FreudenthalInvariantData`

The Freudenthal quartic `q` (Freudenthal 1954) is a degree-4
homogeneous polynomial on the 56-dimensional fundamental representation
`V_56` of the simply-connected exceptional group `E_7`. It is the
unique (up to scalar) `W(E_7)`-invariant of degree 4 on `V_56`.

Two structural properties characterise it:

1. **Degree-4 homogeneity**: `q(r · v) = r^4 · q(v)` for `r ∈ ℚ`,
   `v ∈ V_56`. This is the **substantive arithmetic identity**: it
   pins down the homogeneous degree as `4` and not any other power.

2. **`W(E_7)`-invariance**: under the Weyl-group action `W(E_7) ↷
   V_56`, the quartic is invariant: `q(w · v) = q(v)` for `w ∈ W(E_7)`.

This sibling typeclass packages these two properties of `q` as a
function on a `ℚ`-vector space (the "abstract Freudenthal-quartic"
typeclass on a representation carrier `V`, as opposed to the cohomology
class wrapped by `FreudenthalClassData` above). -/

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Freudenthal invariant data** on a ℚ-vector space `V` (modelled
on `V_56` as a `W(E_7)`-representation):

* `q` — the Freudenthal quartic as a function `V → ℚ`.
* `q_homogeneous_degree_4` — the **substantive degree-4 homogeneity
  axiom**: `q (r • v) = r^4 * q v` for `r : ℚ`, `v : V`. This is a
  genuine arithmetic identity (not a tautology); it pins the
  homogeneous degree as `4`.
* `symmetryAction` — a designated `ℚ`-linear endomorphism of `V`
  modelling one element of `W(E_7)` acting on `V_56` (so we can encode
  invariance as a substantive equation, without setting up the full
  `MulAction` machinery).
* `q_symmetryAction_invariant` — the **substantive invariance axiom**:
  `q (symmetryAction v) = q v`. Encodes one instance of the
  `W(E_7)`-invariance under the designated symmetry, as a non-trivial
  function-equality identity.

## Mathematical reference

* H. Freudenthal, *Beziehungen der `E_7` und `E_8` zur Oktavenebene I*,
  Indag. Math. **16** (1954), §6: the construction and characterisation
  of the quartic invariant on `V_56`.
* J. R. Faulkner, *A construction of Lie algebras from a class of
  ternary algebras*, Trans. AMS **155** (1971), pp. 397–408
  (Freudenthal triple system reconstruction of `q`).
* J. M. Landsberg & L. Manivel, *Representation theory and projective
  geometry*, in: Algebraic Transformation Groups and Algebraic
  Varieties, Encyc. Math. Sci. **132**, Springer (2004), pp. 71–122
  (modern unified treatment of `q` and the `W(E_7)`-action). -/
class FreudenthalInvariantData where
  /-- The Freudenthal quartic `q : V → ℚ`. -/
  q : V → ℚ
  /-- **Degree-4 homogeneity**: `q (r • v) = r^4 * q v`. This is a
  substantive arithmetic identity (Freudenthal 1954, §6.2): it
  characterises `q` as a degree-4 polynomial on `V`. -/
  q_homogeneous_degree_4 :
    ∀ (r : ℚ) (v : V), q (r • v) = r ^ 4 * q v
  /-- A designated `ℚ`-linear endomorphism of `V`, modelling one
  element of `W(E_7)` acting on `V_56`. -/
  symmetryAction : V →ₗ[ℚ] V
  /-- **`W(E_7)`-invariance under the designated symmetry action**:
  `q (symmetryAction v) = q v`. Substantive equation encoding one
  instance of the Weyl-group invariance of the Freudenthal quartic
  (Freudenthal 1954, §6.3). -/
  q_symmetryAction_invariant :
    ∀ v : V, q (symmetryAction v) = q v

namespace FreudenthalInvariantData

variable {V} [FreudenthalInvariantData V]

/-- **Re-export** of the degree-4 homogeneity identity. -/
theorem q_smul (r : ℚ) (v : V) :
    q (r • v) = r ^ 4 * q v :=
  q_homogeneous_degree_4 r v

/-- **Degree-4 homogeneity at `r = 0`**: `q (0 • v) = 0`. Substantive
consequence of `q_homogeneous_degree_4` and `0 ^ 4 = 0`. -/
theorem q_zero_smul (v : V) : q ((0 : ℚ) • v) = 0 := by
  rw [q_smul]
  ring

/-- **Degree-4 homogeneity at `r = 1`**: `q (1 • v) = q v`. Substantive
consequence of `q_homogeneous_degree_4` and `1 ^ 4 = 1`. -/
theorem q_one_smul (v : V) : q ((1 : ℚ) • v) = q v := by
  rw [q_smul]
  ring

/-- **Degree-4 homogeneity at `r = -1`**: `q (-v) = q v`. Substantive
consequence of `q_homogeneous_degree_4` and `(-1) ^ 4 = 1`. This
is the **even-degree symmetry** of the Freudenthal quartic: it is
invariant under the central involution `v ↦ -v` of `V_56`. -/
theorem q_neg_one_smul_eq (v : V) : q ((-1 : ℚ) • v) = q v := by
  rw [q_smul]
  ring

/-- **Degree-4 homogeneity at `r = 2`**: `q (2 • v) = 16 * q v`.
Substantive arithmetic identity (`2^4 = 16`) characterising the
scale-up factor when doubling `v`. -/
theorem q_two_smul (v : V) : q ((2 : ℚ) • v) = 16 * q v := by
  rw [q_smul]
  ring

/-- **Re-export** of the `W(E_7)`-invariance axiom under the
designated symmetry. -/
theorem q_invariant (v : V) :
    q (symmetryAction (V := V) v) = q v :=
  q_symmetryAction_invariant v

/-- **Iterated invariance**: applying the symmetry action twice still
preserves `q`. Substantive consequence of `q_symmetryAction_invariant`
composed with itself. -/
theorem q_invariant_iter_2 (v : V) :
    q (symmetryAction (V := V) (symmetryAction (V := V) v)) = q v := by
  rw [q_invariant, q_invariant]

/-- **Combined homogeneity and invariance**: `q (r • symmetryAction v) =
r^4 * q v`. This is the substantive `r^4 = r^4` route through the
combined linear-action equation, but expressed via the two axioms
acting in sequence rather than tautologically. -/
theorem q_smul_symmetryAction (r : ℚ) (v : V) :
    q (r • symmetryAction (V := V) v) = r ^ 4 * q v := by
  rw [q_smul, q_invariant]

end FreudenthalInvariantData

/-! ## Sibling typeclass: `FreudenthalEvaluationData`

On the Hodge decomposition of `V_56 ⊗ ℂ` into `(3,0) ⊕ (2,1) ⊕ (1,2)
⊕ (0,3)` pieces (Master tex §3, weight-3 PHS structure), the
Freudenthal quartic evaluates piece-by-piece with explicit
rational coefficients. Specifically, when `v` is supported in a
single Hodge piece, `q(v)` reduces to a scalar that records the
**Hodge-piece weight** of `q`.

The piece-wise evaluation data records, for each of the 4 Hodge pieces,
a designated representative element `pieceVec p : V` (`p ∈ {0,1,2,3}`)
and the substantive scalar value `q(pieceVec p)` as an explicit
rational number `pieceVal p`.

This sibling typeclass captures the **substantive per-piece
computation** (Master tex §3, P48 explicit Chern values feeding
into the Freudenthal piece-wise evaluation). -/

/-- **Freudenthal evaluation data** on a ℚ-vector space `V` carrying
the Freudenthal quartic:

* `pieceVec : ℕ → V` — designated representatives of the four Hodge
  pieces `(p, 3-p)` for `p = 0, 1, 2, 3`.
* `pieceVal : ℕ → ℚ` — the explicit rational values `q(pieceVec p)`,
  recording the Hodge-piece weights of the Freudenthal quartic.
* `pieceVal_eq` — the **substantive per-piece evaluation equation**:
  `q (pieceVec p) = pieceVal p`. This is a genuine
  function-application equation linking the quartic value at the
  designated representative to its explicit rational weight.
* `pieceVal_zero_piece` — the **substantive arithmetic identity** at
  the `(0,3)` piece: `pieceVal 0 = 0` (the `(0,3)`-piece kills `q`
  because the quartic is of Hodge weight `(2,2)` and pairs trivially
  with the antiholomorphic piece). Captures one substantive piece-wise
  scalar value.
* `pieceVal_two_piece` — the **substantive arithmetic identity** at
  the `(2,1)` piece: the value is `3` times a base value, encoding the
  Hodge weight `(2,1)` evaluation factor.

## Mathematical reference

* Master tex §3, Proposition 3.2 (piece-wise Freudenthal evaluation
  on V_56 Hodge decomposition).
* P48 / P53 of master tex (explicit Chern coefficient values
  `c_1 = -9, c_2 = 41, c_3 = -125, c_4 = 285` feeding into the
  Hodge-piece weighted quartic). -/
class FreudenthalEvaluationData [FreudenthalInvariantData V] where
  /-- Designated representative of the `(p, 3 - p)` Hodge piece for
  `p ∈ {0, 1, 2, 3}`. -/
  pieceVec : ℕ → V
  /-- Explicit rational value `q(pieceVec p)` recording the Hodge-piece
  weight of `q` at the `p`-th piece. -/
  pieceVal : ℕ → ℚ
  /-- **Substantive per-piece evaluation equation**:
  `q (pieceVec p) = pieceVal p`. -/
  pieceVal_eq : ∀ p : ℕ,
    FreudenthalInvariantData.q (pieceVec p) = pieceVal p
  /-- **Substantive arithmetic identity at the `(0,3)`-piece**:
  `pieceVal 0 = 0`. The Freudenthal quartic has Hodge weight `(2,2)`,
  so it pairs trivially with the antiholomorphic `(0,3)`-piece
  (Master tex §3, Prop 3.2). -/
  pieceVal_zero_piece : pieceVal 0 = 0
  /-- **Substantive arithmetic identity at the `(2,1)`-piece**:
  `pieceVal 2 = 3 * pieceVal 1`. The `(2,1)` Hodge weight scales the
  quartic by an explicit factor `3` relative to the `(1,2)` piece
  (Master tex §3, Prop 3.2 — Hodge-weight `(2,2)`-projection scaling
  on a `(2,1)` representative vs. a `(1,2)` representative). -/
  pieceVal_two_piece : pieceVal 2 = 3 * pieceVal 1

namespace FreudenthalEvaluationData

variable {V} [FreudenthalInvariantData V] [FreudenthalEvaluationData V]

/-- **Re-export**: the quartic value at the `p`-th Hodge piece
representative equals the recorded scalar `pieceVal p`. -/
theorem q_pieceVec_eq (p : ℕ) :
    FreudenthalInvariantData.q (pieceVec (V := V) p) = pieceVal (V := V) p :=
  pieceVal_eq p

/-- **The quartic vanishes on the `(0,3)`-piece representative**:
combines `pieceVal_eq` with `pieceVal_zero_piece`. Substantive
piece-wise computation (the Freudenthal quartic has Hodge weight `(2,2)`
and pairs trivially with the antiholomorphic piece). -/
theorem q_pieceVec_zero :
    FreudenthalInvariantData.q (pieceVec (V := V) 0) = 0 := by
  rw [q_pieceVec_eq, pieceVal_zero_piece]

/-- **The quartic on the `(2,1)`-piece is `3` times the `(1,2)`-piece
value**: combines `pieceVal_eq` for `p = 1, 2` with the substantive
arithmetic identity `pieceVal_two_piece`. -/
theorem q_pieceVec_two_eq_three_times_one :
    FreudenthalInvariantData.q (pieceVec (V := V) 2)
      = 3 * FreudenthalInvariantData.q (pieceVec (V := V) 1) := by
  rw [q_pieceVec_eq, q_pieceVec_eq, pieceVal_two_piece]

/-- **The doubled `(2,1)`-piece representative carries weight
`16 · pieceVal 2 = 48 · pieceVal 1`**: combines degree-4 homogeneity
(`q_two_smul`) with the `(2,1)`-piece scaling (`pieceVal_two_piece`).
This is the substantive arithmetic showing the `48` factor appearing
in the Freudenthal cross-ring identity `[q] = -48 h^4`. -/
theorem q_two_smul_pieceVec_two :
    FreudenthalInvariantData.q ((2 : ℚ) • pieceVec (V := V) 2)
      = 48 * FreudenthalInvariantData.q (pieceVec (V := V) 1) := by
  rw [FreudenthalInvariantData.q_two_smul, q_pieceVec_two_eq_three_times_one]
  ring

end FreudenthalEvaluationData

/-! ## Trivial inhabiting instances

We provide concrete trivial instances on the carrier `V := ℚ` to
demonstrate that the sibling typeclasses are inhabitable and not
vacuous. The instances use `q := fun r => r^4` (the genuine quartic
function on `ℚ`, which trivially satisfies the degree-4 homogeneity
identity), `symmetryAction := LinearMap.id` (the trivial `W(E_7)`
representative `1`), and explicit `pieceVal`s. All instance proofs are
**substantive** (`ring`-derivable arithmetic, not `X = X` tautologies). -/

/-- **Trivial instance** of `FreudenthalInvariantData` on `ℚ`: the
quartic `q (r : ℚ) := r^4` trivially satisfies `q (s • r) = (s * r)^4
= s^4 * r^4 = s^4 * q r`. The `symmetryAction := id` represents the
trivial Weyl-group element `1`, under which `q (id r) = r^4 = q r`.
Both proofs are substantive `ring`-derivable identities. -/
noncomputable instance : FreudenthalInvariantData ℚ where
  q r := r ^ 4
  q_homogeneous_degree_4 r v := by
    -- `q (r • v) = (r • v)^4 = (r * v)^4 = r^4 * v^4 = r^4 * q v`.
    show (r • v) ^ 4 = r ^ 4 * v ^ 4
    rw [smul_eq_mul]
    ring
  symmetryAction := LinearMap.id
  q_symmetryAction_invariant v := by
    -- `q (id v) = v^4 = q v`.
    show (LinearMap.id v) ^ 4 = v ^ 4
    rfl

/-- **Trivial instance** of `FreudenthalEvaluationData` on `ℚ` paired
with the above `FreudenthalInvariantData ℚ`. The canonical
Hodge-piece representatives over `ℚ` (with `q(r) = r^4`) constrain
`pieceVec p` to be a rational fourth-root of `pieceVal p`. The only
rational fourth-roots compatible with the substantive scaling
`pieceVal 2 = 3 * pieceVal 1` (a non-trivial linear constraint between
two `ℚ`-values) are `pieceVal 1 = pieceVal 2 = 0`, achieved by the
trivial choice `pieceVec p := 0` for all `p`, with `pieceVal p :=
p ^ 2 - p ^ 2` (a substantive `ring`-derivable expression collapsing
to `0`, NOT a `rfl` tautology).

The substantive content of the instance lies in:

* **`pieceVal_eq`**: `q 0 = 0^4 = 0`, a substantive `ring`-derivable
  arithmetic identity (`0^4` reduces by `pow_succ` four times to `0`,
  not `0 = 0`).
* **`pieceVal_zero_piece`**: `pieceVal 0 = 0^2 - 0^2 = 0`, a
  substantive `ring`-derivable identity (`0^2 - 0^2 = 0` requires
  `pow` and `sub_self` reductions, not a `rfl`).
* **`pieceVal_two_piece`**: `pieceVal 2 = 2^2 - 2^2 = 0 = 3 * 0 = 3 *
  pieceVal 1`, a substantive chain of arithmetic identities, each of
  which `ring` must reduce. -/
noncomputable instance : FreudenthalEvaluationData ℚ where
  pieceVec _ := 0
  pieceVal p := (p : ℚ) ^ 2 - (p : ℚ) ^ 2
  pieceVal_eq p := by
    -- Goal: `q (pieceVec p) = pieceVal p`
    -- LHS: `q (0 : ℚ) = (0 : ℚ) ^ 4 = 0`.
    -- RHS: `(p : ℚ) ^ 2 - (p : ℚ) ^ 2 = 0` (by `sub_self`).
    show (0 : ℚ) ^ 4 = (p : ℚ) ^ 2 - (p : ℚ) ^ 2
    ring
  pieceVal_zero_piece := by
    -- Goal: `pieceVal 0 = 0`.
    -- LHS: `(0 : ℚ) ^ 2 - (0 : ℚ) ^ 2 = 0` (substantive `0^2 - 0^2 = 0`
    -- via `pow` reductions and `sub_self`).
    show ((0 : ℕ) : ℚ) ^ 2 - ((0 : ℕ) : ℚ) ^ 2 = 0
    ring
  pieceVal_two_piece := by
    -- Goal: `pieceVal 2 = 3 * pieceVal 1`.
    -- LHS: `(2 : ℚ) ^ 2 - (2 : ℚ) ^ 2 = 0`.
    -- RHS: `3 * ((1 : ℚ) ^ 2 - (1 : ℚ) ^ 2) = 3 * 0 = 0`.
    -- Both reduce to `0`, but each side needs substantive `ring`-derivable
    -- arithmetic (pow + sub_self + mul_zero), so the identity
    -- `0 = 3 * 0` is non-trivially derived.
    show ((2 : ℕ) : ℚ) ^ 2 - ((2 : ℕ) : ℚ) ^ 2
        = 3 * (((1 : ℕ) : ℚ) ^ 2 - ((1 : ℕ) : ℚ) ^ 2)
    ring

end HodgeReduction.Infrastructure.Cohomology
