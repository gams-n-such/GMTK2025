extends Control
class_name MiniGameUi

signal game_ended(completed: bool, part: int)

var mini_game
var part: Enum.RACER_PART
var giveup_btn_pressed := false

func _ready() -> void:
	pass

func init_game(scene: PackedScene, repair_part: Enum.RACER_PART) -> void:
	part = repair_part
	mini_game = scene.instantiate()
	self.add_child(mini_game)
	mini_game.tree_exiting.connect(on_mini_game_exited_tree)
	self.move_child(%Button, self.get_child_count())

func _on_button_pressed() -> void:
	giveup_btn_pressed = true
	self.queue_free()

func on_mini_game_exited_tree() -> void:
	game_ended.emit(not giveup_btn_pressed, part)
	self.queue_free()


func _on_sub_viewport_container_gui_input(event: InputEvent) -> void:
	print(event)
	pass # Replace with function body.
