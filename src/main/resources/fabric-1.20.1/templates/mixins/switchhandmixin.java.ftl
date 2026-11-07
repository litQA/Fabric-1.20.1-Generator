<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.entity.LivingEntity;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(LivingEntity.class)
public abstract class ${JavaModName}SwitchHandMixin {

	@Inject(method = "swapHandItems", at = @At("RETURN"), require = 0)
	private void onSwapHandItems(CallbackInfo ci) {
		LivingEntity entity = (LivingEntity) (Object) this;
		if (!entity.level().isClientSide) {
			${JavaModName}Triggers.fireSwitchHand(entity, entity.getMainHandItem().copy(), entity.getOffhandItem().copy());
		}
	}
}
<#-- @formatter:on -->
