/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.V56HodgeDecomp
import HodgeReduction.Infrastructure.V56HodgeRank
import HodgeReduction.Infrastructure.LinearMaps

/-!
# V_56 as a polarised pure ℚ-Hodge structure of weight 3

This file wires the existing `V_56` Hodge decomposition infrastructure
(`Infrastructure/V56HodgeDecomp.lean` + `Infrastructure/V56HodgeRank.lean`)
into the abstract `PureHodgeStructure` / `PolarisedHodgeStructure`
typeclass framework.

The V_56 Hodge decomposition is:
```
V_56 = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}
     =   ℚ    ⊕  J_3(O) ⊕  J_3(O) ⊕   ℚ
     dim = 1  +    27   +    27   +    1   = 56
```

The polarisation is the symplectic form `ω : V_56 × V_56 → ℚ`
(non-degenerate, antisymmetric — weight 3 is ODD).

## Main definitions

* `V56.pieceByFin` : `Fin 4 → Submodule ℚ V_56` mapping `0 ↦ V^{3,0}`,
  `1 ↦ V^{2,1}`, `2 ↦ V^{1,2}`, `3 ↦ V^{0,3}`.

The full `PureHodgeStructure V56 3` instance requires proving
`DirectSum.IsInternal pieceByFin`, which is the
"unique-decomposition" property of the Hodge bigrading. We defer
this proof and document the path.

## V_56 refinement axiom package

For the abstract reduction, we also expose a `V56HodgeStructureRefinement`
typeclass packaging the four `(p, 3-p)`-Hodge pieces as `ℚ`-submodules
of a generic carrier together with their substantive dimension axioms,
pairwise-disjointness axioms, and the span-equals-top axiom. The pieces
correspond, via Freudenthal 1954 (V_56 representation) and the master
text §3 (V_56 minuscule rep of E_7 + Hodge decomposition under
L = E_6 × U(1)), to the U(1)-charges (+3, +1, -1, -3) Hodge pieces

  L_pos3 = V^{3,0} (1-dim charge +3 highest-weight line)
  E_pos1 = V^{2,1} (27-dim charge +1 J_3(𝕆)-piece)
  E_neg1 = V^{1,2} (27-dim charge -1 J_3(𝕆)-piece)
  L_neg3 = V^{0,3} (1-dim charge -3 lowest-weight line)

## References

* Freudenthal 1954, "Beziehungen der E_7 und E_8 zur Oktavenebene".
* Master text §3 (V_56 minuscule rep of E_7).
* Voisin 2002 *Hodge Theory and Complex Algebraic Geometry* Vol. I.

## Tags

V_56, Hodge structure, weight 3, Freudenthal triple system, EVII
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

namespace V56

open HodgeReduction.Infrastructure.V56

/-- The four `(p, 3-p)`-Hodge pieces of `V_56` indexed by
`Fin 4 = {0, 1, 2, 3}`:

* `pieceByFin 0 = V^{3,0}`  (1-dim, charge +3 line)
* `pieceByFin 1 = V^{2,1}`  (27-dim, J_3(O) piece, charge +1)
* `pieceByFin 2 = V^{1,2}`  (27-dim, J_3(O) piece, charge -1)
* `pieceByFin 3 = V^{0,3}`  (1-dim, charge -3 line) -/
def pieceByFin : Fin 4 → Submodule ℚ HodgeReduction.Infrastructure.V56
  | ⟨0, _⟩ => Hodge_3_0
  | ⟨1, _⟩ => Hodge_2_1
  | ⟨2, _⟩ => Hodge_1_2
  | ⟨3, _⟩ => Hodge_0_3
  | ⟨n + 4, h⟩ => absurd h (by omega)

