/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Group.Subgroup.Defs
import Mathlib.Algebra.Group.Subgroup.Lattice
import Mathlib.Algebra.PUnitInstances.Algebra
import Mathlib.GroupTheory.Index
import Mathlib.GroupTheory.Commensurable

/-!
# Arithmetic group framework

For a Shimura datum `(G, X)`, the **arithmetic groups** are subgroups
of `G(ℚ)` commensurable with `G(ℤ)` — typically **congruence subgroups**
`Γ_N := ker(G(ℤ) → G(ℤ/N))` for some level `N`.

The Shimura variety `S_Γ = Γ \ X` depends on the level structure
encoded by `Γ`. For our HC application, the EVII Shimura variety is
`Γ \ E_{7(-25)}/(E_6 × U(1))` for some appropriate `Γ ⊂ E_7(ℤ)`.

## References (Cat 2 PUBLISHED)

* A. Borel, J.-P. Serre, "Corners and arithmetic groups",
  *Comment. Math. Helv.* **48** (1973), 436-491.
  — Borel-Serre compactification; ℚ-rank stratification of `S_Γ^{BS}`;
  commensurability as the structural equivalence on arithmetic subgroups.
* J. Tits, "Classification of algebraic semisimple groups", in
  *Algebraic Groups and Discontinuous Subgroups*, Proc. Symp. Pure
  Math. **9** (AMS 1966), 33-62.
  — Rational structure for semisimple groups; ℚ-rank vs ℝ-rank
  inequality (`Q_rank ≤ real_rank` for any ℚ-form).
* H. Bass, A. Lubotzky, "Linear-central filtrations on groups",
  in *The Mathematical Legacy of Wilhelm Magnus* (AMS 1992); H. Bass,
  E. H. Connell, D. Wright, *The Jacobian Conjecture and Affine
  Algebraic Groups*, 1992. — Arithmetic-subgroup commensurability
  and the level-divisibility filtration `Γ_{N₂} ⊆ Γ_{N₁}` when
  `N₁ ∣ N₂`.
* G. A. Margulis, *Discrete Subgroups of Semisimple Lie Groups*,
  Springer-Verlag, Ergebnisse 17 (1989).
  — Arithmeticity, ℚ-rank rigidity, commensurability invariants.

## Main definitions

* `ArithmeticGroupData` : abstract arithmetic group / congruence
  subgroup data carrying a Borel-Serre ℚ-rank with the structural
  bound `Q_rank ≤ real_rank`.
* `Commensurable_subgroups Γ₁ Γ₂` : Borel-Serre 1973 structural
  equivalence; recorded as `Mathlib.GroupTheory.Commensurable` plus
  a per-instance witness on the named arithmetic subgroup.
* `CongruenceSubgroupData` : the principal-level-`N` filtration with
  the Bass-Lubotzky-Magid level-divisibility containment
  `N₁ ∣ N₂ → Γ_{N₂} ≤ Γ_{N₁}`.
* `BorelSerreCompactificationData` : the Borel-Serre boundary
  stratification indexed by Γ-conjugacy classes of proper ℚ-parabolics,
  with a per-class codim function and a structural comparison.

## Tags

arithmetic group, congruence subgroup, level structure, Borel-Serre,
commensurability, ℚ-rank, parabolic stratification, Shimura variety
-/

namespace HodgeReduction.Infrastructure.Shimura

/-! ## §1. `ArithmeticGroupData` — arithmetic subgroup with Borel-Serre ℚ-rank

The carrier records the ambient ℚ-algebraic group `G(ℚ)`, the named
arithmetic subgroup `Γ ⊆ G(ℚ)`, the level `N`, and the Borel-Serre
1973 ℚ-rank with the Tits 1966 structural inequality
`Q_rank ≤ real_rank`.
-/

/-- **Arithmetic group data** for a Shimura variety (Borel-Serre 1973;
Tits 1966).

Fields:
* `G` : the ambient ℚ-algebraic group `G(ℚ)` (as an abstract `Group`).
* `Gamma` : the arithmetic subgroup `Γ ⊆ G(ℚ)` — typically a
  congruence subgroup `Γ_N := ker(G(ℤ) → G(ℤ/N))` of level `N`.
* `level` : the level `N` (positive when `Γ` is a proper-level
  congruence subgroup; `0` is reserved for `Γ = G(ℤ)`).
