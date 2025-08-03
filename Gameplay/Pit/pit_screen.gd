extends Node2D
class_name PitScreen

var active_mini_game_ui: MiniGameUi = null

func start_mini_game(scene: PackedScene, part: Enum.RACER_PART)-> void:
	active_mini_game_ui = preload("res://Gameplay/Mini Games/mini_game_ui.tscn").instantiate()
	active_mini_game_ui.game_ended.connect(on_game_ended)
	active_mini_game_ui.init_game(scene, part)
	active_mini_game_ui.set_anchors_preset(Control.PRESET_CENTER)
	get_parent().add_child(active_mini_game_ui)
	set_btn_visibility(false)

func on_game_ended(completed: bool, part: Enum.RACER_PART) -> void:
	active_mini_game_ui.game_ended.disconnect(on_game_ended)
	active_mini_game_ui = null
	
	if completed: 
		Game.player.repair(part, 100)
	
	set_btn_visibility(true)

func set_btn_visibility(is_visible: bool) -> void:
	for child in %Pit.get_children():
		if child is StartMiniGameBtn:
			child.visible = is_visible

func _on_visibility_changed() -> void:
	if active_mini_game_ui:
		active_mini_game_ui.game_ended.disconnect(on_game_ended)
		active_mini_game_ui.queue_free()
		active_mini_game_ui = null
