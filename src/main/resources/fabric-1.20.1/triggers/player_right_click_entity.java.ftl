<#include "procedures.java.ftl">
public ${name}Procedure() {
	UseEntityCallback.EVENT.register((player, level, hand, entity, hitResult) -> {
		if (hand != player.getUsedItemHand())
			return InteractionResult.PASS;
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "entity.getX()",
			"y": "entity.getY()",
			"z": "entity.getZ()",
			"world": "level",
			"entity": "entity",
			"sourceentity": "player"
			}/>
		</#compress></#assign>
		execute(${dependenciesCode});
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			return InteractionResult.FAIL;
		return InteractionResult.PASS;
	});
}
