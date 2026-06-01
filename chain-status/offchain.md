# HodgeReduction -- off-chain files

Files NOT transitively reached from any endpoint, grouped by
five-way classification:


* quarantine: **0** (explicit failed-route list)
* infra:      **4** (standalone tools, audit scripts)
* registered: **163** (configured research route/gap files, off endpoint closure)
* orphan:     **253** (loaded but unreachable - investigate)
* on-disk-unloaded: **248** (file exists but not imported by any chain)


## Quarantine (0)

(none)


## Infra (standalone) (4)

| file | decls | axioms |
|------|------:|-------:|
| `HodgeReduction/AxiomInventory.lean` | 55 | 0 |
| `HodgeReduction/HCGapRegistry.lean` | 9 | 0 |
| `HodgeReduction/MainChain.lean` | 340 | 0 |
| `HodgeReduction/PaperInventory.lean` | 677 | 0 |

## Registered research routes/gaps (163)

| file | decls | axioms |
|------|------:|-------:|
| `HodgeReduction/FullHodgeGoal.lean` | 59 | 0 |
| `HodgeReduction/HCGapL2/EllipticCurve.lean` | 43 | 0 |
| `HodgeReduction/HCGapL2/ProjectiveLine.lean` | 44 | 0 |
| `HodgeReduction/HCGapL2/TrivialPoint.lean` | 22 | 0 |
| `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean` | 68 | 0 |
| `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean` | 64 | 0 |
| `HodgeReduction/HCGapL4/FrontC100_H8ResidualCartanContainmentIndependence.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/FrontC101_H8ResidualTargetInvariantLineBridge.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/FrontC102_H8ResidualTargetInvariantQuotientEquivalence.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/FrontC103_H8ResidualExactImageQuotientIndependence.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/FrontC104_H8ResidualSourceH8QuotientIndependence.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/FrontC105_H8ResidualTargetInvariantLineEquality.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/FrontC106_H8ResidualLineEqualityUpperBoundCriterion.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/FrontC107_H8ResidualLineEqualityFiniteUpperBound.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC108_H8ResidualBoundaryDataLineEquality.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/FrontC109_H8ResidualBoundaryDataEquivalence.lean` | 31 | 0 |
| `HodgeReduction/HCGapL4/FrontC10_V56CohomologyIdentification.lean` | 28 | 0 |
| `HodgeReduction/HCGapL4/FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC114_H8ResidualExactImageCartanContainmentEquivalence.lean` | 47 | 0 |
| `HodgeReduction/HCGapL4/FrontC115_H8ResidualExactImageCartanLineContainmentEquivalence.lean` | 47 | 0 |
| `HodgeReduction/HCGapL4/FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual.lean` | 46 | 0 |
| `HodgeReduction/HCGapL4/FrontC119_H8ResidualCartanBoundaryEquality.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC11_ShimuraBettiComputation.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/FrontC120_H8ResidualBoundaryDataCartanContract.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC121_H8ResidualBoundaryDataSourceInvariantRoute.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/FrontC122_H8ResidualBoundaryDataSourceH8Obstruction.lean` | 31 | 0 |
| `HodgeReduction/HCGapL4/FrontC123_H8ResidualGeneratorMultiplicityRoute.lean` | 46 | 0 |
| `HodgeReduction/HCGapL4/FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/FrontC125_H8ResidualSourceBoundaryCartanLineRoute.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/FrontC126_H8ResidualExplicitFiniteMultiplicityRoute.lean` | 49 | 0 |
| `HodgeReduction/HCGapL4/FrontC127_H8ResidualLineContainmentExplicitFiniteRoute.lean` | 50 | 0 |
| `HodgeReduction/HCGapL4/FrontC12_V56InfrastructureProfileBridge.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/FrontC13_MatsushimaV56BoundaryBridge.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/FrontC14_CartanCompactDualSourceBridge.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/FrontC15_MatsushimaBoundaryRankCriterion.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC16_MatsushimaTargetContainmentFromSource.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC17_MatsushimaTargetRankFromSource.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC18_MatsushimaSourceCompactDualRankBridge.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC19_MatsushimaSourceCompactDualObstruction.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/FrontC20_MatsushimaCompactDualExactImageCriterion.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC21_MatsushimaExactImageRankBoundary.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC22_MatsushimaExactImageSourceEquivalence.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC23_MatsushimaCompactDualRankOne.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC24_CartanImageTrivialRank.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/FrontC25_CartanLineBoundaryExactness.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC26_CartanLineExactnessObstruction.lean` | 31 | 0 |
| `HodgeReduction/HCGapL4/FrontC27_CartanImageScalarPreimage.lean` | 5 | 0 |
| `HodgeReduction/HCGapL4/FrontC28_ScalarPreimageObstruction.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/FrontC29_CartanImageFromRankOne.lean` | 5 | 0 |
| `HodgeReduction/HCGapL4/FrontC30_SourceInvariantsH8TargetRank.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC31_TargetRankFromExpectedBetti.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC32_SourceInvariantsH8CarrierCriterion.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC33_CompactDualH8CarrierCriterion.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC34_CartanContainmentsForCompactDual.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/FrontC35_SourceCartanContainments.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC36_TargetBettiObstruction.lean` | 37 | 0 |
| `HodgeReduction/HCGapL4/FrontC37_TargetRankHodgeSumBridge.lean` | 5 | 0 |
| `HodgeReduction/HCGapL4/FrontC38_TargetHodgeSumFromCartanImage.lean` | 5 | 0 |
| `HodgeReduction/HCGapL4/FrontC39_TargetHodgeSumFromScalarPreimage.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC40_TargetRankScalarPreimageEquivalence.lean` | 8 | 0 |
| `HodgeReduction/HCGapL4/FrontC41_CartanContainmentCarrierEquivalence.lean` | 9 | 0 |
| `HodgeReduction/HCGapL4/FrontC42_H8CarrierEqualityRoute.lean` | 9 | 0 |
| `HodgeReduction/HCGapL4/FrontC43_H8BoundaryEqualityRoute.lean` | 9 | 0 |
| `HodgeReduction/HCGapL4/FrontC44_BoundaryDataH8Equivalence.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/FrontC45_H8BoundaryDataObstruction.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC46_TargetSurjectivityContainmentCriterion.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/FrontC47_TargetContainmentScalarPreimageCriterion.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/FrontC48_H8BoundaryRankOneCriterion.lean` | 8 | 0 |
| `HodgeReduction/HCGapL4/FrontC49_H8BoundaryExpectedBettiCriterion.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC50_H8ResidualObligationPackage.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/FrontC51_H8ResidualScalarPreimagePackage.lean` | 19 | 0 |
| `HodgeReduction/HCGapL4/FrontC52_H8ResidualBoundaryPackage.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/FrontC53_H8ResidualBoundaryDataPackage.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/FrontC54_H8ResidualExactImagePackage.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/FrontC55_H8ResidualExactImageRankOnePackage.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/FrontC56_H8ResidualCartanRankOnePackage.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/FrontC57_H8ResidualSourceInvariantTargetRankPackage.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/FrontC58_H8ResidualSourceInvariantNormalization.lean` | 6 | 0 |
| `HodgeReduction/HCGapL4/FrontC59_H8ResidualExpectedBettiPackage.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/FrontC60_H8ResidualSourceCarrierSplitPackage.lean` | 19 | 0 |
| `HodgeReduction/HCGapL4/FrontC61_H8ResidualCompactDualCarrierPackage.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.lean` | 23 | 0 |
| `HodgeReduction/HCGapL4/FrontC63_H8ResidualPrimitiveGapSplit.lean` | 47 | 0 |
| `HodgeReduction/HCGapL4/FrontC64_H8ResidualScalarPreimagePrimitiveSplit.lean` | 37 | 0 |
| `HodgeReduction/HCGapL4/FrontC65_H8ResidualPrimitiveTargetLedger.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC66_H8ResidualEqualityTargetLedger.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/FrontC67_H8ResidualRankOneReconciliation.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/FrontC68_H8ResidualCarrierEqualityObstruction.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/FrontC69_H8ResidualProofWorkContract.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/FrontC70_H8ResidualSourceInvariantScalarContract.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/FrontC71_H8ResidualSourceInvariantExactImageContract.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/FrontC72_H8ResidualExactImageContainmentContract.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/FrontC73_H8ResidualExactImageContainmentObstruction.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/FrontC74_H8ResidualTargetInvariantSaturation.lean` | 53 | 0 |
| `HodgeReduction/HCGapL4/FrontC75_H8ResidualTargetInvariantRankCriterion.lean` | 48 | 0 |
| `HodgeReduction/HCGapL4/FrontC76_H8ResidualRankCriterionReconciliation.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/FrontC77_H8ResidualTargetInvariantExcessQuotient.lean` | 51 | 0 |
| `HodgeReduction/HCGapL4/FrontC78_H8ResidualTargetInvariantInternalQuotient.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC79_H8ResidualTargetInvariantExcessFinrank.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/FrontC7_E7EVIIHodgeDiamondInstance.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/FrontC80_H8ResidualTargetInvariantUpperBound.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC81_H8ResidualTrivialModuleUpperBound.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC82_H8ResidualAtlasMultiplicityCriterion.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC83_H8ResidualCartanImageScalarPreimage.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/FrontC84_H8ResidualScalarPreimageQuotientEquivalence.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/FrontC85_H8ResidualQuotientUpperBoundNoFinite.lean` | 31 | 0 |
| `HodgeReduction/HCGapL4/FrontC86_H8ResidualTargetInvariantPreimageCriterion.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/FrontC87_H8ResidualInvariantMapSurjectivity.lean` | 49 | 0 |
| `HodgeReduction/HCGapL4/FrontC88_H8ResidualInvariantMapBijectivity.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/FrontC89_H8ResidualInvariantMapRightInverse.lean` | 48 | 0 |
| `HodgeReduction/HCGapL4/FrontC8_V56MTBridge.lean` | 28 | 0 |
| `HodgeReduction/HCGapL4/FrontC90_H8ResidualInvariantMapRightInverseEquivalence.lean` | 35 | 0 |
| `HodgeReduction/HCGapL4/FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/FrontC92_H8ResidualCartanGeneratorLineCriterion.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/FrontC93_H8ResidualLineContainmentFromMultiplicity.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/FrontC94_H8ResidualQuotientLineContainmentEquivalence.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/FrontC95_H8ResidualSourceNoExtraFromLineContainment.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC96_H8ResidualSourceGeneratorFromCompactDual.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/FrontC97_H8ResidualCartanToCompactDualLine.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/FrontC98_H8ResidualExactImageIndependence.lean` | 56 | 0 |
| `HodgeReduction/HCGapL4/FrontC99_H8ResidualTargetLineIndependence.lean` | 25 | 0 |
| `HodgeReduction/HCGapL4/FrontC9_EVIIHodgeNumberComputation.lean` | 35 | 0 |
| `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean` | 62 | 0 |
| `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean` | 74 | 0 |
| `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean` | 68 | 0 |
| `HodgeReduction/HCGapL4/R451_MultiFrontFrontierAudit.lean` | 57 | 0 |
| `HodgeReduction/HCGapL4/R456_MultiFrontWave2Audit.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/R460_MultiFrontWave3Audit.lean` | 57 | 0 |
| `HodgeReduction/HCGapL4/R465_MultiFrontWave4Audit.lean` | 58 | 0 |
| `HodgeReduction/HCGapL4/R470_MultiFrontWave5Audit.lean` | 62 | 0 |
| `HodgeReduction/Infrastructure/Automorphic/VoganZuckerman.lean` | 19 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/Matsushima.lean` | 50 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/SheafCohomology.lean` | 48 | 0 |
| `HodgeReduction/Infrastructure/HodgeStructure/MumfordTate.lean` | 70 | 0 |
| `HodgeReduction/Infrastructure/HodgeStructure/V56Instance.lean` | 103 | 0 |
| `HodgeReduction/Infrastructure/Shimura/ToroidalCompactification.lean` | 49 | 0 |
| `HodgeReduction/Infrastructure/V56HodgeDecomp.lean` | 82 | 0 |
| `HodgeReduction/Research/AnisotropicResidue.lean` | 2 | 0 |
| `HodgeReduction/Research/CMFibreDensity.lean` | 21 | 0 |
| `HodgeReduction/Research/ClassicalExternalStatus.lean` | 112 | 0 |
| `HodgeReduction/Research/E7ArithmeticityPipeline.lean` | 29 | 0 |
| `HodgeReduction/Research/E7BBTSpreading.lean` | 72 | 0 |
| `HodgeReduction/Research/E7CMAlgebraicity.lean` | 27 | 0 |
| `HodgeReduction/Research/E7ChernWeilBridge.lean` | 29 | 0 |
| `HodgeReduction/Research/E7ResidualStatus.lean` | 130 | 0 |
| `HodgeReduction/Research/E7ThetaModularity.lean` | 88 | 0 |
| `HodgeReduction/Research/FibreTransfer.lean` | 43 | 0 |
| `HodgeReduction/Research/HBundleStatus.lean` | 69 | 0 |
| `HodgeReduction/Research/LatticeGap.lean` | 18 | 0 |
| `HodgeReduction/Research/MainTheoremInputStatus.lean` | 121 | 0 |
| `HodgeReduction/Research/MainTheoremResidualStatus.lean` | 84 | 0 |
| `HodgeReduction/Research/MokCircularity.lean` | 16 | 0 |
| `HodgeReduction/Research/OmegaDiagonal.lean` | 33 | 0 |
| `HodgeReduction/Research/PadicDescent.lean` | 22 | 0 |
| `HodgeReduction/Research/Q4AbelianAlgebraicity.lean` | 22 | 0 |
| `HodgeReduction/Research/ShimuraTypeFibre.lean` | 32 | 0 |
| `HodgeReduction/Research/WitnessLatticeHypothesis.lean` | 28 | 0 |

