class_name RaceTrack
extends Path2D

@export var config : TrackConfig

var length : float:
	get:
		# TODO: use curve.get_baked_length()
		return config.track_length

func _ready() -> void:
	attach_pit_to_track()

func _process(delta: float) -> void:
	pass


#region Pit

@onready var pit_track : Path2D = %PitTrack

var pit_entry_idx: int
var pit_exit_idx: int

var pit_length : float:
	get:
		return config.pit_track_length

var pit_speed : float:
	get:
		return config.pit_track_speed

func attach_pit_to_track() -> void:
	var get_closest_point_index := func(curve: Curve2D, closest_to: Vector2) -> int:
		var closest_i = 0
		var closest_dist_sqrd = curve.get_point_position(0).distance_squared_to(closest_to)
		
		for i in range(1, curve.point_count):
			var dist_sqrd = curve.get_point_position(i).distance_squared_to(closest_to)
			if dist_sqrd < closest_dist_sqrd:
				closest_i = i
				closest_dist_sqrd = dist_sqrd
		
		return closest_i
	
	pit_entry_idx = get_closest_point_index.call(self.curve, pit_track.curve.get_point_position(0))
	pit_exit_idx = get_closest_point_index.call(self.curve, pit_track.curve.get_point_position(pit_track.curve.point_count - 1))
	
	pit_track.curve.add_point(self.curve.get_point_position(pit_entry_idx), self.curve.get_point_position(pit_entry_idx), pit_track.curve.get_point_in(0), 0)
	pit_track.curve.add_point(self.curve.get_point_position(pit_exit_idx), pit_track.curve.get_point_in(pit_track.curve.point_count - 1), self.curve.get_point_in(pit_exit_idx))

#endregion
