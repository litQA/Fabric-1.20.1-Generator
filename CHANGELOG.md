# [2026.3-4.0.20.59-beta] - 2026-11-07

## Fixes
- Tool harvest level now follows `blockDropsTier` instead of always returning `1` (wood) from the anonymous `Tier`.
  - WOOD/GOLD → 0
  - STONE → 1
  - IRON → 2
  - DIAMOND → 3
  - NETHERITE/other → 4
- This fixes higher-tier tools being treated as wooden by `isCorrectToolForDrops`/required-tool checks.

## Verification
- `UnbreakableTestTool` (NETHERITE) now generates `getLevel()` returning `4`.
- P8 fixture `javac`: 17 source files / 24 classes.

# [2026.3-4.0.19.57-beta] - 2026-11-07

## New Content
- Multipart block states:
  - blockstate JSON now emits `multipart` blocks with per-state `when`/`apply` entries;
  - custom blockstate properties and per-state models are supported;
  - state-specific bounding boxes are emitted when defined.
- Loot modifiers:
  - loot table elements can use `lootTableToModify`;
  - Fabric `LootTableEvents.REPLACE` merges the element's table into the target table;
  - generated `LootTableHelper` merges pools while preserving the target's parameters/functions.
- Raytrace procedure blocks:
  - 1.20.1 `ClipContext.Block.FALLDAMAGE_RESETTING` and `ClipContext.Fluid.WATER` are supported through the existing raytrace templates;
  - added the missing `entity_lookpos` procedure template.
- Strong power emission:
  - `world_data_get_emitted_strong_redstone_power` supports the direction/face input through `Level#getDirectSignal`.
- Armor unbreakable at durability 0:
  - armor with `maxDamage == 0` now overrides `canBeDepleted()` to return false.

## Verification
- P7 fixture with multipart block, loot modifier, raytrace (WATER + FALLDAMAGE_RESETTING), strong power, and unbreakable armor generated successfully.
- Multipart JSON starts with `"multipart": [...]` and uses per-state models.
- `javac`: 30 source files / 0 errors / 46 classes.

## Known Limitations
- Multipart collision is based on configured per-state/default bounding boxes; arbitrary union-of-parts collision is not inferred automatically.
- Loot modifier behavior and armor unbreakability still need real-machine confirmation.

# [2026.3-4.0.18.55-beta] - 2026-11-07

## New Content
- Enchantment `minecraft:armor_effectiveness` now applies through a `LivingEntity#getArmorValue` mixin, with slot filtering from the enchantment's supported slots.
- Removed the old `EnchantmentHelper#getDamageProtection` approximation so armor effectiveness is not counted as protection points.
- Full P4 effect fixture now covers:
  - armor effectiveness;
  - mob and block experience;
  - damage and knockback;
  - attributes;
  - prevention curses;
  - level-based linear/clamped/fraction/squared values.

## Verification
- The full fixture effect JSON parses correctly with all eight effect components.
- `LivingEntityMixin` and `EnchantmentHelperMixin` generate and apply.
- P6 fixture `javac`: 16 source files / 22 classes.

## Known Limitations
- Real-machine behavior of armor effectiveness and experience still needs confirmation.

# [2026.3-4.0.17.53-beta] - 2026-11-07

## Fixes
- Enchantment attribute modifiers are now restricted to the enchantment's configured equipment slots.
  - The generated enchantment exposes a shared `SUPPORTED_SLOTS` array.
  - `EnchantmentEffects` stores the supported slots per enchantment.
  - `ItemStackAttributeMixin` passes the queried `EquipmentSlot` and skips attributes for non-supported slots.
- This stops weapon/armor enchantment attributes from being shown or applied for every equipment slot.

## Verification
- Generated slots:
  - Weapon/Pickaxe → `MAINHAND`
  - Chest enchantment → `CHEST`
  - Foot enchantment → `FEET`
- Attribute lookup now filters by slot.
- P5 fixture `javac`: 17 source files / 23 classes.

## Known Limitations
- The actual tooltip display and equipment behavior still need real-machine confirmation.

# [2026.3-4.0.16.51-beta] - 2026-11-07

## Fixes
- Fixed malformed enchantment attribute effect JSON:
  - the `attribute_effect` template now emits its opening `{`;
  - multiple attribute effects are separated by a trailing comma before `ench_component_attributes` removes the final one.
- Previously this produced invalid JSON for all enchantments with attributes, so `EnchantmentEffects.register` swallowed the parse error and no attribute modifiers were created.
- Enchantment effect JSON parse failures are now logged instead of silently ignored.

