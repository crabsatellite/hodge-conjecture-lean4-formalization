/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# E7 Chern-Weil bridge

Master tex label: `hyp:ChernWeil-bridge-E7`.

The master paper separates three inputs for the Freudenthal-quartic
Chern-Weil argument:

* the Schwarz/Sato-Kimura invariant-ring computation
  `C[V56]^E7 = C[q]`;
* a bridge from the Schwarz invariant `q` to a non-zero compact-dual
  degree-8 class;
* descent to the non-cocompact toroidal quotient and identification with a
  rational polynomial in Chern classes of the canonical extension.

This file formalizes only that dependency shape.  It does not construct the
Schwarz-to-cohomology bridge, Matsushima descent, Mumford good-metric boundary
compatibility, or the explicit Freudenthal Chern polynomial.
-/

namespace HodgeReduction

/--
Abstract dependency shape for Hypothesis `hyp:ChernWeil-bridge-E7`.

The fields deliberately separate the classical invariant-ring input from the
two conditional bridge clauses.  In particular, `schwarzInvariantRing` is not
allowed to imply `q4AlgebraicOnToroidalQuotient` without the compact-dual
bridge, non-cocompact boundary compatibility, and Chern-polynomial identity.
-/
structure E7ChernWeilBridgeData where
  schwarzInvariantRing : Prop
  compactDualBridge : Prop
  compactDualQ4Nonzero : Prop
  cocompactMatsushimaDescent : Prop
  noncompactBoundaryCompatibility : Prop
  toroidalQ4Class : Prop
  chernPolynomialIdentity : Prop
  q4AlgebraicOnToroidalQuotient : Prop
  compact_dual_from_schwarz :
    schwarzInvariantRing ->
      compactDualBridge ->
        compactDualQ4Nonzero
  toroidal_from_matsushima :
    compactDualQ4Nonzero ->
      cocompactMatsushimaDescent ->
        noncompactBoundaryCompatibility ->
          toroidalQ4Class
  algebraic_from_chern_polynomial :
    toroidalQ4Class ->
      chernPolynomialIdentity ->
        q4AlgebraicOnToroidalQuotient

namespace E7ChernWeilBridgeData

/-- Clause (i): the Schwarz invariant-ring computation must be paired with the
extra compact-dual bridge to produce the non-zero degree-8 compact-dual class. -/
theorem compact_dual_nonzero_from_schwarz_bridge
    (D : E7ChernWeilBridgeData)
    (hSchwarz : D.schwarzInvariantRing)
    (hBridge : D.compactDualBridge) :
    D.compactDualQ4Nonzero :=
  D.compact_dual_from_schwarz hSchwarz hBridge

/-- Clause (ii): compact-dual non-vanishing descends to the toroidal quotient
only after both the Matsushima input and the non-cocompact boundary
compatibility are supplied. -/
theorem toroidal_class_from_matsushima_descent
    (D : E7ChernWeilBridgeData)
    (hCompact : D.compactDualQ4Nonzero)
    (hMatsushima : D.cocompactMatsushimaDescent)
    (hBoundary : D.noncompactBoundaryCompatibility) :
    D.toroidalQ4Class :=
  D.toroidal_from_matsushima hCompact hMatsushima hBoundary

/-- Clause (iii): the toroidal class is algebraic once it is identified with
a rational polynomial in Chern classes of the canonical extension. -/
theorem algebraicity_from_chern_polynomial_identity
    (D : E7ChernWeilBridgeData)
    (hToroidal : D.toroidalQ4Class)
    (hPolynomial : D.chernPolynomialIdentity) :
    D.q4AlgebraicOnToroidalQuotient :=
  D.algebraic_from_chern_polynomial hToroidal hPolynomial

/-- Full dependency composition for the master-paper Chern-Weil bridge. -/
theorem e7_chern_weil_algebraicity_from_full_bridge
    (D : E7ChernWeilBridgeData)
    (hSchwarz : D.schwarzInvariantRing)
    (hBridge : D.compactDualBridge)
    (hMatsushima : D.cocompactMatsushimaDescent)
    (hBoundary : D.noncompactBoundaryCompatibility)
    (hPolynomial : D.chernPolynomialIdentity) :
    D.q4AlgebraicOnToroidalQuotient := by
  let hCompact : D.compactDualQ4Nonzero :=
    D.compact_dual_nonzero_from_schwarz_bridge hSchwarz hBridge
  let hToroidal : D.toroidalQ4Class :=
    D.toroidal_class_from_matsushima_descent hCompact hMatsushima hBoundary
  exact D.algebraicity_from_chern_polynomial_identity hToroidal hPolynomial

end E7ChernWeilBridgeData

/-- A model where the classical Schwarz invariant-ring statement holds but the
compact-dual bridge and toroidal algebraicity conclusion are absent. -/
def schwarzRingAloneNoChernWeilCountermodel : E7ChernWeilBridgeData where
  schwarzInvariantRing := True
  compactDualBridge := False
  compactDualQ4Nonzero := False
  cocompactMatsushimaDescent := False
  noncompactBoundaryCompatibility := False
  toroidalQ4Class := False
  chernPolynomialIdentity := False
  q4AlgebraicOnToroidalQuotient := False
  compact_dual_from_schwarz := fun _ hBridge => False.elim hBridge
  toroidal_from_matsushima := fun hCompact _ _ => False.elim hCompact
  algebraic_from_chern_polynomial := fun hToroidal _ => False.elim hToroidal

/--
The Schwarz/Sato-Kimura invariant-ring computation alone does not close the
E7 Chern-Weil bridge.
-/
theorem schwarz_invariant_ring_does_not_self_close_e7_chern_weil :
    Not
      (forall D : E7ChernWeilBridgeData,
        D.schwarzInvariantRing ->
          D.q4AlgebraicOnToroidalQuotient) := by
  intro h
  exact h schwarzRingAloneNoChernWeilCountermodel trivial

/-- A model where cocompact Matsushima descent is available but the actual
non-cocompact boundary compatibility required by the paper is absent. -/
def cocompactOnlyNoNoncompactBoundaryCountermodel : E7ChernWeilBridgeData where
  schwarzInvariantRing := True
  compactDualBridge := True
  compactDualQ4Nonzero := True
  cocompactMatsushimaDescent := True
  noncompactBoundaryCompatibility := False
  toroidalQ4Class := False
  chernPolynomialIdentity := True
  q4AlgebraicOnToroidalQuotient := False
  compact_dual_from_schwarz := fun _ _ => trivial
  toroidal_from_matsushima := fun _ _ hBoundary => False.elim hBoundary
  algebraic_from_chern_polynomial := fun hToroidal _ => False.elim hToroidal

/--
Cocompact Matsushima descent plus the Schwarz bridge does not by itself supply
the non-cocompact toroidal Chern-Weil conclusion used by the master paper.
-/
theorem cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil :
    Not
      (forall D : E7ChernWeilBridgeData,
        D.schwarzInvariantRing ->
          D.compactDualBridge ->
            D.cocompactMatsushimaDescent ->
              D.chernPolynomialIdentity ->
                D.q4AlgebraicOnToroidalQuotient) := by
  intro h
  exact h cocompactOnlyNoNoncompactBoundaryCountermodel trivial trivial trivial trivial

end HodgeReduction
