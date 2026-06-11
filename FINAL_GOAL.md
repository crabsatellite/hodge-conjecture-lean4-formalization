# Final Goal — Hodge Conjecture (Mumford–Tate Reduction) Lean Formalization

**Document status**: living anchor for the multi-round Lean attack(对标
`projects/gray-code-evolution-internal/FINAL_GOAL.md` 的格式与纪律)。
**Last updated**: 2026-06-11(R470 Wave 5 audit 之后;Wave 6 = R472–R476 待执行)。
**执行方式**: 每轮执行 AI 按本文档的轮次小节操作;轮末更新本文档的
"当前阵地"小节 + 追加该轮记录。战略/review 角色负责验收。

---

## 最终目标

干掉唯一的项目公理 `canonicalE7ShimuraTor`,即:

```lean
-- 现状(MainTheorem.lean:323):
theorem hodgeConjectureReal_canonical :
    Infrastructure.HodgeStructure.VarietyHC
      canonicalE7ShimuraTor.cohomologyOfUnderlying
      canonicalE7ShimuraTor.algClassesOfUnderlying
-- #print axioms 给出:
--   [propext, Classical.choice, HodgeReduction.canonicalE7ShimuraTor, Quot.sound]
```

**终态判据**:存在同名结论的定理,其 `#print axioms` cone =
`{propext, Classical.choice, Quot.sound}`,且不通过任何 `Unit`/`True`
占位、不通过 toy carrier(R201 mandate:`Polynomial ℚ` toy 不算)。

这是数年尺度目标。本文档的作用是把它切成**每轮可执行、可验收、
可证伪**的具体 Lean 工件。

## 为什么是这条路线(等价于 GRAYCODE 的 "Why conj:hampath")

* `canonicalE7ShimuraTor : E7ShimuraTor` 是 ~60 字段的 structure;
  headline 证明只投影 3 个字段:`cohomologyOfUnderlying`、
  `algClassesOfUnderlying`、`mtCorrespondencePackage`。
* 所以消灭公理 ⇔ 无公理地构造这 3 个字段 ⇔ HCGapRegistry 的 L1–L4 四层
  (`HodgeReduction/HCGapRegistry.lean` 是 layer 与 decl 的对照表)。
* 多前线(Front A–E)是对 L1–L4 的并行切片;5 个 wave 已产出
  **44 条 substantive kernel-pure 定理、0 新公理**(R470 统计)。

---

## 当前阵地(2026-06-11,R470 后)

### Kernel-pure 已闭合资产(可直接复用)

| 资产 | 声明名 | 所在文件 |
|---|---|---|
| V56 weight-3 Hodge 结构 (1,27,27,1) | `instPureHodgeStructure_V56` | `Infrastructure/HodgeStructure/V56Instance.lean` |
| L2 实例 ×3(dim 0/1/1) | — | `HCGapL2/TrivialPoint.lean`, `ProjectiveLine.lean`, `EllipticCurve.lean` |
| Meyer / G2F4 / E8 vacuity | `thm_Meyer`, `thm_G2F4`, `thm_E8_vacuous` | `MainTheorem.lean` + `ClassicalResults.lean` |
| Hodge 多项式代数(general degree) | `FiniteHodgeDiamondData`, `hodgeSumAtDegree`, `hodgeSum_degree0/1/2`, `hodgeSymmetry` | `HCGapL4/FrontC4_HodgePolynomialAlgebra.lean` |
| rank 适配器(low degree) | `LowDegreeHodgePolynomialRankAdapter` + 5 定理 `rank0_eq_h00_from_adapter` 等 | `HCGapL4/FrontC5_HodgePolynomialToRankAdapter.lean` |
| all-codim 分发器 | `AllCodimHodgeRankMatchingData` | `HCGapL4/FrontE4_AllCodimProfileMatchingDispatcher.lean` |
| C5→E4 集成 | `lowDegreeAdapter_provides_rank_for_matching`, `AllCodimMatchingData_from_HodgePolynomialAdapter` | `HCGapL4/FrontE5_HodgePolynomialFeedsProfileMatching.lean` |
| 拓扑连通性探针 ×2 | `isPreconnected_closure_of_isPreconnected`, `preconnected_univ_of_dense_preconnected_subset` | `HCGapL4/FrontB5_CompactificationConnectednessProbe.lean` |
| 内部椭圆曲线 codim-1 链 | `InternalEllipticCycleClassMap` 等 | `HCGapL4/InternalEllipticCycleClassMap.lean` 及 GaussianCM* 系列 |

