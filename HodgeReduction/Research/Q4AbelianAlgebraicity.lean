/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Q4 algebraicity on the abelian-type side

Master tex label: `prop:q4-abelian-algebraicity`.

The master paper uses a pointwise CM/abelian-type lift for the Freudenthal
quartic class `q4`.  This file formalizes only the dependency shape:
the CM abelian algebraicity bridge can produce pointwise algebraicity on the
abelian side, but it does not by itself supply a global abelian-type Shimura
morphism or the fibre-transfer needed for the E7 family.
-/

namespace HodgeReduction

/--
Abstract dependency shape for the abelian-side algebraicity of the q4 class.

The distinction between `pointwiseQ4Algebraic` and `globalE7Q4Algebraic`
is deliberate: the paper's pointwise CM/abelian input is useful, but it is not
the same statement as a global E7 Shimura morphism or global fibre transfer.
-/
structure Q4AbelianAlgebraicityData where
  q4ClassOnAbelianSide : Prop
  cmAbelianAlgebraicityBridge : Prop
  pointwiseLiftToE7Fibre : Prop
  pointwiseQ4Algebraic : Prop
  globalAbelianTypeShimuraMorphism : Prop
  globalE7Q4Algebraic : Prop
  pointwise_from_cm_abelian_bridge :
    q4ClassOnAbelianSide ->
      cmAbelianAlgebraicityBridge ->
        pointwiseQ4Algebraic
  global_from_pointwise_and_morphism :
    pointwiseQ4Algebraic ->
      pointwiseLiftToE7Fibre ->
        globalAbelianTypeShimuraMorphism ->
          globalE7Q4Algebraic

namespace Q4AbelianAlgebraicityData

/-- The pointwise q4 algebraicity consumer used by the master-paper claim. -/
theorem pointwise_q4_algebraicity_from_cm_abelian_bridge
    (D : Q4AbelianAlgebraicityData)
    (hQ4 : D.q4ClassOnAbelianSide)
    (hCM : D.cmAbelianAlgebraicityBridge) :
    D.pointwiseQ4Algebraic :=
  D.pointwise_from_cm_abelian_bridge hQ4 hCM

/--
The full global consumer: to turn pointwise q4 algebraicity into the global
E7-family conclusion, the fibre lift and the global abelian-type Shimura
morphism must also be supplied.
-/
theorem global_q4_algebraicity_from_full_transfer
    (D : Q4AbelianAlgebraicityData)
    (hQ4 : D.q4ClassOnAbelianSide)
    (hCM : D.cmAbelianAlgebraicityBridge)
    (hLift : D.pointwiseLiftToE7Fibre)
    (hMorphism : D.globalAbelianTypeShimuraMorphism) :
    D.globalE7Q4Algebraic :=
  D.global_from_pointwise_and_morphism
    (D.pointwise_q4_algebraicity_from_cm_abelian_bridge hQ4 hCM)
    hLift
    hMorphism

end Q4AbelianAlgebraicityData

/-- A model in which the pointwise abelian-side statement holds but the global
E7-family algebraicity conclusion is absent. -/
def q4AbelianNoGlobalMorphismCountermodel : Q4AbelianAlgebraicityData where
  q4ClassOnAbelianSide := True
  cmAbelianAlgebraicityBridge := True
  pointwiseLiftToE7Fibre := True
  pointwiseQ4Algebraic := True
  globalAbelianTypeShimuraMorphism := False
  globalE7Q4Algebraic := False
  pointwise_from_cm_abelian_bridge := fun _ _ => trivial
  global_from_pointwise_and_morphism := fun _ _ hMorphism => False.elim hMorphism

/--
The pointwise CM/abelian q4 algebraicity package does not by itself close the
global E7-family q4 algebraicity statement.  The missing global Shimura
morphism or transfer input is load-bearing.
-/
theorem pointwise_q4_algebraicity_does_not_self_close_global_e7 :
    Not
      (forall D : Q4AbelianAlgebraicityData,
        D.q4ClassOnAbelianSide ->
          D.cmAbelianAlgebraicityBridge ->
            D.pointwiseLiftToE7Fibre ->
              D.globalE7Q4Algebraic) := by
  intro h
  exact h q4AbelianNoGlobalMorphismCountermodel trivial trivial trivial

end HodgeReduction
