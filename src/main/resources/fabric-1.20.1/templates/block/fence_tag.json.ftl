<#assign taggedBlocks = w.getGElementsOfType('block')?filter(e -> e.blockBase?has_content && e.blockBase == 'Fence')>
{
    "replace": false,
    "values": [<#list taggedBlocks as block>"${generator.getResourceLocationForModElement(block.getModElement())}"<#if block?has_next>,</#if></#list>]
}
