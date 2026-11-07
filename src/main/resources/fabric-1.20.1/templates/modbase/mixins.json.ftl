<#assign mixins = []>
<#assign clientMixins = []>
<#assign mixins += ["${JavaModName}ExplosionMixin", "${JavaModName}BucketFilledMixin", "${JavaModName}FurnaceResultSlotMixin", "${JavaModName}SwitchHandMixin", "${JavaModName}PlayerActionMixin", "${JavaModName}CraftingRemainderMixin", "${JavaModName}EnchantmentHelperMixin", "${JavaModName}ItemStackAttributeMixin"]>
<#if w.hasElementsOfBaseType("item")>
  <#assign mixins += ["${JavaModName}RepairItemRecipeMixin"]>
</#if>
<#if w.getGElementsOfType('tool')?filter(e -> e.toolType = 'Fishing rod')?size != 0>
  <#assign mixins += ["${JavaModName}FishingHookMixin"]>
  <#assign mixins += ["${JavaModName}FishingHookRendererMixin"]>
  <#assign mixins += ["EntityMixin"]>
</#if>
<#if w.hasElementsOfType("biome")>
  <#assign mixins += ["NoiseGeneratorSettingsAccess"]>
</#if>
<#list w.getGElementsOfType('procedure') as proc>
  <#if proc.procedurexml?contains('<field name="trigger">player_ticks</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_xp_change</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_xp_level_change</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_healed</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_falls</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_jumps</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_item_pickup</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_dropxp</field>') ||
    proc.procedurexml?contains('<field name="trigger">item_crafted</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_tamed</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_sets_attack_target</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_struck_by_lightning</field>') ||
    proc.procedurexml?contains('<field name="trigger">gem_dropped</field>') ||
    proc.procedurexml?contains('<field name="trigger">gem_expired</field>') ||
    proc.procedurexml?contains('<field name="trigger">bonemeal_used</field>') ||
    proc.procedurexml?contains('<field name="trigger">farmland_trampled</field>') ||
    proc.procedurexml?contains('<field name="trigger">crop_attempts_growth</field>') ||
    proc.procedurexml?contains('<field name="trigger">sapling_glow</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_useitem_start</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_useitem_stop</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_useitem_finish</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_pickupxp</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_uses_totem</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_use_hoe</field>') ||
    proc.procedurexml?contains('<field name="trigger">block_multiplace</field>') ||
    proc.procedurexml?contains('<field name="trigger">command_executed</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_completes_advancement</field>') ||
    proc.procedurexml?contains('<field name="trigger">player_fishes_item</field>') ||
    proc.procedurexml?contains('<field name="trigger">entity_blocks</field>')>
    <#assign mixins += [proc.getModElement().getName() + "Mixin"]>
    <#if proc.procedurexml?contains('<field name="trigger">sapling_glow</field>')>
      <#assign mixins += [proc.getModElement().getName() + "MegaMixin"]>
    </#if>
  </#if>
</#list>
<#if w.hasElementsOfType("armor")>
  <#assign clientMixins += ["${JavaModName}ArmorLayerMixin"]>
</#if>
{
  "required": true,
  "minVersion": "0.8",
  "package": "${package}.mixins",
  "compatibilityLevel": "JAVA_17",
  "mixins": [
    <#list mixins as mixin>
      "${mixin}"<#sep>,
    </#list>
  ],
  "client": [
    <#list clientMixins as mixin>
      "${mixin}"<#sep>,
    </#list>
  ],
  "injectors": {
    "defaultRequire": 1
  }
}

