/// @description Send msg world
broadcast(MESSAGES.world, function() {
	ConsoleMessage("Callback for 'world'!");
}, "This string is sent as argument input");