extends Node2D
class_name Scene2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var num_workers_global = 0
export(int) var MAX_SIMULTANEOUS_WORKERS = 3
export(int) var score = 0
export(int) var record = 9223372036854775807

var phases_to_finish: int

var pontuacaoText = """
Você concluiu a construção da casa.
Seu tempo foi: """
var recordText = """
O recorde atual é: """
var descricaoText = """
O objetivo desse jogo é aplicar conceitos de computação concorrente na construção
de uma casa. Os trabalhadores podem ser visto como as threads ou processos, enquanto 
a casa e o trabalho para construí-la é o nosso programa em execução. 
Com a orquestração
correta entre os trabalhadores é possível otimizar o tempo de construção da casa, assim
como é possível também otimizar programas quando os executamos em paralelo. 
Existem tarefas facilmente paralelizáveis, em que o tempo necessário diminui pela metade 
ao dobrar o número de trabalhadores. Existem tarefas não paralelizáveis, em que, ao adicionar mais 
trabalhadores, o tempo quase não é afetado. E, finalmente, existem tarefas pouco paralelizáveis, 
em que ao dobrar o número de trabalhadores, o tempo diminui, mas não tanto quanto o esperado.

Agora, tente descobrir qual a melhor  forma de paralelizar a construção da casa, levando em conta 
quais são as tarefas mais fácil de se paralelizar.

Dica: Uma boa ideia é se atentar ao espaço em que os pedreiros estarão trabalhando. Pequenas tarefas 
costumam ser dificilmente paralelizáveis. Quando cada pedreiro pode fazer a sua parte sem interferir 
no outro, é sinal de que essa tarefa é facilmente paralelizável.

Aperte OK para jogar novamente.
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	# pass # Replace with function body.
	show_home()
	phases_to_finish = $House.get_child_count()
	$Home/Play/PlayButton.connect("pressed", self, "_play_button_pressed")

func _play_button_pressed():
	# $Home.visible = false
	# $Home/Background.visible = false
	# $Home/Play.visible = false
	# $Home/Play/PlayButton.visible = false
	hide_home()

func hide_home():
	$Home.hide()
	$Home/Background.hide()
	$Home/Play.hide()
	$Home/Play/PlayButton.hide()

func show_home():
	$Home.show()
	$Home/Background.show()
	$Home/Play.show()
	$Home/Play/PlayButton.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_score(delta)
	var available_workers = MAX_SIMULTANEOUS_WORKERS - num_workers_global
	$Score.text = "Tempo: " + String(score)
	$Time.text = "Trabalhadores disponíveis: " + String(available_workers)
	

func update_score(delta):
	if (num_workers_global > 0):
		score += delta
		
func update_phases_to_finish():
	phases_to_finish -= 1
	if (phases_to_finish == 0):
		game_over()

func game_over():
	record = score if score < record else record
	$AcceptDialog.dialog_text = pontuacaoText + String(score) + recordText + String(record) + descricaoText
	$AcceptDialog.popup_centered()
	show_home()
	score = 0          
	phases_to_finish = $House.get_child_count()
	$House.reset_constructions()

func _on_Button_pressed():
	var a
	if a is Construction:
		a.add_worker()
		
