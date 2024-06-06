//Anisprite types
//Each item in this struct should contain formatted animation data for an anisprite instance-struct to use
global.anisprite_types = {}

//sprites: array contining sprite assets. Anisprite anim_orientation value determines which sprite it pulls frames from
//loop_frame: Frame for animation to loop back to. Set to -1 for no loop
//frame_sequence: array that lists image indexes to use for the animation's frames, allowing animations to 
//		diverge from the sprite's contents without the need for duplicate/redundant sprites/frames. 
//		Set to false to use the sprite assets frames normally.
//frame_methods: an array containing multiple 2-value arrays that contain [#frame , ()method] for Anisprite instances
//		to call on the defined frames. Set to undefined to ignore.
//step_method: function to use as the animation's step() method
//frame_offset: array containing additional [x,y] offsets to draw each frame of the animation with. Set the value or individual indexes to undefined to ignore.

global.anisprite_types[$ "example"] = [ //example anisprite
	{sprites: [spr_KnightIdle, spr_KnightJump], //0: idle
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.1,
	frame_sequence: undefined,
	loop_frame: 0,
	frame_methods: undefined,
	step_method: global.anisprite_methods[$ "example: step method"]
	},
	
	{sprites: [spr_KnightAttack, spr_KnightAirAttack], //1: attack
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.2,
	frame_sequence: undefined,
	loop_frame: undefined,
	frame_methods: undefined,
	step_method: global.anisprite_methods[$ "example: step method"]
	},
	
	{sprites: [spr_KnightWalk], //2: walk
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.1,
	frame_sequence: undefined,
	loop_frame: 0,
	frame_methods: [ //create poof objects on step
		[3, global.anisprite_methods[$ "example: frame method"]],
		[7, global.anisprite_methods[$ "example: frame method"]],
	],
	step_method: global.anisprite_methods[$ "example: step method"]
	},
	
	{sprites: [spr_KnightHurt], //3: hurt
	offset_x: 0,
	offset_y: 0,
	frame_offset: [
		undefined,[-3,0],undefined,[3,0],undefined,[-3,0],undefined,[3,0],undefined, //shaking
		undefined,undefined,undefined,undefined,undefined //flashing
		],
	default_speed: 0.3,
	frame_sequence: [
		0,0,0,0,0,0,0,0,0, //shaking
		1,0,0,0,0 //flashing
		],
	loop_frame: 9, //loop flashing section
	frame_methods: undefined,
	step_method: global.anisprite_methods[$ "example: step method"]
	},
]