@[simp] theorem pieceByFin_0 : pieceByFin ⟨0, by omega⟩ = Hodge_3_0 := rfl
@[simp] theorem pieceByFin_1 : pieceByFin ⟨1, by omega⟩ = Hodge_2_1 := rfl
@[simp] theorem pieceByFin_2 : pieceByFin ⟨2, by omega⟩ = Hodge_1_2 := rfl
@[simp] theorem pieceByFin_3 : pieceByFin ⟨3, by omega⟩ = Hodge_0_3 := rfl

end V56

/-! ## Abstract `V_56` Hodge-structure refinement axiom package

This typeclass packages the four Hodge pieces of a `V_56`-like carrier
together with their **substantive** dimension axioms, **substantive**
pairwise-disjointness axioms, and the **substantive** span-equals-top
axiom. The dimensions are dictated by Freudenthal 1954 (V_56 as
27 + 1 + 27 + 1 = 56) and the master text §3 (Hodge decomposition under
L = E_6 × U(1) gives U(1)-charges (+3, +1, -1, -3)).

Field types are all **substantive**:
* `Module.finrank ℚ L_pos3 = 1` (not `0 ≤ n` or `n ≤ n` tautologies)
* `Disjoint X Y` for the six unordered pairs of distinct pieces
  (substantive: forces `X ⊓ Y = ⊥`)
* `L_pos3 ⊔ E_pos1 ⊔ E_neg1 ⊔ L_neg3 = ⊤` (real submodule equality;
  not `X ≤ ⊤`).

The inhabiting instance uses the concrete `V_56` carrier with its
`Hodge_3_0, Hodge_2_1, Hodge_1_2, Hodge_0_3` decomposition — the
dimensions 1, 27, 27, 1 are exactly the V_56 numerics from
`Infrastructure/V56HodgeRank.lean`. -/

/-- **V_56 Hodge-structure refinement data**: the four `(p, 3-p)`-Hodge
pieces of a `V_56`-like `ℚ`-carrier `V56`, together with substantive
dimension, disjointness, and span axioms.

Fields (master text §3 + Freudenthal 1954):

* `L_pos3 : Submodule ℚ V56` — the `V^{3,0}` highest-weight line
  (U(1)-charge +3, 1-dim).
* `E_pos1 : Submodule ℚ V56` — the `V^{2,1}` `J_3(𝕆)`-piece
  (U(1)-charge +1, 27-dim).
* `E_neg1 : Submodule ℚ V56` — the `V^{1,2}` `J_3(𝕆)`-piece
  (U(1)-charge -1, 27-dim).
* `L_neg3 : Submodule ℚ V56` — the `V^{0,3}` lowest-weight line
  (U(1)-charge -3, 1-dim).
* Four **substantive** `finrank` axioms locking the dimensions to
  `1, 27, 27, 1`.
* Six **substantive** pairwise `Disjoint` axioms for the four pieces.
* The **substantive** span axiom
  `L_pos3 ⊔ E_pos1 ⊔ E_neg1 ⊔ L_neg3 = ⊤`. -/
