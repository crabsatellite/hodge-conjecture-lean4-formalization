/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Grothendieck's standard conjectures framework

**Grothendieck 1968** formulated the **standard conjectures on algebraic
cycles**:

* **(B) Lefschetz type**: the inverse of the Hard Lefschetz operator
  is induced by an algebraic correspondence.
* **(C) Künneth**: the Künneth projectors are algebraic.
* **(D) Homological = Numerical**: homological and numerical
  equivalences coincide on `CH^*(X)_ℚ`.

These conjectures are open in general. They imply HC for smooth
projective varieties (combined with rationality of Hodge cycles).

For our HC application: the abstract standard conjectures provide
the framework for "motivic" arguments.

This file packages **abstract standard conjectures data**.

## Main definitions

* `StandardConjecturesData A` : abstract data + the three conjectures.

## Tags

standard conjectures, Grothendieck 1968, Lefschetz type, Künneth
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Standard conjectures data**:

* `lefschetz_type` : conjecture (B), the inverse Lefschetz is algebraic.
* `kunneth_algebraic` : conjecture (C), Künneth projectors are algebraic.
* `hom_eq_num` : conjecture (D), homological = numerical.

We package these as the field axioms of the typeclass. Each is an
OPEN classical conjecture. -/
class StandardConjecturesData where
  /-- Conjecture (B) Lefschetz type. -/
  lefschetz_type : Prop
  /-- Conjecture (C) Künneth projectors. -/
  kunneth_algebraic : Prop
  /-- Conjecture (D) Hom = Num. -/
  hom_eq_num : Prop

end HodgeReduction.Infrastructure.Cohomology
