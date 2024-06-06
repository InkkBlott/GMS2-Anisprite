# Anisprite
Version 0.1.0
Created by InkkBlott
For use with GameMaker 2.3+, release validated with runtime 2024.4.1.201


### [ ABOUT ]

Anisprite is a flexible sprite animation tool that allows for a more flexible, more robust, less finicky approach to sprite animation than what GameMaker's current built-in systems accommodate. Using Anisprite, you can define animation datasets containing data for several animations, assign that dataset to an Anisprite instance-struct, and dynamically switch between your predefined animations with a single method call. There are also a number of features that any 2D dev/animator is likely to find useful, such as manual frame-sequence overrides to avoid having to needlessly duplicate animation frames, per-animation-frame function calls and positional offsets, time-scaling, animation loop-points, and many more!


### [ USAGE ]

Anisprites consists of 2 core aspects:

- 1: Animation Data
- 2: Anisprite instance-structs

The intended usage of this tool involves defining animation data in the editor (by default, in the global.anisprite_types struct), creating Anisprite instance-structs using the Anisprite() constructor, using whichever instance or process you want to control them, calling their step() method whenever you want their processes to update (usually in the controlling instance's Step event), and drawing them in a similar fashion using the draw() method. There are a variety of other methods and member variables that can be used to further manipulate Anisprites, but those are the bare essentials of it. More information about the other features will be featured in sections below.


### [ DATASETS ]

An Anisprite dataset is an array containing formatted animation data structs. Each index of the dataset array represents a distinct animation that any Anisprite using the dataset can utilize. It is recommended (but not mandatory) that you define these datasets as keyed values in the global.anisprite_types struct provided in the __Anisprite_types script.


### [ ANIMATION DATA ]

Within a dataset array, animation data consists of formatted structs. Looking at the comments and provided "example" dataset in the __Anisprite_types script should serve as an intuitive guide on how to structure them, but I will detail the values for each animation here, because there are some notable nuances that deserve a more detailed explaination:

- sprites (array)
	- Contains a list of sprite assets, each sprite representing a possible "orientation" for that animation.
	- Animation orientations basically allow you to have multiple sets of animation frames for any given
		animation that you can switch between on the fly using the Anisprite's anim_orientation member variable.
	- For example, if you were making a pseudo-top-down game like P\*\*emon or Z\*\*da, with different animations 
		for a character walking up, down, and left/right, you could contain all of those within a single "walk"
		animation and just change the orientation based on which direction they are moving.
	- It should go without saying, but every animation needs at least one sprite in this array to function.
	- NOTE: EVERY SPRITE ASSET IN THE ARRAY MUST HAVE THE SAME NUMBER OF FRAMES!
- offset_x (number)
- offset_y (number)
	- Intuitively, these offset values additively change the position the Anisprite is drawn at, relative to the 
		position used in the Anisprite's draw() method.
- default_speed (number)
	- The default per-step iteration of the animation. Ignoring other influencing factors on animation speed,
		a value of 0.25, for example, will cause each animation frame to last for 4 step() calls
	- Anisprite member variables and other factors can overwrite or influence the actual speed of animation, but
		this value will always be used as a default when those factors don't apply.
- loop_frame (number or undefined)
	- When set to a number, the animation will loop back to this frame once it reaches the end
	- When set to undefined, the animation will not loop.
- frame_offset (array or undefined)
	- Used for per-animation-frame positional offsets when set as an array. Ignored when set to undefined
	- When used, it should be populated with a corresponding value for each frame in the current animation
	- Each value should either be an [x, y] array describing positional offset for the corresponding animation 
		frame, or undefined, which will result in no offset for that frame.
- frame_sequence: (array or undefined)
	- By default (when this value is set to undefined), Anisprites will use the number and order of the frames in
		the active sprite asset(s) as the animation frames, but using this value allows you to override that and
		substitute your own frame sequence for the animation.
	- Each index of the array should contain a number that corresponds to the index of a frame (a.k.a. "image") 
		in the sprite asset.
	- An example use case for this feature is creating an idle animation where a character stands still for
		numerous frames before performing an action. Instead of copying the frames for the "still" part
		of the animation numerous times you could set the frame_sequence to [0,0,0,0,0,0,0,0,0,0,0,0, ...], using
		that first frame of the sprite for as many frames of actual animation as you need before inserting the 
		rest of the frames. When combined with the frame_offset array, you could even create a motion-animation out
		of a single sprite frame!
- frame_methods (array or undefined)
	- Used to call method functions on the Anisprite instance-struct when set as an array. Ignored when set undefined
	- Each index should contain a formatted array: [frame, function()]
	- When the animation corresponding with the given value is reached, the function will be called on the Anisprite 
		instance-struct as a method. Multiple methods can be run on the same frame if they are given the same frame 
		value.
	- a string can be substituted for the function, and it will be used as a key to get the function from the
		global.anisprite_methods struct in the __Anisprite_methods script
- step_method (function, string, or undefined)
	- When set to a function, this will be executed as a method on Anisprite instance-structs on every step() call,
		for as long as this animation is active.
	- When set to a string, it will be used as a key to get the function from the global.anisprite_methods struct
		in the __Anisprite_methods script
	- When set to undefined, this will be ignored
		
NOTE: IF DESIRED, DATASETS AND ANIMATION DATA CAN BE GENERATED USING THE DATASET GENERATION FUNCTIONS IN THE
__Anisprite_functions SCRIPT


### [ ANISPRITES ]

The final piece of the puzzle, Anisprite instance-structs themselves. As stated in the "USAGE" section, these should be created using the Anisprite() constructor, updated using the step() method, and drawn using the draw() method. In addition to all of these, I will also cover the additional methods/variables/features that will allow you to get the most out of Anisprites here! See the __Anisprite_object script for source code

**CONSTRUCTOR:** Anisprite(animation_data, handler)

- animation_data (dataset array or string)
	- The dataset to use for this Anisprite. If a string is provided, it will be used as a key to retrieve the 
		dataset from global.anisprite_types
- handler (instance, struct, or other reference) [OPTIONAL]
	- An optional value that can be useful as a link from the Anisprite to the instance that created/manages it.
	- For example, you could set frame/step method to create particle effects at the handler's position for a 
		visual effect, or change the Anisprite's orientation based on the handler's direction/state

**VARIABLES:**

- animations (array)
	- Dataset currently in use
- x (number)
- y (number)
	- If draw() is called without provided x/y coordinates, these variables will be used in their place
- offset_x (number)
- offset_y (number)
	- draw position offset values for this Anisprite. These variables, the animation offsets and the frame offsets are 
		all added together to determine the initial offset value
- secondary_offset_x (number)
- secondary_offset_y (number)
	- EVEN MORE draw offset values, except these two aren't affected by offset_rotation, even when it's set to true
- offset_rotation (boolean)
	- When true, offset values (besides the secondary ones above) will be rotated along with the Anisprite's angle
	- For example, an x-offset of 10 pixels to the right becomes a y-offset of 10 pixels up when the angle is 90
- scale_x (number)
- scale_y (number)
	- Self-explanatory size-scaling values. 1.0 is normal/default.
- flipped_x (number)
- flipped_y (number)
	- When set true, flips the sprite horizontally/vertically when drawing
- face_direction (number)
	- Indicates which direction the Anisprite is "facing". Useful for direction-based orientation changes and such
	- expects an angle in degrees
- face_direction_horizontal_flip (boolean)
- face_direction_vertical_flip (boolean)
	- When set true, these values will cause flipped_x/flipped_y to be set based on whether the face_direction variable's
		angle is pointing left/right/up/down.
- angle (number)
	- Angle (in degrees) to draw the Anisprite at. Non-secondary offset values will also be rotated by this amount when
		offset_rotation is set true
- alpha (number)
	- Alpha-transparency value for drawing. (0.0 - 1.0)
- anim (number)
	- Current animation index. Treat this as read-only and only change animations using set_anim()
- anim_orientation (number)
	- Determines which sprite asset will be used when drawing the current animation frame, as explained in the
		"ANIMATION DATA" section.
	- This value can be edited directly for use, but make sure the current animation has a corresponding sprite for the 
		orientation value, or you'll get a crash.
- anim_frame (number)
	- The current frame value of the animation. At any point in time, this is likely to be a floating point, so you'll
	have to apply floor() to it to get the flat image/frame index.
	- Treat this as read-only, and only change animation frames with set_anim_frame() or advance_anim_frame()
- anim_speed_scale (number)
	- Can be set directly to speed up or slow down animation as a multiplier. Default 1.0.
- anim_functions_active (boolean)
	- Animation step() methods and frame methods will only be called when this value is set to true. Can be set directly
- anim_finished (boolean)
	- Read-only. When the current animation reaches its end, this value will be set to true (even if the animation loops).
	- Changing animations will reset this value to false
- anim_end_invisibility (boolean)
	- When true, the Anisprite's alpha will be set to 0 when the animation ends. Can be set directly.
- handler (instance, struct, ref, etc)
	- As explained in the constructor guide, this value is meant to store a reference to the object instance that 
		created/controls this Anisprite
- current_step_method (function or undefined)
	- The current animation's step function as a method, when applicable.
- step_counter (number)
	- A simple counter that goes up by 1 (or the provided time-scale value) every time the Anisprite's step() method 
		is called.
	- modulo 216000 is applied, representing a reset after 1 hour of normal-speed execution at 60 FPS
	
**METHODS:**

- step(timescale)
	- Processes/updates the Anisprite
	- "timescale" (number) [OPTIONAL]: Multiplier for animation iteration and other time-sensitive processes (default: 1)
- draw(x, y)
	- Draw the Anisprite using its current settings/values
	- x, y (numbers) [OPTIONAL]: Coordinates to draw the Anisprite at. If omitted, the Anisprite's x/y will be used instead
- set_anim(new_anim)
	- The proper way to change animations
	- "new_anim" (number): Index of new animation to set
- set_anim_frame(new_frame, ignore_anim_tracking)
	- Change current Anisprite animation frame while also adjusting frame event tracker
	- "new_frame" (number): Animation frame to set
	- "ignore_anim_tracking" (boolean) [OPTIONAL]: When true, the animation tracking process that causes frame methods 
		and other such events to occur will be bypassed/suppressed. This can usually be ignored.
- advance_anim_frame(amount)
	- Advances forward the animation by the given number of frames, triggering any applicable frame methods along the way
	- "amount" (number) [OPTIONAL]: number of frames by which to advance the animation (floats accepted). Default: 1
- get_current_asset()
	- Returns an array containing the sprite asset and sub-image index that the Anisprite is currently set to draw
- frame_count()
	- Returns the current number of animation frames, taking custom frame sequencing into account
