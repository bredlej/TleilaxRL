-- HOST_randomize_seed_xy must be registered inside C program before use

function randomize_seed(x, y)
	print(string.format("LUA called randomize_seed(%d, %d)", x, y))
	return HOST_randomize_seed_xy(x, y) -- return result of host C function call
end
