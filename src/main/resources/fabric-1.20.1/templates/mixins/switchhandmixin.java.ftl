<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.InteractionHand;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.item.ItemStack;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(LivingEntity.class)
public abstract class ${JavaModName}SwitchHandMixin {

	@Inject(method = "setItemInHand", at = @At("HEAD"), require = 0)
	private void onSetItemInHand(InteractionHand hand, ItemStack stack, CallbackInfo ci) {
		if (hand == InteractionHand.OFF_HAND) {
			LivingEntity entity = (LivingEntity) (Object) this;
			${JavaModName}Triggers.fireSwitchHand(entity, entity.getMainHandItem().copy(), stack.copy());
		}
	}
}
<#-- @formatter:on -->
