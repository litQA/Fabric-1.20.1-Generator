<#include "../triggers.java.ftl">

package ${package}.item;

import net.minecraft.network.chat.Component;

public class ${name}Item extends BucketItem {

	public ${name}Item() {
		super(${JavaModName}Fluids.${REGISTRYNAME}, new Item.Properties().craftRemainder(Items.BUCKET).stacksTo(1)
				<#if data.rarity != "COMMON">.rarity(Rarity.${data.rarity})</#if>);
	}

	<@addSpecialInformation data.specialInformation/>
}
