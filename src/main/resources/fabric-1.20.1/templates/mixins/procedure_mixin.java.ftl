<#-- @formatter:off -->
<#assign xml = data.procedurexml>
<#if xml?contains('<field name="trigger">player_ticks</field>')
	|| xml?contains('<field name="trigger">player_xp_change</field>')
	|| xml?contains('<field name="trigger">player_xp_level_change</field>')
	|| xml?contains('<field name="trigger">entity_healed</field>')
	|| xml?contains('<field name="trigger">entity_falls</field>')
	|| xml?contains('<field name="trigger">entity_jumps</field>')
	|| xml?contains('<field name="trigger">entity_item_pickup</field>')
	|| xml?contains('<field name="trigger">entity_dropxp</field>')
	|| xml?contains('<field name="trigger">item_crafted</field>')
	|| xml?contains('<field name="trigger">entity_tamed</field>')
	|| xml?contains('<field name="trigger">entity_sets_attack_target</field>')
	|| xml?contains('<field name="trigger">entity_struck_by_lightning</field>')
	|| xml?contains('<field name="trigger">gem_dropped</field>')
	|| xml?contains('<field name="trigger">gem_expired</field>')
	|| xml?contains('<field name="trigger">bonemeal_used</field>')
	|| xml?contains('<field name="trigger">farmland_trampled</field>')
	|| xml?contains('<field name="trigger">crop_attempts_growth</field>')
	|| xml?contains('<field name="trigger">sapling_glow</field>')
	|| xml?contains('<field name="trigger">player_useitem_start</field>')
	|| xml?contains('<field name="trigger">player_useitem_stop</field>')
	|| xml?contains('<field name="trigger">player_useitem_finish</field>')
	|| xml?contains('<field name="trigger">entity_pickupxp</field>')
	|| xml?contains('<field name="trigger">entity_uses_totem</field>')
	|| xml?contains('<field name="trigger">player_use_hoe</field>')
	|| xml?contains('<field name="trigger">block_multiplace</field>')
	|| xml?contains('<field name="trigger">command_executed</field>')
	|| xml?contains('<field name="trigger">player_completes_advancement</field>')
	|| xml?contains('<field name="trigger">player_fishes_item</field>')
	|| xml?contains('<field name="trigger">entity_blocks</field>')>
package ${package}.mixins;

<#macro mixinArgs>
	<#list dependencies as dep>
		<#assign n = dep.getName()>
		<#if n == "x">self.getX()
		<#elseif n == "y">self.getY()
		<#elseif n == "z">self.getZ()
		<#elseif n == "world">self.level()
		<#elseif n == "entity">self
		<#elseif n == "amount">amount
		<#elseif n == "distance">fallDistance
		<#elseif n == "damagemultiplier">damageMultiplier
		<#elseif n == "itemstack">itemEntity.getItem()
		<#elseif n == "droppedexperience">0
		<#elseif n == "originalexperience">0
		<#elseif n == "sourceentity">self.getLastHurtByMob()
		<#elseif n == "event">null
		<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0
		<#elseif dep.getType(generator.getWorkspace()) == "boolean">false
		<#else>null
		</#if><#if dep?has_next>,</#if>
	</#list>
</#macro>

