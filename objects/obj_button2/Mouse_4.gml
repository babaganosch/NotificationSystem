/// @description Send msg WORLD
broadcast(MESSAGES.WORLD, function() {
	self.console_message("Callback for 'WORLD'!");
}, "This string is sent as argument");