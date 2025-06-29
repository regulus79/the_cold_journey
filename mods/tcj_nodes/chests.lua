

tcj_nodes.regsiter_chest = function(name, tiles, infotext, width, height, item_probs)
	local update_chest = function(pos)
		local meta = core.get_meta(pos)
		meta:set_string("formspec", table.concat({
			"size[8,7]",
			string.format("list[context;main;0,0;%d,%d]", width, height),
			"list[current_player;main;0,3;8,4]",
			"listring[]",
		}, "\n"))
		meta:set_string("infotext", infotext)
		if meta:get_inventory():get_size("main") == 0 then
			meta:get_inventory():set_size("main", width*height)
			for _, item_prob in pairs(item_probs) do
				if math.random() < item_prob.prob then
					meta:get_inventory():add_item("main", item_prob.item)
				end
			end	
		end
	end
	core.register_node("tcj_nodes:chest_"..name, {
		description = "Chest " .. name,
		tiles = tiles,
		groups = {axeable = 1},
		paramtype2 = "facedir",
		on_construct = update_chest,
	})
	core.register_abm({
		label = "Populate chest: " ..  name,
		nodenames = {"tcj_nodes:chest_"..name},
		interval = 5,
		chance = 1,
		action = update_chest,
	})
end




tcj_nodes.regsiter_chest(
	"chest1",
	{"tcj_chest1_top.png", "tcj_chest1_top.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_front.png"},
	"Chest",
	8, 2,
	{
		{item = "tcj_fire:match 3", prob = 1},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_fire:stick", prob = 0.5},
	}
)


tcj_nodes.regsiter_chest(
	"chest2",
	{"tcj_chest1_top.png", "tcj_chest1_top.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_front.png"},
	"Chest",
	8, 2,
	{
		{item = "tcj_clothing:hat", prob = 1},
		{item = "tcj_hunger:bread", prob = 0.2},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_fire:stick", prob = 0.5},
	}
)

tcj_nodes.regsiter_chest(
	"chest3",
	{"tcj_chest1_top.png", "tcj_chest1_top.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_front.png"},
	"Chest",
	8, 2,
	{
		{item = "tcj_clothing:coat", prob = 1},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_hunger:bread", prob = 0.2},
		{item = "tcj_navigation:map", prob = 1},
	}
)

tcj_nodes.regsiter_chest(
	"chest4",
	{"tcj_chest1_top.png", "tcj_chest1_top.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_front.png"},
	"Chest",
	8, 2,
	{
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_hunger:bread", prob = 0.2},
		{item = "tcj_clothing:pants", prob = 1},
		{item = "tcj_fire:stick", prob = 0.5},
	}
)

tcj_nodes.regsiter_chest(
	"chest5",
	{"tcj_chest1_top.png", "tcj_chest1_top.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_front.png"},
	"Chest",
	8, 2,
	{
		{item = "tcj_hunger:bread", prob = 1},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_clothing:boots", prob = 1},
	}
)

tcj_nodes.regsiter_chest(
	"chest6",
	{"tcj_chest1_top.png", "tcj_chest1_top.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_side.png", "tcj_chest1_front.png"},
	"Chest",
	8, 2,
	{
		{item = "tcj_hunger:bread", prob = 1},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_fire:stick", prob = 0.5},
		{item = "tcj_hunger:bread 3", prob = 1},
		{item = "tcj_hunger:bread 2", prob = 1},
		{item = "tcj_navigation:compass1", prob = 1},
	}
)
