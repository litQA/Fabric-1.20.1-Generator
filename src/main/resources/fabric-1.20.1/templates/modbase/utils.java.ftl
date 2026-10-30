<#-- @formatter:off -->
package ${package}.network;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.function.Consumer;

/**
 * Fabric 1.20.1 replacements for Forge capability / persistent-data based procedure blocks.
 *
 * - NBT on blocks/entities: stored in a SavedData map (dimension+pos / entity UUID), server side only.
 *   （1.20.1 没有 data attachments，也没有实体级 persistent NBT，因此用 SavedData 持久化，
 *     语义等价于 Forge 的 getPersistentData，但没有 mixin。）
 * - Inventory: vanilla Container interface (MCreator 生成的方块实体实现 Container)；
 * - Energy / fluid tanks: 1.20.1 Fabric 没有对应 capability，相关过程块生成空实现。
 *
 * 该文件由 procedure 定义中的 global_templates 生成，仅在工程含 procedure 元素时出现。
 */
public class ${JavaModName}Utils {

	private static final String NBT_DATA_NAME = "${modid}_nbt_data";

	// ------------------------------------------------------------------ NBT

	public static class NBTStore extends SavedData {

		public final Map<String, CompoundTag> blocks = new HashMap<>();
		public final Map<UUID, CompoundTag> entities = new HashMap<>();

		public static NBTStore load(CompoundTag tag) {
			NBTStore store = new NBTStore();
			CompoundTag blocks = tag.getCompound("blocks");
			for (String key : blocks.getAllKeys())
				store.blocks.put(key, blocks.getCompound(key));
			CompoundTag entities = tag.getCompound("entities");
			for (String key : entities.getAllKeys()) {
				try {
					store.entities.put(UUID.fromString(key), entities.getCompound(key));
				} catch (IllegalArgumentException ignored) {
				}
			}
			return store;
		}

		@Override public CompoundTag save(CompoundTag tag) {
			CompoundTag blocks = new CompoundTag();
			this.blocks.forEach((key, value) -> blocks.put(key, value));
			tag.put("blocks", blocks);
			CompoundTag entities = new CompoundTag();
			this.entities.forEach((key, value) -> entities.put(key.toString(), value));
			tag.put("entities", entities);
			return tag;
		}
	}

	private static NBTStore nbtStore(LevelAccessor world) {
		if (world instanceof ServerLevel level && level.getServer() != null)
			return level.getServer().overworld().getDataStorage().computeIfAbsent(NBTStore::load, NBTStore::new, NBT_DATA_NAME);
		return null;
	}

	private static String blockKey(LevelAccessor world, BlockPos pos) {
		String dimension = world instanceof Level level ? level.dimension().location().toString() : "minecraft:overworld";
		return dimension + "@" + pos.asLong();
	}

	private static CompoundTag blockTag(LevelAccessor world, BlockPos pos) {
		NBTStore store = nbtStore(world);
		if (store == null)
			return new CompoundTag();
		return store.blocks.computeIfAbsent(blockKey(world, pos), key -> new CompoundTag());
	}

	private static void storeBlockTag(LevelAccessor world, BlockPos pos, Consumer<CompoundTag> mutator) {
		NBTStore store = nbtStore(world);
		if (store == null)
			return;
		mutator.accept(store.blocks.computeIfAbsent(blockKey(world, pos), key -> new CompoundTag()));
		store.setDirty();
	}

	private static CompoundTag entityTag(Entity entity) {
		NBTStore store = nbtStore(entity.level());
		if (store == null)
			return new CompoundTag();
		return store.entities.computeIfAbsent(entity.getUUID(), key -> new CompoundTag());
	}

	private static void storeEntityTag(Entity entity, Consumer<CompoundTag> mutator) {
		NBTStore store = nbtStore(entity.level());
		if (store == null)
			return;
		mutator.accept(store.entities.computeIfAbsent(entity.getUUID(), key -> new CompoundTag()));
		store.setDirty();
	}

	// block NBT

	public static double getBlockDouble(LevelAccessor world, BlockPos pos, String tag) {
		return blockTag(world, pos).getDouble(tag);
	}

	public static boolean getBlockBoolean(LevelAccessor world, BlockPos pos, String tag) {
		return blockTag(world, pos).getBoolean(tag);
	}

	public static String getBlockString(LevelAccessor world, BlockPos pos, String tag) {
		return blockTag(world, pos).getString(tag);
	}

	public static ItemStack getBlockItemStack(LevelAccessor world, BlockPos pos, String tag) {
		return ItemStack.of(blockTag(world, pos).getCompound(tag));
	}

	public static void setBlockDouble(LevelAccessor world, BlockPos pos, String tag, double value) {
		storeBlockTag(world, pos, nbt -> nbt.putDouble(tag, value));
	}

	public static void setBlockBoolean(LevelAccessor world, BlockPos pos, String tag, boolean value) {
		storeBlockTag(world, pos, nbt -> nbt.putBoolean(tag, value));
	}

	public static void setBlockString(LevelAccessor world, BlockPos pos, String tag, String value) {
		storeBlockTag(world, pos, nbt -> nbt.putString(tag, value));
	}

	public static void setBlockItemStack(LevelAccessor world, BlockPos pos, String tag, ItemStack value) {
		storeBlockTag(world, pos, nbt -> nbt.put(tag, !value.isEmpty() ? value.save(new CompoundTag()) : new CompoundTag()));
	}

	// entity NBT

	public static double getEntityDouble(Entity entity, String tag) {
		return entityTag(entity).getDouble(tag);
	}

	public static boolean getEntityBoolean(Entity entity, String tag) {
		return entityTag(entity).getBoolean(tag);
	}

