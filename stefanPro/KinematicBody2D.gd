

extends KinematicBody2D

const GRAVITY = 60.0
const WALK_SPEED = 600

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += delta * GRAVITY

	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		if($Gardener.get("playback/curr_animation") != "moving"):
			$Gardener.stop_all()
			$Gardener.set("playback/curr_animation", "moving")
			$Gardener.set("playback/loop", -1)
			$Gardener.set("playback/speed", 1)
			$Gardener.play(true)
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		if($Gardener.get("playback/curr_animation") != "moving"):
			$Gardener.stop_all()
			$Gardener.set("playback/curr_animation", "moving")
			$Gardener.set("playback/loop", -1)
			$Gardener.set("playback/speed", 1)
			$Gardener.play(true)
	else:
		velocity.x = 0

	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))

