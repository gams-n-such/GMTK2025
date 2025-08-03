extends Node2D
class_name FeedRider

@export var relation_table: Dictionary[Resource, Resource] = {
	preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Call.svg"): preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Cap.svg"),
	preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Fist.svg"): preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Mug.svg"),
	preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Palm.svg"): preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Lolipop.svg"),
	preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Peace.svg"): preload("res://Gameplay/Mini Games/Assets/Rider/MG_Rider_Pipe.svg"),
}
@export var sprite_width: float = 100.0

class Combination:
	var sign: Sprite2D
	var item: Dragable
	var starting_pos: Vector2
	
	func _init(_sign: Sprite2D, _item: Dragable):
		sign = _sign
		item = _item

var combinations: Array[Combination]
var current_idx: int

func _ready() -> void:
	fill_combinations_arr()
	position_items_along_buttom()
	update_current_idx()
	draw_clues()

func draw_clues() -> void:
	var w_offset: float = 100.0
	var h_offset: float = 60.0
	var start_pos : Vector2 = %CluePos.position
	
	for key in relation_table.keys():
		var key_sprite := Sprite2D.new()
		key_sprite.texture = key
		resize(key_sprite, 0.5)
		key_sprite.position = start_pos
		var val_sprite := Sprite2D.new()
		val_sprite.texture = relation_table[key]
		resize(val_sprite, 0.5)
		val_sprite.position = start_pos + Vector2(w_offset, 0.0)
		self.add_child(key_sprite)
		self.add_child(val_sprite)
		start_pos += Vector2(0.0, h_offset)

func fill_combinations_arr() -> void:
	for key in relation_table.keys():
		var sign := Sprite2D.new()
		sign.texture = key
		resize(sign, 1.0)
		var item := Dragable.new()
		item.input_pickable = true
		item.hover_changed.connect(on_hover_changed)
		var item_sprite := Sprite2D.new()
		item.add_child(item_sprite)
		item_sprite.texture = relation_table[key]
		resize(item_sprite, 1.0)
		var item_collision_shape := CollisionShape2D.new()
		item.add_child(item_collision_shape)
		item_collision_shape.shape = CircleShape2D.new()
		item_collision_shape.shape.set_radius(sprite_width * .7)
		combinations.append(Combination.new(sign, item))
		self.add_child(item)

func position_items_along_buttom() -> void:
	var current_pos = %StartPos.position
	for combination in combinations:
		combination.item.position = current_pos
		combination.starting_pos = current_pos
		current_pos += Vector2(sprite_width + 50.0, 0.0)

func update_current_idx() -> void:
	if combinations.is_empty():
		self.queue_free()
		return
	current_idx = randi_range(0, combinations.size() - 1)
	%SignPos.add_child(combinations[current_idx].sign)

func resize(sprite: Sprite2D, factor: float) -> void:
	var ratio: float = sprite_width / sprite.texture.get_width()
	sprite.set_scale(Vector2(ratio * factor, ratio * factor))

func on_hover_changed(node: Dragable, new_value: bool) -> void:
	for child in node.get_children():
		if child is Sprite2D:
			resize(child, 1.3 if new_value == true else 1.0)

func _on_food_reciever_area_entered(area: Area2D) -> void:
	if area is Dragable and area == combinations[current_idx].item:
		combinations[current_idx].item.queue_free()
		combinations[current_idx].sign.queue_free()
		combinations.remove_at(current_idx)
		%PopSound.play()
		update_current_idx()
