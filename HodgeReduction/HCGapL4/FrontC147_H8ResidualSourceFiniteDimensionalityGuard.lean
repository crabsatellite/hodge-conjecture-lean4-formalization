/-
# HC Gap L4 -- Front C147: finite-dimensionality guard for the source rank route (R712).

R709/R710/R711 make the preferred source-native route:

* prove honest boundary data;
* prove h^4 in source_invariants;
* prove finite-dimensional source_invariants;
* prove finrank source_invariants <= 1.

This file records a kernel-checked guard on that third field.  In Lean,
`Module.finrank` is defined without a `FiniteDimensional` instance and is
zero on infinite-dimensional vector spaces.  Therefore the source rank bound
cannot replace the explicit finite-dimensionality obligation.

No geometry is asserted here.  The point is to prevent a future proof-search
agent from dropping the finite-dimensionality field as if it were implied by
the rank bound.
-/

import Mathlib.LinearAlgebra.FiniteDimensional
import HodgeReduction.MathlibCandidates
import HodgeReduction.HCGapL4.FrontC146_H8ResidualSourceFiniteRankToCarrierSplit

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC147_H8ResidualSourceFiniteDimensionalityGuard

noncomputable section

/-- A deliberately infinite-dimensional source carrier used only to expose the
`finrank` guard. -/
abbrev InfinitePolynomialSource := Polynomial Rat

/-- A top-like source-invariant carrier, written explicitly as `Set.univ` to
avoid relying on notation in the guard proof. -/
def polynomialSourceInvariantCarrier : Submodule Rat InfinitePolynomialSource where
  carrier := Set.univ
  zero_mem' := by
    trivial
  add_mem' := by
    intro _ _ _ _
    trivial
  smul_mem' := by
    intro _ _ _
    trivial

/-- **R712 guard theorem (1/5)**: the polynomial source carrier is not
finite-dimensional over `Rat`.  The proof consumes the existing kernel-checked
linear independence of the monomial powers. -/
theorem polynomialSource_not_finiteDimensional :
    Not (FiniteDimensional Rat InfinitePolynomialSource) := by
  intro hfin
  have hlt : Cardinal.mk Nat < Cardinal.aleph0 := by
    letI := hfin
    exact
      HodgeReduction.MathlibCandidates.Polynomial.linearIndependent_X_pow
        |>.lt_aleph0_of_finiteDimensional
  rw [Cardinal.mk_nat] at hlt
  exact (lt_irrefl Cardinal.aleph0) hlt

/-- **R712 guard theorem (2/5)**: the explicit source-invariant carrier is
also not finite-dimensional. -/
theorem polynomialSourceInvariantCarrier_not_finiteDimensional :
    Not (FiniteDimensional Rat polynomialSourceInvariantCarrier) := by
  intro hcarrier
  haveI : FiniteDimensional Rat polynomialSourceInvariantCarrier := hcarrier
  have hsurj : Function.Surjective polynomialSourceInvariantCarrier.subtype := by
    intro x
    exact Exists.intro (Subtype.mk x (by trivial)) rfl
  haveI : FiniteDimensional Rat InfinitePolynomialSource :=
    FiniteDimensional.of_surjective polynomialSourceInvariantCarrier.subtype hsurj
  exact polynomialSource_not_finiteDimensional inferInstance

/-- **R712 guard theorem (3/5)**: despite not being finite-dimensional, this
source-invariant carrier satisfies the naked `finrank <= 1` inequality because
`finrank` is zero for infinite-dimensional vector spaces. -/
theorem polynomialSourceInvariantCarrier_finrank_le_one :
    Module.finrank Rat polynomialSourceInvariantCarrier <= 1 := by
  rw [Module.finrank_of_infinite_dimensional
    polynomialSourceInvariantCarrier_not_finiteDimensional]
  norm_num

/-- **R712 guard theorem (4/5)**: the rank bound alone does not provide the
finite-dimensionality field required by R709/R710/R711. -/
theorem source_finrank_le_one_does_not_force_source_finiteDimensionality :
    And
      (Module.finrank Rat polynomialSourceInvariantCarrier <= 1)
      (Not (FiniteDimensional Rat polynomialSourceInvariantCarrier)) :=
  And.intro
    polynomialSourceInvariantCarrier_finrank_le_one
    polynomialSourceInvariantCarrier_not_finiteDimensional

end

/-- R712 guard target names for route summaries. -/
def currentR712SourceFiniteDimensionalityGuardTargetNames : List String := [
  "do not replace finite-dimensional source_invariants by finrank source_invariants <= 1"
]

/-- Machine-readable status for the R712 source finite-dimensionality guard. -/
structure R712SourceFiniteDimensionalityGuardSnapshot where
  guardObligationCount : Nat
  finrankCanBeZeroWithoutFiniteDimensionality : Bool
  sourceRankBoundAloneCanBeVacuous : Bool
  finiteDimensionalityStillRequiredInR711 : Bool
  remainingSourceRouteObligationCount : Nat
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R712 status: this is a deadend/guard, not theorem closure. -/
def currentR712SourceFiniteDimensionalityGuardSnapshot :
    R712SourceFiniteDimensionalityGuardSnapshot where
  guardObligationCount :=
    currentR712SourceFiniteDimensionalityGuardTargetNames.length
  finrankCanBeZeroWithoutFiniteDimensionality := true
  sourceRankBoundAloneCanBeVacuous := true
  finiteDimensionalityStillRequiredInR711 := true
  remainingSourceRouteObligationCount := 4
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R712 guard theorem (5/5)**: kernel-checked status for the finite-rank
guard. -/
theorem currentR712SourceFiniteDimensionalityGuardSnapshot_eq_texStatus :
    currentR712SourceFiniteDimensionalityGuardSnapshot =
      ({ guardObligationCount := 1
         finrankCanBeZeroWithoutFiniteDimensionality := true
         sourceRankBoundAloneCanBeVacuous := true
         finiteDimensionalityStillRequiredInR711 := true
         remainingSourceRouteObligationCount := 4
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R712SourceFiniteDimensionalityGuardSnapshot) := by
  decide

/-- Kernel-checked target names for the R712 guard. -/
theorem currentR712SourceFiniteDimensionalityGuardTargetNames_eq_texStatus :
    currentR712SourceFiniteDimensionalityGuardTargetNames = [
      "do not replace finite-dimensional source_invariants by finrank source_invariants <= 1"
    ] := by
  rfl

def R712_substantiveTheoremCount : Nat := 5

end FrontC147_H8ResidualSourceFiniteDimensionalityGuard
end HCGapL4
end HodgeReduction
