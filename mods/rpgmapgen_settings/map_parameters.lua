


local map_parameters = {}

map_parameters.noiseperiods = {500, 100, 50, 10}
map_parameters.noiseamps = {30, 10, 5, 1}


local routes = {
	{startpos = vector.new(30,0,0), endpos = vector.new(75,0,75), zigzags = 1, zigzag_amp = 0},
	{startpos = vector.new(75,0,75), endpos = vector.new(400,0,400), zigzags = 15, zigzag_amp = 80},
	{startpos = vector.new(400,0,400), endpos = vector.new(600,0,700), zigzags = 10, zigzag_amp = 50},
}

map_parameters.paths = {
}

for i, route in pairs(routes) do
	local dir = (route.endpos - route.startpos):normalize()
	local rotateddir = vector.new(-dir.z, dir.y, dir.x)
	for j = 1, 2*route.zigzags do
		local t0 = (j - 1) / (2*route.zigzags)
		local t1 = j / (2*route.zigzags)
		table.insert(map_parameters.paths, {
			startpos = route.startpos + (route.endpos - route.startpos) * t0 + rotateddir * route.zigzag_amp * math.sin(math.pi * t0 * route.zigzags),
			endpos = route.startpos + (route.endpos - route.startpos) * t1 + rotateddir * route.zigzag_amp * math.sin(math.pi * t1 * route.zigzags),
			radius = 3,
			node = "tcj_nodes:path1_2",
			halfheight_node = "tcj_nodes:path1_1",
			-- Add some noise for waviness in the path
			noise = {
				scale = 20,
				spread = vector.new(100,100,100),
			},
		})
	end
end


-- Circular areas around the map that are guaranteed to exist, for
-- use in story-based games which require stable areas for important locations
map_parameters.level_grounds = {
	{
		pos = vector.new(30,10,0),
		radius = 30,
		interpolation_length = 40,
		node = "tcj_nodes:dirt_with_snow_village1",
	},
	{
		pos = vector.new(400,150,400),
		radius = 30,
		interpolation_length = 40,
		node = "tcj_nodes:dirt_with_snow_village1",
	},
	{
		pos = vector.new(600,10,700),
		radius = 30,
		interpolation_length = 40,
		node = "tcj_nodes:dirt_with_snow_village1",
	},
}

map_parameters.schematics = {
	{
		pos = vector.new(30,10,0),
		approx_size = 20,
		file = core.get_modpath("rpgmapgen_settings") .. "/schems/loghouse1v1.mts",
		rotation = "0",
		replacements = {},
		force_placement = true,
		flags = "place_center_x,place_center_z",
	}
}


-- General map height, pre-noise
-- Mountain range at x+z = 400!
map_parameters.map_height = function(x,z)
	local dist_from_range = x + z - 800
	return 150 * math.exp(-(dist_from_range*dist_from_range) / (400*400)) + 20
end

-- Input is slope squared because it's faster to calcuate and doesn't really matter
-- Inspired by https://www.youtube.com/watch?v=gsJHzBTPG0Y
map_parameters.slope_adjustment = function(height, slope_squared)
    return height - 10 * slope_squared
end

return map_parameters