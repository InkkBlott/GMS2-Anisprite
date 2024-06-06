/// @function Anisprite(animation_data, handler) 
/// @param {array, string} animation_data Formatted array containing sprites to use for animations and animation speeds
/// @param {instance} handler Instance that this Anisprite is attached to. Used for animation function reference
/// @desc Creates a struct-based "anisprite" instance using the given

function Anisprite(animation_data, inp_handler=noone) constructor {
	animations = (typeof(animation_data) == "string") ? global.anisprite_types[$ animation_data] : animation_data
	x = 0
	y = 0
	offset_x = 0
	offset_y = 0
	secondary_offset_x = 0 //these secondary offsets WILL NOT be affected by offset rotation
	secondary_offset_y = 0
	offset_rotation = false //causes anisprite to rotate its drawing position around offset values
	scale_x = 1
	scale_y = 1
	flipped_x = false
	flipped_y = false
	face_direction = 0
	face_direction_horizontal_flip = false
	angle = 0
	alpha = 1
	anim = 0
	anim_orientation = 0
	anim_frame = 0
	anim_speed_scale = 1
	_anim_tracker = -1
	_anim_frame_tracker = -1
	anim_functions_active = true
	anim_finished = false
	anim_end_invisibility = false
	handler = inp_handler
	current_step_method = undefined
	step_counter = 0 //generic counter. Increments by timescale value (default: 1) every step() call, and resets at 216000 (1 hour at 60fps, normal speed)
	/// @function step([timescale])
	/// @desc processes anisprite animation
	static step = function(timescale=1) {
		var num_frames = frame_count()
		var current_anim = animations[anim]
		if (_anim_tracker != anim) { //change _anim_tracker
			_anim_tracker = anim
			anim_frame = 0
			_anim_frame_tracker = -1
			anim_finished = false
			if (current_anim.step_method != undefined) { current_step_method = method(self, current_anim.step_method) }
			else current_step_method = undefined
		} else {
			anim_frame += current_anim.default_speed*anim_speed_scale*timescale
			if (anim_frame >= num_frames) {
				if (!anim_finished) {
					anim_finished = true
					if (anim_end_invisibility) alpha = 0
				}
				if (current_anim.loop_frame == undefined) { anim_frame = num_frames-1 }
				else { anim_frame = current_anim.loop_frame+frac(anim_frame) }
			}
		}
		if (current_step_method != undefined) current_step_method()
		var fr = floor(anim_frame)
		if (anim_functions_active) {
			while (_anim_frame_tracker != fr) {
				_anim_frame_tracker ++
				if (_anim_frame_tracker >= num_frames) { _anim_frame_tracker = min(current_anim.loop_frame, fr) }
				if (current_anim.frame_methods != undefined) { 
					var funcs = current_anim.frame_methods
					for (var i=0; i<array_length(funcs); i++) {
						if (fr == funcs[i][0]) { method(self,funcs[i][1])() }
					}
				}
			}
		} else if (_anim_frame_tracker != fr) { _anim_frame_tracker = fr }
		//horizontal flip
		if (face_direction_horizontal_flip) {
			var c = dcos(face_direction)
			if (c > 0 and flipped_x) { flipped_x = false }
			else if (c < 0 and !flipped_x) { flipped_x = true }
		}
		//iterate tick counter
		step_counter += timescale
		if (step_counter >= 216000) step_counter %= 216000
	}
	/// @function draw(x,y)
	/// @desc draw anisprite with current settings
	static draw = function(inp_x=undefined,inp_y=undefined) {
		if (alpha <= 0) return;
		var draw_x = inp_x ?? x
		var draw_y = inp_y ?? y
		var current_anim = animations[anim]
		var draw_scale_x = scale_x
		var draw_scale_y = scale_y
		var draw_frame = floor(anim_frame)
		if (flipped_x) { draw_scale_x *= -1 }
		if (flipped_y) { draw_scale_y *= -1 }
		var draw_offset_x = offset_x + current_anim.offset_x
		var draw_offset_y = offset_y + current_anim.offset_y
		if (current_anim.frame_offset != undefined and current_anim.frame_offset[draw_frame] != undefined) {
			draw_offset_x += current_anim.frame_offset[draw_frame][0]
			draw_offset_y += current_anim.frame_offset[draw_frame][1]
		}
		var subimg
		if (current_anim.frame_sequence != undefined) { subimg = current_anim.frame_sequence[draw_frame] }
		else { subimg = draw_frame }
		if (offset_rotation and angle != 0) {
			var ang = point_direction(0,0,draw_offset_x,draw_offset_y) + angle
			var dist = point_distance(0,0,draw_offset_x,draw_offset_y)
			draw_offset_x = dcos(ang)*dist
			draw_offset_y = 0-dsin(ang)*dist
		}
		
		draw_sprite_ext(current_anim.sprites[anim_orientation],subimg,draw_x+draw_offset_x+secondary_offset_x,draw_y+draw_offset_y+secondary_offset_y,draw_scale_x,draw_scale_y,angle,c_white,alpha)
	}
	/// @function set_anim(new_anim)
	/// @param {real} new_anim Index of new animation to set
	/// @desc Change current anisprite animation
	static set_anim = function(new_anim) {
		anim = new_anim
		anim_frame = 0
		_anim_frame_tracker = -1
		anim_finished = false
		if (anim_orientation >= array_length(animations[anim].sprites)) { anim_orientation = 0 }
	}
	/// @function set_anim_frame(new_frame, ignore_tracker)
	/// @param {real} new_frame Animation frame to set
	/// @desc Change current anisprite animation frame while also adjusting frame event tracker
	static set_anim_frame = function(new_frame, ignore_tracker=false) {
		anim_frame = new_frame
		if (ignore_tracker) { _anim_frame_tracker = new_frame }
		else { _anim_frame_tracker = new_frame-1 }
	}
	/// @function advance_anim_frame([number_of_frames])
	/// @desc advances forward the animation by the given number of frames (floats accepted), triggering any applicable frame methods along the way
	static advance_anim_frame = function(frames=1) {
		var num_frames = frame_count()
		var current_anim = animations[anim]
		var i
		while (frames > 0) {
			i = min(frames, 1)
			anim_frame += i
			if (anim_frame >= num_frames) {
				if (!anim_finished) {
					anim_finished = true
					if (anim_end_invisibility) alpha = 0
				}
				if (current_anim.loop_frame == undefined) { 
					anim_frame = num_frames-1 
					frames = 0 //end while loop after this cycle
				}
				else { anim_frame = current_anim.loop_frame+frac(anim_frame) }
			}
			var fr = floor(anim_frame)
			if (anim_functions_active) {
				if (_anim_frame_tracker != fr) {
					_anim_frame_tracker = fr
					if (current_anim.frame_methods != undefined) { 
						var funcs = current_anim.frame_methods
						for (var i=0; i<array_length(funcs); i++) {
							if (fr == funcs[i][0]) { method(self,funcs[i][1])() }
						}
					}
				}
			} else if (_anim_frame_tracker != fr) { _anim_frame_tracker = fr }
			frames -= i
		}
	}
	/// @function get_current_asset()
	/// @desc returns an array containing the sprite asset and sub-image index that the selected Anisprite is currently set to draw
	static get_current_asset = function() {
		var subimg
		if (animations[anim].frame_sequence != undefined) { subimg = animations[anim].frame_sequence[floor(anim_frame)] }
		else { subimg = floor(anim_frame) }
		return [animations[anim].sprites[anim_orientation],subimg]
	}
	/// @function frame_count()
	/// @desc returns number of frames in current animation
	static frame_count = function() {
		if (animations[anim].frame_sequence != undefined) { return array_length(animations[anim].frame_sequence) }
		else { return sprite_get_number(animations[anim].sprites[0]) }
	}
}