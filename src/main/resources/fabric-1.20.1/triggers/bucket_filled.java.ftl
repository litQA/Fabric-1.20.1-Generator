<#include "procedures.java.ftl">
public ${name}Procedure() {
	UseItemCallback.EVENT.register((player, world, hand) -> {
		ItemStack stack = player.getItemInHand(hand);
		if (!stack.is(Items.BUCKET))
			return InteractionResultHolder.pass(stack);
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "player.getX()",
				"y": "player.getY()",
				"z": "player.getZ()",
				"world": "world",
				"itemstack": "stack",
				"entity": "player"
			}/>
		</#compress></#assign>
		execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		return InteractionResultHolder.pass(stack);
	});
}
