enum MESSAGES {
	hello,
	world,
	foo,
	bar
}

receiver = new Receiver();

receiver.on(MESSAGES.hello, function() {
	ConsoleMessage("Received message 'hello'!");
});

receiver.on(MESSAGES.world, function(_data) {
	ConsoleMessage(_data);
});

receiver.on(MESSAGES.foo, function() {
	ConsoleMessage("Received message 'foo'! This callback is performed first,");
});

receiver.on(MESSAGES.bar);

#region -- DEMO ONLY --


function ConsoleMessage(_message) {
	
	/* Push message and pop old */
	ds_list_insert(text_array, 0, _message);
	var size = ds_list_size(text_array);
	if (size > 7) {
		ds_list_delete(text_array, size - 1);
	}
	
	/* Reset fade out */
	visible = true;
	alarm[0] = timer;
	fadeOut = false;
	alpha = 1;

}

text_array = ds_list_create();
alpha = 0;
fadeOut = false;
timer = 120;
#endregion