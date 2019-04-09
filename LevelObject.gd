extends Node

class_name LevelObject

var levelName: String
var rows: int
var cols: int
var cells: Array

func _init(levelName: String, rows: int, cols: int, cells: Array):
	self.levelName = levelName
	self.rows = rows
	self.cols = cols
	self.cells = cells

func _ready():
	pass
