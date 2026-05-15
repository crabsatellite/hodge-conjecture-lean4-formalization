/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.V56HodgeDecomp
import HodgeReduction.Infrastructure.LinearMaps

/-!
# V_56 as a polarised pure ℚ-Hodge structure of weight 3

This file wires the existing `V_56` Hodge decomposition infrastructure
(`Infrastructure/V56HodgeDecomp.lean` + `Infrastructure/V56HodgeRank.lean`)
into the abstract `PureHodgeStructure` / `PolarisedHodgeStructure`
typeclass framework.

The V_56 Hodge decomposition is:
```
V_56 = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}
     =   ℚ    ⊕  J_3(O) ⊕  J_3(O) ⊕   ℚ
     dim = 1  +    27   +    27   +    1   = 56
```

The polarisation is the symplectic form `ω : V_56 × V_56 → ℚ`
(non-degenerate, antisymmetric — weight 3 is ODD).

## Main definitions

* `V56.pieceByFin` : `Fin 4 → Submodule ℚ V_56` mapping `0 ↦ V^{3,0}`,
  `1 ↦ V^{2,1}`, `2 ↦ V^{1,2}`, `3 ↦ V^{0,3}`.

The full `PureHodgeStructure V56 3` instance requires proving
`DirectSum.IsInternal pieceByFin`, which is the
"unique-decomposition" property of the Hodge bigrading. We defer
this proof and document the path.

## Tags

V_56, Hodge structure, weight 3, Freudenthal triple system, EVII
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

namespace V56

open HodgeReduction.Infrastructure.V56

/-- The four `(p, 3-p)`-Hodge pieces of `V_56` indexed by
`Fin 4 = {0, 1, 2, 3}`:

* `pieceByFin 0 = V^{3,0}`  (1-dim, charge +3 line)
* `pieceByFin 1 = V^{2,1}`  (27-dim, J_3(O) piece, charge +1)
* `pieceByFin 2 = V^{1,2}`  (27-dim, J_3(O) piece, charge -1)
* `pieceByFin 3 = V^{0,3}`  (1-dim, charge -3 line) -/
def pieceByFin : Fin 4 → Submodule ℚ HodgeReduction.Infrastructure.V56
  | ⟨0, _⟩ => Hodge_3_0
  | ⟨1, _⟩ => Hodge_2_1
  | ⟨2, _⟩ => Hodge_1_2
  | ⟨3, _⟩ => Hodge_0_3
  | ⟨n + 4, h⟩ => absurd h (by omega)

@[simp] theorem pieceByFin_0 : pieceByFin ⟨0, by omega⟩ = Hodge_3_0 := rfl
@[simp] theorem pieceByFin_1 : pieceByFin ⟨1, by omega⟩ = Hodge_2_1 := rfl
@[simp] theorem pieceByFin_2 : pieceByFin ⟨2, by omega⟩ = Hodge_1_2 := rfl
@[simp] theorem pieceByFin_3 : pieceByFin ⟨3, by omega⟩ = Hodge_0_3 := rfl

end V56

end HodgeReduction.Infrastructure.HodgeStructure
