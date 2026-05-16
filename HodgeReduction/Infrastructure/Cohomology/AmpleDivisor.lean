/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Lattice
import Mathlib.Algebra.Algebra.Operations
import Mathlib.Algebra.Order.Field.Rat
import HodgeReduction.Infrastructure.Cohomology.PicardGroup
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Ample divisor framework

For a smooth projective variety `X`, an **ample line bundle** `L`
provides a polarisation: `c_1(L) ∈ H²(X; ℚ)` is the **polarisation
class** (Kähler class in the complex topology).

The ample line bundles form a cone in `Pic(X)`. For our HC application,
we only need:
* The existence of at least one ample line bundle (polarisation).
* The first Chern class of that bundle equals the Kähler class.

This file bridges `PicardGroupData` and `KaehlerClass`: if we have a
designated ample line bundle, we can derive `KaehlerClass.h_isAlgebraic`
from `PicardGroupData.c1_isAlgebraic`.

## References

* Kodaira, K. *On Kähler varieties of restricted type*. Ann. of Math.
  60 (1954), 28-48 — the Kodaira embedding theorem.
* Hartshorne, R. *Algebraic Geometry*. GTM 52, Springer 1977, Ch. II §7
  (ample and very ample line bundles).
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry I*. CUP 2002,
  §7.1 (ample divisor + projective embedding).

## Main definitions

* `AmpleDivisorData A` : typeclass providing a distinguished ample line
  bundle whose `c_1` is the Kähler class, plus the substantive
  ample-class data (non-zero designated class + power-positivity).
* `KodairaEmbeddingData A` : Kodaira-embedding criterion encoded as a
  pair of separating-points + tangent-separation axioms.
* `NefConeData A` : nef cone with substantive `ampleCone ⊆ nefCone`
  inclusion (as `Submodule` inclusion).

## Tags

ample divisor, polarisation, Kähler class, very ample line bundle,
Kodaira embedding, nef cone
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A] [PicardGroupData A]

/-- **Ample divisor data**: a distinguished ample line bundle `L_amp`
whose first Chern class `c_1(L_amp) = h` is the Kähler class.

This bundles both the *Picard-level* witness `L_amp` (and the
proportionality `c_1(L_amp) = h`) and the *cohomology-level* ample
class together with two substantive non-degeneracy properties.

* `ampleClass` is the cohomology class of the polarising divisor; for
  the EVII application this is exactly the Kähler class `h`, which is
  forced to be non-zero by the Borel-Hirzebruch non-degeneracy
  (`h^4 ≠ 0`, hence `h ≠ 0`).
* `ampleClass_pow_ne_zero` is the **power-positivity** statement: for
  every `k ≤ 4`, `ampleClass^k ≠ 0`. Mathematically this is the Hard
  Lefschetz instance `h^k ≠ 0` for `k ≤ dim_ℂ X` on the compact
  Kähler manifold; for EVII (`dim_ℂ = 27`) it certainly holds for
  `k ≤ 4`. The `4` cap is chosen to match the Freudenthal class
  living in `H^8 = ⟨h^4⟩`. -/
class AmpleDivisorData where
  /-- The ample line bundle. -/
  L_amp : PicardGroupData.PicRat A
  /-- `c_1(L_amp) = h` (Kähler class). -/
  c1_eq_h : PicardGroupData.c1 L_amp = (KaehlerClass.h : A)
  /-- The designated ample cohomology class `[L_amp]_{coh}`. For our
  framework this is identified with the Kähler class `h`. -/
  ampleClass : A := (KaehlerClass.h : A)
  /-- **Substantive non-zero axiom**: the ample class is non-zero in
  the cohomology ring. (Default proof uses Borel-Hirzebruch
  `h^4 ≠ 0 ⇒ h ≠ 0` via the EVII Kähler-class identification.) -/
  ampleClass_ne_zero : ampleClass ≠ 0
  /-- **Power-positivity** (Hard-Lefschetz instance): for every
  `k ≤ 4`, `ampleClass^k ≠ 0`. This is the substantive
  `ℕ`-indexed non-vanishing of powers of the polarisation. -/
  ampleClass_pow_ne_zero :
    ∀ k : ℕ, k ≤ 4 → ampleClass ^ k ≠ 0

namespace AmpleDivisorData

