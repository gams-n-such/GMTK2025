extends Area2D
class_name StartMiniGameBtn

@export var mini_game: PackedScene = preload("res://Gameplay/Mini Games/test_mini_game.tscn")
@export var part: Enum.RACER_PART = Enum.RACER_PART.RIDER

var hover: bool = false

signal start_mini_game(mini_game_scene: PackedScene, part: Enum.RACER_PART)

func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	var control_parent = get_parent()
	while control_parent and control_parent is not Control:
		control_parent = control_parent.get_parent()
	if control_parent:
		control_parent.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	hover = true

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(0)
	var control_parent = get_parent()
	while control_parent and control_parent is not Control:
		control_parent = control_parent.get_parent()
	if control_parent:
		control_parent.set_default_cursor_shape(0)
	hover = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			start_mini_game.emit(mini_game, part)