	public static String getEntityString(Entity entity, String tag) {
		return entityTag(entity).getString(tag);
	}

	public static ItemStack getEntityItemStack(Entity entity, String tag) {
		return ItemStack.of(entityTag(entity).getCompound(tag));
	}

	public static void setEntityDouble(Entity entity, String tag, double value) {
		storeEntityTag(entity, nbt -> nbt.putDouble(tag, value));
	}

	public static void setEntityBoolean(Entity entity, String tag, boolean value) {
		storeEntityTag(entity, nbt -> nbt.putBoolean(tag, value));
	}

	public static void setEntityString(Entity entity, String tag, String value) {
		storeEntityTag(entity, nbt -> nbt.putString(tag, value));
	}

	public static void setEntityItemStack(Entity entity, String tag, ItemStack value) {
		storeEntityTag(entity, nbt -> nbt.put(tag, !value.isEmpty() ? value.save(new CompoundTag()) : new CompoundTag()));
	}

	// -------------------------------------------------------------- inventory

	public static Container blockInventory(LevelAccessor world, BlockPos pos, int slot) {
		if (world.getBlockEntity(pos) instanceof Container container && slot >= 0 && slot < container.getContainerSize())
			return container;
		return null;
	}

	public static ItemStack blockInventoryGet(LevelAccessor world, BlockPos pos, int slot) {
		Container container = blockInventory(world, pos, slot);
		return container != null ? container.getItem(slot) : ItemStack.EMPTY;
	}

	public static int blockInventorySlotCount(LevelAccessor world, BlockPos pos) {
		return world.getBlockEntity(pos) instanceof Container container ? container.getContainerSize() : 0;
	}

	public static int blockInventorySlotLimit(LevelAccessor world, BlockPos pos, int slot) {
		Container container = blockInventory(world, pos, slot);
		return container != null ? container.getMaxStackSize() : 0;
	}

	public static boolean blockInventoryCanInsert(LevelAccessor world, BlockPos pos, int slot, ItemStack stack) {
		Container container = blockInventory(world, pos, slot);
		return container != null && container.canPlaceItem(slot, stack);
	}

	public static int blockInventoryInsert(LevelAccessor world, BlockPos pos, int slot, int amount, ItemStack stack, boolean simulate) {
		Container container = blockInventory(world, pos, slot);
		if (container == null || stack.isEmpty())
			return 0;
		int maxStack = Math.min(container.getMaxStackSize(), stack.getMaxStackSize());
		ItemStack existing = container.getItem(slot);
		int inserted = 0;
		if (existing.isEmpty()) {
			inserted = Math.min(Math.min(amount, stack.getCount()), maxStack);
			if (!simulate && inserted > 0) {
				ItemStack copy = stack.copy();
				copy.setCount(inserted);
				container.setItem(slot, copy);
				container.setChanged();
			}
		} else if (ItemStack.isSameItemSameTags(existing, stack)) {
			inserted = Math.min(Math.min(amount, stack.getCount()), maxStack - existing.getCount());
			if (!simulate && inserted > 0) {
				existing.grow(inserted);
				container.setItem(slot, existing);
				container.setChanged();
			}
		}
		return inserted;
	}

	public static ItemStack blockInventoryExtract(LevelAccessor world, BlockPos pos, int slot, int amount, boolean simulate) {
		Container container = blockInventory(world, pos, slot);
		if (container == null)
			return ItemStack.EMPTY;
		ItemStack existing = container.getItem(slot);
		if (existing.isEmpty())
			return ItemStack.EMPTY;
		int extracted = Math.min(amount, existing.getCount());
		ItemStack result = existing.copy();
		result.setCount(extracted);
		if (!simulate && extracted > 0) {
			existing.shrink(extracted);
			container.setItem(slot, existing.isEmpty() ? ItemStack.EMPTY : existing);
			container.setChanged();
		}
		return result;
	}

	public static void blockInventoryDamageItem(LevelAccessor world, BlockPos pos, int slot, int amount) {
		Container container = blockInventory(world, pos, slot);
		if (container == null)
			return;
		ItemStack stack = container.getItem(slot);
		if (stack.isEmpty() || !stack.isDamageableItem())
			return;
		ItemStack copy = stack.copy();
		if (copy.hurt(amount, RandomSource.create(), null)) {
			copy.shrink(1);
			copy.setDamageValue(0);
		}
		container.setItem(slot, copy);
		container.setChanged();
	}

	public static ItemStack itemStackSlot(ItemStack stack, int slot) {
		// 1.20.1 Fabric 没有物品级 item handler（Forge capability），返回空
		return ItemStack.EMPTY;
	}

	public static void setItemStackSlot(ItemStack stack, int slot, ItemStack value) {
		// 1.20.1 Fabric 没有物品级 item handler（Forge capability），空实现
	}

	// ----------------------------------------------------------------- misc

	public static Block randomBlockFromTag(ResourceLocation tag) {
		return BuiltInRegistries.BLOCK.getTag(TagKey.create(Registries.BLOCK, tag))
				.flatMap(set -> set.getRandomElement(RandomSource.create()))
				.map(Holder::value)
				.orElse(Blocks.AIR);
	}

	public static Item randomItemFromTag(ResourceLocation tag) {
		return BuiltInRegistries.ITEM.getTag(TagKey.create(Registries.ITEM, tag))
				.flatMap(set -> set.getRandomElement(RandomSource.create()))
				.map(Holder::value)
				.orElse(Items.AIR);
	}

	public static double entitySubmergedHeight(Entity entity) {
		return entity.getFluidHeight(FluidTags.WATER);
	}
}
<#-- @formatter:on -->
