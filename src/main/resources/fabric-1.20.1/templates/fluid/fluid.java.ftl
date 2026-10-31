<#include "../procedures.java.ftl">

package ${package}.fluid;

public abstract class ${name}Fluid extends FlowingFluid {

	@Override public Fluid getFlowing() {
		return ${JavaModName}Fluids.FLOWING_${REGISTRYNAME};
	}

	@Override public Fluid getSource() {
		return ${JavaModName}Fluids.${REGISTRYNAME};
	}

	@Override public Item getBucket() {
		return <#if data.generateBucket>${JavaModName}Items.${REGISTRYNAME}_BUCKET<#else>Items.AIR</#if>;
	}

	@Override protected boolean canConvertToSource(Level level) {
		return ${data.canMultiply?c};
	}

	@Override protected void beforeDestroyingBlock(LevelAccessor level, BlockPos pos, BlockState state) {
		BlockEntity blockEntity = state.hasBlockEntity() ? level.getBlockEntity(pos) : null;
		Block.dropResources(state, level, pos, blockEntity);
		<#if hasProcedure(data.beforeReplacingBlock)>
		<@procedureCode data.beforeReplacingBlock, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "level",
			"blockstate": "state"
		}/>
		</#if>
	}

	@Override protected boolean canBeReplacedWith(FluidState state, BlockGetter level, BlockPos pos, Fluid fluid, Direction direction) {
		return direction == Direction.DOWN && !isSame(fluid);
	}

	@Override public float getExplosionResistance() {
		return ${data.resistance}f;
	}

	@Override public int getTickDelay(LevelReader level) {
		return ${data.flowRate};
	}

	@Override protected int getDropOff(LevelReader level) {
		return ${data.levelDecrease};
	}

	@Override protected int getSlopeFindDistance(LevelReader level) {
		return ${data.slopeFindDistance};
	}

	@Override protected BlockState createLegacyBlock(FluidState state) {
		return ${JavaModName}Blocks.${REGISTRYNAME}.defaultBlockState().setValue(LiquidBlock.LEVEL, getLegacyLevel(state));
	}

	@Override public boolean isSame(Fluid fluid) {
		return fluid == getSource() || fluid == getFlowing();
	}

	@Override public Optional<SoundEvent> getPickupSound() {
		return Optional.of(SoundEvents.BUCKET_FILL);
	}

	<#if data.spawnParticles>
	@Override public ParticleOptions getDripParticle() {
		return ${data.dripParticle};
	}
	</#if>

	<#if data.flowStrength != 1>
	@Override public Vec3 getFlow(BlockGetter world, BlockPos pos, FluidState fluidstate) {
		return super.getFlow(world, pos, fluidstate).scale(${data.flowStrength});
	}
	</#if>

	public static class Source extends ${name}Fluid {
		@Override public int getAmount(FluidState state) {
			return 8;
		}

		@Override public boolean isSource(FluidState state) {
			return true;
		}
	}

	public static class Flowing extends ${name}Fluid {
		@Override protected void createFluidStateDefinition(StateDefinition.Builder<Fluid, FluidState> builder) {
			super.createFluidStateDefinition(builder);
			builder.add(LEVEL);
		}

		@Override public int getAmount(FluidState state) {
			return state.getValue(LEVEL);
		}

		@Override public boolean isSource(FluidState state) {
			return false;
		}
	}

	@Environment(EnvType.CLIENT) public static void clientLoad() {
		FluidRenderHandlerRegistry.INSTANCE.register(${JavaModName}Fluids.${REGISTRYNAME}, ${JavaModName}Fluids.FLOWING_${REGISTRYNAME},
				new SimpleFluidRenderHandler(
						new ResourceLocation("${data.textureStill.format("%s:block/%s")}"),
						new ResourceLocation("${data.textureFlowing.format("%s:block/%s")}")));
		BlockRenderLayerMap.INSTANCE.putFluids(RenderType.translucent(), ${JavaModName}Fluids.${REGISTRYNAME}, ${JavaModName}Fluids.FLOWING_${REGISTRYNAME});
	}
}
