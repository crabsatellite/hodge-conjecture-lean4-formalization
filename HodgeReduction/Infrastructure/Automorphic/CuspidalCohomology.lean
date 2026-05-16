/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Automorphic.Basic
import HodgeReduction.Infrastructure.Cohomology.Matsushima

/-!
# Cuspidal cohomology framework

The **cuspidal cohomology** `H^*_{cusp}(S_Γ; ℚ)` is the contribution to
`H^*(S_Γ; ℚ)` from cuspidal automorphic representations of `G(𝔸)`. By
Borel-Wallach 1980 + Franke 1998, it can be computed via:
```
H^*_{cusp}(S_Γ; ℂ) = ⨁_π H^*(g, K; π_∞) ⊗ π_f^Γ_f
```
where the sum is over cuspidal representations `π = π_∞ ⊗ π_f`.

For the Hermitian symmetric pair `(E_{7(-25)}, E_6 × U(1))`, by
Salamanca-Riba 1999 + V-Z 1984: the cuspidal G-invariant H^8 reduces
to the trivial-module contribution.

This file packages **abstract cuspidal cohomology data**.

## Main definitions

* `CuspidalCohomologyData A` : abstract cuspidal subspace data.
* `EisensteinVanishingDeg8 A B` : sibling typeclass asserting that the
  Matsushima target G-invariants at degree 8 equal the cuspidal
  subspace (Franke 1998 §1.4 + degree-8 Eisenstein vanishing).
* `CuspidalGInvariantTrivialModuleDeg8 B` : sibling typeclass asserting
  that the cuspidal G-invariant H^8 equals the trivial-module part
  (V-Z 1984 + KV 1995 + Salamanca-Riba 1999 + V-Z holo-disc + Cartan
  1929).

## Tags

cuspidal cohomology, automorphic representation, Borel-Wallach 1980,
trivial module
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Cuspidal cohomology data**:

* `cuspidalSubspace` : the cuspidal subspace `H^*_{cusp}(S_Γ; ℚ) ⊆ A`.
* `trivialModulePart` : the trivial-module part `(via Cartan thm)`.

For the EVII case: at degree 8, `trivialModulePart` equals the
image of `j^8 : H^8(Ě_VII; ℚ) → H^8(S_Γ; ℚ)^G`. -/
class CuspidalCohomologyData where
  /-- The cuspidal cohomology subspace. -/
  cuspidalSubspace : Submodule ℚ A
  /-- The trivial-module part of the cuspidal cohomology. -/
  trivialModulePart : Submodule ℚ A
  /-- The trivial-module part is contained in the cuspidal part. -/
  trivial_le_cuspidal : trivialModulePart ≤ cuspidalSubspace

/-- **Eisenstein vanishing at degree 8** (Franke 1998 §1.4 + degree-8
Eisenstein-layer vanishing for `E_{7(-25)}`).

Sibling typeclass asserting that the Matsushima target G-invariants
submodule at degree 8 (= `H^8(S_Γ; ℂ)^G`, supplied by `MatsushimaData
A B`'s `target_invariants`) coincides with the cuspidal subspace
(supplied by `CuspidalCohomologyData B`'s `cuspidalSubspace`):

  `MatsushimaData.target_invariants = CuspidalCohomologyData.cuspidalSubspace`.

This is precisely Step A of the (ii.a) realization argument: under
Franke 1998 §1.4 (L²-decomposition cuspidal ⊕ Eisenstein) and
degree-8 Eisenstein vanishing (proved separately via Borel-Serre 1973
+ E_7 codim ≥ 26), the G-invariant H^8 reduces to its cuspidal part.
The vanishing of Eisenstein contributions at degree 8 IS this
equality of submodules; the typeclass field encodes it as a
parameter-level published reduction. -/
class EisensteinVanishingDeg8 (A : Type*) [AddCommGroup A] [Module ℚ A]
    (B : Type*) [AddCommGroup B] [Module ℚ B]
    [HodgeReduction.Infrastructure.Cohomology.MatsushimaData A B]
    [CuspidalCohomologyData B] where
  /-- **Eisenstein vanishing at deg 8** (Franke 1998 §1.4 + Borel-Wallach
  1980 Ch. VII + Borel-Serre 1973 + Schwermer 1994 + Saper 2005): the
  G-invariant `H^8` of `S_Γ` equals its cuspidal part, i.e. the Matsushima
  target G-invariants submodule coincides with the cuspidal subspace.

  This is the substantive Franke 1998 §1.4 layer-decomposition consequence
  at the carrier level: the published L² splitting cuspidal ⊕ Eisenstein
  with degree-8 Eisenstein vanishing for `E_{7(-25)}` reduces the
  G-invariant `H^8` to its cuspidal part.

  The R7 audit B.4 fix (2026-05-16) removed the decorative
  `franke_1998_layer_decomp_holds : cuspidalSubspace ≤ ⊤` field
  (Submodule.le_top tautology); downstream consumers now project through
  this substantive Submodule equality. -/
  target_invariants_eq_cuspidal :
    HodgeReduction.Infrastructure.Cohomology.MatsushimaData.target_invariants
        (A := A) (B := B)
      = CuspidalCohomologyData.cuspidalSubspace (A := B)

/-- **Cuspidal G-invariant H^8 = trivial-module part** at degree 8 for
`E_{7(-25)}` (V-Z 1984 + KV 1995 + Salamanca-Riba 1999 + V-Z holo-disc +
Cartan 1929).

Sibling typeclass asserting that the cuspidal G-invariant `H^8`
(the meet `cuspidalSubspace ⊓ target_invariants`) coincides with the
trivial-module part (`CuspidalCohomologyData.trivialModulePart`):

  `cuspidalSubspace ⊓ target_invariants = trivialModulePart`.

This is precisely Step B of the (ii.a) realization argument: combining
(i) V-Z 1984 A_q(λ) decomposition of cuspidal cohomology, (ii) KV 1995
cohomological induction, (iii) Salamanca-Riba 1999 low-degree vanishing
(only trivial + holo-discrete contribute at deg < dim_C(G/K) = 27),
(iv) V-Z 1984 §5 holo-discrete absent at deg < 27, (v) Cartan 1929
(trivial-module (g, K)-cohomology = `H^*(Ě_VII; ℂ)`), the cuspidal
G-invariant H^8 reduces to the trivial-module Cartan image. The
typeclass field encodes this reduction as a published-parameter level
equation. -/
class CuspidalGInvariantTrivialModuleDeg8
    (A : Type*) [AddCommGroup A] [Module ℚ A]
    (B : Type*) [AddCommGroup B] [Module ℚ B]
    [HodgeReduction.Infrastructure.Cohomology.MatsushimaData A B]
    [CuspidalCohomologyData B] where
  /-- **Cuspidal G-invariant H^8 = trivial-module part** (V-Z + KV +
  Salamanca-Riba + V-Z holo-disc + Cartan synthesis at deg 8 for
  `E_{7(-25)}`). -/
  cuspidal_G_invariant_eq_trivial_module :
    CuspidalCohomologyData.cuspidalSubspace (A := B)
      ⊓ HodgeReduction.Infrastructure.Cohomology.MatsushimaData.target_invariants
          (A := A) (B := B)
      = CuspidalCohomologyData.trivialModulePart (A := B)

end HodgeReduction.Infrastructure.Automorphic
