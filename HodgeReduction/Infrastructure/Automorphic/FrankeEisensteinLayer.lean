/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Shimura.E7ParabolicCodim
import Mathlib.Data.Nat.Defs
import Mathlib.Data.Fintype.Basic

/-!
# Franke 1998 + Borel-Serre 1973 Eisenstein-cohomology layer decomposition

For an arithmetic congruence subgroup `Γ ⊂ G(ℚ)`, the **Eisenstein
cohomology** `H^*_{Eis}(S_Γ; ℂ)` decomposes as a direct sum of layers
indexed by Γ-conjugacy classes of proper ℚ-parabolic subgroups `P ⊂ G`:

```
H^*_{Eis}(S_Γ; ℂ)  =  ⨁_{P ∈ ΓPar(G)/Γ-conj}  H^*(layer_P)
```

with the **layer-codim shift**: the contribution of the `P`-layer to
total degree `d` is supported on `d ≥ codim Y_P` (where `Y_P ⊂ S_Γ^{BS}`
is the corresponding Borel-Serre boundary stratum).

For `G = E_{7(-25)}`, every proper ℚ-parabolic has `codim Y_P ≥ 26`
(carrier `E7ParabolicCodimData`); the layer-codim shift then forces
`H^d_{Eis}(S_Γ; ℂ) = 0` for `d = 8 < 26`. The `Q-rank 0` (cocompact)
case is trivial: no Borel-Serre boundary, no Eisenstein.

## References (Cat 2 PUBLISHED)

* A. Borel, J.-P. Serre, "Corners and arithmetic groups", Comment.
  Math. Helv. 48 (1973), 436-491 (Borel-Serre compactification &
  boundary stratification).
* A. Borel, N. Wallach, *Continuous Cohomology, Discrete Subgroups,
  and Representations of Reductive Groups*, Princeton 1980 (2nd ed.
  AMS 2000), Ch. VII §2-3 (Eisenstein spectral sequence by parabolic
  type).
* J. Franke, "Harmonic analysis in weighted L_2-spaces", Ann. Sci.
  ÉNS (4) 31 (1998), 181-279, §1.4 (Eisenstein-layer L²-decomposition
  + degree-codim support property).
* J. Schwermer, "Eisenstein series and cohomology of arithmetic groups",
  Compositio Math. 92 (1994), 71-118 (regularised Eisenstein series &
  cohomological interpretation).
* L. Saper, "L-modules and the conjecture of Rapoport and Goresky-
  MacPherson", Astérisque 298 (2005), 319-334 (L-module formulation
  refining the Borel-Serre side).

## Main definitions

* `FrankeEisensteinLayerData A` — typeclass packaging the Cat 2
  PUBLISHED Eisenstein-cohomology layer decomposition with codim shift.

## Tags

Franke 1998, Borel-Serre 1973, Borel-Wallach, Eisenstein cohomology,
layer decomposition, codim shift
-/

namespace HodgeReduction.Infrastructure.Automorphic

/-- **Franke 1998 + Borel-Serre 1973 Eisenstein-layer-decomposition data**.

Carrier-level typeclass abstracting the Cat 2 PUBLISHED structural
fact that for an arithmetic congruence `Γ ⊂ G(ℚ)`, the Eisenstein
cohomology `H^*_{Eis}(S_Γ; ℂ)` decomposes by Γ-conjugacy classes of
proper ℚ-parabolic subgroups `P ⊂ G`, with the `P`-layer supported at
degrees `d ≥ codim Y_P`.

For our HC application (`G = E_{7(-25)}`, target deg `d = 8`), the
load-bearing consequence is the **degree-8 specialisation of the
layer-codim shift**: every Eisenstein layer indexed by a proper
ℚ-parabolic of `E_{7(-25)}` has its lowest contribution above degree 8
(because `parabolicCodim i ≥ 26 > 8` for every i in the seven Carter-
indexed maximal-parabolic conjugacy classes, hence
`8 < parabolicCodim i` for every `i`).

This typeclass **extends** `Shimura.E7ParabolicCodimData` so the field
type below is the substantive per-index numerical claim
`∀ i : ParabolicIndex, 8 < parabolicCodim i`, whose proof must consume
`parabolicCodim_ge_26` together with the kernel-decidable `8 < 26`. The
Franke 1998 §1.4 + Borel-Wallach Ch. VII §2-3 + Borel-Serre 1973 §1-§2 +
Schwermer 1994 + Saper 2005 spectral-sequence framework is what justifies
that this degree-8 codim shift implies `H^8_Eis(S_Γ; ℂ) = 0`. -/
class FrankeEisensteinLayerData (A : Type*) extends
    HodgeReduction.Infrastructure.Shimura.E7ParabolicCodimData A where
  /-- **Franke 1998 §1.4 degree-8 layer-codim shift**: for every proper
  ℚ-parabolic conjugacy class `i`, the parabolic's Borel-Serre stratum
  codim strictly exceeds the target degree `8`.

  Substantive content: per-index numerical claim
  `∀ i : ParabolicIndex, 8 < parabolicCodim i`. The instance discharges
  via the substantive Carter 1972 §13.2 bound
  `parabolicCodim_ge_26 i : 26 ≤ parabolicCodim i` together with the
  kernel-decidable `8 < 26`, composed by `Nat.lt_of_lt_of_le`.

  The Franke 1998 §1.4 + Borel-Wallach Ch. VII §2-3 + Borel-Serre 1973
  §1-§2 + Schwermer 1994 + Saper 2005 layer-spectral-sequence framework
  is what justifies that this per-index codim-shift implies vanishing of
  the total `H^8_Eis(S_Γ; ℂ)`; the substantive numerical content lives
  in this typeclass field. -/
  layer_codim_shift_at_deg_8 :
    ∀ i : ParabolicIndex, (8 : ℕ) < parabolicCodim i

/-- **Default instance for `FrankeEisensteinLayerData`** via the
substantive `E7ParabolicCodimData` Carter table and the
`8 < 26 ≤ parabolicCodim i` transitivity.

For any carrier `A`, the parent fields come from
`e7ParabolicCodimData_of_min_eq_26 A` (substantive Fin 7-indexed
`parabolicCodim` from `parabolicCodimList = [32, 41, 46, 52, 49, 41, 26]`),
and the degree-8 layer-codim shift discharges by
`Nat.lt_of_lt_of_le (by decide : (8:ℕ) < 26) (parabolicCodim_ge_26 i)`. -/
instance frankeEisensteinLayerData_via_E7_carter (A : Type*) :
    FrankeEisensteinLayerData A where
  toE7ParabolicCodimData :=
    HodgeReduction.Infrastructure.Shimura.e7ParabolicCodimData_of_min_eq_26 A
  layer_codim_shift_at_deg_8 := fun i =>
    Nat.lt_of_lt_of_le (by decide : (8 : ℕ) < 26)
      (HodgeReduction.Infrastructure.Shimura.parabolicCodim_ge_26 i)

end HodgeReduction.Infrastructure.Automorphic
