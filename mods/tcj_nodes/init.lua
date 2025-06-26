
tcj_nodes = {}


minetest.register_node("tcj_nodes:stone1", {
    description = "Stone",
    tiles = {"tcj_stone1.png"},
    groups = {pickaxeable = 1},
})

minetest.register_node("tcj_nodes:dirt1", {
    description = "Dirt",
    tiles = {"tcj_dirt1.png"},
    groups = {shovelable = 2},
})
for i = 1, 2 do
    minetest.register_node("tcj_nodes:path1_"..i, {
        description = "Test path slab"..i,
        tiles = {"tcj_dirt1.png"},
        groups = {shovelable = 1, no_dust = (i == 2 and 0.9 or 1)},
        drawtype = "nodebox",
        drop = "tcj_nodes:dirt1",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -0.5 + i/2, 0.5}
        }
    })
end

minetest.register_node("tcj_nodes:dirt_with_snow1", {
    description = "Test dirt with snow",
    tiles = {
        "tcj_snow1.png",
        "tcj_dirt1.png",
        "tcj_dirt1.png^tcj_snow1_sideoverlay.png",
    },
    drop = "tcj_nodes:dirt1",
    groups = {shovelable = 2},
})

minetest.register_node("tcj_nodes:dirt_with_snow_village1", {
    description = "Test dirt with snow for villages, no tree grows here, unbreakable",
    tiles = {
        "tcj_snow1.png",
        "tcj_dirt1.png",
        "tcj_dirt1.png^tcj_snow1_sideoverlay.png",
    },
    groups = {unbreakable = 1},
})

for i = 1,4 do
    minetest.register_node("tcj_nodes:wood"..i, {
        description = "Wood",
        tiles = {"tcj_wood"..i..".png"},
        groups = {cuttable = 1},
    })
end

for i = 1,2 do
    minetest.register_node("tcj_nodes:leaves"..i, {
        description = "Leaves",
        tiles = {"tcj_leaves"..i..".png"},
        use_texture_alpha = "blend",
        drawtype = "allfaces_optional",
        paramtype = "light",
        groups = {cuttable = 1},
    })
end

for i = 1,3 do
    minetest.register_node("tcj_nodes:tree"..i, {
        description = "Test tree"..i,
        tiles = {
            "tcj_tree"..i..".png",
            "tcj_tree"..i..".png",
            "tcj_tree"..i.."_side.png",
            "tcj_tree"..i.."_side.png",
            "tcj_tree"..i.."_side.png",
            "tcj_tree"..i.."_side.png",
        },
        groups = {axeable = 1},
        paramtype2 = "facedir",
        on_place = minetest.rotate_node,
    })
end

for i = 1,2 do
    minetest.register_node("tcj_nodes:cobble"..i, {
        description = "Test cobble"..i,
        tiles = {"tcj_cobble"..i..".png"},
        groups = {pickaxeable = 1},
    })
end

minetest.register_node("tcj_nodes:gravel1", {
    description = "Test gravel",
    tiles = {"tcj_gravel1.png"},
    groups = {shovelable = 1},
})


minetest.register_node("tcj_nodes:lantern1", {
    description = "Test lantern1",
    tiles = {"tcj_lantern1.png"},
    paramtype = "light",
    groups = {pickaxeable = 1},
    light_source = 14,
})


for i = 1,2 do
    minetest.register_node("tcj_nodes:glass"..i, {
        description = "Test glass"..i,
        tiles = {"tcj_glass"..i..".png"},
        use_texture_alpha = "blend",
        drawtype = "glasslike",
        paramtype = "light",
        groups = {pickaxeable = 1},
    })
end


for i = 1,4 do
    minetest.register_node("tcj_nodes:flowers"..i, {
        description = "Test flowers"..i,
        tiles = {"tcj_flowers"..i..".png"},
        walkable = false,
        buildable_to = true,
        move_resistance = 1,
        paramtype = "light",
        drawtype = "plantlike",
        paramtype2 = "meshoptions",
        groups = {cuttable = 1},
        selection_box = {
            type = "fixed",
            fixed = {-3/16, -8/16, -3/16, 3/16, -2/16, 3/16}
        },
    })
