class_name RacerPool extends WeightedRandomPool

@export var racers : Array[RacerPoolEntry]

func get_entries() -> Array[WeightedRandomPoolEntry]:
	var result : Array[WeightedRandomPoolEntry]
	result.assign(racers)
	return result
