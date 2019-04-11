extends TileMap

enum actions { NONE = 0, PLACE_TILE, ERASE }

var initpos := Vector2(640, 360)
var level_name: String
var active_tile: int
var action: int
var rclick_down: bool
var rclick_pos: Vector2
var orig_pos: Vector2
var offset := Vector2(28,16)

func _ready():
	position = initpos
	rclick_down = false
	rclick_pos = Vector2()
	orig_pos = position
	action = actions.NONE
	set_process_unhandled_input(false)
	set_process(false)
	hide()

func _process(delta):
	if rclick_down:
		var cur_pos := get_viewport().get_mouse_position()
		var diff_pos = cur_pos - rclick_pos
		position = orig_pos + diff_pos

func enable_editor():
	show()
	set_process_unhandled_input(true)
	set_process(true)

func reset_editor():
	position = initpos
	action = actions.NONE
	level_name = ""
	clear()
	hide()
	set_process_unhandled_input(false)
	set_process(false)
	position = Vector2()

func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT:
		rclick_down = event.pressed
		rclick_pos = get_viewport().get_mouse_position()
		orig_pos = position
	if rclick_down:
		return
	if event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT:
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		var loc: Vector2 = world_to_map(mousePos - position - offset)
		var cell: int = get_cell(loc.x, loc.y)
		if action == actions.PLACE_TILE:
			set_cell(loc.x, loc.y, active_tile)
		elif cell != -1 && action == actions.ERASE:
			set_cell(loc.x, loc.y, -1)

func _on_TileList_item_selected(index):
	var max_tile: int = len(tile_set.get_tiles_ids())
	if index < max_tile:
		action = actions.PLACE_TILE
		active_tile = index
	if index == max_tile:
		action = actions.ERASE

func _on_LevelNameEdit_text_changed(new_text: String):
	level_name = new_text
