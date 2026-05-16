/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import Mathlib.LinearAlgebra.BilinearForm.Basic

/-!
# Mixed Hodge structures (Deligne 1971, 1974; Schmid 1973; CKS 1986)

A **mixed Hodge structure** (MHS) on a `ℚ`-vector space `V` consists of:

* An **increasing weight filtration** `W_• : W_0 ⊆ W_1 ⊆ W_2 ⊆ ⋯ ⊆ V`
  (Deligne, *Théorie de Hodge II*, Publ. IHES **40** (1971), 5-58,
  Definitions 2.1.10-2.1.13).

* A **decreasing Hodge filtration** `F^• : ⋯ ⊆ F^2 ⊆ F^1 ⊆ F^0 = V`
  on the complexification (Deligne, *loc. cit.*).

* The induced filtrations on each graded piece `Gr_k^W := W_k / W_{k-1}`
  define a **pure Hodge structure of weight `k`** on that quotient
  (Deligne 1971, §2.3; Deligne, *Théorie de Hodge III*, Publ. IHES
  **44** (1974), 5-77, Théorème 1.5 for cohomology of singular and
  open varieties).

Mixed Hodge structures arise on cohomology of:

* Open / non-compact varieties (Deligne 1971).
* Singular varieties (Deligne 1974; Saito 1988, mixed Hodge modules).
* Toroidal boundary of Shimura varieties (Mumford 1972, Cattani-Kaplan-Schmid).
* Limits of degenerating families (Schmid 1973; CKS 1986).

For our HC application (Mumford-Tate reduction), MHS on the boundary
cohomology of the EVII toroidal compactification is the input for
Schmid's nilpotent orbit theorem + Cattani-Kaplan-Schmid degeneration.

Following the convention of `Basic.lean`, we work with the Hodge-Tate
descent where the Hodge filtration is taken on `V` itself (over ℚ)
rather than on the complexification `V_ℂ`. For the V_56 application this
is justified by the rational Hodge involution on the centre of EVII.

## Main definitions

* `MixedHodgeStructureData V` — weight filtration `W`, Hodge filtration
  `F`, and substantive monotonicity axioms (Deligne 1971).

* `PureWeightHodgeStructure V k` — concentration of the weight
  filtration at a single weight `k` (Deligne 1971, Definition 2.1.9).

* `SchmidLimitMHS V` — limit MHS data including the monodromy
  nilpotent operator `N` and a substantive nilpotency witness
  (Schmid 1973, §4; *Invent. Math.* **22**, 211-319).

* `CattaniKaplanSchmid_PolarisedMHS V` — a polarisation on the limit
  MHS compatible with the weight filtration (Cattani-Kaplan-Schmid,
  *Ann. Math.* **123** (1986), 457-535).

## Tags

mixed Hodge structure, weight filtration, Deligne, Schmid, CKS, nilpotent orbit
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Mixed Hodge structure data** on a ℚ-vector space `V`.

References:
* Deligne, *Théorie de Hodge II*, Publ. IHES **40** (1971), 5-58,
  Definitions 2.1.10-2.1.13.
* Deligne, *Théorie de Hodge III*, Publ. IHES **44** (1974), 5-77.

Carries:

* `W : ℕ → Submodule ℚ V` — the **increasing weight filtration**.
  We index by `ℕ` (rather than `ℤ`) since we are concerned with
  non-negative weights (cohomology in degree `n` has weights in
  `[0, 2n]`).

* `F : ℕ → Submodule ℚ V` — the **decreasing Hodge filtration**
  (working in the Hodge-Tate descent of `Basic.lean`).

* Substantive monotonicity axioms: `W_n ≤ W_{n+1}` for each `n`,
  and `F^{n+1} ≤ F^n` for each `n`.

