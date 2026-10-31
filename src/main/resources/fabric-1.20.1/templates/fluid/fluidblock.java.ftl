<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">

package ${package}.block;

import net.minecraft.world.level.block.state.BlockBehaviour.Properties;

public class ${name}Block extends LiquidBlock {

	public ${name}Block() {
		super(${JavaModName}Fluids.${REGISTRYNAME}, BlockBehaviour.Properties.of()
				<#if (data.colorOnMap!"DEFAULT") != "DEFAULT">
				.mapColor(MapColor.${data.colorOnMap})
				<#else>
				.mapColor(MapColor.${(data.type == "WATER")?then("WATER", "FIRE")})
				</#if>
				.strength(${data.resistance}f)
				<#if data.emissiveRendering>.hasPostProcess((bs, br, bp) -> true).emissiveRendering((bs, br, bp) -> true)</#if>
				<#if data.luminance != 0>.lightLevel(state -> ${data.luminance})</#if>
				<#if data.ignitedByLava>.ignitedByLava()</#if>
				.noCollission().noLootTable().liquid().pushReaction(PushReaction.DESTROY).sound(SoundType.EMPTY).replaceable());
	}

	<#if data.lightOpacity == 0>
	@Override public boolean propagatesSkylightDown(BlockState state, BlockGetter reader, BlockPos pos) {
		return true;
	}
	<#elseif data.lightOpacity != 1>
	@Override public int getLightBlock(BlockState state, BlockGetter worldIn, BlockPos pos) {
		return ${data.lightOpacity};
	}
	</#if>

	<@onBlockAdded data.onBlockAdded, hasProcedure(data.onTickUpdate) && data.tickRate gt 0, data.tickRate/>

	<@onRedstoneOrNeighborChanged "", "", data.onNeighbourChanges/>

	<@onBlockTick data.onTickUpdate, data.tickRate gt 0, data.tickRate/>

	<@onEntityCollides data.onEntityCollides/>

	<@onAnimateTick data.onRandomUpdateEvent/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>
}
