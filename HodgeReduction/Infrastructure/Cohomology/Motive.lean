/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Pure motive framework (Grothendieck 1968)

**Pure motives** (Grothendieck 1968 letter to Bombieri, Manin 1968,
Deligne 1971) are the universal cohomology theory for smooth projective
varieties: a category `Mot_∼` parametrised by an adequate equivalence
relation `∼` on cycles (rational, homological, numerical, etc.).

Conjectures of Grothendieck:
* The standard conjectures (Lefschetz type, Künneth, etc.).
* These imply that homological and numerical equivalences coincide.
* The Hodge conjecture is equivalent to saying that Hodge classes are
  represented by classes of motives.

For our HC application: the abstract motive language gives the
"target category" for cycle class maps and Hodge realisations.

This file packages **abstract pure motive data**.

## Main definitions

* `PureMotiveData` : abstract pure motive (carrier).

## Tags

pure motive, Grothendieck, adequate equivalence, motivic Galois
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Pure motive data**:

* `Motive` : the abstract motive type.
* `weight` : the weight of the motive.

The full motive category requires substantial categorical infrastructure
(adequate equivalence + correspondences + idempotents). We abstract at
the object level. -/
class PureMotiveData where
  /-- The abstract motive. -/
  Motive : Type
  /-- Weight of the motive. -/
  weight : ℤ

end HodgeReduction.Infrastructure.Cohomology