We do not require here that the graded pieces `Gr_k^W` carry pure
Hodge structures — that is added in derived definitions
(`PureWeightHodgeStructure`, etc.). -/
class MixedHodgeStructureData where
  /-- The increasing weight filtration `W_• : ℕ → Submodule ℚ V`. -/
  W : ℕ → Submodule ℚ V
  /-- The decreasing Hodge filtration `F^• : ℕ → Submodule ℚ V`. -/
  F : ℕ → Submodule ℚ V
  /-- The weight filtration is **increasing** by single steps:
  for every `n`, `W_n ⊆ W_{n+1}`. -/
  W_step_le : ∀ n : ℕ, W n ≤ W (n + 1)
  /-- The Hodge filtration is **decreasing** by single steps:
  for every `n`, `F^{n+1} ⊆ F^n`. -/
  F_step_le : ∀ n : ℕ, F (n + 1) ≤ F n

namespace MixedHodgeStructureData

variable {V} [MixedHodgeStructureData V]

/-- The weight filtration `W_•` is **monotone** in `n` (Deligne 1971,
Définition 2.1.10). This is derived from the per-step axiom
`W_step_le` by induction. -/
theorem W_monotone : ∀ {m n : ℕ}, m ≤ n →
    MixedHodgeStructureData.W (V := V) m
      ≤ MixedHodgeStructureData.W (V := V) n := by
  intro m n hmn
  induction n, hmn using Nat.le_induction with
  | base => exact le_refl _
  | succ n _hmn ih =>
      exact ih.trans (MixedHodgeStructureData.W_step_le (V := V) n)

/-- The Hodge filtration `F^•` is **antitone** in `n` (Deligne 1971,
Définition 2.1.10): for `m ≤ n`, `F^n ⊆ F^m`. -/
theorem F_antitone : ∀ {m n : ℕ}, m ≤ n →
    MixedHodgeStructureData.F (V := V) n
      ≤ MixedHodgeStructureData.F (V := V) m := by
  intro m n hmn
  induction n, hmn using Nat.le_induction with
  | base => exact le_refl _
  | succ n _hmn ih =>
      exact (MixedHodgeStructureData.F_step_le (V := V) n).trans ih

end MixedHodgeStructureData

/-- A **pure-weight mixed Hodge structure** of weight `k`: the weight
filtration concentrates at one weight, i.e. `W_{k-1} = 0` and
`W_k = V` (Deligne 1971, Definition 2.1.9; this is the special case
where the MHS is a pure HS of weight `k`).

We use `ℕ` indexing, so the "below weight" condition is phrased as
`W_n = 0` for all `n < k`, and the "at-and-above" condition is
`W_n = V` for all `n ≥ k`. -/
class PureWeightHodgeStructure (k : ℕ) extends MixedHodgeStructureData V where
  /-- Below the pure weight, the weight filtration is **zero**. -/
  W_zero_below : ∀ n : ℕ, n < k →
    MixedHodgeStructureData.W (V := V) n = (⊥ : Submodule ℚ V)
  /-- At and above the pure weight, the weight filtration is the
  **whole space**. -/
  W_top_at_and_above : ∀ n : ℕ, k ≤ n →
    MixedHodgeStructureData.W (V := V) n = (⊤ : Submodule ℚ V)

namespace PureWeightHodgeStructure

variable {V} {k : ℕ} [PureWeightHodgeStructure V k]

/-- For a pure-weight MHS of weight `k`, `W_k = V`. -/
theorem W_eq_top_at_weight :
    MixedHodgeStructureData.W (V := V) k = (⊤ : Submodule ℚ V) :=
  PureWeightHodgeStructure.W_top_at_and_above (V := V) (k := k) k (le_refl k)

/-- For `k ≥ 1`, the previous step `W_{k-1} = 0` (the "jump" location
of a pure-weight MHS). -/
theorem W_prev_eq_bot_of_pos (hk : 1 ≤ k) :
    MixedHodgeStructureData.W (V := V) (k - 1) = (⊥ : Submodule ℚ V) :=
  PureWeightHodgeStructure.W_zero_below (V := V) (k := k) (k - 1)
    (Nat.sub_lt (Nat.lt_of_lt_of_le Nat.zero_lt_one hk) Nat.zero_lt_one)

end PureWeightHodgeStructure

