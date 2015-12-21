
print (" ---- Overrider christmas_craft = true! ---- ")

local dirttiles = {"snow.png", "default_dirt.png", {name = "default_dirt.png^grass_w_snow_side.png", tileable_vertical = false}}
local snowballdrop = {items = {'christmas_craft:snowball'}, rarity = 0}

local add_drop = function (def)
	if type(def.drop) == "table" then
		if def.drop.max_items then
			def.drop.max_items = def.drop.max_items + 1
		end
		table.insert(def.drop.items, snowballdrop)
	elseif type(def.drop) == "string" then
		def.drop = {
			items = {
				{items = {def.drop}, rarity = 0},
				snowballdrop
			}
		}
	else
		def.drop = {
			items = {
				snowballdrop
			}
		}
	end
end

local dirt_with_grass = minetest.registered_items["default:dirt_with_grass"]
minetest.override_item("default:dirt_with_grass", {tiles = dirttiles})
add_drop(dirt_with_grass)

local dirt_with_dry_grass = minetest.registered_items["default:dirt_with_dry_grass"]
minetest.override_item("default:dirt_with_dry_grass", {tiles = dirttiles})
add_drop(dirt_with_dry_grass)

local leavetiles = {"snow.png", "christmas_craft_leaves_top.png", "christmas_craft_leaves_side.png"}

-- Replace leaves
minetest.override_item("default:leaves", {tiles = leavetiles})

-- Replace jungleleaves
minetest.override_item("default:jungleleaves", {tiles = leavetiles})

-- Replace grass
for i=1,5 do
	minetest.override_item("default:grass_" .. i, {tiles = {"christmas_grass_"..i..".png"}})
end

-- Replace youngtrees
if minetest.registered_items["youngtrees:youngtree_top"] then
	minetest.override_item("youngtrees:youngtree_top", {tiles = {"christmas_youngtree16xa.png"}})
	minetest.override_item("youngtrees:youngtree_middle", {tiles = {"christmas_youngtree16xb.png"}})
end

print (" ---- Overrider christmas_craft [OK] ---- ")

