class_name RacerConfig
extends Resource

enum HPType {
	RIDER = 0,
	PONY = 1,
	CHARIOT = 2,
	WHEELS = 3,
	HORSESHOE = 4,
}

@export var speed : float = 10.0
@export var limp_speed: float = 1.0
#TODO: might want to add @export but i would rather not
var hp_arr: Array[float] = [100.0, 100.0, 100.0, 100.0, 100.0]
@export var hp_decay_speed_arr: Array[float] = [1.0, 1.0, 1.0, 1.0, 1.0]