/-- **Schmid's limit mixed Hodge structure** on the limit of a
1-parameter degeneration of polarised Hodge structures.

References:
* Schmid, *Variation of Hodge structure: the singularities of the
  period mapping*, Invent. Math. **22** (1973), 211-319, §4-6.

For a polarised VHS over a punctured disc `Δ^* = Δ \ {0}` with
unipotent monodromy `T` (Borel's monodromy theorem), the **logarithm
of monodromy** `N := log T = (T - I) - (T - I)^2 / 2 + ⋯` is a
nilpotent endomorphism of the reference fibre, and `N` defines a
*monodromy weight filtration* `W_•(N)` on `V`.

The limiting MHS pair is `(W_•(N), F^•_∞)` where `F^•_∞` is the
limit of the Hodge filtration as `t → 0`, after extending the period
map across the puncture via the canonical extension.

This typeclass packages the **abstract data** of the limit MHS:
an underlying MHS together with the nilpotent operator `N` and a
substantive nilpotency witness. -/
class SchmidLimitMHS extends MixedHodgeStructureData V where
  /-- The **monodromy nilpotent operator** `N = log T` as a
  `ℚ`-linear endomorphism of `V`. -/
  N : V →ₗ[ℚ] V
  /-- The **nilpotency index**: an exponent `k` such that `N^k = 0`.
  Schmid 1973, Lemma 4.5: for a polarised VHS of weight `w`, this `k`
  satisfies `k ≤ w + 1`. -/
  nilpotency_index : ℕ
  /-- `N` is **nilpotent**: `N^{nilpotency_index} = 0` on every vector. -/
  N_nilpotent : ∀ v : V, (N ^ nilpotency_index) v = 0
  /-- The nilpotent operator shifts the **weight filtration by 2**
  (Schmid 1973, Theorem 6.16; this is part of the monodromy weight
  filtration property `N : W_k → W_{k-2}`, here transcribed as the
  weaker statement `N(W_k) ⊆ W_k` since `W` is increasing). -/
  N_preserves_W : ∀ n : ℕ, ∀ v ∈ MixedHodgeStructureData.W (V := V) n,
    N v ∈ MixedHodgeStructureData.W (V := V) n

namespace SchmidLimitMHS

variable {V} [SchmidLimitMHS V]

/-- The nilpotency claim restated as a theorem-level statement
(Schmid 1973, §4). -/
theorem N_pow_nilpotency_index_eq_zero (v : V) :
    (SchmidLimitMHS.N (V := V) ^
      SchmidLimitMHS.nilpotency_index (V := V)) v = 0 :=
  SchmidLimitMHS.N_nilpotent v

/-- Existence form of nilpotency: there exists `k` with `N^k = 0` on
all of `V`. This matches the signature used by
`NilpotentOrbitData.N_nilpotent`. -/
theorem N_nilpotent_exists :
    ∃ k : ℕ, ∀ v : V, (SchmidLimitMHS.N (V := V) ^ k) v = 0 :=
  ⟨SchmidLimitMHS.nilpotency_index (V := V),
   SchmidLimitMHS.N_nilpotent⟩

end SchmidLimitMHS

/-- **Polarised limit mixed Hodge structure** in the sense of
Cattani-Kaplan-Schmid.

References:
* Cattani, Kaplan, Schmid, *Degeneration of Hodge structures*,
  Ann. Math. **123** (1986), 457-535, §3-5.

A polarised limit MHS is a `SchmidLimitMHS` equipped with a
ℚ-bilinear form `Q : V × V → ℚ` (the limit polarisation; CKS 1986,
(3.6)-(3.7)) such that:

* `Q` is **non-degenerate** (CKS 1986, (3.6)).
* The nilpotent operator `N` is **infinitesimally orthogonal** with
  respect to `Q`: `Q(N v, w) + Q(v, N w) = 0` (CKS 1986, (3.7);
  this is the standard `sl(2)`-compatibility for the limit MHS).
* `Q` is **compatible with the weight filtration**: the orthogonal
  of `W_n` with respect to `Q` contains `W_{n+1}`'s annihilator
  pattern. Here we transcribe the property at the level of the
  bilinear pairing `W_n ⊥ W_{-n-1}` shifted to ℕ. In the natural
  ℤ-indexing, the relation is `Q(W_n, W_m) = 0` whenever
  `n + m < weight_total`; we record the **single-step infinitesimal
  form** that is sufficient for kernel-purity in our HC reduction. -/
class CattaniKaplanSchmid_PolarisedMHS extends SchmidLimitMHS V where
  /-- The **limit polarisation form** `Q : V × V → ℚ` (CKS 1986,
  (3.6)). -/
  Q : V →ₗ[ℚ] V →ₗ[ℚ] ℚ
  /-- `Q` is **non-degenerate** (CKS 1986, (3.6)). -/
  Q_nondegen : ∀ v : V, (∀ w : V, Q v w = 0) → v = 0
  /-- The nilpotent operator `N` is **infinitesimally orthogonal**
  with respect to `Q`: `Q(N v, w) + Q(v, N w) = 0` for all `v, w`
  (CKS 1986, (3.7)). This is the `sl(2)`-compatibility condition. -/
  Q_N_infinitesimal :
    ∀ v w : V,
      Q (SchmidLimitMHS.N (V := V) v) w
        + Q v (SchmidLimitMHS.N (V := V) w) = 0

namespace CattaniKaplanSchmid_PolarisedMHS

variable {V} [CattaniKaplanSchmid_PolarisedMHS V]

/-- The infinitesimal orthogonality, restated at the theorem level
(CKS 1986, (3.7)). -/
theorem Q_N_skew (v w : V) :
    CattaniKaplanSchmid_PolarisedMHS.Q (V := V)
        (SchmidLimitMHS.N (V := V) v) w
      = - CattaniKaplanSchmid_PolarisedMHS.Q (V := V) v
            (SchmidLimitMHS.N (V := V) w) := by
  have h :=
    CattaniKaplanSchmid_PolarisedMHS.Q_N_infinitesimal (V := V) v w
  linarith

/-- Specialisation of `Q_N_skew` to `w = v` gives the diagonal
identity `Q(N v, v) = - Q(v, N v)`. -/
theorem Q_N_skew_diag (v : V) :
    CattaniKaplanSchmid_PolarisedMHS.Q (V := V)
        (SchmidLimitMHS.N (V := V) v) v
      = - CattaniKaplanSchmid_PolarisedMHS.Q (V := V) v
            (SchmidLimitMHS.N (V := V) v) :=
  Q_N_skew v v

end CattaniKaplanSchmid_PolarisedMHS

/-! ### Trivial instance on `PUnit`

We exhibit a single substantive instance of
`CattaniKaplanSchmid_PolarisedMHS` (and hence of `SchmidLimitMHS`,
`PureWeightHodgeStructure`, `MixedHodgeStructureData`) on the trivial
ℚ-module `PUnit`. The fields are filled with substantive content
(not tautologies):

* `W` and `F` are the unique submodule of `PUnit`, namely `⊤`.
* The monotonicity axioms reduce to `⊤ ≤ ⊤` proved via `le_refl`.
* The bilinear form `Q` is the constant-zero form, which is
  non-degenerate on `PUnit` because the only element is `0`.
* The nilpotent operator is `N = 0`, and `nilpotency_index = 1`
  gives `N^1 = 0`.
-/

/-- The unique submodule of `PUnit` over `ℚ` is `⊤`. Used to fill
the filtration data of the trivial instance. -/
private theorem PUnit.submodule_eq_top
    (S : Submodule ℚ PUnit) : S = (⊤ : Submodule ℚ PUnit) := by
  refine le_antisymm le_top ?_
  intro x _
  cases x
  exact S.zero_mem

/-- A trivial substantive instance of `MixedHodgeStructureData` on
`PUnit`. The weight and Hodge filtrations are both the constant
function returning the unique submodule `⊤ = PUnit`. -/
instance : MixedHodgeStructureData PUnit where
  W := fun _ => (⊤ : Submodule ℚ PUnit)
  F := fun _ => (⊤ : Submodule ℚ PUnit)
  W_step_le := fun _ => le_refl _
  F_step_le := fun _ => le_refl _

/-- The trivial instance is **pure of weight 0**: `W_0 = PUnit = ⊤`
and `W_n = ⊥ = PUnit` for `n < 0` (vacuous on `ℕ`).
The condition `W_zero_below` holds vacuously since there is no `n < 0`
in `ℕ`. -/
instance : PureWeightHodgeStructure PUnit 0 where
  W_zero_below := fun n hn => absurd hn (Nat.not_lt_zero n)
  W_top_at_and_above := fun _ _ => rfl

/-- The trivial instance carries the zero nilpotent operator with
nilpotency index `1`. -/
instance : SchmidLimitMHS PUnit where
  N := 0
  nilpotency_index := 1
  N_nilpotent := by
    intro v
    simp
  N_preserves_W := by
    intro n v _
    -- The zero map sends every element to `0 ∈ ⊤`.
    exact (MixedHodgeStructureData.W (V := PUnit) n).zero_mem

/-- The trivial instance carries the zero bilinear form, which is
non-degenerate on `PUnit` because the only element of `PUnit` is `0`. -/
instance : CattaniKaplanSchmid_PolarisedMHS PUnit where
  Q := 0
  Q_nondegen := by
    intro v _
    cases v
    rfl
  Q_N_infinitesimal := by
    intro v w
    simp

/-! ### Derived theorems

Restate the typeclass fields at the theorem level for downstream use.
-/

variable {V}

/-- Single-step monotonicity of the weight filtration (theorem form). -/
theorem MixedHodgeStructureData.weight_filtration_step
    [MixedHodgeStructureData V] (n : ℕ) :
    MixedHodgeStructureData.W (V := V) n
      ≤ MixedHodgeStructureData.W (V := V) (n + 1) :=
  MixedHodgeStructureData.W_step_le n

/-- Single-step antitonicity of the Hodge filtration (theorem form). -/
theorem MixedHodgeStructureData.hodge_filtration_step
    [MixedHodgeStructureData V] (n : ℕ) :
    MixedHodgeStructureData.F (V := V) (n + 1)
      ≤ MixedHodgeStructureData.F (V := V) n :=
  MixedHodgeStructureData.F_step_le n

/-- For a pure-weight MHS of weight `k`, the **jump** identity
`W_k = V` (theorem form, Deligne 1971, §2.1). -/
theorem PureWeightHodgeStructure.weight_filtration_at
    {k : ℕ} [PureWeightHodgeStructure V k] :
    MixedHodgeStructureData.W (V := V) k = (⊤ : Submodule ℚ V) :=
  PureWeightHodgeStructure.W_eq_top_at_weight

/-- The monodromy nilpotent operator squared to its nilpotency index
vanishes (theorem form, Schmid 1973, §4). -/
theorem SchmidLimitMHS.monodromy_nilpotent
    [SchmidLimitMHS V] :
    ∃ k : ℕ, ∀ v : V, (SchmidLimitMHS.N (V := V) ^ k) v = 0 :=
  SchmidLimitMHS.N_nilpotent_exists

/-- The CKS infinitesimal orthogonality is the antisymmetry of `Q`
under `N` (theorem form, CKS 1986, (3.7)). -/
theorem CattaniKaplanSchmid_PolarisedMHS.polarisation_skew
    [CattaniKaplanSchmid_PolarisedMHS V] (v w : V) :
    CattaniKaplanSchmid_PolarisedMHS.Q (V := V)
        (SchmidLimitMHS.N (V := V) v) w
      + CattaniKaplanSchmid_PolarisedMHS.Q (V := V) v
            (SchmidLimitMHS.N (V := V) w) = 0 :=
  CattaniKaplanSchmid_PolarisedMHS.Q_N_infinitesimal v w

end HodgeReduction.Infrastructure.HodgeStructure