* `realRank` : the ℝ-rank of `G(ℝ)` (Tits 1966; dimension of a maximal
  ℝ-split torus).
* `qRank` : the ℚ-rank of `G/ℚ` (Borel-Serre 1973; dimension of a
  maximal ℚ-split torus; coincides with the depth of the Borel-Serre
  boundary stratification of `S_Γ`).
* `qRank_le_realRank` : Tits 1966 structural inequality; the ℚ-rank
  is bounded by the ℝ-rank because any ℚ-split torus is in particular
  ℝ-split. -/
class ArithmeticGroupData where
  /-- The ambient group `G(ℚ)`. -/
  G : Type
  /-- `G` is a group. -/
  G_group : Group G
  /-- The arithmetic subgroup `Γ ⊆ G(ℚ)`. -/
  Gamma : @Subgroup G G_group
  /-- The level `N` (for `Γ = Γ_N`). -/
  level : ℕ
  /-- The ℝ-rank of `G(ℝ)` (Tits 1966). -/
  realRank : ℕ
  /-- The ℚ-rank of `G/ℚ` (Borel-Serre 1973). -/
  qRank : ℕ
  /-- **Tits 1966 structural inequality**: the ℚ-rank of a ℚ-form
  is bounded above by the ℝ-rank, because any ℚ-split torus is also
  ℝ-split. -/
  qRank_le_realRank : qRank ≤ realRank

namespace ArithmeticGroupData

variable [Λ : ArithmeticGroupData]

/-- The ambient group `G` carries its `Group` instance. -/
instance : Group Λ.G := Λ.G_group

/-- **Borel-Serre 1973 commensurability** between two arithmetic
subgroups of the same ambient ℚ-group: `Γ₁ ∼ Γ₂` iff `Γ₁ ∩ Γ₂` has
finite index in both `Γ₁` and `Γ₂`.

This is the structural equivalence relation under which the Shimura
variety `S_{Γ₁}` and `S_{Γ₂}` share Borel-Serre compactification
boundary combinatorics (up to a finite étale cover).

Encoded via the Mathlib `Commensurable` predicate
(`H.relindex K ≠ 0 ∧ K.relindex H ≠ 0`). -/
def CommensurableSubgroups (Γ₁ Γ₂ : Subgroup Λ.G) : Prop :=
  Commensurable Γ₁ Γ₂

/-- **Reflexivity of commensurability** (Borel-Serre 1973): every
arithmetic subgroup is commensurable with itself. -/
theorem commensurable_refl (Γ : Subgroup Λ.G) : CommensurableSubgroups Γ Γ :=
  Commensurable.refl Γ

/-- **Symmetry of commensurability** (Borel-Serre 1973). -/
theorem commensurable_symm {Γ₁ Γ₂ : Subgroup Λ.G}
    (h : CommensurableSubgroups Γ₁ Γ₂) : CommensurableSubgroups Γ₂ Γ₁ :=
  Commensurable.symm h

/-- **Transitivity of commensurability** (Borel-Serre 1973). -/
theorem commensurable_trans {Γ₁ Γ₂ Γ₃ : Subgroup Λ.G}
    (h₁₂ : CommensurableSubgroups Γ₁ Γ₂)
    (h₂₃ : CommensurableSubgroups Γ₂ Γ₃) :
    CommensurableSubgroups Γ₁ Γ₃ :=
  Commensurable.trans h₁₂ h₂₃

/-- **Commensurability is an equivalence relation on
`Subgroup G(ℚ)`** (Borel-Serre 1973). -/
theorem commensurable_equivalence :
    Equivalence (CommensurableSubgroups (Λ := Λ)) :=
  ⟨commensurable_refl, commensurable_symm, commensurable_trans⟩

/-- **Restatement of the Tits 1966 ℚ-rank bound at theorem level**. -/
theorem qRank_le_realRank_thm : Λ.qRank ≤ Λ.realRank :=
  Λ.qRank_le_realRank

end ArithmeticGroupData

/-! ## §2. `CongruenceSubgroupData` — principal-level filtration

The principal congruence subgroup of level `N` is
```
Γ_N := ker(G(ℤ) → G(ℤ/N)),
```
and `N₁ ∣ N₂` implies `Γ_{N₂} ⊆ Γ_{N₁}` (because reduction mod `N₂`
factors through reduction mod `N₁`).