### 唯一公理 + 当前占位符债务

* 公理:`canonicalE7ShimuraTor`(OpenHypotheses.lean:893)。
* 占位符债务(均有 disclosure 标记,不是隐藏债):
  - `FiniteHodgeDiamondData_current`:`maxDegree = 0`,只有 `h^{0,0}=1` 有真实含义;
  - `LowDegreeHodgePolynomialRankAdapter_current` 的 rank = `fun k => if k = 0 then 1 else 0`;
  - R469 constructor 的 5 个 Prop target family = `fun _ => True`。

### 前线状态(R470 裁定,Wave 6 优先级)

| Front | 状态 | Wave 6 动作 |
|---|---|---|
| C(Hodge 多项式/rank) | 最高持续产出 | **R472 主攻** |
| E(profile matching 集成) | R469 constructor 已通 | **R473 主攻** |
| D(E7→CM Chow 对应) | 连续 5 wave 推迟 | **R474 激活最小片段** |
| B(Baily–Borel 连通性) | 函数级拓扑趋薄 | R475 仅维护 |
| A(Deligne H0 sheaf) | R455 暂停闸,4 个 Mathlib blocker | R500 前禁止全量审计 |

---

## 死路 / 禁止账本(违反 = review 直接打回)

1. **R43 Unit trick**(`HodgeClasses := Unit`)— R191/R192 已删除其全部消费者
   (`main_reduction_paper_axiom` 链、`E6_V27_vacuity` 等)。永不复活。
2. **新增 `axiom`** — 项目 mandate(`HCGapL4/Deligne1982BoundaryInterface.lean`
   开头有成文约束)。任何轮次 `#print axioms` 出现新名字 = 失败轮。
3. **Front A 全量 Mathlib 审计** — R455 闸:R500 前只允许"找到了具体 API"
   时的窄例外。4 个 blocker 固定为:`HasSheafify` / `HasExt`+`Sheaf.H 0` /
   scalar transport(`AddCommGrp`↔`Module ℚ`)/ constant-sheaf glue。
4. **翻转 `safeToReplaceOriginalHeadline`** — 只有 R398 安全审计条件满足才可。
5. **把 `True` 占位 instance 报告成 closure** — 所有占位必须出现在该文件
   "Honest disclosure" 小节,且 `*_current` 实例的 docstring 标
   `HONEST DISCLOSURE: PLACEHOLDER`。
6. **net W5/W6 膨胀** — 轮末 CheckEntry 的 W5+W6 计数不得高于轮前
   (status-marker 新增数 ≤ 该轮删除/收紧的旧 marker 数)。轮前轮后数字都
   写进该轮 audit 文件 docstring。

---

## Wave 6 执行计划(R472–R476,每轮一个文件 + 一个 ConeAudit 更新)

### R472 — Front C6:all-degree rank 适配器(优先级 1)

**先读**(必须,按序):
1. `HCGapL4/FrontC4_HodgePolynomialAlgebra.lean` — 拿到 `hodgeSumAtDegree`
   的精确定义(对 `Finset.range (k+1)` 求和的具体形状)与 `hodgeSymmetry` 字段签名;
2. `HCGapL4/FrontC5_HodgePolynomialToRankAdapter.lean` — 本轮要把它的
   `allDegreeTarget` 槽位变成真字段。

