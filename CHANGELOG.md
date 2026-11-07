# [2026.3-4.0.5.26-beta] - 2026-11-07

## New Content
- 2026.3 procedure blocks: entity attack cooldown/reset, force player attack, line of sight, invulnerable time get/set, is moving, item can be hurt by/can repair/is empty/piglin currency, vector dot/cross, and strong redstone power for a block face.
- Custom attack AI task using a procedure with speed, range, interval, and optional can-use/can-continue conditions.
- Block force-redstone-conduction, creative tab title hiding, and void dimension generation.
- Custom Java armor models: client model registration, per-piece texture selection, and a `HumanoidArmorLayer` mixin.

## Changes
- Raytrace water/fall-damage-resetting modes, vector cross product, and armor durability 0 were verified against 1.20.1 APIs.
- P1 fixture generation covers 18 elements and passes `javac` with 43 source files and 42 classes.
- The bettermelon regression workspace passes generation and `javac` with 469 source files and 426 classes.

## Known Limitations
- The custom armor model renderer and mixin still need real-machine client verification.
- The minimal void dimension fixture has no biomes; real dimensions need at least one configured biome.
- Entity/item animations and the enchantment effect engine remain outside P1.

# [2026.3-4.0.4.24-beta] - 2026-11-07

## Changes
- Fluid bucket items now register themselves in every creative tab configured on the fluid element, including custom tabs.

## Fixes
Fixed 1 bug(s).
- Fluid buckets were registered but never added to their configured creative tabs, so they were not visible in the creative inventory.

## Known Limitations
- Custom Java armor models are scheduled for P1.

# [2026.3-4.0.3.21-beta] - 2026-11-07

## Changes
- Custom fluid buckets now use the Fabric `item/generated` model and fall back to the vanilla bucket texture when no bucket texture is provided.
- Advancement item predicates now use the 1.20.1 array form.

## Fixes
Fixed 2 bug(s).
- Fluid bucket models still used the Forge fluid-container model, so the bucket item had no valid Fabric model.
- Advancement item predicates emitted a string instead of an item array and were rejected by the 1.20.1 advancement loader.

## Known Limitations
- Custom Java armor models are not implemented by the 1.20.1 armor generator yet.
- The Forge Config API Port must be enabled in the workspace external APIs page before a `config` element can build.
- Stale `deleted_mod_element` tag entries and Forge attribute warnings originate from the workspace or run environment, not from this generator.

# [2026.3-4.0.0.20-beta] - 2026-11-07

## Changes
- Fence and wall block tags are generated as base templates, so adjacent blocks of the same custom fence or wall connect correctly.
- Generated mixin callbacks no longer print `[MixinProbe]` lines to the game console.
- The headless smoke test now uses an isolated plugin directory, so an installed older build cannot shadow the build under test.

## Fixes
Fixed 7 bug(s).
- Block inventory procedure blocks referenced the removed `customBlockIndex` template variable and failed to generate.
- Bone meal methods used pre-1.20.1 parameter types, so blocks implementing `BonemealableBlock` did not compile.
- The potion registry helper returned `Item` instead of `Potion`.
- Villager trade generation used the 1.21.x nested `tradeEntries` model instead of the 1.20.1 flat `trades` model.
- The `actionresulttype` local variable type had no local scope definition.
- Custom fence and wall blocks were not added to the vanilla `fences` and `walls` tags.
- The generated mixin callbacks spammed the console with probe messages.

# [2026.3-4.0.0.3-beta] - 2026-11-07

## New Content
- The plugin now ships the `datapack-1.20.1` and `forge-1.20.1` base layers under `fabric-1.20.1-base/`, so MCreator 2026.3 does not need to bundle a 1.20.1 generator.

## Changes
- The plugin metadata now targets MCreator 2026.3 EAP build 202600344621 and uses plugin weight 10.
- Element definitions declare their provided base types, and the mod entrypoint uses the 2026.3 `types.base_*` collections.
- The Gradle build uses the local Gradle distribution under `reference_resources/` and persists the build number in `gradle.properties`.

## Fixes
Fixed 2 bug(s).
- The 2026.2 plugin metadata was rejected by the 2026.3 plugin loader.
- The generated registries were empty because 2026.3 no longer provides base types from the element classes.

## Known Limitations
- Entity and item animations are outside this upgrade.
- The 1.20.1 enchantment effect engine, the remaining triggers, and the 2026.3 feature ports are scheduled for the next phases.

# [2026.2-3.0.4-beta] - 2026-11-01

