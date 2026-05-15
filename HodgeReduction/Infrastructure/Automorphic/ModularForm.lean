/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Automorphic / modular form framework

An **automorphic form** for an arithmetic group `Γ ⊆ G(ℚ)` on a
Hermitian symmetric domain `X = G/K` is a function `f : X → V`
(taking values in an automorphic representation) satisfying:
* `f(γ · x) = j(γ, x) f(x)` for all `γ ∈ Γ` (automorphy condition).
* Growth at infinity (e.g., bounded, or moderate growth).
* Holomorphy conditions (for holomorphic automorphic forms).

For our HC application: automorphic vector bundles on `S_Γ` carry
automorphic forms as sections, and their `c_i` give algebraic
cohomology classes (BKK 2007 + Harris 1985).

This file packages **abstract automorphic form data**.

## Main definitions

* `AutomorphicFormData` : automorphic forms as ℚ-vector space.

## Tags

automorphic form, modular form, holomorphic, automorphic bundle
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Automorphic form data**:

* `AutoForm` : the ℚ-vector space of automorphic forms.
* `weight` : the weight of the automorphy factor.

Different choices of weight give different automorphic bundle Chern
classes. -/
class AutomorphicFormData where
  /-- The ℚ-vector space of automorphic forms (of fixed weight). -/
  AutoForm : Type
  /-- The weight. -/
  weight : ℤ

end HodgeReduction.Infrastructure.Automorphic
