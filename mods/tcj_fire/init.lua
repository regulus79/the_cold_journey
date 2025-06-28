


tcj_fire = {}




--
-- Sticks
--

max_sticks_in_bundle = 6


for _, burning in pairs({"", "_burning"}) do
	for i = 1, max_sticks_in_bundle do
		core.register_node("tcj_fire:stick_bundle" .. burning .. i, {
			description = "Stick bundle " .. i,
			drawtype = "mesh",
			mesh = "stick_bundle.obj",
			paramtype = "light",
			light_source = burning ~= "" and 4 + 10 * i / max_sticks_in_bundle or 0,
			tiles = {
				string.format("tcj_stick_bundle.png^[fill:96x32:%d,0:#000000^[makealpha:0,0,0", math.min(95, i*16))
			},
			overlay_tiles = burning ~= "" and {
				{
					name = string.format("tcj_stick_bundle_burning_animated.png^[fill:96x192:%d,0:#000000^[makealpha:0,0,0", math.min(95, i*16)),
					animation = {
						type = "vertical_frames",
						aspect_w = 96,
						aspect_h = 32,
						length = 3.0,
					}
				}
			} or nil,
			buildable_to = true,
			walkable = false,
			damage_per_second = burning ~= "" and 2 or 0,
			use_texture_alpha = true,
			groups = {breakable_by_hand = 1},
			on_dig = function(pos, node, digger)
				-- Maybe don't give players burning sticks?
				if burning ~= "" then
					if math.random() < 0.5 then
						core.item_drop(digger:get_inventory():add_item("main", "tcj_fire:stick"), digger, pos)
					end
				else
					core.item_drop(digger:get_inventory():add_item("main", "tcj_fire:stick"), digger, pos)
				end
				if i > 1 then
					core.set_node(pos, {name = "tcj_fire:stick_bundle" .. burning .. tostring(i - 1)})
				else
					core.set_node(pos, {name = "air"})
				end
			end,
			on_timer = function(pos, elapsed)
				if math.random() < 0.5 then
					if i > 1 then
						core.set_node(pos, {name = "tcj_fire:stick_bundle" .. burning .. tostring(i - 1)})
					else
						core.set_node(pos, {name = "air"})
					end
				end
				return true
			end,
			on_construct = function(pos)
				core.get_node_timer(pos):start(8)
			end
		})
	end
end

-- Maybe don't use burning sticks
for _, burning in pairs({"", "_burning"}) do
	core.register_craftitem("tcj_fire:stick" .. burning, {
		description = (burning~="" and "Burning" or "") .. "Stick",
		inventory_image = (burning~="" and "tcj_stick_burning.png" or "tcj_stick.png"),
		on_place = function(itemstack, placer, pointed_thing)
			local node = core.get_node(pointed_thing.under)
			if string.find(node.name, "tcj_fire:stick_bundle_burning") then
				local nodenumber = tonumber(string.sub(node.name, -1))
				if nodenumber < max_sticks_in_bundle then
					core.set_node(pointed_thing.under, {name = "tcj_fire:stick_bundle_burning" .. tostring(nodenumber + 1)})
				else
					return
				end
			elseif string.find(node.name, "tcj_fire:stick_bundle") then
				local nodenumber = tonumber(string.sub(node.name, -1))
				if nodenumber < max_sticks_in_bundle then
					core.set_node(pointed_thing.under, {name = "tcj_fire:stick_bundle" .. burning .. tostring(nodenumber + 1)})
				else
					return
				end
			else
				core.item_place(ItemStack("tcj_fire:stick_bundle" .. burning .. "1"), placer, pointed_thing)
			end
			itemstack:take_item()
			return itemstack
		end
	})
end


dofile(core.get_modpath("tcj_fire") .. "/matches.lua")