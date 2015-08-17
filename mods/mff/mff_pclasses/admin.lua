-----------------
-- Admin class --
-----------------

--
-- https://github.com/MinetestForFun/minetest-minetestforfun-server/issues/139
--

pclasses.api.register_class("admin", {
	on_assigned = function(pname)
		minetest.chat_send_player(pname, "Hello admin.")
	end,
	switch_params = {
		color = {r = 255, g = 00, b = 224}
	}
})

pclasses.api.reserve_item("admin", "3d_armor:helmet_admin")
pclasses.api.reserve_item("admin", "3d_armor:chestplate_admin")
pclasses.api.reserve_item("admin", "3d_armor:leggings_admin")
pclasses.api.reserve_item("admin", "3d_armor:boots_admin")
pclasses.api.reserve_item("admin", "shields:shields_admin")
pclasses.api.reserve_item("admin", "maptools:pick_admin")
pclasses.api.reserve_item("admin", "maptools:pick_admin_with_drops")
