<#--
 # Fabric 1.20.1 enchantment template.
 #
 # The MCreator 2026.2 enchantment data model is used unchanged. Forge-specific
 # APIs (custom EnchantmentCategory factory methods, Forge event hooks for
 # experience drops) do not exist on Fabric 1.20.1, therefore:
 #   * the enchantment category falls back to vanilla EnchantmentCategory.BREAKABLE
 #     and the supported item list is enforced through Enchantment#canEnchant;
 #   * effect components based on Forge events are not emitted.
-->
<#-- @formatter:off -->
<#include "mcitems.ftl">

<#-- filterBrokenReferences returns a Set, so the entries are copied into lists first. -->
<#assign supportedItems = []>
<#list w.filterBrokenReferences(data.supportedItems) as supportedItem>
	<#assign supportedItems = supportedItems + [supportedItem]>
</#list>
<#assign incompatibleEnchantments = []>
<#list w.filterBrokenReferences(data.incompatibleEnchantments) as incompatibleEnchantment>
	<#assign incompatibleEnchantments = incompatibleEnchantments + [incompatibleEnchantment]>
</#list>

<#-- Converts the datalist weight into the vanilla rarity of the enchantment. -->
<#macro weightToRarity weight>
	<#if weight <= 1>VERY_RARE<#elseif weight <= 2>RARE<#elseif weight <= 5>UNCOMMON<#else>COMMON</#if>
</#macro>

<#-- Maps a datalist equipment slot entry to the vanilla EquipmentSlot constants. -->
<#macro equipmentSlots value>
	<#if value == "mainhand">EquipmentSlot.MAINHAND
	<#elseif value == "offhand">EquipmentSlot.OFFHAND
	<#elseif value == "hand">EquipmentSlot.MAINHAND, EquipmentSlot.OFFHAND
	<#elseif value == "feet">EquipmentSlot.FEET
	<#elseif value == "legs">EquipmentSlot.LEGS
	<#elseif value == "chest">EquipmentSlot.CHEST
	<#elseif value == "head">EquipmentSlot.HEAD
	<#elseif value == "armor">EquipmentSlot.HEAD, EquipmentSlot.CHEST, EquipmentSlot.LEGS, EquipmentSlot.FEET
	<#else>EquipmentSlot.MAINHAND
	</#if>
</#macro>

package ${package}.enchantment;

public class ${name}Enchantment extends Enchantment {

	<#if effectcode?has_content>
	private static final String EFFECTS_JSON = """
	{
	${effectcode?remove_ending(",")}
	}
	""";
	<#else>
	private static final String EFFECTS_JSON = "{}";
	</#if>

	public ${name}Enchantment() {
		super(Enchantment.Rarity.<@weightToRarity data.weight/>, EnchantmentCategory.BREAKABLE,
				new EquipmentSlot[]{<@equipmentSlots data.supportedSlots.getUnmappedValue()/>});
		${JavaModName}EnchantmentEffects.register(this, EFFECTS_JSON);
	}

	@Override public boolean canEnchant(ItemStack stack) {
		<#if supportedItems?has_content>
		return ${mappedMCItemsToIngredient(supportedItems)}.test(stack);
		<#else>
		return super.canEnchant(stack);
		</#if>
	}

	@Override public int getMinCost(int level) {
		return 1 + level * 10;
	}

	@Override public int getMaxCost(int level) {
		return 6 + level * 10;
	}

	<#if data.maxLevel != 1>
	@Override public int getMaxLevel() {
		return ${data.maxLevel};
	}
	</#if>

	<#if data.damageModifier != 0>
	@Override public int getDamageProtection(int level, DamageSource source) {
		return level * ${data.damageModifier};
	}
	</#if>

	<#if incompatibleEnchantments?has_content && !incompatibleEnchantments?first?starts_with("#")>
	@Override protected boolean checkCompatibility(Enchantment enchantment) {
		return super.checkCompatibility(enchantment) && !List.of(
			<#list incompatibleEnchantments as incompatibleEnchantment>
				${incompatibleEnchantment}<#sep>,
			</#list>
		).contains(enchantment);
	}
	</#if>

	<#if data.isTreasureEnchantment>
	@Override public boolean isTreasureOnly() {
		return true;
	}
	</#if>

	<#if data.isCurse>
	@Override public boolean isCurse() {
		return true;
	}
	</#if>

	<#if !data.canGenerateInLootTables>
	@Override public boolean isDiscoverable() {
		return false;
	}
	</#if>

	<#if !data.canVillagerTrade>
	@Override public boolean isTradeable() {
		return false;
	}
	</#if>
}
<#-- @formatter:on -->
