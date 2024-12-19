extends CanvasLayer

signal start_game


func _on_start_button_pressed():
	$StartButton.hide()
	$Label.hide()
	start_game.emit()
