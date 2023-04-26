extends State

func enter():
	# like circle this state will also scale the icon, but it will not block execution while doing so
	var tween = create_tween()
	tween.tween_property(%icon, "scale", Vector2(1.5, 1.5),  .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func update(delta:float):
	%icon.position.x = int(age*100) % get_viewport().size.x 
