class_name Race
extends Node

@export_category("Race")
@export var config : RaceConfig

@export_category("Scenes")
@export var racer_scene : PackedScene = preload("res://Gameplay/Race/racer.tscn")
@export var game_over_scene : PackedScene = preload("res://Gameplay/Race/game_over_screen.tscn")


var track : RaceTrack:
	get:
		return %RaceTrack

func _ready() -> void:
	Game.race = self
	if Game.queued_race_config:
		config = Game.queued_race_config
		Game.queued_race_config = null
	
	prepare_race()
	# TODO: add pre-race scene
	
	var countdown = countdown_scene.instantiate()
	%UI.add_child(countdown)
	await countdown.finished
	
	start_race()

func prepare_race() -> void:
	track.config = config.track
	
	spawn_player()
	
	var enemy_configs := generate_random_racers(config.num_opponents)
	for enemy_config in enemy_configs:
		spawn_racer(enemy_config)

#region Racers

var racers : Array[Racer]

func generate_random_racers(num_racers: int) -> Array[RacerConfig]:
	var result : Array[RacerConfig]
	for enemy_idx in range(num_racers):
		result.append(generate_random_racer())
	return result

func generate_random_racer() -> RacerConfig:
	# TODO: implement
	var result_config := RacerConfig.new()
	
	result_config.speed = randfn(Game.player.speed, 0.5)
	print(result_config.speed)
	
	return result_config

func spawn_player() -> Racer:
	var new_racer : Racer = spawn_racer(Game.player_config)
	Game.player = new_racer
	return new_racer

func spawn_racer(config: RacerConfig) -> Racer:
	var new_racer : Racer = racer_scene.instantiate()
	new_racer.config = config
	new_racer.lap_finished.connect(on_racer_lap_finished)
	racers.append(new_racer)
	track.add_child(new_racer)
	return new_racer

#endregion

#region Countdown

var countdown_scene : PackedScene = preload("res://Gameplay/Race/countdown.tscn")

#endregion

#region Race

func start_race() -> void:
	track.process_mode = Node.PROCESS_MODE_INHERIT

func on_racer_lap_finished(racer: Racer, lap_number: int) -> void:
	if lap_number == config.num_laps and racer == Game.player:
		end_race()

func end_race() -> void:
	# TODO: remove on release 
	print("Race finished")
	print("Player finished in ", get_player_position_on_track(), " place")
	track.process_mode = Node.PROCESS_MODE_DISABLED
	# TODO: move to Game class
	# TODO: detect win/lose
	var game_over_screen = game_over_scene.instantiate()
	game_over_screen.player_won = get_player_position_on_track() == 1
	%UI.add_child(game_over_screen)

func get_player_position_on_track() -> int:
	return racers.reduce(func(accum: int, racer: Racer) -> int:
		if Game.player == racer:
			return accum + 1
		if Game.player.current_lap < racer.current_lap:
			return accum + 1
		elif Game.player.current_lap == racer.current_lap and Game.player.current_lap_distance < racer.current_lap_distance:
			return accum + 1
		else:
			return accum
	, 0)

#endregion
