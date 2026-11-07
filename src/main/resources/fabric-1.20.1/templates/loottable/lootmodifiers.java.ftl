<#-- @formatter:off -->
package ${package}.init;

import com.google.gson.JsonParser;

import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.packs.resources.ResourceManager;
import net.minecraft.world.level.storage.loot.LootDataType;
import net.minecraft.world.level.storage.loot.LootTable;
import net.minecraft.world.level.storage.loot.${JavaModName}LootTableHelper;

import net.fabricmc.fabric.api.loot.v2.LootTableEvents;

import java.io.Reader;

public class ${JavaModName}LootModifiers {

	public static void init() {
		LootTableEvents.REPLACE.register((resourceManager, lootManager, id, table, source) -> {
			<#list loottables?filter(e -> e.hasLootModifier()) as lootTable>
			if (id.equals(new ResourceLocation("${lootTable.lootTableToModify}"))) {
				LootTable modifier = loadModifier(resourceManager,
						new ResourceLocation("${lootTable.getResourceLocation()}"));
				if (modifier != null) {
					return ${JavaModName}LootTableHelper.merge(table, modifier);
				}
			}
			</#list>
			return table;
		});
	}

	private static LootTable loadModifier(ResourceManager resourceManager, ResourceLocation id) {
		var resource = resourceManager.getResource(
				new ResourceLocation(id.getNamespace(), "loot_tables/" + id.getPath() + ".json"));
		if (resource.isEmpty()) {
			return null;
		}
		try (Reader reader = resource.get().openAsReader()) {
			return LootDataType.TABLE.deserialize(id, JsonParser.parseReader(reader)).orElse(null);
		} catch (Exception exception) {
			return null;
		}
	}
}
<#-- @formatter:on -->
