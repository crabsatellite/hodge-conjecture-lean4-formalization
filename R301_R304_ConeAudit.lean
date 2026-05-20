import HodgeReduction.HCGapL4.GaussianCMActionEquationPreservation
import HodgeReduction.HCGapL4.GaussianCMActionCoordinateSquare
import HodgeReduction.HCGapL4.GaussianCMActionPointMap
import HodgeReduction.HCGapL4.GaussianCMActionPointSquare
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R301: Equation + Nonsingular preservation (Agent B)
#print axioms gaussianCMAction_preserves_equation
#print axioms gaussianCMAction_preserves_nonsingular

-- R302: Coordinate-level square (Agent D)
#print axioms gaussianCMAction_coord_square_x
#print axioms gaussianCMAction_coord_square_y
#print axioms gaussianCMAction_coord_square
#print axioms gaussianCMAction_coord_square_equals_negY
#print axioms gaussianCMAction_coord_square_equals_negY_pair
#print axioms gaussianCMAction_coord_square_prod

-- R303: Point-level function (Agent C)
#print axioms gaussianCMAction_affinePoint
#print axioms gaussianCMAction_affinePoint_zero
#print axioms gaussianCMAction_affinePoint_some

-- R304: Point-level square = -P (this turn)
#print axioms gaussianCMAction_affinePoint_square_eq_neg

-- Status markers (should be axiom-free)
#print axioms R301_Status_Equation_Preserved
#print axioms R302_Status_Nonsingular_Preserved
#print axioms R303_Status_CMAction_PointMap_Defined
#print axioms R304_Status_Square_Eq_Neg_Closed

-- Blocking markers (should be axiom-free)
#print axioms BlockingLemma_gaussianCMAction_addMonoidHom_chord_tangent
#print axioms BlockingLemma_gaussianCMAction_End_packaging

-- Next-target markers
#print axioms R305_NextTarget_AddMonoidHom
#print axioms R305_NextTarget_End_Element

-- Non-closure (should be axiom-free)
#print axioms R301_does_not_construct_endomorphism
#print axioms R303_does_not_prove_addMonoidHom
#print axioms R304_does_not_prove_addMonoidHom
#print axioms R304_PointSquare_does_not_close_canonicalE7ShimuraTor

-- Headline guard (must stay unchanged)
#print axioms hodgeConjectureReal_canonical
