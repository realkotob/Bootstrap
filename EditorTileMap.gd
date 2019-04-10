extends TileMap

var level_name: String
var active_tile: int

func _ready():
	active_tile = -1
	set_process_unhandled_input(false)
	hide()

func _process(delta):
	pass

func reset_editor():
	active_tile = -1
	level_name = ""
	tile_set.clear()
	hide()
	set_process_unhandled_input(false)

func _unhandled_input(event):
	if event is InputEventMouseButton && event.pressed:
		var mousePos: Vector2 = get_viewport().get_mouse_position()
		var loc: Vector2 = world_to_map(mousePos)
		var cell: int = get_cell(loc.x, loc.y)
		if event.button_index == BUTTON_LEFT:
			set_cell(loc.x, loc.y, active_tile)
		elif event.button_index == BUTTON_RIGHT && cell != -1:
			set_cell(loc.x, loc.y, -1)

func _on_TileList_item_selected(index):
	active_tile = index

func _on_LevelNameEdit_text_changed(new_text: String):
	level_name = new_text
