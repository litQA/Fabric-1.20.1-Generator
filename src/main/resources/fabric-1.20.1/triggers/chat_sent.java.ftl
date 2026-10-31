<#include "procedures.java.ftl">
public ${name}Procedure() {
	ServerMessageEvents.ALLOW_CHAT_MESSAGE.register((message, sender, params) -> {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "sender.getX()",
			"y": "sender.getY()",
			"z": "sender.getZ()",
			"world": "sender.level()",
			"entity": "sender",
			"text": "message.signedContent()"
			}/>
		</#compress></#assign>
		execute(${dependenciesCode});
		return !${package}.network.${JavaModName}Utils.consumeEventCanceled();
	});
}
