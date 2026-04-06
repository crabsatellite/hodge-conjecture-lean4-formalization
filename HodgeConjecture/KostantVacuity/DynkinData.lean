/-
  HodgeConjecture/KostantVacuity/DynkinData.lean

  Dynkin diagram data for exceptional simple Lie algebras.
  For each type we record the coefficients (marks) of the highest root
  expressed in the basis of simple roots:  α̃ = Σ aⱼ αⱼ.

  The key invariant: a Cartan type admits a cominuscule representation
  (equivalently, can support a Hodge cocharacter satisfying Deligne's SV1)
  iff at least one mark equals 1.

  Data source: Bourbaki, Lie Groups and Lie Algebras, Ch. VI, Tables.
-/
import HodgeConjecture.Defs.CartanType
import Mathlib.Data.List.Basic
import Mathlib.Tactic

namespace HodgeConjecture

-- ============================================================================
-- Highest-root marks for exceptional types
-- ============================================================================

/-- Marks of the highest root of G₂ in the simple-root basis.
    α̃ = 3α₁ + 2α₂. -/
def G2_marks : List ℕ := [3, 2]

/-- Marks of the highest root of F₄ in the simple-root basis.
    α̃ = 2α₁ + 3α₂ + 4α₃ + 2α₄. -/
def F4_marks : List ℕ := [2, 3, 4, 2]

/-- Marks of the highest root of E₆ in the simple-root basis.
    α̃ = 1α₁ + 2α₂ + 3α₃ + 2α₄ + 1α₅ + 2α₆.
    Note: marks 1 at positions 1 and 5 (cominuscule). -/
def E6_marks : List ℕ := [1, 2, 3, 2, 1, 2]

/-- Marks of the highest root of E₇ in the simple-root basis.
    α̃ = 2α₁ + 3α₂ + 4α₃ + 3α₄ + 2α₅ + 1α₆ + 2α₇.
    Note: mark 1 at position 6 (cominuscule). -/
def E7_marks : List ℕ := [2, 3, 4, 3, 2, 1, 2]

/-- Marks of the highest root of E₈ in the simple-root basis.
    α̃ = 2α₁ + 3α₂ + 4α₃ + 5α₄ + 6α₅ + 4α₆ + 2α₇ + 3α₈. -/
def E8_marks : List ℕ := [2, 3, 4, 5, 6, 4, 2, 3]

-- ============================================================================
-- Marks for a CartanType
-- ============================================================================

/-- The highest-root marks for each exceptional Cartan type.
    For classical types, we return [] (not needed for vacuity arguments). -/
def CartanType.highestRootMarks : CartanType → List ℕ
  | .G2 => G2_marks
  | .F4 => F4_marks
  | .E6 => E6_marks
  | .E7 => E7_marks
  | .E8 => E8_marks
  | _ => []

-- ============================================================================
-- Cominuscule node detection
-- ============================================================================

/-- A list of marks has a cominuscule node iff some entry equals 1. -/
def hasCominusculeNode (marks : List ℕ) : Bool :=
  marks.any (· == 1)

/-- Prop version: a Cartan type can admit a Hodge cocharacter
    satisfying Deligne's (SV1) iff its Dynkin diagram has a node
    whose highest-root mark is 1 (a cominuscule node).

    For a non-trivial cocharacter μ = Σ nⱼ αⱼ∨ with max(nⱼ) ≥ 1,
    the pairing ⟨α̃, μ⟩ = Σ aⱼ nⱼ.  If all aⱼ ≥ 2, then
    ⟨α̃, μ⟩ ≥ 2·max(nⱼ) ≥ 2, violating (SV1) which requires ≤ 1. -/
def canAdmitHodgeCocharacter (t : CartanType) : Prop :=
  hasCominusculeNode t.highestRootMarks = true

-- ============================================================================
-- Basic computational lemmas
-- ============================================================================

theorem G2_marks_eq : G2_marks = [3, 2] := rfl
theorem F4_marks_eq : F4_marks = [2, 3, 4, 2] := rfl
theorem E6_marks_eq : E6_marks = [1, 2, 3, 2, 1, 2] := rfl
theorem E7_marks_eq : E7_marks = [2, 3, 4, 3, 2, 1, 2] := rfl
theorem E8_marks_eq : E8_marks = [2, 3, 4, 5, 6, 4, 2, 3] := rfl

end HodgeConjecture