## Verification
- Weapon attribute JSON: valid `minecraft:generic.attack_damage`.
- Chest/foot attribute JSON: valid arrays with multiple modifiers.
- P5 fixture: three user enchantments generate with valid effect JSON and `javac` passes (17 source files / 22 classes).

## Known Limitations
- Real in-game attribute values still need confirmation.

# [2026.3-4.0.15.48-beta] - 2026-11-07

## Fixes
- Enchantments now select the correct vanilla `EnchantmentCategory` from their standard `minecraft:enchantable/*` supported-item tag instead of always using `BREAKABLE`.
  - sword/weapon → `WEAPON`
  - chest/foot/head/leg/armor → the matching armor category
  - mining/bow/crossbow/fishing/trident/durability/equippable/vanishing → their categories
- `canEnchant` now accepts both the selected category and the supported-item tag, fixing anvil/table applicability for the affected enchantments.

## Changes
- The three user test enchantments now generate:
  - `TestWeaponEnchant` → `EnchantmentCategory.WEAPON`
  - `TestArmorEnchantChest` → `EnchantmentCategory.ARMOR_CHEST`
  - `TestArmorEnchantFoot` → `EnchantmentCategory.ARMOR_FEET`
- P5 fixture generation passes `javac` with 17 source files and 22 classes.

## Known Limitations
- The real in-game applicability and effect values still need confirmation.

# [2026.3-4.0.14.46-beta] - 2026-11-07

## New Content
- Full 2026.3 enchantment effect JSON generation for 1.20.1, including effect components, value effects, level-based values, lookups, and attribute effects.
- Runtime `EnchantmentEffects` engine with:
  - `minecraft:damage`, `minecraft:knockback`, and `minecraft:armor_effectiveness` hooks.
  - `minecraft:attributes` item attribute modifiers.
  - `minecraft:mob_experience` and `minecraft:block_experience` hooks.
  - `minecraft:prevent_armor_change` and `minecraft:prevent_equipment_drop` curse hooks.
- `EnchantmentHelper` and `ItemStack` attribute mixins.

## Changes
- Enchantment classes now embed their generated effect JSON and register it with the runtime engine.
- The 1.20.1 attribute effect template maps standard datalist keys to the 1.20.1 attribute registry IDs.
- P4 fixture generation passes `javac` with 15 source files and 20 classes.

## Known Limitations
- Effect condition predicates beyond `predicate_true` are not evaluated yet.
- The legacy `damageModifier` field remains separate from the new effect components.
- The full enchantment engine still needs real-machine verification.

# [2026.3-4.0.13.43-beta] - 2026-11-07

## New Content
- `entity_change_equipment` trigger through Fabric `ServerEntityEvents.EQUIPMENT_CHANGE`.
- Item/recipe remainder support through a `CraftingRemainders` registry and `Item` mixin.
  - Item `recipeRemainder` is returned as the crafting remainder.
  - Item/tool `stayInGridWhenCrafting` returns the item itself as the remainder.

## Changes
- Item and tool constructors register their remainder at runtime; the `Item#getCraftingRemainingItem` / `hasCraftingRemainingItem` bridge is provided by a mixin.
- P3 fixture generation covers the equipment trigger, item remainder, and tool remainder; `javac` passes with 18 source files and 23 classes.

## Known Limitations
- `damageOnCrafting` is not applied as durability damage in this batch; the item/tool still stays in the grid when configured.
- Other P3 content is intentionally not developed in this batch.

# [2026.3-4.0.12.41-beta] - 2026-11-07

## Fixes
- `bucket_filled` no longer requires the hand slot to still contain the original empty bucket at RETURN. Some server paths replace the hand before the bucket item's `use` returns, which made that check fail. The mixin now classifies the call solely by the returned `InteractionResultHolder`: successful action, non-empty result stack, and result not an empty bucket.

## Changes
- The filled result stack is passed directly as the `itemstack` dependency.
- P2 fixture re-verified with 18 source files and 19 classes.

## Known Limitations
- The result-only bucket check still needs real-machine confirmation.

# [2026.3-4.0.11.39-beta] - 2026-11-07

## Fixes
- `bucket_filled` now injects directly into `BucketItem#use` / `MilkBucketItem#use` at RETURN and reads the returned `InteractionResultHolder` stack. This avoids both the hand-slot check and the inner `ItemStack.use` redirect, and supplies the actual filled bucket as `itemstack`.

## Changes
- The `ServerPlayerGameMode` bucket mixin and its `@Redirect` were removed; the bucket mixin now targets only the bucket item classes.
- P2 fixture re-verified with 18 source files and 19 classes.

