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

# References
onready var playerMovementAnim = $AnimationPlayer

func _process(delta):
	# Simple state machine running the different player states
	match playerState:
		EXPLORE:
			explore_state(delta)
		BATTLE:
			battle_state(delta)
		TALK:
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
			print("walk left is true")
		else:
			playerMovementAnim.play("idleRight")
			print("walk left is false")
	
func battle_state(delta):
	pass
	
func talk_state(delta):
	pass
	
func win_state(delta):
	pass

func move():
	# Apply the velocity to the movement
	velocity = move_and_slide(velocity)
