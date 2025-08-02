class_name Racer
extends PathFollow2D

enum RACER_ATTRIBUTES {
	HEALTH,
	MAX_HEALTH,
	SPEED
}

signal lap_finished(racer: Racer, lap_number: int)

@export var id : RacerId
@export var config : RacerConfig

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


#region RacerState

enum RacerState {
	RACE,
	PIT_LANE,
	PIT_STOP,
}

var _current_state := RacerState.RACE
var current_state : RacerState:
	get:
		return _current_state
	set(new_state):
		if _current_state != new_state:
			_current_state = new_state
			state_changed.emit(self, new_state)
			if new_state == RacerState.PIT_STOP:
				in_pit.emit()

signal state_changed(racer: Racer, new_state: RacerState)

#endregion

#region Parts

var _cached_parts : Dictionary[Enum.RACER_PART, RacerPart]
var all_parts : Array[RacerPart]:
	get:
		return _cached_parts.values()

func init_parts() -> void:
	if not _cached_parts.is_empty():
		return
	for child in %Parts.get_children():
		assert(child is RacerPart)
		var part := child as RacerPart
		part.durability.max_value = config.parts_durability[part.type]
		part.repair()
		_cached_parts.set(part.type, part)

func get_part(type: Enum.RACER_PART) -> RacerPart:
	return all_parts[type]

#endregion


func is_on_track() -> bool:
	return current_state == RacerState.RACE

func is_in_the_pit() -> bool:
	return current_state == RacerState.PIT_LANE or current_state == RacerState.PIT_STOP

func is_on_pit_stop() -> bool:
	return current_state == RacerState.PIT_STOP

func _ready() -> void:
	assert(config != null)
	# HACK: use sprite
	$TempVisual.color = id.color
	init_parts()
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
	
	for part in all_parts:
		var decay := config.parts_decay_speed[part.type] * delta
		part.durability.add_instant(-decay)
		decay_factor += part.durability.value
		if (part.durability.value <= 0.0):
			# TODO: add attribute signal for min value hit
			critical_damage = true
	
	if (critical_damage):
		decay_factor = 0.0
	else:
		# TODO: calc actual total durability
		decay_factor /= all_parts.size() * 100.0

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
		current_state = RacerState.PIT_STOP
	
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
	Game.message_system.send_message(msg)

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

func end_pit_stop() -> void:
	current_state = RacerState.PIT_LANE

# HACK: this is temp code for pit stop prototype
func repair(part: Enum.RACER_PART, val: float) -> void:
	get_part(part).durability.add_instant(val)

#endregion
