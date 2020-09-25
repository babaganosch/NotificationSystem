subscribe();
receiver = new Receiver();

receiver.add(MESSAGES.hello, function() {
	ConsoleMessage("Received message 'hello'!");
});

receiver.add(MESSAGES.world, function() {
	ConsoleMessage("Received message 'world'!");
});

receiver.add(MESSAGES.foo, function() {
	ConsoleMessage("Received message 'foo'! This callback is performed first,");
});

receiver.add(MESSAGES.bar);




#region -- DEMO ONLY --
text_array = ds_list_create();
alpha = 0;
fadeOut = false;
timer = 120;
#endregion