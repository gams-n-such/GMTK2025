class_name RaceConfig
extends Resource


@export_category("Race")
@export var num_laps : int = 5
@export var track : TrackConfig

@export_category("Racers")
@export var enable_ai_racers : bool = true
@export var ai_racers : Array[AiRacerPreset]
