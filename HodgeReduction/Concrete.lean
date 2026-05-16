/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# HodgeReduction.Concrete — top-level module.

Re-exports concrete instances of the abstract HC framework. Each
sub-module provides a concrete carrier (a Lean type) together with
instances of every HC-framework typeclass and a closed-form witness
that the abstract universal-quantification theorems specialise to a
concrete conclusion.

This module is the **Cat 1-conversion target**: as the abstract
framework's universal-quantification theorems are kernel-derivable,
the only remaining content for *concrete* HC closure is exhibiting
concrete (carrier, instance, data) tuples — which is what the
sub-modules of this directory provide.

Re-exports:
  * `HodgeReduction.Concrete.EVII` — concrete carrier `A_EVII`
    modelling the cohomology ring of `Ě_VII` (currently
    `Polynomial ℚ` at the scaffolding stage), with instances of
    `CohomologyRing`, `KaehlerClass`, `Lefschetz11Data`, and
    `HodgeCycleData`, and the concrete Freudenthal class
    `q = -48 X^4` with the sanity-check theorem `HC_for_Concrete_EVII`.
-/

import HodgeReduction.Concrete.EVII
