class_name RacerPart
extends Node

@export var type : RacerConfig.RACER_PART

var durability : Attribute:
	get:
		return %Durability

# TODO: move decay speed here
# TODO: separate attribute for max durability?
