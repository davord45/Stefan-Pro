extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SS2D_Shape_Open._points._points[1].position.x+=200
	$SS2D_Shape_Open._gui_update_info_panels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
