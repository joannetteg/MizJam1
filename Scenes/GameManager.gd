extends Node2D

onready var quitAnim = $QuitMenuAnim
var wantToQuit = false
var canQuit = false

signal triggerTalk
signal triggerExplore

func _process(_delta):
	# Leave game when pressing ESC
	if Input.is_action_just_pressed("ui_cancel") and wantToQuit == false and canQuit == true:
		wantToQuit = true
		quitAnim.play("in")
		emit_signal("triggerTalk")
	elif Input.is_action_just_pressed("ui_cancel") and wantToQuit == true:
		quitAnim.play("out")
		wantToQuit = false
		emit_signal("triggerExplore")
	if wantToQuit == true:
		if Input.is_action_just_pressed("no"):
			quitAnim.play("out")
			wantToQuit = false
			emit_signal("triggerExplore")
		elif Input.is_action_just_pressed("yes"):
			get_tree().quit()


func _on_Player_onExploreState():
	canQuit = true

func _on_Player_onTalkState():
	canQuit = false

func _on_Player_onBattleState():
	canQuit = false
