<#include "procedures.java.ftl">
public ${name}Procedure() {
	ServerLifecycleEvents.SERVER_STARTED.register((server) -> {
		execute();
	});
}
