class_name RaceTrack
extends Path2D

@export var config : TrackConfig

var length : float:
	get:
		# TODO: use curve.get_baked_length()
		return config.track_length

func _ready() -> void:
	_cached_pit_length = pit_track.curve.get_baked_length() / curve.get_baked_length() * config.track_length
	_cached_pit_enter = calc_pit_enter_offset()
	_cached_pit_exit = calc_pit_exit_offset()


func _process(delta: float) -> void:
	pass


#region Pit

@onready var pit_track : Path2D = %PitTrack

var _cached_pit_length : float
var pit_track_length : float:
	get:
		return _cached_pit_length

var _cached_pit_enter : float
var pit_enter : float:
	get:
		return _cached_pit_enter

var _cached_pit_exit : float
var pit_exit : float:
	get:
		return _cached_pit_exit

func calc_pit_enter_offset() -> float:
	var pit_enter_position : Vector2 = pit_track.curve.get_point_position(0)
	return curve.get_closest_offset(pit_enter_position)

func calc_pit_exit_offset() -> float:
	var last_point_idx : int = pit_track.curve.point_count - 1
	var pit_exit_position : Vector2 = pit_track.curve.get_point_position(last_point_idx)
	return curve.get_closest_offset(pit_exit_position)
	
#endregion
