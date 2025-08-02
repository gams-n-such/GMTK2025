class_name RacerPart
extends Node

@export var type : RacerConfig.RACER_PART

var durability : Attribute:
	get:
		return %Durability

# TODO: move decay speed here
# TODO: add separate attribute for max durability?

# TODO: add old_value?
signal durability_changed(part: RacerPart, new_value: float)

func _on_durability_value_changed(attribute: Attribute, new_value: float) -> void:
	durability_changed.emit(self, new_value)

func repair() -> void:
	durability.add_instant(durability.max_value)
