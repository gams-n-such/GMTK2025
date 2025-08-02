extends Button
class_name StartMiniGameBtn

@export var mini_game: PackedScene = preload("res://Gameplay/Mini Games/test_mini_game.tscn")
@export var part: Enum.RACER_PART = Enum.RACER_PART.RIDER

signal start_mini_game(mini_game_scene: PackedScene, part: Enum.RACER_PART)

func _ready() -> void:
	self.button_up.connect(on_pressed)

func on_pressed() -> void:
	self.start_mini_game.emit(mini_game, part) # Replace with function body.
