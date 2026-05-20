/-
# HC Gap L4 — linear cycle-class-map replacement interface (R248).

R206 / R207 built `CycleClassFamily` / `ofCycleClassFamily`: cycle
generators are given as raw functions `GenIndex p → X.H (2 * p)`,
and the algebraic-classes submodule is the **span** of the range.

R248 upgrades this into a **linear cycle-class-map interface**:
each codim now carries a `ℚ`-module of cycles and a `ℚ`-linear
`cycleClass` map into cohomology, and the algebraic-classes submodule
is the **`LinearMap.range`** of that map. This is closer to the
real Chow-theoretic picture `cl : CH^p(X)_ℚ → H^{2p}(X, ℚ)`, without
claiming real Chow groups exist.

## What R248 (this file) provides (all kernel-pure)

* `CycleClassMapReplacementData` — structure carrying per-codim
  ℚ-modules of cycles + linear cycle class maps + Hodge-half witnesses.
* `AlgebraicClassesData.ofCycleClassMapReplacement` — ACD constructor
  from cycle-class-map data; `algClasses p := LinearMap.range (cycleClass p)`.
* `ofCycleClassMapReplacement_algClasses_eq_range` — the defining
  range equality.
* `VarietyHCAt_of_cycleClassMapReplacement_surjective_on_hodgeClasses` —
  HC bridge: if `hodgeClassesAtDegree p ≤ range (cycleClass p)`, then
  HC at codim `p` holds for the constructed ACD.

## What R248 (this file) does NOT do

* Does NOT implement a real Chow group.
* Does NOT implement rational equivalence (no quotient).
* Does NOT implement real cycle class map.
* Does NOT replace `canonicalE7ShimuraTor.algClassesOfUnderlying`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Only defines a linear replacement INTERFACE — a generalisation of
  R206/R207's generator-family interface.

All R248 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL4.InducedAlgClassMap

namespace HodgeReduction
namespace HCGapL4
namespace CycleClassMapReplacement

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.InducedAlgClassMap

/-! ## Section 1: linear cycle-class-map data -/

/-- **R248 cycle-class-map replacement data** for a fixed VCD `X`:
per codim `p`, a ℚ-module `CycleGroup p` with a linear cycle class map
into `H^{2p}(X, ℚ)` and a Hodge-half witness. Models the shape of a
real `cl : CH^p(X)_ℚ → H^{2p}(X, ℚ)` without claiming a real Chow group. -/
structure CycleClassMapReplacementData (X : VarietyCohomologyData) where
  /-- Per-codim cycle group carrier. -/
  CycleGroup : ℕ → Type
  /-- Each `CycleGroup p` is an additive commutative group. -/
  instAddCommGroup : ∀ p, AddCommGroup (CycleGroup p)
  /-- Each `CycleGroup p` is a `ℚ`-module. -/
  instModule : ∀ p,
    @Module ℚ (CycleGroup p) _ (instAddCommGroup p).toAddCommMonoid
  /-- The linear cycle class map at codim `p`. The target side uses
  the generic `acg_VCD_Hk` / `mod_VCD_Hk` instances from R214. -/
  cycleClass : ∀ p,
    @LinearMap ℚ ℚ Rat.semiring Rat.semiring (RingHom.id ℚ)
      (CycleGroup p) (X.H (2 * p))
      (instAddCommGroup p).toAddCommMonoid
      AddCommGroup.toAddCommMonoid
      (instModule p)
      (X.module (2 * p))
  /-- Hodge-half: the image of any cycle is a Hodge class. -/
  cycleClass_isHodge :
    ∀ p (z : CycleGroup p),
      cycleClass p z ∈ X.hodgeClassesAtDegree p

/-! ## Section 2: `AlgebraicClassesData` constructor -/

/-- **R248 ACD constructor**: from cycle-class-map data, define
`algClasses p := LinearMap.range (cycleClass p)`, with the Hodge-half
inequality from `cycleClass_isHodge`. -/
noncomputable def AlgebraicClassesData.ofCycleClassMapReplacement
    {X : VarietyCohomologyData}
    (D : CycleClassMapReplacementData X) :
    AlgebraicClassesData X where
  algClasses p :=
    letI _ := D.instAddCommGroup p
    letI _ := D.instModule p
    LinearMap.range (D.cycleClass p)
  algClasses_le_hodgeClasses p := by
    letI _ := D.instAddCommGroup p
    letI _ := D.instModule p
    letI _ := X.addCommGroup (2 * p)
    letI _ := X.module (2 * p)
    letI _ := X.hodgeStructure (2 * p)
    rintro x ⟨z, rfl⟩
    exact D.cycleClass_isHodge p z