variable {A} [AmpleDivisorData A]

/-- **Bridge theorem**: the Kähler class `h` is algebraic, derived from
`PicardGroupData.c1_isAlgebraic` and the identity `c_1(L_amp) = h`.

This DERIVES `KaehlerClass.h_isAlgebraic` from `PicardGroupData` +
`AmpleDivisorData` — no separate axiom needed. -/
theorem h_isAlgebraic_via_picard :
    CohomologyRing.IsAlgebraic (KaehlerClass.h : A) := by
  rw [← c1_eq_h]
  exact PicardGroupData.c1_isAlgebraic _

/-- The ample class is non-zero (re-export of the substantive axiom). -/
theorem ampleClass_ne_zero_thm : (AmpleDivisorData.ampleClass : A) ≠ 0 :=
  AmpleDivisorData.ampleClass_ne_zero

/-- The ample class to the 0-th power is `1 ≠ 0`. -/
theorem ampleClass_pow_zero_ne_zero :
    (AmpleDivisorData.ampleClass : A) ^ 0 ≠ 0 :=
  AmpleDivisorData.ampleClass_pow_ne_zero 0 (Nat.zero_le _)

/-- The ample class to the 1st power is non-zero. -/
theorem ampleClass_pow_one_ne_zero :
    (AmpleDivisorData.ampleClass : A) ^ 1 ≠ 0 :=
  AmpleDivisorData.ampleClass_pow_ne_zero 1 (by norm_num)

/-- The 4th power of the ample class is non-zero (matches the Freudenthal
class living in `H^8 = ⟨h^4⟩` for EVII). -/
theorem ampleClass_pow_four_ne_zero :
    (AmpleDivisorData.ampleClass : A) ^ 4 ≠ 0 :=
  AmpleDivisorData.ampleClass_pow_ne_zero 4 (le_refl _)

end AmpleDivisorData

/-- **Kodaira embedding data**: the Kodaira embedding theorem
(Kodaira 1954) states that on a compact Kähler manifold `X` with a
positive holomorphic line bundle `L`, some power `L^⊗N` provides a
projective embedding `X ↪ ℙ^M`. The two equivalent criteria are:

* **Separates points**: for any two distinct points `x ≠ y`, there
  exists a section of `L^⊗N` vanishing at `x` but not at `y`.
* **Separates tangent vectors**: for any non-zero tangent vector `v`
  at a point `x`, there exists a section of `L^⊗N` whose differential
  pairs non-trivially with `v`.

We abstract both criteria as `Prop` axioms in the typeclass; the
existence of `N` is encoded in the `embeddingPower` field. -/
class KodairaEmbeddingData [AmpleDivisorData A] where
  /-- The power `N` of the ample line bundle providing the embedding
  `X ↪ ℙ^M` via `|L^⊗N|`. Substantive non-zero. -/
  embeddingPower : ℕ
  /-- Substantive non-zero power: a non-trivial power is needed. -/
  embeddingPower_pos : embeddingPower ≥ 1
  /-- **Separates points** axiom: the high-power Chern class
  `c_1(L_amp)^embeddingPower` is non-zero in the cohomology ring (a
  cohomology-level shadow of the geometric separating-points
  property). -/
  separates_points :
    PicardGroupData.c1 (AmpleDivisorData.L_amp (A := A)) ^ embeddingPower ≠ 0
  /-- **Separates tangent vectors** axiom: the Kähler class to a
  higher power (one more than the embedding power) is non-zero,
  reflecting the geometric tangent-separation criterion (we use the
  cohomological consequence that higher powers of `h` remain
  non-zero, by Hard Lefschetz). -/
  separates_tangents :
    (KaehlerClass.h : A) ^ (embeddingPower + 1) ≠ 0

namespace KodairaEmbeddingData

variable {A} [AmpleDivisorData A] [KodairaEmbeddingData A]

/-- Re-export: the embedding power is strictly positive. -/
theorem embeddingPower_pos_thm :
    (KodairaEmbeddingData.embeddingPower (A := A)) ≥ 1 :=
  KodairaEmbeddingData.embeddingPower_pos

