subscribe();
receiver = new Receiver();

receiver.add(MESSAGES.hello, function() {
	show_message("Listener3 received message 'hello'!");
});
receiver.add(MESSAGES.world, function() {
	show_message("Listener3 received message 'world'!");
});
receiver.add(MESSAGES.foo, function() {
	show_message("Listener3 received message 'foo'! This callback is performed first,");
});
receiver.add(MESSAGES.bar);