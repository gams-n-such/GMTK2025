extends Node2D
class_name MiniGameHshoe

var nails_left: int = 5

func _ready() -> void:
	for child in get_children():
		if child is Clickable:
			child.clicked.connect(on_nail_clicked)

func on_nail_clicked(node: Clickable) -> void:
	nails_left -= 1
	%NailSound.play()
	for child in node.get_children():
		if child is Sprite2D:
			child.visible = !child.visible
		if child is CollisionShape2D:
			child.queue_free()
	
	if nails_left == 0:
		self.queue_free()
