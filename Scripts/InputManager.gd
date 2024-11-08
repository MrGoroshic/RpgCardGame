extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLISION_MASC_CARD = 1
const COLISION_MASC_DECK = 4 

var card_manager_reference
var deck_reference

func _ready() -> void:
	card_manager_reference = $"../CardMeneger"
	deck_reference = $"../DeckPlayer"


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")


func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var rezult_collision_mask = result[0].collider.collision_mask
		if rezult_collision_mask == COLISION_MASC_CARD:
			# Card clicked
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager_reference.start_drag(card_found)
		elif rezult_collision_mask == COLISION_MASC_DECK:
			# Deck clicked
			deck_reference.draw_card()
