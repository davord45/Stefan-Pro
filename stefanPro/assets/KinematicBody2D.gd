extends KinematicBody2D


export (int) var speed = 250
export (int) var jump_speed = -1800
export (int) var gravity = 0
var lastPosY
var lastPosX
var time_Delta
var frozen=false
var crouching=false
var velocity = Vector2.ZERO
var colliding= false
signal isBitten()
signal hasEvaded()
signal stationary()
var uiRun

func _ready():
	set_safe_margin(0.0000001)
	lastPosX=position.x
	lastPosY=position.y
	uiRun=true

var waitMark=true
func _process(delta):
	var xCheck=false
	var yCheck=false
	time_Delta=delta
	if(lastPosX!=position.x):
		if(!colliding):
			get_tree().call_group("camera", "moveCamera", position.x)
		lastPosX=position.x
	else:
		xCheck=true
	if(lastPosY!=position.y):
		if(!colliding):
			get_tree().call_group("camera", "moveCameraY", position.y)
		lastPosY=position.y
	else:
		yCheck=true
	
	if((xCheck and yCheck) and waitMark):
		waitMark=false
		emit_signal("stationary")
		yield(get_tree().create_timer(.5),"timeout")
		waitMark=true


func get_input():
	velocity.x = 0
	velocity.y = 0
	if((!frozen and !Input.is_action_pressed("crouch") and !Input.is_action_pressed("ui_select"))or $MainChar.gunMode):
		if Input.is_action_pressed("ui_right"):
			velocity.x += speed/1.5
			move_and_collide(Vector2.RIGHT)
			repositionCollider(-20)
			crouching=false
#			move_and_slide(velocity, Vector2.RIGHT)
		if Input.is_action_pressed("ui_left"):
			velocity.x -= speed/1.5
			move_and_collide(Vector2.LEFT)
			repositionCollider(-20)
			crouching=false
#			move_and_slide(velocity, Vector2.LEFT)
		if Input.is_action_pressed("ui_down"):
			velocity.y += speed/8
			move_and_collide(Vector2.DOWN)
			repositionCollider(-20)
			crouching=false
#			move_and_slide(velocity, Vector2.DOWN)
		if Input.is_action_pressed("ui_up"):
			velocity.y -= speed/8
			move_and_collide(Vector2.UP)
			repositionCollider(-20)
			crouching=false
#			move_and_slide(velocity, Vector2.UP)
	elif(Input.is_action_pressed("crouch")):
		repositionCollider(20)
		crouching=true

func _physics_process(delta):
	if !uiRun:
		if(get_slide_count()>0):
			colliding=true
		else:
			colliding=false
		get_input()
		velocity = move_and_slide(velocity, Vector2.UP)

var lowered=false
func repositionCollider(howMuch):
	if(!lowered and howMuch>0):
		$CollisionShape2D.set_scale(Vector2($CollisionShape2D.scale.x,$CollisionShape2D.scale.y-3))
		$CollisionShape2D.position.y+=howMuch
		lowered=true
	elif(lowered and howMuch<0):
		$CollisionShape2D.set_scale(Vector2($CollisionShape2D.scale.x,$CollisionShape2D.scale.y+3))
		$CollisionShape2D.position.y+=howMuch
		lowered=false

func _on_MainChar_stopped_Shivering(extra_arg_0):
	frozen=extra_arg_0


func _on_Tracker_inSight(extra_arg_0):
	frozen=extra_arg_0

func _on_Chaser_isAttacking(state):
	if(state=="CHASE"):
		if !crouching:
	#		get_node("/root/Node2D/Scene Controller").breakScene("eaten")
			letAttackPass()
		else:
			yield(get_tree().create_timer(1), "timeout")
			if(crouching):
				letAttackPass()
				return
			emit_signal("hasEvaded")
			print("Attack dodged")
	elif(state=="CRAWLING"):
		emit_signal("isBitten")
		
func letAttackPass():
	emit_signal("isBitten")
	print("You are eaten")