**新建文件**:`HodgeReduction/HCGapL4/FrontC6_AllDegreeRankAdapter.lean`

**必须交付的声明**(签名按此写,名字不得改):

```lean
namespace HodgeReduction
namespace HCGapL4
namespace FrontC6_AllDegreeRankAdapter

/-- 全度数 rank 适配器:R467 低度数三等式升级为 ∀ k 等式。 -/
structure AllDegreeHodgePolynomialRankAdapter where
  hodgeData : FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData
  rank : ℕ → ℕ
  rank_eq : ∀ k, rank k = FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree hodgeData k

/-- 降级构造器:全度数适配器 ⟹ R467 低度数适配器(真还原,非占位)。 -/
def toLowDegreeAdapter (A : AllDegreeHodgePolynomialRankAdapter) :
    FrontC5_HodgePolynomialToRankAdapter.LowDegreeHodgePolynomialRankAdapter where
  hodgeData := A.hodgeData
  rank := A.rank
  rank0_eq := A.rank_eq 0
  rank1_eq := A.rank_eq 1
  rank2_eq := A.rank_eq 2

/-- substantive (1/3):全度数 rank 公式。 -/
theorem rank_eq_hodgeSum_all_degrees (A : AllDegreeHodgePolynomialRankAdapter) (k : ℕ) :
    A.rank k = FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree A.hodgeData k :=
  A.rank_eq k

/-- substantive (2/3):R467 五条低度数定理全部从全度数适配器免费重获
    (经 toLowDegreeAdapter;逐条 `exact` 即可)。 -/
theorem rank1_eq_two_mul_h10_from_allDegree
    (A : AllDegreeHodgePolynomialRankAdapter) :
    A.rank 1 = 2 * A.hodgeData.hodgeNumber 1 0 :=
  FrontC5_HodgePolynomialToRankAdapter.rank1_eq_two_mul_h10_from_adapter
    (toLowDegreeAdapter A)

/-- substantive (3/3,本轮真正的新数学):奇数度数 rank 偶性。
    对 k 为奇数,hodgeSumAtDegree 的 p ↔ k-p 配对 + hodgeSymmetry
    给出 rank k 为偶数。证明策略:对 Finset.range (k+1) 用
    Finset.sum_involution 或 reindex(p ↦ k-p),配对项相等。 -/
theorem rank_odd_is_even (A : AllDegreeHodgePolynomialRankAdapter)
    (k : ℕ) (hk : Odd k) : Even (A.rank k) := ...
```

**证明策略提示**(`rank_odd_is_even`):若 `hodgeSumAtDegree` 定义为
`∑ p in Finset.range (k+1), hodgeNumber p (k-p)`,则用
`Finset.sum_nbij' (fun p => k - p)` 把和重排,得
`sum = ∑ hodgeNumber (k-p) p`,逐项用 `hodgeSymmetry` 等同,从而
`2 ∣ 2 * (前半段和)`。奇数 k 没有中点项,Finset.range 上做
`Finset.range_filter_lt` 切分或直接 `Nat.rec` 小心边界。预算 ≤ 150 行;
如 2 小时内不闭合,降级为:对 `k = 3` 的特例
`rank3_eq_two_mul_h30_add_two_mul_h21` 闭合(V_56 正好用 k=3),
并把一般情形写成带签名的 named open(放进文件尾 disclosure)。

**成功判据**:≥3 条 substantive kernel-pure(`#print axioms` 只见 3 kernel);
`toLowDegreeAdapter` 编译通过即算第 4 条(它消灭了 C5/C6 的层级重复)。
**失败记录方式**:`rank_odd_is_even` 不闭合时,保留精确签名为注释 +
named Prop(写明缺哪条 Finset 引理),禁止改成 `True`。

### R473 — Front E6:把 R469 constructor 接到 R405 转移模式(优先级 2)