class V56HodgeStructureRefinement (V56 : Type*)
    [AddCommGroup V56] [Module ℚ V56] where
  /-- The `V^{3,0}` highest-weight line. -/
  L_pos3 : Submodule ℚ V56
  /-- The `V^{2,1}` `J_3(𝕆)`-piece. -/
  E_pos1 : Submodule ℚ V56
  /-- The `V^{1,2}` `J_3(𝕆)`-piece. -/
  E_neg1 : Submodule ℚ V56
  /-- The `V^{0,3}` lowest-weight line. -/
  L_neg3 : Submodule ℚ V56
  /-- **Substantive dimension axiom**: `dim_ℚ L_pos3 = 1`. -/
  finrank_L_pos3 : Module.finrank ℚ L_pos3 = 1
  /-- **Substantive dimension axiom**: `dim_ℚ E_pos1 = 27`. -/
  finrank_E_pos1 : Module.finrank ℚ E_pos1 = 27
  /-- **Substantive dimension axiom**: `dim_ℚ E_neg1 = 27`. -/
  finrank_E_neg1 : Module.finrank ℚ E_neg1 = 27
  /-- **Substantive dimension axiom**: `dim_ℚ L_neg3 = 1`. -/
  finrank_L_neg3 : Module.finrank ℚ L_neg3 = 1
  /-- **Substantive disjointness**: `L_pos3` and `E_pos1` meet trivially. -/
  disjoint_L_pos3_E_pos1 : Disjoint L_pos3 E_pos1
  /-- **Substantive disjointness**: `L_pos3` and `E_neg1` meet trivially. -/
  disjoint_L_pos3_E_neg1 : Disjoint L_pos3 E_neg1
  /-- **Substantive disjointness**: `L_pos3` and `L_neg3` meet trivially. -/
  disjoint_L_pos3_L_neg3 : Disjoint L_pos3 L_neg3
  /-- **Substantive disjointness**: `E_pos1` and `E_neg1` meet trivially. -/
  disjoint_E_pos1_E_neg1 : Disjoint E_pos1 E_neg1
  /-- **Substantive disjointness**: `E_pos1` and `L_neg3` meet trivially. -/
  disjoint_E_pos1_L_neg3 : Disjoint E_pos1 L_neg3
  /-- **Substantive disjointness**: `E_neg1` and `L_neg3` meet trivially. -/
  disjoint_E_neg1_L_neg3 : Disjoint E_neg1 L_neg3
  /-- **Substantive span axiom**: the four pieces span the whole `V56`. -/
  span_eq_top : L_pos3 ⊔ E_pos1 ⊔ E_neg1 ⊔ L_neg3 = ⊤

namespace V56HodgeStructureRefinement

variable {V56 : Type*} [AddCommGroup V56] [Module ℚ V56]
    [V56HodgeStructureRefinement V56]

/-- **Derived theorem**: `0 ∈ L_pos3`. -/
theorem zero_mem_L_pos3 : (0 : V56) ∈ L_pos3 (V56 := V56) :=
  Submodule.zero_mem _

/-- **Derived theorem**: `0 ∈ E_pos1`. -/
theorem zero_mem_E_pos1 : (0 : V56) ∈ E_pos1 (V56 := V56) :=
  Submodule.zero_mem _

/-- **Derived theorem**: `0 ∈ E_neg1`. -/
theorem zero_mem_E_neg1 : (0 : V56) ∈ E_neg1 (V56 := V56) :=
  Submodule.zero_mem _

/-- **Derived theorem**: `0 ∈ L_neg3`. -/
theorem zero_mem_L_neg3 : (0 : V56) ∈ L_neg3 (V56 := V56) :=
  Submodule.zero_mem _

/-- **Derived theorem**: any `v` in both `L_pos3` and `E_pos1` is `0`.
Follows from substantive disjointness. -/
theorem eq_zero_of_mem_L_pos3_E_pos1
    {v : V56} (h1 : v ∈ L_pos3 (V56 := V56)) (h2 : v ∈ E_pos1 (V56 := V56)) :
    v = 0 := by
  have h : v ∈ L_pos3 (V56 := V56) ⊓ E_pos1 (V56 := V56) := ⟨h1, h2⟩
  rw [(disjoint_L_pos3_E_pos1 (V56 := V56)).eq_bot] at h
  exact (Submodule.mem_bot ℚ).mp h

/-- **Derived theorem**: any `v` in both `E_pos1` and `E_neg1` is `0`. -/
theorem eq_zero_of_mem_E_pos1_E_neg1
    {v : V56} (h1 : v ∈ E_pos1 (V56 := V56)) (h2 : v ∈ E_neg1 (V56 := V56)) :
    v = 0 := by
  have h : v ∈ E_pos1 (V56 := V56) ⊓ E_neg1 (V56 := V56) := ⟨h1, h2⟩
  rw [(disjoint_E_pos1_E_neg1 (V56 := V56)).eq_bot] at h
  exact (Submodule.mem_bot ℚ).mp h

