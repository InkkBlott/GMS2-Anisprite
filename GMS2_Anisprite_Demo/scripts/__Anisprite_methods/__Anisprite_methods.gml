//These functions can be referenced by Anisprite instances via string and run as methods on the instances during certain events
global.anisprite_methods = {}

global.anisprite_methods[$ "example: step method"] = function() {
	if (anim_orientation == 1) {
		offset_y = -20 + (dcos(step_counter * 4) * 10)
	}
	else if (offset_y != 0) offset_y = 0
}

global.anisprite_methods[$ "example: frame method"] = function() {
	var o = instance_create_depth(handler.x, handler.y, -1, obj_fx_poof)
	o.direction = random_range(80,100) + (flipped_x ? -45 : 45)
}