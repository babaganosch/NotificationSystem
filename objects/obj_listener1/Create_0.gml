subscribe();
receiver = new Receiver();
receiver.add(MESSAGES.hello, function() {
	show_message_async("Listener1 received message 'hello'!");
});