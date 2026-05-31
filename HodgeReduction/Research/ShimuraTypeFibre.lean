/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Shimura-type fibres

Master tex label: `def:shimura-type-fibre`.

This file records the paper's definition as an abstract Lean carrier.  It does
not prove density of such fibres, the E7 Chern-Weil bridge, or any BBT
spreading theorem.
-/

namespace HodgeReduction

/--
Data expressing that a fibre is Shimura-type in the sense of the master paper.

The field `fibreClassPulledBackFromChernWeil` is the definitional pullback
condition for the chosen E7-invariant Hodge class.  The stronger
`allInvariantHodgeClassesRealizedThroughMap` field records the equivalent
formulation in the paper: all E7-invariant Hodge classes are realized through
the map to an EVII Shimura toroidal compactification, finite cover, or
birational model.
-/
structure ShimuraTypeFibreData where
  familyTotalSpace : Type
  base : Type
  fibre : base -> Type
  point : base
  genericMumfordTateHasE7Factor : Prop
  arithmeticLattice : Type
  arithmeticLatticeInE7QPlus : Prop
  eVIIShimuraToroidalCompactification : Type
  toroidalCompactificationSmooth : Prop
  targetIsToroidalOrFiniteCoverOrBirationalModel : Prop
  fibreToShimuraTarget : fibre point -> eVIIShimuraToroidalCompactification
  fibreToShimuraTargetAlgebraic : Prop
  fibreToShimuraTargetAlgebraic_holds : fibreToShimuraTargetAlgebraic
  e7InvariantHodgeClassOnFibre : Type
  chernWeilClassOnShimuraTarget : Type
  fibreClassPulledBackFromChernWeil : Prop
  fibreClassPulledBackFromChernWeil_holds : fibreClassPulledBackFromChernWeil
  allInvariantHodgeClassesRealizedThroughMap : Prop
  allInvariantHodgeClassesRealizedThroughMap_holds :
    allInvariantHodgeClassesRealizedThroughMap

namespace ShimuraTypeFibreData

/-- The definition includes an algebraic map from the fibre to the Shimura
toroidal target or its finite-cover/birational variant. -/
theorem has_algebraic_map_to_shimura_target (D : ShimuraTypeFibreData) :
    D.fibreToShimuraTargetAlgebraic :=
  D.fibreToShimuraTargetAlgebraic_holds

/-- The definition includes the pullback condition for the selected
E7-invariant Hodge class. -/
theorem selected_class_is_pulled_back_from_chern_weil
    (D : ShimuraTypeFibreData) :
    D.fibreClassPulledBackFromChernWeil :=
  D.fibreClassPulledBackFromChernWeil_holds

/-- The equivalent formulation recorded in the definition: all invariant
classes are realized through the Shimura-type map. -/
theorem invariant_classes_realized_through_map
    (D : ShimuraTypeFibreData) :
    D.allInvariantHodgeClassesRealizedThroughMap :=
  D.allInvariantHodgeClassesRealizedThroughMap_holds

end ShimuraTypeFibreData

end HodgeReduction
