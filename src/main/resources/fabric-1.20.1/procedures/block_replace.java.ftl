<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#if field$nbt?lower_case == "false" && field$state?lower_case == "false">
world.setBlock(${toBlockPos(input$x,input$y,input$z)}, ${mappedBlockToBlockStateCode(input$block)},3);
<#else>
{
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	BlockState _bs = ${mappedBlockToBlockStateCode(input$block)};

	<#if field$state?lower_case == "true">
	_bs = ${package}.network.${JavaModName}Utils.copyProperties(_bs, world.getBlockState(_bp));
	</#if>

	<#if field$nbt?lower_case == "true">
	BlockEntity _be = world.getBlockEntity(_bp);
	CompoundTag _bnbt = null;
	if(_be != null) {
		_bnbt = _be.saveWithFullMetadata();
		_be.setRemoved();
	}
	</#if>

	world.setBlock(_bp, _bs, 3);

	<#if field$nbt?lower_case == "true">
	if(_bnbt != null) {
		_be = world.getBlockEntity(_bp);
		if(_be != null) {
			try {
				_be.load(_bnbt);
			} catch(Exception ignored) {}
		}
	}
	</#if>
}
</#if>