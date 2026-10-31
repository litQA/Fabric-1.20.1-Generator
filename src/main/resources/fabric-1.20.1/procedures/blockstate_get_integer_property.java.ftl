<#include "mcitems.ftl">
<#assign _state><#if input$block?contains("blockstate")>blockstate<#else>${mappedBlockToBlockStateCode(input$block)}</#if></#assign>
/*@int*/(${package}.network.${JavaModName}Utils.getIntegerProperty(_state, ${input$property}))
