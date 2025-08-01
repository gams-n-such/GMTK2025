class_name Race
extends Node

@export_category("Race")
@export var config : RaceConfig

@export_category("Scenes")
@export var racer_scene : PackedScene = preload("res://Gameplay/Race/racer.tscn")
@export var racer_ai_scene: PackedScene = preload("res://Gameplay/Racer/enemy_ai.tscn")
@export var game_over_scene : PackedScene = preload("res://Gameplay/Race/game_over_screen.tscn")

var track : RaceTrack:
	get:
		return %RaceTrack

func _ready() -> void:
	Game.race = self
	if Game.queued_race_config:
		config = Game.queued_race_config
		#Game.queued_race_config = null
	
	prepare_race()
	# TODO: add pre-race scene
	
	var countdown = countdown_scene.instantiate()
	%UI.add_child(countdown)
	await countdown.finished
	
	start_race()

func _process(delta: float) -> void:
	sort_racers()
	%Scoreboard.update(racers)

func prepare_race() -> void:
	track.config = config.track
	
	spawn_player()
	
	if config.enable_ai_racers:
		spawn_ai_racers()

#region Racers

var racers : Array[Racer]

func spawn_player() -> Racer:
	var new_racer : Racer = spawn_racer(Game.player_id, Game.player_config)
	Game.player = new_racer
	Game.player.state_changed.connect(_on_player_state_changed)
	new_racer.z_index = 1
	return new_racer

func spawn_ai_racers() -> void:
	for preset in config.ai_racers:
		var racer := spawn_racer(preset.id, preset.racer_config)
		var enemy_ai := racer_ai_scene.instantiate() as EnemyAI
		# TODO: spawning default aiconfig atm
		enemy_ai.ai_config = AiConfig.new()
		enemy_ai.racer = racer
		racer.add_child(enemy_ai)

func spawn_racer(id : RacerId, config: RacerConfig) -> Racer:
	var new_racer : Racer = racer_scene.instantiate()
	new_racer.id = id
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
	var game_over_screen = game_over_scene.instantiate()
	game_over_screen.player_won = get_player_position_on_track() == 1
	%UI.add_child(game_over_screen)

func get_player_position_on_track() -> int:
	return racers.reduce(func(accum: int, racer: Racer) -> int:
		if Game.player == racer:
			return accum + 1
		
		var overall_player_distance: float = Game.player.current_lap * Game.race.track.length + Game.player.current_lap_distance
		var overall_racer_distance: float = racer.current_lap * Game.race.track.length + racer.current_lap_distance
		
		return accum + 1 if overall_racer_distance > overall_player_distance else accum
	, 0)

func sort_racers() -> void:
	racers.sort_custom(func(left: Racer, right: Racer) -> bool:
		var left_distance: float = left.current_lap * Game.race.track.length + left.current_lap_distance
		var right_distance: float = right.current_lap * Game.race.track.length + right.current_lap_distance
		return left_distance > right_distance
		)

func _on_player_state_changed(racer: Racer, new_state: Racer.RacerState) -> void:
	if racer.is_on_pit_stop():
		%GameplayUI.enter_pit_mode()
	%PitBG.visible = racer.is_on_pit_stop()
	%RaceBG.visible = not %PitBG.visible

#endregion
