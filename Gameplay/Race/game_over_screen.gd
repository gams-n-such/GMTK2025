extends Control

var player_won : bool = true

func _ready() -> void:
	%WinScreen.visible = player_won
	%LoseScreen.visible = not player_won

func _on_continue_button_pressed() -> void:
	Game.return_to_main_menu()
	queue_free()
