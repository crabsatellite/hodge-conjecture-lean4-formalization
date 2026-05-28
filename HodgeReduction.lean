/-
# HodgeReduction â€?top-level module.

Lean4 formalisation of the Mumford--Tate reduction of the Hodge Conjecture
("A Mumford--Tate Reduction of the Hodge Conjecture", Alex Chengyu Li, 2026).

The formalisation matches the state of the master proof at its current
writing. The Main Theorem is a *reduction*, not an unconditional proof: it
concludes HC on four enumerated scope sub-classes modulo nine labelled
paper hypotheses and the sub-gaps inventoried in the paper's appendix.
Several sub-branches (exotic rigid non-Shimura E7-type in dim >= 5 with
c1 != 0) are explicitly OPEN and carry no theorem statement.

Re-exports:
  * `HodgeReduction.Types`            â€?opaque types.
  * `HodgeReduction.ClassicalResults` â€?classical results (axiomatised
                                        pending Mathlib port).
  * `HodgeReduction.OpenHypotheses`   â€?nine labelled paper hypotheses
                                        (exploratory reduction-stage ledger
                                        with broken-link Phase 0 audit trail).
  * `HodgeReduction.MainTheorem`      â€?the Main Theorem and unconditional
                                        theorems, each with `sorry`.
  * `HodgeReduction.Ledger`           â€?gap ledger (status + metadata for
                                        every OPEN / PARTIAL / BLOCKED /
                                        DEAD-END / CLOSED entry; cross-
                                        session attack-history record).
  * `HodgeReduction.Strict`           â€?Cat 1-3 strict-discipline restructure
                                        (P17+). Each chain migrates from
                                        opaque-axiom reduction-stage to
                                        Cat 1+2-only derivation-stage via
                                        explicit-content Cat 2 axioms +
                                        derived theorems + honest conditional
                                        structure for open targets.
  * `HodgeReduction.Concrete`         â€?concrete instances of the abstract
                                        HC framework typeclasses. First
                                        sub-module: `HodgeReduction.Concrete.EVII`
                                        gives a concrete carrier `A_EVII`
                                        (= `Polynomial â„š` at scaffolding stage)
                                        with `CohomologyRing` / `KaehlerClass` /
                                        `Lefschetz11Data` / `HodgeCycleData`
                                        instances and a concrete
                                        `FreudenthalClassData`; the sanity-check
                                        theorem `HC_for_Concrete_EVII`
                                        specialises the abstract closure
                                        `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL`
                                        to a concrete witness.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses
