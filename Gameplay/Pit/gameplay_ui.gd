extends Control


@export var pause_scene : PackedScene = preload("res://Gameplay/Race/pause_screen.tscn")

#TODO: determine if this should stay as is
var active_mini_game = preload("res://Gameplay/Mini Games/mini_game_ui.tscn")

func _ready() -> void:
	self.add_child(active_mini_game.instantiate())
	self.get_children().back().game_ended.connect(on_game_ended)
	enter_race_mode()

func on_game_ended(completed: bool) -> void:
	print(completed)

func _process(delta: float) -> void:
	pass

func enter_race_mode() -> void:
	%RacingScreen.visible = true

func _unhandled_input(event: InputEvent) -> void:
	# TODO: don't use built-in action?
	if event.is_action_pressed("pause"):
		var pause_screen = pause_scene.instantiate()
		add_child(pause_screen)

func _on_pit_start_button_pressed() -> void:
	# TODO: wait until racer reaches the pit
	Game.player.schedule_pit_stop()

func _on_pit_end_button_pressed() -> void:
	exit_pit_mode()

func enter_pit_mode() -> void:
	Game.player.process_mode = Node.PROCESS_MODE_DISABLED
	
	%PitScreen.visible = true
	%PitEndButton.disabled = true

func _on_repair_button_pressed() -> void:
	try_repair()

func try_repair() -> void:
	await Game.player.repair()
	%PitEndButton.disabled = false

func exit_pit_mode() -> void:
	Game.player.process_mode = Node.PROCESS_MODE_INHERIT
	enter_race_mode()
	# HACK: Pit prototype
	Game.player.damage()