## Orphan (warning - investigate) (253)

| file | decls | axioms |
|------|------:|-------:|
| `HodgeReduction.lean` | 0 | 0 |
| `HodgeReduction/HCGapL4/AbelianVarietyInterface.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/AbelianVarietyInterfaceECRealization.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/AbstractConnectedH0RankOneTheorem.lean` | 48 | 0 |
| `HodgeReduction/HCGapL4/AuthorizedRefactorDryRunReport.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/AuthorizedRefactorPreparationMap.lean` | 47 | 0 |
| `HodgeReduction/HCGapL4/BailyBorelConnectednessTargetDecomposition.lean` | 86 | 0 |
| `HodgeReduction/HCGapL4/CMAbelianToySkeleton.lean` | 52 | 0 |
| `HodgeReduction/HCGapL4/CMFieldChainIntegration.lean` | 37 | 0 |
| `HodgeReduction/HCGapL4/CMFieldInterfaceSkeleton.lean` | 63 | 0 |
| `HodgeReduction/HCGapL4/CMFieldRealizationInterface.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/CanonicalE7ShimuraTorReplacementInterface.lean` | 38 | 0 |
| `HodgeReduction/HCGapL4/CanonicalFieldwiseAlgClassesComparison.lean` | 59 | 0 |
| `HodgeReduction/HCGapL4/CanonicalFieldwiseCohomologyComparison.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/CanonicalFieldwiseMTPackageComparison.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/CanonicalRootCompatibilityWrapper.lean` | 14 | 0 |
| `HodgeReduction/HCGapL4/ClassicalCartanProof.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/CohomologyProfileComparisonConditional.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/CohomologyProfileComparisonSkeleton.lean` | 47 | 0 |
| `HodgeReduction/HCGapL4/ComplexMultiplicationInterface.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/ComplexMultiplicationInterfaceECRealization.lean` | 37 | 0 |
| `HodgeReduction/HCGapL4/ComplexMultiplicationNumberFieldAudit.lean` | 86 | 0 |
| `HodgeReduction/HCGapL4/ComplexMultiplicationQuadraticFieldCandidate.lean` | 49 | 0 |
| `HodgeReduction/HCGapL4/ConditionalRealHeadlineTransfer.lean` | 25 | 0 |
| `HodgeReduction/HCGapL4/ConnectedImageQuotient.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/ConnectedImageToBailyBorelPath.lean` | 67 | 0 |
| `HodgeReduction/HCGapL4/ConnectedSmoothProjectiveH0RankOneInterface.lean` | 75 | 0 |
| `HodgeReduction/HCGapL4/ConnectednessToH0ConstantsAbstract.lean` | 53 | 0 |
| `HodgeReduction/HCGapL4/CycleClassEquivarianceTarget.lean` | 14 | 0 |
| `HodgeReduction/HCGapL4/CycleClassPresentation.lean` | 74 | 0 |
| `HodgeReduction/HCGapL4/CycleInducedCodim1.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/CycleInducedCorrespondence.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/DegreewiseRankE7CohomologyProfile.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/DegreewiseRankE7HodgeStructure.lean` | 50 | 0 |
| `HodgeReduction/HCGapL4/DegreewiseRankE7VCDACD.lean` | 27 | 0 |
| `HodgeReduction/HCGapL4/DegreewiseRankParametricHC.lean` | 26 | 0 |
| `HodgeReduction/HCGapL4/Deligne1971H0RealizationTarget.lean` | 62 | 0 |
| `HodgeReduction/HCGapL4/Deligne1971H0TargetDecomposition.lean` | 87 | 0 |
| `HodgeReduction/HCGapL4/Deligne1971LowDegreeFragment.lean` | 67 | 0 |
| `HodgeReduction/HCGapL4/DeligneH0AfterLocallyConstantBundle.lean` | 68 | 0 |
| `HodgeReduction/HCGapL4/DeligneSchmidCohomologyImportInterface.lean` | 59 | 0 |
| `HodgeReduction/HCGapL4/DeligneSchmidLowDegreeRankFragment.lean` | 73 | 0 |
| `HodgeReduction/HCGapL4/E6V27VacuityBridge.lean` | 21 | 0 |
| `HodgeReduction/HCGapL4/E7CohomologyProfileAdapter.lean` | 62 | 0 |
| `HodgeReduction/HCGapL4/E7ConnectednessPaperPath.lean` | 66 | 0 |
| `HodgeReduction/HCGapL4/E7H0RankOneFromAbstractConnectedSource.lean` | 64 | 0 |
| `HodgeReduction/HCGapL4/E7H0RankOneSpecializationTarget.lean` | 58 | 0 |
| `HodgeReduction/HCGapL4/E7HighDegreeRankTargetSchema.lean` | 90 | 0 |
| `HodgeReduction/HCGapL4/E7LowDegreeRankPopulation.lean` | 29 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraDatumToySkeleton.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyCarrier.lean` | 24 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyDeligneTorusSkeleton.lean` | 54 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyMTCorrespondencePackage.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyMumfordTateCocharacter.lean` | 39 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyProductCycleFactory.lean` | 21 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyV56HodgeSkeleton.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/E7ShimuraToyV56Skeleton.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/E7ToCMCorrespondenceTargetRefined.lean` | 49 | 0 |
| `HodgeReduction/HCGapL4/EllipticCurveEnd0ActionTarget.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/EllipticCurveEnd0ActionTargetRefined.lean` | 48 | 0 |
| `HodgeReduction/HCGapL4/EllipticCurveEnd0Interface.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/EllipticCurveEndomorphismRingInterface.lean` | 53 | 0 |
| `HodgeReduction/HCGapL4/End0CohomologyActionTarget.lean` | 31 | 0 |
| `HodgeReduction/HCGapL4/End0InfrastructureChainIntegration.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/FrontA_PauseUntilR500.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/FrontB2_ConnectednessNstepPipeline.lean` | 81 | 0 |
| `HodgeReduction/HCGapL4/FrontB3_ArithmeticQuotientConnectedness.lean` | 87 | 0 |
| `HodgeReduction/HCGapL4/FrontB4_DiscreteGroupQuotientRefinement.lean` | 97 | 0 |
| `HodgeReduction/HCGapL4/FrontB5_CompactificationConnectednessProbe.lean` | 93 | 0 |
| `HodgeReduction/HCGapL4/FrontC2_LowDegreeHodgeRankAlgebra.lean` | 83 | 0 |
| `HodgeReduction/HCGapL4/FrontC3_LowDegreeHodgeEulerAlgebra.lean` | 80 | 0 |
| `HodgeReduction/HCGapL4/FrontC4_HodgePolynomialAlgebra.lean` | 70 | 0 |
| `HodgeReduction/HCGapL4/FrontC5_HodgePolynomialToRankAdapter.lean` | 102 | 0 |
| `HodgeReduction/HCGapL4/FrontE2_ProfileMatchingObligationSplit.lean` | 93 | 0 |
| `HodgeReduction/HCGapL4/FrontE3_LowDegreeDataFeedsProfileMatching.lean` | 83 | 0 |
| `HodgeReduction/HCGapL4/FrontE4_AllCodimProfileMatchingDispatcher.lean` | 77 | 0 |
| `HodgeReduction/HCGapL4/FrontE5_HodgePolynomialFeedsProfileMatching.lean` | 82 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionAddCasesBasic.lean` | 10 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionAddCasesGeneric.lean` | 9 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionAddMonoidHom.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionAddXCompat.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionAddYCompat.lean` | 9 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionCoordinateSquare.lean` | 13 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionEquationPreservation.lean` | 9 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionNegYCompat.lean` | 5 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionPointMap.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionPointSquare.lean` | 8 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMActionSlopeCompat.lean` | 7 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMEllipticCurveBaseChange.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMEllipticCurveIsElliptic.lean` | 15 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMEllipticCurveTarget.lean` | 15 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMFieldEvidence.lean` | 68 | 0 |
| `HodgeReduction/HCGapL4/GaussianCMFieldEvidenceIntegration.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/GaussianEmbeddingIntoEnd0Target.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldActionOnInternalH1.lean` | 29 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldActionOnInternalH2.lean` | 25 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldActionOnPointEndQ.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldActionPointEndQClosed.lean` | 25 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldActionViaSubring.lean` | 15 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldLocalizationTarget.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldSubringCommRing.lean` | 88 | 0 |
| `HodgeReduction/HCGapL4/GaussianFieldSubringPointEndQ.lean` | 36 | 0 |
| `HodgeReduction/HCGapL4/GaussianImaginaryQuadraticEvidence.lean` | 57 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionAddMonoidHomFormula.lean` | 22 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionAddMonoidHomMultiplicative.lean` | 14 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionAddMonoidHomOps.lean` | 28 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionInvertibility.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionLandsInSubfield.lean` | 10 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionNormConjugate.lean` | 14 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntActionRingHomLike.lean` | 30 | 0 |
| `HodgeReduction/HCGapL4/GaussianIntNormConjugate.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/GaussianNumberFieldClosureIntegration.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/GaussianPairAdjoinRootAlgEquiv.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/GaussianPairAdjoinRootAlgHom.lean` | 20 | 0 |
| `HodgeReduction/HCGapL4/GaussianPairToAdjoinRootAlgHom.lean` | 24 | 0 |
| `HodgeReduction/HCGapL4/GaussianPolynomialIrreducible.lean` | 14 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalAdjoinRoot.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalAdjoinRootAlgEquiv.lean` | 20 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalAdjoinRootEquiv.lean` | 38 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalConjugation.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalConjugationLift.lean` | 19 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalNumberFieldClosed.lean` | 24 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalNumberFieldConstruction.lean` | 52 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalNumberFieldTarget.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalPairAlgEquiv.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/GaussianRationalToAdjoinRoot.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/GenericCycleAction.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/GenericCycleActionMultiStep.lean` | 10 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterAbstractH0RankOne.lean` | 54 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterAuthorizedRefactorDryRun.lean` | 39 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterAxiomFreeHeadline.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterBridgeInterface.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterClosedGaussianFieldAction.lean` | 72 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterCohomologyAction.lean` | 39 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterCohomologyProfileDecomposition.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterConnectednessH0Decomposition.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterDegreewiseRankProfile.lean` | 53 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterEnd0PointAction.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterFieldwiseComparisonSkeleton.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterFirstRankPopulation.lean` | 50 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterGaussianFieldAction.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterH0RankOneInterface.lean` | 51 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterInternalMTPackageAtClosure.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterInvertibility.lean` | 36 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterLocallyConstantBundle.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterRealCompatibleProfile.lean` | 48 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterRealGeometrySchema.lean` | 53 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterSecondRankPopulation.lean` | 71 | 0 |
| `HodgeReduction/HCGapL4/HCFrontierAfterTopologyAtoms.lean` | 54 | 0 |
| `HodgeReduction/HCGapL4/HeadlineReplacementSafetyAfterPackageFamily.lean` | 43 | 0 |
| `HodgeReduction/HCGapL4/HodgeDecompositionCompatibility.lean` | 12 | 0 |
| `HodgeReduction/HCGapL4/HodgeMorphism.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/ImaginaryQuadraticFieldRealizationInterface.lean` | 55 | 0 |
| `HodgeReduction/HCGapL4/InducedAlgClassMap.lean` | 20 | 0 |
| `HodgeReduction/HCGapL4/InternalCycleActionWithProductCycle.lean` | 29 | 0 |
| `HodgeReduction/HCGapL4/InternalE7ToCMMTPackageAt.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/InternalEllipticCycleClassMap.lean` | 36 | 0 |
| `HodgeReduction/HCGapL4/InternalMTCorrespondencePackage.lean` | 35 | 0 |
| `HodgeReduction/HCGapL4/InternalMTPackageWithCycleData.lean` | 28 | 0 |
| `HodgeReduction/HCGapL4/InternalToRealChowBridge.lean` | 49 | 0 |
| `HodgeReduction/HCGapL4/InternalToRealCohomologyBridge.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/InternalToyFullCodimHC.lean` | 10 | 0 |
| `HodgeReduction/HCGapL4/LocallyConstantAbstractConnectedSourceBundle.lean` | 51 | 0 |
| `HodgeReduction/HCGapL4/LocallyConstantH0RankOneThread.lean` | 64 | 0 |
| `HodgeReduction/HCGapL4/LocallyConstantOnConnected.lean` | 52 | 0 |
| `HodgeReduction/HCGapL4/LocallyConstantToH0Realization.lean` | 74 | 0 |
| `HodgeReduction/HCGapL4/LowDegreeRankSchemaIntegration.lean` | 68 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceAfterCohomologyAction.lean` | 45 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceAfterGaussianFieldAction.lean` | 50 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceAfterInternalE7ToCMPackage.lean` | 47 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceAfterInvertibility.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceMathlibAudit.lean` | 37 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceReplacementDependencyMap.lean` | 90 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceReplacementNextTarget.lean` | 53 | 0 |
| `HodgeReduction/HCGapL4/MTCorrespondenceSourceSideBridge.lean` | 46 | 0 |
| `HodgeReduction/HCGapL4/MathlibRealGeometryRevisitGate.lean` | 33 | 0 |
| `HodgeReduction/HCGapL4/MathlibRealGeometryRevisit_R400.lean` | 38 | 0 |
| `HodgeReduction/HCGapL4/MathlibRealGeometryRevisit_R425_Optional.lean` | 39 | 0 |
| `HodgeReduction/HCGapL4/NontrivialCorrespondence.lean` | 24 | 0 |
| `HodgeReduction/HCGapL4/OriginalHeadlineReplacementSafetyAudit.lean` | 40 | 0 |
| `HodgeReduction/HCGapL4/ParametricCanonicalE7ShimuraTor.lean` | 44 | 0 |
| `HodgeReduction/HCGapL4/ParametricCanonicalE7ShimuraTor_AxiomFree.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/ParametricCanonicalHCAtCodim1.lean` | 14 | 0 |
| `HodgeReduction/HCGapL4/ParametricCanonicalHCTransfer.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/ParametricCanonicalReplacementAssumptions.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/ParametricFullCodimMTPackageWitness.lean` | 20 | 0 |
| `HodgeReduction/HCGapL4/ParametricHCExplicitAssumptions.lean` | 34 | 0 |
| `HodgeReduction/HCGapL4/ParametricHodgeConjectureReal.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/PointEndActionToCohomologyTarget.lean` | 28 | 0 |
| `HodgeReduction/HCGapL4/PointEndHomQMultiplication.lean` | 46 | 0 |
| `HodgeReduction/HCGapL4/PointEndHomRationalization.lean` | 25 | 0 |
| `HodgeReduction/HCGapL4/ProductCohomology.lean` | 38 | 0 |
| `HodgeReduction/HCGapL4/ProductCohomologyPointProjectiveLine.lean` | 23 | 0 |
| `HodgeReduction/HCGapL4/ProductCohomologyPointTimesE7ShimuraToy.lean` | 19 | 0 |
| `HodgeReduction/HCGapL4/ProductCycleFactoryLifter.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/PtToProjectiveLineProductCycleFactory.lean` | 24 | 0 |
| `HodgeReduction/HCGapL4/RealCompatibleE7AlgClassesProfile.lean` | 41 | 0 |
| `HodgeReduction/HCGapL4/RealCompatibleE7CarrierProfile.lean` | 62 | 0 |
| `HodgeReduction/HCGapL4/RealCompatibleParametricCanonicalTor.lean` | 25 | 0 |
| `HodgeReduction/HCGapL4/RealCompatibleVsToyProfileComparison.lean` | 39 | 0 |
| `HodgeReduction/HCGapL4/RealGeometryIdentificationSchema.lean` | 64 | 0 |
| `HodgeReduction/HCGapL4/RealGeometryPaperObligationLedger.lean` | 71 | 0 |
| `HodgeReduction/HCGapL4/SHSM2MultiStep.lean` | 11 | 0 |
| `HodgeReduction/HCGapL4/SecondPaperTargetDischargeAudit.lean` | 42 | 0 |
| `HodgeReduction/HCGapL4/ShadowCanonicalHCTheorem.lean` | 17 | 0 |
| `HodgeReduction/HCGapL4/ShiftedCorrespondence.lean` | 19 | 0 |
| `HodgeReduction/HCGapL4/ShiftedCorrespondenceSHSM.lean` | 16 | 0 |
| `HodgeReduction/HCGapL4/ShiftedCorrespondenceSHSM2.lean` | 18 | 0 |
| `HodgeReduction/HCGapL4/ToyToRealE7VCDIdentification.lean` | 57 | 0 |
| `HodgeReduction/HCGapL4/ToyToRealHCTransfer.lean` | 38 | 0 |
| `HodgeReduction/HCGapL4/ToyToRealPackageFamilyDispatcher.lean` | 27 | 0 |
| `HodgeReduction/HCGapL4/ToyToRealPackageFamilyHighCodim.lean` | 32 | 0 |
| `HodgeReduction/HCGapL4/ToyToRealPackageFamilyLowCodim.lean` | 31 | 0 |
| `HodgeReduction/HCGapL4/ToyToRealPackageFamilyWitness.lean` | 44 | 0 |
| `HodgeReduction/Infrastructure/AbelianVariety/Basic.lean` | 81 | 0 |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/ChowGroup.lean` | 71 | 0 |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/HodgeDecomposition.lean` | 49 | 0 |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/LineBundle.lean` | 58 | 0 |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/PicardGroup.lean` | 48 | 0 |
| `HodgeReduction/Infrastructure/Automorphic/AtlasE7minus25.lean` | 51 | 0 |
| `HodgeReduction/Infrastructure/Automorphic/Basic.lean` | 49 | 0 |
| `HodgeReduction/Infrastructure/Automorphic/CuspidalCohomology.lean` | 26 | 0 |
| `HodgeReduction/Infrastructure/Automorphic/GKCohomology.lean` | 50 | 0 |
| `HodgeReduction/Infrastructure/CartanMatrices.lean` | 10 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/AlgebraicBundle.lean` | 74 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/Basic.lean` | 53 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/ChernClasses.lean` | 81 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/CycleClassMap.lean` | 55 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/FreudenthalClass.lean` | 59 | 0 |
| `HodgeReduction/Infrastructure/Cohomology/KaehlerClass.lean` | 62 | 0 |
| `HodgeReduction/Infrastructure/Coxeter/WE7.lean` | 52 | 0 |
| `HodgeReduction/Infrastructure/CoxeterDegrees.lean` | 19 | 0 |
| `HodgeReduction/Infrastructure/DynkinMarks.lean` | 18 | 0 |
| `HodgeReduction/Infrastructure/E7ParabolicDimensions.lean` | 13 | 0 |
| `HodgeReduction/Infrastructure/HCFramework.lean` | 3 | 0 |
| `HodgeReduction/Infrastructure/HodgeStructure/Polarised.lean` | 61 | 0 |
| `HodgeReduction/Infrastructure/HodgeStructure/Variation.lean` | 67 | 0 |
| `HodgeReduction/Infrastructure/J3OInnerProduct.lean` | 3 | 0 |
| `HodgeReduction/Infrastructure/JordanJ3O.lean` | 83 | 0 |
| `HodgeReduction/Infrastructure/JordanJ3OBasis.lean` | 21 | 0 |
| `HodgeReduction/Infrastructure/KostantCominusculeClassification.lean` | 1 | 0 |
| `HodgeReduction/Infrastructure/LinearMaps.lean` | 24 | 0 |
| `HodgeReduction/Infrastructure/Octonion.lean` | 158 | 0 |
| `HodgeReduction/Infrastructure/OctonionBasis.lean` | 14 | 0 |
| `HodgeReduction/Infrastructure/Shimura/Basic.lean` | 72 | 0 |
| `HodgeReduction/Infrastructure/Shimura/CompactDual.lean` | 49 | 0 |
| `HodgeReduction/Infrastructure/Shimura/MumfordExtension.lean` | 22 | 0 |
| `HodgeReduction/Infrastructure/SimpleLieAlgebraClassification.lean` | 110 | 0 |
| `HodgeReduction/Infrastructure/V56Basis.lean` | 17 | 0 |
| `HodgeReduction/Infrastructure/V56BranchingRules.lean` | 18 | 0 |
| `HodgeReduction/Infrastructure/V56Freudenthal.lean` | 121 | 0 |
| `HodgeReduction/Infrastructure/V56HodgeRank.lean` | 33 | 0 |
| `HodgeReduction/MathlibCandidates.lean` | 123 | 0 |

