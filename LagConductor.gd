#"""
#a dumbed down version of Conductor.gd so that you can test the player's laggy hardware
#"""

extends StreamPlayer

# songposition (not streamplayer position)
var songposition=0
# opus have metadata which makes them start late? also song ight have blank space at beginning
# opus is gonna be removed use ogg
var offset=2.5 +0
# 80 bpm is nice for test
var bpm= 80
# duration of a beat (otherwise known as crotchet)
var beatduration = 0.0
# time of last beat
var lastbeat = 0.0
# what actual beat are we on?
var beat = 0

func start(playaudio):
	# set beatduration to its duration in seconds
	beatduration = 60.0/bpm
	# start song at 2.5 seconds in. you're song shouldn't need this
	play(2.5)
	if(!playaudio):
		set_volume(0.0)
	else:
		set_volume(1.0)
	set_process(true)
	lastbeat=0
	beat=0

func _process(delta):
	songposition = get_pos() - offset
	
	if(songposition>lastbeat+beatduration): 
		beat+=1
		output(self)
		lastbeat+=beatduration 

func output(checknode):
	"""
	activate all the child nodes if they have the on_beat() method.
	"""
	if(checknode.get_children().size()>=0):
		for node in checknode.get_children():
			if(node.has_method("on_beat")):
				node.on_beat(beat)
			else :
				output(node)
	
	