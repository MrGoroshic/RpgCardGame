extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.4

var enemy_deck = [1, 2, 3 ,4 , 5, 6, 7, 8, 9, 10]
var deck_position_x
var deck_position_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#deck_position_x = get_viewport().size.x / 12
	#deck_position_y = get_viewport().size.y - 110
	#position.x = deck_position_x
	#position.y = deck_position_y
	
	$RichTextLabel.text = str(enemy_deck.size())


func draw_card_enemy():
	var card_drawn = enemy_deck[0]
	enemy_deck.erase(card_drawn)
	
	# If player drew the last card in the deck, disable the deck
	if enemy_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(enemy_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../CardMeneger".add_child(new_card)
	new_card.name = "Card"
	add_card_enemy(new_card)


func add_card_enemy(card_for_add):
	var card_slot_found = $"../CardMeneger".raycast_check_for_card_slot()
	if card_slot_found and $"../CardSlotEnemy".enemy_card_in_slot.size() < 6:
		card_for_add.position = card_slot_found.position
		card_for_add.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.enemy_card_in_slot.push_back(card_for_add) 
		$"../CardSlotEnemy".enemy_card_value_in_slot += card_for_add.card_value
	else:
		$"../Enemy".enemy_action = false