## On-disk-unloaded (248)

Files present in the source tree but NOT imported by the entry script.  Either wire them into the chain, mark them quarantine, or delete them.

- `HodgeReduction/Concrete.lean`
- `HodgeReduction/Concrete/EVII.lean`
- `HodgeReduction/ConeAudits/R217_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R218_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R219_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R220_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R221_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R222_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R223_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R224_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R225_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R226_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R227_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R228_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R229_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R230_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R231_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R232_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R233_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R234_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R235_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R236_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R237_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R238_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R239_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R240_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R241_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R242_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R243_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R244_R247_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R248_R250_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R251_R253_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R254_R256_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R257_R259_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R260_R264_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R265A_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R265B_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R266_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R267A_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R267B_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R268_R272_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R273_R278_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R279_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R280_R283_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R284_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R285_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R286_R288_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R289_R292_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R293_R298_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R301_R304_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R305_R309_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R310_R315_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R316_R320_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R321_R326_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R327_R332_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R333_R338_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R339_R344_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R345_R350_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R351_R356_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R357_R362_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R363_R366_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R367_R370_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R371_R376_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R377_R384_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R385_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R385_R388_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R386_R387_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R389_R391_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R392_R396_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R397_R402_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R403_R406_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R407_R411_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R412_R416_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R417_R420_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R421_R425_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R426_R428_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R429_R432_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R433_R436_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R437_R442_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R443a_R446_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R451_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R452_R456_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R457_R460_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R462_R465_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean`
- `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean`
- `HodgeReduction/CrossRingArithmetic.lean`
- `HodgeReduction/HCGapL2/AbelianSurface.lean`
- `HodgeReduction/HCGapL2/EVIICohomologyModel.lean`
- `HodgeReduction/HCGapL2/ProjectivePlane.lean`
- `HodgeReduction/HCGapL2/ProjectiveThreeSpace.lean`
- `HodgeReduction/HCGapL2/QuadricSurface.lean`
- `HodgeReduction/HCGapL4/ACDReconciliation.lean`
- `HodgeReduction/HCGapL4/AbelianVarietyInterfaceECProjectiveRealization.lean`
- `HodgeReduction/HCGapL4/AbstractHCDataPackage.lean`
- `HodgeReduction/HCGapL4/AbstractHCDataWithMTTransfer.lean`
- `HodgeReduction/HCGapL4/AbstractHodgeSource.lean`
- `HodgeReduction/HCGapL4/CMAbelianToyChainToE7ShimuraToy.lean`
- `HodgeReduction/HCGapL4/CMAbelianToyProductCycleToE7ShimuraToy.lean`
- `HodgeReduction/HCGapL4/CMFieldSequenceStoppingAudit.lean`
- `HodgeReduction/HCGapL4/CMSourceBridgeNextTarget.lean`
- `HodgeReduction/HCGapL4/CMSourceReplacementBridge.lean`
- `HodgeReduction/HCGapL4/CY3NonexistenceDecomposition.lean`
- `HodgeReduction/HCGapL4/CY3NonexistenceProof.lean`
- `HodgeReduction/HCGapL4/CY3SpringerDiscriminant.lean`
- `HodgeReduction/HCGapL4/CanonicalConeExtractionAudit.lean`
- `HodgeReduction/HCGapL4/ClassicalCartanGapCard.lean`
- `HodgeReduction/HCGapL4/CohomologyReplacementDependencyMap.lean`
- `HodgeReduction/HCGapL4/CohomologyReplacementMathlibAudit.lean`
- `HodgeReduction/HCGapL4/CohomologyReplacementNextTarget.lean`
- `HodgeReduction/HCGapL4/CycleClassMapReplacement.lean`
- `HodgeReduction/HCGapL4/Deligne1982BoundaryInterface.lean`
- `HodgeReduction/HCGapL4/DeligneCMHCSkeleton.lean`
- `HodgeReduction/HCGapL4/E6CaseClosureConstraints.lean`
- `HodgeReduction/HCGapL4/E6CaseProof.lean`
- `HodgeReduction/HCGapL4/E7ShimuraDatumToySkeletonV2.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorAlgClassesReplacement.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorAlgClassesReplacementViaCycleClassMap.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorCohomologyReplacement.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorDecomposition.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorFieldReplacementPlan.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorMTCorrespondenceReplacement.lean`
- `HodgeReduction/HCGapL4/E7ShimuraTorToyContainer.lean`
- `HodgeReduction/HCGapL4/E7ShimuraToyCycleClassMapReplacement.lean`
- `HodgeReduction/HCGapL4/E7ShimuraToyHermitianDomainSkeleton.lean`
- `HodgeReduction/HCGapL4/E7ShimuraToyMTCorrespondenceRealization.lean`
- `HodgeReduction/HCGapL4/E7ShimuraToyReflexFieldSkeleton.lean`
- `HodgeReduction/HCGapL4/EllipticCurveCohomologyRealizationAudit.lean`
- `HodgeReduction/HCGapL4/EllipticCurveEnd0ActionBoundary.lean`
- `HodgeReduction/HCGapL4/FrontB6_MaintenanceOnly.lean`
- `HodgeReduction/HCGapL4/FrontC12_ClassicalCartanDerivation.lean`
- `HodgeReduction/HCGapL4/FrontC13_E6CaseDerivation.lean`
- `HodgeReduction/HCGapL4/FrontC14_CY3NonexistenceDerivation.lean`
- `HodgeReduction/HCGapL4/FrontD10_Codim3AndGeneralStrategy.lean`
- `HodgeReduction/HCGapL4/FrontD11_CMAbelianGaussianHC.lean`
- `HodgeReduction/HCGapL4/FrontD6_Deligne1982MinimalFragment.lean`
- `HodgeReduction/HCGapL4/FrontD7_Deligne1982ExpandedFragment.lean`
- `HodgeReduction/HCGapL4/FrontD8_PerCodimDeligneWitness.lean`
- `HodgeReduction/HCGapL4/FrontD9_Codim2NeronSeveri.lean`
- `HodgeReduction/HCGapL4/FrontE10_HeadlineAssembly.lean`
- `HodgeReduction/HCGapL4/FrontE6_FeedR405ConditionalTransfer.lean`
- `HodgeReduction/HCGapL4/FrontE7_ConditionalTransferFromConcrete.lean`
- `HodgeReduction/HCGapL4/FrontE8_ConcreteProfileR405Bridge.lean`
- `HodgeReduction/HCGapL4/FrontE9_MTCorrespondenceWitness.lean`
- `HodgeReduction/HCGapL4/GaussianCMActionAffineMorphismInterface.lean`
- `HodgeReduction/HCGapL4/GaussianCMActionAlgebraicEndInterface.lean`
- `HodgeReduction/HCGapL4/GaussianCMActionCoordinateRing.lean`
- `HodgeReduction/HCGapL4/GaussianCMActionEndChainIntegration.lean`
- `HodgeReduction/HCGapL4/GaussianCMActionProjectiveMorphism.lean`
- `HodgeReduction/HCGapL4/GaussianFieldToEnd0Chain.lean`
- `HodgeReduction/HCGapL4/GaussianIntActionEndCandidate.lean`
- `HodgeReduction/HCGapL4/GaussianIntActionToGaussianFieldTarget.lean`
- `HodgeReduction/HCGapL4/GaussianNumberFieldChainIntegration.lean`
- `HodgeReduction/HCGapL4/GaussianRationalBasisOneI.lean`
- `HodgeReduction/HCGapL4/HCFrontierAfterInternalMTPackage.lean`
- `HodgeReduction/HCGapL4/HCFrontierAfterParametricRefactorPreparation.lean`
- `HodgeReduction/HCGapL4/ImaginaryQuadraticFieldInterfaceSkeleton.lean`
- `HodgeReduction/HCGapL4/Lefschetz11Arithmetic.lean`
- `HodgeReduction/HCGapL4/NoetherLefschetzSkeleton.lean`
- `HodgeReduction/HCGapL4/ProductCohomologyProjectiveLineEllipticCurve.lean`
- `HodgeReduction/HCGapL4/ProductCohomologyProjectiveLineSelf.lean`
- `HodgeReduction/HCGapL4/ProductCycleFactoryComposition.lean`
- `HodgeReduction/HCGapL4/ProductCycleFactoryProjectiveLineSelf.lean`
- `HodgeReduction/HCGapL4/ProductCycleFactoryProjectiveLineToEllipticCurve.lean`
- `HodgeReduction/HCGapL4/ProofBlueprint.lean`
- `HodgeReduction/HCGapL4/R476_MultiFrontWave6Audit.lean`
- `HodgeReduction/HCGapL4/R480_MultiFrontWave7Audit.lean`
- `HodgeReduction/HCGapL4/R483_MultiFrontWave8Audit.lean`
- `HodgeReduction/HCGapL4/R486_MultiFrontWave9Audit.lean`
- `HodgeReduction/HCGapL4/R489_MultiFrontWave10Audit.lean`
- `HodgeReduction/HCGapL4/R492_MultiFrontWave11Audit.lean`
- `HodgeReduction/HCGapL4/R494_MultiFrontWave12Audit.lean`
- `HodgeReduction/HCGapL4/R496_MultiFrontWave13Audit.lean`
- `HodgeReduction/HCGapL4/R498_MultiFrontWave14Audit.lean`
- `HodgeReduction/HCGapL4/R501_MultiFrontWave15Audit.lean`
- `HodgeReduction/HCGapL4/R504_MultiFrontWave16Audit.lean`
- `HodgeReduction/HCGapL4/SHSMComposition.lean`
- `HodgeReduction/HCGapL4/SHSMCompositionGeneral.lean`
- `HodgeReduction/HCGapL4/ShiftedCorrespondenceComposition.lean`
- `HodgeReduction/HCGapL4/ShiftedCorrespondenceSHSM2Bridge.lean`
- `HodgeReduction/HCGapL4/V56CohomologyRank.lean`
- `HodgeReduction/Infrastructure/AbelianVariety/CMType.lean`
- `HodgeReduction/Infrastructure/AbelianVariety/HyperKahler.lean`
- `HodgeReduction/Infrastructure/AbelianVariety/K3Surface.lean`
- `HodgeReduction/Infrastructure/AbelianVariety/KugaSatake.lean`
- `HodgeReduction/Infrastructure/AbelianVariety/PolarisedAV.lean`
- `HodgeReduction/Infrastructure/AbelianVariety/TateModule.lean`
- `HodgeReduction/Infrastructure/AlgebraicGeometry/ExponentialSequence.lean`
- `HodgeReduction/Infrastructure/AlgebraicGeometry/FirstChernClass.lean`
- `HodgeReduction/Infrastructure/Automorphic/BorelBottWeil.lean`
- `HodgeReduction/Infrastructure/Automorphic/FrankeEisensteinLayer.lean`
- `HodgeReduction/Infrastructure/Automorphic/HeckeCorrespondence.lean`
- `HodgeReduction/Infrastructure/Automorphic/ModularForm.lean`
- `HodgeReduction/Infrastructure/ClassicalCominusculeClassification.lean`
- `HodgeReduction/Infrastructure/Cohomology/AbelJacobi.lean`
- `HodgeReduction/Infrastructure/Cohomology/AlgebraicCycle.lean`
- `HodgeReduction/Infrastructure/Cohomology/AmpleDivisor.lean`
- `HodgeReduction/Infrastructure/Cohomology/BettiCohomology.lean`
- `HodgeReduction/Infrastructure/Cohomology/BorelHirzebruchCoinvariant.lean`
- `HodgeReduction/Infrastructure/Cohomology/ChernCharacter.lean`
- `HodgeReduction/Infrastructure/Cohomology/ChowRing.lean`
- `HodgeReduction/Infrastructure/Cohomology/ClassifyingSpace.lean`
- `HodgeReduction/Infrastructure/Cohomology/ComparisonTheorem.lean`
- `HodgeReduction/Infrastructure/Cohomology/DeRham.lean`
- `HodgeReduction/Infrastructure/Cohomology/DivisorClass.lean`
- `HodgeReduction/Infrastructure/Cohomology/Galois.lean`
- `HodgeReduction/Infrastructure/Cohomology/HCCodim1.lean`
- `HodgeReduction/Infrastructure/Cohomology/HardLefschetz.lean`
- `HodgeReduction/Infrastructure/Cohomology/HodgeCycle.lean`
- `HodgeReduction/Infrastructure/Cohomology/HodgeRefinementCarriers.lean`
- `HodgeReduction/Infrastructure/Cohomology/Lattice.lean`
- `HodgeReduction/Infrastructure/Cohomology/Lefschetz.lean`
- `HodgeReduction/Infrastructure/Cohomology/LefschetzHyperplane.lean`
- `HodgeReduction/Infrastructure/Cohomology/Motive.lean`
- `HodgeReduction/Infrastructure/Cohomology/NeronSeveri.lean`
- `HodgeReduction/Infrastructure/Cohomology/PicardGroup.lean`
- `HodgeReduction/Infrastructure/Cohomology/PoincareDuality.lean`
- `HodgeReduction/Infrastructure/Cohomology/RiemannRoch.lean`
- `HodgeReduction/Infrastructure/Cohomology/StandardConjectures.lean`
- `HodgeReduction/Infrastructure/Cohomology/TateConjecture.lean`
- `HodgeReduction/Infrastructure/Cohomology/TwistedPhiL.lean`
- `HodgeReduction/Infrastructure/HodgeStructure/GaussManin.lean`
- `HodgeReduction/Infrastructure/HodgeStructure/MixedHodge.lean`
- `HodgeReduction/Infrastructure/HodgeStructure/MixedHodgeModule.lean`
- `HodgeReduction/Infrastructure/HodgeStructure/NilpotentOrbit.lean`
- `HodgeReduction/Infrastructure/J3OAlgebra.lean`
- `HodgeReduction/Infrastructure/J3OJordan.lean`
- `HodgeReduction/Infrastructure/LieAlgebra/Basic.lean`
- `HodgeReduction/Infrastructure/LieAlgebra/ReductiveGroup.lean`
- `HodgeReduction/Infrastructure/PoincarePolynomialEVII.lean`
- `HodgeReduction/Infrastructure/SchlafliGraph.lean`
- `HodgeReduction/Infrastructure/Shimura/Adelic.lean`
- `HodgeReduction/Infrastructure/Shimura/ArithmeticGroup.lean`
- `HodgeReduction/Infrastructure/Shimura/BorelHirzebruch.lean`
- `HodgeReduction/Infrastructure/Shimura/E7ParabolicCodim.lean`
- `HodgeReduction/Infrastructure/Shimura/HermitianForm.lean`
- `HodgeReduction/Infrastructure/Shimura/HermitianSymmetric.lean`
- `HodgeReduction/Infrastructure/Shimura/HirzebruchMumford.lean`
- `HodgeReduction/Infrastructure/Shimura/IntersectionHomology.lean`
- `HodgeReduction/Infrastructure/Shimura/PeriodDomain.lean`
- `HodgeReduction/Infrastructure/Shimura/SchubertCells.lean`
- `HodgeReduction/Infrastructure/ToroidalDimensions.lean`
- `HodgeReduction/Infrastructure/V56HodgeAlgebra.lean`
- `HodgeReduction/Ledger.lean`
- `HodgeReduction/Scripts/CheckEntry.lean`
- `HodgeReduction/Scripts/StatusEntry.lean`
- `HodgeReduction/Strict.lean`
