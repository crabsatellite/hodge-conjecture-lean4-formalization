# `HodgeReduction.Infrastructure` — Mathlib-PR-quality Lean infrastructure

This directory contains **self-contained Lean modules** designed to be
Mathlib-PR-ready. Each module fills a gap in Mathlib (currently no
exceptional Cartan matrices, no Schläfli graph, no Octonion `ℚ`-algebra,
no exceptional Jordan algebra `J₃(𝕆)`, etc.) while providing the
mathematical foundations needed for the Hodge-conjecture EVII case.

## Design principles

* **Mathlib-PR-quality**: generic naming, comprehensive docstrings,
  Apache-2.0 licensed, no project-specific dependencies.
* **Real Lean proofs**: all theorems decided by Lean kernel + Mathlib
  tactics (`ext`, `simp`, `ring`, `norm_num`, `positivity`). No domain
  axioms.
* **Incremental**: each module is self-contained, builds on earlier
  modules.

## Status (as of P85)

### ✅ Tier A — Combinatorial / Arithmetic (DONE)

| Module | Description | Lines | Status |
|---|---|---|---|
| `../CrossRingArithmetic.lean` | P48 Chern values + P57 polynomial identity (`-48 c_2² + 96 c_1 c_3 - 96 c_4`) + P53 `Φ_tw(q) = -48 h⁴` verification | ~270 | ✅ |
| `CartanMatrices.lean` | E₆, E₇, E₈ Cartan matrices + diagonal/edges/nesting | ~150 | ✅ |
| `SchlafliGraph.lean` | `srg(27, 10, 1, 5)` via 6+6+15 Schläfli double-six model | ~175 | ✅ |
| `CoxeterDegrees.lean` | W(E_6)/W(E_7)/W(E_8) invariant degrees + order + Coxeter number + dim(e_n) sanity | ~110 | ✅ |

### ✅ Tier B — Algebra (DONE for basics)

| Module | Description | Lines | Status |
|---|---|---|---|
| `Octonion.lean` | Octonion `ℚ`-algebra (8-dim, Fano-plane mult) + `conj` + `normSq` + 32 component simp lemmas + alternative laws + flexibility + **Hurwitz composition** `‖x·y‖² = ‖x‖²·‖y‖²` + scalar-mult ring laws + `conj_smul`/`smul_sub`/`smul_add` | ~410 | ✅ |
| `JordanJ3O.lean` | Exceptional Jordan algebra `J₃(𝕆)` (27-dim Hermitian 3×3) + Freudenthal cubic norm `N` + `N(0)=0`, `N(I)=1`, `N(diag)=abc` + **cubic-norm homogeneity** `N(r·X) = r³N(X)` + 12 zero/one simp lemmas | ~200 | ✅ |
| `V56Freudenthal.lean` | 56-dim Freudenthal triple system `V₅₆ = ℚ⊕J₃(𝕆)⊕J₃(𝕆)⊕ℚ` + **Freudenthal quartic** `q` + **degree-4 homogeneity** `q(r·v) = r⁴·q(v)` + **symplectic form** `ω` + full bilinearity of `⟨·,·⟩` and `ω` + sharp degree-2 `(r·A)^# = r²·A^#` | ~500 | ✅ |

### 🔲 Tier B — Algebra (FUTURE WORK)

* **Jordan-algebra structure** on `J₃(𝕆)`:
  - Jordan product `X ∘ Y = (X·Y + Y·X)/2` (commutative, power-associative).
  - Identity `X · X# = N(X) · I` (Freudenthal cubic identity).
* **Connection to E_6**:
  - `Aut(J₃(𝕆)) = F₄` (compact real form).
  - `Str(J₃(𝕆))/Center = E₆`.
  - `V_27 ≅ J₃(𝕆)` as `E₆`-rep.

### 🔲 Tier B — Freudenthal triple product (mostly DONE for the basics)

