<#-- @formatter:off -->
package ${package}.mixins;

import com.mojang.blaze3d.vertex.PoseStack;

import net.minecraft.client.model.HumanoidModel;
import net.minecraft.client.renderer.MultiBufferSource;
import net.minecraft.client.renderer.entity.layers.HumanoidArmorLayer;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.item.ArmorItem;
import net.minecraft.world.item.ItemStack;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.ModifyVariable;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(HumanoidArmorLayer.class)
public class ${JavaModName}ArmorLayerMixin {

	@ModifyVariable(method = "renderArmorPiece", at = @At("HEAD"), argsOnly = true, index = 6)
	private HumanoidModel ${JavaModName}ArmorModel(HumanoidModel original, PoseStack poseStack, MultiBufferSource buffer,
			LivingEntity entity, EquipmentSlot slot, int packedLight) {
		ItemStack stack = entity.getItemBySlot(slot);
		return ${package}.init.${JavaModName}ArmorModels.getHumanoidArmorModel(stack, slot, original);
	}

	@Inject(method = "getArmorLocation", at = @At("HEAD"), cancellable = true)
	private void ${JavaModName}ArmorTexture(ArmorItem armorItem, boolean secondLayer, String suffix,
			CallbackInfoReturnable<ResourceLocation> cir) {
		ResourceLocation texture = ${package}.init.${JavaModName}ArmorModels.getArmorTexture(armorItem);
		if (texture != null) {
			cir.setReturnValue(texture);
		}
	}
}
<#-- @formatter:on -->
