<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.world.level.Explosion;
import net.minecraft.world.level.Level;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(Explosion.class)
public abstract class ${JavaModName}ExplosionMixin {

	@Shadow private Level level;
	@Shadow private double x;
	@Shadow private double y;
	@Shadow private double z;

	@Inject(method = "explode", at = @At("HEAD"), require = 0)
	private void onExplode(CallbackInfo ci) {
		if (!this.level.isClientSide) {
			${JavaModName}Triggers.fireExplosion(this.level, this.x, this.y, this.z);
		}
	}
}
<#-- @formatter:on -->
