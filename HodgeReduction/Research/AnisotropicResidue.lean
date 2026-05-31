/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

import HodgeReduction.ClassicalResults

/-!
# Isotropic core of the anisotropic-residue corollary

Master tex label: `cor:aniso_empty`.

The full corollary also asserts the witness-lattice conclusion obtained by a
Witt-cancellation iteration.  This file formalizes the kernel-checkable Meyer
part only: if `min(p, q) >= 4`, then every rational quadratic form of
signature `(p, q)` in the project's `RationalQuadraticForm` interface is
`QQ`-isotropic.
-/

namespace HodgeReduction

/-- If `min(p, q) >= 4`, then both signatures are positive and the total rank
is at least five. -/
theorem min_signature_ge_four_forces_meyer_hypotheses {p q : Nat}
    (hmin : 4 <= Nat.min p q) :
    (p >= 1 /\ q >= 1) /\ p + q >= 5 := by
  have hp4 : 4 <= p := Nat.le_trans hmin (Nat.min_le_left p q)
  have hq4 : 4 <= q := Nat.le_trans hmin (Nat.min_le_right p q)
  have hp1 : p >= 1 := Nat.le_trans (by decide : 1 <= 4) hp4
  have hq1 : q >= 1 := Nat.le_trans (by decide : 1 <= 4) hq4
  have hsum8 : 8 <= p + q := by
    simpa using Nat.add_le_add hp4 hq4
  have hsum5 : p + q >= 5 := Nat.le_trans (by decide : 5 <= 8) hsum8
  exact ⟨⟨hp1, hq1⟩, hsum5⟩

/--
Meyer eliminates the `QQ`-anisotropic residue at the isotropy level for
signatures with `min(p, q) >= 4`.
-/
theorem aniso_empty_isotropic_core {p q : Nat}
    (Q : RationalQuadraticForm p q) (hmin : 4 <= Nat.min p q) :
    Q.IsIsotropicQ := by
  have h := min_signature_ge_four_forces_meyer_hypotheses (p := p) (q := q) hmin
  exact meyer_hasse_minkowski Q h.1 h.2

end HodgeReduction
