# REVIEW — R778 裁定 + R779 放行指示(指定坐标系坍缩轮)

Reviewer 独立验证记录,2026-06-11 18:20。对象:commit `a4155e1`
"R778 isolate exact image target projection gap"。

## R778 裁定:**PASS**,且 reviewer 复核后把缺口进一步降级(见下)

验证证据:

| 检查项 | 结果 |
|---|---|
| `FrontC212` 全文逐定理读审 | 8 条定理结构诚实:countermodel 显式(scalar 级,`⊤`/`⊥` 子模),三前提 + ¬(1) 的合取定理 5/8 完整,正向 sanity 6/8 的 calc 链每步可追 ✓ |
| snapshot 与 decide 一致 | `countermodelKilledByCartanLine := false` 如实记录第三结局 ✓ |
| commit 范围 | 仅 C212 + MainChain + chain-status 再生 + review 文件镜像,无越权 ✓ |
| 无新增 axiom / native_decide | ✓(报告称 grep = 0,与文件读审一致) |

执行质量无可挑剔。但是——

## Reviewer 复核发现:R778 隔离出的缺口**不是新数学,是指定坐标系不连贯**

读 `Infrastructure/Cohomology/Matsushima.lean` 与
`Infrastructure/Automorphic/CuspidalCohomology.lean` 的类定义后,两个事实:

**事实 1:`target_invariants = trivialModulePart` 今天就 kernel-可导。**
现有字段:

```
EisensteinVanishingDeg8.target_invariants_eq_cuspidal :
    target_invariants = cuspidalSubspace
CuspidalGInvariantTrivialModuleDeg8.cuspidal_G_invariant_eq_trivial_module :
    cuspidalSubspace ⊓ target_invariants = trivialModulePart
```

代入 + `inf_idem` 两步:`target_invariants = trivialModulePart`。

**事实 2:R778 缺口 `surjectivity_target = target_invariants` 因此等价于
`surjectivity_target = trivialModulePart`,而这两个字段的 docstring 指定的是
同一个数学对象**:

- `MatsushimaSurjectivityData.surjectivity_target` docstring:
  "the **cuspidal trivial-module G-invariant part** of H^q(S_Γ)";
- `CuspidalCohomologyData.trivialModulePart` docstring:
  "the **trivial-module part** of the cuspidal cohomology"。

同一对象在两个 typeclass 里各自独立指定,之间没有 coherence 等式。R778 的
countermodel 正是钻这个空子(`surjectivity_target := ⊥`,其余 `:= ⊤`)。
这是接口自伤,不是 Matsushima 理论的真空缺。

**事实 3(更大的坍缩,执行者须逐一核对):同样的"重复指定"遍布源侧。**
"deg-8 trivial-module Cartan image"这一个对象,被指定了至少四次:

| 字段 | 所在类 | 载体 |
|---|---|---|
| `CompactDualData.H8` | CompactDualData | A |
| `MatsushimaCompactDualData.compactDual` | MatsushimaCompactDualData | A |
| `MatsushimaData.source_invariants` | MatsushimaData | A |
| `MatsushimaSurjectivityData.surjectivity_source`(docstring:"the trivial-module Cartan image ⟨h^4⟩") | MatsushimaSurjectivityData | A |

现有胶水只有一条:`compactDual_eq_source_invariants`。
注意 `surjectivity_eq : map j_q surjectivity_source = surjectivity_target`
是现成字段——所以**如果**源侧 coherence `surjectivity_source = compactDual`
成立,则:

```
map j_q source_invariants = map j_q compactDual = map j_q surjectivity_source
  = surjectivity_target            -- 即 (1) exact image,一步不剩
```

**(1) 可能只差一条源侧 coherence 等式**,连 R778 找到的 target 侧投影等式
都不需要。三场 contract 的剩余实质很可能整体坍缩为:
"若干 designation coherence 等式 + 已有字段"。届时诚实 frontier 从
"抽象 contract 未证"移动到"没有任何真实 instance 同时实现这些指定"
——也就是回到 L1/L2 真实几何构造,这才是这条线五个月来的真位置。

---

## R779 放行 — Track HC′:指定坐标系坍缩轮(原 R779 Schubert probe 顺延为 R780)

### 必须交付(新文件 `FrontC213_H8ResidualDesignationCoherenceCollapse.lean`)

**第 1 步 — 免费定理(直接证,不许跳过)**:

