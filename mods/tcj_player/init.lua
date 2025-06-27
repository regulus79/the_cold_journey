
tcj_player = {}

-- For player model animations:
-- Walking: 0/24 to 20/24
-- Standing: 21/24 to 41/24
-- Mining: 42/24 to 54/24
-- Mine Walking: 55/24 to 75/24

local player_anim_states = {}
local WALKING = 0
local STANDING = 1
local DIGGING = 2
local WALKING_DIGGING = 3


tcj_player.base_inventory_formspec = table.concat({
    "size[8,8]",
    "list[current_player;main;0,4;8,4;]",
}, "\n")

tcj_player.formspec_prepend = table.concat({
    "background9[0,0;0,0;tcj_dialogue_background1.png;true;16]"
}, "\n")


minetest.register_on_joinplayer(function(player)
    player:set_formspec_prepend(tcj_player.formspec_prepend)
    if not core.is_creative_enabled() then
        tcj_clothing.update_inventory_formspec(player)
    end
    local props = player:get_properties()
    props.visual = "mesh"
    props.mesh = "tcj_player2.glb"
    props.textures = {"tcj_player_template.png"}
    props.visual_size = vector.new(1,1,1)
    player:set_properties(props)
    minetest.after(0, function()
        tcj_quests.update_quest_hud(player)
    end)
end)

minetest.register_globalstep(function(dtime)
    for _, player in pairs(minetest.get_connected_players()) do
        local control = player:get_player_control()
        if not control.dig then
            if control.up or control.down or control.right or control.left then
                if player_anim_states[player:get_player_name()] ~= WALKING then
                    player_anim_states[player:get_player_name()] = WALKING
                    player:set_animation({x = 0/24, y = 20/24}, 1)
                end
            else
                if player_anim_states[player:get_player_name()] ~= STANDING then
                    player_anim_states[player:get_player_name()] = STANDING
                    player:set_animation({x = 21/24, y = 41/24}, 1)
                end
            end
        else
            if control.up or control.down or control.right or control.left then
                if player_anim_states[player:get_player_name()] ~= WALKING_DIGGING then
                    player_anim_states[player:get_player_name()] = WALKING_DIGGING
                    player:set_animation({x = 55/24, y = 75/24}, 1)
                end
            else
                if player_anim_states[player:get_player_name()] ~= DIGGING then
                    player_anim_states[player:get_player_name()] = DIGGING
                    player:set_animation({x = 42/24, y = 54/24}, 1)
                end
            end
        end
    end
end)