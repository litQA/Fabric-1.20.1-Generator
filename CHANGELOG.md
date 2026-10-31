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
- Crafting remainders (items and tools) are not available on Fabric 1.20.1 without an accessor mixin; the item is consumed when crafted.
- Energy, fluid tank and item-level item handler procedure blocks are generated as type-correct no-ops, because Fabric 1.20.1 has no equivalent capability API.
- Forty global triggers remain compilable stubs: Fabric API 0.92.12 exposes no equivalent event and the reference generator fires those through mixins, which are out of scope for this release.
- The `fluid` element type produces no output; it requires a complete Fabric fluid implementation to be supported.
