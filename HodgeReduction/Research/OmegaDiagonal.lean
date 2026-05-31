/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Omega-diagonal status

Master tex label: `prop:omega-diagonal`.

The proposition gives a cohomology-level diagonal formula for the
`E_7`-invariant symplectic class.  The master paper then separates the
Chow-level obligations: the degree-3 Standard Conjecture B package, the
degree-3 Standard Conjecture C package, and the Schur projector onto the
`E_7`-invariant line.  The final Schur-projector step is circular at Chow
level: it is equivalent to algebraicity of the omega class itself.

This file records only that dependency shape and the relevant non-closure
certificates.  It does not formalize Kunneth projectors, Hard Lefschetz,
Schur theory for `V_56`, Standard Conjectures, or Chow motives.
-/

namespace HodgeReduction

/-- Dependency shape for `prop:omega-diagonal`. -/
structure OmegaDiagonalData where
  diagonalClassAlgebraic : Prop
  cohomologicalKunnethProjector : Prop
  standardConjectureB3 : Prop
  standardConjectureC3 : Prop
  schurProjectorChowAlgebraic : Prop
  omegaClassAlgebraic : Prop
  andreMotivatedB3C3 : Prop
  motivatedToChowDescent : Prop
  cohomologicalOmegaIdentity : Prop
  cohomological_identity_from_standard_package :
    cohomologicalKunnethProjector ->
      standardConjectureB3 ->
        standardConjectureC3 ->
          cohomologicalOmegaIdentity
  omega_from_chow_package :
    diagonalClassAlgebraic ->
      cohomologicalOmegaIdentity ->
        standardConjectureB3 ->
          standardConjectureC3 ->
            schurProjectorChowAlgebraic ->
              omegaClassAlgebraic
  schur_projector_from_omega :
    omegaClassAlgebraic -> schurProjectorChowAlgebraic
  omega_from_schur_projector :
    schurProjectorChowAlgebraic -> omegaClassAlgebraic
  andre_motivated_closure :
    andreMotivatedB3C3
  chow_standard_conjectures_from_motivated_descent :
    andreMotivatedB3C3 ->
      motivatedToChowDescent ->
        standardConjectureB3 ∧ standardConjectureC3

namespace OmegaDiagonalData

/-- The cohomological diagonal identity is available once the paper's
Kunneth/Lefschetz package is supplied. -/
theorem cohomological_identity_from_standard_conjecture_package
    (D : OmegaDiagonalData)
    (hKun : D.cohomologicalKunnethProjector)
    (hB3 : D.standardConjectureB3)
    (hC3 : D.standardConjectureC3) :
    D.cohomologicalOmegaIdentity :=
  D.cohomological_identity_from_standard_package hKun hB3 hC3

/-- The Chow-level omega conclusion needs the Schur projector in addition to
the diagonal formula and the degree-3 Standard Conjecture package. -/
theorem omega_algebraic_from_diagonal_standard_conjectures_and_schur
    (D : OmegaDiagonalData)
    (hDiag : D.diagonalClassAlgebraic)
    (hCoh : D.cohomologicalOmegaIdentity)
    (hB3 : D.standardConjectureB3)
    (hC3 : D.standardConjectureC3)
    (hSchur : D.schurProjectorChowAlgebraic) :
    D.omegaClassAlgebraic :=
  D.omega_from_chow_package hDiag hCoh hB3 hC3 hSchur

/-- The final Schur-projector step is equivalent to the desired omega
algebraicity conclusion in the current interface. -/
theorem schur_projector_step_iff_omega_algebraicity
    (D : OmegaDiagonalData) :
    D.schurProjectorChowAlgebraic ↔ D.omegaClassAlgebraic :=
  ⟨D.omega_from_schur_projector, D.schur_projector_from_omega⟩

/-- Andre's motivated-motive closure reaches Chow-level Standard
Conjectures only after an independent motivated-to-Chow descent input. -/
theorem chow_standard_conjectures_from_andre_descent
    (D : OmegaDiagonalData)
    (hDescent : D.motivatedToChowDescent) :
    D.standardConjectureB3 ∧ D.standardConjectureC3 :=
  D.chow_standard_conjectures_from_motivated_descent
    D.andre_motivated_closure hDescent

end OmegaDiagonalData

/-- A model in which the cohomological diagonal formula and the
`SC(B)_3`/`SC(C)_3` package hold, but the Schur projector and omega
algebraicity do not. -/
def omegaDiagonalNoSchurCountermodel : OmegaDiagonalData where
  diagonalClassAlgebraic := True
  cohomologicalKunnethProjector := True
  standardConjectureB3 := True
  standardConjectureC3 := True
  schurProjectorChowAlgebraic := False
  omegaClassAlgebraic := False
  andreMotivatedB3C3 := True
  motivatedToChowDescent := False
  cohomologicalOmegaIdentity := True
  cohomological_identity_from_standard_package := fun _ _ _ => trivial
  omega_from_chow_package := fun _ _ _ _ hSchur => False.elim hSchur
  schur_projector_from_omega := fun hOmega => False.elim hOmega
  omega_from_schur_projector := fun hSchur => False.elim hSchur
  andre_motivated_closure := trivial
  chow_standard_conjectures_from_motivated_descent :=
    fun _ hDescent => False.elim hDescent

/-- The cohomological diagonal identity plus `SC(B)_3` and `SC(C)_3` does
not self-close Chow algebraicity of the omega class. -/
theorem standard_conjecture_pair_does_not_self_close_omega_diagonal :
    Not
      (forall D : OmegaDiagonalData,
        D.diagonalClassAlgebraic ->
          D.cohomologicalOmegaIdentity ->
            D.standardConjectureB3 ->
              D.standardConjectureC3 ->
                D.omegaClassAlgebraic) := by
  intro h
  exact h omegaDiagonalNoSchurCountermodel trivial trivial trivial trivial

/-- The appendix-scope Andre motivated closure does not by itself descend to
Chow-level omega algebraicity. -/
theorem andre_motivated_closure_does_not_self_close_chow_omega :
    Not
      (forall D : OmegaDiagonalData,
        D.andreMotivatedB3C3 -> D.omegaClassAlgebraic) := by
  intro h
  exact h omegaDiagonalNoSchurCountermodel trivial

end HodgeReduction