```lean
theorem r779_target_invariants_eq_trivialModulePart
    [全 R776 栈] :
    MatsushimaData.target_invariants (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  -- target_invariants_eq_cuspidal 代入 cuspidal_G_invariant_eq_trivial_module
  -- + inf_idem;两次 rw 级别
```

**第 2 步 — designation coherence 清查表**:把上文 4+3 个指定字段全部列举,
对每一对写明:已有胶水字段(名字)/ 缺失。产出 `R779DesignationLedger`
(List String + snapshot),kernel 钉死。**先查后做**——若发现我漏看的现有
胶水(例如某 FrontC 文件早已加过 coherence 字段),如实记录并直接使用。

**第 3 步 — 最小 coherence 类**(只为清查表里确实缺失的对,每对一个字段,
禁止合并打包):

```lean
class MatsushimaSourceDesignationCoherence (A B) [...] where
  surjectivity_source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)

class MatsushimaTargetDesignationCoherence (A B) [...] where
  surjectivity_target_eq_trivialModulePart :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B)
```

docstring 引用与被胶合字段相同的文献(Matsushima 1962 Thm 4.1 / Borel 1974
Thm 7.5 / V-Z 1984 链),并写明:**这是指定一致性,不是新数学断言**。

**第 4 步 — 坍缩定理**(本轮主交付,名字固定):

```lean
-- (1) 只用源侧 coherence:
theorem r779_exact_image_of_source_coherence
    [MatsushimaSourceDesignationCoherence A B] :
    sourceInvariantExactImageTarget A B
-- 三场 contract 整体:列出 coherence + 已有字段后还剩什么。
-- 预期:(2) 由 source-H8 思路 + H8_eq_span_h_pow_4 走通或归于 H8↔compactDual 胶水;
-- (3) 经 r779_target_invariants_eq_trivialModulePart + surjectivity_eq +
--     源侧 coherence + H8 线追到 span{j_q h^4}。每一步写成独立定理。
theorem r779_three_field_contract_of_coherences [...] :
    EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B
```

若某一场追不通,照实留 named gap(精确签名),禁止为凑坍缩加强 coherence 字段。

**第 5 步 — 杀伤测试**:R778 countermodel(`ExactImageObstructionSource/Target`)
必须**不满足**每一个新 coherence 类,逐类一条定理
(`r779_countermodel_fails_source_coherence` 等)。任何一个被它满足 = 该
coherence 字段形状错误,停下上报。

**第 6 步 — 诚实重述 frontier**:snapshot 字段必含
`abstractContractCollapsedToCoherences : Bool`、
`remainingFrontierIsInstanceLevel : Bool`、`isClosureClaim (= false)`。
配套 `does_not_*` 定理必含:
`r779_does_not_construct_real_instance`、`r779_does_not_solve_HC`、
`r779_coherence_classes_are_not_new_mathematics_disclosure`。
**严禁**在任何 docstring/commit message 出现"closed/solved"字样;正确表述是
"abstract frontier collapsed to designation coherence; open work moved to
instance level"。

### 顺延与不变项

- 原 R779(Schubert b₈ probe + Betti 截断口径整改)→ **R780**,内容不变;
  注:R778 已确认 `CompactDualData.H8_eq_span_h_pow_4` 是现有字段,故 R780 的
  Schubert 推导定位为"给该字段补计算后盾",优先级降低但保留。
- R781(ConeAudits R777_R781 汇总 + headline guard + 全量审计 + FINAL_GOAL
  轮次记录 + GATE-H3)不变;GATE-H3 的三选一议题更新为:
  (i) instance-level 真实构造路线规划(L1/L2 合流);
  (ii) coherence 字段的 Mathlib 化深挖;
  (iii) 若坍缩不完全:残余 named gap 的逐个攻击排序。
- 轮末固定三件套照旧:单文件 typecheck / `rg native_decide` 证明位 = 0 /
  StatusEntry → post_process → CheckEntry fail = 0。

### Review 将检查

1. 第 1 步定理确实只用现有字段(`#print axioms` 干净,无 coherence 类混入);
2. 清查表与类定义逐字段对得上(我会抽查 `Matsushima.lean` 原文);
3. 杀伤测试全绿;
4. 坍缩定理的前提列表里没有 conjunction shell、没有偷塞强前提;
5. frontier 重述措辞诚实。
