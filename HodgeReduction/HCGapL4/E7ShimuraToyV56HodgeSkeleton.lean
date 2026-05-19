/-
# HC Gap L4 — minimal V_56-shaped TOY Hodge skeleton (R231).

R230 introduced `V56ToySkeleton` as a typed slot (56-dim ℚ-module +
placeholder Hodge weight, no further structure). R231 upgrades the
slot into a **minimal Hodge-theoretic toy** by attaching:

* a concrete `PureHodgeStructure V56Toy 3` with one trivial piece
  (mirroring R202's `pureHodgeStructure_ℚ_Tate2` pattern but at
  weight 3);
* an upgraded skeleton structure `V56ToyHodgeSkeleton` bundling
  this PHS;
* a wrapper `E7ShimuraToyWithV56HodgeSkeleton` attaching the upgrade
  to the R229 carrier.

The Hodge decomposition exhibited here is TRIVIAL: one piece is `⊤`
and the rest are `⊥`. The real V_56 has Hodge decomposition
`H^{3,0} ⊕ H^{2,1} ⊕ H^{1,2} ⊕ H^{0,3}` of dimensions `1, 27, 27, 1`,
none of which is realised. The toy PHS exists only to occupy the
typed slot for `PureHodgeStructure V56 3` at the position the real
V_56 would.

## What R231 (this file) provides (all kernel-pure)

* `piece_V56Toy_weight3` — toy weight-3 Hodge pieces (one `⊤`, rest
  `⊥`).
* `pureHodgeStructure_V56Toy_weight3` — `PureHodgeStructure V56Toy 3`
  instance via `iSupIndep` + `iSup = ⊤`.
* `V56ToyHodgeSkeleton` — upgraded skeleton structure bundling the
  carrier + PHS instance.
* `E7ShimuraToy_V56HodgeSkeleton` — instance for the E_7 toy.
* `E7ShimuraToyWithV56HodgeSkeleton` — wrapper bundling VCD + ACD +
  Hodge skeleton.
* `VarietyHCAt_E7ShimuraToyWithV56HodgeSkeleton_codim1_via_productCycleFactory` —
  HC at codim 1 carried through the wrapper.

## What R231 (this file) does NOT do

* Does NOT implement the real V_56 Hodge decomposition
  (`1 + 27 + 27 + 1`).
* Does NOT implement the Mumford–Tate group / cocharacter associated
  to the real V_56.
* Does NOT implement Freudenthal triple system, octonions, or E_7
  action.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT identify `E7ShimuraToy` with the real canonical E_7
  Shimura variety.

All R231 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraToyProductCycleFactory
import HodgeReduction.HCGapL4.E7ShimuraToyV56Skeleton
import Mathlib.Algebra.DirectSum.Module

namespace HodgeReduction
namespace HCGapL4
namespace E7ShimuraToyV56HodgeSkeleton

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraToyProductCycleFactory
open HodgeReduction.HCGapL4.E7ShimuraToyV56Skeleton

/-! ## Section 1: toy Hodge pieces for V_56 at weight 3

Mirrors R202's `piece_ℚ_Tate2` pattern at weight 3. Picks one
arbitrary piece to carry `⊤` and the rest `⊥`. NOT the real
`1 + 27 + 27 + 1` Hodge decomposition. -/

/-- **R231 toy Hodge pieces** for `V56Toy` at weight 3. Only one piece
(arbitrarily chosen at index 1) is non-trivial. -/
noncomputable def piece_V56Toy_weight3 : Fin 4 → Submodule ℚ V56Toy
  | ⟨0, _⟩ => ⊥
  | ⟨1, _⟩ => ⊤
  | ⟨2, _⟩ => ⊥
  | ⟨3, _⟩ => ⊥

@[simp] theorem piece_V56Toy_weight3_zero :
    piece_V56Toy_weight3 ⟨0, by omega⟩ = (⊥ : Submodule ℚ V56Toy) := rfl

