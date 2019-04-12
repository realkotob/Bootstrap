extends Node

class_name LevelObject

export var levelName: String
export var rows: int
export var cols: int
export var cells: Array

func _init(levelName: String, rows: int, cols: int, cells: Array):
	self.levelName = levelName
	self.rows = rows
	self.cols = cols
	self.cells = cells

func _ready():
	pass
