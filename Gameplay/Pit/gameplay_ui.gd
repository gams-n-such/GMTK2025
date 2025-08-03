extends Control

@export var pause_scene = preload("res://Gameplay/Race/pause_screen.tscn")

func _ready() -> void:
	pass

#maxf(speed * decay_factor, limp_speed)

func _process(delta: float) -> void:
	var speed = maxf(Game.player.speed * Game.player.decay_factor, Game.player.limp_speed)
	%Speed.text = "%d dm/s" %speed
	Game.race.sort_racers()
	%Scoreboard.update(Game.race.racers)

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
	%PitScreen.visible = true
	%PitEndButton.disabled = false

func _on_repair_button_pressed() -> void:
	for key in Enum.RACER_PART.values():
		Game.player.repair(key, 100)

func exit_pit_mode() -> void:
	#Game.player.process_mode = Node.PROCESS_MODE_INHERIT
	Game.player.end_pit_stop()
	enter_race_mode()


func _on_pit_screen_mini_game_started() -> void:
	%MinigameBlur.visible = true


func _on_pit_screen_mini_game_ended() -> void:
	%MinigameBlur.visible = false
