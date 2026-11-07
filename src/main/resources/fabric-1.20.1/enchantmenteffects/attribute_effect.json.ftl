<#-- @formatter:off -->
<#if field$attribute?contains(":")>
"attribute": "${field$attribute}",
<#else>
<#assign attributeKey = field$attribute?lower_case>
<#if attributeKey == "spawn_reinforcements_chance">
"attribute": "minecraft:zombie.spawn_reinforcements",
<#elseif attributeKey == "jump_strength">
"attribute": "minecraft:horse.jump_strength",
<#else>
"attribute": "minecraft:generic.${attributeKey}",
</#if>
</#if>
"amount": ${input$amount},
"operation": "${field$operation}",
"id": "${modid}:enchantment.${registryname}_${cbi}"
<#-- @formatter:on -->
