/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Canonical.FullHodgeGoal
import HodgeReduction.Canonical.RouteReduction
import HodgeReduction.Canonical.ProgressiveReduction
import HodgeReduction.Canonical.ScalarExtensionDescent
import HodgeReduction.Canonical.LegacyArithmeticPatches
import HodgeReduction.Canonical.PaperLedgerGenerated
import HodgeReduction.Canonical.MainChain

/-!
# HodgeReduction

Clean root surface for the canonical paper and its machine audit.  Historical
attack modules remain outside `HodgeReduction.Canonical` and are not
re-exported.
-/
