extends Node

const Cell = preload("res://Cell.gd")
#const GameLevel = preload("res://GameLevel.gd")
onready var Level_Editor = preload("res://Level_Editor.tscn")

func _ready():
	pass

func _on_MainMenu_start_level(name: String):
	pass

func _on_MainMenu_start_editor():
	($MainMenu as Node2D).hide()
	var le = Level_Editor.instance()
	(le as Node).connect("end_level", self, "_on_Level_Editor_exit")
	add_child(le)

func _on_Level_Editor_exit():
	($Root as Node).queue_free()
	($MainMenu as Node2D).show()
