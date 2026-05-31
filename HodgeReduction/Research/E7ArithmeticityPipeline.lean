/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# E7 arithmeticity pipeline

Master tex labels:
`lem:fibre-density`, `prop:boundary-in-u7`, `prop:w0-flip`,
`thm:parabolic-density`, `thm:e7-arithmeticity`.

The master paper's Step 1 arithmeticity argument is a chain of deep geometric
and group-theoretic inputs.  This file formalizes only the dependency shape:
if the named inputs are supplied, the finite-index conclusion follows.  The
Borel density, Schmid/CKS, Bruhat/Chevalley, Steinberg, and
Matthews--Vaserstein--Weisfeiler ingredients remain separate import debt.
-/

namespace HodgeReduction

/--
Abstract data for the boundary-parabolic route to arithmeticity of E7-type
monodromy.

Each proposition field corresponds to one master-paper input.  The implication
fields record the proof architecture without pretending that the external
geometric or Chevalley-group theorems have been ported to Lean.
-/
structure E7ArithmeticityStep1Data where
  e7TypeVHS : Prop
  zariskiDenseMonodromy : Prop
  boundaryMonodromyInU7 : Prop
  fibreDensityForParabolics : Prop
  u7ParabolicDensity : Prop
  oppositeUnipotentExists : Prop
  oppositeU7ParabolicDensity : Prop
  rootPropagationAndModPSurjectivity : Prop
  finiteIndexInE7Z : Prop
  boundary_to_u7_density :
    e7TypeVHS ->
      zariskiDenseMonodromy ->
        boundaryMonodromyInU7 ->
          fibreDensityForParabolics ->
            u7ParabolicDensity
  w0_flip :
    zariskiDenseMonodromy ->
      u7ParabolicDensity ->
        oppositeUnipotentExists
  opposite_density :
    zariskiDenseMonodromy ->
      fibreDensityForParabolics ->
        oppositeUnipotentExists ->
          oppositeU7ParabolicDensity
  root_propagation_mvw :
    u7ParabolicDensity ->
      oppositeU7ParabolicDensity ->
        rootPropagationAndModPSurjectivity
  finite_index_of_modp :
    rootPropagationAndModPSurjectivity ->
      finiteIndexInE7Z

namespace E7ArithmeticityStep1Data

/-- The parabolic-density theorem is the first consumer of the boundary and
fibre-density inputs. -/
theorem parabolic_density
    (D : E7ArithmeticityStep1Data)
    (hVHS : D.e7TypeVHS)
    (hDense : D.zariskiDenseMonodromy)
    (hBoundary : D.boundaryMonodromyInU7)
    (hFibre : D.fibreDensityForParabolics) :
    D.u7ParabolicDensity :=
  D.boundary_to_u7_density hVHS hDense hBoundary hFibre

/-- Once density is known on both opposite unipotent radicals, the
root-propagation and MVW part gives finite index. -/
theorem arithmeticity_from_opposite_parabolic_densities
    (D : E7ArithmeticityStep1Data)
    (hU7 : D.u7ParabolicDensity)
    (hOpp : D.oppositeU7ParabolicDensity) :
    D.finiteIndexInE7Z :=
  D.finite_index_of_modp (D.root_propagation_mvw hU7 hOpp)

/-- Full dependency composition for the master-paper Step 1 route. -/
theorem arithmeticity_from_all_inputs
    (D : E7ArithmeticityStep1Data)
    (hVHS : D.e7TypeVHS)
    (hDense : D.zariskiDenseMonodromy)
    (hBoundary : D.boundaryMonodromyInU7)
    (hFibre : D.fibreDensityForParabolics) :
    D.finiteIndexInE7Z := by
  let hU7 : D.u7ParabolicDensity :=
    D.parabolic_density hVHS hDense hBoundary hFibre
  let hOppExists : D.oppositeUnipotentExists :=
    D.w0_flip hDense hU7
  let hOppDense : D.oppositeU7ParabolicDensity :=
    D.opposite_density hDense hFibre hOppExists
  exact D.arithmeticity_from_opposite_parabolic_densities hU7 hOppDense

end E7ArithmeticityStep1Data

/-- A minimal model showing why the boundary-monodromy input alone is not an
arithmeticity theorem. -/
def e7ArithmeticityMissingDensityCountermodel : E7ArithmeticityStep1Data where
  e7TypeVHS := True
  zariskiDenseMonodromy := True
  boundaryMonodromyInU7 := True
  fibreDensityForParabolics := False
  u7ParabolicDensity := False
  oppositeUnipotentExists := False
  oppositeU7ParabolicDensity := False
  rootPropagationAndModPSurjectivity := False
  finiteIndexInE7Z := False
  boundary_to_u7_density := fun _ _ _ hFibre => False.elim hFibre
  w0_flip := fun _ hU7 => False.elim hU7
  opposite_density := fun _ hFibre _ => False.elim hFibre
  root_propagation_mvw := fun hU7 _ => False.elim hU7
  finite_index_of_modp := fun hRoot => False.elim hRoot

/--
The E7 Step 1 proof cannot be compressed to "E7-type VHS + dense monodromy +
one boundary unipotent" without the fibre-density and root-propagation inputs.
-/
theorem e7_arithmeticity_not_from_boundary_data_alone :
    Not
      (forall D : E7ArithmeticityStep1Data,
        D.e7TypeVHS ->
          D.zariskiDenseMonodromy ->
            D.boundaryMonodromyInU7 ->
              D.finiteIndexInE7Z) := by
  intro h
  exact h e7ArithmeticityMissingDensityCountermodel trivial trivial trivial

end HodgeReduction
