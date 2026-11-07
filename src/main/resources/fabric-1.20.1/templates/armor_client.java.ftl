<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
 # Copyright (C) 2020-2025, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU Lesser General Public License for more details.
 #
 # You should have received a copy of the GNU Lesser General Public License
 # along with Fabric-Generator-MCreator.  If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->

package ${package}.client.renderer.item;

import net.minecraft.client.Minecraft;
import net.minecraft.client.model.HumanoidModel;
import net.minecraft.client.model.geom.ModelPart;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.item.ItemStack;

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;

import java.util.Collections;
import java.util.Map;

@Environment(EnvType.CLIENT) public class ${name}Armor {

	public static void clientLoad() {
		<#if data.enableHelmet>
		<#assign helmetCustomModel = data.helmetModelName != "Default" && data.getHelmetModel()??>
		<#assign helmetCustomTexture = data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
		<#if helmetCustomModel || helmetCustomTexture>
		${JavaModName}ArmorModels.ARMOR_MODELS.put(${JavaModName}Items.${REGISTRYNAME}_HELMET, new ${JavaModName}ArmorModels.ArmorModel() {
			private final ResourceLocation armorTexture = new ResourceLocation("${modid}", "textures/<#if helmetCustomTexture>entities/${data.helmetModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_1.png</#if>");
			<#if helmetCustomModel>
			private HumanoidModel<?> armorModel;
			@Override public HumanoidModel<?> getHumanoidArmorModel(ItemStack stack, EquipmentSlot slot, HumanoidModel<?> defaultModel) {
				if (armorModel == null) {
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"head", new ${data.helmetModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.helmetModelName}.LAYER_LOCATION)).${data.helmetModelPart},
						"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)));
				}
				return armorModel;
			}
			</#if>
			@Override public ResourceLocation getArmorTexture() {
				return armorTexture;
			}
		});
		</#if>
		</#if>

		<#if data.enableBody>
		<#assign bodyCustomModel = data.bodyModelName != "Default" && data.getBodyModel()??>
		<#assign bodyCustomTexture = data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
		<#if bodyCustomModel || bodyCustomTexture>
		${JavaModName}ArmorModels.ARMOR_MODELS.put(${JavaModName}Items.${REGISTRYNAME}_CHESTPLATE, new ${JavaModName}ArmorModels.ArmorModel() {
			private final ResourceLocation armorTexture = new ResourceLocation("${modid}", "textures/<#if bodyCustomTexture>entities/${data.bodyModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_1.png</#if>");
			<#if bodyCustomModel>
			private HumanoidModel<?> armorModel;
			@Override public HumanoidModel<?> getHumanoidArmorModel(ItemStack stack, EquipmentSlot slot, HumanoidModel<?> defaultModel) {
				if (armorModel == null) {
					${data.bodyModelName} model = new ${data.bodyModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.bodyModelName}.LAYER_LOCATION));
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"body", model.${data.bodyModelPart},
						"left_arm", model.${data.armsModelPartL},
						"right_arm", model.${data.armsModelPartR},
						"head", new ModelPart(Collections.emptyList(), Map.of(
							"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						)),
						"right_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)));
				}
				return armorModel;
			}
			</#if>
			@Override public ResourceLocation getArmorTexture() {
				return armorTexture;
			}
		});
		</#if>
		</#if>

		<#if data.enableLeggings>
		<#assign leggingsCustomModel = data.leggingsModelName != "Default" && data.getLeggingsModel()??>
		<#assign leggingsCustomTexture = data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
		<#if leggingsCustomModel || leggingsCustomTexture>
		${JavaModName}ArmorModels.ARMOR_MODELS.put(${JavaModName}Items.${REGISTRYNAME}_LEGGINGS, new ${JavaModName}ArmorModels.ArmorModel() {
			private final ResourceLocation armorTexture = new ResourceLocation("${modid}", "textures/<#if leggingsCustomTexture>entities/${data.leggingsModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_2.png</#if>");
			<#if leggingsCustomModel>
			private HumanoidModel<?> armorModel;
			@Override public HumanoidModel<?> getHumanoidArmorModel(ItemStack stack, EquipmentSlot slot, HumanoidModel<?> defaultModel) {
				if (armorModel == null) {
					${data.leggingsModelName} model = new ${data.leggingsModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.leggingsModelName}.LAYER_LOCATION));
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"left_leg", model.${data.leggingsModelPartL},
						"right_leg", model.${data.leggingsModelPartR},
						"head", new ModelPart(Collections.emptyList(), Map.of(
							"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						)),
						"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)));
				}
				return armorModel;
			}
			</#if>
			@Override public ResourceLocation getArmorTexture() {
				return armorTexture;
			}
		});
		</#if>
		</#if>

		<#if data.enableBoots>
		<#assign bootsCustomModel = data.bootsModelName != "Default" && data.getBootsModel()??>
		<#assign bootsCustomTexture = data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
		<#if bootsCustomModel || bootsCustomTexture>
		${JavaModName}ArmorModels.ARMOR_MODELS.put(${JavaModName}Items.${REGISTRYNAME}_BOOTS, new ${JavaModName}ArmorModels.ArmorModel() {
			private final ResourceLocation armorTexture = new ResourceLocation("${modid}", "textures/<#if bootsCustomTexture>entities/${data.bootsModelTexture}<#else>models/armor/${data.armorTextureFile}_layer_1.png</#if>");
			<#if bootsCustomModel>
			private HumanoidModel<?> armorModel;
			@Override public HumanoidModel<?> getHumanoidArmorModel(ItemStack stack, EquipmentSlot slot, HumanoidModel<?> defaultModel) {
				if (armorModel == null) {
					${data.bootsModelName} model = new ${data.bootsModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${data.bootsModelName}.LAYER_LOCATION));
					armorModel = new HumanoidModel(new ModelPart(Collections.emptyList(), Map.of(
						"left_leg", model.${data.bootsModelPartL},
						"right_leg", model.${data.bootsModelPartR},
						"head", new ModelPart(Collections.emptyList(), Map.of(
							"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						)),
						"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
						"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap())
					)));
				}
				return armorModel;
			}
			</#if>
			@Override public ResourceLocation getArmorTexture() {
				return armorTexture;
			}
		});
		</#if>
		</#if>
	}
}
<#-- @formatter:on -->
