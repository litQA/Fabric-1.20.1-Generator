<#-- @formatter:off -->
/*
 *	MCreator note: This file will be REGENERATED on each build.
 *
 *	Fabric 1.20.1: attributes are registered directly in BuiltInRegistries.ATTRIBUTE.
 *	把自定义属性挂到原版实体/玩家上需要 mixin 复制 vanilla AttributeSupplier（1.21.8 参考用的是
 *	AttributeSupplierAccessor mixin），本阶段不做，见 MIGRATION-PLAN-V2.md §2 P1-A。
 */

package ${package}.init;

public class ${JavaModName}Attributes {

	<#list attributes as attribute>
	public static final Attribute ${attribute.getModElement().getRegistryNameUpper()} = new RangedAttribute("attribute.${modid}.${attribute.getModElement().getRegistryName()}",
			${attribute.defaultValue}d, ${attribute.minValue}d, ${attribute.maxValue}d).setSyncable(true);
	</#list>

	public static void load() {
		<#list attributes as attribute>
		Registry.register(BuiltInRegistries.ATTRIBUTE, new ResourceLocation(${JavaModName}.MODID, "${attribute.getModElement().getRegistryName()}"),
				${attribute.getModElement().getRegistryNameUpper()});
		</#list>
	}
}
<#-- @formatter:on -->
