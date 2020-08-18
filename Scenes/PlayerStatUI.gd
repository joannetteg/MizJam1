extends Node2D

var MAXLEVEL = 999
var currentLevel = 1
var XPTOLEVEL = 100
var currentXP = 0

var availableStatPoints = 5

var MAXSTAT = 50
var PWR = 1
var MGC = 1
var WIS = 1
var CON = 1
var CHA = 1
var statsIn = false
var canOpenStats = false

enum {
	POWER,
	MAGIC,
	WISDOM,
	CONST,
	CHAR
}
var currentStat = POWER

onready var levelStats = $FrameSprite2/Level/LVLDigit

onready var PWRtext = $FrameSprite2/Power/PowerDigit
onready var MGCtext = $FrameSprite2/Magic/MagicDigit
onready var WIStext = $FrameSprite2/Wisdom/WisdomDigit
onready var CONtext = $FrameSprite2/Constitution/ConstitutionDigit
onready var CHAtext = $FrameSprite2/Charisma/CharismaDigit

onready var PTStext = $FrameSprite2/Points/AvalaiblePTS

onready var statsUIAnim = $"../StatsUI"
onready var statsCursorAnim = $CursorAnim
onready var statsPTSAnim = $PTSAnim

signal triggerTalkState
signal triggerExploreState
	
func _process(delta):
	if availableStatPoints > 0:
		statsPTSAnim.play("PTSAvailable")
	else:
		statsPTSAnim.play("default")
	
	if Input.is_action_just_pressed("stats") and statsIn == false and canOpenStats == true:
		statsUIAnim.play("SlideIn")
		statsIn = true
		emit_signal("triggerTalkState")
		
	elif Input.is_action_just_pressed("stats") and statsIn == true:
		statsUIAnim.play("SlideOut")
		statsIn = false
		emit_signal("triggerExploreState")
		
	if statsIn == true:
		if Input.is_action_just_pressed("ui_down"):
			match currentStat:
				POWER:
					currentStat = MAGIC
					statsCursorAnim.play("MGC")
				MAGIC:
					currentStat = WISDOM
					statsCursorAnim.play("WIS")
				WISDOM:
					currentStat = CONST
					statsCursorAnim.play("CON")
				CONST:
					currentStat = CHAR
					statsCursorAnim.play("CHA")
				CHAR:
					currentStat = POWER
					statsCursorAnim.play("PWR")
					
		if Input.is_action_just_pressed("ui_up"):
			match currentStat:
				POWER:
					currentStat = CHAR
					statsCursorAnim.play("CHA")
				MAGIC:
					currentStat = POWER
					statsCursorAnim.play("PWR")
				WISDOM:
					currentStat = MAGIC
					statsCursorAnim.play("MGC")
				CONST:
					currentStat = WISDOM
					statsCursorAnim.play("WIS")
				CHAR:
					currentStat = CONST
					statsCursorAnim.play("CON")
					
		if Input.is_action_just_pressed("ui_accept") and availableStatPoints >= 1:
			match currentStat:
				POWER:
					print("+1 PWR")
					PWR += 1
					availableStatPoints -= 1
				MAGIC:
					print("+1 MGC")
					MGC += 1
					availableStatPoints -= 1
				WISDOM:
					print("+1 WIS")
					WIS += 1
					availableStatPoints -= 1
				CONST:
					print("+1 CON")
					CON += 1
					availableStatPoints -= 1
				CHAR:
					print("+1 CHA")
					CHA += 1
					availableStatPoints -= 1

	levelStats.text = str(currentLevel)
	PTStext.text = str(availableStatPoints)
	
	PWRtext.text = str(PWR)
	MGCtext.text = str(MGC)
	WIStext.text = str(WIS)
	CONtext.text = str(CON)
	CHAtext.text = str(CHA)


func _on_Player_onTalkState():
	canOpenStats = false

func _on_Player_onExploreState():
	canOpenStats = true