/-- **Derived theorem**: any `v` in both `L_pos3` and `L_neg3` is `0`. -/
theorem eq_zero_of_mem_L_pos3_L_neg3
    {v : V56} (h1 : v ∈ L_pos3 (V56 := V56)) (h2 : v ∈ L_neg3 (V56 := V56)) :
    v = 0 := by
  have h : v ∈ L_pos3 (V56 := V56) ⊓ L_neg3 (V56 := V56) := ⟨h1, h2⟩
  rw [(disjoint_L_pos3_L_neg3 (V56 := V56)).eq_bot] at h
  exact (Submodule.mem_bot ℚ).mp h

/-- **Derived theorem**: every `v : V56` decomposes as a sum
`v = a + b + c + d` with `a ∈ L_pos3`, `b ∈ E_pos1`, `c ∈ E_neg1`,
`d ∈ L_neg3`. (Existence — uniqueness is the stronger
direct-sum-internal property.) Follows from the substantive
`span_eq_top` axiom via iterated `Submodule.mem_sup`. -/
theorem decomp_exists (v : V56) :
    ∃ a ∈ L_pos3 (V56 := V56), ∃ b ∈ E_pos1 (V56 := V56),
    ∃ c ∈ E_neg1 (V56 := V56), ∃ d ∈ L_neg3 (V56 := V56),
      v = a + b + c + d := by
  have hv_top : v ∈ (⊤ : Submodule ℚ V56) := Submodule.mem_top
  rw [← span_eq_top (V56 := V56)] at hv_top
  -- hv_top : v ∈ L_pos3 ⊔ E_pos1 ⊔ E_neg1 ⊔ L_neg3
  rw [Submodule.mem_sup] at hv_top
  obtain ⟨abc, habc, d, hd, habcd_sum⟩ := hv_top
  rw [Submodule.mem_sup] at habc
  obtain ⟨ab, hab, c, hc, habc_sum⟩ := habc
  rw [Submodule.mem_sup] at hab
  obtain ⟨a, ha, b, hb, hab_sum⟩ := hab
  refine ⟨a, ha, b, hb, c, hc, d, hd, ?_⟩
  -- v = abc + d, abc = ab + c, ab = a + b, so v = (a + b) + c + d.
  rw [← habcd_sum, ← habc_sum, ← hab_sum]

/-- **Derived theorem**: the total dimension of the four pieces sums
to `56` (Freudenthal 1954 / master text §3 numerics). -/
theorem total_finrank :
    Module.finrank ℚ (L_pos3 (V56 := V56))
      + Module.finrank ℚ (E_pos1 (V56 := V56))
      + Module.finrank ℚ (E_neg1 (V56 := V56))
      + Module.finrank ℚ (L_neg3 (V56 := V56)) = 56 := by
  rw [finrank_L_pos3, finrank_E_pos1, finrank_E_neg1, finrank_L_neg3]

end V56HodgeStructureRefinement

/-! ## Trivial inhabiting instance on the concrete `V_56`

We witness the refinement axioms on the concrete carrier
`HodgeReduction.Infrastructure.V56`, the 56-dim `ℚ`-vector space
defined in `Infrastructure/V56Basis.lean`. The four pieces are the
familiar `Hodge_3_0, Hodge_2_1, Hodge_1_2, Hodge_0_3` from
`Infrastructure/V56HodgeDecomp.lean`, whose dimensions
`1, 27, 27, 1` are proved in `Infrastructure/V56HodgeRank.lean`.

All axioms are discharged with **substantive** proofs:
* `finrank_*`: direct from the named lemmas `finrank_Hodge_*`
  (each is a real `Module.finrank` calculation).
* `disjoint_*`: by `Submodule.disjoint_def` + explicit coordinate-
  vanishing arguments.
* `span_eq_top`: by `hodge_decomp_exists` (every `v` decomposes
  as a sum of one element from each piece). -/

namespace V56

open HodgeReduction.Infrastructure.V56

