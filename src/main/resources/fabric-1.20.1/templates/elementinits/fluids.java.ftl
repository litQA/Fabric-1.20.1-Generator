<#-- @formatter:off -->
/*
 * MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}Fluids {

	<#list fluids as fluid>
	public static FlowingFluid ${fluid.getModElement().getRegistryNameUpper()};
	public static FlowingFluid FLOWING_${fluid.getModElement().getRegistryNameUpper()};
	</#list>

	public static void load() {
		<#list fluids as fluid>
		${fluid.getModElement().getRegistryNameUpper()} = register("${fluid.getModElement().getRegistryName()}", new ${fluid.getModElement().getName()}Fluid.Source());
		FLOWING_${fluid.getModElement().getRegistryNameUpper()} = register("flowing_${fluid.getModElement().getRegistryName()}", new ${fluid.getModElement().getName()}Fluid.Flowing());
		</#list>
	}

	<@javacompress>
	@Environment(EnvType.CLIENT) public static void clientLoad() {
		<#list fluids as fluid>
		${fluid.getModElement().getName()}Fluid.clientLoad();
		</#list>
	}
	</@javacompress>

	private static FlowingFluid register(String name, FlowingFluid fluid) {
		return Registry.register(BuiltInRegistries.FLUID, new ResourceLocation(${JavaModName}.MODID, name), fluid);
	}
}
<#-- @formatter:on -->