@[simp] theorem piece_V56Toy_weight3_one :
    piece_V56Toy_weight3 ⟨1, by omega⟩ = (⊤ : Submodule ℚ V56Toy) := rfl

@[simp] theorem piece_V56Toy_weight3_two :
    piece_V56Toy_weight3 ⟨2, by omega⟩ = (⊥ : Submodule ℚ V56Toy) := rfl

@[simp] theorem piece_V56Toy_weight3_three :
    piece_V56Toy_weight3 ⟨3, by omega⟩ = (⊥ : Submodule ℚ V56Toy) := rfl

theorem iSupIndep_piece_V56Toy_weight3 :
    iSupIndep piece_V56Toy_weight3 := by
  intro p
  fin_cases p
  · simp [piece_V56Toy_weight3, disjoint_bot_left]
  · refine disjoint_iff.mpr ?_
    apply le_antisymm
    · refine le_trans inf_le_right ?_
      refine iSup_le (fun q => ?_)
      refine iSup_le (fun hq => ?_)
      fin_cases q
      · simp [piece_V56Toy_weight3]
      · exact absurd rfl hq
      · simp [piece_V56Toy_weight3]
      · simp [piece_V56Toy_weight3]
    · exact bot_le
  · simp [piece_V56Toy_weight3, disjoint_bot_left]
  · simp [piece_V56Toy_weight3, disjoint_bot_left]

theorem iSup_piece_V56Toy_weight3_eq_top :
    ⨆ p, piece_V56Toy_weight3 p = (⊤ : Submodule ℚ V56Toy) := by
  apply le_antisymm le_top
  intro x _
  refine Submodule.mem_iSup_of_mem ⟨1, by omega⟩ ?_
  simp [piece_V56Toy_weight3]

/-- **R231 V_56 toy PureHodgeStructure at weight 3**. Kernel-pure
construction via Mathlib's `isInternal_submodule_of_iSupIndep_of_iSup_eq_top`.
The Hodge decomposition is TRIVIAL (one `⊤`, rest `⊥`); the real V_56
has `1 + 27 + 27 + 1`. -/
noncomputable instance pureHodgeStructure_V56Toy_weight3 :
    PureHodgeStructure V56Toy 3 where
  piece := piece_V56Toy_weight3
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      iSupIndep_piece_V56Toy_weight3
      iSup_piece_V56Toy_weight3_eq_top

/-! ## Section 2: upgraded skeleton structure bundling the PHS -/

/-- **R231 upgraded V_56 toy Hodge skeleton**: bundles the carrier,
group / module instances, weight, and `PureHodgeStructure`. -/
structure V56ToyHodgeSkeleton where
  /-- The underlying carrier type. -/
  V56 : Type
  /-- `V56` is an additive commutative group. -/
  instAddCommGroup : AddCommGroup V56
  /-- `V56` is a ℚ-module. -/
  instModule : @Module ℚ V56 _ instAddCommGroup.toAddCommMonoid
  /-- Hodge weight. -/
  weight : ℕ
  /-- The pure Hodge structure of the given weight on `V56`. -/
  instPHS : @PureHodgeStructure V56 instAddCommGroup instModule weight

/-! ## Section 3: E_7-toy V_56 Hodge skeleton instance -/

/-- **R231 E_7-toy V_56 Hodge skeleton instance**: attaches the toy
PHS at weight 3 to the E_7 toy carrier. -/
noncomputable def E7ShimuraToy_V56HodgeSkeleton : V56ToyHodgeSkeleton where
  V56 := V56Toy
  instAddCommGroup := instAddCommGroup_V56Toy
  instModule := instModule_V56Toy
  weight := 3
  instPHS := pureHodgeStructure_V56Toy_weight3

/-! ## Section 4: wrapper bundling VCD + ACD + Hodge skeleton -/

