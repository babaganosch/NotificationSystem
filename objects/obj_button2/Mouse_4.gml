/// @description Send msg world
broadcast(MESSAGES.world, function() {
	self.ConsoleMessage("Callback for 'world'!");
}, "This string is sent as argument");