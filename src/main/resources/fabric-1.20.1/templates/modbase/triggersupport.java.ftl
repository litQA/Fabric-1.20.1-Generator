<#-- @formatter:off -->
package ${package}.trigger;

import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class ${JavaModName}Triggers {

	public interface ItemSmelted {
		void on(Player player, ItemStack stack);
	}

	public interface SwitchHand {
		void on(LivingEntity entity, ItemStack main, ItemStack off);
	}

	public interface Explosion {
		void on(Level world, double x, double y, double z);
	}

	public static final List<ItemSmelted> ITEM_SMELTED = new CopyOnWriteArrayList<>();
	public static final List<SwitchHand> SWITCH_HAND = new CopyOnWriteArrayList<>();
	public static final List<Explosion> EXPLOSION = new CopyOnWriteArrayList<>();

	public static void fireItemSmelted(Player player, ItemStack stack) {
		for (ItemSmelted listener : ITEM_SMELTED) listener.on(player, stack);
	}

	public static void fireSwitchHand(LivingEntity entity, ItemStack main, ItemStack off) {
		for (SwitchHand listener : SWITCH_HAND) listener.on(entity, main, off);
	}

	public static void fireExplosion(Level world, double x, double y, double z) {
		for (Explosion listener : EXPLOSION) listener.on(world, x, y, z);
	}
}
<#-- @formatter:on -->
