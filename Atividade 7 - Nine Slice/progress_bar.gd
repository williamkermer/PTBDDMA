extends Control

@onready var progress_bar = $ProgressBar
@onready var button = $Button

func _ready() -> void:

	button.pressed.connect(_ao_pressionar_botao)

func _ao_pressionar_botao() -> void:

	var valor_alvo = 100.0
	var duracao = 1.5

	var tween = create_tween()

	tween.tween_property(
		progress_bar, 
		"value", 
		valor_alvo, 
		duracao
	).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	

	tween.tween_callback(func(): print("Progresso atualizado!"))