/-! ## Section 3: defining range equality -/

/-- **R248 range equality**: the constructed `algClasses p` is exactly
the linear range of `cycleClass p`. -/
theorem ofCycleClassMapReplacement_algClasses_eq_range
    {X : VarietyCohomologyData}
    (D : CycleClassMapReplacementData X) (p : ℕ) :
    letI _ := D.instAddCommGroup p
    letI _ := D.instModule p
    (AlgebraicClassesData.ofCycleClassMapReplacement D).algClasses p =
      LinearMap.range (D.cycleClass p) := by
  letI _ := D.instAddCommGroup p
  letI _ := D.instModule p
  rfl

/-! ## Section 4: HC bridge theorem -/

/-- **R248 HC bridge**: if the cycle class map's image covers the
Hodge-class submodule at codim `p`, then HC at codim `p` holds for
the constructed ACD. -/
theorem VarietyHCAt_of_cycleClassMapReplacement_surjective_on_hodgeClasses
    {X : VarietyCohomologyData} {p : ℕ}
    (D : CycleClassMapReplacementData X)
    (h_cover :
      letI _ := D.instAddCommGroup p
      letI _ := D.instModule p
      X.hodgeClassesAtDegree p ≤ LinearMap.range (D.cycleClass p)) :
    VarietyHCAt X (AlgebraicClassesData.ofCycleClassMapReplacement D) p := by
  letI _ := D.instAddCommGroup p
  letI _ := D.instModule p
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  intro x hx
  show x ∈ (AlgebraicClassesData.ofCycleClassMapReplacement D).algClasses p
  rw [ofCycleClassMapReplacement_algClasses_eq_range]
  exact h_cover hx

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_CycleClassMapReplacement_To_RealChowGroup**: upgrading the
toy `CycleGroup p` (an arbitrary ℚ-module) to a genuine Chow group
`CH^p(X)_ℚ` (quotient of the free abelian group of codim-`p` cycles by
rational equivalence). -/
abbrev L4_G_CycleClassMapReplacement_To_RealChowGroup : Prop := True

/-- **L4-G_CycleClassMapReplacement_MissingRationalEquivalence**: the
toy `CycleGroup p` carries no rational equivalence quotient. -/
abbrev L4_G_CycleClassMapReplacement_MissingRationalEquivalence :
    Prop := True

/-- **L4-G_CycleClassMapReplacement_MissingFunctoriality**: the toy
interface has no push-forward `f_*` or pull-back `f^*` functoriality
across morphisms of varieties. -/
abbrev L4_G_CycleClassMapReplacement_MissingFunctoriality : Prop := True

/-- **L4-G_CycleClassMapReplacement_To_algClassesOfUnderlying**: the
bridge from this linear-interface ACD to a genuine replacement of
`canonicalE7ShimuraTor.algClassesOfUnderlying`. -/
abbrev L4_G_CycleClassMapReplacement_To_algClassesOfUnderlying :
    Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R248 non-closure (1/5)**: does NOT implement a real Chow group. -/
theorem R248_does_not_implement_real_chow_group : True := trivial

/-- **R248 non-closure (2/5)**: does NOT implement rational equivalence. -/
theorem R248_does_not_implement_rational_equivalence : True := trivial

/-- **R248 non-closure (3/5)**: does NOT implement a real cycle class map. -/
theorem R248_does_not_implement_real_cycle_class_map : True := trivial

/-- **R248 non-closure (4/5)**: does NOT replace
`canonicalE7ShimuraTor.algClassesOfUnderlying`. -/
theorem R248_does_not_replace_canonicalE7ShimuraTor_algClassesOfUnderlying :
    True := trivial

/-- **R248 non-closure (5/5)**: only defines a linear replacement
interface — a generalisation of R206/R207's generator-family interface. -/
theorem R248_only_defines_linear_replacement_interface : True := trivial

end CycleClassMapReplacement
end HCGapL4
end HodgeReduction
