extends HBoxContainer
class_name ScoreboardRow

func update(racer: Racer, position: int) -> void:
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = racer.id.color
	%Color.add_theme_stylebox_override("panel", style_box)
	%Name.text = racer.id.name
	%Lap.text = str(racer.current_lap)
	%Position.text = str(position)
