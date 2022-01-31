/// @description DEMO ONLY
#region -- DEMO ONLY --
if (fadeOut) {
	alpha -= 0.01;	
}

if (alpha <= 0) {
	visible = false;
	fadeOut = false;
	alpha   = 0;
	ds_list_clear(text_array);
}
#endregion