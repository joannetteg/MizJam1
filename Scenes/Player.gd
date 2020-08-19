extends KinematicBody2D
class_name Player

# Movement variables
var maxSpeed = 120
var acceleration = 1400
var deceleration = 1000
var velocity = Vector2.ZERO
var isWalkingLeft = false

# Player State variables
enum {
	EXPLORE,
	BATTLE,
	TALK,
	WIN
}
var playerState = EXPLORE

signal onExploreState
signal onTalkState
signal onBattleState

# References
onready var playerMovementAnim = $AnimationPlayer
onready var battleTransition = $Camera2D/BattleTransition/AnimationPlayer
onready var gameCamera = $Camera2D/CamAnim
onready var grassNodes = $"../Grass/"
onready var battleCamera = $"../../BattleCam/"

func _ready():
	for grass in grassNodes.get_children():
		grass.connect("trigger_battle", self, "trigger_battle")

func _process(delta):
	# Simple state machine running the different player states
	match playerState:
		EXPLORE:
			emit_signal("onExploreState")
			explore_state(delta)
		BATTLE:
			emit_signal("onBattleState")
			battle_state(delta)
		TALK:
			emit_signal("onTalkState")
			talk_state(delta)
		WIN:
			win_state(delta)

func explore_state(delta):
	var input_vector = Vector2.ZERO
	var remember_vector = Vector2.ZERO
	
	# Create a movement vector with the inputs
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalizing the vector for diagonal speed
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		# Accelerate the Player
		velocity = velocity.move_toward(input_vector * maxSpeed, acceleration * delta)
		# Dirty animation handling
		if input_vector.x < -0.1:
			playerMovementAnim.play("walkLeft")
			isWalkingLeft = true
		elif input_vector.x > 0.1:
			playerMovementAnim.play("walkRight")
			isWalkingLeft = false
		if isWalkingLeft and input_vector.y != 0:
			playerMovementAnim.play("walkLeft")
		elif !isWalkingLeft and input_vector.y != 0:
			playerMovementAnim.play("walkRight")
		move()
	else:
		# Decelerate the Player
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		# Dirty animation handling
		if isWalkingLeft:
			playerMovementAnim.play("idleLeft")
		else:
			playerMovementAnim.play("idleRight")
	
func battle_state(delta):
	#Placeholder action to go out of battle
	if Input.is_action_just_pressed("ui_accept"):
		playerState = EXPLORE
		battleTransition.play("FadeOut")
		gameCamera.play("ZoomOut")
	
func talk_state(delta):
	print("IN MENU")
	
func win_state(delta):
	pass

func move():
	# Apply the velocity to the movement
	velocity = move_and_slide(velocity)

func trigger_battle(value):
	playerState = BATTLE
	print("TRIGGERED " + str(value))
	battleTransition.play("SlideIn")
	gameCamera.play("ZoomIn")


func _on_PlayerBattleUI_triggerTalkState():
	playerState = TALK


func _on_PlayerBattleUI_triggerExploreState():
	playerState = EXPLORE


func _on_GameManager_triggerTalk():
	playerState = TALK


func _on_GameManager_triggerExplore():
	playerState = EXPLORE
