extends Node2D
class_name TestMiniGame

var presses_left := 3

func _on_button_button_up() -> void:
	presses_left -= 1
	if presses_left <= 0:
		self.queue_free()
	else:
		%Button.text = ("press me %d times" % [presses_left])
