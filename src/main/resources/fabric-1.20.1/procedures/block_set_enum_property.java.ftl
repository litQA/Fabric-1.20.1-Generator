<#include "mcelements.ftl">
{
	String _value = ${input$value};
	BlockPos _pos = ${toBlockPos(input$x, input$y, input$z)};
	BlockState _bs = world.getBlockState(_pos);
	EnumProperty _enumProp = ${package}.network.${JavaModName}Utils.findEnumProperty(_bs, ${input$property});
	if (_enumProp != null && _enumProp.getValue(_value).isPresent())
		world.setBlock(_pos, _bs.setValue(_enumProp, (Enum) _enumProp.getValue(_value).get()), 3);
}
