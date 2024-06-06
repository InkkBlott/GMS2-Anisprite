if (keyboard_check_pressed(vk_up) and anisprite_1.anim < 2) anisprite_1.anim_orientation = 1
if (keyboard_check_pressed(vk_down) and anisprite_1.anim < 2) anisprite_1.anim_orientation = 0
if (keyboard_check_pressed(vk_shift)) {
	test_speed += 0.5
	if (test_speed > 3) test_speed = 0.5
}
anisprite_1.face_direction = point_direction(x, y, mouse_x, mouse_y)

anisprite_1.step(test_speed)

if (keyboard_check_pressed(vk_right)) {
	test_anim ++
	test_anim %= 4
	anisprite_1.set_anim(test_anim)
}
else if (keyboard_check_pressed(vk_left)) {
	test_anim --
	if (test_anim < 0) test_anim += 4
	anisprite_1.set_anim(test_anim)
}