class_name Racer
extends Node

signal lap_finished(racer: Racer, lap_number: int)

@export var config : RacerConfig

var current_lap_distance : float = 0.0
var current_lap : int = 1

var speed : float:
	get:
		return config.speed

var track : RaceTrack:
	get:
		return Game.race.track

func _ready() -> void:
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

func increment_lap() -> void:
	var finished_lap := current_lap
	current_lap += 1
	lap_finished.emit(self, finished_lap)
