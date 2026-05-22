extends Control

@onready var input_id = $VBoxContainer/HBoxContainer/LineEdit
@onready var btn_buscar = $VBoxContainer/HBoxContainer/Button
@onready var lbl_id = $VBoxContainer/LabelID
@onready var lbl_nome = $VBoxContainer/LabelNome
@onready var lbl_pai = $VBoxContainer/LabelPai
@onready var lbl_mae = $VBoxContainer/LabelMae
@onready var vbox_jutsus = $VBoxContainer/ScrollContainer/VBoxListaJutsus
@onready var http_request = $HTTPRequest

const BASE_URL = "https://dattebayo-api.onrender.com/characters/"

func _ready():
	input_id.placeholder_text = "Digite o ID do personagem"


func _on_btn_buscar_pressed():
	var character_id = input_id.text.strip_edges()
	
	if character_id.is_empty() or not character_id.is_valid_int():
		lbl_nome.text = "Nome: Por favor, digite um ID válido (número)."
		return
		
	var url = BASE_URL + character_id
	
	btn_buscar.disabled = true
	btn_buscar.text = "Buscando..."
	
	var error = http_request.request(url)
	if error != OK:
		lbl_nome.text = "Nome: Erro ao iniciar a requisição HTTP."
		btn_buscar.disabled = false
		btn_buscar.text = "Buscar"


func _on_request_completed(result, response_code, headers, body):

	btn_buscar.disabled = false
	btn_buscar.text = "Buscar"
	
	# Verifica se a requisição deu certo
	if response_code != 200:
		lbl_id.text = "ID: -"
		lbl_nome.text = "Nome: Personagem não encontrado (Erro %d)." % response_code
		lbl_pai.text = "Pai: -"
		lbl_mae.text = "Mãe: -"
		_limpar_lista_jutsus()
		return

	var json_string = body.get_string_from_utf8()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		lbl_nome.text = "Nome: Erro ao ler o JSON (Linha %d)." % json.get_error_line()
		print("Erro no JSON: ", json.get_error_message())
		return

	var data = json.data
	
	# Garante que os dados vieram como um Dicionário
	if typeof(data) != TYPE_DICTIONARY:
		lbl_nome.text = "Nome: Formato de dados inválido recebido da API."
		return

	
	lbl_id.text = "ID do Personagem: " + str(data.get("id", "-"))
	lbl_nome.text = "Nome: " + str(data.get("name", "Desconhecido"))
	
	
	if data.has("family") and typeof(data["family"]) == TYPE_DICTIONARY:
		var family_data = data["family"]
		lbl_pai.text = "Pai: " + str(family_data.get("father", "Desconhecido"))
		lbl_mae.text = "Mãe: " + str(family_data.get("mother", "Desconhecido"))
	else:
		lbl_pai.text = "Pai: Desconhecido"
		lbl_mae.text = "Mãe: Desconhecido"
		
	# Popula a lista de jutsus
	var lista_jutsus = data.get("jutsu", [])
	if typeof(lista_jutsus) == TYPE_ARRAY:
		_atualizar_lista_jutsus(lista_jutsus)
	else:
		_atualizar_lista_jutsus([])


func _limpar_lista_jutsus():
	for child in vbox_jutsus.get_children():
		child.queue_free()


func _atualizar_lista_jutsus(jutsus: Array):
	_limpar_lista_jutsus()
	
	if jutsus.is_empty():
		var lbl_aviso = Label.new()
		lbl_aviso.text = "Nenhum jutsu registrado."
		vbox_jutsus.add_child(lbl_aviso)
		return
		
	for jutsu in jutsus:
		var lbl = Label.new()
		lbl.text = "• " + str(jutsu)
		vbox_jutsus.add_child(lbl)
