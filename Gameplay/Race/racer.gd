class_name Racer
extends PathFollow2D

enum RACER_ATTRIBUTES {
	HEALTH,
	MAX_HEALTH,
	SPEED
}

signal lap_finished(racer: Racer, lap_number: int)

@export var config : RacerConfig

var current_lap_distance : float = 0.0
var current_lap : int = 1

var speed : float:
	get:
		# TODO: dynamic speed attribute
		return config.speed

var track : RaceTrack:
	get:
		return Game.race.track

func is_on_track() -> bool:
	return get_parent() == track

func is_in_the_pit() -> bool:
	# HACK:
	return not is_on_track()

func _ready() -> void:
	set_loop(true)
	set_rotates(true)
	pass

func _process(delta: float) -> void:
	process_movement(delta)

func process_movement(delta: float) -> void:
	var old_distance := current_lap_distance
	current_lap_distance += speed * delta
	
	while current_lap_distance > track.length:
		current_lap_distance -= track.length
		increment_lap()
	
	# TODO: move along path
	set_progress_ratio(current_lap_distance / Game.race.track.length)

func increment_lap() -> void:
	var finished_lap := current_lap
	current_lap += 1
	lap_finished.emit(self, finished_lap)
	print("lap ", current_lap)

#region Pit Stop

# HACK: this is temp code for pit stop prototype
var is_repaired : bool = false
var repair_time : float = 3.0

func repair() -> void:
	if is_repaired:
		return
	await get_tree().create_timer(repair_time).timeout
	is_repaired = true

func damage() -> void:
	is_repaired = false

#endregion
