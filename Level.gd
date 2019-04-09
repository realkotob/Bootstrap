extends Node2D

class_name Level

const Cell = preload("res://Cell.gd")
const LevelObject = preload("res://LevelObject.gd")

var levelObject: LevelObject

func _init(levelObject: LevelObject):
	self.levelObject = levelObject
	self.spawn_tiles()

func spawn_tiles():
	pass

func _ready():
	pass # Replace with function body.

