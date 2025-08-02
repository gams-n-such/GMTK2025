extends Node
class_name EnemyAI

var ai_config: AiConfig
var racer: Racer

func _ready() -> void:
	racer.in_pit.connect(entered_pit)

func _process(delta: float) -> void:
	racer.schedule_pit_stop()

func entered_pit() -> void:
	await get_tree().create_timer(ai_config.ai_pit_duration)
	for part in racer.all_parts:
		part.durability.add_instant(100)
