{
	if (${input$entity} instanceof Player _player) {
		for (int _idx = 0; _idx < _player.getInventory().getContainerSize(); _idx++) {
			ItemStack itemstackiterator = _player.getInventory().getItem(_idx).copy();
			${statement$foreach}
		}
	}
}
