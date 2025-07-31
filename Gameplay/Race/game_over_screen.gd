extends Control

@onready var player_won: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _enter_tree() -> void:
	if (player_won):
		%Label.text = "You won!"
	else:
		%Label.text = "You lost!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	Game.return_to_main_menu()
	queue_free()
