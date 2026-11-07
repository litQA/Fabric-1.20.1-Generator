<#include "procedures.java.ftl">
public ${name}Procedure() {
	${package}.trigger.${JavaModName}Triggers.BUCKET_FILLED.add((player, stack) -> {
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
	});
}
