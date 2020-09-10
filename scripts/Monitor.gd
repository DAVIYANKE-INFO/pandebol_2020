extends Control


func _physics_process(delta):
	$Label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$Label2.text = "Memoria esttica : " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)) + "MB"
