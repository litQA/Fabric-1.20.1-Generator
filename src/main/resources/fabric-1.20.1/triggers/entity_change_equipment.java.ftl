<#include "procedures.java.ftl">
public ${name}Procedure() {
	ServerEntityEvents.EQUIPMENT_CHANGE.register((entity, slot, previous, current) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"equipmentslot": "slot.getFilterFlag()",
				"olditemstack": "previous",
				"newitemstack": "current"
			}/>
		</#compress></#assign>
		execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
	});
}
