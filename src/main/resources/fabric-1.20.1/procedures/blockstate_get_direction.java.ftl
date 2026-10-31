<#include "mcitems.ftl">
<#assign _state><#if input$block?contains("blockstate")>blockstate<#else>${mappedBlockToBlockStateCode(input$block)}</#if></#assign>
(${package}.network.${JavaModName}Utils.getDirectionOrDefault(${_state}))
