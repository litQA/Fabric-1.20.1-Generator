accessWidener v1 named

<#if w.hasElementsOfType("biome")>
accessible method net/minecraft/world/level/biome/MultiNoiseBiomeSource parameters ()Lnet/minecraft/world/level/biome/Climate$ParameterList;
accessible field net/minecraft/world/level/chunk/ChunkGenerator biomeSource Lnet/minecraft/world/level/biome/BiomeSource;
accessible field net/minecraft/world/level/chunk/ChunkGenerator featuresPerStep Ljava/util/function/Supplier;
mutable field net/minecraft/world/level/chunk/ChunkGenerator biomeSource Lnet/minecraft/world/level/biome/BiomeSource;
mutable field net/minecraft/world/level/chunk/ChunkGenerator featuresPerStep Ljava/util/function/Supplier;
accessible field net/minecraft/world/level/chunk/ChunkGenerator generationSettingsGetter Ljava/util/function/Function;
accessible field net/minecraft/world/level/levelgen/NoiseBasedChunkGenerator settings Lnet/minecraft/core/Holder;
mutable field net/minecraft/world/level/levelgen/NoiseBasedChunkGenerator settings Lnet/minecraft/core/Holder;
</#if>

<#-- MenuScreens.register + ScreenConstructor are private/package-private in vanilla 1.20.1 (Forge patches them, Fabric does not) -->
<#if w.hasElementsOfType("gui")>
accessible class net/minecraft/client/gui/screens/MenuScreens$ScreenConstructor
accessible method net/minecraft/client/gui/screens/MenuScreens register (Lnet/minecraft/world/inventory/MenuType;Lnet/minecraft/client/gui/screens/MenuScreens$ScreenConstructor;)V
</#if>

<#-- ItemProperties.register(...) is private in vanilla 1.20.1; Fabric API widens it transitively, but keep it explicit for standalone builds -->
<#if w.hasElementsOfType("item") || w.hasElementsOfType("tool")>
accessible method net/minecraft/client/renderer/item/ItemProperties register (Lnet/minecraft/world/item/Item;Lnet/minecraft/resources/ResourceLocation;Lnet/minecraft/client/renderer/item/ClampedItemPropertyFunction;)V
</#if>
