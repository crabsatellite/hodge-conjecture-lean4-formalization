/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

import HodgeReduction.Types

/-!
# Witness Lattice Hypothesis

Master tex label: `def:WLH`.

This file records the paper's Witness Lattice Hypothesis as an abstract Lean
data structure.  The current project does not yet carry a concrete theory of
rational lattices inside quadratic spaces, so the lattice and orthogonal
complement are represented as semantic carriers with explicit signature
bookkeeping.  The kernel-checked theorem below formalizes the definition's
signature-additivity consequence: a witness of signature `(0, q - 2)` inside a
space of signature `(p, q)` has orthogonal complement signature `(p, 2)`.
-/

namespace HodgeReduction

/--
The Witness Lattice Hypothesis from the master paper.

For a rational quadratic form of signature `(p, q)` with `min(p, q) >= 4`,
WLH records a non-degenerate rational witness lattice of signature
`(0, q - 2)` and its orthogonal complement.  The actual lattice theory remains
opaque here; the structure pins down the formal semantic data needed by later
AHD reductions without asserting that any particular form satisfies WLH.
-/
structure WitnessLatticeHypothesis (p q : Nat) where
  form : RationalQuadraticForm p q
  min_signature_rank : 4 <= Nat.min p q
  p_ge_q : q <= p
  witnessLattice : Type*
  witnessNondegenerate : Prop
  witnessSignaturePositive : Nat
  witnessSignatureNegative : Nat
  witness_signature_positive_zero : witnessSignaturePositive = 0
  witness_signature_negative_eq : witnessSignatureNegative = q - 2
  orthogonalComplement : Type*
  complementSignaturePositive : Nat
  complementSignatureNegative : Nat
  signature_add_positive :
    witnessSignaturePositive + complementSignaturePositive = p
  signature_add_negative :
    witnessSignatureNegative + complementSignatureNegative = q

namespace WitnessLatticeHypothesis

variable {p q : Nat}

/-- The WLH witness condition forces `q >= 2`, so `q - 2` is the expected
negative signature contribution of the witness lattice. -/
theorem two_le_q (D : WitnessLatticeHypothesis p q) : 2 <= q := by
  have hq4 : 4 <= q := Nat.le_trans D.min_signature_rank (Nat.min_le_right p q)
  exact Nat.le_trans (by decide : 2 <= 4) hq4

/-- Positive-signature bookkeeping in the WLH split. -/
theorem complementSignaturePositive_eq (D : WitnessLatticeHypothesis p q) :
    D.complementSignaturePositive = p := by
  have h :
      0 + D.complementSignaturePositive = p := by
    simpa [D.witness_signature_positive_zero] using D.signature_add_positive
  simpa using h

/-- Negative-signature bookkeeping in the WLH split. -/
theorem complementSignatureNegative_eq_two (D : WitnessLatticeHypothesis p q) :
    D.complementSignatureNegative = 2 := by
  have hq_sub : q - 2 + 2 = q := Nat.sub_add_cancel (D.two_le_q)
  have h :
      q - 2 + D.complementSignatureNegative = q := by
    simpa [D.witness_signature_negative_eq] using D.signature_add_negative
  exact Nat.add_left_cancel (h.trans hq_sub.symm)

/--
The definition's stated consequence: the orthogonal complement has signature
`(p, 2)`.
-/
theorem orthogonalComplement_signature_eq_p_two
    (D : WitnessLatticeHypothesis p q) :
    D.complementSignaturePositive = p /\
      D.complementSignatureNegative = 2 :=
  ⟨D.complementSignaturePositive_eq, D.complementSignatureNegative_eq_two⟩

end WitnessLatticeHypothesis

end HodgeReduction
