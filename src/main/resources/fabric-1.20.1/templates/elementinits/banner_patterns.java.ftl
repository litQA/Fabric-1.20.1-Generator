<#-- @formatter:off -->
/*
 *	MCreator note: This file will be REGENERATED on each build.
 *
 *	Fabric 1.20.1: banner patterns are registered directly in BuiltInRegistries.BANNER_PATTERN.
 */

package ${package}.init;

public class ${JavaModName}BannerPatterns {

	<#list bannerpatterns as bannerpattern>
	public static final BannerPattern ${bannerpattern.getModElement().getRegistryNameUpper()} = new BannerPattern("${modid}:${bannerpattern.getModElement().getRegistryName()}");
	</#list>

	public static void load() {
		<#list bannerpatterns as bannerpattern>
		Registry.register(BuiltInRegistries.BANNER_PATTERN, new ResourceLocation(${JavaModName}.MODID, "${bannerpattern.getModElement().getRegistryName()}"),
				${bannerpattern.getModElement().getRegistryNameUpper()});
		</#list>
	}
}
<#-- @formatter:on -->
