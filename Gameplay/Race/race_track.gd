class_name RaceTrack
extends Path2D

@export var config : TrackConfig

var length : float:
	get:
		# TODO: use curve.get_baked_length()
		return config.track_length

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
