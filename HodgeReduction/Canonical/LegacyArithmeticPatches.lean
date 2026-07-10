import Mathlib.LinearAlgebra.Dual

/-!
# Kernel-checked arithmetic recovered from the legacy manuscript

Only the integer implication at the end of the old SG-17 argument is
retained here.  The geometric and representation-theoretic premises that
would produce these integers are not asserted by this file.
-/

namespace HodgeReduction.Canonical

/--
The valid arithmetic core of the old SG-17 valuation obstruction.

The variables stand for the two lattice-scaling sums, the congruence
parameter, the valuation of the comparison scalar, and the valuation of
the Hard-Lefschetz Schur scalar.  The hypotheses are exactly the linear
relations and integrality bounds used by the final legacy calculation;
they imply that the last valuation is positive.
-/
theorem sg17ValuationObstruction
    (a b j vc vlambda : ℤ)
    (hscale : b - a = 28 * j - 1)
    (hdisc : vc = vlambda - a - j)
    (hboundA : -a ≤ vc)
    (hboundB : -b ≤ vc) :
    1 ≤ vlambda := by
  omega

/-- In particular, the SG-17 arithmetic constraints have no solution on
the stratum where the Schur scalar has valuation zero. -/
theorem sg17NoSolutionAtValuationZero
    (a b j vc vlambda : ℤ)
    (hscale : b - a = 28 * j - 1)
    (hdisc : vc = vlambda - a - j)
    (hboundA : -a ≤ vc)
    (hboundB : -b ≤ vc)
    (hzero : vlambda = 0) :
    False := by
  have hpositive := sg17ValuationObstruction a b j vc vlambda
    hscale hdisc hboundA hboundB
  omega

end HodgeReduction.Canonical
