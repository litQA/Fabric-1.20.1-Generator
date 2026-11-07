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

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.minecraft.client.model.HumanoidModel;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;

import java.util.HashMap;
import java.util.Map;

@Environment(EnvType.CLIENT) public class ${JavaModName}ArmorModels {

	public static final Map<Item, ArmorModel> ARMOR_MODELS = new HashMap<>();

	public static void clientLoad() {
		<#list w.getGElementsOfType('armor') as armor>
		${armor.getModElement().getName()}Armor.clientLoad();
		</#list>
	}

	public static HumanoidModel<?> getHumanoidArmorModel(ItemStack stack, EquipmentSlot slot, HumanoidModel<?> defaultModel) {
		ArmorModel model = ARMOR_MODELS.get(stack.getItem());
		return model != null ? model.getHumanoidArmorModel(stack, slot, defaultModel) : defaultModel;
	}

	public static ResourceLocation getArmorTexture(Item item) {
		ArmorModel model = ARMOR_MODELS.get(item);
		return model != null ? model.getArmorTexture() : null;
	}

	public interface ArmorModel {
		default HumanoidModel<?> getHumanoidArmorModel(ItemStack stack, EquipmentSlot slot, HumanoidModel<?> defaultModel) {
			return defaultModel;
		}

		ResourceLocation getArmorTexture();
	}
}
<#-- @formatter:on -->
