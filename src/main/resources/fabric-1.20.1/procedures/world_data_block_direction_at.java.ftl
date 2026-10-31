<#include "mcelements.ftl">
(new Object() {
	public Direction getDirection(BlockPos pos) {
		return ${package}.network.${JavaModName}Utils.getDirectionOrDefault(world.getBlockState(pos));
	}
}.getDirection(${toBlockPos(input$x, input$y, input$z)}))
