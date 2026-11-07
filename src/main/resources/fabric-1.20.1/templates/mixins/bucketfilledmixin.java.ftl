<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResultHolder;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.BucketItem;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.item.MilkBucketItem;
import net.minecraft.world.level.Level;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin({ BucketItem.class, MilkBucketItem.class })
public abstract class ${JavaModName}BucketFilledMixin {

	@Unique private final ThreadLocal<ItemStack> ${JavaModName}bucketBeforeUse = new ThreadLocal<>();

	@Inject(method = "use", at = @At("HEAD"))
	private void beforeUse(Level world, Player player, InteractionHand hand,
			CallbackInfoReturnable<InteractionResultHolder<ItemStack>> cir) {
		${JavaModName}bucketBeforeUse.set(player.getItemInHand(hand).copy());
	}

	@Inject(method = "use", at = @At("RETURN"))
	private void afterUse(Level world, Player player, InteractionHand hand,
			CallbackInfoReturnable<InteractionResultHolder<ItemStack>> cir) {
		ItemStack original = ${JavaModName}bucketBeforeUse.get();
		${JavaModName}bucketBeforeUse.remove();

		InteractionResultHolder<ItemStack> result = cir.getReturnValue();
		if (original != null && original.is(Items.BUCKET) && result != null && result.getResult().consumesAction()
				&& result.getObject() != null && !result.getObject().isEmpty() && !result.getObject().is(Items.BUCKET)
				&& !world.isClientSide) {
			${JavaModName}Triggers.fireBucketFilled(player, result.getObject().copy());
		}
	}
}
<#-- @formatter:on -->
