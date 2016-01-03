------------------
-- Wizard class --
------------------

--
-- No Issue Yet
--

pclasses.api.register_class("wizard", {
	on_assigned = function(pname, inform)
		if inform then
	--		minetest.sound_play("pclasses_full_wizard", {to_player=pname, gain=1})
			minetest.chat_send_player(pname, "You are now a wizard.")
		end
		-- Add specs here
		minetest.log("action", "[PClasses] Player " .. pname .. " becomes a wizard")
	end,
	on_unassigned = function(pname)
	end,
	switch_params = {
		color = {r = 230, g = 230, b = 0},
		holo_item = "default:book"
	}
})

-- Reserved items here 
