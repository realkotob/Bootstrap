extends Node

signal end_level

func _ready():
	var ids := ($EditorTileMap as TileMap).tile_set.get_tiles_ids()
	for id in ids:
		var name := ($EditorTileMap as TileMap).tile_set.tile_get_name(id)
		($EditorPanel/ActiveState/ActionList).add_item("Place " + name, null, true)
	($EditorPanel/ActiveState/ActionList).add_item("Erase Tile", null, true)

func _on_ImportJSON_pressed():
	var dialog := FileDialog.new()
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.add_filter("*.json ; JSON Files")
	dialog.window_title = "Open a File"
	dialog.connect("file_selected", self, "_on_JSONPicker_file_selected")
	($EditorPanel/Popups as Node).add_child(dialog)
	dialog.popup_centered_ratio()

func show_error(text: String):
	($EditorPanel/Popups/AcceptDialog as AcceptDialog).dialog_text = text
	($EditorPanel/Popups/AcceptDialog as AcceptDialog).popup_centered()

func load_file(path: String):
	var file = File.new()
	if !file.file_exists(path):
		return String()
	file.open(path, File.READ)
	var content: String = file.get_as_text()
	file.close()
	return content

func save_file(path: String, data: String):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(data)
	file.close()

func _on_JSONPicker_file_selected(path: String):
	var data: String = load_file(path)
	if len(data) == 0:
		show_error("No data found")
		return
	var parsed := JSON.parse(data)
	# verify the data format
	if parsed.error != OK:
		show_error(parsed.error_string)
		return
	if typeof(parsed.result) != TYPE_DICTIONARY:
		show_error("JSON root must be of type struct")
		return
	if typeof(parsed.result["name"]) != TYPE_STRING:
		show_error("level name must be of type string")
		return
	var name := str(parsed.result["name"])
	if typeof(parsed.result["rows"]) != TYPE_REAL:
		show_error("level row count must be of type number")
		return
	var rows := int(parsed.result["rows"])
	if typeof(parsed.result["cols"]) != TYPE_REAL:
		show_error("level column count must be of type number")
		return
	var cols := int(parsed.result["cols"])
	if typeof(parsed.result["cells"]) != TYPE_ARRAY:
		show_error("level cells must be of type array")
		return
	var cellobjs: Array = []
	var cells: Array = parsed.result["cells"]
	for cell in cells:
		if typeof(cell) != TYPE_DICTIONARY:
			show_error("cell must be of type struct")
			return
		if typeof(cell["row"]) != TYPE_REAL:
			show_error("cell row must be of type number")
			return
		var row := int(cell["row"])
		if typeof(cell["col"]) != TYPE_REAL:
			show_error("cell column must be of type number")
			return
		var col := int(cell["col"])
		if typeof(cell["cellType"]) != TYPE_REAL:
			show_error("cell type must be of type number")
			return
		var cellType := int(cell["cellType"])
		if typeof(cell["label"]) != TYPE_STRING:
			show_error("cell label must be of type string")
			return
		var label := str(cell["label"])
		if typeof(cell["keys"]) != TYPE_STRING_ARRAY:
			if typeof(cell["keys"]) == TYPE_ARRAY && len(cell["keys"]) != 0:
				show_error("cell keys must be of type string array")
				return
		var keys: Array = cell["keys"]
		cellobjs.append(CellObject.new(row, col, cellType, label, keys))
	var levelobj := LevelObject.new(name, rows, cols, cellobjs)
	_on_StartNew_pressed()
	($EditorTileMap as TileMap).load_level_data(levelobj)
	($EditorPanel/ActiveState/LevelNameEdit as LineEdit).text = levelobj.levelName

func _on_StartNew_pressed():
	($EditorTileMap as TileMap).reset_editor()
	($EditorTileMap as TileMap).enable_editor()
	var children := ($EditorPanel/InitialState as Node).get_children()
	for child in children:
		child.hide()
	children = ($EditorPanel/ActiveState as Node).get_children()
	for child in children:
		child.show()

func _on_Exit_pressed():
	emit_signal("end_level")

func _on_ExitEdit_pressed():
	($EditorTileMap as TileMap).reset_editor()
	($EditorPanel/ActiveState/LevelNameEdit as LineEdit).clear()
	($EditorPanel/ActiveState/ActionList as ItemList).unselect_all()
	var children := ($EditorPanel/ActiveState as Node).get_children()
	for child in children:
		child.hide()
	children = ($EditorPanel/InitialState as Node).get_children()
	for child in children:
		child.show()

func _on_SaveLevel_pressed():
	var dialog := FileDialog.new()
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.add_filter("*.json ; JSON Files")
	dialog.window_title = "Save a File"
	dialog.connect("file_selected", self, "_on_JSONPicker_file_save")
	($EditorPanel/Popups as Node).add_child(dialog)
	dialog.popup_centered_ratio()

func _on_JSONPicker_file_save(path: String):
	$EditorTileMap.center_cells()
	var levelobj: LevelObject = $EditorTileMap.get_level_object()
	var cells_dic: Array = []
	for c in levelobj.cells:
		cells_dic.append(c.get_dic())
	var dic: Dictionary = {
		"name": levelobj.levelName,
		"rows": levelobj.rows,
		"cols": levelobj.cols,
		"cells": cells_dic,
	}
	var data: String = JSON.print(dic)
	save_file(path, data)
