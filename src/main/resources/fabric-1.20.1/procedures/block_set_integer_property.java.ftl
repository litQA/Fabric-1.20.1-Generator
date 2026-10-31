<#include "mcelements.ftl">
{
	int _value = ${opt.toInt(input$value)};
	BlockPos _pos = ${toBlockPos(input$x, input$y, input$z)};
	BlockState _bs = world.getBlockState(_pos);
	if (${package}.network.${JavaModName}Utils.findIntegerProperty(_bs, ${input$property}) instanceof IntegerProperty _integerProp && _integerProp.getPossibleValues().contains(_value))
		world.setBlock(_pos, _bs.setValue(_integerProp, _value), 3);
}
