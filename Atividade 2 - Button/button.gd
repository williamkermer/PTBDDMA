extends Button


func _on_pressed() -> void:
	$"../Label".text = $"../LineEdit".text
	$"../LineEdit".text = ''
