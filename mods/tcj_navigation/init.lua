

for i = 1,8 do
	core.register_craftitem("tcj_navigation:compass"..i, {
		description = "Compass",
		inventory_image = "tcj_compass" .. i .. ".png",
	})
end

core.register_globalstep(function(dtime)
	for _, player in pairs(core.get_connected_players()) do
		local inv = player:get_inventory()
		local compassindex = math.floor(player:get_look_horizontal() / (2 * math.pi) * 8 + 1)
		local compassitemname = "tcj_navigation:compass" .. compassindex
		for i, item in pairs(inv:get_list("main")) do
			if string.find(item:get_name(), "tcj_navigation:compass") and string.sub(item:get_name(), -1) ~= tostring(compassindex) then
				inv:set_stack("main", i, compassitemname)
			end
		end
	end
end)





local map_formspec = table.concat({
	"formspec_version[7]",
	"size[13,13]",
	"image[0.5,0.5;12,12;tcj_map.png]",
}, "\n")


core.register_craftitem("tcj_navigation:map", {
	description = "Map",
	inventory_image = "tcj_map_icon.png",
	on_use = function(itemstack, user)
		core.show_formspec(user:get_player_name(), "tcj_navigation:map", map_formspec)
	end,
})