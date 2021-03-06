if not DISABLE_WOODEN_BOW then
	throwing_register_bow ('bow_wood', 'Wooden bow', {x=1, y=1, z=0.5}, 11, 1.6, 50, false, {
			{'', 'default:stick', ''},
			{'farming:string', '', 'default:stick'},
			{'', 'default:stick', ''},
		})
end

if not DISABLE_LONGBOW then
	throwing_register_bow ('longbow', 'Longbow', {x=1, y=2.5, z=0.5}, 17, 1.5, 100, false, {
			{'farming:string', 'group:wood', ''},
			{'farming:string', '', 'group:wood'},
			{'farming:string', 'group:wood', ''},
		})
end

if not DISABLE_COMPOSITE_BOW then
	throwing_register_bow ('bow_composite', 'Composite bow', {x=1, y=1.4, z=0.5}, 17, 2, 150, false, {
			{'farming:string', 'group:wood', ''},
			{'farming:string', '', 'default:steel_ingot'},
			{'farming:string', 'group:wood', ''},
		})
end

if not DISABLE_STEEL_BOW then
	throwing_register_bow ('bow_steel', 'Steel bow', {x=1, y=1.4, z=0.5}, 20, 1.4, 250, false, {
			{'farming:string', 'default:steel_ingot', ''},
			{'farming:string', '', 'default:steel_ingot'},
			{'farming:string', 'default:steel_ingot', ''},
		})
end

if not DISABLE_ROYAL_BOW then
	throwing_register_bow ('bow_royal', 'Royal bow', {x=1, y=1.5, z=0.5}, 25, 1.3, 750, false, {
			{'farming:string', 'group:wood', 'default:diamond'},
			{'farming:string', '', 'default:gold_ingot'},
			{'farming:string', 'group:wood', 'default:diamond'},
		})
end

--function throwing_register_bow (name, desc, scale, stiffness, reload_time, toughness, is_cross, craft)
if not DISABLE_MINOTAUR_HORN_BOW then
	throwing_register_bow ('bow_minotaur_horn', 'Minotaur Horn Bow (Hunter)', {x=1, y=1.5, z=0.5}, 35, 1.2, 1000, false, {
			{'farming:string', 'mobs:minotaur_horn', 'mobs:minotaur_horn'},
			{'farming:string', '', 'moreores:mithril_ingot'},
			{'farming:string', 'mobs:minotaur_horn', 'mobs:minotaur_horn'},
		})
end

--function throwing_register_bow (name, desc, scale, stiffness, reload_time, toughness, is_cross, craft)
if not DISABLE_MINOTAUR_HORN_IMPROVED_BOW then
	throwing_register_bow ('bow_minotaur_horn_improved', 'Minotaur Horn Improved Bow (Hunter)', {x=1, y=1.5, z=0.5}, 50, 1.5, 2000, false, {
			{'throwing:bow_minotaur_horn', 'throwing:string_mithril'},
		})
end

if not DISABLE_CROSSBOW then
	throwing_register_bow ('crossbow', 'Crossbow', {x=1, y=1.3, z=0.5}, 28, 5, 80, true, {
			{'group:wood', 'farming:string', ''},
			{'default:steel_ingot', 'farming:string', 'group:wood'},
			{'group:wood', 'farming:string', ''},
		})
end

if not DISABLE_ARBALEST then
	throwing_register_bow ('arbalest', 'Arbalest', {x=1, y=1.3, z=0.5}, 35, 7.5, 120, true, {
			{'default:steel_ingot', 'farming:string', 'default:stick'},
			{'default:steel_ingot', 'farming:string', 'default:steel_ingot'},
			{'default:steel_ingot', 'farming:string', 'default:stick'},
		})
end

if not DISABLE_AUTOMATED_ARBALEST then
	throwing_register_bow ('arbalest_auto', 'Automated arbalest', {x=1, y=1.3, z=0.5}, 40, 3.5, 60, true, {
			{'default:steel_ingot', 'farming:string', 'default:mese_crystal'},
			{'default:steel_ingot', 'farming:string', 'default:steel_ingot'},
			{'default:steel_ingot', 'farming:string', 'default:mese_crystal'},
		})
end
