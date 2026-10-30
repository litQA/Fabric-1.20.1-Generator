<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

<#assign hasWorldVars = w.hasVariablesOfScope("GLOBAL_WORLD")>
<#assign hasMapVars = w.hasVariablesOfScope("GLOBAL_MAP")>
<#assign hasLifetimeVars = w.hasVariablesOfScope("PLAYER_LIFETIME")>
<#assign hasPersistentVars = w.hasVariablesOfScope("PLAYER_PERSISTENT")>
<#assign hasPlayerVars = hasLifetimeVars || hasPersistentVars>

/*
 * Variable storage & sync for Fabric 1.20.1.
 *
 * - GLOBAL_SESSION: static fields on this class
 * - GLOBAL_WORLD / GLOBAL_MAP: SavedData on the dimension data storage, synced to all players
 * - PLAYER_PERSISTENT: SavedData keyed by player UUID (survives relog)
 * - PLAYER_LIFETIME: in-memory map keyed by player UUID (cleared on relog)
 *
 * Networking uses the 1.20.1 Fabric raw-channel API (ServerPlayNetworking / ClientPlayNetworking
 * with FriendlyByteBuf). MCreator regenerates this file on each build.
 */
public class ${JavaModName}Variables {

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_SESSION">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
			</#if>
		</#list>
	</#if>

	<#if hasWorldVars>
	public static final ResourceLocation WORLD_VARIABLES_SYNC = new ResourceLocation(${JavaModName}.MODID, "world_variables_sync");
	</#if>
	<#if hasMapVars>
	public static final ResourceLocation MAP_VARIABLES_SYNC = new ResourceLocation(${JavaModName}.MODID, "map_variables_sync");
	</#if>
	<#if hasPlayerVars>
	public static final ResourceLocation PLAYER_VARIABLES_SYNC = new ResourceLocation(${JavaModName}.MODID, "player_variables_sync");
	</#if>
	<#if hasPersistentVars>
	private static final Map<UUID, PlayerVariables> CLIENT_PERSISTENT = new ConcurrentHashMap<>();
	</#if>
	<#if hasLifetimeVars>
	private static final Map<UUID, PlayerLifetimeVariables> CLIENT_LIFETIME = new ConcurrentHashMap<>();
	private static final Map<UUID, PlayerLifetimeVariables> LIFETIME = new ConcurrentHashMap<>();
	</#if>

	// ---------------------------------------------------------------- network

	/**
	 * Server side: send the current values to players when they join, so clients have a mirror
	 * before any change happens.
	 */
	public static void initNetwork() {
		<#if hasWorldVars || hasMapVars || hasPlayerVars>
		ServerPlayConnectionEvents.JOIN.register((handler, sender, server) -> {
			<#if hasWorldVars>
			syncWorldVariables(handler.player);
			</#if>
			<#if hasMapVars>
			syncMapVariables(handler.player);
			</#if>
			<#if hasPlayerVars>
			syncPlayerVars(handler.player);
			</#if>
		});
		</#if>
	}

	<#if hasWorldVars>
	public static void syncWorldVariables(ServerPlayer player) {
		if (player.getServer() == null)
			return;
		WorldVariables data = WorldVariables.get((ServerLevel) player.level());
		FriendlyByteBuf buffer = new FriendlyByteBuf(Unpooled.buffer());
		buffer.writeNbt(data.save(new CompoundTag()));
		ServerPlayNetworking.send(player, WORLD_VARIABLES_SYNC, buffer);
	}
	</#if>

	<#if hasMapVars>
	public static void syncMapVariables(ServerPlayer player) {
		if (player.getServer() == null)
			return;
		ServerLevel overworld = player.getServer().getLevel(Level.OVERWORLD);
		MapVariables data = MapVariables.get(overworld);
		FriendlyByteBuf buffer = new FriendlyByteBuf(Unpooled.buffer());
		buffer.writeNbt(data.save(new CompoundTag()));
		ServerPlayNetworking.send(player, MAP_VARIABLES_SYNC, buffer);
	}
	</#if>

	<#if hasPlayerVars>
	/** Server side: persist + push the player's variables to that player. */
	public static void syncPlayerVars(Entity entity) {
		if (!(entity instanceof ServerPlayer player))
			return;
		<#if hasPersistentVars>
		PlayerVariablesData.get((ServerLevel) player.level()).setDirty();
		</#if>
		CompoundTag payload = new CompoundTag();
		<#if hasPersistentVars>
		payload.put("persistent", getPlayerVars(player).save(new CompoundTag()));
		</#if>
		<#if hasLifetimeVars>
		payload.put("lifetime", getPlayerLifetimeVars(player).save(new CompoundTag()));
		</#if>
		FriendlyByteBuf buffer = new FriendlyByteBuf(Unpooled.buffer());
		buffer.writeUUID(player.getUUID());
		buffer.writeNbt(payload);
		ServerPlayNetworking.send(player, PLAYER_VARIABLES_SYNC, buffer);
	}

	/** Client side: store the mirrored values received from the server. */
	public static void acceptClientPlayerVars(UUID uuid, CompoundTag payload) {
		<#if hasPersistentVars>
		PlayerVariables persistent = new PlayerVariables();
		if (payload.contains("persistent"))
			persistent.read(payload.getCompound("persistent"));
		CLIENT_PERSISTENT.put(uuid, persistent);
		</#if>
		<#if hasLifetimeVars>
		PlayerLifetimeVariables lifetime = new PlayerLifetimeVariables();
		if (payload.contains("lifetime"))
			lifetime.read(payload.getCompound("lifetime"));
		CLIENT_LIFETIME.put(uuid, lifetime);
		</#if>
	}
	</#if>

