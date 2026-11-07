<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.world.item.Item;

import java.util.HashMap;
import java.util.Map;

public class ${JavaModName}CraftingRemainders {

	private static final Map<Item, Item> REMAINDERS = new HashMap<>();

	public static void register(Item item, Item remainder) {
		REMAINDERS.put(item, remainder);
	}

	public static boolean has(Item item) {
		return REMAINDERS.containsKey(item);
	}

	public static Item get(Item item) {
		return REMAINDERS.get(item);
	}
}
<#-- @formatter:on -->
