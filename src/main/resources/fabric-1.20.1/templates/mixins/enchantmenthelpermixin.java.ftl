<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.MobType;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.enchantment.Enchantment;
import net.minecraft.world.item.enchantment.EnchantmentHelper;

import ${package}.init.${JavaModName}EnchantmentEffects;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import java.util.Map;

@Mixin(EnchantmentHelper.class)
public abstract class ${JavaModName}EnchantmentHelperMixin {

	@Inject(method = "getDamageBonus", at = @At("RETURN"), cancellable = true, require = 0)
	private static void getDamageBonus(ItemStack stack, MobType type, CallbackInfoReturnable<Float> cir) {
		float bonus = cir.getReturnValueF();
		for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
			bonus += ${JavaModName}EnchantmentEffects.damage(entry.getKey(), entry.getValue());
		}
		cir.setReturnValue(bonus);
	}

	@Inject(method = "getKnockbackBonus", at = @At("RETURN"), cancellable = true, require = 0)
	private static void getKnockbackBonus(LivingEntity entity, CallbackInfoReturnable<Integer> cir) {
		int bonus = cir.getReturnValue();
		ItemStack stack = entity.getMainHandItem();
		for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
			bonus += (int) ${JavaModName}EnchantmentEffects.knockback(entry.getKey(), entry.getValue());
		}
		cir.setReturnValue(bonus);
	}

	@Inject(method = "getDamageProtection", at = @At("RETURN"), cancellable = true, require = 0)
	private static void getDamageProtection(Iterable<ItemStack> stacks, DamageSource source, CallbackInfoReturnable<Integer> cir) {
		int bonus = cir.getReturnValue();
		for (ItemStack stack : stacks) {
			for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
				bonus += (int) ${JavaModName}EnchantmentEffects.armorEffectiveness(entry.getKey(), entry.getValue());
			}
		}
		cir.setReturnValue(bonus);
	}

	@Inject(method = "hasBindingCurse", at = @At("RETURN"), cancellable = true, require = 0)
	private static void hasBindingCurse(ItemStack stack, CallbackInfoReturnable<Boolean> cir) {
		if (cir.getReturnValueZ()) {
			return;
		}
		for (Enchantment enchantment : EnchantmentHelper.getEnchantments(stack).keySet()) {
			if (${JavaModName}EnchantmentEffects.hasBinding(enchantment)) {
				cir.setReturnValue(true);
				return;
			}
		}
	}

	@Inject(method = "hasVanishingCurse", at = @At("RETURN"), cancellable = true, require = 0)
	private static void hasVanishingCurse(ItemStack stack, CallbackInfoReturnable<Boolean> cir) {
		if (cir.getReturnValueZ()) {
			return;
		}
		for (Enchantment enchantment : EnchantmentHelper.getEnchantments(stack).keySet()) {
			if (${JavaModName}EnchantmentEffects.hasVanishing(enchantment)) {
				cir.setReturnValue(true);
				return;
			}
		}
	}
}
<#-- @formatter:on -->