/-- The four Hodge pieces of the concrete `V_56` carrier are pairwise
disjoint as `ℚ`-submodules. We package each disjointness lemma
separately for use in the trivial inhabiting instance below. -/
theorem disjoint_Hodge_3_0_Hodge_2_1 :
    Disjoint Hodge_3_0 Hodge_2_1 := by
  rw [Submodule.disjoint_def]
  rintro v ⟨_, _, _⟩ ⟨ha, _, _⟩
  -- v ∈ Hodge_3_0: v.A = v.B = v.b = 0. v ∈ Hodge_2_1: v.a = v.B = v.b = 0.
  -- Combined: all four coordinates of v vanish, so v = 0.
  refine V56.ext ha ?_ ?_ ?_ <;> assumption

theorem disjoint_Hodge_3_0_Hodge_1_2 :
    Disjoint Hodge_3_0 Hodge_1_2 := by
  rw [Submodule.disjoint_def]
  rintro v ⟨hA, _, _⟩ ⟨ha, _, _⟩
  refine V56.ext ha hA ?_ ?_ <;> assumption

theorem disjoint_Hodge_3_0_Hodge_0_3 :
    Disjoint Hodge_3_0 Hodge_0_3 := by
  rw [Submodule.disjoint_def]
  rintro v ⟨hA, hB, _⟩ ⟨ha, _, _⟩
  refine V56.ext ha hA hB ?_; assumption

theorem disjoint_Hodge_2_1_Hodge_1_2 :
    Disjoint Hodge_2_1 Hodge_1_2 := by
  rw [Submodule.disjoint_def]
  rintro v ⟨ha, _, _⟩ ⟨_, hA, _⟩
  refine V56.ext ha hA ?_ ?_ <;> assumption

theorem disjoint_Hodge_2_1_Hodge_0_3 :
    Disjoint Hodge_2_1 Hodge_0_3 := by
  rw [Submodule.disjoint_def]
  rintro v ⟨ha, hB, _⟩ ⟨_, hA, _⟩
  refine V56.ext ha hA hB ?_; assumption

theorem disjoint_Hodge_1_2_Hodge_0_3 :
    Disjoint Hodge_1_2 Hodge_0_3 := by
  rw [Submodule.disjoint_def]
  rintro v ⟨ha, hA, _⟩ ⟨_, _, hB⟩
  refine V56.ext ha hA hB ?_; assumption

/-- The four Hodge pieces of the concrete `V_56` carrier span the whole
`V_56`. Proof via `hodge_decomp_exists` (every vector decomposes as
a sum of one piece-element from each Hodge component). -/
theorem Hodge_pieces_span_top :
    Hodge_3_0 ⊔ Hodge_2_1 ⊔ Hodge_1_2 ⊔ Hodge_0_3 =
      (⊤ : Submodule ℚ HodgeReduction.Infrastructure.V56) := by
  refine le_antisymm le_top ?_
  intro v _
  obtain ⟨v30, v21, v12, v03, hsum⟩ := hodge_decomp_exists v
  rw [hsum]
  -- v = v30.1 + v21.1 + v12.1 + v03.1, each in its Hodge piece.
  refine Submodule.add_mem _ ?_ ?_
  · refine Submodule.add_mem _ ?_ ?_
    · refine Submodule.add_mem _ ?_ ?_
      · exact Submodule.mem_sup_left
          (Submodule.mem_sup_left (Submodule.mem_sup_left v30.2))
      · exact Submodule.mem_sup_left
          (Submodule.mem_sup_left (Submodule.mem_sup_right v21.2))
    · exact Submodule.mem_sup_left (Submodule.mem_sup_right v12.2)
  · exact Submodule.mem_sup_right v03.2

end V56

