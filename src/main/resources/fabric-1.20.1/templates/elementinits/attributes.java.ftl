<#-- @formatter:off -->
/*
 *	MCreator note: This file will be REGENERATED on each build.
 *
 *	Fabric 1.20.1: attributes are registered directly in BuiltInRegistries.ATTRIBUTE.
 *	Attaching custom attributes to vanilla entities or players requires copying the vanilla
 *	AttributeSupplier through an accessor mixin (as the 1.21.8 reference does); that is out of
 *	scope for this release.
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
