extends Node

class_name Cell

enum Type {FLOOR = 0, WALL, BUTTON, PLAYER, OPEN_DOOR, CLOSED_DOOR, LOCKED_DOOR, TIME_MACHINE, EXIT}

var row: int
var col: int
var cellType: int
var label: String
var keys: Array

func _init(row: int, col: int, cellType: int, label: String, keys: Array):
	self.row = row
	self.col = col
	self.cellType = cellType
	self.label = label
	self.keys = keys

func _ready():
	pass
