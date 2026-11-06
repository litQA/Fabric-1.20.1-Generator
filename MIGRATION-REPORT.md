# Fabric 1.20.1 Generator — MCreator 2026.3 迁移报告

- 目标 MCreator：EAP 2026.3.44621（构建号 `202600344621`）
- 当前版本：`2026.3-4.0.0.20-beta`
- 目标 Minecraft / Fabric：1.20.1 / Fabric Loader 0.20.1 / Fabric API 0.92.12
- 源码目录：`plugin-branch-2026.3/`

## P0：2026.3 基线兼容

### 已完成

1. **内嵌基础层**
   - `src/main/resources/fabric-1.20.1-base/datapack/`：来自 2026.2 的 `datapack-1.20.1`。
   - `src/main/resources/fabric-1.20.1-base/forge/`：来自 2026.2 的 `forge-1.20.1`。
   - 两层的 `generator.yaml` 已删除；ZIP 中只保留主生成器的 `fabric-1.20.1/generator.yaml`。
   - 主 `generator.yaml` 改为：
     ```yaml
     import:
       - fabric-1.20.1-base/datapack
       - fabric-1.20.1-base/forge
     ```
   - 保留 forge base 的 `procedures` / `triggers` 继承，不采用 1.21.8 参考的 `exclude`，因为当前主生成器只覆盖了 451 个 procedure，forge base 仍有约 80 个可达 template。

2. **2026.3 基础类型模型**
   - 为 `block`、`plant`、`fluid`、`item`、`armor`、`tool`、`livingentity`、`feature`、`projectile` 增加 `base_types`。
   - `dimension` 暂不声明 block/item base type：当前 1.20.1 的 portal 字段仍被隐藏，避免生成不存在的 portal 类。
   - `itemextension` 继续使用自身的 `itemextensions.java.ftl`，不引入 `dispensebehavior` base type。
   - `mod.java.ftl` 的 `types["base:*"]??` 改为 `types.base_*?has_content`。

3. **插件元数据与构建**
   - `plugin.json`：`supportedversions: [202600344621, 202600399999]`、`weight: 10`、版本 `2026.3-4.0.0.1-beta`。
   - `gradle.properties`：构建序号持久化；`tools/build-plugin.ps1` 在每次构建后递增（失败也递增）。
   - ZIP 固定为 `generator-fabric-1.20.1.zip`，不携带版本号。
   - `build.gradle` 将 `LICENSE` 打入 ZIP。
   - Gradle wrapper 指向 `reference_resources/gradle-9.8.0-bin.zip`；Gradle 缓存重定向到 `caches/gradle`。

4. **内嵌式检查**
   - ZIP 根：`plugin.json`、`LICENSE`、`fabric-1.20.1/`、`fabric-1.20.1-base/`。
   - 只有一个 `generator.yaml`。
   - 不包含旧的 `datapack-1.20.1/`、`forge-1.20.1/` 路径。

## P0 验证证据

- 构建：`tools/build-plugin.ps1` → `BUILD SUCCESSFUL`，产物 `build/generator-fabric-1.20.1.zip`。
- 2026.3 插件加载：`GenHarness` 输出 `[HARNESS] plugins: 15`，并成功加载 `generator-fabric-1.20.1`。
- `testmod` 工作区（item + block）：
  - `[HARNESS] generateBase OK`
  - 两个元素均 `OK`
  - `javac`：7 个源文件，`exit=0`，7 个 class。
- `all` 工作区（item、block、livingentity、plant、tool、armor、recipe、procedure、tab、achievement、loottable、command、structure、painting、gamerule、potioneffect、particle、keybind、gui）：
  - `[HARNESS] final generateBase OK`
  - `javac`：36 个源文件，`exit=0`，46 个 class。
- Forge 污染审计：继承 265 文件，命中 19（全部白名单），`-FailOnHit` 通过。
- 生成的 `mod.java` 已正确调用 `TestmodModBlocks.load()` / `TestmodModItems.load()` / `TestmodModEntities.load()` / `TestmodModBlockEntities.load()`，说明 `base_types` 迁移生效。

