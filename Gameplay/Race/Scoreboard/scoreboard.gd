extends Control
class_name Scoreboard

var scoreboard_row_scene: PackedScene = preload("res://Gameplay/Race/Scoreboard/scoreboard_row.tscn")

func update(racers: Array[Racer]) -> void:
	while %VBoxContainer.get_child_count() < racers.size():
		var row_instance = scoreboard_row_scene.instantiate()
		%VBoxContainer.add_child(row_instance)
	
	while %VBoxContainer.get_child_count() > racers.size():
		%VBoxContainer.get_child(0).queue_free()
	
	for i in racers.size():
		(%VBoxContainer.get_child(i) as ScoreboardRow).update(racers[i])
