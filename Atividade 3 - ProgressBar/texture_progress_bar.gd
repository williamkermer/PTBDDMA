extends TextureProgressBar

var count = 1
var nivel = 100

func _ready() -> void:
	$Label.text = str(count)

func _on_button_pressed() -> void:
	if $Timer.is_stopped():	
		$Timer.start()
		$Button.text = "Desligar timer"
	else:
		$Timer.stop()
		$Button.text = "Ligar timer"

func _on_button_2_pressed() -> void:
	value += int($LineEdit.text)
	
	if value >= max_value:
		value = 0
		count = count + 1
		$Label.text = str(count)
		nivel = int($Label3.text)
		$Label3.text = str((nivel * 1.1))

func _on_timer_timeout() -> void:
	value += 2
	
	if value >= max_value:
		value = 0
		count = count + 1
		$Label.text = str(count)
		nivel = int($Label3.text)
		$Label3.text = str((nivel * 1.1))
