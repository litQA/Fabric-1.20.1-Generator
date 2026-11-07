<#-- @formatter:off -->
package ${package}.init;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import net.minecraft.core.BlockPos;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.ai.attributes.Attribute;
import net.minecraft.world.entity.ai.attributes.AttributeModifier;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.enchantment.Enchantment;
import net.minecraft.world.item.enchantment.EnchantmentHelper;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.entity.BlockEntity;
import net.minecraft.world.level.block.state.BlockState;

import net.fabricmc.fabric.api.entity.event.v1.ServerLivingEntityEvents;
import net.fabricmc.fabric.api.event.player.PlayerBlockBreakEvents;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class ${JavaModName}EnchantmentEffects {

	private static final Map<Enchantment, JsonObject> EFFECTS = new HashMap<>();

	public record AttributeEffect(Attribute attribute, AttributeModifier modifier) {
	}

	static {
		ServerLivingEntityEvents.AFTER_DEATH.register((entity, source) -> {
			if (entity.level().isClientSide || !(source.getEntity() instanceof ServerPlayer player)) {
				return;
			}
			ItemStack stack = player.getMainHandItem();
			for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
				double value = list("minecraft:mob_experience", entry.getKey(), entry.getValue());
				if (value != 0) {
					player.giveExperiencePoints((int) value);
				}
			}
		});

		PlayerBlockBreakEvents.AFTER.register((world, player, pos, state, blockEntity) -> {
			if (world.isClientSide || !(player instanceof ServerPlayer serverPlayer)) {
				return;
			}
			ItemStack stack = player.getMainHandItem();
			for (Map.Entry<Enchantment, Integer> entry : EnchantmentHelper.getEnchantments(stack).entrySet()) {
				double value = list("minecraft:block_experience", entry.getKey(), entry.getValue());
				if (value != 0) {
					serverPlayer.giveExperiencePoints((int) value);
				}
			}
		});
	}

	public static void register(Enchantment enchantment, String json) {
		try {
			EFFECTS.put(enchantment, JsonParser.parseString(json).getAsJsonObject());
		} catch (Exception ignored) {
		}
	}

	public static float damage(Enchantment enchantment, int level) {
		return (float) list("minecraft:damage", enchantment, level);
	}

	public static float knockback(Enchantment enchantment, int level) {
		return (float) list("minecraft:knockback", enchantment, level);
	}

	public static float armorEffectiveness(Enchantment enchantment, int level) {
		return (float) list("minecraft:armor_effectiveness", enchantment, level);
	}

	public static boolean hasBinding(Enchantment enchantment) {
		return has("minecraft:prevent_armor_change", enchantment);
	}

	public static boolean hasVanishing(Enchantment enchantment) {
		return has("minecraft:prevent_equipment_drop", enchantment);
	}

	public static List<AttributeEffect> attributes(Enchantment enchantment, int level) {
		List<AttributeEffect> result = new ArrayList<>();
		JsonObject root = EFFECTS.get(enchantment);
		if (root == null || !root.has("minecraft:attributes")) {
			return result;
		}

		for (JsonElement element : root.getAsJsonArray("minecraft:attributes")) {
			JsonObject attributeEntry = element.getAsJsonObject();
			if (!attributeEntry.has("attribute")) {
				continue;
			}

			Attribute attribute = BuiltInRegistries.ATTRIBUTE.get(new ResourceLocation(attributeEntry.get("attribute").getAsString()));
			if (attribute == null) {
				continue;
			}

			double amount = levelValue(attributeEntry.get("amount"), level);
			String operationName = attributeEntry.has("operation") ? attributeEntry.get("operation").getAsString() : "add_value";
			AttributeModifier.Operation operation = switch (operationName) {
				case "add_multiplied_base" -> AttributeModifier.Operation.MULTIPLY_BASE;
				case "add_multiplied_total" -> AttributeModifier.Operation.MULTIPLY_TOTAL;
				default -> AttributeModifier.Operation.ADDITION;
			};

			String id = attributeEntry.has("id") ? attributeEntry.get("id").getAsString() : "${modid}:enchantment." + enchantment.getDescriptionId();
			UUID uuid = UUID.nameUUIDFromBytes(id.getBytes(StandardCharsets.UTF_8));
			result.add(new AttributeEffect(attribute, new AttributeModifier(uuid, id, amount, operation)));
		}
		return result;
	}

	private static boolean has(String key, Enchantment enchantment) {
		JsonObject root = EFFECTS.get(enchantment);
		return root != null && root.has(key);
	}

	private static double list(String key, Enchantment enchantment, int level) {
		JsonObject root = EFFECTS.get(enchantment);
		if (root == null || !root.has(key) || !root.get(key).isJsonArray()) {
			return 0;
		}

		double value = 0;
		for (JsonElement element : root.getAsJsonArray(key)) {
			if (!element.isJsonObject()) {
				continue;
			}
			JsonObject conditional = element.getAsJsonObject();
			if (!requirements(conditional) || !conditional.has("effect") || !conditional.get("effect").isJsonObject()) {
				continue;
			}
			value = valueEffect(conditional.getAsJsonObject("effect"), level, value);
		}
		return value;
	}

	private static boolean requirements(JsonObject conditional) {
		if (!conditional.has("requirements") || !conditional.get("requirements").isJsonObject()) {
			return true;
		}
		JsonObject requirements = conditional.getAsJsonObject("requirements");
		if (!requirements.has("condition")) {
			return true;
		}
		String condition = requirements.get("condition").getAsString();
		return condition.equals("minecraft:predicate_true") || condition.equals("predicate_true");
	}

	private static double valueEffect(JsonObject effect, int level, double current) {
		if (effect == null || !effect.has("type")) {
			return current;
		}

		return switch (effect.get("type").getAsString()) {
			case "minecraft:add" -> current + levelValue(effect.get("value"), level);
			case "minecraft:multiply" -> current * levelValue(effect.get("factor"), level);
			case "minecraft:set" -> levelValue(effect.get("value"), level);
			case "minecraft:all_of" -> {
				double value = current;
				if (effect.has("effects")) {
					for (JsonElement element : effect.getAsJsonArray("effects")) {
						if (element.isJsonObject()) {
							value = valueEffect(element.getAsJsonObject(), level, value);
						}
					}
				}
				yield value;
			}
			default -> current;
		};
	}

	private static double levelValue(JsonElement element, int level) {
		if (element == null || element.isJsonNull()) {
			return 0;
		}
		if (element.isJsonPrimitive()) {
			return element.getAsDouble();
		}
		if (!element.isJsonObject()) {
			return 0;
		}

		JsonObject object = element.getAsJsonObject();
		String type = object.has("type") ? object.get("type").getAsString() : "";
		return switch (type) {
			case "minecraft:linear" -> object.get("base").getAsDouble()
					+ object.get("per_level_above_first").getAsDouble() * (level - 1);
			case "minecraft:clamped" -> Math.max(object.get("min").getAsDouble(),
					Math.min(object.get("max").getAsDouble(), levelValue(object.get("value"), level)));
			case "minecraft:fraction" -> {
				double denominator = levelValue(object.get("denominator"), level);
				yield denominator == 0 ? 0 : levelValue(object.get("numerator"), level) / denominator;
			}
			case "minecraft:levels_squared" -> object.get("added").getAsDouble() + (double) level * level;
			case "minecraft:lookup" -> {
				JsonArray values = object.getAsJsonArray("values");
				if (level >= 1 && level <= values.size()) {
					yield levelValue(values.get(level - 1), level);
				}
				yield object.has("fallback") ? levelValue(object.get("fallback"), level) : 0;
			}
			default -> 0;
		};
	}
}
<#-- @formatter:on -->
