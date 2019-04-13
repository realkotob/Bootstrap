extends TileMap

enum actions { NONE = 0, PLACE_TILE, ERASE }

#onready var LevelObject = preload("res://LevelObject.gd")
#onready var CellObject = preload("res://CellObject.gd")

var initpos := Vector2(640, 360)
var active_tile: int
var action: int
var rclick_down: bool
var rclick_pos: Vector2
var orig_pos: Vector2
var offset := Vector2(16,28)
var levelobj: LevelObject

func _ready():
	rclick_down = false
	rclick_pos = Vector2()
	reset_editor()

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
	levelobj = LevelObject.new("", 0, 0, [])
	clear()
	hide()
	set_process_unhandled_input(false)
	set_process(false)

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
	levelobj.levelName = new_text

func load_level_data(levelobj: LevelObject):
	self.levelobj = levelobj
	for c in levelobj.cells:
		var cell := (c as CellObject)
		set_cell(cell.row, cell.col, cell.cellType)
	center_cells()

func center_cells():
	var cells := get_used_cells()
	var indices: Array = []
	if len(cells) == 0:
		return
	var min_x: int = (cells[0] as Vector2).x
	var min_y: int = (cells[0] as Vector2).y
	for c in cells:
		var v := c as Vector2
		indices.push_back(get_cell(v.x, v.y))
		min_x = min(min_x, v.x)
		min_y = min(min_y, v.y)
	var rect_size: Vector2 = get_used_rect().size
	var to_trans := Vector2(int(-min_x-rect_size.x/2+0.5), int(-min_y-rect_size.y/2+0.5))
	# todo: fix coordinate position mapping, i.e. center the used_rect
	clear()
	for i in range(0, len(cells)):
		var v: Vector2 = cells[i] + to_trans
		var tile: int = indices[i]
		set_cell(v.x, v.y, tile)
	position = initpos

func get_cell_obj(x: int, y: int):
	var ind: int = get_cell(x, y)
	var label: String = ""
	var keys: Array = []
	var cell := CellObject.new(x, y, ind, label, keys)
	return cell

func get_level_object():
	var rect: Rect2 = get_used_rect()
	var rect_size: Vector2 = rect.size
	levelobj.rows = rect_size.x
	levelobj.cols = rect_size.y
	var cells: Array = []
	var used_cells := get_used_cells()
	for c in used_cells:
		var v: Vector2 = c
		var cell: CellObject = get_cell_obj(v.x, v.y)
		cells.append(cell)
	levelobj.cells = cells
	return levelobj
