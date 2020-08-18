extends Node2D

var MAXLEVEL = 999
var currentLevel = 1
var XPTOLEVEL = 100
var currentXP = 0
var maxHP = 8

onready var currentHP = maxHP
var maxMana = 12
onready var currentMana = maxMana

onready var lifeBar = $FrameSprite/LifeBar
onready var manaBar = $FrameSprite/ManaBar
onready var HPDigit = $FrameSprite/LifeBar/HPDigit
onready var manaDigit = $FrameSprite/ManaBar/ManaDigit

onready var levelBattle = $FrameSprite/Level/LVLDigit

func _ready():
	lifeBar.max_value = maxHP
	manaBar.max_value = maxMana
	lifeBar.value = currentHP
	manaBar.value = currentMana
	
func _process(delta):
	HPDigit.text = str(currentHP)
	manaDigit.text = str(currentMana)
	
	levelBattle.text = str(currentLevel)
