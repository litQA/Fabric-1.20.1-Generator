<#include "mcelements.ftl">
<#include "mcitems.ftl">
if (!world.isClientSide()) {
	BlockPos _bp = ${toBlockPos(input$x, input$y, input$z)};
	${package}.network.${JavaModName}Utils.setBlockItemStack(world, _bp, ${input$tagName}, ${mappedMCItemToItemStackCode(input$tagValue, 1)});
	if (world instanceof Level _level) {
		BlockState _bs = world.getBlockState(_bp);
		_level.sendBlockUpdated(_bp, _bs, _bs, 3);
	}
}
