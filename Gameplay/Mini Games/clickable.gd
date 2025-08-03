extends Area2D
class_name Clickable

signal clicked(node: Clickable)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_button = event as InputEventMouseButton
		if mouse_button.is_pressed() and mouse_button.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
