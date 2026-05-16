# Trick Audit — R7 (READ-ONLY)

Scope: every `.lean` file under `HodgeReduction/`. Method: keyword sweep
(`:= True`, `sorry`, `native_decide`, `^opaque`, `axiom X : Prop`,
`_holds := trivial`, `:= ⊤`) + targeted context reads for every hit.

---

## §1 Summary

| Bucket | Count | Verdict |
|--------|------:|---------|
| A (hard tricks)   | **0** | none |
| B (soft tricks)   | **2 loci** | minor |
| C (false positives confirmed honest) | many | n/a |
| Honest `axiom : Prop` (Cat 2/3 placeholders) | ~53 in `OpenHypotheses.lean` + 3 `opaque ... : Prop` in `Strict.lean` | by design |

**Overall: MINOR.** No `sorry`, no `native_decide`, no `opaque P :
Prop` paired with `axiom : P` (the Cat A.4 anti-pattern that bit
`V_dyn` 2026-05-15). Two soft `:= True` typeclass-field fills sit in
`AtlasE7minus25.lean` and propagate one step into the Strict layer
through the `voganZuckerman_framework`/`knappVogan_induction` fields of
`VZAqLambdaData`. They are not load-bearing for the
`HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` axiom set (which
P90-P94 reduced to 2 Cat 2 axioms), but they DO mean the
"Atlas instance discharges VZ 1984 + KV 1995 frameworks" claim in the
docstring is decorative, not load-bearing.

---

## §2 Category A findings (hard tricks)

**None.**

Sweep confirmations:
- `:= True` outside string literals: only 2 lines, both in
 `Infrastructure/Automorphic/AtlasE7minus25.lean` — these are
 typeclass-field fills, not `def X : Prop := True` aliases. Moved to §3.
- `sorry`: zero matches inside proof bodies. All hits are docstring /
 comment / `attackHistory`-string references documenting the absence
 of `sorry` (e.g. `MainTheorem.lean:252` "no `sorry` body"). Verified
 against `theorem ... := by ... sorry` and `:= sorry` patterns.
- `native_decide`: zero in proof bodies. All hits are docstring
 disclaimers ("no `native_decide`"). The
 `SchlafliGraph.lean:398` mention is the opposite — explicitly says
 `decide`, NOT `native_decide`.
- `^opaque` outside `: Prop`: one hit, `Strict.lean:448`
 `opaque borelM_E7minus25 : ℕ` — this is a Type-valued opaque, not a
 Prop, so the A.4 anti-pattern does not apply. The docstring honestly
 records "Concrete value not proposed — would require atlas-software
 `A_q(λ)` enumeration which is genuinely open."
- `opaque ... : Prop` paired with `axiom : <name>`: NO occurrences.
 The historical anti-pattern is gone — see §5 for the new pattern.
- `implemented_by`: zero matches.

---

## §3 Category B findings (soft tricks)

### B.1 `AtlasE7minus25.lean:308-311` — framework-witness fields set to `True`

```lean
voganZuckerman_framework := True
voganZuckerman_framework_holds := trivial
knappVogan_induction := True
knappVogan_induction_holds := trivial
```

**Context.** `VZAqLambdaData` (declared
`Infrastructure/Automorphic/VoganZuckerman.lean:126-138`) is a Schmid
two-field typeclass — `field : Prop` + `field_holds : field`. The
docstrings on both fields claim they discharge the Strict-level
`vogan_zuckerman_1984_OPEN` and `knapp_vogan_1995_OPEN` axioms
(Compositio 1984 + PMS-45 1995 PUBLISHED frameworks).

**Why it's a soft trick.** The Schmid pattern is *valid in principle*
(the `Prop` field is intended to carry whatever named-theorem content
the instance provider has at hand), but here the ONLY instance,
`vzAtlasInstance`, sets the field to `True`, so the witness slot is
vacuous. The docstring at `AtlasE7minus25.lean:280-285` justifies this
by claiming the Atlas finite list IS the computational realization of
both frameworks — which is mathematically reasonable but is a
*meta*-argument, not a Lean-checked discharge. A skeptic could
substitute any other `: Prop` filler and the build would stay green.

**Severity: low.** Inspection of axiom-dependency in `Strict.lean`
(P90-P94 reduction text + the explicit P230-P232 typeclass-projection
closures) shows the final
`HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` chain does NOT
project through `voganZuckerman_framework` /
`knappVogan_induction` — the load-bearing fields are the *concrete*
ones (`bottomDegree`, `salamancaRibaClassification`,
`knappVoganUnitarity`, `trivial_bottomDegree_zero`,
`holoDiscrete_bottomDegree_eq_dim`), all discharged by `decide` on the
finite Atlas table. So the `True` fills are *decorative* in the
docstring sense but not a vector for an unconditional-HC overclaim.

