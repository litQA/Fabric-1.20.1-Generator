<#include "mcitems.ftl">
{
	ItemStack _isc = ${mappedMCItemToItemStackCode(input$item, 1)};
	final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	${package}.network.${JavaModName}Utils.setItemStackSlot(_isc, ${opt.toInt(input$slotid)}, _setstack);
}
