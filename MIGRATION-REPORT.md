# Fabric 1.20.1 Generator — MCreator 2026.3 迁移报告

- 目标 MCreator：EAP 2026.3.44621（构建号 `202600344621`）
- 当前版本：`2026.3-4.0.10.37-beta`
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

## 2026.3-4.0.4.24-beta 追加修复

- **版本号规则**：上一轮交付的 `.21` 包按规范应为 `2026.3-4.0.3.21-beta`；本轮作为下一轮交付，使用 `2026.3-4.0.4.24-beta`。`tools/build-plugin.ps1 -NewDelivery` 会在新交付时把补丁号 +1，构建号继续递增。
- **自定义流体桶未出现在创造模式物品栏**：
  - 根因：bucket item 已经生成并注册，但 `fabric_fluidbucket.java.ftl` 没有把它加入流体配置的创造模式标签页；`tabMap` 的元素名匹配对 fluid bucket 也不可靠。
  - 修复：模板直接遍历 `data.creativeTabs`，对 `CUSTOM:` 标签页注册 `ItemGroupEvents.modifyEntriesEvent(${JavaModName}Tabs.TAB_...)`，对原版标签页注册对应的 `CreativeModeTabs` 项。
  - 回归：`SampleTab` + `TestFluidTab` fixture 生成 `TestFluidTabItem`，其中包含 `ItemGroupEvents.modifyEntriesEvent(TestmodModTabs.TAB_SAMPLETAB).register(...)`；`javac` 10 源文件 / 0 错误 / 12 class。
- **P1 范围更新**：自定义 Java armor 模型纳入 P1。

## 2026.3-4.0.3.21-beta 追加修复

- **自定义流体桶**：
  - 根因：主生成器没有覆盖 `json/bucket.json.ftl`，1.20.1 的 fluid bucket 继续使用 Forge 的 `forge:fluid_container` / `forge:item/bucket_drip` 模型，Fabric 无法解析。
  - 修复：新增 Fabric 版 `templates/json/bucket.json.ftl`，使用 `item/generated`；有 `textureBucket` 时用指定纹理，留空时回退到 `minecraft:item/bucket`。
  - 回归：新建 2026.3 fluid fixture（`generateBucket=true`、`textureBucket` 为空）生成 `TestFluidItem` 和 `test_fluid_bucket.json`，模型为合法 Fabric `item/generated`。
- **Advancement item predicate**：
  - 根因：`jsontriggers/_mcitem.json.ftl` 输出 `"items": "id"`；1.20.1 需要 `"items": ["id"]`。
  - 修复：改为数组形式。
  - 回归：bettermelon 的 `unsweet_melon_drinks.json` 已输出 `"items": ["qa_better_melon:unripe_melon_drinks"]`；`javac` 458 源文件 / 0 错误 / 405 class。
- **运行时日志评估**：
  - `Couldn't load tag ... deleted_mod_element`：工作区问题。工作区里仍有已删除元素的旧 tag 引用，需要清理对应 tag 或重新生成 tag。
  - `Ignoring unknown attribute 'forge:entity_gravity'` / `forge:step_height_addition`：生成代码中没有这些字符串；属于运行环境/其他 mod 的 Forge 属性注册，不是本生成器输出。
  - `Parsing error loading custom advancement ... Expected items to be a JsonArray`：生成器问题，已在 `.21` 修复。
  - 自定义 Java 模型头盔：**生成器能力缺口**，已在 P1（`2026.3-4.0.5.26-beta`）补上 client 模型注册、纹理选择和 `HumanoidArmorLayer` mixin；真机渲染仍需验证。
- **Forge Config API**：`config` 元素依赖外部 API；MCreator 要求用户在 Workspace Settings 的 External APIs 页面勾选 `forgeconfigapiport`，否则构建失败。这是插件/工作区的使用要求，不是生成器模板错误；已记录到 Known Limitations。

## P1 完成（2026.3-4.0.5.26-beta）

- **13 个 2026.3 procedure block**：`entity_attackcooldown`、`entity_attackcooldown_reset`、`entity_forceplayerattack`、`entity_has_line_of_sight`、`entity_invulnerabletime`、`entity_is_moving`、`entity_set_invulnerabletime`、`item_can_be_hurt_by`、`item_can_repair`、`item_is_empty`、`item_is_piglin_currency`、`vector_dot`、`world_data_get_emitted_strong_redstone_power`。
  - 1.20.1 API 适配：`item_can_be_hurt_by` 使用 `Item.canBeHurtBy`，`item_can_repair` 使用 `Item.isValidRepairItem`，Piglin 货币使用 `ItemTags.PIGLIN_LOVED`。
- **`vector_dual_ops`**：新增 `add` / `subtract` / `multiply` / `cross` 模板，覆盖 2026.3 的 cross product。
- **`attack_with_procedure` AI task**：新增 `aitasks/attack_with_procedure.java.ftl`；fixture 生成的实体 AI 代码可调用 procedure，`javac` 通过。
- **Block / Tab / Dimension**：
  - `forceRedstoneConductor` → `.isRedstoneConductor((bs, br, bp) -> true)`。
  - `hideTitle` → `FabricItemGroup.builder().hideTitle()`。
  - `Void gen` → `dimension_void.json.ftl` + `void_noise_router.json.ftl`。