**先读**:
1. `HCGapL4/ConditionalRealHeadlineTransfer.lean` — 拿到
   `hodgeConjectureReal_realCompatible_to_realCanonical_via_packages` 的
   完整 hypothesis 列表(R405 schema 到底要什么输入);
2. `HCGapL4/FrontE4_AllCodimProfileMatchingDispatcher.lean` — 5 个
   indexed Prop family 的精确 index 类型;
3. `HCGapL4/FrontE5_HodgePolynomialFeedsProfileMatching.lean`。

**新建文件**:`HodgeReduction/HCGapL4/FrontE6_DispatcherFeedsConditionalTransfer.lean`

**必须交付**:

1. **升级版 constructor**(本轮核心):

```lean
/-- R473:从 R472 全度数适配器构造 dispatcher 数据,
    且第一个 Prop family 不再是 True,而是被证明的真命题。 -/
def AllCodimMatchingData_from_AllDegreeAdapter
    (A : FrontC6_AllDegreeRankAdapter.AllDegreeHodgePolynomialRankAdapter) :
    FrontE4_AllCodimProfileMatchingDispatcher.AllCodimHodgeRankMatchingData where
  rank := A.rank
  hodgeNumber := A.hodgeData.hodgeNumber
  betti_eq_hodgeSum_target := fun k =>
    A.rank k = FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree A.hodgeData k
  -- ^ 这个 family 由 A.rank_eq 全 index 可证,不是 True
  degreewiseLinearEquivTarget := fun _ => True   -- 仍开放,照实披露
  hodgeCompatibilityTarget := fun _ => True
  algClassesCompatibilityTarget := fun _ => True
  mtPackageCompatibilityTarget := fun _ => True

theorem betti_target_discharged_all_k
    (A : ...) (k : ℕ) :
    (AllCodimMatchingData_from_AllDegreeAdapter A).betti_eq_hodgeSum_target k :=
  A.rank_eq k
```

2. 一个 `R405FeedPackage` structure:字段 = R405 schema 实际需要的
   hypotheses(按第 1 步读到的签名逐字段对齐)+ 来自 dispatcher 的数据;
   外加 `feed_consistency` 字段把两边 rank 函数钉成同一个。
   若 R405 的 hypotheses 里有当前完全无法供给的项,**不要造壳**:
   把该项原样作为 structure 的 Prop 字段保留,文件尾 disclosure 列明
   "R405 还缺 X、Y"。

**成功判据**:5 个 `True` family 中至少 1 个变为被证明的真命题
(`betti_eq_hodgeSum_target`);R405 缺口清单成文(这是 R477+ 的输入)。

### R474 — Front D6:Deligne 1982 最小片段激活(优先级 3)

**先读**:
1. `HCGapL4/Deligne1982BoundaryInterface.lean`(无公理约束的成文处);
2. `HCGapL4/InternalEllipticCycleClassMap.lean` +
   `HCGapL4/InternalMTPackageWithCycleData.lean`;
3. `MainTheorem.lean` 中 `hyp_HC_CM_Ab_real`(146 行)的精确陈述。

**新建文件**:`HodgeReduction/HCGapL4/FrontD6_Deligne1982MinimalFragment.lean`

**必须交付**:

1. `AbsoluteHodgeWitnessData` structure:对一个内部 cohomology 模型,
   字段 = (hodge class 选择子, galois 等变性 Prop 槽, algebraicity Prop 槽)。
   语义对齐 Deligne 1982 LNM 900 Thm 2.11 的"绝对 Hodge"三件套;
   **不是** OpenHypotheses 里那个 `Unit` 时代的 `absHodgeWitness`(那是
   R43 遗产,勿碰勿引用)。
2. substantive 定理(本轮最低要求 1 条):对**已有的内部椭圆曲线模型**
   (GaussianCM 链,p = 1),证明 cycle-class 像覆盖 Hodge 类,即把
   `InternalEllipticCycleClassMap` 已有的素材重组为
   `internal_elliptic_absoluteHodge_implies_algebraic_codim1`。
   这是 Deligne 1982 在 toy-内部模型上的第一个非占位投影。