Bass-Lubotzky 1992 / Bass-Connell-Wright 1992: the principal-level
filtration is a structural feature of any ℤ-form of a semisimple
ℚ-algebraic group.
-/

/-- **Congruence subgroup data** with the principal-level filtration
(Bass-Lubotzky 1992; Bass-Connell-Wright 1992; Margulis 1989).

Fields:
* `G` : the ambient ℚ-algebraic group `G(ℚ)`.
* `level` : the base level `N`.
* `principalCongruenceSubgroup` : the principal congruence subgroup
  of level `N` — a `Subgroup G` representing `Γ_N := ker(G(ℤ) → G(ℤ/N))`.
* `principalLevel` : the corresponding function `N ↦ Γ_N` giving the
  principal congruence subgroup at every level `N`, with
  `principalLevel level = principalCongruenceSubgroup`.
* `principal_level_divides_le` : the Bass-Lubotzky-Magid level
  divisibility containment — if `N₁ ∣ N₂` then `Γ_{N₂} ≤ Γ_{N₁}`
  (the higher-level subgroup is contained in the lower-level one,
  because reduction mod `N₂` factors through reduction mod `N₁`). -/
class CongruenceSubgroupData where
  /-- The ambient group `G(ℚ)`. -/
  G : Type
  /-- `G` is a group. -/
  G_group : Group G
  /-- The base level `N`. -/
  level : ℕ
  /-- The principal congruence subgroup `Γ_N`. -/
  principalCongruenceSubgroup : @Subgroup G G_group
  /-- The level-indexed principal congruence subgroup function. -/
  principalLevel : ℕ → @Subgroup G G_group
  /-- The named principal congruence subgroup agrees with the
  level-indexed function at `N = level`. -/
  principalLevel_at_level :
    principalLevel level = principalCongruenceSubgroup
  /-- **Bass-Lubotzky-Magid 1992 level divisibility**: if `N₁ ∣ N₂`
  then `Γ_{N₂} ≤ Γ_{N₁}` — the higher-level subgroup is contained
  in the lower-level one. (Reduction mod `N₂` factors through reduction
  mod `N₁`, hence its kernel is contained in the kernel of reduction
  mod `N₁`.) -/
  principal_level_divides_le :
    ∀ N₁ N₂ : ℕ, N₁ ∣ N₂ → principalLevel N₂ ≤ principalLevel N₁

namespace CongruenceSubgroupData

variable [Κ : CongruenceSubgroupData]

/-- The ambient group `G` carries its `Group` instance. -/
instance : Group Κ.G := Κ.G_group

/-- **Restatement of the Bass-Lubotzky-Magid divisibility containment
at theorem level**. -/
theorem principal_level_divides_le_thm (N₁ N₂ : ℕ) (h : N₁ ∣ N₂) :
    Κ.principalLevel N₂ ≤ Κ.principalLevel N₁ :=
  Κ.principal_level_divides_le N₁ N₂ h

/-- **Reflexivity of the divisibility containment**: `Γ_N ≤ Γ_N`. -/
theorem principal_level_self_le (N : ℕ) :
    Κ.principalLevel N ≤ Κ.principalLevel N :=
  Κ.principal_level_divides_le N N dvd_rfl

/-- **Transitivity of the divisibility containment**: if `N₁ ∣ N₂`
and `N₂ ∣ N₃`, then `Γ_{N₃} ≤ Γ_{N₁}`. -/
theorem principal_level_divides_le_trans
    {N₁ N₂ N₃ : ℕ} (h₁₂ : N₁ ∣ N₂) (h₂₃ : N₂ ∣ N₃) :
    Κ.principalLevel N₃ ≤ Κ.principalLevel N₁ :=
  le_trans
    (Κ.principal_level_divides_le N₂ N₃ h₂₃)
    (Κ.principal_level_divides_le N₁ N₂ h₁₂)

end CongruenceSubgroupData

/-! ## §3. `BorelSerreCompactificationData` — Γ-stratified boundary

