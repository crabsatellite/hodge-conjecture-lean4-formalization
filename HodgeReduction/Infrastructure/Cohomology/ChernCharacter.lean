/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.AlgebraicBundle

/-!
# Chern character framework

For an algebraic vector bundle `V` of rank `r` with Chern classes
`c_1, c_2, ..., c_r`, the **Chern character** is the cohomology class
```
ch(V) := r + c_1 + (c_1² - 2c_2)/2 + (c_1³ - 3 c_1 c_2 + 3 c_3)/6 + …
```
The Chern character is a **ring homomorphism** `K^0(X) → H^{2*}(X; ℚ)`
(Grothendieck), making computations in K-theory map to additive
computations in cohomology.

For our HC application:
* The total Chern class `c(V) := 1 + c_1 + c_2 + …` is multiplicative
  under direct sums: `c(V ⊕ W) = c(V) c(W)`.
* The filtered-trivial constraint `V_56^{can} = L_{+3} ⊕ 𝓔_{+1} ⊕
  𝓔_{-1} ⊕ L_{-3}` with `c(V_56^{can}) = 1` gives the P57 polynomial
  identity.

This file packages **abstract Chern character data**.

## Main definitions

* `ChernCharacterData A` : Chern character function.

## Tags

Chern character, K-theory, Grothendieck, Riemann-Roch
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Chern character data** for a cohomology ring `A`:

* `ch_2` : the degree-2 part of the Chern character `(c_1² - 2c_2)/2`.
* `ch_4` : the degree-4 part of the Chern character.

For our HC application, only the degree-2 and degree-4 parts are
load-bearing (via the P53/P57 polynomial identities). -/
class ChernCharacterData where
  /-- The degree-2 part of the Chern character. -/
  ch_2 : A
  /-- The degree-4 part of the Chern character. -/
  ch_4 : A

end HodgeReduction.Infrastructure.Cohomology
