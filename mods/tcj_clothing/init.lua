


tcj_clothing = {}

tcj_clothing.registered_clothes = {}

tcj_clothing.register_clothing = function(name, def)
	assert(def.description)
	assert(def.inventory_image)
	assert(def.texture)
	assert(def.groups)
	assert(def.groups.thermal_conductivity)
	def.name = name
	tcj_clothing.registered_clothes[name] = def

	core.register_craftitem(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		groups = def.groups,
		on_use = function(itemstack, user)
			tcj_clothing.equip_clothing(user, itemstack:get_name())
			itemstack:take_item(1)
			return itemstack
		end
	})
end


tcj_clothing.update_clothing_textures = function(player)
	local clothes = tcj_clothing.get_clothing(player)
	local textures = {"tcj_player_template.png"}
	for _, clothingname in pairs(clothes) do
		table.insert(textures, tcj_clothing.registered_clothes[clothingname].texture)
	end

    local props = player:get_properties()
    props.textures = {table.concat(textures, "^")}
    player:set_properties(props)
end

tcj_clothing.update_inventory_formspec = function(player)
	player:set_inventory_formspec(tcj_player.base_inventory_formspec .. tcj_clothing.get_formspec(player))
end

tcj_clothing.equip_clothing = function(player, clothingname)
	local clothes = tcj_clothing.get_clothing(player)
	table.insert(clothes, clothingname)
	player:get_meta():set_string("clothing", core.serialize(clothes))
	tcj_clothing.update_clothing_textures(player)
	tcj_clothing.update_inventory_formspec(player)
end

tcj_clothing.unequip_clothing = function(player, index)
	local clothes = tcj_clothing.get_clothing(player)
	core.add_item(player:get_pos(), player:get_inventory():add_item("main", clothes[index]))
	table.remove(clothes, index)
	player:get_meta():set_string("clothing", core.serialize(clothes))
	tcj_clothing.update_clothing_textures(player)
	tcj_clothing.update_inventory_formspec(player)
end

tcj_clothing.get_clothing = function(player)
	return core.deserialize(player:get_meta():get_string("clothing")) or {}
end


tcj_clothing.get_formspec = function(player)
	local clothes = tcj_clothing.get_clothing(player)
	local fs = {
		"anchor[0,0]",
		""
	}
	for i, clothingname in pairs(clothes) do
		local clothingdef = tcj_clothing.registered_clothes[clothingname]
		table.insert(fs, string.format("image_button[%f,%f;0.7,0.7;%s;clothing%d;]", math.random()*4, math.random()*2, clothingdef.inventory_image, i))
	end
	core.debug(dump(fs))
	return table.concat(fs, "\n")
end

core.register_on_player_receive_fields(function(player, formname, fields)
	for fieldname, _ in pairs(fields) do
		if string.find(fieldname, "clothing") then
			core.debug(string.sub(fieldname, 9, #fieldname))
			tcj_clothing.unequip_clothing(player, tonumber(string.sub(fieldname, 9, #fieldname)))
		end
	end
	core.debug(formname, dump(fields))
end)



core.register_on_joinplayer(function(player)
	tcj_clothing.update_clothing_textures(player)
	tcj_clothing.update_inventory_formspec(player)
end)




core.register_chatcommand("clothes", {
	description = "print clothes",
	func = function(name)
		core.chat_send_player(name, dump(tcj_clothing.get_clothing(core.get_player_by_name(name))))
	end
})
core.register_chatcommand("reset_clothes", {
	description = "delete all clothes from meta",
	func = function(name)
		local player = core.get_player_by_name(name)
		player:get_meta():set_string("clothing", "")
		tcj_clothing.update_clothing_textures(player)
		tcj_clothing.update_inventory_formspec(player)
	end
})



dofile(core.get_modpath("tcj_clothing") .. "/clothing.lua")