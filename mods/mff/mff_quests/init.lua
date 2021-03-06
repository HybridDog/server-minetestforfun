mff.quests = {}
mff.QPREFIX = "mff_quests:"
mff.QNOPREFIX = function(s) return s:sub(mff.QPREFIX:len()+1) end

quests.set_hud_position(1, 0.31)
quests.set_hud_offset(-200, 0)

mff.quests.quests = {
	still_testing_quests = {
		title = "Stone digger",
		description = "TEST QUEST!\nGet a Super Apple at the end!",
		repeating = 60*60*24,
		awards = {["maptools:superapple"] = 1},
		tasks = {
			diggy = {
				title = "Dig 100 stone",
				description = "Show you can dig through stone",
				max = 100,
				objective = {
					dig = {"default:stone"}
				}
			}
		}
	},
	still_testing_quests2 = {
		title = "Coal digger",
		description = "TEST QUEST!\nGet a Diamond at the end!",
		repeating = 60*60*24,
		awards = {["default:diamond"] = 1},
		tasks = {
			diggy = {
				title = "Dig 20 coal",
				description = "Get the fire mineral",
				max = 20,
				objective = {
					dig = {"default:stone_with_coal"}
				}
			}
		}
	},
	still_testing_quests3 = {
		title = "Shiny diamonds",
		description = "TEST QUEST!\nGet a mithril ingot at the end!",
		repeating = 60*60*24,
		awards = {["moreores:mithril_ingot"] = 1},
		tasks = {
			diggy = {
				title = "Dig 5 diamonds",
				description = "Yarr harr fiddle dee-dee, being a pirate is alright with me! Do what you want 'cause a pirate is free, you are a pirate! Go get the precious booty... underground. Mine it :/",
				max = 5,
				objective = {
					dig = {"default:stone_with_diamond"}
				}
			}
		}
	},
	--[[ Disabled, Mesecons levers now use right click
	levermaniac = {
		title = "Levermaniac",
		description = "For some reason you've become obsessed with Mesecons's lever, causing you to insanely switch the levers on and off at an amazing speed.\nDoctors have diagnosed a strange brain damage, but said you'd be rewarded with a Super Apple if you can assist them in their research about the disease.\nThey simply ask you to flip a lever 5 times, but won't come to inspect and study you afterwards, which may suggest they also are brain damaged.",
		repeating = 60*60*24,
		max = 5,
		awards = {["maptools:superapple"] = 1},
		objective = {
			punch = {"mesecons_walllever:wall_lever"}
		}
	}]]
}

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
		return true
		end
	end
	return false
end

function mff.quests.start_quest(playername, qname, meta)
	quests.start_quest(playername, mff.QPREFIX .. qname, meta)
end

function mff.quests.handle_quest_end(playername, questname, metadata)
	for item, count in pairs(mff.quests.quests[mff.QNOPREFIX(questname)].awards) do
		local p = minetest.get_player_by_name(playername)
		if p then
			minetest.add_item(p:getpos(), {name=item, count=count, wear=0, metadata=""})
		end
	end
end

-- Register the quests defined above
for qname, quest in pairs(mff.quests.quests) do
	quest.completecallback = mff.quests.handle_quest_end
	local ret, err = quests.register_quest(mff.QPREFIX .. qname, quest)
	if not ret then
		minetest.log("error", "mff_quests: failed registering " .. qname .. ": " .. err)
	end
end

-- The callback function parameters are as follows:
--   questname, questdef,
--   taskname (nil?), taskdef (nil?),
--   objective_container (that is, either questdef or taskdef),
--   objective (=objectives_container.objectives),
--   function_to_update_the_objective_progress(value)
local function iterate_through_objectives(pname, callback)
	for qname, quest in pairs(mff.quests.quests) do
		if quest.tasks then
			for tname, task in pairs(quest.tasks) do
				if quests.is_task_disabled(pname, mff.QPREFIX .. qname, tname) == false then
					callback(qname, quest, tname, task, task, task.objective, function (value)
						quests.update_quest_task(pname, mff.QPREFIX .. qname, tname, value)
					end)
				end
			end
		else
			if quests.get_quest_progress(pname, mff.QPREFIX .. qname) ~= nil then
				callback(qname, quest, nil, nil, quest, quest.objective, function (value)
					quests.update_quest(pname, mff.QPREFIX .. qname, value)
				end)
			end
		end
	end
end

local function contains_node_or_group(table, element)
	for _, value in pairs(table) do
		if value == element or -- Simple node match
		   (value:len() > 6 and value:sub(0,6) == "group:" and
		   minetest.get_item_group(element, value:sub(7)) > 0) then -- Group
			return true
		end
	end
	return false
end

-- Quest objective: node digging
minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger or digger.is_fake_player then return end
	local pname = digger:get_player_name()
	iterate_through_objectives(pname, function (_, _, _, _, _, objective, update)
		if objective.dig and contains_node_or_group(objective.dig, oldnode.name) then
			update(1)
		end
	end)
end)

-- Quest objective: node punching
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if not puncher or puncher.is_fake_player then return end
	local pname = puncher:get_player_name()
	iterate_through_objectives(pname, function (_, _, _, _, _, objective, update)
		if objective.punch and contains_node_or_group(objective.punch, node.name) then
			update(1)
		end
	end)
end)

-- Quest objective: node placement
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if not placer or placer.is_fake_player then return end
	local pname = placer:get_player_name()
	iterate_through_objectives(pname, function (_, _, _, _, _, objective, update)
		if objective.place and contains_node_or_group(objective.place, newnode.name) then
			update(1)
		end
	end)
end)

minetest.register_on_joinplayer(function (player)
	local playername = player:get_player_name()
	for _, qname in ipairs({"still_testing_quests", "still_testing_quests2", "still_testing_quests3", "levermaniac"}) do
		if not quests.quest_restarting_in(playername, mff.QPREFIX .. qname) then
			mff.quests.start_quest(playername, qname)
		end
	end
end)
