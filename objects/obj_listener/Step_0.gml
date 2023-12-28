/// @description DEMO ONLY
#region -- DEMO ONLY --
if (fade_out) {
	alpha -= 0.01;	
}

if (alpha <= 0) {
	visible = false;
	fade_out = false;
	alpha   = 0;
	ds_list_clear(text_array);
}

if (keyboard_check(vk_escape)) game_end();
#endregion