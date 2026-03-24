extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_botao_cadastrar_pressed() -> void:
	
	$VBoxContainer/LabelMensagem.text = ""
	$VBoxContainer/LabelMensagem.add_theme_color_override("font_color", Color.RED);
	var erro = 0;
	
	if ($VBoxContainer/InputNome.text == ""):
		$VBoxContainer/LabelMensagem.text += "Nome não pode estar vazio\n"
		erro = 1
		
	if ($VBoxContainer/InputEmail.text == ""):
		$VBoxContainer/LabelMensagem.text += "Email não pode estar vazio\n"
		erro = 1
	elif not "@" in $VBoxContainer/InputEmail.text or not "." in $VBoxContainer/InputEmail.text:
		$VBoxContainer/LabelMensagem.text += "Email deve conter '@' e '.'\n"
		erro = 1
		
	if ($VBoxContainer/InputSenha.text == ""):
		$VBoxContainer/LabelMensagem.text += "O campo senha não pode estar vazio\n"
		erro = 1
		
	if ($VBoxContainer/InputConfirmarSenha.text == ""):
		$VBoxContainer/LabelMensagem.text += "O campo confirmar Senha não pode estar vazio\n"
		erro = 1
	elif $VBoxContainer/InputConfirmarSenha.text != $VBoxContainer/InputSenha.text:
		$VBoxContainer/LabelMensagem.text += "O campo Senha e confirmar Senha não estão iguais\n"
		erro = 1
	
	if (erro == 1):
		pass
	else:
		$VBoxContainer/LabelMensagem.add_theme_color_override("font_color", Color.GREEN);
		$VBoxContainer/LabelMensagem.text = "Sucesso! Você foi cadastrado\n"
	
	pass # Replace with function body.