## P0 修复回归（2026.3-4.0.0.20-beta）

用户真机测试暴露了三个工作区问题，本轮修复并回归如下：

- **test-croparium**：`StonecutterFunction` 的 `block_inv_clear_slot` 模板使用已移除的 `customBlockIndex`，导致整个 procedure 不生成，进而出现 3 处 `cannot find symbol`。模板改为 2026.3 的 `${cbi}`。
  - 由于完整工作区依赖 `forge-config-api-port` 的 `config` 元素/API，headless harness 的 `verifyPluginRequirements` 无法在隔离目录中满足该组合；用最小 `block_inv_clear_slot` fixture 验证：`generateElement OK`，`javac` 6 源文件 / 0 错误。
- **test-everrose**：自定义 fence/wall 未加入 `minecraft:fences` / `minecraft:walls` 标签，导致同方块不连接。改为在 `generator.yaml` 的 `base_templates` 生成 `data/minecraft/tags/blocks/fences.json` 与 `walls.json`。
  - 回归：两个标签均生成，包含 `everrose:everrose_fence`、`everrose:cut_everrose_fence`、`everrose:everrose_wall`、`everrose:cut_everrose_wall`。
- **test-bettermelon**：
  - `villagertrades.java.ftl` 使用 1.21.x 的 `trade.tradeEntries` 嵌套模型；1.20.1 模型是扁平的 `trade.trades`，已改写。
  - `actionresulttype` 变量类型缺少 `local` scope，导致 `procedure.java.ftl` 渲染失败；已补 `local` scope。
  - `BonemealableBlock` 方法使用旧类型 `BlockGetter`/`Random`，已改为 `LevelReader`/`RandomSource`。
  - 药水注册 helper 返回 `Item`，已改为 `Potion`。
  - 回归：`generateBase OK` + 全部元素生成成功；`javac` 458 源文件 / 0 错误 / 405 class。
- **MixinProbe**：`procedure_mixin.java.ftl` 中 30 处 `[MixinProbe]` 控制台输出已全部移除；生成的 mixin 中不再出现该字符串。

> **测试隔离教训**：`MCreatorEAP2026344621/plugins/` 中残留的旧 `generator-fabric-1.20.1.zip`（`.3`）会先于 `MCREATOR_PLUGINS_FOLDER` 被加载，导致 harness 实际测试旧插件。`tools/smoke-test.ps1` 已改为在 `caches/smoke/workdir/` 中只放 `mcreator-core`、localization、themes、link、forge-config-api-port 和被测插件，避免旧插件或其他生成器（尤其是 1.21.x 的 `common.*.yaml`）污染测试。

## 已知问题 / 下一阶段

- **旧工作区转换**：`test-workspace/b4e` 的 fluid 元素是旧 schema，2026.3 读取时报 `Field type of mod element DefaultFluid is null`。这不是生成器 YAML 问题，需要新建 2026.3 fluid fixture 或在后续阶段补 converter 兼容验证。
- **动画**：本轮明确不实现实体/物品动画；`animations` 与 synced data 条件后续按用户决定隐藏或排除。
- **附魔引擎**：2026.2/2026.3 的积木式附魔效果是后续重点，计划在 P4 实现 1.20.1 的 Mixin 引擎。
- **其余触发器 / 2026.3 新功能**：按 P1–P5 批次推进，每批 `javac`/生成通过后停止等待真机验证。
- 测试 harness 仍位于工作区 `_verify/`；P1 起逐步把必要的 smoke-test/verify 脚本迁入 `tools/`，重依赖继续使用 MCreator/Gradle 缓存。

## 下一步（P1）

1. 添加 13 个 2026.3 procedure block 模板。
2. 添加 `attack_with_procedure` AI task。
3. 实现 `forceRedstoneConductor`、`hideTitle`、`dimension_void`。
4. 验证 raytrace 新模式、vector cross、armor 耐久 0。
5. 新建 2026.3 fixture，覆盖上述功能并 `javac` 通过。
