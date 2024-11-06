extends Node2D

const CARD_VETERAN_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_ARCHER_SCENE_PATH = "res://Scenes/CardArcher.tscn"
const CARD_KNIGHT_SCENE_PATH = "res://Scenes/CardKnight.tscn"
const CARD_DRAW_SPEED = 0.4

var player_deck = [1, 2, 3 ,4, 5, 6, 7, 8, 9, 10]
var deck_position_x
var deck_position_y
var scene_paths = [CARD_VETERAN_SCENE_PATH, CARD_ARCHER_SCENE_PATH, CARD_KNIGHT_SCENE_PATH]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_position_x = get_viewport().size.x / 12
	deck_position_y = get_viewport().size.y - 110
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
	var random_index = randi() % scene_paths.size()
	var card_scene = load(scene_paths[random_index])
	var new_card = card_scene.instantiate()
	$"../CardMeneger".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
