extends Control

@export var seconds_to_start : int = 3

signal finished

func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	# TODO: visuals, SFX
	seconds_to_start -= 1
	if seconds_to_start <= 0:
		finished.emit()
		queue_free()
