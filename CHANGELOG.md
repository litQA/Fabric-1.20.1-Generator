# [2026.2-3.0.5] - 2026-11-08

## Changed
- Mixin trigger callbacks no longer print diagnostic lines to the console. The debug output was temporary instrumentation and removing it does not change trigger behaviour, cancellation or dependency mapping.

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