**Recommended fix.** Either (a) remove the two framework-witness
fields from `VZAqLambdaData` entirely (they are unused), or (b)
replace `True` with a substantive predicate the Atlas table actually
satisfies (e.g. "every label has a corresponding theta-stable
parabolic representative" — a `Decidable` enumeration claim). Option
(a) is honest and cheaper.

### B.2 `Strict.lean:1370, 1927` — two remaining `opaque ... : Prop` carriers

```lean
opaque higher_rank_good_metric_for_EVII : Prop          -- L1370
opaque twisted_Phi_L_total_coefficient_nonzero : Prop   -- L1927
```

**Context.** These are Cat 3 placeholders. Neither is paired with an
`axiom : <name>` (so the Cat A.4 anti-pattern does NOT apply), and
both docstrings record their status honestly:

- L1370 (`higher_rank_good_metric_for_EVII`) is consumed by
 `Hyp_HigherRank_GoodMetric_OPEN`, which `Strict.lean:4137-4147`
 marks `gapClosed` via the Mumford 1977 + Harris 1985 + BKK 2007 + K∞
 synthesis (P34). The carrier is documented as retained "as a
 faithful tex-narrative record" — see §4.
- L1927 (`twisted_Phi_L_total_coefficient_nonzero`) is the P118
 *honest revert* of a previous trick: "P115 closure (def :=
 ℚ-arithmetic `-48 ≠ 0`) was a trick — `-48 ≠ 0` is decidable but
 does NOT capture the cohomological content (Φ_L is a cross-ring map
 between H^*(BG; ℚ) and H^*(S_Γ; ℚ)). Restored to opaque pending
 Chern-class / classifying-space infrastructure." That is exactly
 the gap-ledger discipline this audit exists to enforce.

**Severity: low (calibrated).** These are honest opaques that record
where the framework is incomplete; they are NOT marked `gapClosed`
*as opaque Props*. Where the corresponding Strict entry IS
`gapClosed`, the closure routes through an *abstract framework*
(P229/P230/P231/P232 typeclass-projection chain) — see §5.

---

## §4 Category C confirmations (NOT tricks)

1. **R6/R7 AG framework files**
 (`Infrastructure/AlgebraicGeometry/{LineBundle, PicardGroup,
 FirstChernClass, ExponentialSequence, HodgeDecomposition,
 ChowGroup}.lean`, ~2200 lines total). Every class has substantive
 typeclass fields — `expMap`, `delta`, `exact_at_holo`,
 `intToHolo` for the exponential sequence;
 `intersect`, `cl`, `cl_intersect`, `cl_fundamental` for Chow.
 Trivial-example instances exist (`instance ... ChowGroupData Unit`,
 `instance ... ExponentialSequenceData Unit`,
 `instance ... HodgeDecompositionData Unit ℂ`) but in each case
 they (a) are explicitly named `TrivialUnit` / `UnitExample` /
 `HpqTrivial`/`HkTrivial`, (b) are documented as "non-vacuous
 typecheck witnesses", and (c) carry real proof obligations
 discharged by `rfl` / `Subsingleton` / explicit lemmas. The
 framework is not vacuous — the typeclass shapes (e.g. exactness
 fields `range = ker`) are mathematically the right shape.

2. **`Concrete/EVII.lean` — `Algebra.adjoin ℚ {X}` fields**
 (L124, L184). The brief flagged "Algebra := ⊤" as suspicious. The
 actual code uses `Algebra.adjoin ℚ ({X} : Set A_EVII)`, not `⊤`.
 The lemma `Polynomial.adjoin_X` proves this *equals* ⊤
 *theorem-wise* (see L138), but the **definitional form**
 `adjoin ℚ {X}` is the load-bearing one — it states the content
 ("every class is generated by `h = c_1(L_amp)` via ring ops") and
 the kernel-pure proofs route through `Algebra.subset_adjoin`. This
 is exactly the R5-A discipline: definitional content, not `⊤`-by-
 fiat. NOT a trick.

3. **`OpenHypotheses.lean` — ~53 `axiom X : Prop` declarations.**
 These are Cat 2 / Cat 3 *PLACEHOLDERS* — each one is named with a
 paper-citation suffix (`_NAMED_OPEN`, `_BROKEN_LINK`,
 `_INVENTION_CLASS`, `_PUBLISHED`, `_CONJECTURAL`) and consumed
 downstream as an explicit hypothesis. The pattern is

 ```lean
 axiom Is<NamedFact>_PUBLISHED : Prop
 axiom <attribution>_<fact>_PUBLISHED : Is<NamedFact>_PUBLISHED
 ```

 i.e. the Prop **schema** is one axiom and the **witness** is a
 separate axiom carrying the paper citation. This is the standard
 way to encode "we are using the published claim X" without
 attempting to formalize its proof — NOT the `opaque P : Prop +
 axiom Q : P` anti-pattern. The brief's Cat A.4 explicitly targets
 the case where `opaque` *hides what `P` is*; here `P` is itself a
 named hypothesis (`Is<NamedFact>_PUBLISHED`), so the witness axiom
 IS the named hypothesis citation. Honest.

