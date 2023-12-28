enum MESSAGES {
	HELLO,
	WORLD,
	FOO,
	BAR
}

receiver = new Receiver();

receiver.on(MESSAGES.HELLO, function() {
	console_message("Received message 'hello'!");
});

receiver.on(MESSAGES.WORLD, function(_data) {
	console_message(_data);
});

receiver.on(MESSAGES.FOO, function() {
	console_message("Received message 'foo'! This callback is performed first,");
});

receiver.on(MESSAGES.BAR);

#region -- DEMO ONLY --


function console_message(_message) {
	
	/* Push message and pop old */
	ds_list_insert(text_array, 0, _message);
	var _size = ds_list_size(text_array);
	if (_size > 7) {
		ds_list_delete(text_array, _size - 1);
	}
	
	/* Reset fade out */
	visible = true;
	alarm[0] = timer;
	fade_out = false;
	alpha = 1;

}

text_array = ds_list_create();
alpha = 0;
fade_out = false;
timer = 120;
#endregion