3. `Deligne1982_full_statement : Prop`:真命题陈述(∀ CM abelian …),
   作为 named open 挂出,**绝不**以 axiom 或 True 形式出现。

**成功判据**:连续 5 wave 推迟后,D 前线第一次有 substantive 定理落地;
`#print axioms` 全 kernel。
**失败记录**:若内部模型素材不足以闭合第 2 项,把缺的引理签名
(精确到 binder)写进文件尾,标 `R479_target`。

### R475 — Front B6:仅维护(优先级 4,半轮预算)

* 只允许:删除/合并 B 线冗余 status marker(为第 6 条纪律腾 W5/W6 额度);
  以及**当且仅当**找到具体 Mathlib API 时加 1 条探针定理
  (候选:`IsPreconnected.image`、`DenseRange.preconnected` 一类,
  15 分钟内找不到就放弃)。
* 禁止开新方向。文件改动 ≤ 1 个。

### R476 — Wave 6 audit + 收尾(必做)

1. 新建 `HodgeReduction/HCGapL4/R476_MultiFrontWave6Audit.lean`,
   格式照抄 `R470_MultiFrontWave5Audit.lean`(8-item 报告 + per-front
   状态 + Wave 7 优先级 R477–R481 命名)。
2. 新建 `HodgeReduction/ConeAudits/R472_R476_ConeAudit.lean`:对本 wave
   全部 substantive 定理逐条 `#print axioms`,末尾必须含
   `#print axioms hodgeConjectureReal_canonical`(headline guard)。
3. 把 R472/R473/R474(/R475)/R476 的新文件 import 进 `HodgeReduction.lean` 尾部。
4. 跑完整审计(命令见下节),`failures` 必须 = 0;W5+W6 计数与 Wave 5 末
   对比写进 R476 文件 docstring。
5. 更新本文档:"当前阵地"表格 + 追加 "After R476" 小节(GRAYCODE 式:
   每轮 3–6 行,只写 decl 名和闭合/证伪事实,不写感想)。

---

## 每轮固定协议(所有轮次一样,照抄执行)

```powershell
cd e:\Dev\OpenExecution\research-line\academic-papers\millennium-problems\hodge-conjecture\lean4-formalization

# 1. 新文件单独 typecheck(快路径,~10s/文件)
lake env lean HodgeReduction/HCGapL4/<新文件>.lean

# 2. 编出 olean(供后续文件 import;绕过 lake 全链 replay)
#    注意 -o/-i/-c 三件套与 .lake/build 目录结构对齐,模板:
lake env lean -o .lake\build\lib\HodgeReduction\HCGapL4\<名>.olean `
  -i .lake\build\lib\HodgeReduction\HCGapL4\<名>.ilean `
  -c .lake\build\ir\HodgeReduction\HCGapL4\<名>.c `
  --root=. HodgeReduction/HCGapL4/<名>.lean

# 3. wave 末(R476)full 审计
lake env lean --run HodgeReduction/Scripts/StatusEntry.lean
python ../../../tools/chain-audit/ChainAudit/Postprocess/post_process.py `
  --raw chain-status/raw.json --out chain-status
lake env lean --run HodgeReduction/Scripts/CheckEntry.lean   # failures 必须 0
```

**每个新文件的固定骨架**(与 R467/R469 一致,缺一不可):
头部 docstring(含 8-item round-end report + Honest disclosure +
What this round does NOT do)→ substantive 内容 → status markers →
disclosure markers → 非闭合 `theorem RXXX_does_not_* : True := trivial`
(≥5 条,其中必含 `does_not_delete_canonical_axiom`、`does_not_solve_HC`)。

