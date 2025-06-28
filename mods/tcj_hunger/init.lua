

tcj_hunger = {}

tcj_hunger.max_food = 20
tcj_hunger.default_hunger_rate = -1/40
tcj_hunger.default_starving_damage_rate = -1/20
tcj_hunger.health_regain_rate = 1/10


tcj_hunger.get_hunger = function(player)
	return player:get_meta():get_float("food")
end

tcj_hunger.adjust_hunger = function(player, amount)
	player:get_meta():set_float("food", math.min(tcj_hunger.max_food, math.max(0, tcj_hunger.get_hunger(player) + amount)))
	tcj_hunger.update_hunger_statbar(player)
end

tcj_hunger.item_eat = function(amount)
	return function(itemstack, user)
		tcj_hunger.adjust_hunger(user, amount)
		itemstack:take_item()
		return itemstack
	end
end


core.register_on_newplayer(function(player)
	player:get_meta():set_float("food", tcj_hunger.max_food)
end)

local player_hungerbar_ids = {}
core.register_on_joinplayer(function(player)
	player_hungerbar_ids[player:get_player_name()] = player:hud_add({
		type = "statbar",
		position = {x = 0.5, y = 1},
		offset = {x = -265, y = -112},
		size = {x = 24, y = 24},
		direction = 0,
		text = "tcj_bread.png",
		number = tcj_hunger.get_hunger(player),
	})
end)


tcj_hunger.update_hunger_statbar = function(player)
	player:hud_change(player_hungerbar_ids[player:get_player_name()], "number", tcj_hunger.get_hunger(player))
end


winter.register_timer("update_hunger", 5, function(dtime)
	for _, player in pairs(core.get_connected_players()) do
		tcj_hunger.adjust_hunger(player, tcj_hunger.default_hunger_rate * dtime)
		local hunger = tcj_hunger.get_hunger(player)
		if hunger <= 0 then
			player:set_hp(player:get_hp() + tcj_hunger.default_starving_damage_rate * dtime)
		else
			local health_increase = tcj_hunger.health_regain_rate * (hunger / tcj_hunger.max_food) * dtime
			if health_increase < 1 then
				player:set_hp(player:get_hp() + (math.random() < health_increase and 1 or 0))
			else
				player:set_hp(player:get_hp() + health_increase)
			end
		end
	end
end)


dofile(core.get_modpath("tcj_hunger") .. "/food.lua")