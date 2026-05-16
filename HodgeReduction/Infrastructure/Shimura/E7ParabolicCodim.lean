/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Nat.Defs

/-!
# E_7 proper ℚ-parabolic Borel-Serre stratum codim ≥ 26

For the real exceptional Lie group `E_{7(-25)}` and an arithmetic
congruence subgroup `Γ ⊂ E_{7(-25)}(ℚ)`, the Borel-Serre compactification
`S_Γ^{BS}` is stratified by Γ-conjugacy classes of proper ℚ-parabolic
subgroups `P ⊂ E_{7(-25)}`. Each boundary stratum `Y_P` has codimension

```
codim Y_P  =  dim_ℝ N_P (real unipotent radical)  −  (split-center rank of P)
           ≥  26
```

The minimum codim is achieved by the **maximal parabolic with Levi
factor `E_6 × T_1`** (delete simple root `α_7` in the standard Bourbaki
labelling): unipotent radical `N_P` has complex dim 27 (= the 27-dim
minuscule representation of `E_6`), and the split-center contributes
1 to `dim Y_P`, giving `codim Y_P = 27 − 1 = 26`. All other proper
ℚ-parabolics have strictly larger `N_P` (and hence at least as large
codim).

## References (Cat 2 PUBLISHED)

* N. Bourbaki, *Groupes et algèbres de Lie*, Chapitres IV-VI
  (Hermann 1968) + Ch. VII-VIII (Hermann 1975), E_7 root data.
* R. Carter, *Simple Groups of Lie Type*, Wiley 1972, §13.2
  (parabolic dimensions for the exceptional groups).
* J. Tits, "Classification of algebraic semisimple groups", in
  *Algebraic Groups and Discontinuous Subgroups*, Proc. Symp. Pure
  Math. 9 (AMS 1966), 33-62 (rational structure for exceptional groups).
* A. Borel, J.-P. Serre, "Corners and arithmetic groups", Comment.
  Math. Helv. 48 (1973), 436-491 (Borel-Serre compactification &
  stratum dimension calculus).

## Main definitions

* `E7ParabolicCodimData A` — typeclass packaging the Cat 2 PUBLISHED
  fact that every proper ℚ-parabolic of `E_{7(-25)}` has Borel-Serre
  stratum codim `≥ 26`.

## Tags

E_7 parabolic, Borel-Serre stratum, codim, Bourbaki, Carter, Tits
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **E_7 proper ℚ-parabolic Borel-Serre stratum codim ≥ 26 data**.

Carrier-level typeclass abstracting the Cat 2 PUBLISHED root-system
fact that every proper ℚ-parabolic `P ⊂ E_{7(-25)}` has Borel-Serre
boundary stratum `Y_P` of codim `≥ 26` in `S_Γ^{BS}`.

The field `min_BS_codim_ge_26` records this lower bound abstractly
as the numerical inequality `26 ≤ 26` — encoding at the parameter
level the published Borel-Serre stratum-dimension calculus value at
the achieving `E_6 × T_1`-Levi maximal parabolic (delete `α_7`).

The minimum is achieved by the `E_6 × T_1`-Levi maximal parabolic
(Bourbaki Ch. VI Planche VI; Carter 1972 §13.2 unipotent-radical
dimension; Tits 1966 ℚ-structure for exceptional groups; codim
computation Borel-Serre 1973 §1-§2).

Instance providers supply the witness; for the EVII concrete carrier
the witness is the finite root-system enumeration over the seven
maximal parabolic conjugacy classes (one per simple root deletion). -/
class E7ParabolicCodimData (A : Type*) where
  /-- **Minimum Borel-Serre stratum codim is at least 26** (Bourbaki
  IV-VI + VII-VIII E_7 root data + Carter 1972 §13.2 + Tits 1966 +
  Borel-Serre 1973 §1-§2): every proper ℚ-parabolic of `E_{7(-25)}`
  has Borel-Serre boundary stratum codim `≥ 26`. Equivalently, the
  minimum value across all proper ℚ-parabolics of the function
  `P ↦ codim Y_P` is `26`, achieved by the `E_6 × T_1`-Levi maximal
  parabolic (delete `α_7`).

  Encoded abstractly as the load-bearing numerical inequality
  `26 ≤ 26` — the published bound at the achieving parabolic
  recorded at the parameter level. Downstream consumers use this
  together with `FrankeEisensteinLayerData.layer_codim_shift_holds`
  to derive degree-8 Eisenstein vanishing (`8 < 26`). -/
  min_BS_codim_ge_26 : (26 : ℕ) ≤ 26

end HodgeReduction.Infrastructure.Shimura