	<#if hasWorldVars>
	public static void acceptClientWorldVariables(CompoundTag tag) {
		WorldVariables.clientSide = new WorldVariables();
		WorldVariables.clientSide.read(tag);
	}
	</#if>

	<#if hasMapVars>
	public static void acceptClientMapVariables(CompoundTag tag) {
		MapVariables.clientSide = new MapVariables();
		MapVariables.clientSide.read(tag);
	}
	</#if>

	// ------------------------------------------------------------ world / map

	<#if hasWorldVars>
	public static class WorldVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public static WorldVariables load(CompoundTag tag) {
			WorldVariables data = new WorldVariables();
			data.read(tag);
			return data;
		}

		public void read(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void syncData(LevelAccessor world) {
			this.setDirty();
			if (world instanceof ServerLevel level && level.getServer() != null) {
				CompoundTag tag = this.save(new CompoundTag());
				for (ServerPlayer player : level.getServer().getPlayerList().getPlayers()) {
					FriendlyByteBuf buffer = new FriendlyByteBuf(Unpooled.buffer());
					buffer.writeNbt(tag);
					ServerPlayNetworking.send(player, WORLD_VARIABLES_SYNC, buffer);
				}
			}
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level) {
				return level.getDataStorage().computeIfAbsent(WorldVariables::load, WorldVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}
	</#if>

	<#if hasMapVars>
	public static class MapVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public static MapVariables load(CompoundTag tag) {
			MapVariables data = new MapVariables();
			data.read(tag);
			return data;
		}

		public void read(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void syncData(LevelAccessor world) {
			this.setDirty();
			if (world instanceof ServerLevelAccessor serverLevelAccessor && serverLevelAccessor.getLevel().getServer() != null) {
				ServerLevel overworld = serverLevelAccessor.getLevel().getServer().getLevel(Level.OVERWORLD);
				CompoundTag tag = this.save(new CompoundTag());
				for (ServerPlayer player : overworld.getServer().getPlayerList().getPlayers()) {
					FriendlyByteBuf buffer = new FriendlyByteBuf(Unpooled.buffer());
					buffer.writeNbt(tag);
					ServerPlayNetworking.send(player, MAP_VARIABLES_SYNC, buffer);
				}
			}
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(LevelAccessor world) {
			if (world instanceof ServerLevelAccessor serverLevelAccessor) {
				ServerLevel overworld = serverLevelAccessor.getLevel().getServer().getLevel(Level.OVERWORLD);
				return overworld.getDataStorage().computeIfAbsent(MapVariables::load, MapVariables::new, DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}
	</#if>

	// ---------------------------------------------------------------- player

	<#if hasPersistentVars>
	public static class PlayerVariables {

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		public void read(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

		public CompoundTag save(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			// kept for template compatibility; sync is triggered by syncPlayerVars
		}
	}

	public static class PlayerVariablesData extends SavedData {

		public static final String DATA_NAME = "${modid}_player_vars";

		public final Map<UUID, PlayerVariables> data = new HashMap<>();

		public static PlayerVariablesData load(CompoundTag tag) {
			PlayerVariablesData store = new PlayerVariablesData();
			for (String key : tag.getAllKeys()) {
				PlayerVariables vars = new PlayerVariables();
				vars.read(tag.getCompound(key));
				try {
					store.data.put(UUID.fromString(key), vars);
				} catch (IllegalArgumentException ignored) {
				}
			}
			return store;
		}

		@Override public CompoundTag save(CompoundTag nbt) {
			data.forEach((uuid, vars) -> nbt.put(uuid.toString(), vars.save(new CompoundTag())));
			return nbt;
		}

		public static PlayerVariablesData get(ServerLevel level) {
			ServerLevel overworld = level.getServer().getLevel(Level.OVERWORLD);
			return overworld.getDataStorage().computeIfAbsent(PlayerVariablesData::load, PlayerVariablesData::new, DATA_NAME);
		}
	}

	public static PlayerVariables getPlayerVars(Entity entity) {
		if (!(entity instanceof Player player))
			return new PlayerVariables();
		if (player.level().isClientSide())
			return CLIENT_PERSISTENT.computeIfAbsent(player.getUUID(), uuid -> new PlayerVariables());
		if (!(player instanceof ServerPlayer serverPlayer))
			return new PlayerVariables();
		PlayerVariablesData store = PlayerVariablesData.get((ServerLevel) serverPlayer.level());
		return store.data.computeIfAbsent(player.getUUID(), uuid -> new PlayerVariables());
	}
	</#if>

	<#if hasLifetimeVars>
	public static class PlayerLifetimeVariables {

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			</#if>
		</#list>

		public void read(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				</#if>
			</#list>
		}

		public CompoundTag save(CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			// kept for template compatibility; sync is triggered by syncPlayerVars
		}
	}

	public static PlayerLifetimeVariables getPlayerLifetimeVars(Entity entity) {
		if (!(entity instanceof Player player))
			return new PlayerLifetimeVariables();
		if (player.level().isClientSide())
			return CLIENT_LIFETIME.computeIfAbsent(player.getUUID(), uuid -> new PlayerLifetimeVariables());
		return LIFETIME.computeIfAbsent(player.getUUID(), uuid -> new PlayerLifetimeVariables());
	}
	</#if>
}
<#-- @formatter:on -->
