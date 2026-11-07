<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.server.level.ServerPlayer;
import net.minecraft.server.level.ServerPlayerGameMode;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.InteractionResultHolder;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.Level;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.Redirect;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(ServerPlayerGameMode.class)
public abstract class ${JavaModName}BucketFilledMixin {

	@Unique private final ThreadLocal<ItemStack> ${JavaModName}bucketFilledResult = new ThreadLocal<>();

	@Redirect(method = "useItem", at = @At(value = "INVOKE",
			target = "Lnet/minecraft/world/item/ItemStack;use(Lnet/minecraft/world/level/Level;Lnet/minecraft/world/entity/player/Player;Lnet/minecraft/world/InteractionHand;)Lnet/minecraft/world/InteractionResultHolder;"), require = 0)
	private InteractionResultHolder<ItemStack> redirectUse(ItemStack stack, Level level, Player player, InteractionHand hand) {
		InteractionResultHolder<ItemStack> result = stack.use(level, player, hand);
		if (stack.is(Items.BUCKET) && result != null && result.getResult().consumesAction()
				&& result.getObject() != null && !result.getObject().isEmpty() && !result.getObject().is(Items.BUCKET)) {
			${JavaModName}bucketFilledResult.set(result.getObject().copy());
		}
		return result;
	}

	@Inject(method = "useItem", at = @At("RETURN"), require = 0)
	private void onUseItem(ServerPlayer player, Level level, ItemStack stack, InteractionHand hand,
			CallbackInfoReturnable<InteractionResult> cir) {
		ItemStack result = ${JavaModName}bucketFilledResult.get();
		${JavaModName}bucketFilledResult.remove();
		if (result != null) {
			${JavaModName}Triggers.fireBucketFilled(player, result);
		}
	}
}
<#-- @formatter:on -->
