<#include "procedures.java.ftl">
public ${name}Procedure() {
	ServerTickEvents.END_SERVER_TICK.register((server) -> {
		for (ServerLevel level : server.getAllLevels()) {
			for (Entity entity : level.getAllEntities()) {
				<#assign dependenciesCode><#compress>
					<@procedureDependenciesCode dependencies, {
						"x": "entity.getX()",
						"y": "entity.getY()",
						"z": "entity.getZ()",
						"world": "level",
						"entity": "entity"
					}/>
				</#compress></#assign>
				execute(${dependenciesCode});
			}
		}
	});
}
