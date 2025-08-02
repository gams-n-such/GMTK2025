class_name RacerPartStatusControl
extends Control

@export var part_type : Enum.RACER_PART

var racer : Racer:
	get:
		return racer
	set(new_racer):
		racer = new_racer
		part = racer.get_part(part_type)

var part : RacerPart:
	get:
		return part
	set(new_part):
		if part:
			part.durability_changed.disconnect(_on_part_durability_changed)
		part = new_part
		if part:
			part.durability_changed.connect(_on_part_durability_changed)

var durability : float:
	get:
		return part.durability.value

func _ready() -> void:
	# HACK:
	await get_tree().create_timer(0.5).timeout
	racer = Game.player
	update_visuals()

func _process(delta: float) -> void:
	pass

func _on_part_durability_changed(part: RacerPart, new_value: float) -> void:
	update_visuals()

var part_names : Dictionary[Enum.RACER_PART, String] = {
	Enum.RACER_PART.RIDER: "Rider",
	Enum.RACER_PART.PONY: "Pony",
	Enum.RACER_PART.CHARIOT: "Cart",
	Enum.RACER_PART.WHEELS: "Wheels",
	Enum.RACER_PART.HORSESHOE: "H-shoes",
}

func update_visuals() -> void:
	# TODO: use sprite + color
	
	%DurabilityLabel.text = "%s: %s" % [part_names[part_type], int(durability)]
