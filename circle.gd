extends State

var initial_position := Vector2() 

func request_enter():
	# block entering until the tween is complete
	var enter_tween = create_tween()
	enter_tween.tween_property(%icon, "scale", Vector2(.5, .5),  2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	enter_tween.tween_callback(confirm_enter)

func enter():
	initial_position = %icon.position

func update(delta:float):
	%icon.position = initial_position + Vector2(sin(age), cos(age)) * min(200, age*100)

func exit():
	%icon.position = initial_position
