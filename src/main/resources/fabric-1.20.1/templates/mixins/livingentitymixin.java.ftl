<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.enchantment.Enchantment;
import net.minecraft.world.item.enchantment.EnchantmentHelper;

import ${package}.init.${JavaModName}EnchantmentEffects;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import java.util.Map;

@Mixin(LivingEntity.class)
public abstract class ${JavaModName}LivingEntityMixin {

	@Inject(method = "getArmorValue", at = @At("RETURN"), cancellable = true, require = 0)
	private void getArmorValue(CallbackInfoReturnable<Integer> cir) {
		LivingEntity entity = (LivingEntity) (Object) this;
		float bonus = 0;
		for (EquipmentSlot slot : EquipmentSlot.values()) {
			ItemStack stack = entity.getItemBySlot(slot);
			if (stack.isEmpty()) {
				continue;
			}
			for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
				bonus += ${JavaModName}EnchantmentEffects.armorEffectiveness(entry.getKey(), entry.getValue(), slot);
			}
		}
		if (bonus != 0) {
			cir.setReturnValue(cir.getReturnValue() + (int) bonus);
		}
	}
}
<#-- @formatter:on -->