<#if xml?contains('<field name="trigger">player_ticks</field>')>
@Mixin(Player.class)
abstract class ${name}Mixin {
	@Inject(method = "tick()V", at = @At("TAIL"), require = 0)
	private void onPlayerTick(CallbackInfo ci) {
		Player self = (Player) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_xp_change</field>')>
@Mixin(Player.class)
abstract class ${name}Mixin {
	@Inject(method = "giveExperiencePoints(I)V", at = @At("HEAD"), require = 0)
	private void onXpChange(int amount, CallbackInfo ci) {
		Player self = (Player) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_xp_level_change</field>')>
@Mixin(Player.class)
abstract class ${name}Mixin {
	@Inject(method = "giveExperienceLevels(I)V", at = @At("HEAD"), require = 0)
	private void onXpLevelChange(int amount, CallbackInfo ci) {
		Player self = (Player) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_healed</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "heal(F)V", at = @At("HEAD"), cancellable = true, require = 0)
	private void onEntityHealed(float amount, CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			ci.cancel();
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_falls</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "causeFallDamage(FFLnet/minecraft/world/damagesource/DamageSource;)Z", at = @At("HEAD"), cancellable = true, require = 0)
	private void onEntityFall(float fallDistance, float damageMultiplier, DamageSource source, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(false);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_jumps</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "jumpFromGround()V", at = @At("TAIL"), require = 0)
	private void onEntityJump(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_item_pickup</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "onItemPickup(Lnet/minecraft/world/entity/item/ItemEntity;)V", at = @At("HEAD"), require = 0)
	private void onItemPickup(ItemEntity itemEntity, CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_dropxp</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "dropExperience()V", at = @At("TAIL"), require = 0)
	private void onDropExperience(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		${package}.procedures.${name}Procedure.execute(<@mixinArgs/>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">item_crafted</field>')>
@Mixin(ItemStack.class)
abstract class ${name}Mixin {
	@Inject(method = "onCraftedBy(Lnet/minecraft/world/level/Level;Lnet/minecraft/world/entity/player/Player;I)V", at = @At("TAIL"), require = 0)
	private void onCraftedBy(Level level, Player player, int amount, CallbackInfo ci) {
		if (player == null || level.isClientSide())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">player.getX()<#elseif n == "y">player.getY()<#elseif n == "z">player.getZ()<#elseif n == "world">level<#elseif n == "entity">player<#elseif n == "itemstack">(ItemStack) (Object) this<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_tamed</field>')>
@Mixin(TamableAnimal.class)
abstract class ${name}Mixin {
	@Inject(method = "tame(Lnet/minecraft/world/entity/player/Player;)V", at = @At("TAIL"), require = 0)
	private void onTamed(Player player, CallbackInfo ci) {
		TamableAnimal self = (TamableAnimal) (Object) this;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "sourceentity">player<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_sets_attack_target</field>')>
@Mixin(Mob.class)
abstract class ${name}Mixin {
	@Inject(method = "setTarget(Lnet/minecraft/world/entity/LivingEntity;)V", at = @At("HEAD"), require = 0)
	private void onSetTarget(LivingEntity target, CallbackInfo ci) {
		Mob self = (Mob) (Object) this;
		if (self.level().isClientSide())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">target<#elseif n == "sourceentity">self<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_struck_by_lightning</field>')>
@Mixin(Entity.class)
abstract class ${name}Mixin {
	@Inject(method = "thunderHit(Lnet/minecraft/server/level/ServerLevel;Lnet/minecraft/world/entity/LightningBolt;)V", at = @At("HEAD"), require = 0)
	private void onThunderHit(ServerLevel level, LightningBolt lightning, CallbackInfo ci) {
		Entity self = (Entity) (Object) this;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">gem_dropped</field>')>
@Mixin(ServerPlayer.class)
abstract class ${name}Mixin {
	@Inject(method = "drop(Lnet/minecraft/world/item/ItemStack;ZZ)Lnet/minecraft/world/entity/item/ItemEntity;", at = @At("HEAD"), cancellable = true, require = 0)
	private void onDrop(ItemStack stack, boolean dropAround, boolean traceItem, CallbackInfoReturnable<ItemEntity> cir) {
		ServerPlayer self = (ServerPlayer) (Object) this;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "itemstack">stack<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(null);
	}
}
</#if>

<#if xml?contains('<field name="trigger">gem_expired</field>')>
@Mixin(ItemEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "tick()V", at = @At("HEAD"), require = 0)
	private void onItemTick(CallbackInfo ci) {
		ItemEntity self = (ItemEntity) (Object) this;
		if (self.level().isClientSide() || self.getAge() != 5999)
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "itemstack">self.getItem()<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">bonemeal_used</field>')>
@Mixin(BoneMealItem.class)
abstract class ${name}Mixin {
	@Inject(method = "useOn(Lnet/minecraft/world/item/context/UseOnContext;)Lnet/minecraft/world/InteractionResult;", at = @At("HEAD"), cancellable = true, require = 0)
	private void onBonemealUsed(UseOnContext context, CallbackInfoReturnable<InteractionResult> cir) {
		if (!(context.getLevel() instanceof ServerLevel level))
			return;
		Player player = context.getPlayer();
		if (player == null)
			return;
		BlockPos pos = context.getClickedPos();
		BlockState state = level.getBlockState(pos);
		boolean farmLand = state.is(net.minecraft.world.level.block.Blocks.FARMLAND);
		if (!farmLand && !(state.getBlock() instanceof BonemealableBlock bonemealable && bonemealable.isValidBonemealTarget(level, pos, state, false)))
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "world">level<#elseif n == "entity">player<#elseif n == "itemstack">context.getItemInHand()<#elseif n == "blockstate">state<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(InteractionResult.FAIL);
	}
}
</#if>

<#if xml?contains('<field name="trigger">farmland_trampled</field>')>
@Mixin(FarmBlock.class)
abstract class ${name}Mixin {
	@Inject(method = "fallOn(Lnet/minecraft/world/level/Level;Lnet/minecraft/world/level/block/state/BlockState;Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/entity/Entity;F)V", at = @At("HEAD"), cancellable = true, require = 0)
	private void onFarmlandTrampled(Level level, BlockState state, BlockPos pos, Entity entity, float fallDistance, CallbackInfo ci) {
		if (level.isClientSide())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "world">level<#elseif n == "entity">entity<#elseif n == "blockstate">state<#elseif n == "falldistance">fallDistance<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			ci.cancel();
	}
}
</#if>

<#if xml?contains('<field name="trigger">crop_attempts_growth</field>')>
@Mixin(CropBlock.class)
abstract class ${name}Mixin {
	@Inject(method = "randomTick(Lnet/minecraft/world/level/block/state/BlockState;Lnet/minecraft/server/level/ServerLevel;Lnet/minecraft/core/BlockPos;Lnet/minecraft/util/RandomSource;)V", at = @At("HEAD"), cancellable = true, require = 0)
	private void onCropGrowAttempt(BlockState state, ServerLevel level, BlockPos pos, RandomSource random, CallbackInfo ci) {
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "world">level<#elseif n == "blockstate">state<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			ci.cancel();
	}
}
</#if>

<#if xml?contains('<field name="trigger">sapling_glow</field>')>
@Mixin(AbstractTreeGrower.class)
abstract class ${name}Mixin {
	@Inject(method = "growTree(Lnet/minecraft/server/level/ServerLevel;Lnet/minecraft/world/level/chunk/ChunkGenerator;Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;Lnet/minecraft/util/RandomSource;)Z", at = @At("RETURN"), require = 0)
	private void onGrowTree(ServerLevel level, ChunkGenerator generator, BlockPos pos, BlockState state, RandomSource random, CallbackInfoReturnable<Boolean> cir) {
		if (!Boolean.TRUE.equals(cir.getReturnValue()))
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "world">level<#elseif n == "blockstate">state<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}

@Mixin(AbstractMegaTreeGrower.class)
abstract class ${name}MegaMixin {
	@Inject(method = "growTree(Lnet/minecraft/server/level/ServerLevel;Lnet/minecraft/world/level/chunk/ChunkGenerator;Lnet/minecraft/core/BlockPos;Lnet/minecraft/world/level/block/state/BlockState;Lnet/minecraft/util/RandomSource;)Z", at = @At("RETURN"), require = 0)
	private void onGrowMegaTree(ServerLevel level, ChunkGenerator generator, BlockPos pos, BlockState state, RandomSource random, CallbackInfoReturnable<Boolean> cir) {
		if (!Boolean.TRUE.equals(cir.getReturnValue()))
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "world">level<#elseif n == "blockstate">state<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_useitem_start</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "startUsingItem(Lnet/minecraft/world/InteractionHand;)V", at = @At("HEAD"), cancellable = true, require = 0)
	private void onStartUsingItem(InteractionHand hand, CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide() || self.isUsingItem())
			return;
		if (self instanceof ServerPlayer serverPlayer && (serverPlayer.connection == null || serverPlayer.hasDisconnected()))
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "itemstack">self.getItemInHand(hand)<#elseif n == "duration">self.getUseItemRemainingTicks()<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			ci.cancel();
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_useitem_stop</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "releaseUsingItem()V", at = @At("HEAD"), cancellable = true, require = 0)
	private void onReleaseUsingItem(CallbackInfo ci) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide() || self.getUseItem().isEmpty())
			return;
		if (self instanceof ServerPlayer serverPlayer && (serverPlayer.connection == null || serverPlayer.hasDisconnected()))
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "itemstack">self.getUseItem()<#elseif n == "duration">self.getUseItemRemainingTicks()<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			ci.cancel();
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_useitem_finish</field>')>
@Mixin(ItemStack.class)
abstract class ${name}Mixin {
	@Inject(method = "finishUsingItem(Lnet/minecraft/world/level/Level;Lnet/minecraft/world/entity/LivingEntity;)Lnet/minecraft/world/item/ItemStack;", at = @At("HEAD"), cancellable = true, require = 0)
	private void onFinishUsingItem(Level level, LivingEntity entity, CallbackInfoReturnable<ItemStack> cir) {
		if (level.isClientSide())
			return;
		if (entity instanceof ServerPlayer serverPlayer && (serverPlayer.connection == null || serverPlayer.hasDisconnected()))
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">entity.getX()<#elseif n == "y">entity.getY()<#elseif n == "z">entity.getZ()<#elseif n == "world">level<#elseif n == "entity">entity<#elseif n == "itemstack">(ItemStack) (Object) this<#elseif n == "duration">entity.getUseItemRemainingTicks()<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue((ItemStack) (Object) this);
	}
}
</#if>





<#if xml?contains('<field name="trigger">entity_pickupxp</field>')>
@Mixin(ExperienceOrb.class)
abstract class ${name}Mixin {
	@Inject(method = "playerTouch(Lnet/minecraft/world/entity/player/Player;)V", at = @At("HEAD"), cancellable = true, require = 0)
	private void onPlayerTouch(Player player, CallbackInfo ci) {
		if (!(player instanceof ServerPlayer serverPlayer) || serverPlayer.takeXpDelay != 0)
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">player.getX()<#elseif n == "y">player.getY()<#elseif n == "z">player.getZ()<#elseif n == "world">player.level()<#elseif n == "entity">player<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			ci.cancel();
	}
}
</#if>

<#if xml?contains('<field name="trigger">entity_uses_totem</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "checkTotemDeathProtection(Lnet/minecraft/world/damagesource/DamageSource;)Z", at = @At("HEAD"), cancellable = true, require = 0)
	private void onCheckTotem(DamageSource source, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "damagesource">source<#elseif n == "sourceentity">source.getEntity()<#elseif n == "immediatesourceentity">source.getDirectEntity()<#elseif n == "itemstack">self.getUseItem()<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(false);
	}
}
</#if>



<#if xml?contains('<field name="trigger">player_use_hoe</field>')>
@Mixin(HoeItem.class)
abstract class ${name}Mixin {
	@Inject(method = "useOn(Lnet/minecraft/world/item/context/UseOnContext;)Lnet/minecraft/world/InteractionResult;", at = @At("RETURN"), cancellable = true, require = 0)
	private void onUseHoe(UseOnContext context, CallbackInfoReturnable<InteractionResult> cir) {
		if (!cir.getReturnValue().consumesAction() || context.getPlayer() == null)
			return;
		BlockPos pos = context.getClickedPos();
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "world">context.getLevel()<#elseif n == "entity">context.getPlayer()<#elseif n == "blockstate">context.getLevel().getBlockState(pos)<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(InteractionResult.FAIL);
	}
}
</#if>

<#if xml?contains('<field name="trigger">block_multiplace</field>')>
@Mixin(ItemStack.class)
abstract class ${name}Mixin {
	@Inject(method = "useOn(Lnet/minecraft/world/item/context/UseOnContext;)Lnet/minecraft/world/InteractionResult;", at = @At("TAIL"), cancellable = true, require = 0)
	private void onMultiplace(UseOnContext context, CallbackInfoReturnable<InteractionResult> cir) {
		Player player = context.getPlayer();
		if (player == null || context.getLevel().isClientSide())
			return;
		BlockPos pos = context.getClickedPos().relative(context.getClickedFace());
		BlockPos against = context.getClickedPos();
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">pos.getX()<#elseif n == "y">pos.getY()<#elseif n == "z">pos.getZ()<#elseif n == "px">player.getX()<#elseif n == "py">player.getY()<#elseif n == "pz">player.getZ()<#elseif n == "world">context.getLevel()<#elseif n == "entity">player<#elseif n == "blockstate">context.getLevel().getBlockState(pos)<#elseif n == "placedagainst">context.getLevel().getBlockState(against)<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(InteractionResult.FAIL);
	}
}
</#if>

<#if xml?contains('<field name="trigger">command_executed</field>')>
@Mixin(Commands.class)
abstract class ${name}Mixin {
	@Inject(method = "performCommand(Lcom/mojang/brigadier/ParseResults;Ljava/lang/String;)I", at = @At("HEAD"), cancellable = true, require = 0)
	private void onPerformCommand(ParseResults<CommandSourceStack> parseResults, String command, CallbackInfoReturnable<Integer> cir) {
		CommandSourceStack source = parseResults.getContext().getSource();
		Entity entity = source.getEntity();
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">source.getPosition().x<#elseif n == "y">source.getPosition().y<#elseif n == "z">source.getPosition().z<#elseif n == "world">source.getLevel()<#elseif n == "entity">entity<#elseif n == "command">command<#elseif n == "arguments">parseResults.getContext().build(command)<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(0);
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_completes_advancement</field>')>
@Mixin(PlayerAdvancements.class)
abstract class ${name}Mixin {
	@Shadow private ServerPlayer player;

	@Inject(method = "award(Lnet/minecraft/advancements/Advancement;Ljava/lang/String;)Z", at = @At("RETURN"), require = 0)
	private void onAward(Advancement advancement, String criterion, CallbackInfoReturnable<Boolean> cir) {
		if (!Boolean.TRUE.equals(cir.getReturnValue()))
			return;
		if (player.connection == null || player.hasDisconnected())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">player.getX()<#elseif n == "y">player.getY()<#elseif n == "z">player.getZ()<#elseif n == "world">player.level()<#elseif n == "entity">player<#elseif n == "advancement">advancement<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>

<#if xml?contains('<field name="trigger">player_fishes_item</field>')>
@Mixin(FishingHook.class)
abstract class ${name}Mixin {
	@Inject(method = "retrieve(Lnet/minecraft/world/item/ItemStack;)I", at = @At("HEAD"), require = 0)
	private void onRetrieve(ItemStack caught, CallbackInfoReturnable<Integer> cir) {
		if (caught.isEmpty())
			return;
		Player player = ((FishingHook) (Object) this).getPlayerOwner();
		if (player == null || player.level().isClientSide())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">player.getX()<#elseif n == "y">player.getY()<#elseif n == "z">player.getZ()<#elseif n == "world">player.level()<#elseif n == "entity">player<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
	}
}
</#if>
<#if xml?contains('<field name="trigger">entity_blocks</field>')>
@Mixin(LivingEntity.class)
abstract class ${name}Mixin {
	@Inject(method = "hurt(Lnet/minecraft/world/damagesource/DamageSource;F)Z", at = @At("HEAD"), cancellable = true, require = 0)
	private void onHurtBlocked(DamageSource source, float amount, CallbackInfoReturnable<Boolean> cir) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.level().isClientSide() || !self.isDamageSourceBlocked(source))
			return;
		if (self instanceof ServerPlayer serverPlayer && serverPlayer.hasDisconnected())
			return;
		${package}.procedures.${name}Procedure.execute(<#list dependencies as dep><#assign n = dep.getName()><#if n == "x">self.getX()<#elseif n == "y">self.getY()<#elseif n == "z">self.getZ()<#elseif n == "world">self.level()<#elseif n == "entity">self<#elseif n == "damagesource">source<#elseif n == "sourceentity">source.getEntity()<#elseif n == "immediatesourceentity">source.getDirectEntity()<#elseif n == "originalblockedamount">amount<#elseif n == "blockedamount">amount<#elseif n == "event">null<#elseif dep.getType(generator.getWorkspace()) == "double" || dep.getType(generator.getWorkspace()) == "int">0<#else>null</#if><#if dep?has_next>,</#if></#list>);
		if (${package}.network.${JavaModName}Utils.consumeEventCanceled())
			cir.setReturnValue(false);
	}
}
</#if>
</#if>

<#-- @formatter:on -->
