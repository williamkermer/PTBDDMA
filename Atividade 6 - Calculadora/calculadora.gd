extends Control

var numero_atual: String = ""
var numero_anterior: float = 0.0
var operacao_atual: String = ""
var aguardando_segundo_numero: bool = false
var calculo_finalizado: bool = false

var cores = {
	"+": Color("#4CAF50"),
	"-": Color("#FFC107"),  
	"−": Color("#FFC107"),  
	"x": Color("#F44336"), 
	"X": Color("#F44336"), 
	"×": Color("#F44336"),  
	"/": Color("#2196F3"),  
	"÷": Color("#2196F3"),  
	"neutro": Color("#2b2b2b")
}

func _ready() -> void:
	resetar_calculadora()
	for botao in get_tree().get_nodes_in_group("botoes"):
		botao.pressed.connect(_on_button_pressed.bind(botao.text))

func _on_button_pressed(valor: String) -> void:
	if valor.is_valid_int() or valor == ".":
		digito_pressionado(valor)
	elif valor in ["+", "-", "−", "x", "X", "×", "/", "÷"]:
		operacao_pressionada(valor)
	elif valor == "=":
		calcular_resultado()
	elif valor == "C":
		resetar_calculadora()

func digito_pressionado(digito: String) -> void:
	if calculo_finalizado:
		numero_atual = ""
		$VBoxContainer/PanelContainer/VBoxContainer/expressao_label.text = ""
		calculo_finalizado = false
	
	if aguardando_segundo_numero:
		numero_atual = ""
		aguardando_segundo_numero = false
	
	numero_atual += digito
	$VBoxContainer/PanelContainer/VBoxContainer/resultado_label.text = numero_atual

func operacao_pressionada(op: String) -> void:
	if numero_atual != "" and not calculo_finalizado:
		numero_anterior = numero_atual.to_float()
	elif calculo_finalizado:
		numero_anterior = numero_atual.to_float()
		calculo_finalizado = false
	
	operacao_atual = op
	aguardando_segundo_numero = true
	$VBoxContainer/PanelContainer/VBoxContainer/expressao_label.text = str(numero_anterior) + " " + op
	mudar_cor(cores[op])

func calcular_resultado() -> void:
	if operacao_atual == "" or numero_atual == "":
		return
		
	var num2 = numero_atual.to_float()
	var resultado = 0.0
	
	if operacao_atual == "+":
		resultado = numero_anterior + num2
	elif operacao_atual == "-" or operacao_atual == "−":
		resultado = numero_anterior - num2
	elif operacao_atual == "x" or operacao_atual == "X" or operacao_atual == "×":
		resultado = numero_anterior * num2
	elif operacao_atual == "/" or operacao_atual == "÷":
		if num2 != 0:
			resultado = numero_anterior / num2
		else:
			$VBoxContainer/PanelContainer/VBoxContainer/expressao_label.text = ""
			$VBoxContainer/PanelContainer/VBoxContainer/resultado_label.text = "Erro! 🚫"
			calculo_finalizado = true
			return
	
	$VBoxContainer/PanelContainer/VBoxContainer/expressao_label.text = str(numero_anterior) + " " + operacao_atual + " " + str(num2)
	$VBoxContainer/PanelContainer/VBoxContainer/resultado_label.text = "= " + str(resultado)
	
	numero_atual = str(resultado)
	operacao_atual = ""
	calculo_finalizado = true

func mudar_cor(cor: Color) -> void:
	var estilo = $VBoxContainer/PanelContainer.get_theme_stylebox("panel").duplicate()
	if estilo is StyleBoxFlat:
		estilo.bg_color = cor
		$VBoxContainer/PanelContainer.add_theme_stylebox_override("panel", estilo)

func resetar_calculadora() -> void:
	numero_atual = ""
	numero_anterior = 0.0
	operacao_atual = ""
	calculo_finalizado = false
	$VBoxContainer/PanelContainer/VBoxContainer/expressao_label.text = ""
	$VBoxContainer/PanelContainer/VBoxContainer/resultado_label.text = "0"
	mudar_cor(cores["neutro"])
