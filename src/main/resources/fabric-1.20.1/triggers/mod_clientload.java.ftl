public ${name}Procedure() {
	// Fabric 1.20.1: 仅在客户端侧注册，避免专用服务器崩溃
	if (net.fabricmc.loader.api.FabricLoader.getInstance().getEnvironmentType() == net.fabricmc.api.EnvType.CLIENT) {
		ClientLifecycleEvents.CLIENT_STARTED.register((client) -> {
			execute();
		});
	}
}
