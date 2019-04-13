extends Node

class_name CellObject

enum Type {FLOOR = 0, WALL, BUTTON, PLAYER, OPEN_DOOR, CLOSED_DOOR, LOCKED_DOOR, TIME_MACHINE, EXIT}

export var row: int
export var col: int
export var cellType: int
export var label: String
export var keys: Array

func _init(row: int, col: int, cellType: int, label: String, keys: Array):
	self.row = row
	self.col = col
	self.cellType = cellType
	self.label = label
	self.keys = keys

func get_dic():
	var dic: Dictionary = {}
	dic["row"] = row
	dic["col"] = col
	dic["cellType"] = cellType
	dic["label"] = label
	dic["keys"] = keys
	return dic

func _ready():
	pass
