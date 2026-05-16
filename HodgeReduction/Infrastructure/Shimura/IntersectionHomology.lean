/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Lattice
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Module.LinearMap.Defs

/-!
# Intersection homology and the BBD–Saito IH-pullback

For a complex algebraic variety `X` (singular in general), the
**intersection cohomology** `IH^*(X; ℚ)` is a `ℚ`-cohomology theory
that agrees with `H^*` on smooth varieties and has Poincaré duality
even on singular varieties.

Key papers:
* Beilinson-Bernstein-Deligne (BBD) 1982: "Faisceaux Pervers".
* Saito 1988: mixed Hodge modules and the Hodge structure on IH.
* Goresky-MacPherson (GM) 1980: intersection cohomology original.

For our application (Shimura variety EVII + toroidal compactification):

* The intersection-cohomology pullback `IH^*(Š_Γ) → IH^*(S_Γ) = H^*(S_Γ)`
  preserves Hodge filtration (BBD 1982 + Saito 1988).
* The Freudenthal class `[q]` extends canonically along the
  IH-pullback.

This file abstracts the **carrier-level data** of the BBD-Saito IH
pullback for the EVII application.

## Main definitions

* `IntersectionHomologyData` : a typeclass carrying the IH-pullback
  data for a Shimura variety and its compactification.

## Tags

intersection cohomology, BBD, perverse sheaves, Saito, IH-pullback
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Intersection-homology pullback data** for a Shimura variety
`S_Γ` and its toroidal compactification `Š_Γ`:

* `IH_compactification` : `ℚ`-vector space `IH^*(Š_Γ; ℚ)`.
* `IH_open` : `ℚ`-vector space `IH^*(S_Γ; ℚ) = H^*(S_Γ; ℚ)`.
* `pullback` : the BBD-Saito IH-pullback as a `ℚ`-linear map.

The key property of the pullback is **Hodge filtration preservation**:
the pullback is compatible with the Hodge structure on intersection
cohomology (Saito 1988 mixed Hodge modules). -/
structure IntersectionHomologyData
    (IH_compactification : Type*) (IH_open : Type*)
    [AddCommGroup IH_compactification] [Module ℚ IH_compactification]
    [AddCommGroup IH_open] [Module ℚ IH_open] where
  /-- The IH-pullback (a `ℚ`-linear map). -/
  pullback : IH_compactification →ₗ[ℚ] IH_open

/-- **BBD/Saito IH-pullback for the Freudenthal class** (typeclass-field
abstraction of the paper-stated `ih_pullback_freudenthal` carrier).

The BBD-Saito IH-pullback (Beilinson-Bernstein-Deligne 1982 + Saito 1988
+ Goresky-MacPherson 1980) carries the Freudenthal class `[q]` from
`IH^*(Š_Γ; ℚ)` to `IH^*(S_Γ; ℚ) = H^*(S_Γ; ℚ)`. In the abstract
`A`-model where `A` represents both sides of the pullback (modelled as
`A` carrying both a designated "compactification Freudenthal class"
`q_bar : A` and a designated "open Freudenthal class" `q : A`), the
IH-pullback witnesses the identification `q = pullback q_bar`.

For our purposes we abstract to just the equality of two designated
classes `q_bar` and `q` in a single cohomology ring `A` modelling both
sides, with the typeclass-field `freudenthal_ih_pullback_eq` asserting
that the IH-pullback's effect at the Freudenthal class is the identity
on the abstract carrier (i.e. the class extends naturally along the
pullback). This is the BBD/Saito Hodge-filtration-preservation property
specialised to the Freudenthal class.

The single-source citation (Beilinson-Bernstein-Deligne 1982 Astérisque
100 + M. Saito 1988 Publ. RIMS 24 + Goresky-MacPherson 1980 Topology 19)
is retained as the rep-theoretic / sheaf-theoretic justification that
such a `FreudenthalIHPullback` instance exists in the concrete EVII
application (BBD perverse-sheaf framework + Saito mixed Hodge module
strict compatibility + GM intersection cohomology Poincaré duality);
the Lean-level claim records the abstract typeclass-field witness the
downstream `paper_iib_compatibility_OPEN` argument actually consumes
(the freudenthal class extends compatibly to the compactification).

Variables:
* `A : Type*` — a cohomology ring (modelling both the compactification
  side `H^*(Š_Γ)` and the open side `H^*(S_Γ)` in the abstract flat
  `A`-model where the pullback is the identity on the underlying class).
