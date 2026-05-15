/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.MixedHodge

/-!
# Saito's mixed Hodge module framework

**M. Saito 1988** ("Modules de Hodge polarisables", Publ. RIMS 24)
constructs the category `MHM(X)` of **mixed Hodge modules** on a
complex variety `X`. This is a sheaf-theoretic enrichment of Deligne's
mixed Hodge structures, with:
* A perverse sheaf underlying.
* A filtered D-module.
* A weight filtration.
* Strict compatibility under standard sheaf operations.

For our HC application:
* The BBD/Saito IH-pullback (Saito 1988 + BBD 1982) preserves Hodge
  filtration.
* Variation of mixed Hodge structures over the base of a VHS family.

This file packages **abstract mixed Hodge module data**.

## Main definitions

* `MixedHodgeModuleData` : abstract MHM data.

## Tags

mixed Hodge module, Saito, perverse sheaf, D-module, BBD
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

/-- **Mixed Hodge module data** for a variety `X`:

* `MHMObject` : an abstract MHM as a type.
* `weight_bound` : the maximum weight occurring in `MHMObject`.

Full Saito theory requires perverse sheaves + filtered D-modules; we
abstract at the carrier level. -/
class MixedHodgeModuleData where
  /-- Abstract mixed Hodge module. -/
  MHMObject : Type
  /-- Maximum weight bound. -/
  weight_bound : ℤ

end HodgeReduction.Infrastructure.HodgeStructure
