extends Control


@export var pause_scene : PackedScene = preload("res://Gameplay/Race/pause_screen.tscn")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	# TODO: don't use built-in action?
	if event.is_action_pressed("pause"):
		var pause_screen = pause_scene.instantiate()
		add_child(pause_screen)