4. **`Strict.lean:4143/4155/4178/4192` — "P23 `:= True` (vacuous
 violation)" strings.** These appear inside `attackHistory`
 string-array fields of `StrictGapEntry`. They are
 *history records* — every one is followed by "P24 CRITICAL #2 fix:
 real carrier" in the same array, recording that the previous P23
 trick has been replaced. NOT tricks — they are the ledger doing
 its job.

5. **`Submodule := ⊤` fields in trivial examples** (e.g.
 `HodgeDecomposition.lean:440` `Q_lattice := ⊤`). These are
 trivial-Unit example instances; the `⊤` choice is mathematically
 correct for the one-point manifold (every rational is a
 ℚ-submodule element). The brief's concern about
 `Algebra := ⊤` in EVII is addressed in (2) above — Concrete uses
 `adjoin ℚ {X}`, not `⊤`.

---

## §5 Gap-ledger reconciliation

`Strict.lean` contains 143 `gapClosed` occurrences across the
`StrictGapEntry` collection. Spot-checked the four entries that
historically tripped on `P23 := True`:

| Entry | Status | Closure path | Honest? |
|---|---|---|---|
| `Hyp_HigherRank_GoodMetric_OPEN` (L4137-4147) | gapClosed | Mumford 1977 Thm 3.1 + Harris 1985 §4 + BKK 2007 Thm 5.2 + K∞ decomp; opaque carrier kept as tex-narrative record only — NOT load-bearing for the closure proof | YES |
| `Hyp_ChernWeilForm_Proportionality_OPEN` (L4149-4161) | gapClosedConditional on `Hyp_MumfordExtension_LBlockDiagonal_OPEN` | P40 Hodge-refinement, abstract `LRefinedChernWeilProportionalityData` typeclass + field projection (P232) | YES |
| `Hyp_FreudenthalClassPlacement_OPEN` (L4172-4184) | gapClosedConditional | P35 reduction → P230 LEAN-CLOSED via `FreudenthalChernSubalgebraPlacementData` typeclass field `placement_holds`; honest conditional on `Hyp_BorelMAtLeast8_OPEN` + `Hyp_Eisenstein_Vanishing_OPEN` | YES |
| `Hyp_CrossRingPhiNonzero_OPEN` (L4186-4198) | gapClosed | P231 typeclass-projection chain `twistedPhiFilt_q_eq_neg_48_h_pow_4` + `h_pow_4_ne_zero` + `coefficient_neg_48_ne_zero`; P118 honestly notes the previous P115 `:= -48 ≠ 0` was a trick and was reverted, then **properly closed** via Cat-1 abstract framework typeclass field | YES |

No `gapClosed` flips need to revert.

The remaining `opaque ... : Prop` carriers in §3.B.2 are NOT marked
`gapClosed` as opaques — the corresponding entry status is `gapClosed`
because the entry routes through an *abstract framework* (typeclass
field) introduced by P229-P232, not because the `opaque` was
discharged. This is the correct discipline.

---

## §6 Recommendations

1. **Atlas framework-witness fields (B.1):** drop
 `voganZuckerman_framework` + `voganZuckerman_framework_holds` and
 `knappVogan_induction` + `knappVogan_induction_holds` from
 `VZAqLambdaData` (4 lines in `VoganZuckerman.lean`, 4 lines in
 `AtlasE7minus25.lean`). They are documented as "downstream proofs
 project through this field to discharge Strict-level
 `vogan_zuckerman_1984_OPEN`" but the actual closure routes around
 them (see B.1 severity analysis). Removing them removes a quiet
 `True`-filler without affecting the build. Alternative: replace
 with a `Decidable` enumeration claim about the Atlas table.

2. **Two remaining `opaque ... : Prop` (B.2):** keep as-is. Both
 carry honest docstrings (P118 revert note especially); neither
 corresponds to an over-stated `gapClosed`. Optional: surface the
 P118 revert in `attackHistory` of the corresponding
 `StrictGapEntry` so the trick history is visible from the entry
 itself, not just the carrier docstring.

3. **No `gapClosed` flag flips required.** All four spot-checked
 entries pass the substantive-content test.

**Top-level verdict: MINOR exposure.** The honest opaques + framework
axioms are by design; the only genuine soft trick is the
`True`-filling of two framework-witness slots in the Atlas instance,
which is decorative rather than load-bearing. Fix B.1 to clean up the
last `:= True` outside string literals; B.2 is policy-compliant.
