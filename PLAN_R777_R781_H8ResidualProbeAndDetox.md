# PLAN R777–R781 — H8 residual: kernel 排毒、两场化简、b₈ probe、纸面输入命名

Status date: 2026-06-11,基于 R776(`FrontC211_H8ResidualCompactDualTargetLineUnifiedSurfaces`)。
Reviewer(战略层)裁定文件。执行者逐字执行;每个 GATE 处停下等 review。
格式对标 `abc-conjecture/lean4-formalization/PLAN_R327_R330_StepCRepair.md`。

## GATE-H1 裁定(binding,先读)

当前 frontier = R776 三义务(kernel 等价于 quotient-vanishing / finite-upper-bound 全部旧拼法):

```
(1) Submodule.map j_q source_invariants = surjectivity_target     [exact image]
(2) h^4 ∈ compactDual                                              [generator membership]
(3) target_invariants = span ℚ {j_q (h^4)}                         [target-line equality]
```

裁定:

- **Contract 改写轮全面冻结。** R641/R669/R671/R775/R776 已把同一 gap 的所有拼法
  连成等价类;R757 已用 R723/R724 countermodel 证明"抽象 carrier 堆叠 + boundary
  data"永远不强迫该 contract。任何 FrontC212+ 的"再换一种 spelling"轮 = 零产出,
  review 直接打回。从本计划起,只允许三类轮:**排毒轮 / 化简-证伪轮 / 输入命名轮**。
- **发现违纪(本计划第一优先)**:HCGapL4 与 Infrastructure 共 17 个 .lean 文件
  ~70 处 `native_decide`(`FrontC7` ×21、`FrontC11` ×13、`FrontC9` ×8、
  `SimpleLieAlgebraClassification` ×5、`FrontC12` ×4 等)。`native_decide` 向 cone
  注入 `Lean.ofReduceBool`/`Lean.trustCompiler`,而这些文件的 docstring 声称
  "All declarations kernel-pure: cone ⊆ {propext, Classical.choice, Quot.sound}"
  —— **声称为假**。R777 必须先排毒,否则 R778+ 的一切 "kernel-checked" 叙述继续失真。
- **发现数学口径问题(R779 处理)**:`FrontC7.e7EVIICompactDualBetti` 断言
  b₀..b₈ = 1,0,1,0,1,0,1,0,1 且 **k ≥ 9 全为 0**。EVII 紧对偶(27 维 Freudenthal 簇
  E₇/P₇)有 |W(E₇)|/|W(E₆)·W(U(1))| = 56 个 Schubert cell,全度 Betti 总和必为 56,
  不是 5;`expected_betti_sum = 61` 只在"截断到 k ≤ 8"的口径下才是诚实陈述。
  现状是隐式截断 + 显式 `| _ => 0`,任何 ≥ 10 度的未来消费者会静默吃到假值。

---

## R777 — Track HA:native_decide 排毒(URGENT;其余一切轮等待)

类比 ABC R327 excision:先恢复声明诚实性,再谈推进。