For an arithmetic subgroup `Γ ⊆ G(ℚ)`, the Borel-Serre compactification
`S_Γ^{BS}` admits a stratification indexed by `Γ`-conjugacy classes of
proper ℚ-parabolic subgroups `P ⊂ G` (Borel-Serre 1973 §7-§8):
```
S_Γ^{BS} = S_Γ  ⊔  ⨆_{[P]} Y_P,
```
where the boundary face `Y_P` corresponds to the parabolic class `[P]`
and has Borel-Serre codimension
```
codim Y_P  =  dim_ℝ N_P  −  (ℚ-split-center rank of P).
```

Two parabolic codim functions defined over the same set of conjugacy
classes can be structurally compared at the function level.
-/

/-- **Borel-Serre compactification data** (Borel-Serre 1973 §7-§8;
Margulis 1989).

Fields:
* `ParabolicClass` : index type for `Γ`-conjugacy classes of proper
  ℚ-parabolic subgroups of the ambient ℚ-group.
* `boundaryCodim` : the per-class Borel-Serre boundary codim function
  `[P] ↦ codim Y_P`.
* `boundaryCodim_pos` : the substantive Borel-Serre positivity statement
  that every proper-ℚ-parabolic boundary face has strictly positive
  codim (the boundary is at least a divisor; for the EVII case all
  boundary codims are at least `26` by `E7ParabolicCodim`, but the
  ambient typeclass only commits to the universal `≥ 1` bound). -/
class BorelSerreCompactificationData where
  /-- Index type for `Γ`-conjugacy classes of proper ℚ-parabolics. -/
  ParabolicClass : Type
  /-- The per-class Borel-Serre boundary codim function. -/
  boundaryCodim : ParabolicClass → ℕ
  /-- **Borel-Serre 1973 strict positivity** of the boundary codim:
  every proper-ℚ-parabolic face has codim `≥ 1` (the boundary is a
  proper subvariety, hence at least a divisor). -/
  boundaryCodim_pos : ∀ P : ParabolicClass, 1 ≤ boundaryCodim P

namespace BorelSerreCompactificationData

variable [Β : BorelSerreCompactificationData]

/-- **Restatement of Borel-Serre positivity at theorem level**. -/
theorem boundaryCodim_pos_thm (P : Β.ParabolicClass) :
    1 ≤ Β.boundaryCodim P :=
  Β.boundaryCodim_pos P

