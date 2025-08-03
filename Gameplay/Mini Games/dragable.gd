extends Area2D
class_name Dragable

signal hover_changed(from: Dragable, new_value: bool)
signal drag_changed(from: Dragable, new_value: bool)

var is_dragging: bool = false
var is_hovering: bool = false
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	self.input_pickable = true
	self.input_event.connect(_on_input_event)
	self.mouse_exited.connect(_on_mouse_exited)
	self.mouse_entered.connect(_on_mouse_entered)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
			drag_changed.emit(self, is_dragging)
			offset = self.global_position - get_global_mouse_position()
		else:
			is_dragging = false
			drag_changed.emit(self, is_dragging)
	elif event is InputEventMouseMotion and is_dragging:
		self.global_position = get_global_mouse_position() + offset

func _on_mouse_entered() -> void:
	is_hovering = true
	hover_changed.emit(self, is_hovering)

func _on_mouse_exited() -> void:
	is_hovering = false
	hover_changed.emit(self, is_hovering)
	
	is_dragging = false
	drag_changed.emit(self, is_dragging)
	offset = Vector2.ZERO
