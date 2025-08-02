class_name Racer
extends PathFollow2D

enum RACER_ATTRIBUTES {
	HEALTH,
	MAX_HEALTH,
	SPEED
}

enum RacerState {
	RACE,
	PIT_LANE,
	PIT_STOP,
}

signal lap_finished(racer: Racer, lap_number: int)

@export var id : RacerId
@export var config : RacerConfig

var current_state: = RacerState.RACE
var current_lap_distance : float = 0.0
var current_lap : int = 1
var decay_factor: float = 1.0

var speed : float:
	get:
		# TODO: dynamic speed attribute
		return config.speed

var limp_speed: float:
	get:
		return config.limp_speed

var track : RaceTrack:
	get:
		return Game.race.track

var rider_hp: float:
	get:
		return config.hp_arr[config.RACER_PART.RIDER]

var pony_hp: float:
	get:
		return config.hp_arr[config.RACER_PART.PONY]

var chariot_hp: float:
	get:
		return config.hp_arr[config.RACER_PART.CHARIOT]

var wheels_hp: float:
	get:
		return config.hp_arr[config.RACER_PART.WHEELS]

var horseshoe_hp: float:
	get:
		return config.hp_arr[config.RACER_PART.HORSESHOE]


func is_on_track() -> bool:
	return get_parent() == track

func is_in_the_pit() -> bool:
	# HACK:
	return not is_on_track()

func _ready() -> void:
	# HACK: use sprite
	$TempVisual.color = id.color
	pass

func _process(delta: float) -> void:
	match current_state:
		RacerState.RACE:
			update_hp(delta)
			process_RACE(delta)
		RacerState.PIT_LANE:
			process_PIT_LANE(delta)
		RacerState.PIT_STOP:
			process_PIT_STOP(delta)
		_:
			push_error("Unreachable racer state")

func update_hp(delta: float) -> void:
	var critical_damage: bool = false
	decay_factor = 0.0
	
	for i in config.hp_arr.size():
		config.hp_arr[i] -= config.hp_decay_speed_arr[i] * delta
		decay_factor += config.hp_arr[i]
		if (config.hp_arr[i] <= 0.0):
			critical_damage = true
			config.hp_arr[i] = 0.0
	
	if (critical_damage):
		decay_factor = 0.0
	else:
		decay_factor /= config.hp_arr.size() * 100.0

func process_RACE(delta: float) -> void:
	var old_distance := current_lap_distance
	current_lap_distance += maxf(speed * decay_factor, limp_speed) * delta
	set_progress_ratio(current_lap_distance / track.length)
	
	while current_lap_distance > track.length:
		current_lap_distance -= track.length
		increment_lap()
	
	if wants_pit_stop():
		var pit_entry_lap_distance := track.curve.get_closest_offset(track.curve.get_point_position(track.pit_entry_idx)) / track.curve.get_baked_length() * track.length
		if old_distance < pit_entry_lap_distance and pit_entry_lap_distance <= current_lap_distance:
			var distance_to_pit_entry := pit_entry_lap_distance - old_distance
			var delta_in_pit := delta - distance_to_pit_entry / speed
			
			transition_to_pit_track(delta_in_pit)

func process_PIT_LANE(delta: float) -> void:
	var old_distance := current_pit_track_distance
	current_pit_track_distance += track.pit_speed * delta
	set_progress_ratio(current_pit_track_distance / track.pit_length)
		
	if old_distance < track.pit_length/2 and track.pit_length/2 <= current_pit_track_distance:
		# TODO: pitstop transition
		#current_state = RacerState.PIT_STOP
		in_pit.emit()
	
	if current_pit_track_distance > track.pit_length:
		var delta_in_track := (current_pit_track_distance - track.pit_length) / track.pit_speed
		
		transition_from_pit_track(delta_in_track)

func process_PIT_STOP(delta: float) -> void:
	pass

func increment_lap() -> void:
	var finished_lap := current_lap
	current_lap += 1
	lap_finished.emit(self, finished_lap)
	var msg: Message = Message.new()
	msg.description = str("lap ", current_lap)
	Game.message_system.send_message(msg)
	#print("lap ", current_lap)

#region Pit Stop
var current_pit_track_distance: float = 0.0
var heading_for_pit : bool = false

signal in_pit

func wants_pit_stop() -> bool:
	return heading_for_pit

func schedule_pit_stop() -> void:
	if (current_state == RacerState.RACE):
		heading_for_pit = true

func transition_to_pit_track(delta: float) -> void:
	current_state = RacerState.PIT_LANE
	heading_for_pit = false
	
	reparent(track.pit_track)
	
	current_pit_track_distance = 0.0
	process_PIT_LANE(delta)

func transition_from_pit_track(delta: float) -> void:
	current_state = RacerState.RACE
	
	reparent(track)
	
	current_lap_distance = track.curve.get_closest_offset(track.curve.get_point_position(track.pit_exit_idx)) / track.curve.get_baked_length() * track.length
	process_RACE(delta)

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
