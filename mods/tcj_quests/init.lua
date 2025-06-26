



tcj_quests = {}

dofile(minetest.get_modpath("tcj_quests") .. "/quests.lua")

-- Setup hud
local quest_text_hud_ids = {}
minetest.register_on_joinplayer(function(player)
    quest_text_hud_ids[player:get_player_name()] = player:hud_add({
        type = "text",
        text = "OBJECTIVES", -- used to be called quests, whatever
        number = 0xFFB930,
        position = {x = 1, y = 0},
        offset = {x = -100, y = 100},
        alignment = {x = -1, y = 1},
    })
end)

tcj_quests.construct_quest_hud_text = function(player)
    local text = {"OBJECTIVES"}
    for questname, questdata in pairs(tcj_quests.get_active_quests(player)) do
        local quest_title = questdata.hud_text or tcj_quests.quests[questname].hud_text or nil
        if quest_title ~= nil and quest_title ~= "" then
            table.insert(text, quest_title)
        end
    end
    return table.concat(text, "\n")
end

tcj_quests.update_quest_hud = function(player)
    player:hud_change(quest_text_hud_ids[player:get_player_name()], "text", tcj_quests.construct_quest_hud_text(player))
end

--
-- CALLBACKS
--

---- AAAAAAAAAAAAAAAAAAAA
--- HOW DO I DO THIS RIGHT I need to have npc be passed as an arg, but I gotta save it to meta too :sob:
tcj_quests.on_finish_dialogue = function(player, dialogue_id)
    for questname, questdata in pairs(tcj_quests.get_active_quests(player)) do
        local questdef = tcj_quests.quests[questname]
        if questdef.type == "custom" then
            local questdata = tcj_quests.get_active_quests(player)[questname]
            if questdef.on_finish_dialogue then
                local new_questdata = questdef.on_finish_dialogue(player, dialogue_id, questdata) or questdata
                tcj_quests.set_active_quest_data(player, questname, new_questdata)
            end
        elseif questdef.type == "complete_dialogue" and questdef.dialogue_id == dialogue_id then
            tcj_quests.complete_quest(player, questname)
        end
    end
end



tcj_quests.on_cast_spell = function(player, spell_id)
    for questname, questdata in pairs(tcj_quests.get_active_quests(player)) do
        local questdef = tcj_quests.quests[questname]
        if questdef.type == "custom" then
            local questdata = tcj_quests.get_active_quests(player)[questname]
            if questdef.on_cast_spell then
                local new_questdata = questdef.on_cast_spell(player, spell_id, questdata) or questdata
                tcj_quests.set_active_quest_data(player, questname, new_questdata)
            end
        elseif questdef.type == "cast_spell" and questdef.spell_id == spell_id then
            tcj_quests.complete_quest(player, questname)
        end
    end
end

minetest.register_on_dignode(function(pos, oldnode, digger)
    for questname, questdata in pairs(tcj_quests.get_active_quests(digger)) do
        local questdef = tcj_quests.quests[questname]
        if questdef.type == "custom" then
            local questdata = tcj_quests.get_active_quests(digger)[questname]
            if questdef.on_dignode then
                local new_questdata = questdef.on_dignode(pos, oldnode, digger, questdata) or questdata
                tcj_quests.set_active_quest_data(digger, questname, new_questdata)
            end
        elseif questdef.type == "dig_node" and questdef.what == oldnode.name then
            tcj_quests.complete_quest(digger, questname)
        end
    end
end)

minetest.register_globalstep(function()
    for _, player in pairs(minetest.get_connected_players()) do
        for questname, questdata in pairs(tcj_quests.get_active_quests(player)) do
            local questdef = tcj_quests.quests[questname]
            if questdef.type == "custom" then
                local questdata = tcj_quests.get_active_quests(player)[questname]
                if questdef.on_step then
                    local new_questdata = questdef.on_step(player, questdata) or questdata
                    tcj_quests.set_active_quest_data(player, questname, new_questdata)
                end
            elseif questdef.type == "go_to_pos" and player:get_pos():distance(questdef.pos) <= questdef.radius then
                tcj_quests.complete_quest(player, questname)
            end
        end
    end
end)


--
-- HELPER FUNCTIONS
--

tcj_quests.add_active_quest = function(player, questname)
    local meta = player:get_meta()
    local active_quests = minetest.deserialize(meta:get_string("active_quests")) or {}
    if not active_quests[questname] then
        active_quests[questname] = {}
    end
    if tcj_quests.quests[questname].on_start_quest then
        tcj_quests.quests[questname].on_start_quest(player, active_quests[questname])
    end
    meta:set_string("active_quests", minetest.serialize(active_quests))
    tcj_quests.update_quest_hud(player)
end

tcj_quests.set_active_quest_data = function(player, questname, questdata)
    local meta = player:get_meta()
    -- Only change questdata if quest is active, else do nothing (if you set it to something other than nil, it will count as an active quest)
    local active_quests = minetest.deserialize(meta:get_string("active_quests")) or {}
    if active_quests[questname] then
        active_quests[questname] = questdata
        meta:set_string("active_quests", minetest.serialize(active_quests))
    end
    -- Update quest hud beacuse hud_name could potentially have changed
    tcj_quests.update_quest_hud(player)
end

tcj_quests.get_active_quests = function(player)
    local meta = player:get_meta()
    return minetest.deserialize(meta:get_string("active_quests")) or {}
end

tcj_quests.remove_active_quest = function(player, questname)
    local meta = player:get_meta()
    local active_quests = minetest.deserialize(meta:get_string("active_quests")) or {}
    if active_quests[questname] then
        active_quests[questname] = nil
    end
    meta:set_string("active_quests", minetest.serialize(active_quests))
    tcj_quests.update_quest_hud(player)
end

tcj_quests.add_completed_quest = function(player, questname)
    local meta = player:get_meta()
    local completed_quests = minetest.deserialize(meta:get_string("completed_quests")) or {}
    if not completed_quests[questname] then
        completed_quests[questname] = {}
    end
    meta:set_string("completed_quests", minetest.serialize(completed_quests))
end

tcj_quests.get_completed_quests = function(player)
    local meta = player:get_meta()
    return minetest.deserialize(meta:get_string("completed_quests")) or {}
end

tcj_quests.complete_quest = function(player, questname)
    if tcj_quests.quests[questname].on_complete then
        local questdata = tcj_quests.get_active_quests(player)[questname]
        local new_questdata = tcj_quests.quests[questname].on_complete(player, questdata)
        tcj_quests.set_active_quest_data(player, questname, new_questdata)
    end
    tcj_quests.remove_active_quest(player, questname)
    tcj_quests.add_completed_quest(player, questname)
end

-- TESTING
minetest.register_chatcommand("quests", {
    description = "show quests stuff",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        minetest.debug("ACTIVE QUESTS: ", dump(tcj_quests.get_active_quests(player)))
        minetest.debug("COMPLETEd QUESTS: ", dump(tcj_quests.get_completed_quests(player)))
    end
})

minetest.register_chatcommand("add_quest", {
    description = "add a quest to be active",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        tcj_quests.add_active_quest(player, param)
    end
})

minetest.register_chatcommand("reset_quests", {
    description = "reset the completed and active quest tables",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local meta =player:get_meta()
        meta:set_string("active_quests", "")
        meta:set_string("completed_quests", "")
    end
})