/-- **R231 upgraded wrapper** bundling the E_7 toy carrier's VCD, ACD,
and V_56 Hodge skeleton (which itself bundles the PHS). -/
structure E7ShimuraToyWithV56HodgeSkeleton where
  /-- The toy `VarietyCohomologyData`. -/
  VCD : VarietyCohomologyData
  /-- The toy algebraic-classes bundle. -/
  ACD : AlgebraicClassesData VCD
  /-- The V_56 toy Hodge skeleton. -/
  v56Hodge : V56ToyHodgeSkeleton

/-- **R231 upgraded wrapper instance** for the E_7 toy carrier. -/
noncomputable def E7ShimuraToy_WithV56HodgeSkeleton :
    E7ShimuraToyWithV56HodgeSkeleton where
  VCD := VarietyCohomologyData_E7ShimuraToy
  ACD := AlgebraicClassesData_E7ShimuraToy
  v56Hodge := E7ShimuraToy_V56HodgeSkeleton

/-! ## Section 5: HC carry through the upgraded wrapper -/

/-- **R231 interface-level HC carry**: the R229 product-cycle factory
HC closure carries through the upgraded wrapper unchanged. The Hodge
skeleton is attached by-side. -/
theorem VarietyHCAt_E7ShimuraToyWithV56HodgeSkeleton_codim1_via_productCycleFactory :
    VarietyHCAt
      E7ShimuraToy_WithV56HodgeSkeleton.VCD
      E7ShimuraToy_WithV56HodgeSkeleton.ACD
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_productCycleFactory

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_V56ToyHodgeSkeleton_To_RealV56HodgeStructure**: upgrading
the toy weight-3 PHS (one `⊤`, rest `⊥`) to the real V_56 Hodge
decomposition `H^{3,0} ⊕ H^{2,1} ⊕ H^{1,2} ⊕ H^{0,3}` of dimensions
`1 + 27 + 27 + 1`. R231 provides only a trivial split. -/
abbrev L4_G_V56ToyHodgeSkeleton_To_RealV56HodgeStructure : Prop := True

/-- **L4-G_V56ToyHodgeSkeleton_MissingMumfordTateCocharacter**: the
Mumford–Tate cocharacter `μ : 𝔾_m → MT(V_56)_ℂ` defining the real V_56
Hodge structure is NOT modelled. -/
abbrev L4_G_V56ToyHodgeSkeleton_MissingMumfordTateCocharacter :
    Prop := True

/-- **L4-G_V56ToyHodgeSkeleton_MissingE7Action**: the toy skeleton
still has no E_7 group action (carried forward from R230). -/
abbrev L4_G_V56ToyHodgeSkeleton_MissingE7Action : Prop := True

/-- **L4-G_V56ToyHodgeSkeleton_MissingFreudenthalQuartic**: the toy
skeleton carries no Freudenthal quartic form (carried forward from
R230). -/
abbrev L4_G_V56ToyHodgeSkeleton_MissingFreudenthalQuartic : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R231 non-closure (1/6)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R231_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R231 non-closure (2/6)**: does NOT implement real V_56
representation theory of E_7. -/
theorem R231_does_not_implement_real_V56 : True := trivial

/-- **R231 non-closure (3/6)**: does NOT implement the true
Mumford–Tate group / cocharacter for V_56. -/
theorem R231_does_not_implement_true_mumford_tate : True := trivial

/-- **R231 non-closure (4/6)**: does NOT implement E_7 group action
on V_56. -/
theorem R231_does_not_implement_real_E7_action : True := trivial

/-- **R231 non-closure (5/6)**: does NOT implement Freudenthal
triple system, quartic form, or Jordan algebra `J_3(O)`. -/
theorem R231_does_not_implement_freudenthal_triple : True := trivial

/-- **R231 non-closure (6/6)**: does NOT identify `E7ShimuraToy` with
the real canonical E_7 Shimura variety. -/
theorem R231_does_not_identify_toy_with_real_E7Shimura : True := trivial

end E7ShimuraToyV56HodgeSkeleton
end HCGapL4
end HodgeReduction
