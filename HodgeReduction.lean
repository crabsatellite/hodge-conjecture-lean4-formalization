/-
# HodgeReduction — top-level module.

Lean4 formalisation of the Mumford--Tate reduction of the Hodge Conjecture
("A Mumford--Tate Reduction of the Hodge Conjecture", Alex Chengyu Li, 2026).

The formalisation matches the state of the master proof at its current
writing. The Main Theorem is a *reduction*, not an unconditional proof: it
concludes HC on four enumerated scope sub-classes modulo nine labelled
paper hypotheses and the sub-gaps inventoried in the paper's appendix.
Several sub-branches (exotic rigid non-Shimura E7-type in dim >= 5 with
c1 != 0) are explicitly OPEN and carry no theorem statement.

Re-exports:
  * `HodgeReduction.Types`            — opaque types.
  * `HodgeReduction.ClassicalResults` — classical results (axiomatised
                                        pending Mathlib port).
  * `HodgeReduction.OpenHypotheses`   — nine labelled paper hypotheses
                                        (exploratory reduction-stage ledger
                                        with broken-link Phase 0 audit trail).
  * `HodgeReduction.MainTheorem`      — the Main Theorem and unconditional
                                        theorems, each with `sorry`.
  * `HodgeReduction.Ledger`           — gap ledger (status + metadata for
                                        every OPEN / PARTIAL / BLOCKED /
                                        DEAD-END / CLOSED entry; cross-
                                        session attack-history record).
  * `HodgeReduction.Strict`           — Cat 1-3 strict-discipline restructure
                                        (P17+). Each chain migrates from
                                        opaque-axiom reduction-stage to
                                        Cat 1+2-only derivation-stage via
                                        explicit-content Cat 2 axioms +
                                        derived theorems + honest conditional
                                        structure for open targets.
  * `HodgeReduction.Concrete`         — concrete instances of the abstract
                                        HC framework typeclasses. First
                                        sub-module: `HodgeReduction.Concrete.EVII`
                                        gives a concrete carrier `A_EVII`
                                        (= `Polynomial ℚ` at scaffolding stage)
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
-- (2026-05-16). ChowGroup: fixed neg_eq_of_add_eq_zero_left → _right;
-- added Mathlib.RingTheory.Adjoin.Basic; fixed multi-binder ∃; replaced
-- OfNat-on-CH-Unit with explicit ℤ-cast via let-binding; fixed
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
import HodgeReduction.Concrete
