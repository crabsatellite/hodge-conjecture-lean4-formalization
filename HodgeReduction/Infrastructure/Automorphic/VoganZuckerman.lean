/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Automorphic.Basic

/-!
# Vogan–Zuckerman `A_q(λ)` modules and (g, K)-cohomology

For a real reductive Lie group `G` with maximal compact `K`, the
**Vogan–Zuckerman modules** `A_q(λ)` are a family of irreducible
unitary `(g, K)`-modules constructed by cohomological induction
from `(l, L ∩ K)`-modules.

For each θ-stable parabolic `q ⊆ g` with Levi `l` and a one-dim
character `λ`, the module `A_q(λ)` has:

* `R(q) := 2 dim(u ∩ p)` — its **bottom (g, K)-cohomology degree**.
* `A_q(λ)` contributes to `H^*(g, K; A_q(λ) ⊗ V)` only at degrees
  `≥ R(q)`, with the bottom degree being 1-dim.

For `(G, K) = (E_{7(-25)}, E_6 × U(1))`:

* Salamanca-Riba 1999: at any degree `< dim_ℂ(G/K) = 27`, only
  trivial-module `A_q(λ)` contributes G-invariantly.
* VZ 1984: holomorphic discrete series have `R(q) = dim_ℂ(G/K) = 27`,
  so at `q < 27` no holomorphic discrete contributes.

These two facts together give the **`H^8(S_Γ; ℂ)_G = trivial-module
Cartan image`** identification used in the (ii.a) realization argument.

## Main definitions

* `VZAqLambdaData` : abstract carrier for the VZ-module data we need.
* `VZAqLambdaData.bottomDegree` : the `R(q)` invariant of a θ-stable q.
* `VZAqLambdaData.contributes_at` : predicate "the q-module
  contributes to H^k via cohomological induction".

## Tags

Vogan-Zuckerman, A_q(λ), (g, K)-cohomology, cohomological induction,
Salamanca-Riba 1999
-/

namespace HodgeReduction.Infrastructure.Automorphic

/-- **Vogan-Zuckerman `A_q(λ)` data**: a stub for the
cohomological-induction framework. Captures the carrier-level
information we need for the EVII application.

A full Lean formalisation would require:
* `(g, K)`-modules
* θ-stable parabolics
* Bottom-degree calculation `R(q)`
* Cohomological induction functor

We provide just the abstract data: for each "label" (parabolic class),
a bottom degree and a "contributes at degree k" predicate. -/
class VZAqLambdaData where
  /-- Abstract "labels" for theta-stable parabolics `q`. -/
  Label : Type
  /-- Bottom (g, K)-cohomology degree `R(q) = 2 dim(u ∩ p)`. -/
  bottomDegree : Label → ℕ
  /-- The module `A_q(λ)` contributes to `H^k(g, K; A_q(λ) ⊗ V)`
  only when `k ≥ R(q)`. -/
  contributes_at : Label → ℕ → Prop
  /-- Below the bottom degree, no contribution. -/
  contributes_at_below_bottom :
    ∀ (q : Label) (k : ℕ), k < bottomDegree q → ¬ contributes_at q k

namespace VZAqLambdaData

variable [VZAqLambdaData]

/-- The **trivial module label**: the q corresponding to the trivial
A_q(λ), namely q = g (the full algebra). It has bottom degree 0. -/
def trivialLabel := bottomDegree

end VZAqLambdaData

end HodgeReduction.Infrastructure.Automorphic
