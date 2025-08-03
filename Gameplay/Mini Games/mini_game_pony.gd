extends Node2D
class_name MiniGamePony

var clicks_left: int = 10

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var mouse_button := event as InputEventMouseButton
	if mouse_button and mouse_button.is_pressed():
		clicks_left -= 1
		%Sprite2D.modulate = Color(Color.WHITE, clicks_left / 10.0)
		%ChompSound.play()
		if clicks_left <= 0:
			self.queue_free()
