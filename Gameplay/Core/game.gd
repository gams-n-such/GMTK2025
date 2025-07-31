extends Node

@export_category("Scenes")
@export var main_menu_scene : PackedScene = preload("res://MainMenu/main_menu.tscn")
@export var race_scene : PackedScene = preload("res://Gameplay/Race/race.tscn")


@export_category("Game")
@export var player_config : RacerConfig
# TODO: remove
@export var test_race : RaceConfig

var race : Race
# HACK: just so we can use change_scene_to_packed()
var queued_race_config : RaceConfig
var player : Racer


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func return_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
	race = null

func start_test_race() -> void:
	start_race(test_race)

func start_race(config: RaceConfig) -> void:
	if config == null:
		push_error("Can't start race without valid race config")
		return
	queued_race_config = config
	get_tree().change_scene_to_packed(race_scene)
