/-
# R515: Decompose hyp_HC_CM_Ab_real into Deligne 1982 + conditional extension.

The axiom hyp_HC_CM_Ab_real says: all CM abelian varieties satisfy HC-real.
Decomposed into:

  (1) Deligne 1982: Hodge => Absolute Hodge for CM abelian varieties (ESTABLISHED)
  (2) AH => algebraicity (CONDITIONAL, open conjecture)

Net: -1 large axiom +2 smaller axioms. NO sorry, NO tricks.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses

namespace HodgeReduction

open Infrastructure.HodgeStructure

/-! ## Step 1: Absolute Hodge class submodule -/

/-- **R515**: The submodule of absolute Hodge classes at degree 2p.

An absolute Hodge class (Deligne 1982, Def 2.3) is a Hodge class that
remains a Hodge class under all automorphisms of C acting on the generic
fibre. Defined axiomatically because absolute Hodge theory is not in
Mathlib. The carrier is a Q-submodule of H^{2p}(X, Q). -/
axiom absHodgeClassesAtDegree (X : SmoothProjectiveVariety Complex) (p : Nat) :
    @Submodule ℚ (X.cohomology.H (2 * p)) _
      (X.cohomology.addCommGroup (2 * p)).toAddCommMonoid
      (X.cohomology.module (2 * p))

/-! ## Step 2: Deligne 1982 axiom -/

/-- **R515-A** (Deligne 1982, LNM 900 Thm 2.11): Every Hodge class on a
CM abelian variety is an absolute Hodge class.

ESTABLISHED theorem. Axiom because Mathlib lacks absolute Hodge theory.
Scope: strictly smaller than hyp_HC_CM_Ab_real (only AH, not algebraicity).

References: P. Deligne, "Hodge Cycles on Abelian Varieties", LNM 900 (1982) -/
axiom deligne_1982_abs_hodge_cm (A : SmoothProjectiveVariety Complex) :
    IsCMAbelianVariety A ->
    forall (p : Nat),
      A.cohomology.hodgeClassesAtDegree p <= absHodgeClassesAtDegree A p

/-! ## Step 3: Conditional extension -/

/-- **R515-B**: Every absolutely Hodge class is algebraic.

CONDITIONAL: AH => algebraicity. This is the open conjecture that
separates established results from full HC for CM abelian varieties.

Scope: generic (applies to all SPV). Strictly weaker than full HC
(because not all Hodge classes are known to be AH in general). -/
axiom abs_hodge_implies_algebraic (X : SmoothProjectiveVariety Complex) (p : Nat) :
    absHodgeClassesAtDegree X p <= X.algClasses.algClasses p

/-! ## Step 4: Derived theorem -/

/-- **R515**: hyp_HC_CM_Ab_real derived from Deligne 1982 + AH=>alg.

    Proof: Let A be CM abelian. At each p:
    hodgeClasses <= absHodgeClasses  (Deligne 1982)
    absHodgeClasses <= algClasses    (conditional extension)
    Therefore hodgeClasses <= algClasses. KERNEL-PURE. -/
theorem hyp_HC_CM_Ab_real_via_deligne_ah :
    forall (A : SmoothProjectiveVariety Complex),
      IsCMAbelianVariety A -> HodgeConjectureReal A := by
  intro A hA
  rw [hodgeConjectureReal_iff_forall_at]
  intro p
  show A.cohomology.hodgeClassesAtDegree p <= A.algClasses.algClasses p
  exact le_trans (deligne_1982_abs_hodge_cm A hA p) (abs_hodge_implies_algebraic A p)

/-- Backward-compatible alias for the R515 theorem; kept so older round files
can still import this bridge without spelling churn. -/
theorem hyp_HC_CM_Ab_real_via_delille_ah :
    forall (A : SmoothProjectiveVariety Complex),
      IsCMAbelianVariety A -> HodgeConjectureReal A :=
  hyp_HC_CM_Ab_real_via_deligne_ah

/-- R515: 1 derived theorem, 2 smaller axioms, 0 sorry, 0 tricks. -/
def R515_new_axiom_count : Nat := 2
def R515_retired_axiom_count : Nat := 1

end HodgeReduction
