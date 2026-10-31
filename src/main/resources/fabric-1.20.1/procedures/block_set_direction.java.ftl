<#include "mcelements.ftl">
{
	Direction _dir = ${input$direction};
	BlockPos _pos = ${toBlockPos(input$x, input$y, input$z)};
	BlockState _bs = world.getBlockState(_pos);
	DirectionProperty _facing = ${package}.network.${JavaModName}Utils.findDirectionProperty(_bs, "facing");
	if (_facing != null && _facing.getPossibleValues().contains(_dir)) {
		world.setBlock(_pos, _bs.setValue(_facing, _dir), 3);
	} else {
		EnumProperty<?> _axis = ${package}.network.${JavaModName}Utils.findEnumProperty(_bs, "axis");
		if (_axis != null && _axis.getPossibleValues().contains(_dir.getAxis()))
			world.setBlock(_pos, ${package}.network.${JavaModName}Utils.withDirection(_bs, _dir), 3);
	}
}
