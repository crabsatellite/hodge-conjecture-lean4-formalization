/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Circularity certificate for the Mok step

Master tex labels: `prop:mok-conditional`, `thm:torelli-evii-verdict`.

The master paper uses the Venkataramana--Margulis--Mok route as a diagnostic:
the Mok step is useful only after an EVII-uniformisation-type hypothesis is
supplied independently.  This file formalizes the logical core of that status
claim.  It does not formalize Mok's theorem, Margulis superrigidity, or the
arithmeticity proof.
-/

namespace HodgeReduction

/--
The logical shape of the Mok step in the Torelli-EVII route.

The field `mokConditional` records only the conditional form:
EVII uniformisation of the source implies the Torelli-EVII conclusion.
It deliberately does not include a proof of `eviiUniformisation`.
-/
structure MokTorelliConditionalShape where
  eviiUniformisation : Prop
  torelliEVII : Prop
  mokConditional : eviiUniformisation -> torelliEVII

/-- A minimal model in which the Mok conditional is present but the Torelli
conclusion is not available. -/
def mokTorelliCircularityCountermodel : MokTorelliConditionalShape where
  eviiUniformisation := False
  torelliEVII := False
  mokConditional := False.elim

/--
A conditional Mok implication alone does not self-close the Torelli-EVII
conclusion.
-/
theorem mok_conditional_does_not_self_close_torelli :
    Not (forall D : MokTorelliConditionalShape, D.torelliEVII) := by
  intro h
  exact h mokTorelliCircularityCountermodel

/-- If the independent EVII-uniformisation input is supplied, the conditional
Mok step can be consumed. -/
theorem mok_conditional_closes_with_uniformisation
    (D : MokTorelliConditionalShape) (hUniform : D.eviiUniformisation) :
    D.torelliEVII :=
  D.mokConditional hUniform

end HodgeReduction
