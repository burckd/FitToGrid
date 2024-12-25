extends CanvasLayer

signal start_game


func _on_start_button_pressed():
	$StartButton.hide()
	$Label.hide()
	start_game.emit()


func _on_restart_button_pressed():
	$RestartButton.hide()
	$Label2.hide()
	start_game.emit()


func _on_game_play_game_overed():
	$RestartButton.show()
	$Label2.show()
