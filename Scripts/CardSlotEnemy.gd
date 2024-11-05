extends Node2D

const CARD_WIDTH = 120
const DEFAULT_CARD_MOVE_SPEED = 0.1

#var card_in_slot = false
var enemy_card_in_slot = []
var center_screen_x
var hand_y_position
var enemy_card_value_in_slot = 0

func _ready() -> void:
	center_screen_x = global_position.x
	hand_y_position = global_position.y

func update_hand_position():
	for i in range(enemy_card_in_slot.size()):
		# Get new card position based on index
		var new_position = Vector2(calculate_card_position(i), hand_y_position)
		var card = enemy_card_in_slot[i]
		card.starting_hand_position = new_position
		animate_card_to_position(card, new_position, DEFAULT_CARD_MOVE_SPEED)
		
func calculate_card_position(index):
	var total_width = (enemy_card_in_slot.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
