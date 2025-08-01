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
	var old_distance: float
	if is_in_pit_lane():
		old_distance = current_pit_track_distance
		current_pit_track_distance += track.pit_speed * delta
		set_progress_ratio(current_pit_track_distance / track.pit_length)
		
		if old_distance < track.pit_length/2 and track.pit_length/2 < current_pit_track_distance:
			in_pit.emit()
	else: 
		old_distance = current_lap_distance
		current_lap_distance += speed * delta
		set_progress_ratio(current_lap_distance / track.length)
	
	while current_lap_distance > track.length:
		current_lap_distance -= track.length
		increment_lap()
	
	# TODO: move along path
	if wants_pit_stop():
		var pit_entry_lap_distance := track.curve.get_closest_offset(track.curve.get_point_position(track.pit_entry_idx)) / track.curve.get_baked_length() * track.length
		if old_distance <= pit_entry_lap_distance and pit_entry_lap_distance <= current_lap_distance:
			var distance_to_pit_entry := pit_entry_lap_distance - old_distance
			var delta_in_pit := delta - distance_to_pit_entry / speed
			
			transition_to_pit_track(delta_in_pit)
	
	if is_in_pit_lane() and current_pit_track_distance > track.pit_length:
		var delta_in_track := (current_pit_track_distance - track.pit_length) / track.pit_speed
		
		transition_from_pit_track(delta_in_track)


func increment_lap() -> void:
	var finished_lap := current_lap
	current_lap += 1
	lap_finished.emit(self, finished_lap)
	print("lap ", current_lap)

#region Pit Stop
var current_pit_track_distance: float = 0.0
var heading_for_pit : bool = false
var in_pit_lane: bool = false

signal in_pit

func wants_pit_stop() -> bool:
	return heading_for_pit

func is_in_pit_lane() -> bool:
	return in_pit_lane

func schedule_pit_stop() -> void:
	if (not in_pit_lane):
		heading_for_pit = true

func transition_to_pit_track(delta: float) -> void:
	heading_for_pit = false
	in_pit_lane = true
	
	reparent(track.pit_track)
	
	current_pit_track_distance = 0.0
	process_movement(delta)

func transition_from_pit_track(delta: float) -> void:
	in_pit_lane = false
	
	reparent(Game.race.track)
	
	current_lap_distance = track.curve.get_closest_offset(track.curve.get_point_position(track.pit_exit_idx)) / track.curve.get_baked_length() * track.length
	process_movement(delta)

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
