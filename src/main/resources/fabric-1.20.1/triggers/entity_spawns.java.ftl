<#include "procedures.java.ftl">
public ${name}Procedure() {
	ServerEntityEvents.ENTITY_LOAD.register((entity, world) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "world",
				"entity": "entity"
			}/>
		</#compress></#assign>
		execute(${dependenciesCode});
	});
}
