-- This module serves as the root of the `HodgeConjecture` library.
-- Import modules here that should be built as part of the library.
--
-- Formal verification of the Hodge Conjecture master proof reduction chain.
-- Based on: "Towards an Integrated Proof of the Hodge Conjecture" (Li, 2026)
--
-- Structure:
--   Defs/          Core definitions (CartanType, HodgeStructure, MumfordTate, axioms)
--   KostantVacuity/ G₂, F₄, E₈ elimination (fully proved from Dynkin data)
--   Meyer/          Meyer's theorem and anisotropic residue elimination
--   HCAb/           HC for abelian varieties (proof chain)
--   GLBOrth/        Non-Hermitian orthogonal case (AHD pipeline)
--   Exceptional/    E₆, E₇ Chern-Weil closure and scope bridge
--   ReductionChain/ Coverage table, Schur bypass, general reduction
--   MainTheorem     Final assembly of all components

import HodgeConjecture.Basic
import HodgeConjecture.KostantVacuity.Main
import HodgeConjecture.Meyer.Main
import HodgeConjecture.HCAb.Main
import HodgeConjecture.GLBOrth.Main
import HodgeConjecture.Exceptional.Main
import HodgeConjecture.ReductionChain.Main
import HodgeConjecture.MainTheorem