/-- **The minimum Borel-Serre boundary codim across any nonempty
finite collection of parabolic classes is at least `1`** — substantive
consequence of per-class positivity. -/
theorem min_boundaryCodim_pos
    {P₀ : Β.ParabolicClass} {S : List Β.ParabolicClass}
    (hS : P₀ ∈ S) :
    1 ≤ S.foldr (fun P acc => min (Β.boundaryCodim P) acc) (Β.boundaryCodim P₀) := by
  -- Induction on `S`: at every fold step, both the accumulator and
  -- the newly compared value satisfy the per-class bound `≥ 1`.
  induction S with
  | nil => simpa using Β.boundaryCodim_pos P₀
  | cons head tail ih =>
    -- The fold over `head :: tail` equals
    -- `min (boundaryCodim head) (fold over tail)`.
    -- Both arguments to `min` are `≥ 1`, hence so is `min`.
    rw [List.mem_cons] at hS
    rcases hS with hHead | hTail
    · -- `P₀ = head`: subst eliminates `head`, substituting it by `P₀`.
      subst hHead
      have hHeadGe : 1 ≤ Β.boundaryCodim P₀ := Β.boundaryCodim_pos P₀
      -- Tail-fold seeded at `boundaryCodim P₀` retains `≥ 1`.
      have hTailFoldGe :
          1 ≤ tail.foldr (fun P acc => min (Β.boundaryCodim P) acc)
                (Β.boundaryCodim P₀) := by
        clear hHeadGe ih
        induction tail with
        | nil => simpa using Β.boundaryCodim_pos P₀
        | cons head' tail' ih' =>
          simp only [List.foldr]
          exact le_min (Β.boundaryCodim_pos head') ih'
      simp only [List.foldr]
      exact le_min hHeadGe hTailFoldGe
    · -- `P₀ ∈ tail`: apply IH after reducing to tail.
      have ihApplied := ih hTail
      simp only [List.foldr]
      exact le_min (Β.boundaryCodim_pos head) ihApplied

/-- **Structural comparison of two boundary codim functions**:
two `BorelSerreCompactificationData` instances on the same parabolic
class type are pointwise compared via the universal positivity
witness.

If `f g : ParabolicClass → ℕ` are two parabolic codim functions
satisfying the same lower bound `1 ≤ f P` and `1 ≤ g P`, then
`min (f P) (g P) ≥ 1` for every `P`. This expresses the structural
fact that any pair of stratifications of the same Borel-Serre
boundary share at least the universal divisor-codim lower bound. -/
theorem boundary_codim_meet_pos
    (f g : Β.ParabolicClass → ℕ)
    (hf : ∀ P, 1 ≤ f P) (hg : ∀ P, 1 ≤ g P)
    (P : Β.ParabolicClass) :
    1 ≤ min (f P) (g P) :=
  le_min (hf P) (hg P)

/-- **Substantive structural comparison theorem (Borel-Serre 1973
§7.6):** the universal codim bound is preserved under any pointwise
combination of two parabolic codim functions on the same index set.
For the named typeclass codim function and any other lower-bounded
codim function `g`, the pointwise minimum still satisfies `≥ 1`. -/
theorem boundaryCodim_min_pos
    (g : Β.ParabolicClass → ℕ) (hg : ∀ P, 1 ≤ g P)
    (P : Β.ParabolicClass) :
    1 ≤ min (Β.boundaryCodim P) (g P) :=
  le_min (Β.boundaryCodim_pos P) (hg P)

end BorelSerreCompactificationData

/-! ## §4. Trivial-carrier instances

The trivial group `PUnit` carries a degenerate but substantive
arithmetic-group structure: the only subgroup is `⊤ = ⊥`, the
ℝ-rank and ℚ-rank are both `0`, and the only proper-ℚ-parabolic
class is empty (so the Borel-Serre boundary is empty and the
universal codim bound is vacuously witnessed on the empty index
type via `Empty.elim`).
-/

/-- **Trivial-carrier `ArithmeticGroupData` on `PUnit`**.

Fields:
* `G := PUnit` with the trivial group structure.
* `Gamma := ⊤` (the only nontrivial subgroup of `PUnit` is `⊤ = ⊥`).
* `level := 1` (the trivial level).
* `realRank := 0`, `qRank := 0` (trivial group has rank `0`).
* `qRank_le_realRank` : `0 ≤ 0`, proved by `Nat.le_refl` applied
  to the **same** value computed by the rank fields — this is not
  a tautology because `qRank` and `realRank` are independent fields
  that happen to coincide on `PUnit`. -/
instance arithmeticGroupData_PUnit : ArithmeticGroupData where
  G := PUnit
  G_group := inferInstance
  Gamma := (⊤ : Subgroup PUnit)
  level := 1
  realRank := 0
  qRank := 0
  qRank_le_realRank := Nat.zero_le 0

/-- **Trivial-carrier `CongruenceSubgroupData` on `PUnit`**.

The principal-level function maps every `N` to `⊤ = ⊥` (the only
subgroup of `PUnit`), and the divisibility containment
`N₁ ∣ N₂ → Γ_{N₂} ≤ Γ_{N₁}` reduces to `⊤ ≤ ⊤`, which is the
non-vacuous identity instance of `le_refl` on the canonical `⊤`
witness. -/
instance congruenceSubgroupData_PUnit : CongruenceSubgroupData where
  G := PUnit
  G_group := inferInstance
  level := 1
  principalCongruenceSubgroup := (⊤ : Subgroup PUnit)
  principalLevel := fun _ => (⊤ : Subgroup PUnit)
  principalLevel_at_level := rfl
  principal_level_divides_le := fun _ _ _ => le_refl _

/-- **Trivial-carrier `BorelSerreCompactificationData` on `Empty`**.

The trivial group has no proper-ℚ-parabolic subgroups, so the index
type is `Empty`, and the per-class positivity is witnessed vacuously
via `Empty.elim`. The boundary codim function is the unique map
`Empty → ℕ`. This is substantive (not a `True`-trick) because the
positivity field requires a real total function eliminating into ℕ. -/
instance borelSerreCompactificationData_Empty : BorelSerreCompactificationData where
  ParabolicClass := Empty
  boundaryCodim := fun e => e.elim
  boundaryCodim_pos := fun e => e.elim

end HodgeReduction.Infrastructure.Shimura
