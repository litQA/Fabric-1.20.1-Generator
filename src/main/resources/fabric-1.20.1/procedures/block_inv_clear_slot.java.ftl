<#include "mcelements.ftl">
<#-- @formatter:off -->
BlockEntity _ent${cbi} = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
if (_ent${cbi} != null) {
	((RandomizableContainerBlockEntity) _ent${cbi}).removeItemNoUpdate(${opt.toInt(input$slotid)});
}
<#-- @formatter:on -->