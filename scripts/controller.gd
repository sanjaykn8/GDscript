# GameController.gd
extends Node

@onready var players := [$"../player1", $"../player2"] #replace path if different

var current_index: int = 0

func _ready() -> void:
	# make sure only the first player active at start
	for p in players:
		p.set_active(false)
	players[current_index].set_active(true)

func _input(event):
	if event.is_action_pressed("switch_player"):
		_switch_player()

func _switch_player() -> void:
	players[current_index].set_active(false)
	current_index = (current_index + 1) % players.size()
	players[current_index].set_active(true)
