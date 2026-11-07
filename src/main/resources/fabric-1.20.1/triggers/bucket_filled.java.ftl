<#include "procedures.java.ftl">
public ${name}Procedure() {
	java.util.Map<Player, InteractionHand> pending = new java.util.concurrent.ConcurrentHashMap<>();
	UseItemCallback.EVENT.register((player, world, hand) -> {
		if (!world.isClientSide && player.getItemInHand(hand).is(Items.BUCKET)) {
			pending.put(player, hand);
		}
		return InteractionResultHolder.pass(player.getItemInHand(hand));
	});
	ServerTickEvents.END_SERVER_TICK.register(server -> {
		pending.forEach((player, hand) -> {
			ItemStack stack = player.getItemInHand(hand);
			if (stack.isEmpty() || stack.is(Items.BUCKET)
					|| !(stack.getItem() instanceof BucketItem || stack.is(Items.MILK_BUCKET))) {
				pending.remove(player);
				return;
			}
			<#assign dependenciesCode><#compress>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()",
					"y": "player.getY()",
					"z": "player.getZ()",
					"world": "player.level()",
					"entity": "player",
					"itemstack": "stack"
				}/>
			</#compress></#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			pending.remove(player);
		});
	});
}