* ✅ `V_56 = ℚ ⊕ J₃(𝕆) ⊕ J₃(𝕆) ⊕ ℚ` (= 1 + 27 + 27 + 1 = 56).
* ✅ Freudenthal quartic `q : V₅₆ → ℚ`, with `q(0) = 0`, `q(r·v) = r⁴·q(v)`, `q(-v) = q(v)`.
* ✅ Symplectic form `ω : V₅₆ × V₅₆ → ℚ`, antisymmetric and bilinear.
* 🔲 Freudenthal cubic-T product `T : V_56 × V_56 × V_56 → V_56`.
* 🔲 `q(v) ∼ ⟨T(v,v,v), v⟩` derivation.
* 🔲 Sato-Kimura rank stratification.

### 🔲 Tier C — Representation theory

* **W(E_6), W(E_7) Coxeter groups** via Mathlib `Coxeter` framework.
* ✅ `W(E_6)` / `W(E_7)` / `W(E_8)` invariant degrees as decidable list facts
  (in `CoxeterDegrees.lean`).
* **E_6 root system + V_27 weights** with explicit Bourbaki coordinates.
* **E_7 root system + V_56 weights**.
* **Borel-Hirzebruch coinvariant algebra**: `H*(G_C/P; ℚ) = Sym(t^∨)^{W(L)} / (Sym(t^∨)^{W(G)}_+)`.

### 🔲 Tier D — Algebraic geometry

* **Compact dual flag variety** `Ě_VII = E_{7,C}/P_7` as Mathlib type.
* **Chern-Weil theory** for vector bundles on `Ě_VII`.
* **Schubert cells / Schubert calculus**.
* **Hodge structures** on compact-dual cohomology.

### 🔲 Tier E — Long-term (years)

* **Hermitian symmetric domain `EVII`**.
* **Shimura variety `S_Γ`**.
* **Automorphic vector bundles, Mumford 1977 canonical extension**.
* **Borel-Wallach `(g, K)`-cohomology, V-Z / KV / Franke**.
* **Cuspidal vs Eisenstein decomposition (Franke 1998)**.

## Key files in `..` (related)

* `../Strict.lean` — axiom-architecture for HC reduction (P54-P71 saturated).
* `../CrossRingArithmetic.lean` — first real Lean proofs from this project.

## How to use

Importing this directory:
```lean
import HodgeReduction.Infrastructure.Octonion
import HodgeReduction.Infrastructure.JordanJ3O
import HodgeReduction.Infrastructure.CartanMatrices
import HodgeReduction.Infrastructure.SchlafliGraph
```

Or via the top-level meta-import:
```lean
import HodgeReduction  -- imports everything
```

## Verification

Each file has its theorems verified by `lake build`. The `#print axioms`
output for theorems in these files should show only Lean kernel
foundational axioms (`propext`, `Classical.choice`, `Quot.sound`) —
NO domain-specific axioms.

## Mathlib PR plan

When complete and stable, these modules can be contributed to Mathlib
as standalone PRs:

1. `Mathlib.LinearAlgebra.CartanMatrix.Exceptional` — E_6, E_7, E_8
   Cartan matrices.
2. `Mathlib.Algebra.Octonion.Basic` — Octonion algebra over a
   commutative ring with characteristic-zero specialisation.
3. `Mathlib.Algebra.Jordan.J3O` — Exceptional Jordan algebra.
4. `Mathlib.Combinatorics.SchlafliGraph` — `srg(27, 10, 1, 5)`.

These would be the first occurrence in Mathlib of these exceptional
algebraic / combinatorial objects.

## License

Apache 2.0 (same as Mathlib).

## References

Standard references for the math:

* J. C. Baez, "The octonions", *Bull. Amer. Math. Soc.* **39** (2002), 145-205.
* T. A. Springer, F. D. Veldkamp, *Octonions, Jordan Algebras, and
  Exceptional Groups*, Springer Monographs in Mathematics (2000).
* N. Bourbaki, *Groupes et algèbres de Lie*, Ch. IV-VI (1968) + Ch. VII-VIII
  (1975).
* R. Carter, *Simple Groups of Lie Type*, Wiley (1972).
* H. Freudenthal, "Beziehungen der E_7 und E_8 zur Oktavenebene I-V",
  *Indag. Math.* **16-17** (1954-55).
* L. Schläfli, *Quart. J. Pure Appl. Math.* **2** (1858).
* J. Tits, "Une classe d'algèbres de Lie en relation avec les algèbres
  de Jordan", *Indag. Math.* **24** (1962), 530-535.
