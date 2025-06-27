


--[[
core.register_node("tcj_fire:matchbox", {
	description = "Matchbox",
	tiles = {"tcj_matchbox.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		{-2/16, -0.5, -3/16, 2/16, -14/16, 3/16},
	},
	on_construct = function(pos)
		core.debug(core.get_meta(pos))
	end
	on_place
})
]]
core.register_craftitem("tcj_fire:match", {
	description = "Match",
	inventory_image = "tcj_match.png",
	on_use = function(itemstack, user, pointed_thing)
		local nodename = core.get_node(pointed_thing.under).name
		if string.find(nodename, "tcj_fire:stick_bundle") then
			local nodenumber = string.sub(nodename, -1)
			core.set_node(pointed_thing.under, {name = "tcj_fire:stick_bundle_burning" .. nodenumber})
			itemstack:take_item()
			return itemstack
		end
	end
})