## New Content
- Mixin infrastructure: `mixins.json` is generated for every workspace, `fabric.mod.json` references it, and per-procedure mixin classes are emitted next to their procedure.
- Mixin-based implementations for eight global triggers: player ticks, experience change, experience level change, entity healed, entity fall damage, entity jump, entity item pickup and entity experience drop.
- Mixin-based implementations for six more global triggers: item crafted, entity tamed, entity attack target change, entity struck by lightning, item dropped and item expired.
- Item dropped event now hooks the server-side player override, so dropping an item from the inventory is reported instead of being missed.
- Mixin-based implementations for four block-related triggers: bone meal used, farmland trampled, crop growth attempt and sapling tree growth.
- Mixin-based implementations for thirteen additional global triggers: item use start/stop/finish, item destroyed, equipment change, experience orb pickup, totem use, critical hit, hoe use, multi-place, command execution, advancement completion and fishing catch.
- Equipment change no longer crashes at startup: the mixin targets the concrete `Mob`, `Player` and `ArmorStand` implementations instead of the abstract `LivingEntity` method.
- Worlds no longer fail to load with "Invalid player data": the advancement mixin shadowed a server player field under the wrong type, and the low-level trigger mixins now verify that the player connection is ready before running procedures.
- Item destruction now covers both environmental destruction and durability loss; equipment changes ignore identical re-syncs; critical hits are detected from the attack call instead of the visual-only critical effect.
- Bone meal use is reported only for targets that accept bone meal, and sapling growth is reported once when a tree is actually generated.
- Mixin injection points are guarded with `require = 0`, so a missing target logs a warning instead of aborting game start.

## Fixed
- Mixin configuration was generated but not referenced from `fabric.mod.json` in workspaces without item elements, so no mixin was ever applied and every mixin-based trigger stayed inert.
- The mixin package covered the whole mod package, causing `IllegalClassLoadError` for the mod entrypoint and every generated class; mixin classes now live in a dedicated `mixins` subpackage.
- Trigger procedures emitted no code when bound to events not covered by Fabric API, leaving those events silently inert.

## Known Limitations
- `item_destroyed` is not available on Fabric 1.20.1. Vanilla destroys items through several unrelated paths (durability loss replaces the stack, environmental destruction discards the item entity) and no stable, semantically equivalent hook exists.
- `entity_change_equipment` is not available on Fabric 1.20.1. The vanilla slot write is client/server symmetric and is re-entered by inventory synchronisation, so a single-owner event cannot be produced without altering vanilla behaviour.
- `player_critical_hit` is not available on Fabric 1.20.1. The critical flag is computed inline inside `Player#attack`, and the dedicated `crit` method only plays effects, so the event cannot carry the original damage modifier reliably.
- Thirty-two of the forty global triggers still use stubs; their mixin mappings are scheduled for the next release.
- Crafting remainders for items and tools are not available on Fabric 1.20.1 without an accessor mixin; the item is consumed when crafted.
- Energy, fluid tank and item-level item handler procedure blocks are generated as type-correct no-ops.
- The `fluid` element type is supported, but fluid textures must be supplied by the workspace.
# [2026.2-3.0.3-beta] - 2026-10-31

## New Content
- Fluid element support for Fabric 1.20.1: source and flowing fluids, liquid block, bucket item, fluid render handler, blockstate and model generation, and replaceable block tag.
- Procedure arguments are now passed correctly when one procedure calls another, including custom dependency values declared on the callee.
- Generated procedures now receive additional helper code requested by procedure blocks, such as the command-result collector.

## Fixed
- Crash when opening the creative inventory on worlds that contain blocks without an item form.
- Missing arguments when invoking procedures that declare custom dependencies such as `text`, `start`, `end` or `delay`.
- `java.util.jar.Attributes` being imported instead of `net.minecraft.world.entity.ai.attributes.Attributes` in procedures that read entity attributes.
- Invalid nested enum expression `UseAnim.USEANIM.SPEAR` in generated item classes.
- Block positions being passed where a block state is expected by the block right-click trigger.
- Fluid elements aborting generation with a missing template exception and leaving their blocks and buckets unregistered.

