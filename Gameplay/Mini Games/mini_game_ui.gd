extends Control
class_name MiniGameUi

signal game_ended(completed: bool)

@export var mini_game_scene = preload("res://Gameplay/Mini Games/test_mini_game.tscn")
var mini_game
var giveup_btn_pressed := false

func _ready() -> void:
	mini_game = mini_game_scene.instantiate()
	%SubViewport.add_child(mini_game)
	mini_game.tree_exiting.connect(on_mini_game_exited_tree)

func _on_button_pressed() -> void:
	giveup_btn_pressed = true
	self.queue_free()

func on_mini_game_exited_tree() -> void:
	game_ended.emit(not giveup_btn_pressed)
	self.queue_free()
