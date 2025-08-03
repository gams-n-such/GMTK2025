extends Node2D
class_name MiniGameWhell

var lynch_removed: bool = false
var old_wheel_moved: bool = false
var new_wheel_on: bool = false
var lynch_installed: bool = false
var wheel_pos: Vector2


func _ready() -> void:
	for child in %BG.get_children():
		if child is Dragable:
			(child as Dragable).input_pickable = false
	
	wheel_pos = %NewWheel.position
	%NewWheel.position = Vector2(600.0, 200.0)
	%Lynch.input_pickable = true
	

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area == %Lynch and not lynch_removed:
		%OldWheel.input_pickable = true
		area.input_pickable = false
		area.position += Vector2(50.0, -50.0)
		lynch_removed = true


func _on_trash_area_entered(area: Area2D) -> void:
	if area == %OldWheel and lynch_removed and not old_wheel_moved:
		old_wheel_moved = true
		%OldWheel.queue_free()
		%NewWheel.input_pickable = true

func _on_axle_area_entered(area: Area2D) -> void:
	if area == %Center and lynch_removed and old_wheel_moved and not new_wheel_on:
		new_wheel_on = true
		%NewWheel.position = wheel_pos
		%NewWheel.input_pickable = false
		%Lynch.input_pickable = true
	if area == %LynchCenter and lynch_removed and old_wheel_moved and new_wheel_on:
		self.queue_free()
