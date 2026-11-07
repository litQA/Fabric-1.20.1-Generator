<#-- @formatter:off -->
package net.minecraft.world.level.storage.loot;

public final class ${JavaModName}LootTableHelper {

	private ${JavaModName}LootTableHelper() {
	}

	public static LootTable merge(LootTable target, LootTable modifier) {
		LootPool[] pools = new LootPool[target.pools.length + modifier.pools.length];
		System.arraycopy(target.pools, 0, pools, 0, target.pools.length);
		System.arraycopy(modifier.pools, 0, pools, target.pools.length, modifier.pools.length);
		return new LootTable(target.paramSet, target.randomSequence, pools, target.functions);
	}
}
<#-- @formatter:on -->