**MainChain.lean 同步规则**:只有当某轮**关闭或新开一个 gap 级目标**时
才动 `MainChain.lean`(例:R473 关闭 betti family ⇒ 在
`G-hcgap-l4-multifront` 的 summary 里加一句;R474 激活 D ⇒ decls 列表
追加 `internal_elliptic_absoluteHodge_implies_algebraic_codim1`)。
改后重跑协议第 3 步。

---

## R477+ 中期具体靶(Wave 7 备选,R476 时按产出重排)

* **T1 — V56 真值注入 C 线**:定义
  `FiniteHodgeDiamondData_V56W3 : FiniteHodgeDiamondData`,
  `maxDegree := 3`,`hodgeNumber 3 0 = 1 / 2 1 = 27 / 1 2 = 27 / 0 3 = 1`,
  其余 0;`hodgeSymmetry` 逐 case 可判定。然后证
  `(V56W3).hodgeSumAtDegree 3 = 56` 并与
  `instPureHodgeStructure_V56` 的 Hodge 数逐项钉死。
  这是第一次把占位 `_current` 替换为 paper-backed 数据。
* **T2 — L2 第 4 个实例**:`HCGapL2/ProjectivePlane.lean`,P² 的
  `VarietyCohomologyData`(diamond:h^{0,0}=h^{1,1}=h^{2,2}=1,其余 0),
  模板抄 `ProjectiveLine.lean`。第一个 dim ≥ 2 实例,直接喂 L2-G1。
* **T3 — R405 缺口清单消化**:按 R473 产出的清单逐项开轮。
* **T4 — R500 Front A 复审**:仅 4 个 blocker 的定点 Mathlib 重查
  (查 `Mathlib.Topology.Sheaves`、`CategoryTheory.Sites.Sheafification`
  当前版本是否已提供),有 API 才解除暂停。
* **T5 — mtCorrespondencePackage 拆包**:把 `E7ShimuraTor` 的
  `mtCorrespondencePackage` 字段拆成独立 structure,使 L4-G2(Deligne)
  与 L4-G3(对应包)在类型层面解耦——R474 的
  `AbsoluteHodgeWitnessData` 是其前置。

---

## 轮次记录(执行 AI 在此追加;格式:3–6 行/轮,只写事实)

### After R470(基线,2026-05-25)

* Wave 5 完结:C5 ×5 + B5 ×2 + E5 ×1+constructor;累计 44 substantive,0 公理。
* headline cone 4 公理不变;`chain-status` 全套 0 failures。
* Wave 6 优先级裁定:C6 > E6 > D6(激活)> B6(维护);A 暂停至 R500。

### After R776 reconciliation(2026-06-11)

* R472 exact-name surface added: `FrontC6_AllDegreeRankAdapter.lean` provides
  `toLowDegreeAdapter`, `rank_eq_hodgeSum_all_degrees`,
  `rank1_eq_two_mul_h10_from_allDegree`, and kernel-checked
  `rank_odd_is_even`.
* R473 exact-name surface added: `FrontE6_DispatcherFeedsConditionalTransfer.lean`
  builds dispatcher data from the all-degree adapter; the
  `betti_eq_hodgeSum_target` family is discharged by `A.rank_eq k`, while
  the remaining geometry families stay explicitly open.
* R474 exact-name supplement added:
  `FrontD6_Deligne1982MinimalFragment_FinalGoalCompat.lean` defines
  `AbsoluteHodgeWitnessData`, closes the internal elliptic codim-1
  cycle-class projection, and records `Deligne1982_full_statement` as a
  non-`True` named open statement.
* R476 audit surface added as `ConeAudits/R472_R476_ConeAudit.lean`; old
  `FrontD6_Deligne1982MinimalFragment.lean` build blocker was fixed by
  using `trivial` as the proof of its `True` target marker.
* Current main theorem frontier remains R776: exact image, compact-dual
  generator membership, and the target-line/quotient-vanishing/finite-upper
  bound spellings are the same open target-side gap. `Close Theorem` is not
  complete.
