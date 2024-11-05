extends Node2D

signal hovered
signal hovered_off

var starting_hand_position
var card_position_x
var card_position_y
var card_value = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# все карты должны быть дочерними для CardManager, или возникнет ошибка
	card_position_x = get_viewport().size.x / 12
	card_position_y = get_viewport().size.y - 120
	position.x = card_position_x
	position.y = card_position_y
	$RichTextLabel.text = str(card_value)
	get_parent().connect_card_signal(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)
