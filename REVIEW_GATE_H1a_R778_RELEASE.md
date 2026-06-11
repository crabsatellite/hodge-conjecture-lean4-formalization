# REVIEW — GATE-H1a 裁定 + R778 放行指示

Reviewer 独立验证记录,2026-06-11 17:55。对象:commit `7d2bdb9`
"R777 detox native decide proof points"。

## GATE-H1a 裁定:**PASS**(无保留)

独立验证证据(非采信执行者报告,逐项重查):

| 检查项 | 方法 | 结果 |
|---|---|---|
| 证明位 `native_decide` 残留 | `rg "native_decide"` 全仓 .lean | 0 处证明位;剩余 13 处全部是 docstring/注释文本 ✓ |
| 定义体零篡改 | `git show 7d2bdb9` 逐文件 diff 抽查(C7 全量 + V56CohomologyRank + ToroidalDimensions) | 全部为 `native_decide → decide` 战术单点替换,无 def/match 行变更 ✓ |
| Ledger 与报告一致 | 读 `R777_NativeDecideDetoxLedger.lean` | 63 / 10 文件 / HEAVY = [],snapshot 经 `rfl`/`decide` 钉死 ✓ |
| 顺手修复的两个 build blocker | diff 审查 | `v56_e6_branching_restate`(未导入引用→`by omega`,陈述不变)与 `e7_parabolic_dim_table`(坏 `refine {andI ?_ ?_}.1`→显式 anonymous constructor,陈述不变):**合法**,且暴露了这两个文件此前从未被编译验证过的事实 ✓ |
| headline cone 不变 | commit 的 chain-status diff 中 `cuts.md` / `axioms.md` 无变更 | ✓ |
| 越权改动 | commit 文件清单 | 仅 10 detox 文件 + ledger + ConeAudit + MainChain + chain-status 再生 + PLAN 文件,无越权 ✓ |

两点小记(不阻塞,记入 R781 验收):

1. `R777_ConeAudit.lean` 未含 `#print axioms hodgeConjectureReal_canonical`
   headline guard——按 PLAN,guard 在 R781 的 `R777_R781_ConeAudit` 强制补上。
2. 自本轮起,**每轮轮末新增固定检查**:`rg "native_decide" HodgeReduction/ --type lean`
   证明位必须为 0(写进轮末报告)。排毒成果不允许回退。

---

## R778 放行 + 指示细化(在 PLAN R778 原文之上追加,冲突处以本文件为准)

### Reviewer 的结构预判(执行者须先证实或证伪)

读过 `FrontC71` 的定义后,(1) 的成立性分解为两个独立自由度:

```
(1) Submodule.map j_q source_invariants = surjectivity_target
     ↑ 经 (2)+(3) ⟹ source-H8,左边 = Submodule.map j_q H8
```

- 自由度 A:typeclass 栈是否把 `surjectivity_target` 钉到 `target_invariants`?
  (查 `MatsushimaSurjectivityData` 的字段;若有 `surjectivity_target = target_invariants`
  类等式字段,(1) 的右边被 (3) 接管。)
- 自由度 B:栈是否钉 `H8 = span ℚ {h^4}`?(**应该没有**——这正是 R780 要命名的
  Cartan 纸面输入。)若不钉,`map j_q H8` 可严格大于 `span {j_q h^4}` = target line。

**预判:countermodel 存在**,构造要点 = 取 H8 二维(`h^4` 外加一条幽灵线),
j_q 不杀幽灵线,使左边二维 > 右边一维。除非自由度 A 的字段缺失导致更平凡的
countermodel(右边随便挑)。执行者若发现栈里其实有钉死 A 或 B 的字段,
预判作废,按实际字段走证明分支。

### 新增步骤 R778-2.5(必做,把 R778 与 R780 预接线)

countermodel 建成后,**立刻在同文件**做一次前瞻测试:

```lean
-- R780 候选 Cartan 输入(此处仅作局部 hypothesis,不引入 typeclass):
-- hC : CompactDualData.H8 (A := A) = Submodule.span ℚ {(KaehlerClass.h : A)^4}
theorem r778_countermodel_killed_by_cartan_h8_line : <countermodel 不满足 hC> := ...
-- 以及正向:加 hC 后 (1) 是否可证?
theorem r778_exact_image_of_compactDual_targetLine_and_cartanLine
    (hC : ...) (hh : ...) (hline : ...) : sourceInvariantExactImageTarget A B := ...
```

三种结局,全部有价值,照实记录:

| 结局 | 含义 | 后续 |
|---|---|---|
| countermodel 被 hC 杀死 + 正向定理可证 | (1) 的全部缺口 = Cartan 线性输入,三场实质收缩为 (2)+(3)+Cartan | R780 直接以 hC 为第一纸面输入,杀伤测试已预完成 |
| countermodel 被 hC 杀死但正向仍证不动 | (1) 还有 Cartan 之外的缺口(大概率自由度 A) | 缺口签名写进 obstruction,R780 加第二输入(Matsushima deg-8 投影面) |
| countermodel 在 hC 下存活 | hC 太弱,幽灵自由度在别处 | 重大信息:R780 的输入命名必须改形状,停下上报 |

### 验收增补

- snapshot 命名 `R778ExactImageReductionSnapshot`,布尔字段必含
  `exactImageDerivable / countermodelExists / countermodelKilledByCartanLine /
  introducesStrongerPremise(=false) / isClosureClaim(=false)`,`decide` 钉死;
- countermodel 实例必须给出**显式 carrier**(仿 R723/R724 的搭法,scalar/二维
  向量空间级别),不许用 `Classical.choice` 凭空变;
- 轮末三件套:单文件 typecheck + `rg native_decide` 证明位 = 0 + 一句话报告
  (走到三结局表的哪一格)。

### 仍然冻结

Contract 改写轮(FrontC212+ 换拼法)依旧冻结;R779/R780/R781 顺序不变,
R778 的结局只影响 R780 的输入清单,不改变轮次结构。
