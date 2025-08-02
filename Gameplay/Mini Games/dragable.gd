extends StaticBody2D
class_name Dragable

var is_dragging: bool = false
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	self.input_event.connect(_on_input_event)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
			offset = self.global_position - get_global_mouse_position()
		else:
			is_dragging = false
	elif event is InputEventMouseMotion and is_dragging:
		self.global_position = get_global_mouse_position() + offset

func _on_mouse_exited() -> void:
	is_dragging = false
	offset = Vector2.ZERO
