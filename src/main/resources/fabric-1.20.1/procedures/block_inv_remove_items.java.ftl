<#include "mcelements.ftl">
<#-- @formatter:off -->
BlockEntity _ent${cbi} = world.getBlockEntity(${toBlockPos(input$x,input$y,input$z)});
if (_ent${cbi} != null) {
    ((RandomizableContainerBlockEntity) _ent${cbi}).removeItem(${opt.toInt(input$slotid)}, ${opt.toInt(input$amount)});
}
<#-- @formatter:on -->