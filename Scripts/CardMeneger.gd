extends Node2D

const COLISION_MASC_CARD = 1
const COLISION_MASC_CARD_SLOT = 2 
const DEFAULT_CARD_MOVE_SPEED = 0.1

var screen_size
var card_deing_dragged
var is_hovering_on_card
var player_hand_reference
var card_scale_hovered = 0.65
var card_scale_hovered_off = 0.6

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if card_deing_dragged:
		var mouse_pos =  get_global_mouse_position()
		card_deing_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))


func start_drag(card):
	card_deing_dragged = card
	card.scale = Vector2(card_scale_hovered_off, card_scale_hovered_off)


func finish_drag():
	card_deing_dragged.scale = Vector2(card_scale_hovered, card_scale_hovered)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and $"../CardSlotPlayer".card_in_slot.size() < 6:
		player_hand_reference.remove_card_from_hand(card_deing_dragged)
		# Card dropped in empty card slot
		card_deing_dragged.position = card_slot_found.position
		card_deing_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot.push_back(card_deing_dragged) 
		$"../CardSlotPlayer".card_value_in_slot += card_deing_dragged.card_value
		card_slot_found.update_hand_position()
		$"../Enemy".enemy_action = true
		$"../Enemy".enemy_move()
	else:
		player_hand_reference.add_card_to_hand(card_deing_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_deing_dragged = null


func connect_card_signal(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_left_click_released():
	if card_deing_dragged:
		finish_drag()


func on_hovered_over_card(card):
	if !card_deing_dragged:
		is_hovering_on_card = true
		highlight_card(card, true)


func on_hovered_off_card(card):
	if !card_deing_dragged:
		highlight_card(card, false)
		# проверка, на не переключение на другую карту
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false


func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(card_scale_hovered, card_scale_hovered)
		card.z_index = 2
	else:
		card.scale = Vector2(card_scale_hovered_off, card_scale_hovered_off)
		card.z_index = 1


func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLISION_MASC_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return result[0].collider.get_parent()
	return null


func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLISION_MASC_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null


func get_card_with_highest_z_index(cards):
	# предположим, что первая карта в массиве cards имеет самый высокий z-индекс
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	#просмотрите остальные карточки, если они имеют более высокий z-индекс
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
