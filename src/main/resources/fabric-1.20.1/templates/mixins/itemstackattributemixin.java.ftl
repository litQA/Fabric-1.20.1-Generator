<#-- @formatter:off -->
package ${package}.mixins;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.entity.ai.attributes.Attribute;
import net.minecraft.world.entity.ai.attributes.AttributeModifier;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.enchantment.Enchantment;
import net.minecraft.world.item.enchantment.EnchantmentHelper;

import ${package}.init.${JavaModName}EnchantmentEffects;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import java.util.Map;

@Mixin(ItemStack.class)
public abstract class ${JavaModName}ItemStackAttributeMixin {

	@Inject(method = "getAttributeModifiers", at = @At("RETURN"), cancellable = true, require = 0)
	private void getAttributeModifiers(EquipmentSlot slot, CallbackInfoReturnable<Multimap<Attribute, AttributeModifier>> cir) {
		ItemStack stack = (ItemStack) (Object) this;
		Multimap<Attribute, AttributeModifier> result = HashMultimap.create(cir.getReturnValue());
		for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
			for (${JavaModName}EnchantmentEffects.AttributeEffect effect : ${JavaModName}EnchantmentEffects.attributes(entry.getKey(), entry.getValue())) {
				result.put(effect.attribute(), effect.modifier());
			}
		}
		cir.setReturnValue(result);
	}
}
<#-- @formatter:on -->