end


minetest.register_node("tcj_nodes:plaster1", {
    description = "Test plaster",
    tiles = {"tcj_plaster1.png"},
    groups = {pickaxeable = 1},
})
minetest.register_node("tcj_nodes:plastertile1", {
    description = "Test plaster tile",
    tiles = {"tcj_plastertile1.png"},
    groups = {pickaxeable = 1},
})
minetest.register_node("tcj_nodes:plastercrosstile1", {
    description = "Test plaster cross tile",
    tiles = {"tcj_plastercrosstile1.png"},
    groups = {pickaxeable = 1},
})
for i = 1, 2 do
    minetest.register_node("tcj_nodes:stonebrick" .. i, {
        description = "Test stone brick" .. i,
        tiles = {"tcj_stonebrick" .. i .. ".png"},
        groups = {pickaxeable = 1},
    })
end



minetest.register_node("tcj_nodes:water_source", {
    description = "Test water source",
    drawtype = "liquid",
    waving = 1,
    tiles = {"tcj_water.png"},
    use_texture_alpha = "blend",
    paramtype = "light",
    walkable = false,
    pointable = false,
    buildable_to = true,
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "tcj_nodes:water_flowing",
    liquid_alternative_source = "tcj_nodes:water_source",
    liquid_viscosity = 1,
    post_effect_color = {a = 103, r = 70, g = 80, b = 100},
    groups = {water = 1},
})

minetest.register_node("tcj_nodes:water_flowing", {
    description = "Test water flowing",
    drawtype = "flowingliquid",
    waving = 1,
    tiles = {"tcj_water.png"},
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    buildable_to = true,
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "tcj_nodes:water_flowing",
    liquid_alternative_source = "tcj_nodes:water_source",
    liquid_viscosity = 1,
    post_effect_color = {a = 103, r = 70, g = 80, b = 100},
    groups = {water = 1},
})


minetest.register_node("tcj_nodes:ice", {
    description = "Ice",
    tiles = {"tcj_ice.png"},
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.45, -0.5, 0.5, -0.25, 0.5}
    },
    groups = {pickaxeable = 1, shovelable = 2, no_dust = 1},
    paramtype = "light",
})
for i = 1,2 do
    minetest.register_node("tcj_nodes:ice_cracked"..i, {
        description = "Ice Cracked "..i,
        tiles = {"tcj_ice_cracked"..i..".png"},
        groups = {pickaxeable = 1, shovelable = 2, no_dust = 1},
        drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {-0.5, -0.45, -0.5, 0.5, -0.25, 0.5}
        },
        paramtype = "light",
    })
end

-- Ice cracking
local surrounding_nodes = {
    vector.new(-1, 0, -1),
    vector.new(-1, 0, 0),
    vector.new(-1, 0, 1),
    vector.new(0, 0, -1),
    vector.new(0, 0, 0),
    vector.new(0, 0, 1),
    vector.new(1, 0, -1),
    vector.new(1, 0, 0),
    vector.new(1, 0, 1),
}
winter.register_timer("ice_cracking", 0.5, function()
    for _, player in pairs(core.get_connected_players()) do
        for _, offset in pairs(surrounding_nodes) do
            if math.random() < 0.8 then
                local pos = player:get_pos() + offset
                local node = core.get_node(pos)
                if node.name == "tcj_nodes:ice" then
                    core.set_node(pos, {name = "tcj_nodes:ice_cracked1"})
                elseif node.name == "tcj_nodes:ice_cracked1" then
                    core.set_node(pos, {name = "tcj_nodes:ice_cracked2"})
                elseif node.name == "tcj_nodes:ice_cracked2" then
                    core.set_node(pos, {name = "air"})
                end
            end
        end
    end
end)



dofile(minetest.get_modpath("tcj_nodes").."/biomes.lua")
dofile(minetest.get_modpath("tcj_nodes").."/decorations.lua")
dofile(minetest.get_modpath("tcj_nodes").."/stairs.lua")
