Anisprite 
Version 0.1.0
Created by InkkBlott
For use with GameMaker 2.3+, release validated with runtime 2024.4.1.201


[ ABOUT ]

Anisprite is a flexible sprite animation tool that allows for a more flexible, more robust, less finicky 
approach to sprite animation than what GameMaker's current built-in systems accomodate. Using Anisprite,
you can define animation datasets containing datata for several animations, assign that dataset to an 
Anisprite instance-struct, and dynamically switch between your pre-defined animations with a single method 
call. There are also a number of features that any 2D game-dev is likely to find useful, such as manual
frame-sequence overrides to avoid having to needlessly duplicate animation frames, per-animation-frame 
function calls and positional offsets, time-scaling, animation loop-points, and many more!


[ USAGE ]

Anisprites consists of 2 core aspects:

- 1: Animation Data
- 2: Anisprite instance-structs

The intended usage of this tool involves defining animation data in the editor (by default, in the 
global.anisprite_types struct), creating Anisprite instance-structs using the Anisprite() constructor,
using whichever instance or process you want to control them, calling their step() method whenever you
want their processes to update (usually in the controlling instance's Step event), and drawing them in a
similar fashion using the draw() method. There are a variety of other methods and member variables that can 
be used to further manipulate Anisprites, but those are the bare essentials of it. More information about
the other features will be featured in sections below.


[ DATASETS ]

An anisprite dataset is an array containing formatted animation data structs. Each index of the 
dataset array represents a distinct animation that any Anisprite using the dataset can utilize. It is 
recommended (but not mandatory) that you define these datasets as keyed values in the global.anisprite_types 
struct provided in the __Anisprite_types script.


[ ANIMATION DATA ]

Within a dataset array, animation data consists of formatted structs. Looking at the comments and provided 
"example" dataset in the __Anisprite_types script should serve as an intuitive guide on how to structure them, 
but I will detail the values for each animation here, because there are some notable nuances that deserve 
a more detailed explaination:

- sprites (array)
	>> Contains a list of sprite assets, each sprite representing a possible "orientation" for that animation.
	>> Animation orientations basically allow you to have multiple sets of animation frames for any given
		animation that you can switch between on the fly using the Anisprite's anim_orientation member variable.
	>> For example, if you were making a pseudo-top-down game like P**emon or Z**da, with different animations 
		for a character walking up, down, and left/right, you could contain all of those within a single "walk"
		animation and just change the orientation based on which direction they are moving.
	>> It should go without saying, but every animation needs at least one sprite in this array to function.
	>> NOTE: EVERY SPRITE ASSET IN THE ARRAY MUST HAVE THE SAME NUMBER OF FRAMES!
- offset_x (number)
- offset_y (number)
	>> Intuitively, these offset values additively change the position the Anisprite is drawn at, relative to the 
		position used in the Anisprite's draw() method.
