/-
# HC Gap L4 — `X² + 1` irreducible over ℚ + AdjoinRoot field (R284).

R280-R283 identified `Irreducible (X²+1 : ℚ[X])` as the smallest
blocker on the NumberField construction chain. R284 closes it via
Mathlib's `Polynomial.irreducible_iff_roots_eq_zero_of_degree_le_three`
(`SpecificDegree.lean:43`), then auto-derives
`Field GaussianAdjoinRootCandidate` via `AdjoinRoot.instField`.

## Mathlib path

* `Polynomial.irreducible_iff_roots_eq_zero_of_degree_le_three
  {p : K[X]} (hp2 : 2 ≤ p.natDegree) (hp3 : p.natDegree ≤ 3) :
    Irreducible p ↔ p.roots = 0` — `SpecificDegree.lean:43`.
* `AdjoinRoot.instField [Fact (Irreducible f)] : Field (AdjoinRoot f)`
  — `AdjoinRoot.lean:347`.

## What R284 (this file) provides (all kernel-pure)

* `GaussianPolynomialOverQ_no_root` — `∀ x : ℚ, x²+1 ≠ 0`.
* `GaussianPolynomialOverQ_roots_eq_zero` — the multiset of roots is
  empty.
* `GaussianPolynomialOverQ_irreducible` — irreducibility via the
  Mathlib degree-≤-3 lemma.
* `BlockingLemma_R281_X_sq_add_one_irreducible_over_Q_closed` —
  re-export of the irreducibility theorem, closing the R281 blocker.
* `instance : Fact (Irreducible GaussianPolynomialOverQ)` — required
  for `AdjoinRoot.instField`.
* `GaussianAdjoinRootCandidate_has_Field` — `Nonempty (Field ...)`.

## What R284 (this file) does NOT do

* Does NOT construct AlgEquiv (R285+ target).
* Does NOT lift reverse ring hom to fraction field (R285 target).
* Does NOT prove `FiniteDimensional ℚ GaussianRationalFieldCandidate`
  (still open on the fraction-field side).
* Does NOT prove `NumberField GaussianRationalFieldCandidate`.
* Does NOT close `canonicalE7ShimuraTor`.

All R284 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import Mathlib.Algebra.Polynomial.SpecificDegree
import Mathlib.RingTheory.AdjoinRoot

namespace HodgeReduction
namespace HCGapL4

open Polynomial

/-! ## Section 1: no rational root for `X² + 1` -/

/-- **R284** no rational root: `∀ x : ℚ, eval x (X²+1) ≠ 0`. -/
theorem GaussianPolynomialOverQ_no_root :
    ∀ x : ℚ, Polynomial.eval x GaussianPolynomialOverQ ≠ 0 := by
  intro x
  unfold GaussianPolynomialOverQ
  show Polynomial.eval x (X^2 + 1) ≠ 0
  simp only [eval_add, eval_pow, eval_X, eval_one]
  -- Goal: x^2 + 1 ≠ 0
  nlinarith [sq_nonneg x]

/-! ## Section 2: empty root multiset -/

/-- **R284** the multiset of roots of `X²+1` over ℚ is empty. -/
theorem GaussianPolynomialOverQ_roots_eq_zero :
    (GaussianPolynomialOverQ : ℚ[X]).roots = 0 := by
  apply Multiset.eq_zero_iff_forall_not_mem.mpr
  intro x hx
  rw [Polynomial.mem_roots GaussianPolynomialOverQ_ne_zero] at hx
  -- hx : IsRoot GaussianPolynomialOverQ x, i.e. eval x GaussianPolynomialOverQ = 0
  exact GaussianPolynomialOverQ_no_root x hx

/-! ## Section 3: irreducibility -/

/-- **R284** `X² + 1` is irreducible over ℚ. Closes the R281 blocking
lemma. -/
theorem GaussianPolynomialOverQ_irreducible :
    Irreducible (GaussianPolynomialOverQ : ℚ[X]) := by
  rw [Polynomial.irreducible_iff_roots_eq_zero_of_degree_le_three]
  · exact GaussianPolynomialOverQ_roots_eq_zero
  · -- 2 ≤ natDegree
    rw [GaussianPolynomialOverQ_natDegree_eq_two]
  · -- natDegree ≤ 3
    rw [GaussianPolynomialOverQ_natDegree_eq_two]
    decide

/-- **R284** closure of the R281 blocking lemma. -/
theorem BlockingLemma_R281_X_sq_add_one_irreducible_over_Q_closed :
    Irreducible (GaussianPolynomialOverQ : ℚ[X]) :=
  GaussianPolynomialOverQ_irreducible

/-! ## Section 4: AdjoinRoot field via Fact (Irreducible) -/

/-- **R284** register irreducibility as `Fact` for typeclass
inference. -/
instance GaussianPolynomialOverQ_irreducible_Fact :
    Fact (Irreducible GaussianPolynomialOverQ) :=
  ⟨GaussianPolynomialOverQ_irreducible⟩

/-- **R284** `GaussianAdjoinRootCandidate` is a `Field` — automatic
via `AdjoinRoot.instField` + the `Fact` instance above. -/
theorem GaussianAdjoinRootCandidate_has_Field :
    Nonempty (Field GaussianAdjoinRootCandidate) :=
  ⟨inferInstance⟩

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianPolynomialIrreducible_To_AdjoinRootField**: this
file's main bridge — irreducibility closure ⟹ `Field` on AdjoinRoot. -/
def L4_G_GaussianPolynomialIrreducible_To_AdjoinRootField : Prop := True

/-- **L4-G_GaussianPolynomialIrreducible_To_GaussianRationalAlgEquiv**:
next step (R285+): use the AdjoinRoot field structure to lift R281's
reverse ring hom to the fraction field, then construct AlgEquiv. -/
def L4_G_GaussianPolynomialIrreducible_To_GaussianRationalAlgEquiv :
    Prop := True

/-- **L4-G_GaussianPolynomialIrreducible_To_NumberField**: end target
of the chain — closing AlgEquiv gives finite-dim + NumberField on
the fraction-field side. -/
def L4_G_GaussianPolynomialIrreducible_To_NumberField : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R284 non-closure (1/5)**: does NOT construct AlgEquiv. -/
theorem R284_does_not_construct_algEquiv : True := trivial

/-- **R284 non-closure (2/5)**: does NOT prove `NumberField`. -/
theorem R284_does_not_prove_NumberField : True := trivial

/-- **R284 non-closure (3/5)**: does NOT prove `FiniteDimensional ℚ
GaussianRationalFieldCandidate`. -/
theorem R284_does_not_prove_finiteDimensional_on_FractionRing :
    True := trivial

/-- **R284 non-closure (4/5)**: does NOT lift the reverse ring hom
to the fraction field (R285 target). -/
theorem R284_does_not_lift_reverse_to_FractionRing : True := trivial

/-- **R284 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R284_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
