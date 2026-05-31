/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# The monodromy lattice gap as a non-implication

Master tex label: `prop:lattice-gap`.

The proposition in the master paper is a diagnostic statement: containment of
the monodromy image in an arithmetic lattice does not by itself prove that the
monodromy image has finite covolume.  This file formalizes that exact logical
shape as an abstract countermodel.  It does not assert anything negative about
the actual geometric `E_7` monodromy representation.
-/

namespace HodgeReduction

/--
The data available before an arithmeticity argument: a monodromy image is
contained in an ambient arithmetic lattice, and the ambient group is known to
be a lattice.  The finite-covolume property of the monodromy image is kept as a
separate field because it is not a consequence of the two preceding facts.
-/
structure MonodromyLatticeContainmentData where
  monodromyImage : Type
  arithmeticLattice : Type
  monodromyContainedInArithmeticLattice : Prop
  arithmeticLatticeFiniteCovolume : Prop
  monodromyFiniteCovolume : Prop

/-- A minimal abstract thin-subgroup model for the lattice gap. -/
def monodromyLatticeGapCountermodel : MonodromyLatticeContainmentData where
  monodromyImage := Unit
  arithmeticLattice := Unit
  monodromyContainedInArithmeticLattice := True
  arithmeticLatticeFiniteCovolume := True
  monodromyFiniteCovolume := False

/--
There is a model in which the containment and ambient-lattice facts hold while
the desired finite-covolume conclusion fails.
-/
theorem monodromy_lattice_gap_countermodel :
    Exists fun D : MonodromyLatticeContainmentData =>
      And D.monodromyContainedInArithmeticLattice
        (And D.arithmeticLatticeFiniteCovolume
          (Not D.monodromyFiniteCovolume)) := by
  refine ⟨monodromyLatticeGapCountermodel, ?_, ?_, ?_⟩
  · trivial
  · trivial
  · intro h
    exact h

/--
Containment in an ambient arithmetic lattice, even when the ambient lattice has
finite covolume, does not logically force finite covolume of the monodromy
image.
-/
theorem containment_in_arithmetic_lattice_does_not_force_finite_covolume :
    Not
      (forall D : MonodromyLatticeContainmentData,
        D.monodromyContainedInArithmeticLattice ->
          D.arithmeticLatticeFiniteCovolume ->
            D.monodromyFiniteCovolume) := by
  intro h
  exact h monodromyLatticeGapCountermodel trivial trivial

end HodgeReduction
