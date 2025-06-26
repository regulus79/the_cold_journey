
for i=1,1 do
    minetest.register_decoration({
        name = "tcj_nodes:tree"..i,
        deco_type = "schematic",
        place_on = {"tcj_nodes:dirt_with_snow1"},
        sidelen = 16,
        noise_params = {
            offset = 0,
            scale = 0.1,
            spread = {x = 100, y = 100, z = 100},
            seed = 0,
            octaves = 3,
            persistence = 0.5,
            lacunarity = 2,
        },
        schematic = minetest.get_modpath("tcj_nodes") .. "/schems/tree"..i..".mts",
        flags = "place_center_x, place_center_z",
        place_offset_y = 1,
        rotation = "random",
    })
end