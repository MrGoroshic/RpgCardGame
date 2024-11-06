extends Node2D

var enemy_action = false

func enemy_move():
	if enemy_action:
		$"../DeckEnemy".draw_card_enemy()
		enemy_action = false
	if $"../CardSlotEnemy".enemy_card_in_slot.size() == 6:
		if $"../CardSlotPlayer".card_value_in_slot == $"../CardSlotEnemy".enemy_card_value_in_slot:
			$"../draw".visible = true
		elif $"../CardSlotPlayer".card_value_in_slot > $"../CardSlotEnemy".enemy_card_value_in_slot:
			$"../win".visible = true
		elif $"../CardSlotPlayer".card_value_in_slot < $"../CardSlotEnemy".enemy_card_value_in_slot:
			$"../lose".visible = true 



#func draw_enemy_card():
	#var card_drawn = enemy_deck[0]
	#enemy_deck.erase(card_drawn)
	#
	## If player drew the last card in the deck, disable the deck
	#if player_deck.size() == 0:
		#$Area2D/CollisionShape2D.disabled = true
		#$Sprite2D.visible = false
		#$RichTextLabel.visible = false
	#
	#$RichTextLabel.text = str(player_deck.size())
	#var card_scene = preload(CARD_SCENE_PATH)
	#var new_card = card_scene.instantiate()
	#$"../CardMeneger".add_child(new_card)
	#new_card.name = "Card"
	#$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
