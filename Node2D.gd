extends Node2D
class_name Scene2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var num_workers_global = 0
export(int) var MAX_SIMULTANEOUS_WORKERS = 3
export(int) var score = 0
export(int) var record = 9223372036854775807

var TOTAL_PHASES = 4
var phases_to_finish = TOTAL_PHASES

var pontuacaoText = """
Parabéns! Você concluiu a construção da casa.
Seu tempo foi: """
var recordText = """
O recorde atual é: """
var descricaoText = """

O objetivo desse jogo é demonstrar que com conceitos de
computação concorrente é possível melhorar o tempo que
leva para construir uma casa.
Os trabalhadores podem ser visto como as threads ou
processos, enquanto a casa e o trabalho para construí-la
é o nosso programa em execução.

Com a orquestração correta entre os trabalhadores é
possível otimizar o tempo de construção da casa, assim
como é possível também otimizar programas quando os
executamos em paralelo.

Aperte OK para jogar novamente.
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	# pass # Replace with function body.
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
	$Label.text = "Score: " + String(score)

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
	phases_to_finish = TOTAL_PHASES
	$House.reset_constructions()

func _on_Button_pressed():
	var a
	if a is Construction:
		a.add_worker()
		
