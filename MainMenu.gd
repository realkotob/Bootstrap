extends Node2D

signal start_level(level)

var gamelevels = {}

func _ready():
	#gamelevels["let_me_in"] = load("res://levels/let_me_in.tres")
	#gamelevels["lock_without_key"] = load("res://levels/lock_without_key.tres")
	#gamelevels["two_buttons"] = load("res://levels/two_buttons.tres")
	pass

func _on_StartButton_pressed():
	emit_signal("start_level", "let_me_in")