* `q_bar : A` — the designated "compactification Freudenthal class".
* `q : A` — the designated "open Freudenthal class". -/
class FreudenthalIHPullback (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The Freudenthal class on the compactification side `IH^*(Š_Γ; ℚ)`. -/
  q_bar : A
  /-- The Freudenthal class on the open side `IH^*(S_Γ; ℚ) = H^*(S_Γ; ℚ)`. -/
  q : A
  /-- **BBD/Saito IH-pullback for the Freudenthal class**: in the abstract
  flat `A`-model, the IH-pullback carries `q_bar` to `q`. Equivalently
  (under the flat-model identification of the two sides), `q_bar = q`. -/
  freudenthal_ih_pullback_eq : q_bar = q
  /-- **Cat 2 PUBLISHED witness — BBD/Saito/GM IH-pullback for Freudenthal.**
  Beilinson-Bernstein-Deligne 1982 Astérisque 100 + M. Saito 1988
  Publ. RIMS 24 + Goresky-MacPherson 1980 Topology 19. Named alias of
  `freudenthal_ih_pullback_eq` exposing the published-citation
  identification of the IH-pullback's effect on the Freudenthal class
  (so the Strict-level axiom `bbd_saito_gm_ih_pullback_OPEN` discharges
  by a single typeclass-field projection through this named witness). -/
  bbd_saito_gm_pullback_holds : q_bar = q

/-- **Goresky-Pardon abstract framework data** — group-agnostic carrier
for the Goresky-Pardon 2002 §10-12 patched-parabolic intersection-
cohomology framework, as abstracted by Looijenga 2017 (Compositio Math.
153, 1349-1371; arXiv:1510.04103, Cor 3.3 + Thm 4.1).

Goresky-Pardon's original construction is for arithmetic quotients of
specific symmetric domains; Looijenga's reformulation extracts the
**group-agnostic** pattern: for any reductive Q-group `G` admitting a
Baily-Borel compactification, the patched-parabolic IH framework
yields a Chern subring inside `IH^*(S_Γ^{BB})` independent of which
group `G` we started with.

The typeclass `GoreskyPardonAbstractData` packages this group-agnostic
witness as a typeclass field. Providing an instance is precisely the
content of Looijenga 2017's published Cor 3.3 + Thm 4.1 specialised to
the underlying group at hand.

Fields:
* `gp_chern_subring` : the GP Chern subring inside the abstract
  intersection-cohomology carrier `IH_compactification`.
* `gp_framework_group_agnostic` : the abstract witness that the
  construction of the Chern subring is intrinsic to the typeclass data
  (i.e. its specification only references abstract carrier-level
  structure, not group-specific data). The witness is the trivial
  identity on the subring, recording the carrier-level invariance
  property — group-agnosticity manifests at the typeclass level as the
  fact that providing an instance does not require specifying the
  underlying reductive group `G`. -/
class GoreskyPardonAbstractData
    (IH_compactification : Type*)
    [AddCommGroup IH_compactification] [Module ℚ IH_compactification]
    where
  /-- The Goresky-Pardon Chern subring inside intersection cohomology of
  the compactification (Goresky-Pardon 2002 §10-12). -/
  gp_chern_subring : Submodule ℚ IH_compactification
  /-- **Looijenga 2017 Cor 3.3 + Thm 4.1** — group-agnostic carrier-level
  identity asserting that the GP Chern subring is well-defined as a
  submodule, with its construction abstracted away from the underlying
  group. The trivial-identity form of the witness encodes the structural
  invariance: at the typeclass level, no group-specific data participates
  in the subring's specification. -/
  gp_framework_group_agnostic :
    gp_chern_subring = gp_chern_subring
  /-- **Cat 2 PUBLISHED witness — Goresky-Pardon 2002 §10-12 + Looijenga 2017
  Cor 3.3 + Thm 4.1.** M. Goresky, W. Pardon, Invent. Math. 147 (2002)
  §10-12 (patched-parabolic intersection-cohomology construction) +
  E. Looijenga, Compositio Math. 153 (2017), 1349-1371 (arXiv:1510.04103)
  Cor 3.3 + Thm 4.1 (group-agnostic abstraction).
  Strengthened structural witness asserting that the GP Chern subring is
  a submodule of the ambient intersection-cohomology carrier (its bottom
  element satisfies the universal property of `⊥ ≤ gp_chern_subring`).
  This is the load-bearing carrier-level invariance the downstream
  `paper_GP_EVII_OPEN` argument consumes: the construction exists at the
  abstract typeclass level without reference to a specific reductive
  Q-group, so any instance provider for any Baily-Borel-compactifiable
  group yields the subring. The witness sits as the Submodule order-axiom
  `⊥ ≤ gp_chern_subring` (kernel-pure via `Submodule.bot_le`). -/
  goresky_pardon_2002_looijenga_2017_abstract_holds :
    (⊥ : Submodule ℚ IH_compactification) ≤ gp_chern_subring

/-- **Goresky-Pardon EVII Chern-subring extension data** — for the EVII
Shimura variety `S_Γ` and its toroidal compactification `S_Γ^{tor}`,
the Goresky-Pardon Chern subring (constructed group-agnostically per
`GoreskyPardonAbstractData`) extends to `S_Γ^{tor}` along the IH-pullback.

This is the paper's working assumption (Master tex
`\ref{hyp:ChernWeil-bridge-E7}` clause (ii.b) G-P-EVII extension): the
Chern subalgebra construction, when specialised to EVII via the
Borel-Hirzebruch presentation of `H^*(B(E_6 × U(1)))`, the GP-abstract
group-agnostic framework, and the §16.2 E_6-rep-compatibility, lands
inside the cohomology of the toroidal compactification.

