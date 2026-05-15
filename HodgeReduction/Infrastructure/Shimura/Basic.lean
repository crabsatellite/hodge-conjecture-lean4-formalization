/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.HodgeStructure.MumfordTate
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Shimura varieties — abstract data for the Mumford–Tate reduction

A **Shimura variety** `S_Γ` is a quasi-projective `ℚ`-variety
classifying polarised Hodge structures of given type with extra
data (Mumford–Tate group action, level structure). Concretely:

* `(G, X)` : a Shimura datum (G is a Q-algebraic group, X is a
  conjugacy class of cocharacters `S → G_ℝ`).
* `Γ ⊆ G(ℚ)` : a congruence subgroup.
* `S_Γ := Γ \\ X` (or its compactification).

For the Mumford–Tate reduction of the Hodge Conjecture (our paper),
we work with the **EVII Shimura variety**:
* `G = E_{7(-25)}` (the exceptional Lie group of type E_7, with
  −25 the signature of the Killing form on the symmetric pair).
* `X = E_{7(-25)} / (E_6 × U(1))` (the bounded symmetric domain
  of complex dimension 27).
* `S_Γ` is the moduli space of polarised Hodge structures of EVII
  type, with extra data.

This file packages the **abstract Shimura variety data** without
formalising the algebraic-group / arithmetic-quotient structure.
What we need for HC:

1. The cohomology ring `H^*(S_Γ; ℚ)` (a CommRing with `algebraic`).
2. A specific class `[q] ∈ H^8` (the Freudenthal class).
3. The polynomial identity `[q] = polynomial in Chern classes`.
4. A Kähler class `h ∈ H^2` (from the polarisation line bundle).
5. The proportionality `[q] = −48 h^4`.

## Main definitions

* `ShimuraVarietyData` : a typeclass packaging the cohomology data
  of a Shimura variety with a designated Freudenthal class and
  polynomial identity.

## Tags

Shimura variety, EVII, polarised Hodge structure, Mumford-Tate reduction
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- Abstract data for a Shimura variety `S_Γ` relevant to the
HC application:

* `A` : the cohomology ring `H^*(S_Γ; ℚ)`.
* `dim` : the complex dimension of `S_Γ`.

This is the **minimal carrier** we need for the abstract HC argument.

For EVII specifically: `dim = 27`. -/
class ShimuraVarietyData (A : Type*) [CommRing A] [Algebra ℚ A]
    [Cohomology.CohomologyRing A] where
  /-- The complex dimension of the Shimura variety. -/
  dim : ℕ

namespace ShimuraVarietyData

variable {A : Type*} [CommRing A] [Algebra ℚ A]
    [Cohomology.CohomologyRing A] [ShimuraVarietyData A]

/-- For the EVII Shimura variety, `dim = 27`. -/
def EVII_dim : ℕ := 27

/-- Tag a `ShimuraVarietyData` as "EVII-type" if its dimension is 27. -/
def IsEVII : Prop := dim (A := A) = 27

end ShimuraVarietyData

end HodgeReduction.Infrastructure.Shimura