## Known Limitations
- `item_destroyed` is not available on Fabric 1.20.1. Vanilla destroys items through several unrelated paths (durability loss replaces the stack, environmental destruction discards the item entity) and no stable, semantically equivalent hook exists.
- `entity_change_equipment` is not available on Fabric 1.20.1. The vanilla slot write is client/server symmetric and is re-entered by inventory synchronisation, so a single-owner event cannot be produced without altering vanilla behaviour.
- `player_critical_hit` is not available on Fabric 1.20.1. The critical flag is computed inline inside `Player#attack`, and the dedicated `crit` method only plays effects, so the event cannot carry the original damage modifier reliably.
- Crafting remainders for items and tools are not available on Fabric 1.20.1 without an accessor mixin; the item is consumed when crafted.
- Energy, fluid tank and item-level item handler procedure blocks are generated as type-correct no-ops, because Fabric 1.20.1 has no equivalent capability API.
- Forty global triggers remain compilable stubs: Fabric API 0.92.12 exposes no equivalent event and the reference generator fires those through mixins, which are out of scope for this release.

# [2026.2-3.0.2-beta] - 2026-10-31

## New Content
- Generated block-state utility layer (`@JavaModNameUtils`) that resolves block properties from the `BlockState` instance itself, so block-state procedure code no longer depends on `Block#getStateDefinition()`.
- Block editor state properties are now registered on the generated block class, including vanilla properties such as `lit` and custom properties such as `type`.

## Fixed
- Crash on client startup when the dynamic lightLevel procedure accesses an uninitialized StateDefinition.
- Missing block models for blocks utilizing multiple blockstate variants.
- Compilation errors and invalid cancellation logic in the entity attacked trigger for Fabric.
- Blockstate properties declared in the block editor were not registered, leaving their models and collision shapes unreachable at runtime.

## Known Limitations
- `item_destroyed` is not available on Fabric 1.20.1. Vanilla destroys items through several unrelated paths (durability loss replaces the stack, environmental destruction discards the item entity) and no stable, semantically equivalent hook exists.
- `entity_change_equipment` is not available on Fabric 1.20.1. The vanilla slot write is client/server symmetric and is re-entered by inventory synchronisation, so a single-owner event cannot be produced without altering vanilla behaviour.
- `player_critical_hit` is not available on Fabric 1.20.1. The critical flag is computed inline inside `Player#attack`, and the dedicated `crit` method only plays effects, so the event cannot carry the original damage modifier reliably.
- Crafting remainders for items and tools are not available on Fabric 1.20.1 without an accessor mixin; the item is consumed when crafted.
- Energy, fluid tank and item-level item handler procedure blocks are generated as type-correct no-ops, because Fabric 1.20.1 has no equivalent capability API.
- Forty global triggers remain compilable stubs: Fabric API 0.92.12 exposes no equivalent event and the reference generator fires those through mixins, which are out of scope for this release.

# [2026.2-3.0.1-beta] - 2026-10-31

## Fixed
- Block luminance: the `.lightLevel(...)` lambda parameter name did not match the dependency name used by MCreator procedure code, producing `cannot find symbol: variable blockstate`.
- Variable storage: `MapVariables.get(...)` and `WorldVariables.get(...)` used the removed `ServerLevelAccessor#level()` accessor, breaking `@JavaModNameVariables` generation.
- Creative tabs: tab constants were derived from the registry name while item, block and tool templates referenced the mod element name, leaving `TAB_*` symbols missing.
- Enchantments: the legacy template referenced fields that no longer exist, aborting generation and leaving the `*Enchantment` classes missing.
- Items and tools: the generated classes emitted `getRecipeRemainder(ItemStack)`, which does not exist in Minecraft 1.20.1, producing `@Override` errors.

## Known Limitations
- `item_destroyed` is not available on Fabric 1.20.1. Vanilla destroys items through several unrelated paths (durability loss replaces the stack, environmental destruction discards the item entity) and no stable, semantically equivalent hook exists.
- `entity_change_equipment` is not available on Fabric 1.20.1. The vanilla slot write is client/server symmetric and is re-entered by inventory synchronisation, so a single-owner event cannot be produced without altering vanilla behaviour.
- `player_critical_hit` is not available on Fabric 1.20.1. The critical flag is computed inline inside `Player#attack`, and the dedicated `crit` method only plays effects, so the event cannot carry the original damage modifier reliably.
- Crafting remainders (items and tools) are not available on Fabric 1.20.1 without an accessor mixin; the item is consumed when crafted.
- Energy, fluid tank and item-level item handler procedure blocks are generated as type-correct no-ops, because Fabric 1.20.1 has no equivalent capability API.
- Forty global triggers remain compilable stubs: Fabric API 0.92.12 exposes no equivalent event and the reference generator fires those through mixins, which are out of scope for this release.
- The `fluid` element type produces no output; it requires a complete Fabric fluid implementation to be supported.