1. **枚举**:`rg -n "native_decide" HodgeReduction/ --type lean` 取全清单
   (2026-06-11 实测 17 文件,Research/*.md 中的出现不算)。
2. **替换规则**(逐处执行,不许批量盲改):
   - 目标是 `match`-定义的 `Nat`/`Bool` 字面量等式(如
     `shimuraEVIIExpectedBetti 3 = 56`):一律换 `rfl`;`rfl` 不行换 `decide`;
   - `decide` 超时(> 30s)的:**停**,该处登记进 R777 报告的 `HEAVY` 列表,
     保持 native_decide 原样并在该定理 docstring 加
     `NATIVE_DECIDE: cone contains Lean.ofReduceBool — NOT kernel-pure` 标注;
   - 禁止为了过 `decide` 改动任何定义体。
3. **声明修正**:被排毒文件的头 docstring 中所有 "kernel-pure" 声称逐文件复核:
   仍含 native_decide 的文件必须改写为
   "kernel-pure EXCEPT the declarations listed in the NATIVE_DECIDE ledger"。
4. **新文件** `HodgeReduction/HCGapL4/R777_NativeDecideDetoxLedger.lean`:
   - `def R777_detoxedDeclCount : Nat := <实数>`;
   - `def R777_heavyResidualDecls : List String := [...]`(期望为空表;非空必须上报);
   - 对 ≥ 10 条代表性排毒后定理逐条 `#print axioms`(进 ConeAudits,见 R781)。
5. 跑 `lake env lean` 单文件验证全部被改文件;**不要全量 build**(增量即可)。

验收(review 检查):`rg "native_decide" HodgeReduction/ --type lean` 输出 =
HEAVY 列表 ∪ 空;抽查 10 条 `#print axioms` 无 `ofReduceBool`/`trustCompiler`;
没有任何定义体被改动(`git diff` 中 def/match 行零变更)。

GATE-H1a:提交 HEAVY 列表(若非空)+ 排毒计数,等 review 放行 R778。

## R778 — Track HB:三场化简或诚实保留(two-field-or-honest-retain)

类比 ABC R316.1 Track G。已有事实:
`h_pow_four_mem_compactDual_of_sourceH8`(source-H8 ⟹ (2))与
`source_invariants_eq_H8_of_h_pow_four_mem_compactDual_targetLineEquality`
((2)+(3) ⟹ source-H8)。问题:**(1) exact image 是否被 (2)+(3)+typeclass 栈蕴含?**

1. **先试证**:新文件 `FrontC212_H8ResidualExactImageFromTargetLine.lean`,
   目标定理(名字固定):

```lean
theorem r778_exact_image_of_compactDual_targetLine
    (hh : (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
            ((KaehlerClass.h : A) ^ 4))
    (hline : MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) :
    sourceInvariantExactImageTarget A B
```

   攻击路径:经 (2)+(3) ⟹ source-H8,再看 `MatsushimaSurjectivityData` 的字段
   (先读 `FrontC71`、`FrontC13` 的 class 定义)是否把
   `surjectivity_target` 钉到 `map j_q source_invariants` 可达的形状。
2. **证不动则证伪**:复用 R723/R724 countermodel 构造技术
   (先读 `FrontC192_H8ResidualCurrentCartanImageGuardrail.lean` 与 R757 文件的
   模型搭法),构造满足 (2)+(3)+全栈但 (1) 为假的 instance,
   定理名 `r778_exact_image_independent_countermodel`。
3. **二者必居其一**,产出对应证书:
   - 化简成功 ⇒ `R778_TwoFieldContract` structure((2)+(3) 两字段)+
     与 R776 三场 contract 的 `Nonempty` 等价定理;
   - 化简失败 ⇒ `def R778_HonestRetain3 : Prop`(非 True;陈述"countermodel 存在")
     + countermodel 实例本体。
4. 禁:把 (1)∧(2)∧(3) 打包成单一 Prop 再声称"一场化"(conjunction shell,
   ChainAudit W5 直接抓)。

验收:新文件单独 typecheck 绿;结论方向与 snapshot 字段一致更新
(仿 `R776CompactDualTargetLineUnifiedSnapshot` 写 `R778…Snapshot` + `decide` 钉死)。

## R779 — Track HC:b₈ kernel probe + Betti 截断口径整改(GATE-H2)

类比 ABC two-power probe:让 kernel 算数裁决,不让 match 自断言裁决。

1. **先读**:`Infrastructure/PoincarePolynomialEVII.lean`、
   `Infrastructure/Shimura/SchubertCells.lean`、`Infrastructure/CoxeterDegrees.lean`
   ——确认项目内是否已有从 W(E₇)/W(E₆×U(1)) 最短陪集代表长度分布
   推 Poincaré 系数的素材。
2. **主目标**(新文件 `FrontC213_H8ResidualCompactDualBettiFromSchubert.lean`):
   从 Schubert/Coxeter 素材**推导**(非断言)低度系数:

```lean
theorem r779_compactDual_b8_eq_one_from_schubert : <推导版 b₈> = 1
theorem r779_compactDual_lowDegree_betti_chain :
    <b₀,b₂,b₄,b₆,b₈ 推导版> = (1, 1, 1, 1, 1)
theorem r779_compactDual_total_cells_56 : <全度系数和> = 56
```

   若基础设施不足以推 56-cell 总账,**至少**交付 b₈ = 1 的独立推导
   (длина-4 陪集代表唯一性;E₇ minuscule poset 低层链状)。
   完全推不动 ⇒ 按 graycode 纪律产出 obstruction 文件
   `R779_SchubertBettiObstruction.lean`(列出缺的引理签名)并上报,不许硬塞。
3. **截断口径整改**(同轮必做,与 2 解耦):
   - `FrontC7.e7EVIICompactDualBetti` 改名/包装为显式截断语义:新增
     `def e7EVIICompactDualBettiLowDegree (k : Nat) : Nat`(语义:k ≤ 8 区间的
     Betti;docstring 写明 k ≥ 9 的真值是 56-cell 分布,本函数不承诺),
     旧名保留为 `abbrev` + DEPRECATED docstring,禁止新消费者;
   - `FrontC11.expected_betti_sum`(61 口径)docstring 补"截断 ≤ 8"限定;
   - grep 检查现存消费者是否有人在 k ≥ 9 处消费 `| _ => 0` 假值
     (`rg "e7EVIICompactDualBetti" --type lean` 逐处看 index),有则登记修复。

GATE-H2(硬停):报告 b₈ 的最终依据(Schubert 推导 ✓ / 仍是自断言 ✗)+
截断消费者扫描结果。b₈ ≠ 1 被推出来的情形(极低概率)= 重大负结果:
(3) 的 target-line 拼法在 expected 模型上即假,frontier 必须重拼——立即停全部轮等裁定。

## R780 — Track HD:纸面输入命名 + countermodel 杀伤测试

类比 ABC "named paper input must kill the probe"。前提:R778 已裁定场数,
R779 已钉死 b₈。

1. 为每个存活 field 命名**最小纸面输入**,全部非断言(typeclass 字段或 Prop,
   零 axiom),新文件 `FrontC214_H8ResidualPaperInputNaming.lean`:
   - `(2)/(source-H8)` 候选:`CartanInvariantDeg8Data` —— Cartan(1929)/
     Borel:紧型对称空间的不变形式即上同调,H⁸(compact dual) 由 Kähler 类幂
     生成(b₈ = 1 时即一条线)。字段形状:
     `cartan_H8_eq_span_h4 : CompactDualData.H8 (A := A) = Submodule.span ℚ {(KaehlerClass.h : A)^4}`;
   - `(3)` 候选:`MatsushimaDeg8SurjData` —— Matsushima(1962)同构在 deg 8
     的投影面 + `EisensteinVanishingDeg8` 已有面;先检查 (3) 是否已被
     `CartanInvariantDeg8Data` + 现栈推出(写 conditional 定理试一把);
   - `(1)`(若 R778 保留):`BorelStabilityDeg8Data` —— Borel 稳定范围内
     `j_q` 像 = 不变类全体。
2. **杀伤测试(本轮的硬验收)**:每个新输入对 R757 转运的 countermodel 逐一测试,
   定理名 `r780_<输入名>_kills_R757_countermodel`:countermodel **必须无法**满足
   新输入(否则该输入弱到无用 = vacuous,打回重命名)。
3. conditional 闭合链(全 kernel,无断言):
   `r780_contract_of_paper_inputs : <新输入们> → EVIIH8Residual…Contract A B`,
   并经 R756 既有桥回放到 `MatsushimaV56BoundaryData`。

验收:每个新输入 = 一条可引用的纸面定理(作者-年份-定理号进 docstring);
杀伤测试全绿;无 conjunction shell;无新增 axiom。

## R781 — Track HE:可满足性证书 + 全量审计收口(GATE-H3)

1. **模型存在性**:扩展 `FrontC209` 的 scalar carrier(先读其 instance 搭法)
   成同时满足 R780 全部纸面输入的具体 instance,定理
   `r781_paper_inputs_satisfiable`(`Nonempty <bundle>`)。
   这是可满足性证书,**不是**闭合声明——snapshot 的
   `fullHcClosureClaim := false` 照旧。
2. **ConeAudits**:新建 `ConeAudits/R777_R781_ConeAudit.lean`:
   R777 排毒代表定理 ×10、R778/R779/R780/R781 全部 substantive 定理逐条
   `#print axioms`,末尾固定 `#print axioms hodgeConjectureReal_canonical`
   (headline guard,cone 必须仍恰为 4 公理)。
3. **全量审计**:StatusEntry → post_process → CheckEntry,`failures = 0`;
   W5+W6 计数与 R776 基线对比,**净不增**(R777 排毒 + R779 DEPRECATED 整改
   应当净减,做不到要解释)。
4. **账面同步**:`MainChain.lean` 的 `G-hcgap-l4-multifront` summary 追加
   R777–R781 一句话;`FINAL_GOAL.md` 追加 "After R781" 轮次记录
   (3–6 行,只写 decl 名与事实);本 PLAN 文件状态行改 EXECUTED。
5. **GATE-H3(硬停,review 裁定下一程)**:三选一提案,附一句话论据:
   (i) 纸面输入 Mathlib 化深挖(Cartan/Borel 不变量理论的真正形式化);
   (ii) 具体 EVII instance 继续向 `VarietyCohomologyData` 对接(L2 路线合流);
   (iii) 若 R778 出 countermodel 且 R779 出 obstruction:frontier 重拼裁定轮。

---

## 统一纪律(违者返工;graycode 8 条 + Hodge 特有)

1. 禁 `sorry`、禁新 `axiom`、**禁新增 `native_decide`**(R777 之后零容忍)。
2. 绝不 `lake clean`;单文件 `lake env lean` 验证,wave 末才全量审计。
3. 写文件用 Python(UTF-8 无 BOM);PowerShell `Set-Content` 注 BOM 毁 Lean 解析。
4. 状态工具用 `lake env lean --run`,不用 `lake exe`(Windows 符号上限)。
5. 新声明一律带 `r777_`/`R778_` 等轮次前缀;文件名沿用 `FrontC<n>_` 流水号
   (C212 起),先 `git log --oneline -20` 查重避撞号。
6. 新接口先自查非 vacuous:trivial instance 或小例 `decide` 验证
   (R723/R724/R757 三次 countermodel 教训在前)。
7. 每文件骨架照旧:头 docstring(8-item report + Honest disclosure +
   What this round does NOT do)→ substantive → snapshot(`decide` 钉死)→
   非闭合 `does_not_*` 定理(≥5 条,必含 `does_not_solve_HC`)。
8. 卡住 ≥ 2 天:停止硬攻,产出 obstruction 文件 + 上报战略层改道。

## 风险登记与备选

| 风险 | 概率 | 备选 |
|---|---|---|
| R777 出现真 HEAVY(decide 不动的大计算) | 低 | 保留 native_decide + 显式 NATIVE_DECIDE ledger 标注,headline cone 不受影响(这些定理不在 4-公理 cone 内);review 决定是否值得重写计算 |
| R778 既证不出也造不出 countermodel | 中 | 降级:对 scalar carrier 特化版先裁定((1) 在具体模型上真/假),一般情形挂 named open;不算失败轮 |
| R779 Schubert 素材不足 | 中 | obstruction 文件 + b₈ 退守为"截断口径下的工作假设"显式标注;R780 照常(纸面输入命名不依赖推导版 b₈) |
| R780 杀伤测试发现 R757 countermodel 也满足某新输入 | 中 | 该输入升强重写(更接近纸面原文的形状),直到 countermodel 死;两次失败 ⇒ 上报,可能 countermodel 本身揭示纸面输入不充分 = 有价值负结果 |
| R781 scalar instance 无法同时满足全部输入 | 低-中 | 这本身是输入彼此相容性的负信号,按 obstruction 上报;切勿为凑 instance 弱化输入 |

## Review 协议(战略层职责)

每轮交付检查:(1) 单文件 + 增量 build 绿;(2) 陈述级审查——hypothesis 可满足、
结论非平凡、与 FrontC71/C210/C211 签名严格匹配;(3) snapshot 与 decide 证明一致;
(4) `git diff` 抽查无定义体篡改、无 shell;(5) R781 后 diff route-index/cuts/
findings,确认无新 cut、headline cone 不变、W5/W6 净不增;(6) 失败轮的
obstruction 文件必须写明墙在哪里——证伪也是资产。