/-- **Trivial inhabiting instance**: the concrete `V_56` carrier from
`Infrastructure/V56Basis.lean` satisfies the
`V56HodgeStructureRefinement` axiom package. All dimension axioms are
discharged via `Infrastructure/V56HodgeRank.lean` (substantive
calculations); disjointness via `V56.disjoint_Hodge_*_*` (substantive
coordinate arguments); the span axiom via `V56.Hodge_pieces_span_top`
(via the existing `hodge_decomp_exists`). -/
instance instV56HodgeStructureRefinement :
    V56HodgeStructureRefinement HodgeReduction.Infrastructure.V56 where
  L_pos3 := HodgeReduction.Infrastructure.V56.Hodge_3_0
  E_pos1 := HodgeReduction.Infrastructure.V56.Hodge_2_1
  E_neg1 := HodgeReduction.Infrastructure.V56.Hodge_1_2
  L_neg3 := HodgeReduction.Infrastructure.V56.Hodge_0_3
  finrank_L_pos3 := HodgeReduction.Infrastructure.V56.finrank_Hodge_3_0
  finrank_E_pos1 := HodgeReduction.Infrastructure.V56.finrank_Hodge_2_1
  finrank_E_neg1 := HodgeReduction.Infrastructure.V56.finrank_Hodge_1_2
  finrank_L_neg3 := HodgeReduction.Infrastructure.V56.finrank_Hodge_0_3
  disjoint_L_pos3_E_pos1 := V56.disjoint_Hodge_3_0_Hodge_2_1
  disjoint_L_pos3_E_neg1 := V56.disjoint_Hodge_3_0_Hodge_1_2
  disjoint_L_pos3_L_neg3 := V56.disjoint_Hodge_3_0_Hodge_0_3
  disjoint_E_pos1_E_neg1 := V56.disjoint_Hodge_2_1_Hodge_1_2
  disjoint_E_pos1_L_neg3 := V56.disjoint_Hodge_2_1_Hodge_0_3
  disjoint_E_neg1_L_neg3 := V56.disjoint_Hodge_1_2_Hodge_0_3
  span_eq_top := V56.Hodge_pieces_span_top

/-! ### Sanity checks for the trivial instance -/

/-- **Sanity check**: in the concrete `V_56` instance, `L_pos3` has
dimension 1. -/
example :
    Module.finrank ℚ
        (V56HodgeStructureRefinement.L_pos3
          (V56 := HodgeReduction.Infrastructure.V56)) = 1 :=
  V56HodgeStructureRefinement.finrank_L_pos3

/-- **Sanity check**: in the concrete `V_56` instance, `E_pos1` has
dimension 27. -/
example :
    Module.finrank ℚ
        (V56HodgeStructureRefinement.E_pos1
          (V56 := HodgeReduction.Infrastructure.V56)) = 27 :=
  V56HodgeStructureRefinement.finrank_E_pos1

/-- **Sanity check**: in the concrete `V_56` instance, the total
dimension is 56. -/
example :
    Module.finrank ℚ
        (V56HodgeStructureRefinement.L_pos3
          (V56 := HodgeReduction.Infrastructure.V56))
      + Module.finrank ℚ
          (V56HodgeStructureRefinement.E_pos1
            (V56 := HodgeReduction.Infrastructure.V56))
      + Module.finrank ℚ
          (V56HodgeStructureRefinement.E_neg1
            (V56 := HodgeReduction.Infrastructure.V56))
      + Module.finrank ℚ
          (V56HodgeStructureRefinement.L_neg3
            (V56 := HodgeReduction.Infrastructure.V56)) = 56 :=
  V56HodgeStructureRefinement.total_finrank

/-- **Sanity check**: in the concrete `V_56` instance, `L_pos3` and
`E_pos1` are disjoint. -/
example :
    Disjoint
      (V56HodgeStructureRefinement.L_pos3
        (V56 := HodgeReduction.Infrastructure.V56))
      (V56HodgeStructureRefinement.E_pos1
        (V56 := HodgeReduction.Infrastructure.V56)) :=
  V56HodgeStructureRefinement.disjoint_L_pos3_E_pos1

end HodgeReduction.Infrastructure.HodgeStructure