- **Raytrace / armor durability**：1.20.1 `ClipContext.Block.FALLDAMAGE_RESETTING` 和 `ClipContext.Fluid.WATER` 已生成；`maxDamage=0` 时 `getDurabilityForType` 返回 0，物品不可损坏。
- **自定义 Java armor 模型**：
  - `armor_client.java.ftl` 生成每件 armor 的 `HumanoidModel` 注册；支持 helmet/body/leggings/boots 的自定义模型部件、`textures/entities/...` 自定义纹理，以及 `From armor` 回退。
  - `elementinits/armormodels.java.ftl` 生成 `ARMOR_MODELS` 映射；`client.java.ftl` 调用 clientLoad。
  - `armorlayermixin.java.ftl` 注入 `HumanoidArmorLayer#renderArmorPiece`（模型替换）和 `getArmorLocation`（纹理替换）；已用 `javap` 核对 1.20.1 目标签名。
- **验证**：
  - `p1workspace`：18 个元素生成成功，`javac` 43 源文件 / 0 错误 / 42 class。
  - bettermelon：469 源文件 / 0 错误 / 426 class；`MelonArmorArmor` 已注册 `Modelmelon_rind` 和 `rind_melon_default.png`。
  - 审计：无未豁免 Forge API 残留。

## P2 完成（2026.3-4.0.10.37-beta）

- **`bucket_filled`**：
  - `BucketFilledMixin` 使用 `@Redirect` 拦截 `ServerPlayerGameMode#useItem` 内部的 `ItemStack#use` 调用。
  - 仅当原栈为空桶、返回结果为成功、结果栈是 `BucketItem` 或 `MilkBucketItem` 时，把**结果栈**写入 ThreadLocal；在 `useItem` 的 RETURN 触发 `BUCKET_FILLED`。
  - 空桶右键空气、已装满桶倒出流体不会触发；`itemstack` 是装填后的结果；服务端触发。
- **`explosion_occurs`**：
  - `ExplosionMixin` 注入 `Explosion#explode` 的 HEAD，使用 `@Shadow` 读取 `level/x/y/z` 并触发；服务端触发。
- **`item_smelted`**：
  - `FurnaceResultSlotMixin` 注入 `FurnaceResultSlot#onTake` 的 RETURN，携带 `player` 与结果 `ItemStack`。
- **`entity_switch_hand`**：
  - 真机已确认通过。
  - 玩家路径由 `PlayerActionMixin` 注入 `ServerGamePacketListenerImpl#handlePlayerAction` 的 RETURN，读取交换后的主手/副手。
  - 非玩家实体由 `SwitchHandMixin` 注入 `LivingEntity#swapHandItems` 的 RETURN。
- **注册与生成**：
  - `modbase/triggersupport.java.ftl` 生成 `ITEM_SMELTED` / `BUCKET_FILLED` / `SWITCH_HAND` / `EXPLOSION` listener 列表和 fire 方法。
  - 五个 mixin（Explosion、BucketFilled、FurnaceResultSlot、SwitchHand、PlayerAction）加入 `mixins.json`，使用 `require = 0`。
- **验证**：
  - `p2workspace`：4 个 trigger procedure、`Triggers`、5 个 mixin 生成成功。
  - `javac`：18 源文件 / 0 错误 / 19 class。
  - 生成物包含 `P2BucketFilledProcedure`、`P2ExplosionOccursProcedure`、`P2ItemSmeltedProcedure`、`P2EntitySwitchHandProcedure`，以及五个 trigger mixin。
- **待真机确认**：
  - `bucket_filled` 的实际装填结果。

## 已知问题 / 下一阶段

- **旧工作区转换**：`test-workspace/b4e` 的 fluid 元素是旧 schema，2026.3 读取时报 `Field type of mod element DefaultFluid is null`。这不是生成器 YAML 问题，需要新建 2026.3 fluid fixture 或在后续阶段补 converter 兼容验证。
- **动画**：本轮明确不实现实体/物品动画；`animations` 与 synced data 条件后续按用户决定隐藏或排除。
- **附魔引擎**：2026.2/2026.3 的积木式附魔效果是后续重点，计划在 P4 实现 1.20.1 的 Mixin 引擎。
- **其余触发器 / 2026.3 新功能**：按 P3–P5 批次推进，每批 `javac`/生成通过后停止等待真机验证。
- 测试 harness 仍位于工作区 `_verify/`；P3 起逐步把必要的 smoke-test/verify 脚本迁入 `tools/`，重依赖继续使用 MCreator/Gradle 缓存。

## 下一步（P3 / P4）

1. **真机验证 P1/P2**：自定义 armor 渲染/mixin、`attack_with_procedure` AI task、void dimension、13 个新过程块，以及 P2 四个 trigger。
2. **P3**：处理其余 2026.3 功能与工作区转换问题（旧 fluid schema、其他 latent gaps）。
3. **P4**：实现 1.20.1 的积木式附魔效果 Mixin 引擎与 enchantment value/effect modifiers。
4. 动画与 synced data 动画/图层条件仍按用户决定隐藏或排除。
