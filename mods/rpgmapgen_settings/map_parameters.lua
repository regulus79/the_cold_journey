


local map_parameters = {}

map_parameters.noiseperiods = {500, 100, 50, 10}
map_parameters.noiseamps = {20, 10, 5, 1}


local routes = {
	-- Path to mountain
	{startpos = vector.new(60,0,-10), endpos = vector.new(100,0,300), radius = 2},
	{startpos = vector.new(100,0,300), endpos = vector.new(-1000,200,1000), radius = 2},
	-- Path by other side of river
	{startpos = vector.new(-1000,0,-100), endpos = vector.new(1000,0,1900), radius = 2},
	-- Path by this side of river
	{startpos = vector.new(100,0,300), endpos = vector.new(1100,0,1300), radius = 2},
	-- Path down south
	{startpos = vector.new(60,0,-10), endpos = vector.new(-400,0,-1000), radius = 2},
	-- Path by the southern mountains
	{startpos = vector.new(-400,0,-1000), endpos = vector.new(1000,0,-1000), radius = 3},
	{startpos = vector.new(-400,0,-1000), endpos = vector.new(-1000,0,-1000), radius = 3},
}

map_parameters.paths = {
}

for i, route in pairs(routes) do
	local dir = (route.endpos - route.startpos):normalize()
	local rotateddir = vector.new(-dir.z, dir.y, dir.x)
	table.insert(map_parameters.paths, {
		startpos = route.startpos,
		endpos = route.endpos,
		radius = route.radius,
		node = "tcj_nodes:path1_2",
		halfheight_node = "tcj_nodes:path1_1",
		-- Add some noise for waviness in the path
		noise = {
			scale = 20,
			spread = vector.new(100,100,100),
		},
	})
end


-- Circular areas around the map that are guaranteed to exist, for
-- use in story-based games which require stable areas for important locations
map_parameters.level_grounds = {
	{
		pos = vector.new(50,10,0),
		radius = 30,
		interpolation_length = 80,
		node = "tcj_nodes:dirt_with_snow_village1",
	},
	{
		pos = vector.new(-1000,300,1000),
		radius = 30,
		interpolation_length = 80,
		node = "tcj_nodes:dirt_with_snow_village1",
	},
}

map_parameters.schematics = {
	{
		pos = vector.new(50,10,0),
		approx_size = 30,
		file = core.get_modpath("rpgmapgen_settings") .. "/schems/loghouse2v1.mts",
		rotation = "0",
		replacements = {},
		force_placement = true,
		flags = "place_center_x,place_center_z",
	},
	{
		pos = vector.new(-1000,300,1000),
		approx_size = 30,
		file = core.get_modpath("rpgmapgen_settings") .. "/schems/loghouse1v1.mts",
		rotation = "0",
		replacements = {},
		force_placement = true,
		flags = "place_center_x,place_center_z",
	}
}


-- General map height, pre-noise
-- Mountain range at z - x = 2000
-- river valley thing at z - x = 700
map_parameters.map_height = function(x,z)
	local dist_from_range = z - x - 2000
	local dist_from_river = z - x - 700
	local base_height = 40
	local moutain_height = 300 * math.exp(-(dist_from_range*dist_from_range) / (500*500))
	local river_height = -70 * math.exp(-(dist_from_river*dist_from_river) / (100*100))
	return base_height + moutain_height + river_height
end

-- Input is slope squared because it's faster to calcuate and doesn't really matter
-- Inspired by https://www.youtube.com/watch?v=gsJHzBTPG0Y
map_parameters.slope_adjustment = function(height, slope_squared)
    return height - 10 * slope_squared
end

return map_parameters