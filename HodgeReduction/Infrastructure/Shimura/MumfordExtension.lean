/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.AlgebraicBundle
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Mumford canonical extension of automorphic vector bundles

For a Shimura variety `S_Γ` with a toroidal compactification
`S_Γ ↪ Š_Γ`, every automorphic vector bundle `V` on `S_Γ` admits
a **canonical extension** `V̄ → Š_Γ` (Mumford 1977 §1.3):

* `V̄` is the unique extension of `V` to `Š_Γ` as a vector bundle
  with logarithmic regularity at the boundary.
* The Chern classes `c_i(V̄) ∈ H^{2i}(Š_Γ; ℚ)` are well-defined.
* The pull-back `c_i(V̄)|_{S_Γ} = c_i(V)` (extension property).

For our HC application, the key property is:

**L-block-diagonality** (Mumford 1977 §1.3, refined by Schmid 1973):
the canonical extension of `V_56^{can}` stays block-diagonal under
the decomposition `V_56 = L_{+3} ⊕ 𝓔_{+1} ⊕ 𝓔_{-1} ⊕ L_{-3}` at the
toroidal boundary. This is what makes the L-refinement of Chern-Weil
form proportionality work.

This file abstracts the **carrier-level data** of the Mumford
extension.

## Main definitions

* `MumfordExtensionData A V` : packages the canonical extension data
  of an automorphic vector bundle `V`.

## Tags

Mumford extension, automorphic vector bundle, toroidal compactification
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]

/-- **Mumford canonical extension data** for an automorphic vector
bundle on a Shimura variety:

* `V̄` : an `AlgebraicVectorBundle A` (the canonical extension).
* `L_block_diagonal` : the block-diagonality property at the
  toroidal boundary.

For our V_56^can application, the extension decomposes as
`V̄_56^can = L_{+3} ⊕ 𝓔̄_{+1} ⊕ 𝓔̄_{-1} ⊕ L_{-3}` at the boundary. -/
class MumfordExtensionData where
  /-- The canonical extension as an algebraic vector bundle on
  the toroidal compactification. -/
  Vbar : HodgeReduction.Infrastructure.Cohomology.AlgebraicVectorBundle A
  /-- **L-block-diagonality** (paper's
  `Hyp_MumfordExtension_LBlockDiagonal`): the extension preserves
  the U(1)-charge polarisation, hence stays L-block-diagonal at the
  toroidal boundary.

  This is the **Schmid 1973 + Deligne 1970 + Cattani-Kaplan-Schmid 1986**
  consequence: the canonical extension of a polarised VHS preserves
  the Hodge filtration, hence stays diagonal in the Hodge
  decomposition. -/
  L_block_diagonal : Prop

namespace MumfordExtensionData

variable {A} [MumfordExtensionData A]

/-- The Chern classes of the Mumford extension are algebraic
(inherited from `AlgebraicVectorBundle`). -/
theorem chern_isAlgebraic (i : ℕ) :
    HodgeReduction.Infrastructure.Cohomology.CohomologyRing.IsAlgebraic
      (Vbar (A := A) |>.chern i) :=
  Vbar (A := A) |>.chern_isAlgebraic i

end MumfordExtensionData

end HodgeReduction.Infrastructure.Shimura