import HodgeReduction.MainTheorem
import HodgeReduction.Ledger
import HodgeReduction.Strict
import HodgeReduction.CrossRingArithmetic
import HodgeReduction.Infrastructure.CartanMatrices
import HodgeReduction.Infrastructure.SchlafliGraph
import HodgeReduction.Infrastructure.Octonion
import HodgeReduction.Infrastructure.JordanJ3O
import HodgeReduction.Infrastructure.V56Freudenthal
import HodgeReduction.Infrastructure.CoxeterDegrees
import HodgeReduction.Infrastructure.PoincarePolynomialEVII
import HodgeReduction.Infrastructure.OctonionBasis
import HodgeReduction.Infrastructure.JordanJ3OBasis
import HodgeReduction.Infrastructure.V56Basis
import HodgeReduction.Infrastructure.LinearMaps
import HodgeReduction.Infrastructure.V56HodgeDecomp
import HodgeReduction.Infrastructure.J3OInnerProduct
import HodgeReduction.Infrastructure.J3OJordan
import HodgeReduction.Infrastructure.V56HodgeRank
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass
import HodgeReduction.Infrastructure.Cohomology.FreudenthalClass
import HodgeReduction.Infrastructure.Cohomology.AlgebraicBundle
import HodgeReduction.Infrastructure.Cohomology.CycleClassMap
import HodgeReduction.Infrastructure.Cohomology.Lefschetz
import HodgeReduction.Infrastructure.Cohomology.HodgeCycle
import HodgeReduction.Infrastructure.Cohomology.HardLefschetz
import HodgeReduction.Infrastructure.Cohomology.NeronSeveri
import HodgeReduction.Infrastructure.Cohomology.ChowRing
import HodgeReduction.Infrastructure.Cohomology.HCCodim1
import HodgeReduction.Infrastructure.Cohomology.PicardGroup
import HodgeReduction.Infrastructure.Cohomology.AmpleDivisor
import HodgeReduction.Infrastructure.Cohomology.Galois
import HodgeReduction.Infrastructure.Cohomology.DivisorClass
import HodgeReduction.Infrastructure.Cohomology.AlgebraicCycle
import HodgeReduction.Infrastructure.Cohomology.ChernCharacter
import HodgeReduction.Infrastructure.Cohomology.LefschetzHyperplane
import HodgeReduction.Infrastructure.Cohomology.RiemannRoch
import HodgeReduction.Infrastructure.Cohomology.SheafCohomology
import HodgeReduction.Infrastructure.Cohomology.Motive
import HodgeReduction.Infrastructure.Cohomology.Lattice
import HodgeReduction.Infrastructure.Cohomology.PoincareDuality
import HodgeReduction.Infrastructure.Cohomology.Matsushima
import HodgeReduction.Infrastructure.Cohomology.AbelJacobi
import HodgeReduction.Infrastructure.Cohomology.StandardConjectures
import HodgeReduction.Infrastructure.Cohomology.TateConjecture
import HodgeReduction.Infrastructure.Cohomology.DeRham
import HodgeReduction.Infrastructure.Cohomology.BettiCohomology
import HodgeReduction.Infrastructure.Cohomology.ComparisonTheorem
import HodgeReduction.Infrastructure.Shimura.PeriodDomain
import HodgeReduction.Infrastructure.Shimura.SchubertCells
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.HodgeStructure.MixedHodge
import HodgeReduction.Infrastructure.HodgeStructure.NilpotentOrbit
import HodgeReduction.Infrastructure.HodgeStructure.MixedHodgeModule
import HodgeReduction.Infrastructure.HodgeStructure.GaussManin
import HodgeReduction.Infrastructure.HodgeStructure.V56Instance
import HodgeReduction.Infrastructure.HodgeStructure.MumfordTate
import HodgeReduction.Infrastructure.HodgeStructure.Variation
import HodgeReduction.Infrastructure.Coxeter.WE7
import HodgeReduction.Infrastructure.Shimura.Basic
import HodgeReduction.Infrastructure.Shimura.CompactDual
import HodgeReduction.Infrastructure.Shimura.MumfordExtension
import HodgeReduction.Infrastructure.Shimura.IntersectionHomology
import HodgeReduction.Infrastructure.Shimura.HirzebruchMumford
import HodgeReduction.Infrastructure.Shimura.ToroidalCompactification
import HodgeReduction.Infrastructure.Shimura.BorelHirzebruch
import HodgeReduction.Infrastructure.Shimura.HermitianForm
import HodgeReduction.Infrastructure.Shimura.Adelic
import HodgeReduction.Infrastructure.AbelianVariety.Basic
import HodgeReduction.Infrastructure.AbelianVariety.PolarisedAV
import HodgeReduction.Infrastructure.AbelianVariety.CMType
import HodgeReduction.Infrastructure.AbelianVariety.KugaSatake
import HodgeReduction.Infrastructure.AbelianVariety.K3Surface
import HodgeReduction.Infrastructure.AbelianVariety.HyperKahler
import HodgeReduction.Infrastructure.AbelianVariety.TateModule
import HodgeReduction.Infrastructure.Shimura.HermitianSymmetric
import HodgeReduction.Infrastructure.Shimura.ArithmeticGroup
import HodgeReduction.Infrastructure.Shimura.E7ParabolicCodim
import HodgeReduction.Infrastructure.Automorphic.Basic
import HodgeReduction.Infrastructure.Automorphic.VoganZuckerman
import HodgeReduction.Infrastructure.Automorphic.AtlasE7minus25
import HodgeReduction.Infrastructure.Automorphic.BorelBottWeil
import HodgeReduction.Infrastructure.Automorphic.HeckeCorrespondence
import HodgeReduction.Infrastructure.Automorphic.ModularForm
import HodgeReduction.Infrastructure.Automorphic.GKCohomology
import HodgeReduction.Infrastructure.Automorphic.CuspidalCohomology
import HodgeReduction.Infrastructure.Automorphic.FrankeEisensteinLayer
import HodgeReduction.Infrastructure.Cohomology.BorelHirzebruchCoinvariant
import HodgeReduction.Infrastructure.LieAlgebra.Basic
import HodgeReduction.Infrastructure.LieAlgebra.ReductiveGroup
import HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundle
import HodgeReduction.Infrastructure.AlgebraicGeometry.PicardGroup
import HodgeReduction.Infrastructure.AlgebraicGeometry.FirstChernClass
import HodgeReduction.Infrastructure.AlgebraicGeometry.ExponentialSequence
-- R7 ChowGroup / HodgeDecomposition: re-enabled after R7-quarantine-fix
-- (2026-05-16). ChowGroup: fixed neg_eq_of_add_eq_zero_left â†?_right;
-- added Mathlib.RingTheory.Adjoin.Basic; fixed multi-binder âˆ? replaced
-- OfNat-on-CH-Unit with explicit â„?cast via let-binding; fixed
-- cl_intersect / cl_fundamental via Int.cast_mul / Int.cast_one.
-- HodgeDecomposition: added noncomputable to HpqTrivial/HkTrivial/
-- instHodgeDecompositionDataTrivial; fixed le_antisymm argument order;
-- replaced omega-on-complexDim with direct HpqTrivial_eq_bot_of_p_pos.
import HodgeReduction.Infrastructure.AlgebraicGeometry.ChowGroup
import HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecomposition
import HodgeReduction.Infrastructure.HCFramework
import HodgeReduction.MathlibCandidates
import HodgeReduction.HCGapRegistry
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.HodgeMorphism
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleClassPresentation
import HodgeReduction.HCGapL4.ACDReconciliation
import HodgeReduction.HCGapL4.ProductCohomology
import HodgeReduction.HCGapL4.CycleInducedCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.ShiftedCorrespondenceComposition
import HodgeReduction.HCGapL4.SHSMComposition
import HodgeReduction.HCGapL4.SHSMCompositionGeneral
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2Bridge
import HodgeReduction.HCGapL4.SHSM2MultiStep
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.GenericCycleActionMultiStep
import HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
import HodgeReduction.HCGapL4.ProductCohomologyPointProjectiveLine
import HodgeReduction.HCGapL4.PtToProjectiveLineProductCycleFactory
import HodgeReduction.HCGapL4.ProductCycleFactoryLifter
import HodgeReduction.HCGapL4.ProductCycleFactoryComposition
import HodgeReduction.HCGapL4.ProductCohomologyProjectiveLineSelf
import HodgeReduction.HCGapL4.ProductCycleFactoryProjectiveLineSelf
import HodgeReduction.HCGapL4.ProductCohomologyProjectiveLineEllipticCurve
import HodgeReduction.HCGapL4.ProductCycleFactoryProjectiveLineToEllipticCurve
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.ProductCohomologyPointTimesE7ShimuraToy
import HodgeReduction.HCGapL4.E7ShimuraToyProductCycleFactory
import HodgeReduction.HCGapL4.E7ShimuraToyV56Skeleton
import HodgeReduction.HCGapL4.E7ShimuraToyV56HodgeSkeleton
import HodgeReduction.HCGapL4.E7ShimuraToyMumfordTateCocharacter
import HodgeReduction.HCGapL4.E7ShimuraToyDeligneTorusSkeleton
import HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
import HodgeReduction.HCGapL4.E7ShimuraToyMTCorrespondencePackage
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.CMAbelianToyProductCycleToE7ShimuraToy
import HodgeReduction.HCGapL4.CMAbelianToyChainToE7ShimuraToy
import HodgeReduction.HCGapL4.E7ShimuraToyMTCorrespondenceRealization
import HodgeReduction.HCGapL4.E7ShimuraToyHermitianDomainSkeleton
import HodgeReduction.HCGapL4.E7ShimuraToyReflexFieldSkeleton
import HodgeReduction.HCGapL4.E7ShimuraDatumToySkeletonV2
import HodgeReduction.HCGapL4.E7ShimuraTorToyContainer
import HodgeReduction.HCGapL4.E7ShimuraTorFieldReplacementPlan
import HodgeReduction.HCGapL4.E7ShimuraTorCohomologyReplacement
import HodgeReduction.HCGapL4.E7ShimuraTorAlgClassesReplacement
import HodgeReduction.HCGapL4.E7ShimuraTorMTCorrespondenceReplacement
import HodgeReduction.HCGapL4.CycleClassMapReplacement
import HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement
import HodgeReduction.HCGapL4.E7ShimuraTorAlgClassesReplacementViaCycleClassMap
import HodgeReduction.HCGapL4.CohomologyReplacementMathlibAudit
import HodgeReduction.HCGapL4.CohomologyReplacementDependencyMap
import HodgeReduction.HCGapL4.CohomologyReplacementNextTarget
import HodgeReduction.HCGapL4.MTCorrespondenceMathlibAudit
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementDependencyMap
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL4.AbstractHodgeSource
import HodgeReduction.HCGapL4.AbstractHCDataPackage
import HodgeReduction.HCGapL4.AbstractHCDataWithMTTransfer
import HodgeReduction.HCGapL4.AbelianVarietyInterface
import HodgeReduction.HCGapL4.ComplexMultiplicationInterface
import HodgeReduction.HCGapL4.Deligne1982BoundaryInterface
import HodgeReduction.HCGapL4.CMSourceReplacementBridge
import HodgeReduction.HCGapL4.CMSourceBridgeNextTarget
import HodgeReduction.HCGapL4.AbelianVarietyInterfaceECRealization
import HodgeReduction.HCGapL4.AbelianVarietyInterfaceECProjectiveRealization
import HodgeReduction.HCGapL4.ComplexMultiplicationInterfaceECRealization
import HodgeReduction.HCGapL4.ComplexMultiplicationNumberFieldAudit
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import HodgeReduction.HCGapL4.CMFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.ImaginaryQuadraticFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.EllipticCurveEnd0ActionBoundary
import HodgeReduction.HCGapL4.CMFieldSequenceStoppingAudit
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.GaussianRationalConjugation
import HodgeReduction.HCGapL4.ImaginaryQuadraticFieldRealizationInterface
import HodgeReduction.HCGapL4.CMFieldRealizationInterface
import HodgeReduction.HCGapL4.EllipticCurveEnd0ActionTarget
import HodgeReduction.HCGapL4.CMFieldChainIntegration
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalBasisOneI
import HodgeReduction.HCGapL4.GaussianNumberFieldChainIntegration
import HodgeReduction.HCGapL4.GaussianPolynomialIrreducible
import HodgeReduction.HCGapL4.GaussianRationalToAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootAlgEquiv
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldClosed
import HodgeReduction.HCGapL4.GaussianNumberFieldClosureIntegration
import HodgeReduction.HCGapL4.GaussianImaginaryQuadraticEvidence
import HodgeReduction.HCGapL4.GaussianCMFieldEvidence
import HodgeReduction.HCGapL4.EllipticCurveEnd0ActionTargetRefined
import HodgeReduction.HCGapL4.GaussianCMFieldEvidenceIntegration
import HodgeReduction.HCGapL4.EllipticCurveEndomorphismRingInterface
import HodgeReduction.HCGapL4.EllipticCurveEnd0Interface
import HodgeReduction.HCGapL4.GaussianCMEllipticCurveTarget
import HodgeReduction.HCGapL4.GaussianEmbeddingIntoEnd0Target
import HodgeReduction.HCGapL4.End0CohomologyActionTarget
import HodgeReduction.HCGapL4.End0InfrastructureChainIntegration
import HodgeReduction.HCGapL4.GaussianCMEllipticCurveIsElliptic
import HodgeReduction.HCGapL4.GaussianCMEllipticCurveBaseChange
import HodgeReduction.HCGapL4.GaussianCMActionEquationPreservation
import HodgeReduction.HCGapL4.GaussianCMActionCoordinateSquare
import HodgeReduction.HCGapL4.GaussianCMActionPointMap
import HodgeReduction.HCGapL4.GaussianCMActionPointSquare
import HodgeReduction.HCGapL4.GaussianCMActionNegYCompat
import HodgeReduction.HCGapL4.GaussianCMActionSlopeCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddXCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddYCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddCasesBasic
import HodgeReduction.HCGapL4.GaussianCMActionAddCasesGeneric
import HodgeReduction.HCGapL4.GaussianCMActionAddMonoidHom
import HodgeReduction.HCGapL4.GaussianCMActionEndChainIntegration
import HodgeReduction.HCGapL4.GaussianCMActionCoordinateRing
import HodgeReduction.HCGapL4.GaussianCMActionAffineMorphismInterface
import HodgeReduction.HCGapL4.GaussianCMActionProjectiveMorphism
import HodgeReduction.HCGapL4.GaussianCMActionAlgebraicEndInterface
import HodgeReduction.HCGapL4.GaussianIntActionEndCandidate
import HodgeReduction.HCGapL4.GaussianFieldToEnd0Chain
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomOps
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomFormula
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomMultiplicative
import HodgeReduction.HCGapL4.GaussianIntActionRingHomLike
import HodgeReduction.HCGapL4.GaussianIntActionToGaussianFieldTarget
import HodgeReduction.HCGapL4.PointEndHomRationalization
import HodgeReduction.HCGapL4.PointEndHomQMultiplication
import HodgeReduction.HCGapL4.GaussianFieldActionOnPointEndQ
import HodgeReduction.HCGapL4.GaussianIntNormConjugate
import HodgeReduction.HCGapL4.GaussianIntActionNormConjugate
import HodgeReduction.HCGapL4.MTCorrespondenceSourceSideBridge
import HodgeReduction.HCGapL4.PointEndActionToCohomologyTarget
import HodgeReduction.HCGapL4.HCFrontierAfterEnd0PointAction
import HodgeReduction.HCGapL4.GaussianIntActionInvertibility
import HodgeReduction.HCGapL4.GaussianFieldLocalizationTarget
import HodgeReduction.HCGapL4.MTCorrespondenceAfterInvertibility
import HodgeReduction.HCGapL4.HCFrontierAfterInvertibility
import HodgeReduction.HCGapL4.GaussianFieldSubringPointEndQ
import HodgeReduction.HCGapL4.GaussianFieldSubringCommRing
import HodgeReduction.HCGapL4.GaussianIntActionLandsInSubfield
import HodgeReduction.HCGapL4.GaussianFieldActionViaSubring
import HodgeReduction.HCGapL4.MTCorrespondenceAfterGaussianFieldAction
import HodgeReduction.HCGapL4.HCFrontierAfterGaussianFieldAction
import HodgeReduction.HCGapL4.GaussianPairAdjoinRootAlgHom
import HodgeReduction.HCGapL4.GaussianPairToAdjoinRootAlgHom
import HodgeReduction.HCGapL4.GaussianPairAdjoinRootAlgEquiv
import HodgeReduction.HCGapL4.GaussianRationalPairAlgEquiv
import HodgeReduction.HCGapL4.GaussianFieldActionPointEndQClosed
import HodgeReduction.HCGapL4.HCFrontierAfterClosedGaussianFieldAction
import HodgeReduction.HCGapL4.GaussianFieldActionOnInternalH1
import HodgeReduction.HCGapL4.GaussianFieldActionOnInternalH2
import HodgeReduction.HCGapL4.HodgeDecompositionCompatibility
import HodgeReduction.HCGapL4.CycleClassEquivarianceTarget
import HodgeReduction.HCGapL4.MTCorrespondenceAfterCohomologyAction
import HodgeReduction.HCGapL4.HCFrontierAfterCohomologyAction
import HodgeReduction.HCGapL4.EllipticCurveCohomologyRealizationAudit
import HodgeReduction.HCGapL4.InternalMTCorrespondencePackage
import HodgeReduction.HCGapL4.InternalEllipticCycleClassMap
import HodgeReduction.HCGapL4.InternalMTPackageWithCycleData
import HodgeReduction.HCGapL4.E7ToCMCorrespondenceTargetRefined
import HodgeReduction.HCGapL4.HCFrontierAfterInternalMTPackage
import HodgeReduction.HCGapL4.InternalE7ToCMMTPackageAt
import HodgeReduction.HCGapL4.MTCorrespondenceAfterInternalE7ToCMPackage
import HodgeReduction.HCGapL4.HCFrontierAfterInternalMTPackageAtClosure
import HodgeReduction.HCGapL4.InternalToRealCohomologyBridge
import HodgeReduction.HCGapL4.InternalToRealChowBridge
import HodgeReduction.HCGapL4.CanonicalE7ShimuraTorReplacementInterface
import HodgeReduction.HCGapL4.HCFrontierAfterBridgeInterface
import HodgeReduction.HCGapL4.CanonicalFieldwiseCohomologyComparison
import HodgeReduction.HCGapL4.CanonicalFieldwiseAlgClassesComparison
import HodgeReduction.HCGapL4.CanonicalFieldwiseMTPackageComparison
import HodgeReduction.HCGapL4.HCFrontierAfterFieldwiseComparisonSkeleton
import HodgeReduction.HCGapL4.ParametricCanonicalReplacementAssumptions
import HodgeReduction.HCGapL4.ParametricCanonicalHCTransfer
import HodgeReduction.HCGapL4.ShadowCanonicalHCTheorem
import HodgeReduction.HCGapL4.AuthorizedRefactorPreparationMap
import HodgeReduction.HCGapL4.MathlibRealGeometryRevisitGate
import HodgeReduction.HCGapL4.HCFrontierAfterParametricRefactorPreparation
import HodgeReduction.HCGapL4.CanonicalConeExtractionAudit
import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor
import HodgeReduction.HCGapL4.ParametricCanonicalHCAtCodim1
import HodgeReduction.HCGapL4.ParametricHodgeConjectureReal
import HodgeReduction.HCGapL4.ParametricHCExplicitAssumptions
import HodgeReduction.HCGapL4.CanonicalRootCompatibilityWrapper
import HodgeReduction.HCGapL4.AuthorizedRefactorDryRunReport
import HodgeReduction.HCGapL4.HCFrontierAfterAuthorizedRefactorDryRun
import HodgeReduction.HCGapL4.InternalToyFullCodimHC
import HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor_AxiomFree
import HodgeReduction.HCGapL4.HCFrontierAfterAxiomFreeHeadline
import HodgeReduction.HCGapL4.ToyToRealE7VCDIdentification
import HodgeReduction.HCGapL4.ToyToRealHCTransfer
import HodgeReduction.HCGapL4.OriginalHeadlineReplacementSafetyAudit
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyWitness
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyLowCodim
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyHighCodim
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyDispatcher
import HodgeReduction.HCGapL4.HeadlineReplacementSafetyAfterPackageFamily
import HodgeReduction.HCGapL4.RealCompatibleE7CarrierProfile
import HodgeReduction.HCGapL4.RealCompatibleE7AlgClassesProfile
import HodgeReduction.HCGapL4.RealCompatibleParametricCanonicalTor
import HodgeReduction.HCGapL4.MathlibRealGeometryRevisit_R400
import HodgeReduction.HCGapL4.RealCompatibleVsToyProfileComparison
import HodgeReduction.HCGapL4.HCFrontierAfterRealCompatibleProfile
import HodgeReduction.HCGapL4.RealGeometryIdentificationSchema
import HodgeReduction.HCGapL4.RealGeometryPaperObligationLedger
import HodgeReduction.HCGapL4.ConditionalRealHeadlineTransfer
import HodgeReduction.HCGapL4.HCFrontierAfterRealGeometrySchema
import HodgeReduction.HCGapL4.CohomologyProfileComparisonSkeleton
import HodgeReduction.HCGapL4.DeligneSchmidCohomologyImportInterface
import HodgeReduction.HCGapL4.E7CohomologyProfileAdapter
import HodgeReduction.HCGapL4.CohomologyProfileComparisonConditional
import HodgeReduction.HCGapL4.HCFrontierAfterCohomologyProfileDecomposition
import HodgeReduction.HCGapL4.DegreewiseRankE7CohomologyProfile
import HodgeReduction.HCGapL4.DegreewiseRankE7HodgeStructure
import HodgeReduction.HCGapL4.DegreewiseRankE7VCDACD
import HodgeReduction.HCGapL4.DegreewiseRankParametricHC
import HodgeReduction.HCGapL4.HCFrontierAfterDegreewiseRankProfile
import HodgeReduction.HCGapL4.Deligne1971LowDegreeFragment
import HodgeReduction.HCGapL4.E7LowDegreeRankPopulation
import HodgeReduction.HCGapL4.E7HighDegreeRankTargetSchema
import HodgeReduction.HCGapL4.HCFrontierAfterFirstRankPopulation
import HodgeReduction.HCGapL4.ConnectedSmoothProjectiveH0RankOneInterface
import HodgeReduction.HCGapL4.E7H0RankOneSpecializationTarget
import HodgeReduction.HCGapL4.LowDegreeRankSchemaIntegration
import HodgeReduction.HCGapL4.MathlibRealGeometryRevisit_R425_Optional
import HodgeReduction.HCGapL4.HCFrontierAfterH0RankOneInterface
import HodgeReduction.HCGapL4.DeligneSchmidLowDegreeRankFragment
import HodgeReduction.HCGapL4.E7ConnectednessPaperPath
import HodgeReduction.HCGapL4.HCFrontierAfterSecondRankPopulation
import HodgeReduction.HCGapL4.AbstractConnectedH0RankOneTheorem
import HodgeReduction.HCGapL4.E7H0RankOneFromAbstractConnectedSource
import HodgeReduction.HCGapL4.Deligne1971H0RealizationTarget
import HodgeReduction.HCGapL4.HCFrontierAfterAbstractH0RankOne
import HodgeReduction.HCGapL4.ConnectednessToH0ConstantsAbstract
import HodgeReduction.HCGapL4.BailyBorelConnectednessTargetDecomposition
import HodgeReduction.HCGapL4.Deligne1971H0TargetDecomposition
import HodgeReduction.HCGapL4.HCFrontierAfterConnectednessH0Decomposition
import HodgeReduction.HCGapL4.LocallyConstantOnConnected
import HodgeReduction.HCGapL4.ConnectedImageQuotient
import HodgeReduction.HCGapL4.LocallyConstantToH0Realization
import HodgeReduction.HCGapL4.ConnectedImageToBailyBorelPath
import HodgeReduction.HCGapL4.SecondPaperTargetDischargeAudit
import HodgeReduction.HCGapL4.HCFrontierAfterTopologyAtoms
import HodgeReduction.HCGapL4.LocallyConstantAbstractConnectedSourceBundle
import HodgeReduction.HCGapL4.LocallyConstantH0RankOneThread
import HodgeReduction.HCGapL4.DeligneH0AfterLocallyConstantBundle
import HodgeReduction.HCGapL4.HCFrontierAfterLocallyConstantBundle
import HodgeReduction.HCGapL4.FrontA_DeligneH0SheafRealization
import HodgeReduction.HCGapL4.FrontB_BailyBorelConnectedness
import HodgeReduction.HCGapL4.FrontC_E7LowDegreeHodgeNumbers
import HodgeReduction.HCGapL4.FrontD_E7ToCMChowCorrespondence
import HodgeReduction.HCGapL4.FrontE_RealCarrierProfileMatching
import HodgeReduction.HCGapL4.R451_MultiFrontFrontierAudit
import HodgeReduction.HCGapL4.FrontC2_LowDegreeHodgeRankAlgebra
import HodgeReduction.HCGapL4.FrontB2_ConnectednessNstepPipeline
import HodgeReduction.HCGapL4.FrontE2_ProfileMatchingObligationSplit
import HodgeReduction.HCGapL4.FrontA_PauseUntilR500
import HodgeReduction.HCGapL4.R456_MultiFrontWave2Audit
import HodgeReduction.HCGapL4.FrontC3_LowDegreeHodgeEulerAlgebra
import HodgeReduction.HCGapL4.FrontB3_ArithmeticQuotientConnectedness
import HodgeReduction.HCGapL4.FrontE3_LowDegreeDataFeedsProfileMatching
import HodgeReduction.HCGapL4.R460_MultiFrontWave3Audit
import HodgeReduction.HCGapL4.FrontE4_AllCodimProfileMatchingDispatcher
import HodgeReduction.HCGapL4.FrontC4_HodgePolynomialAlgebra
import HodgeReduction.HCGapL4.FrontB4_DiscreteGroupQuotientRefinement
import HodgeReduction.HCGapL4.R465_MultiFrontWave4Audit
import HodgeReduction.HCGapL4.FrontC5_HodgePolynomialToRankAdapter
import HodgeReduction.HCGapL4.FrontB5_CompactificationConnectednessProbe
import HodgeReduction.HCGapL4.FrontE5_HodgePolynomialFeedsProfileMatching
import HodgeReduction.HCGapL4.R470_MultiFrontWave5Audit
import HodgeReduction.HCGapL4.FrontC6_AllDegreeHodgeRankAdapter
import HodgeReduction.HCGapL4.FrontE6_FeedR405ConditionalTransfer
import HodgeReduction.HCGapL4.FrontD6_Deligne1982MinimalFragment
import HodgeReduction.HCGapL4.FrontB6_MaintenanceOnly
import HodgeReduction.HCGapL4.R476_MultiFrontWave6Audit
import HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance
import HodgeReduction.HCGapL4.FrontE7_ConditionalTransferFromConcrete
import HodgeReduction.HCGapL4.FrontD7_Deligne1982ExpandedFragment
import HodgeReduction.HCGapL4.R480_MultiFrontWave7Audit
import HodgeReduction.HCGapL4.FrontC8_V56MTBridge
import HodgeReduction.HCGapL4.FrontD8_PerCodimDeligneWitness
import HodgeReduction.HCGapL4.R483_MultiFrontWave8Audit
import HodgeReduction.HCGapL4.FrontC9_EVIIHodgeNumberComputation
import HodgeReduction.HCGapL4.FrontD9_Codim2NeronSeveri
import HodgeReduction.HCGapL4.R486_MultiFrontWave9Audit
import HodgeReduction.HCGapL4.FrontD10_Codim3AndGeneralStrategy
import HodgeReduction.HCGapL4.FrontE8_ConcreteProfileR405Bridge
import HodgeReduction.HCGapL4.R489_MultiFrontWave10Audit
import HodgeReduction.HCGapL4.FrontD11_CMAbelianGaussianHC
import HodgeReduction.HCGapL4.FrontC10_V56CohomologyIdentification
import HodgeReduction.HCGapL4.R492_MultiFrontWave11Audit
import HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation
import HodgeReduction.HCGapL4.R494_MultiFrontWave12Audit
import HodgeReduction.HCGapL4.FrontE9_MTCorrespondenceWitness
import HodgeReduction.HCGapL4.R496_MultiFrontWave13Audit
import HodgeReduction.HCGapL4.FrontE10_HeadlineAssembly
import HodgeReduction.HCGapL4.R498_MultiFrontWave14Audit
import HodgeReduction.HCGapL4.ProofBlueprint
import HodgeReduction.HCGapL4.FrontC12_ClassicalCartanDerivation
import HodgeReduction.HCGapL4.R501_MultiFrontWave15Audit
import HodgeReduction.Concrete
