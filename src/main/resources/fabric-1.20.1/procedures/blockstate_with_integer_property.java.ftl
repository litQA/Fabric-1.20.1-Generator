<#include "mcitems.ftl">
<#assign _state><#if input$block?contains("blockstate")>blockstate<#else>${mappedBlockToBlockStateCode(input$block)}</#if></#assign>
/*@BlockState*/(${package}.network.${JavaModName}Utils.withIntegerProperty(_state, ${input$property}, ${opt.toInt(input$value)}))