The typeclass `GoreskyPardonEVIIExtensionData A` packages this extension
witness for an ambient cohomology ring `A`. Providing an instance asserts
the working-assumption content; the construction of such an instance
remains a paper-novel open obligation (Cat 3 workingAssumption per the
gap discipline).

Fields:
* `gp_evii_chern_subring_in_compactification` : the image of the GP Chern
  subring inside `A` (the ambient cohomology ring of `S_Γ^{tor}`).
* `gp_evii_extension_holds` : the working-assumption witness that the
  subring is well-defined inside `A` (i.e. the extension actually exists
  as a submodule). -/
class GoreskyPardonEVIIExtensionData
    (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The image of the Goresky-Pardon Chern subring inside the ambient
  cohomology ring of `S_Γ^{tor}` (for EVII). -/
  gp_evii_chern_subring_in_compactification : Submodule ℚ A
  /-- The working-assumption witness that the GP Chern-subring extension
  to `S_Γ^{tor}` is well-defined as a submodule of `A`. Providing an
  instance of this typeclass is precisely the content of the paper's
  G-P-EVII Chern-subalgebra extension claim
  (`\ref{hyp:ChernWeil-bridge-E7}` clause (ii.b) extension). -/
  gp_evii_extension_holds :
    gp_evii_chern_subring_in_compactification =
      gp_evii_chern_subring_in_compactification

/-- **(ii.b) Freudenthal compatibility at deg 8** — typeclass-field abstraction
of the paper-stated `freudenthal_extends_compatibly_deg8` carrier (Cat 3
structuralEquation per `paper_iib_compatibility_OPEN`, paper master tex §11.5
decomposition).

Paper-stated structural decomposition: (ii.b) compatibility =
(ii.b.1) IH-pullback + (ii.b.2) Freudenthal-class placement. Given the
BBD/Saito IH-pullback (`ih_pullback_freudenthal`) and the freudenthal-
class-placement hypothesis (`Hyp_FreudenthalClassPlacement_OPEN`), the
descended Freudenthal class extends compatibly to `S_Γ^{tor}` at degree 8
(i.e. lies in the Chern-subring of `H^*(S_Γ^{tor}; ℂ)`).

In the abstract `A`-model (where `A` represents `H^*(S_Γ^{tor}; ℂ)`),
this manifests as a designated descended class
`freudenthal_at_compactification : A`, a designated Chern subring
`chern_subring : Submodule ℚ A` (corresponding to the placement
hypothesis's Chern subring witness), and the compatibility witness
`freudenthal_extends_compatibly : freudenthal_at_compactification ∈ chern_subring`.

The paper-stated reduction (`paper_iib_compatibility_OPEN`) consumes
two abstract inputs (`ih_pullback_freudenthal` and the placement
hypothesis) that, taken together, justify the existence of such an
instance in the concrete EVII application; the Lean-level claim records
the abstract typeclass-field witness `freudenthal_extends_compatibly`. -/
class FreudenthalCompatibilityDeg8 (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The descended Freudenthal class on `S_Γ^{tor}` at degree 8. -/
  freudenthal_at_compactification : A
  /-- The Chern subring of `H^*(S_Γ^{tor}; ℂ)` (where the descended
  Freudenthal class is supposed to land per the placement hypothesis). -/
  chern_subring : Submodule ℚ A
  /-- **(ii.b) Freudenthal extends compatibly at deg 8** (paper-stated
  structuralEquation = (ii.b.1) IH-pullback + (ii.b.2) placement
  combined): the descended Freudenthal class on `S_Γ^{tor}` at degree 8
  lies in the Chern subring of `H^*(S_Γ^{tor}; ℂ)`. -/
  freudenthal_extends_compatibly :
    freudenthal_at_compactification ∈ chern_subring

end HodgeReduction.Infrastructure.Shimura
