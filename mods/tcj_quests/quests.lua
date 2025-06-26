

minetest.register_on_newplayer(function(player)
    minetest.after(0, function()
        tcj_quests.add_active_quest(player, "go_to_start")
        player:set_pos(vector.new(30.5,10.5,2.0))
    end)
end)



tcj_quests.quests = {
    go_to_start = {
        type = "go_to_pos",
        hud_text = "Go to the start",
        pos = vector.new(10,10,0),
        radius = 5,
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "go_to_midpoint")
        end
    },
    go_to_midpoint = {
        type = "go_to_pos",
        hud_text = "Go to the midpoint",
        pos = vector.new(400,200,400),
        radius = 20,
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "go_to_end")
        end
    },
    go_to_end = {
        type = "go_to_pos",
        hud_text = "Go to the end",
        pos = vector.new(600,10,700),
        radius = 20,
        on_complete = function(player, questdata)
            core.chat_send_player(player:get_player_name(), "You did it!")
        end
    },
    --[[
    find_a_place_to_stay = {
        type = "custom",
        hud_text = "Find a place to stay the night",
        on_start_quest = function(player, questdata)
            questdata.num_villagers_encountered = 0
        end,
        on_finish_dialogue = function(player, dialogue_id, questdata)
            if dialogue_id == "find_a_place_to_stay1" or dialogue_id == "find_a_place_to_stay2" or dialogue_id == "find_a_place_to_stay3" then
                questdata.num_villagers_encountered = questdata.num_villagers_encountered + 1
            end
            if questdata.num_villagers_encountered == 3 then
                tcj_quests.complete_quest(player, "find_a_place_to_stay")
                tcj_quests.add_active_quest(player, "ask_wizard_for_place_to_stay")
            end
        end
    },
    ask_wizard_for_place_to_stay = {
        type = "complete_dialogue",
        hud_text = "Ask the Wizard",
        dialogue_id = "ask_wizard_for_place_to_stay",
        on_complete = function(player, questdata)
            -- Find the npc. UGH this is bad but it's the only way I know of, since you can't serialize objects to store in meta, cuz like what if they rejoin?
            for object in minetest.objects_inside_radius(player:get_pos(), 8) do
                if not object:is_player() and object:get_luaentity().name == "tcj_npcs:oldman" then
                    object:get_luaentity()._target_waypoint = villages[1].waypoints.inside_library_second_room_center
                    object:get_luaentity()._state = "walk_to_waypoint"
                end
            end
            tcj_quests.add_active_quest(player, "go_inside_the_house")
        end
    },
    go_inside_the_house = {
        type = "go_to_pos",
        hud_text = "Follow the Wizard",
        pos = vector.new(-15,0,0),
        radius = 3,
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "talk_to_wizard_again")
        end
    },
    talk_to_wizard_again = {
        type = "complete_dialogue",
        hud_text = "Talk to the Wizard",
        dialogue_id = "talk_to_wizard_again",
        on_complete = function(player, questdata)
            for object in minetest.objects_inside_radius(player:get_pos(), 8) do
                if not object:is_player() and object:get_luaentity().name == "tcj_npcs:oldman" then
                end
            end
            tcj_quests.add_active_quest(player, "go_to_the_bedroom")
        end
    },
    go_to_the_bedroom = {
        type = "go_to_pos",
        hud_text = "Find the bedroom",
        pos = vector.new(-18.5,4.5,-6.5),
        radius = 2,
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "read_the_book_on_floor")
        end
    },
    read_the_book_on_floor = {
        type = "read_book",
        book_id = "bedroom_book",
        hud_text = "Read the book on the floor",
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "read_more_bedroom_books")
        end
    },
    read_more_bedroom_books = {
        type = "custom",
        hud_text = "Find more books",
        on_start_quest = function(player, questdata)
            questdata.num_books_read = 0
        end,
        on_read_book = function(player, book_id, questdata)
            if book_id == "bedroom_book2" or book_id == "bedroom_book3" then
                questdata.num_books_read = questdata.num_books_read + 1
            end
            if questdata.num_books_read >= 2 then
                tcj_quests.complete_quest(player, "read_more_bedroom_books")
                tcj_quests.add_active_quest(player, "find_the_library")
            end
            return questdata
        end
    },
    find_the_library = {
        type = "cast_spell",
        spell_id = "reveal",
        hud_text = "Find the Library",
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "enter_the_library")
        end
    },
    enter_the_library = {
        type = "go_to_pos",
        hud_text = "",
        pos = vector.new(-31,0,-2),
        radius = 3,
        on_complete = function(player, questdata)
            tcj_player.timeofday = 0.3
            minetest.after(8, function()
                tcj_quests.add_active_quest(player, "talk_to_wizard_in_library")
            end)
            tcj_quests.add_active_quest(player, "find_all_four_books")
        end
    },
    talk_to_wizard_in_library = {
        type = "complete_dialogue",
        hud_text = "Talk to the Wizard",
        dialogue_id = "talk_to_wizard_in_library",
        on_complete = function(player, questdata)
            -- Find the npc. UGH this is bad but it's the only way I know of, since you can't serialize objects to store in meta, cuz like what if they rejoin?
            for object in minetest.objects_inside_radius(player:get_pos(), 8) do
                if not object:is_player() and object:get_luaentity().name == "tcj_npcs:oldman" then
                    object:get_luaentity()._force_disappear = true
                end
            end
            tcj_quests.add_active_quest(player, "go_to_the_pedestal")
        end
    },
    go_to_the_pedestal = {
        type = "go_to_pos",
        hud_text = "Travel to the Pedestals of Banishment",
        pos = villages[2].pos,
        radius = 10,
        on_complete = function(player, questdata)
            tcj_quests.add_active_quest(player, "find_the_book_of_banishment")
        end
    },
    find_the_book_of_banishment = {
        type = "read_book",
        book_id = "the_book_of_banishment",
        hud_text = "Find the Book of Banishment",
        on_complete = function(player, questdata)
            local find_all_four_books_questdata = tcj_quests.get_active_quests(player).find_all_four_books
            if find_all_four_books_questdata then
                find_all_four_books_questdata.hud_text = "Find the four books"
                tcj_quests.set_active_quest_data(player, "find_all_four_books", find_all_four_books_questdata)
            end
            tcj_quests.add_active_quest(player, "meet_darkness1")
        end
    },
    meet_darkness1 = {
        type = "go_to_pos",
        pos = vector.new(150, 0, -45),
        radius = 50,
        hud_text = "",
        on_complete = function(player, questdata)
            tcj_cutscenes.start_darkness_cutscene1(player)
        end
    },
    find_all_four_books = {
        type = "custom",
        hud_text = "",--"Find the four books", -- empty at first, onyl appears after find the book of banishment. This is to prevent bugs with players getting the books too early.
        on_start_quest = function(player, questdata)
            questdata.num_books_read = 0
        end,
        on_get_book = function(player, book_id, questdata)
            if book_id == "the_book_of_light" or book_id == "the_book_of_darkness" or book_id == "the_book_of_truth" or book_id == "the_book_of_lies" then
                questdata.num_books_read = questdata.num_books_read + 1
            end
            if questdata.num_books_read >= 4 then
                tcj_quests.complete_quest(player, "find_all_four_books")
                tcj_quests.add_active_quest(player, "banish_the_darkness")
                tcj_quests.add_active_quest(player, "meet_darkness2")
            end
            return questdata
        end
    },
    meet_darkness2 = {
        type = "go_to_pos",
        pos = vector.new(150, 0, -45),
        radius = 50,
        hud_text = "",
        on_complete = function(player, questdata)
            tcj_cutscenes.start_darkness_cutscene2(player)
        end
    },
    banish_the_darkness = {
        type = "custom",
        hud_text = "Banish the Darkness",
        -- To be handled by the spell. If the spell is successful, it will complete this quest.
    },
    ]]
}

