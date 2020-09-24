subscribe();
receiver = new Receiver();
receiver.add(MESSAGES.world, function() {
	show_message_async("Listener2 received message 'world'!");
});