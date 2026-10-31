<#include "mcelements.ftl">
{
	BlockPos _pos = ${toBlockPos(input$x, input$y, input$z)};
	BlockState _bs = world.getBlockState(_pos);
	BooleanProperty _booleanProp = ${package}.network.${JavaModName}Utils.findBooleanProperty(_bs, ${input$property});
	if (_booleanProp != null)
		world.setBlock(_pos, _bs.setValue(_booleanProp, ${input$value}), 3);
}
