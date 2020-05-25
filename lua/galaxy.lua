require 'lua/galaxy_c_bindings'

function draw_galaxy(width, height) 
	for x = 0, width, 1
		do
		for y = 0, height, 1
			do
			randomize_seed(x + math.floor(galaxy["offset_x"]), y + math.floor(galaxy["offset_y"] ))

			randomNum = random_int(0, 43);
			if (randomNum == 0)
			then
				randomNum = random_int(0,100);
				
				if (randomNum < 10) 
					then
						galaxy_draw_char("O", x+5, y+5, 1)
					else if (randomNum >= 10 and randomNum < 50)
					then
						galaxy_draw_char("o", x+5, y+5, 2)
					else
						galaxy_draw_char("*", x+5, y+5, 3)
					end			
				end
			else
				galaxy_draw_char(" ", x+5, y+5, 1);
			end
		end
	end		
end
