# TODO: move screens to a separate folder
extends Control


func _ready() -> void:
	Game.pause()

func _on_resume_button_pressed() -> void:
	Game.unpause()
	queue_free()
