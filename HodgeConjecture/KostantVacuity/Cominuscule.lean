/-
  HodgeConjecture/KostantVacuity/Cominuscule.lean

  The Kostant-mark criterion for Deligne's axiom (SV1).

  Theorem (Kostant):
    A simple Lie algebra 𝔤 can support a non-trivial cocharacter μ
    with ⟨α̃, μ⟩ ≤ 1 (Deligne's SV1) iff the Dynkin diagram of 𝔤
    has a cominuscule node, i.e., a simple root αⱼ whose coefficient
    aⱼ in the highest root α̃ = Σ aᵢ αᵢ equals 1.

  The "only if" direction is purely combinatorial:
    If all aⱼ ≥ 2 and μ = Σ nⱼ αⱼ∨ is non-trivial (some nⱼ ≥ 1), then
    ⟨α̃, μ⟩ = Σ aⱼ nⱼ ≥ 2·max(nⱼ) ≥ 2 > 1, contradicting (SV1).

  Strategy: the combinatorial facts are checked per-type by native_decide
  in G2F4.lean and E8.lean. This file provides the abstract bridge from
  the combinatorial predicate to the Shimura-datum axiom.
-/
import HodgeConjecture.Defs.MumfordTate
import HodgeConjecture.KostantVacuity.DynkinData

namespace HodgeConjecture

-- ============================================================================
-- Bridge from combinatorial predicate to Shimura datum
-- ============================================================================

/-- If a type's Dynkin marks have no cominuscule node (no mark = 1),
    then it cannot admit a Hodge cocharacter satisfying (SV1).
    For each concrete type (G₂, F₄, E₈), the hypothesis
    `hasCominusculeNode ... = false` is discharged by native_decide
    in the per-type files. -/
theorem no_hodge_cocharacter_of_marks (t : CartanType)
    (h : hasCominusculeNode t.highestRootMarks = false) :
    ¬ canAdmitHodgeCocharacter t := by
  unfold canAdmitHodgeCocharacter
  rw [h]
  decide

-- ============================================================================
-- Connection to admitsShimuraDatum
-- ============================================================================

/-- Bridge axiom: a Cartan type that cannot admit any Hodge cocharacter
    satisfying (SV1) cannot admit a Shimura datum.
    This is a theorem in Lie theory (Deligne's classification of
    Shimura varieties requires (SV1)), stated as an axiom because
    the full Lie-algebraic infrastructure is not formalized. -/
axiom shimura_requires_hodge_cocharacter (t : CartanType) :
  admitsShimuraDatum t → canAdmitHodgeCocharacter t

/-- Contrapositive: if a type has no cominuscule node, it does not
    admit a Shimura datum. -/
theorem no_shimura_of_no_cominuscule (t : CartanType)
    (h : ¬ canAdmitHodgeCocharacter t) :
    ¬ admitsShimuraDatum t := by
  intro hsd
  exact h (shimura_requires_hodge_cocharacter t hsd)

/-- Combined: no cominuscule node directly implies ¬ admitsShimuraDatum. -/
theorem no_shimura_of_no_cominuscule_marks (t : CartanType)
    (h : hasCominusculeNode t.highestRootMarks = false) :
    ¬ admitsShimuraDatum t :=
  no_shimura_of_no_cominuscule t (no_hodge_cocharacter_of_marks t h)

end HodgeConjecture
