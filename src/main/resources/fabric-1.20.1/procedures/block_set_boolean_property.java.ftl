<#include "mcelements.ftl">
{
	BlockPos _pos = ${toBlockPos(input$x, input$y, input$z)};
	BlockState _bs = world.getBlockState(_pos);
	if (${package}.network.${JavaModName}Utils.findBooleanProperty(_bs, ${input$property}) instanceof BooleanProperty _booleanProp)
		world.setBlock(_pos, _bs.setValue(_booleanProp, ${input$value}), 3);
}
