/// @description DEMO ONLY
#region -- DEMO ONLY --
var safezone = 10;
var offset   = 14;
var bottom   = display_get_gui_height() - safezone;
var left	 = safezone;

var array_size = ds_list_size(text_array);

draw_set_valign(fa_bottom);
for (var i = 0; i < array_size; i++) {
	draw_set_alpha(alpha - (i * 0.143));
	draw_text(left, bottom - (i * offset), ds_list_find_value(text_array, i));
}



/*
 *		RESET
 */
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
#endregion