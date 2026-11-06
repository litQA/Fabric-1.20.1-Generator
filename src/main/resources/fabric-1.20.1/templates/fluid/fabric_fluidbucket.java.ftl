<#include "../triggers.java.ftl">

package ${package}.item;

import net.minecraft.network.chat.Component;
import net.minecraft.world.item.CreativeModeTabs;

public class ${name}Item extends BucketItem {

	public ${name}Item() {
		super(${JavaModName}Fluids.${REGISTRYNAME}, new Item.Properties().craftRemainder(Items.BUCKET).stacksTo(1)
				<#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>);
		<#list data.creativeTabs as tab>
			<#assign tabValue = tab.getUnmappedValue()>
			<#if tabValue?starts_with("CUSTOM:")>
				<#assign modifiedTabName = tabValue?replace("CUSTOM:", "")?upper_case>
				ItemGroupEvents.modifyEntriesEvent(${JavaModName}Tabs.TAB_${modifiedTabName}).register(content -> content.accept(this));
			<#elseif tabValue == "DECORATIONS">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.NATURAL_BLOCKS).register(content -> content.accept(this));
			<#elseif tabValue == "REDSTONE">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.REDSTONE_BLOCKS).register(content -> content.accept(this));
			<#elseif tabValue == "FOOD">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FOOD_AND_DRINKS).register(content -> content.accept(this));
			<#elseif tabValue == "TOOLS">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.TOOLS_AND_UTILITIES).register(content -> content.accept(this));
			<#elseif tabValue == "MATERIALS">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.INGREDIENTS).register(content -> content.accept(this));
			<#elseif tabValue == "MISC">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.SPAWN_EGGS).register(content -> content.accept(this));
			<#elseif tabValue == "TRANSPORTATION">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.FUNCTIONAL_BLOCKS).register(content -> content.accept(this));
			<#elseif tabValue == "BREWING">
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COLORED_BLOCKS).register(content -> content.accept(this));
			<#else>
				ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.${tabValue}).register(content -> content.accept(this));
			</#if>
		</#list>
	}

	<@addSpecialInformation data.specialInformation/>
}