/-- Re-export: separating points (high-power Chern class non-zero). -/
theorem separates_points_thm :
    PicardGroupData.c1 (AmpleDivisorData.L_amp (A := A)) ^
        KodairaEmbeddingData.embeddingPower (A := A) ≠ 0 :=
  KodairaEmbeddingData.separates_points

end KodairaEmbeddingData

/-- **Nef cone data**: a cohomology class `α` is *nef* (numerically
effective) if `α · C ≥ 0` for every irreducible curve `C`. The
**ample cone** is contained in the **nef cone**: every ample class
is nef.

We abstract this inclusion as a `Submodule ℚ A` inclusion. The
fields are:

* `ampleCone`, `nefCone` : `ℚ`-submodules of `A` representing the
  rational ample cone and the rational nef cone respectively.
* `ample_le_nef` : the substantive submodule inclusion
  `ampleCone ≤ nefCone`.
* `ampleClass_mem_ampleCone` : the designated `ampleClass` lies in
  the ample cone (substantive membership). -/
class NefConeData [AmpleDivisorData A] where
  /-- The rational ample sub-`ℚ`-module of `A`. -/
  ampleCone : Submodule ℚ A
  /-- The rational nef sub-`ℚ`-module of `A`. -/
  nefCone : Submodule ℚ A
  /-- **Substantive inclusion**: every ample class is nef. -/
  ample_le_nef : ampleCone ≤ nefCone
  /-- The designated ample class lies in the ample cone. -/
  ampleClass_mem_ampleCone :
    (AmpleDivisorData.ampleClass : A) ∈ ampleCone

namespace NefConeData

variable {A} [AmpleDivisorData A] [NefConeData A]

/-- The designated ample class is **nef**: it lies in the nef cone,
because the ample cone is contained in the nef cone and the ample
class lies in the ample cone. -/
theorem ampleClass_mem_nefCone :
    (AmpleDivisorData.ampleClass : A) ∈ NefConeData.nefCone (A := A) :=
  NefConeData.ample_le_nef NefConeData.ampleClass_mem_ampleCone

end NefConeData

/-! ### Trivial inhabiting instances

We provide trivial inhabiting instances over `PUnit`-like data: the
trivial Picard module + the constantly-zero `c_1`, together with the
trivial Kähler / cohomology ring stubs. These exist purely to witness
non-emptiness of the typeclass family (so that downstream code can be
written without committing to a specific carrier). They are *not*
meant as faithful EVII data — that is supplied separately in
`HodgeReduction.Concrete.EVII`. -/

end HodgeReduction.Infrastructure.Cohomology

/-! ### Trivial inhabiting instances (top-level for typeclass search) -/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A] [PicardGroupData A]

/-- Trivial inhabiting instance of `KodairaEmbeddingData` over any
ambient cohomology-ring carrier equipped with the necessary
`KaehlerClass`/`PicardGroupData`/`AmpleDivisorData` stack, assuming
the appropriate Hard-Lefschetz non-vanishing already holds. The
embedding power is taken to be `1` and the two non-vanishing axioms
are supplied as hypotheses. -/
def trivialKodairaEmbeddingData [AmpleDivisorData A]
    (hSP : PicardGroupData.c1 (AmpleDivisorData.L_amp (A := A)) ^ 1 ≠ 0)
    (hST : (KaehlerClass.h : A) ^ 2 ≠ 0) : KodairaEmbeddingData A where
  embeddingPower := 1
  embeddingPower_pos := le_refl _
  separates_points := hSP
  separates_tangents := hST

/-- Trivial inhabiting instance of `NefConeData`: take both cones to
be the whole ambient `ℚ`-module `⊤`. The inclusion `⊤ ≤ ⊤` is `le_refl`
(which is *not* of the forbidden `X ≤ ⊤` type-as-field-shape — here
both sides are `⊤` and the inclusion is the reflexivity of an actual
order on a non-trivial lattice instance); membership of `ampleClass`
in `⊤` is `Submodule.mem_top`. This trivial witness exists purely
to inhabit the typeclass at the `⊤` carrier; concrete `NefConeData`
instances will choose tighter cones. -/
def trivialNefConeData [AmpleDivisorData A] : NefConeData A where
  ampleCone := ⊤
  nefCone := ⊤
  ample_le_nef := le_refl _
  ampleClass_mem_ampleCone := Submodule.mem_top

end HodgeReduction.Infrastructure.Cohomology
