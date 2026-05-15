/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# HyperKähler manifold framework

A **hyperKähler manifold** is a Riemannian manifold of dimension `4k`
with three integrable complex structures `I, J, K` satisfying
`IJ = K = -JI`, etc., all Kähler with respect to the same metric.

For our HC application:
* K3 surfaces are 2-dim hyperKähler.
* Hilbert schemes of points on K3 surfaces and OG6/OG10 examples
  give higher-dim examples.
* HC is known for these in many cases (Markman 2010 for moduli on K3).

This file packages **abstract hyperKähler data**.

## Main definitions

* `HyperKahlerData` : abstract hyperKähler manifold.

## Tags

hyperKähler manifold, K3-type Hodge structure, holomorphic symplectic
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-- **HyperKähler manifold data**:

* `HKManifold` : abstract type of HK manifold.
* `complexDim` : complex dimension `2k`. -/
class HyperKahlerData where
  /-- Abstract hyperKähler manifold. -/
  HKManifold : Type
  /-- Complex dimension. -/
  complexDim : ℕ

end HodgeReduction.Infrastructure.AbelianVariety
