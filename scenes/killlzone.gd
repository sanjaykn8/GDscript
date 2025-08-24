extends Area2D

@onready var timer = $Timer

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "player1" or body.name == "player2":
		Engine.time_scale = 0.5
		# instead of Timer.start(), use SceneTreeTimer that ignores time scale
		var t = get_tree().create_timer(0.5, false, true) # (time, process_in_physics, ignore_time_scale)
		t.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
