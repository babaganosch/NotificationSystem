enum MESSAGES {
	hello,
	world,
	foo,
	bar
}

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