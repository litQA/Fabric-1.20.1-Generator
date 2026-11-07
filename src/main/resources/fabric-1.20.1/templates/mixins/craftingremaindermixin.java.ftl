<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.item.Item;

import ${package}.init.${JavaModName}CraftingRemainders;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Item.class)
public abstract class ${JavaModName}CraftingRemainderMixin {

	@Inject(method = "getCraftingRemainingItem", at = @At("HEAD"), cancellable = true, require = 0)
	private void getCraftingRemainingItem(CallbackInfoReturnable<Item> cir) {
		Item remainder = ${JavaModName}CraftingRemainders.get((Item) (Object) this);
		if (remainder != null) {
			cir.setReturnValue(remainder);
		}
	}

	@Inject(method = "hasCraftingRemainingItem", at = @At("HEAD"), cancellable = true, require = 0)
	private void hasCraftingRemainingItem(CallbackInfoReturnable<Boolean> cir) {
		if (${JavaModName}CraftingRemainders.has((Item) (Object) this)) {
			cir.setReturnValue(true);
		}
	}
}
<#-- @formatter:on -->
