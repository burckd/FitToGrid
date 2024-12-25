extends Node2D

@onready var game_play = %GamePlay

var score

func new_game():
	game_play.start_game()
	game_play.show()

func game_over():
	pass
