class_name Race
extends Node

@export_category("Race")
@export var config : RaceConfig

var track : RaceTrack:
	get:
		return %RaceTrack

func _ready() -> void:
	prepare_race()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func prepare_race() -> void:
	pass

func start_countdown() -> void:
	pass

func on_countdown_finished() -> void:
	pass


func start_race() -> void:
	# TODO: enable process for racers
	pass
