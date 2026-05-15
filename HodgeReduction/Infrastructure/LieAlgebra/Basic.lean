/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Lie.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Exceptional Lie algebra framework

The exceptional Lie algebras `e_6, e_7, e_8` (78-, 133-, 248-dimensional)
are the foundation for the Mumford-Tate reduction. Specifically:

* `e_{7(-25)}` : the real form of `e_7` with signature `-25` (a
  Hermitian symmetric Lie algebra of compact type).
* `e_6` : the Levi component of `e_{7(-25)}` minus the U(1) center.

For our HC application, we abstract these:
* The 7-dim Cartan subalgebra of `e_7`.
* The 78-dim adjoint representation of `e_6`.
* The 27-dim minuscule representation `V_27` (= `J_3(O)` as `e_6`-module).
* The 56-dim minuscule representation `V_56` of `e_7`.

This file provides **abstract Lie algebra data** for the exceptional
types.

## Main definitions

* `LieAlgebraData R` : abstract Lie algebra over `R`.

## Tags

Lie algebra, exceptional, E_6, E_7, root system, minuscule
-/

namespace HodgeReduction.Infrastructure.LieAlgebra

variable (R : Type*) [CommRing R]

/-- **Abstract Lie algebra data** over a commutative ring `R`.
A wrapper for use with Mathlib's `LieAlgebra` typeclass.

For our application: `R = ℚ` and the Lie algebra is one of the
exceptional `e_6, e_7, e_8`. -/
class LieAlgebraData where
  /-- The underlying type. -/
  L : Type
  /-- The dimension of `L` over `R` (for finite-dim case). -/
  dim : ℕ

end HodgeReduction.Infrastructure.LieAlgebra
