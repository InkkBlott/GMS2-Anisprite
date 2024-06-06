
function anisprite_type_set(name, animation_data) { global.anisprite_types[$ name] = animation_data }

function anisprite_type_create(name) { return global.anisprite_types[$ name] = [] }

function anisprite_type_add_animation(type_name) {
	array_push(global.anisprite_types[$ type_name], {
		sprites: [], //idle
		offset_x: 0,
		offset_y: 0,
		frame_offset: undefined,
		default_speed: 0.1,
		frame_sequence: undefined,
		loop_frame: 0,
		frame_methods: undefined,
		step_method: undefined
	})
	return array_length(global.anisprite_types[$ type_name])-1
}

/// @function anisprite_animation_add_sprites(type_name, animation_index, sprite_1, sprite_2, ...) {
function anisprite_animation_add_sprites() {
	var sprite_arr = global.anisprite_types[$ argument[0]][argument[1]].sprites
	for (var i=2; i<argument_count; i++) array_push(sprite_arr, argument[i])
}

function anisprite_animation_set_offset(type_name, animation_index, offset_x=0, offset_y=0) {
	var anim = global.anisprite_types[$ type_name][animation_index]
	anim.offset_x = offset_x
	anim.offset_y = offset_y
}

function anisprite_animation_set_frame_offset(type_name, animation_index, animation_frame, offset_x=0, offset_y=0) {
	var anim = global.anisprite_types[$ type_name][animation_index]
	anim.frame_offset ??= []
	for (var i=array_length(anim.frame_offset); i<animation_frame; i++) anim.frame_offset[i] = undefined
	anim.frame_offset[animation_frame] = [offset_x, offset_y]
}

function anisprite_animation_set_speed(type_name, animation_index, animation_speed) { global.anisprite_types[$ type_name][animation_index].default_speed = animation_speed }

function anisprite_animation_set_frame_sequence(type_name, animation_index, frame_sequence_array) { global.anisprite_types[$ type_name][animation_index].frame_sequence = frame_sequence_array }

function anisprite_animation_set_loop_frame(type_name, animation_index, loop_frame) { global.anisprite_types[$ type_name][animation_index].loop_frame = loop_frame }

function anisprite_animation_add_frame_method(type_name, animation_index, animation_frame, method_function) {
	var anim = global.anisprite_types[$ type_name][animation_index]
	anim.frame_methods ??= []
	array_push(anim.frame_methods, [animation_frame, (typeof(method_function) == "string") ? global.anisprite_methods[$ method_function] : method_function])
}

function anisprite_animation_set_step_method(type_name, animation_index, method_function) { global.anisprite_types[$ type_name][animation_index].step_method = (typeof(method_function) == "string") ? global.anisprite_methods[$ method_function] : method_function }