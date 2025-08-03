extends Control

#@export var seconds_to_start : int = 3

signal finished

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	# We start by the fourth bleep
	# TODO: visuals
	finished.emit()
	visible = false

func _on_countdown_sound_finished() -> void:
	queue_free()
