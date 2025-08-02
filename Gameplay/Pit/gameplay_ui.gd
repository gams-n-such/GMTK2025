extends Control

@export var pause_scene = preload("res://Gameplay/Race/pause_screen.tscn")
var active_mini_game_ui: MiniGameUi = null

func _ready() -> void:
	pass

func start_mini_game(scene: PackedScene, part: Enum.RACER_PART)-> void:
	%VBoxContainer.set_visible(false)
	active_mini_game_ui = preload("res://Gameplay/Mini Games/mini_game_ui.tscn").instantiate()
	active_mini_game_ui.game_ended.connect(on_game_ended)
	active_mini_game_ui.init_game(scene, part)
	active_mini_game_ui.set_anchors_preset(Control.PRESET_CENTER)
	self.add_child(active_mini_game_ui)

func on_game_ended(completed: bool, part: Enum.RACER_PART) -> void:
	%VBoxContainer.set_visible(true)
	
	if completed: 
		Game.player.repair(part, 100)
	
	#if completed:
		#var index = %VBoxContainer.get_children().find_custom(func(btn: StartMiniGameBtn): return btn.part == part)
		#%VBoxContainer.get_children()[index].set_disabled(true)
	#
	#if completed:
		#print("completed ", Enum.RACER_PART.keys()[part])
	#else:
		#print("gave up ", Enum.RACER_PART.keys()[part])
		#


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
	#Game.player.process_mode = Node.PROCESS_MODE_DISABLED
	
	%PitScreen.visible = true
	%PitEndButton.disabled = false

func _on_repair_button_pressed() -> void:
	for key in Enum.RACER_PART.values():
		Game.player.repair(key, 100)

func exit_pit_mode() -> void:
	#Game.player.process_mode = Node.PROCESS_MODE_INHERIT
	Game.player.end_pit_stop()
	enter_race_mode()
