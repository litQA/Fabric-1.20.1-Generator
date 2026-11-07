<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.inventory.FurnaceResultSlot;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(FurnaceResultSlot.class)
public abstract class ${JavaModName}FurnaceResultSlotMixin {

	@Inject(method = "onTake", at = @At("RETURN"), require = 0)
	private void onTake(Player player, ItemStack stack, CallbackInfo ci) {
		${JavaModName}Triggers.fireItemSmelted(player, stack.copy());
	}
}
<#-- @formatter:on -->
