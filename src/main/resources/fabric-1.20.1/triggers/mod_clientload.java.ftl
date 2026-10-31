public ${name}Procedure() {
	// Fabric 1.20.1: registered on the client only to keep dedicated servers from crashing.
	if (net.fabricmc.loader.api.FabricLoader.getInstance().getEnvironmentType() == net.fabricmc.api.EnvType.CLIENT) {
		ClientLifecycleEvents.CLIENT_STARTED.register((client) -> {
			execute();
		});
	}
}
