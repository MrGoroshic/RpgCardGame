extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.4

var player_deck = ["Knight", "Knight", "Knight"]
var deck_position_x
var deck_position_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_position_x = get_viewport().size.x / 12
	deck_position_y = get_viewport().size.y - 120
	position.x = deck_position_x
	position.y = deck_position_y
	
	$RichTextLabel.text = str(player_deck.size())


func draw_card():
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	# If player drew the last card in the deck, disable the deck
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../CardMeneger".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
