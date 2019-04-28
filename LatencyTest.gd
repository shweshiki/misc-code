#"""
#A script to calculate the laggyness of the player's audio and video on their computer.
#"""


# how the heck do i compile?????????????



extends Node

# the lagtime each time
var latencies = []
# to check so the player cant mash it
var already_hit =false

var audio_testing = false
var visual_testing = false

var audio_lag = 0.0
var video_lag = 0.0
func start(playaudio):
	get_parent().start(playaudio)
	# disappear the buttons and appear tap button
	get_node("Tap").show()
	get_node("Tap").set("focus/ignore_mouse",false)
	get_node("Test audio").hide()
	get_node("Test audio").set("focus/ignore_mouse",true)
	get_node("Test video").hide()
	get_node("Test video").set("focus/ignore_mouse",true)
	if visual_testing:
		get_node("Visual Cue").show()
		get_node("Beat Display").show()
	#clear array
	latencies = []

func _on_Tap_pressed():
	if not audio_testing and not visual_testing:#so its not this
		get_node("Tap Count").set_text("NO TEST PARAMETERS!")
	if not already_hit:
		latencies.append(get_parent().songposition-get_parent().lastbeat)
		already_hit = true
	get_node("Tap Count").set_text(str(latencies.size()))
	if latencies.size()>19:
		latency_sendoff()
	

func on_beat(beat):
	already_hit =false
	get_node("Beat Display").set_text(str(beat))
	
# send the lag measurements to conductor, save in file
func latency_sendoff():
	#y it no do the number?
	if audio_testing:
		audio_lag = ave_latencies()
		get_node("Tap Count").set_text(str(audio_lag))
	if visual_testing:
		video_lag = ave_latencies()
		get_node("Tap Count").set_text(str(video_lag))
	#save it
	var options = File.new()
	options.open("user://options.save", File.WRITE)
	if audio_testing:
		options.store_float(audio_lag)
	if visual_testing:
		options.store_float(video_lag)
	options.close()
	
	# finish up
	get_node("Tap").hide()
	get_node("Tap").set("focus/ignore_mouse",true)
	get_node("Test audio").show()
	get_node("Test audio").set("focus/ignore_mouse",false)
	get_node("Test video").show()
	get_node("Test video").set("focus/ignore_mouse",false)
	get_node("Visual Cue").hide()
	get_node("Beat Display").hide()
	audio_testing = false
	visual_testing = false

func ave_latencies():
	var sum =0.0
	for i in range(0,latencies.size()):
		sum+=latencies[i]
	return sum/latencies.size()


func _on_Test_audio_pressed():
	audio_testing = true
	start(true)

func _on_Test_video_pressed():
	visual_testing = true
	start(false)



