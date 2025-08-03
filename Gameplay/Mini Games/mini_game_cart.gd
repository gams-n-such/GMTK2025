extends Node2D
class_name MiniGameCart

var dirt_left: float = 100.0
var mouse_down: bool = false
var speed: float = 0.0

func _process(delta: float) -> void:
	%Sponge.global_position = get_global_mouse_position()
	%Dirt.set_modulate(Color(Color.WHITE, dirt_left / 100))
	dirt_left -= speed * delta / 10
	speed = 0.0
	if dirt_left < 0.0:
		self.queue_free()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var mouse_event := event as InputEventMouseMotion
	if mouse_event:
		speed = mouse_event.screen_velocity.length()
