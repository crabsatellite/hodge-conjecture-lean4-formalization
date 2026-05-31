/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

import Mathlib.Algebra.Field.Defs
import Mathlib.Algebra.Field.Rat
import Mathlib.Data.Rat.Defs
import Mathlib.LinearAlgebra.Quotient.Basic

/-!
# Linear-algebra core of the paper's p-adic descent step

Master tex label: `thm:p-adic-descent`.

The theorem in the paper reduces, after setting
`W := H^{2p}(X, Q)` and
`V := im(CH^p(X)_Q -> W)`, to the elementary intersection statement
that a rational vector whose scalar extension lies in the scalar extension
of `V` already lies in `V`.

This file records the kernel-checkable linear-algebra core in an abstract
quotient/base-change form.  The surrounding syntomic and cycle-class inputs
remain separate open/conditional material in the paper inventory.
-/

namespace HodgeReduction

/--
Data for the faithful scalar-extension quotient test used by the p-adic
descent argument.

Think of `W` as the rational cohomology vector space, `rationalSubspace` as
the image of the rational Chow cycle-class map, `WK` as a scalar extension,
and `extendedSubspace` as the corresponding extended cycle-class image.
The quotient map `W -> Q` kills exactly `rationalSubspace`; after scalar
extension the quotient map `WK -> QK` kills exactly `extendedSubspace`; and
the quotient base-change map `Q -> QK` is injective.
-/
structure RationalScalarExtensionDescentData
    (W WK Q QK : Type*) [AddCommGroup W] [Module ℚ W]
    [AddCommGroup WK] [Module ℚ WK]
    [AddCommGroup Q] [Module ℚ Q]
    [AddCommGroup QK] [Module ℚ QK] where
  rationalSubspace : Submodule ℚ W
  extendedSubspace : Submodule ℚ WK
  rationalToExtended : W →ₗ[ℚ] WK
  quotientMap : W →ₗ[ℚ] Q
  extendedQuotientMap : WK →ₗ[ℚ] QK
  quotientBaseChange : Q →ₗ[ℚ] QK
  quotientBaseChange_injective : Function.Injective quotientBaseChange
  quotient_ker : LinearMap.ker quotientMap = rationalSubspace
  extended_ker : LinearMap.ker extendedQuotientMap = extendedSubspace
  quotient_commutes :
    ∀ w : W, quotientBaseChange (quotientMap w) =
      extendedQuotientMap (rationalToExtended w)

namespace RationalScalarExtensionDescentData

variable {W WK Q QK : Type*}
variable [AddCommGroup W] [Module ℚ W]
variable [AddCommGroup WK] [Module ℚ WK]
variable [AddCommGroup Q] [Module ℚ Q]
variable [AddCommGroup QK] [Module ℚ QK]

/--
If a rational class maps into the scalar-extended cycle subspace, then it was
already in the rational cycle subspace.

This is the formal Lean version of the paper proof's linear-algebra step
`(V \otimes_Q K) \cap W = V`, expressed through the quotient by `V`.
-/
theorem mem_rationalSubspace_of_base_mem_extendedSubspace
    (D : RationalScalarExtensionDescentData W WK Q QK) {alpha : W}
    (hAlpha : D.rationalToExtended alpha ∈ D.extendedSubspace) :
    alpha ∈ D.rationalSubspace := by
  have hKerExtended :
      D.rationalToExtended alpha ∈ LinearMap.ker D.extendedQuotientMap := by
    rwa [D.extended_ker]
  have hExtendedZero :
      D.extendedQuotientMap (D.rationalToExtended alpha) = 0 :=
    LinearMap.mem_ker.mp hKerExtended
  have hBaseZero :
      D.quotientBaseChange (D.quotientMap alpha) = 0 := by
    rw [D.quotient_commutes alpha, hExtendedZero]
  have hQuotientZero : D.quotientMap alpha = 0 := by
    apply D.quotientBaseChange_injective
    simpa using hBaseZero
  have hKerRational : alpha ∈ LinearMap.ker D.quotientMap :=
    LinearMap.mem_ker.mpr hQuotientZero
  rwa [D.quotient_ker] at hKerRational

/--
Named export matching the paper label `thm:p-adic-descent`: the p-adic
descent step is the faithful scalar-extension quotient test above.
-/
theorem padic_descent_linear_algebra_core
    (D : RationalScalarExtensionDescentData W WK Q QK) {alpha : W}
    (hAlpha : D.rationalToExtended alpha ∈ D.extendedSubspace) :
    alpha ∈ D.rationalSubspace :=
  D.mem_rationalSubspace_of_base_mem_extendedSubspace hAlpha

end RationalScalarExtensionDescentData

end HodgeReduction
