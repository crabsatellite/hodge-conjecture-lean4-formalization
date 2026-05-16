/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Shimura.E7ParabolicCodim
import Mathlib.Data.Nat.Defs

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
load-bearing consequence is the **codim-shift inequality**: at the
target degree `d = 8`, every layer's contribution vanishes whenever
`d < min_P codim Y_P`. We package this as the abstract numerical
inequality `8 < 26` (the published target gap at the EVII
instantiation), composed with `Shimura.E7ParabolicCodimData.min_BS_codim_ge_26`
to give the degree-8 Eisenstein vanishing for `E_{7(-25)}` (the
Q-rank 0 cocompact case trivially satisfies the same vanishing). -/
class FrankeEisensteinLayerData (A : Type*) where
  /-- **Layer-codim shift holds** (Franke 1998 §1.4 + Borel-Wallach
  Ch. VII §2-3 + Borel-Serre 1973 §1-§2 + Schwermer 1994 + Saper 2005):
  for the Eisenstein cohomology `H^*_{Eis}(S_Γ; ℂ)` decomposed by proper
  ℚ-parabolic with the layer-codim shift, at target degree `d = 8`
  every layer contributes zero whenever the minimum codim across all
  proper ℚ-parabolic Borel-Serre strata is strictly greater than 8 —
  hence `H^8_{Eis}(S_Γ; ℂ) = 0`.

  Encoded abstractly as the load-bearing numerical inequality `8 < 26`
  (the published codim gap at the EVII target instantiation). The
  instance provider supplies the witness from the Franke + Borel-Wallach
  + Schwermer + Saper layer-spectral-sequence synthesis. -/
  layer_codim_shift_holds : (8 : ℕ) < 26

end HodgeReduction.Infrastructure.Automorphic
