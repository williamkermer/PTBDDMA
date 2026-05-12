extends Area2D

# Variável para guardar a referência à HUD
var hud: Node

func _ready() -> void:
	# Busca a HUD na cena principal (vamos criar ela no passo 3)
	hud = get_tree().get_root().find_child("HUD", true, false)


func _on_body_entered(body: Node2D) -> void:
	# Verifica se quem entrou é o player
	if body.name == "Player":
		# Avisa a HUD que um item foi coletado
		if hud:
			hud.adicionar_item()
		# Reposiciona o item em lugar aleatório
		reposicionar()


func reposicionar() -> void:
	# Pega o tamanho da janela do jogo
	var tela = get_viewport_rect().size
	# Gera coordenadas aleatórias dentro da tela (com margem de 40px)
	var nova_x = randf_range(40, tela.x - 40)
	var nova_y = randf_range(40, tela.y - 40)
	global_position = Vector2(nova_x, nova_y)
