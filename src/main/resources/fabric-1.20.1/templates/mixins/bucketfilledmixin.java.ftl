<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.server.level.ServerPlayer;
import net.minecraft.server.level.ServerPlayerGameMode;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.item.BucketItem;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.Level;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(ServerPlayerGameMode.class)
public abstract class ${JavaModName}BucketFilledMixin {

	@Inject(method = "useItem", at = @At("RETURN"), require = 0)
	private void onUseItem(ServerPlayer player, Level level, ItemStack stack, InteractionHand hand,
			CallbackInfoReturnable<InteractionResult> cir) {
		if (!stack.is(Items.BUCKET)) {
			return;
		}

		ItemStack result = player.getItemInHand(hand);
		if (!result.isEmpty() && !result.is(Items.BUCKET)
				&& (result.getItem() instanceof BucketItem || result.is(Items.MILK_BUCKET))) {
			${JavaModName}Triggers.fireBucketFilled(player, result.copy());
		}
	}
}
<#-- @formatter:on -->
