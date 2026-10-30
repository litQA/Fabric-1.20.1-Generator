<#include "mcelements.ftl">
if (!world.isClientSide()) {
	BlockPos _bp = ${toBlockPos(input$x, input$y, input$z)};
	${package}.network.${JavaModName}Utils.setBlockBoolean(world, _bp, ${input$tagName}, ${input$tagValue});
	if (world instanceof Level _level) {
		BlockState _bs = world.getBlockState(_bp);
		_level.sendBlockUpdated(_bp, _bs, _bs, 3);
	}
}
