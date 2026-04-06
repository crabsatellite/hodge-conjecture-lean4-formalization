/-
  HodgeConjecture/KostantVacuity/Main.lean

  Combined Kostant vacuity theorem: G₂, F₄, and E₈ cannot appear
  as Mumford-Tate factors of any smooth projective variety.

  This is because their Dynkin diagrams have no cominuscule node
  (all highest-root marks ≥ 2), so no non-trivial Hodge cocharacter
  can satisfy Deligne's axiom (SV1).

  Consequence: the proof of the Hodge Conjecture need not consider
  these three exceptional types at all. The remaining exceptional
  types E₆ and E₇ DO have cominuscule nodes and require separate
  treatment (see Exceptional/).
-/
import HodgeConjecture.KostantVacuity.DynkinData
import HodgeConjecture.KostantVacuity.Cominuscule
import HodgeConjecture.KostantVacuity.G2F4
import HodgeConjecture.KostantVacuity.E8

namespace HodgeConjecture

-- ============================================================================
-- Combined vacuity: G₂, F₄, E₈
-- ============================================================================

/-- The three exceptional types G₂, F₄, E₈ all fail to admit a Shimura datum.
    This is the Kostant vacuity theorem applied to the Mumford-Tate
    classification: no smooth projective variety can have an MT factor
    of type G₂, F₄, or E₈. -/
theorem kostant_vacuity_G2F4E8 :
    ∀ (t : CartanType), t = .G2 ∨ t = .F4 ∨ t = .E8 →
      ¬ admitsShimuraDatum t := by
  intro t ht
  rcases ht with rfl | rfl | rfl
  · exact G2_no_shimura
  · exact F4_no_shimura
  · exact E8_no_shimura

/-- Equivalent formulation as a conjunction. -/
theorem kostant_vacuity_triple :
    ¬ admitsShimuraDatum .G2 ∧
    ¬ admitsShimuraDatum .F4 ∧
    ¬ admitsShimuraDatum .E8 :=
  ⟨G2_no_shimura, F4_no_shimura, E8_no_shimura⟩

-- ============================================================================
-- The combinatorial core is fully proved (no sorry)
-- ============================================================================

/-- None of G₂, F₄, E₈ has a cominuscule node (purely combinatorial). -/
theorem no_cominuscule_G2F4E8 :
    hasCominusculeNode G2_marks = false ∧
    hasCominusculeNode F4_marks = false ∧
    hasCominusculeNode E8_marks = false := by
  exact ⟨by native_decide, by native_decide, by native_decide⟩

/-- Positive confirmation: E₆ and E₇ DO have cominuscule nodes. -/
theorem cominuscule_E6E7 :
    hasCominusculeNode E6_marks = true ∧
    hasCominusculeNode E7_marks = true := by
  exact ⟨by native_decide, by native_decide⟩

-- ============================================================================
-- Per-variety consequence
-- ============================================================================

/-- If X is a smooth projective variety and t is one of G₂, F₄, E₈,
    then t cannot be a simple factor of MT(X). -/
theorem no_MT_factor_G2F4E8 (X : SmoothProjVar) (t : CartanType)
    (ht : t = .G2 ∨ t = .F4 ∨ t = .E8)
    (hfactor : t ∈ MT_simpleFactors X) :
    False := by
  rcases ht with rfl | rfl | rfl
  · exact absurd (MT_factor_admits_shimura X .G2 hfactor) G2_no_shimura
  · exact absurd (MT_factor_admits_shimura X .F4 hfactor) F4_no_shimura
  · exact absurd (MT_factor_admits_shimura X .E8 hfactor) E8_no_shimura

end HodgeConjecture
