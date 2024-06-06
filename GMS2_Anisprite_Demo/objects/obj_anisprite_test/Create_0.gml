x = room_width/2
y = 140
anisprite_1 = new Anisprite("example", id)
anisprite_1.face_direction_horizontal_flip = true

test_anim = 0
test_speed = 1

draw_set_font(fnt_0)
text_pos = 160
desc_text = "<<Anisprite Prototype Demonstration>>\n\n"
		+ "- Anisprite faces the cursor\n"
		+ "[Left]/[Right] Change animation)\n"
		+ "[Up]/[Down] Change orientation (animations 0 and 1)\n"
		+ "[Shift] Change time-scale \n"