## Known Limitations
- The direct bucket use mixin still needs real-machine confirmation.

# [2026.3-4.0.10.37-beta] - 2026-11-07

## Fixes
- `bucket_filled` now redirects the `ItemStack.use` call inside `ServerPlayerGameMode#useItem`, captures the actual `InteractionResultHolder` result stack, and fires only for a successful empty-bucket fill. This removes the dependence on the player's hand state at RETURN and guarantees that `itemstack` is the filled bucket.

## Changes
- `entity_switch_hand` was confirmed working on the real client through the `PlayerActionMixin` RETURN injection.
- P2 fixture re-verified with 18 source files and 19 classes.

## Known Limitations
- The `bucket_filled` redirect still needs real-machine confirmation.

# [2026.3-4.0.9.35-beta] - 2026-11-07

## Fixes
Fixed 2 bug(s).
- `entity_switch_hand` still did not fire because `handlePlayerAction` returns early for the swap action; the `@At("TAIL")` injection only covered the final return. The player-action mixin now injects at `RETURN` and checks the swap action, so it fires before the early return with the final main/off-hand stacks.
- `bucket_filled` now hooks `ServerPlayerGameMode#useItem` at RETURN, reads the hand after vanilla applied the filled result, and fires only when the original stack was an empty bucket and the result is a `BucketItem` or milk bucket.

## Changes
- The bucket event-delay implementation from `.8.33` was replaced with the server game-mode mixin, so `itemstack` is the actual filled result and there is no one-tick delay.
- Trigger mixins are now Explosion, BucketFilled, FurnaceResultSlot, SwitchHand, and PlayerAction.
- P2 fixture re-verified with 18 source files and 19 classes.

## Known Limitations
- The corrected P2 trigger paths still need real-machine client/server verification.

# [2026.3-4.0.8.33-beta] - 2026-11-07

## Fixes
Fixed 2 bug(s).
- `entity_switch_hand` did not fire for the player hotkey path because the server handles that path in `ServerGamePacketListenerImpl#handlePlayerAction`, not `LivingEntity#swapHandItems`; a player-action mixin now fires after the swap with the final main/off-hand stacks.
- `bucket_filled` did not fire with the filled stack; the bucket mixin was replaced with a server-side `UseItemCallback` plus a next-tick check that fires only when an empty bucket became a filled bucket item.

## Changes
- `entity_switch_hand` still supports the generic `LivingEntity#swapHandItems` path for non-player entities; the player path uses the new `PlayerActionMixin`.
- `bucket_filled` no longer fires for empty-bucket air use or for emptying an already filled bucket.
- Removed the unused bucket mixin; the trigger mixin set is now Explosion, FurnaceResultSlot, SwitchHand, and PlayerAction.
- P2 fixture re-verified with 17 source files and 17 classes.

## Known Limitations
- The corrected P2 trigger paths still need real-machine client/server verification.

# [2026.3-4.0.7.31-beta] - 2026-11-07

## Fixes
Fixed 2 bug(s).
- `entity_switch_hand` supplied the post-swap off-hand item for both dependencies because it hooked `setItemInHand`; it now hooks `LivingEntity#swapHandItems` at RETURN and reads the new main/off-hand after the swap.
- `bucket_filled` fired on every bucket use and supplied the original empty bucket; it now hooks `BucketItem#use` and `MilkBucketItem#use` at RETURN, fires only for a successful empty-bucket fill, and supplies the filled result stack.

## Changes
- `bucket_filled`, `entity_switch_hand`, and `explosion_occurs` now fire server-side only, avoiding duplicate client/server procedure runs.
- P2 fixture re-verified with 17 source files and 18 classes.

## Known Limitations
- The corrected P2 trigger mixins still need real-machine client/server verification.

# [2026.3-4.0.6.29-beta] - 2026-11-07

## New Content
- `bucket_filled` global trigger via Fabric `UseItemCallback`.
- `explosion_occurs` global trigger with an `Explosion` mixin.
- `item_smelted` global trigger with a `FurnaceResultSlot` mixin.
- `entity_switch_hand` global trigger with a `LivingEntity#setItemInHand` mixin.
- A generated trigger registry and three global trigger mixins.

## Changes
- P2 fixture generation covers all four triggers; `javac` passes with 16 source files and 16 classes.
- The trigger mixins are listed in the generated `mixins.json` and have `require = 0` so a missing target does not crash startup.

## Known Limitations
- `bucket_filled` follows the 1.21.x `UseItemCallback` approach and fires on bucket use; exact fill-result semantics still need real-machine confirmation.
- The new trigger mixins and the custom armor mixin need real-machine client/server verification.

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
