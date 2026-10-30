<#include "mcelements.ftl">
{
	BlockPos _bp = ${toBlockPos(input$x, input$y, input$z)};
	${package}.network.${JavaModName}Utils.blockInventoryDamageItem(world, _bp, ${opt.toInt(input$slotid)}, ${opt.toInt(input$amount)});
}
