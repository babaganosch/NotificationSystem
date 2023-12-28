/// @description DEMO ONLY
#region -- DEMO ONLY --
var _safezone = 10;
var _offset   = 14;
var _bottom   = display_get_gui_height() - _safezone;
var _left	 = _safezone;

var _array_size = ds_list_size(text_array);

draw_set_valign(fa_bottom);
for (var _i = 0; _i < _array_size; _i++) {
	draw_set_alpha(alpha - (_i * 0.143));
	draw_text(_left, _bottom - (_i * _offset), ds_list_find_value(text_array, _i));
}



/*
 *		RESET
 */
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
#endregion