<#-- @formatter:off -->
package ${package}.mixins;

import net.minecraft.network.protocol.game.ServerboundPlayerActionPacket;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.server.network.ServerGamePacketListenerImpl;

import ${package}.trigger.${JavaModName}Triggers;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(ServerGamePacketListenerImpl.class)
public abstract class ${JavaModName}PlayerActionMixin {

	@Shadow public ServerPlayer player;

	@Inject(method = "handlePlayerAction", at = @At("RETURN"), require = 0)
	private void onPlayerAction(ServerboundPlayerActionPacket packet, CallbackInfo ci) {
		if (packet.getAction() == ServerboundPlayerActionPacket.Action.SWAP_ITEM_WITH_OFFHAND) {
			${JavaModName}Triggers.fireSwitchHand(this.player, this.player.getMainHandItem().copy(), this.player.getOffhandItem().copy());
		}
	}
}
<#-- @formatter:on -->
