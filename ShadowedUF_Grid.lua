--[[ 
	Shadow Unit Frames (Grid), Mayen of Mal'Ganis (US) PvP
]]

local L = SUFGridLocals
local SL = ShadowUFLocals
local Grid = {}
local AceDialgo, AceRegistry, playerClass
ShadowUF:RegisterModule(Grid, "grid")

function Grid:OnDefaultsSet()
	ShadowUF.defaults.profile.units.raid.grid = {enabled = true, cursed = false, vertical = false, disabled = {},
		indicators = {
			["tl"] = {enabled = true, name = ShadowUFLocals["Top Left"], anchorPoint = "ITL", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = 8, y = 3},
			["tr"] = {enabled = true, name = ShadowUFLocals["Top Right"], anchorPoint = "ITR", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = -4, y = 3},
			["bl"] = {enabled = true, name = ShadowUFLocals["Bottom Left"], anchorPoint = "IBL", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = 8, y = 5},
			["br"] = {enabled = true, name = ShadowUFLocals["Bottom Right"], anchorPoint = "IBR", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = -4, y = 4},
			["c"] = {enabled = true, name = ShadowUFLocals["Center"], anchorPoint = "IC", anchorTo = "$parent", height = 20, width = 20, alpha = 1.0, x = 0, y = 0},
		},
		linked = {
			-- Shadow Protection -> Prayer of Shadow Protection
			[GetSpellInfo(976)] = GetSpellInfo(27683),
			-- Arcane Intelligent -> Arcane Brilliance
			[GetSpellInfo(1459)] = GetSpellInfo(43002),
			-- Dalaran Brilliance -> Arcane Brilliance
			[GetSpellInfo(61316)] = GetSpellInfo(43002),
			-- Mark of the Wild -> Gift of the Wild
			[GetSpellInfo(1126)] = GetSpellInfo(21849),
			-- Power Word: Fortitude -> Prayer of Fortitude
			[GetSpellInfo(1243)] = GetSpellInfo(21562),
		},
		auras = {
			-- Rejuvenation
			[GetSpellInfo(774)] = {indicator = "", group = L["Druid"], priority = 10, r = 0.66, g = 0.66, b = 1.0},
			-- Regrowth
			[GetSpellInfo(8936)] = {indicator = "", group = L["Druid"], priority = 10, r = 0.50, g = 1.0, b = 0.63},
			-- Lifebloom
			[GetSpellInfo(33763)] = {indicator = "", group = L["Druid"], priority = 10, r = 0.07, g = 1.0, b = 0.01},
			-- Wild Growth
			[GetSpellInfo(53248)] = {indicator = "", group = L["Druid"], priority = 10, r = 0.51, g = 0.72, b = 0.77},
			-- Gift of the Wild
			[GetSpellInfo(21849)] = {indicator = "", group = L["Druid"], priority = 10, r = 1.0, g = 0.33, b = 0.90},
			-- Abolish Poison
			[GetSpellInfo(2893)] = {indicator = "", group = L["Druid"], priority = 10, r = 0.40, g = 1.0, b = 0.45},
			-- Renew
			[GetSpellInfo(139)] = {indicator = "", group = L["Priest"], priority = 10, r = 1, g = 0.62, b = 0.88},
			-- Power Word: Shield
			[GetSpellInfo(17)] = {indicator = "", group = L["Priest"], priority = 10, r = 0.55, g = 0.69, b = 1.0},
			-- Prayer of Fortitude
			[GetSpellInfo(21562)] = {indicator = "", group = L["Priest"], priority = 10, r = 0.58, g = 1.0, b = 0.50},
			-- Abolish Disease
			[GetSpellInfo(552)] = {indicator = "", group = L["Priest"], priority = 10, r = 1.0, g = 0.79, b = 0.67},
			-- Prayer of Shadow Protection
			[GetSpellInfo(27683)] = {indicator = "", group = L["Priest"], priority = 10, r = 0.60, g = 0.18, b = 1.0},
			-- Sacred Shield
			[GetSpellInfo(53601)] = {indicator = "", group = L["Paladin"], priority = 10, r = 0.90, g = 1.0, b = 0.37},
			-- Earth Shield
			[GetSpellInfo(49284)] = {indicator = "", group = L["Shaman"], priority = 10, r = 0.26, g = 1.0, b = 0.26},
			-- Riptide
			[GetSpellInfo(61301)] = {indicator = "", group = L["Shaman"], priority = 10, r = 0.30, g = 0.24, b = 1.0},
			-- Focus Magic
			[GetSpellInfo(54648)] = {indicator = "", group = L["Mage"], priority = 10, r = 0.67, g = 0.76, b = 1.0},
			-- Arcane Brilliance
			[GetSpellInfo(43002)] = {indicator = "", group = L["Mage"], priority = 10, r = 0.10, g = 0.68, b = 0.88},
			-- Soulstone Ressurection
			[GetSpellInfo(20707)] = {indicator = "", group = L["Warlock"], priority = 10, r = 0.42, g = 0.21, b = 0.65},
			-- Saronite Vapors
			[GetSpellInfo(63337)] = {indicator = "c", group = L["General Vezax"], priority = 50, r = 0, g = 0, b = 0},
			-- Shadow Crash
			[GetSpellInfo(62659)] = {indicator = "c", group = L["General Vezax"], priority = 5, r = 0, g = 0, b = 0},
			-- Iron Roots
			[GetSpellInfo(63601)] = {indicator = "c", group = L["Freya"], priority = 0, r = 0, g = 0, b = 0},
			-- Nature's Fury
			[GetSpellInfo(63571)] = {indicator = "c", group = L["Freya"], priority = 100, r = 0, g = 0, b = 0},
			-- Slag Pot
			[GetSpellInfo(62717)] = {indicator = "c", group = L["Ignis the Furnace Master"], priority = 0, r = 0, g = 0, b = 0},
			-- Sentinel Blast
			[GetSpellInfo(64389)] = {indicator = "c", group = L["Auriaya"], priority = 20, r = 0, g = 0, b = 0},
			-- Rip Flesh
			[GetSpellInfo(64667)] = {indicator = "c", group = L["Auriaya"], priority = 0, r = 0, g = 0, b = 0},
			-- Savage Pounce
			[GetSpellInfo(64374)] = {indicator = "c", group = L["Auriaya"], priority = 10, r = 0, g = 0, b = 0},
			-- Feral Pounce
			[GetSpellInfo(64478)] = {indicator = "c", group = L["Auriaya"], priority = 5, r = 0, g = 0, b = 0},
			-- Devouring Flame
			[GetSpellInfo(64733)] = {indicator = "c", group = L["Razorscale"], priority = 10, r = 0, g = 0, b = 0},
			-- Brittle Skin
			[GetSpellInfo(62055)] = {indicator = "c", group = L["Kologarn"], priority = 0, r = 0, g = 0, b = 0},
			-- Stone Grip
			[GetSpellInfo(63981)] = {indicator = "c", group = L["Kologarn"], priority = 10, r = 0, g = 0, b = 0},
			-- Flash Freeze
			[GetSpellInfo(61969)] = {indicator = "c", group = L["Hodir"], priority = 0, r = 0, g = 0, b = 0},
			-- Battering Ram
			[GetSpellInfo(62376)] = {indicator = "", group = L["Flame Leviathan"], priority = 0, r = 0, g = 0, b = 0},
			-- Overwhelming Power
			[GetSpellInfo(64637)] = {indicator = "c", group = L["Assembly of Iron"], priority = 0, r = 0, g = 0, b = 0},
			-- Fusion Punch
			[GetSpellInfo(63493)] = {indicator = "c", group = L["Assembly of Iron"], priority = 0, r = 0, g = 0, b = 0},
			-- Searing Light
			[GetSpellInfo(63018)] = {indicator = "c", group = L["XT-002 Deconstructor"], priority = 0, r = 0, g = 0, b = 0},
			-- Gravity Bomb
			[GetSpellInfo(64234)] = {indicator = "c", group = L["XT-002 Deconstructor"], priority = 0, r = 0, g = 0, b = 0},
			-- Malady of the Mind
			[GetSpellInfo(63830)] = {indicator = "", group = L["Yogg-Saron"], priority = 50, r = 0, g = 0, b = 0},
			-- Draining Poison
			[GetSpellInfo(64152)] = {indicator = "c", group = L["Yogg-Saron"], priority = 5, r = 0, g = 0, b = 0},
			-- Dark Volley
			[GetSpellInfo(63038)] = {indicator = "c", group = L["Yogg-Saron"], priority = 0, r = 0, g = 0, b = 0},
			-- Sara's Blessing
			[GetSpellInfo(63134)] = {indicator = "c", group = L["Yogg-Saron"], priority = 25, r = 0, g = 0, b = 0},
			-- Dominate Mind
			[GetSpellInfo(63713)] = {indicator = "c", group = L["Yogg-Saron"], priority = 100, r = 0, g = 0, b = 0},
			-- Drain Life
			[GetSpellInfo(36655)] = {indicator = "", group = L["Yogg-Saron"], priority = 1, r = 0, g = 0, b = 0},
			-- Sara's Anger
			[GetSpellInfo(63147)] = {indicator = "", group = L["Yogg-Saron"], priority = 50, r = 0, g = 0, b = 0},
			-- Curse of Doom
			[GetSpellInfo(30910)] = {indicator = "", group = L["Yogg-Saron"], priority = 100, r = 0, g = 0, b = 0},
			-- Insane
			[GetSpellInfo(63120)] = {indicator = "c", group = L["Yogg-Saron"], priority = 100, r = 0, g = 0, b = 0},
			-- Squeeze
			[GetSpellInfo(64125)] = {indicator = "c", group = L["Yogg-Saron"], priority = 75, r = 0, g = 0, b = 0},
		}
	}

	-- Also lets make sure that the player class is set of course
	playerClass = select(2, UnitClass("player"))
	
	-- Hook into the coloring to make sure our color override is set if needed.
	local UpdateColor = ShadowUF.modules.healthBar.UpdateColor
	ShadowUF.modules.healthBar.UpdateColor = function(self, frame, ...)
		-- Check if the unit is cursed, and we need to force it to color it by the debuff
		if( frame.unitType == "raid" and frame.grid and frame.grid.activeCurse ) then
			local color = DebuffTypeColor[frame.grid.activeCurse]
			if( color ) then
				frame.healthBar:SetStatusBarColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.alpha)
				frame.healthBar.background:SetVertexColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.backgroundAlpha)
				return
			end
		end
		
		return UpdateColor(self, frame, ...)
	end
end

function Grid:OnEnable(frame)
	-- Force a check cures check in case every aura is disabled
	ShadowUF.modules.auras:CheckCures()

	-- Not going to create the indicators we want here, will do that when we do the layout stuff
	frame.grid = frame.grid or CreateFrame("Frame", nil, frame)
	frame.grid.indicators = frame.grid.indicators or {}
	
	-- Of course, watch for auras
	frame:RegisterUnitEvent("UNIT_AURA", self, "UpdateAuras")
	frame:RegisterUpdateFunc(self, "UpdateAuras")
end

function Grid:OnDisable(frame)
	frame:UnregisterAll(self)
	frame.healthBar:SetOrientation("HORIZONTAL")
	
	if( frame.incHeal ) then
		frame.incHeal:SetOrientation("HORIZONTAL")
	end
end

local backdropTbl
function Grid:OnLayoutApplied(frame)
	if( not frame.grid ) then return end
	
	-- Set orientation of bars
	if( frame.healthBar ) then
		local orientation = ShadowUF.db.profile.units[frame.unitType].grid.vertical and "VERTICAL" or "HORIZONTAL"
		frame.healthBar:SetOrientation(orientation)
		
		if( frame.incHeal ) then
			frame.incHeal:SetOrientation(orientation)
		end
	end
	
	-- Create indicators
	backdropTbl = backdropTbl or {
		bgFile = "Interface\\Addons\\ShadowedUF_Grid\\backdrop",
		edgeFile = "Interface\\Addons\\ShadowedUF_Grid\\backdrop",
		tile = true,
		tileSize = 1,
		edgeSize = 1,
	}
	
	local id = 1
	local config = ShadowUF.db.profile.units[frame.unitType].grid
	for key, indicatorConfig in pairs(config.indicators) do
		-- Create indicator as needed
		local indicator = frame.grid.indicators[id]
		if( not indicator ) then
			indicator = CreateFrame("Frame", nil, frame.grid)
			indicator:SetFrameLevel(frame.topFrameLevel + 1)
			indicator.texture = indicator:CreateTexture(nil, "OVERLAY")
			indicator.texture:SetPoint("CENTER", indicator)
			indicator:SetAlpha(indicatorConfig.alpha)
			indicator:SetBackdrop(backdropTbl)
			indicator:SetBackdropColor(0, 0, 0, 1)
			
			indicator.cooldown = CreateFrame("Cooldown", nil, indicator, "CooldownFrameTemplate")
			indicator.cooldown:SetReverse(true)
			indicator.cooldown:SetPoint("CENTER", 0, -1)
			
			frame.grid.indicators[id] = indicator
		end
		
		-- Set up the sizing options
		indicator.enabled = indicatorConfig and indicatorConfig.enabled
		if( indicator.enabled ) then
			indicator:SetHeight(indicatorConfig.height)
			indicator.texture:SetWidth(indicatorConfig.width - 1)
			indicator:SetWidth(indicatorConfig.width)
			indicator.texture:SetHeight(indicatorConfig.height - 1)
			
			ShadowUF.Layout:AnchorFrame(frame, indicator, indicatorConfig)
			
			-- Let the auras module quickly access indicators without having to use index
			frame.grid.indicators[key] = indicator
		end
		
		id = id + 1
	end
end

local auraList = {}
local function scanAura(frame, unit, filter)
	local index = 1
	while( true ) do
		local name, rank, texture, count, debuffType, duration, endTime, caster, isStealable = UnitAura(unit, index, filter)
		if( not name ) then break end
			
		-- Setup the auras in the indicators baserd on priority
		name = ShadowUF.db.profile.units[frame.unitType].grid.linked[name] or name
		local auraConfig = ShadowUF.db.profile.units[frame.unitType].grid.auras[name]
		local indicator = auraConfig and frame.grid.indicators[auraConfig.indicator]
		if( indicator and indicator.enabled and auraConfig.priority > indicator.priority and not auraConfig.missing and ( not auraConfig.player or caster == "player" or caster == "vehicle" ) and not ShadowUF.db.profile.units[frame.unitType].grid.disabled[playerClass .. name] ) then
			indicator.priority = auraConfig.priority
			indicator.showIcon = auraConfig.icon
			indicator.showDuration = auraConfig.duration
			indicator.spellDuration = duration
			indicator.spellEnd = endTime
			indicator.spellIcon = texture
			indicator.colorR = auraConfig.r
			indicator.colorG = auraConfig.g
			indicator.colorB = auraConfig.b
		end
		
		-- Set the current debuff if we can cure it
		if( debuffType and filter == "HARMFUL" and ShadowUF.modules.auras.canRemove[debuffType] ) then
			frame.grid.currentCurse = debuffType
		end

		-- Save a small list that we can duplicate check, and figure out whats missing
		auraList[name] = true

		index = index + 1
	end
end

function Grid:UpdateIndicators(indicators)
	for id, indicator in pairs(indicators) do
		if( indicator.enabled and indicator.priority > -1 ) then
			-- Show a cooldown ring
			if( indicator.showDuration and indicator.spellDuration > 0 and indicator.spellEnd > 0 ) then
				indicator.cooldown:SetCooldown(indicator.spellEnd - indicator.spellDuration, indicator.spellDuration)
			else
				indicator.cooldown:Hide()
			end
			
			-- Show either the icon, or a solid color
			if( indicator.showIcon and indicator.spellIcon ) then
				indicator.texture:SetTexture(indicator.spellIcon)
				indicator:SetBackdropColor(0, 0, 0, 0)
			else
				indicator.texture:SetTexture(indicator.colorR, indicator.colorG, indicator.colorB)
				indicator:SetBackdropColor(0, 0, 0, 1)
			end
			
			indicator:Show()
		else
			indicator:Hide()
		end
	end
end

function Grid:UpdateAuras(frame)
	-- Reset flagging
	for _, indicator in pairs(frame.grid.indicators) do indicator.priority = -1 end
	for k in pairs(auraList) do auraList[k] = nil end
	
	frame.grid.currentCurse = nil
	
	-- Scan auras
	scanAura(frame, frame.unit, "HELPFUL")
	scanAura(frame, frame.unit, "HARMFUL")
	
	-- Check for any indicators that are triggered due to something missing
	for name, aura in pairs(ShadowUF.db.profile.units[frame.unitType].grid.auras) do
		if( aura.missing and not auraList[name] ) then
			local indicator = frame.grid.indicators[aura.indicator]
			if( indicator and indicator.enabled and aura.priority > indicator.priority and not ShadowUF.db.profile.units[frame.unitType].grid.disabled[playerClass .. name] ) then
				indicator.priority = aura.priority
				indicator.showIcon = aura.icon
				indicator.showDuration = aura.duration
				indicator.spellDuration = 0
				indicator.spellEnd = 0
				indicator.spellIcon = aura.iconTexture or select(3, GetSpellInfo(name))
				indicator.colorR = aura.r
				indicator.colorG = aura.g
				indicator.colorB = aura.b
			end
		end
	end
	
	-- Active curse changed, make sure we update coloring
	if( frame.grid.currentCurse ~= frame.grid.activeCurse ) then
		frame.grid.activeCurse = frame.grid.currentCurse
		ShadowUF.modules.healthBar:UpdateColor(frame)
	end
	
	-- Now force the indicators to update
	self:UpdateIndicators(frame.grid.indicators)
end


function Grid:OnConfigurationLoad()
	ShadowUF.Config.unitTable.args.bars.args.healthBar.args.vertical = {
		order = 0,
		type = "toggle",
		name = L["Enable vertical health"],
		desc = L["Changes the health bar to go from top -> bottom instead of right -> left when players lose health."],
		arg = "grid.vertical",
		hidden = function(info) return info[2] ~= "raid" end,
	}

	ShadowUF.Config.unitTable.args.bars.args.healthBar.args.cursed = {
		order = 0.10,
		type = "toggle",
		name = L["Enable debuff coloring"],
		desc = L["If the player is debuffed with something you can cure, the health bar will be colored with the debuff type."],
		arg = "grid.cursed",
		hidden = function(info) return info[2] ~= "raid" end,
	}
	
	local groupList = {}
	local function getAuraGroup(info)
		for k in pairs(groupList) do groupList[k] = nil end
		for _, aura in pairs(ShadowUF.db.profile.units.raid.grid.auras) do
			groupList[aura.group] = aura.group
		end
	
		return groupList
	end

	local auraList = {}
	local function getAuraList(info)
		for k in pairs(auraList) do auraList[k] = nil end
		for name in pairs(ShadowUF.db.profile.units.raid.grid.auras) do
			auraList[name] = name
		end
	
		return auraList
	end

	local indicatorList = {}
	local function getIndicatorList(info)
		for k in pairs(indicatorList) do indicatorList[k] = nil end
		indicatorList[""] = L["None (Disabled)"]
		for key, indicator in pairs(ShadowUF.db.profile.units.raid.grid.indicators) do
			indicatorList[key] = indicator.name
		end
		
		return indicatorList
	end

	local groupMap, auraMap, linkMap = {}, {}, {}
	local groupID, auraID, linkID = 0, 0, 0
	
	-- Actual aura configuration
	local auraGroupTable = {
		order = function(info)
			local group = groupMap[info[#(info)]]
			for _, class in pairs(SL.classes) do
				if( group == class ) then return 1 end
			end
			
			return 2
		end,
		type = "group",
		name = function(info) return groupMap[info[#(info)]] end,
		args = {},
	}
	
	local auraConfigTable = {
		order = 0,
		type = "group",
		inline = true,
		name = function(info) return auraMap[info[#(info)]] end,
		hidden = function(info)
			local group = groupMap[info[#(info) - 1]]
			local aura = auraMap[info[#(info)]]
			return ShadowUF.db.profile.units.raid.grid.auras[aura].group ~= group
		end,
		set = function(info, value, g, b, a)
			local aura = auraMap[info[#(info) - 1]]
			local key = info[#(info)]

			-- Changing the color
			if( key == "color" ) then
				ShadowUF.db.profile.units.raid.grid.auras[aura].r = value
				ShadowUF.db.profile.units.raid.grid.auras[aura].g = g
				ShadowUF.db.profile.units.raid.grid.auras[aura].b = b
				ShadowUF.db.profile.units.raid.grid.auras[aura].alpha = a
				ShadowUF.Layout:ReloadAll("raid")
				return
			end

			ShadowUF.db.profile.units.raid.grid.auras[aura][key] = value
			ShadowUF.Layout:ReloadAll("raid")
		end,
		get = function(info)
			local aura = auraMap[info[#(info) - 1]]
			local key = info[#(info)]
			local config = ShadowUF.db.profile.units.raid.grid.auras[aura]			
			if( key == "color" ) then
				return config.r, config.g, config.b, config.alpha
			end
			
			return config[key]
		end,
		args = {	
			indicator = {
				order = 1,
				type = "select",
				name = L["Show inside"],
				desc = L["Indicator this aura should be displayed in."],
				values = getIndicatorList,
				hidden = false,
			},
			sep1 = {
				order = 2,
				type = "description",
				name = "",
				width = "full",
				hidden = false,
			},
			priority = {
				order = 3,
				type = "range",
				name = L["Priority"],
				desc = L["If multiple auras are shown in the same indicator, the higher priority one is shown first."],
				min = 0, max = 100, step = 1,
				hidden = false,
			},
			color = {
				order = 4,
				type = "color",
				name = L["Indicator color"],
				desc = L["Solid color to use in the indicator, only used if you do not have use aura icon enabled."],
				hidden = false,
				hasAlpha = true,
			},
			sep2 = {
				order = 5,
				type = "description",
				name = "",
				width = "full",
				hidden = false,
			},
			icon = {
				order = 6,
				type = "toggle",
				name = L["Show aura icon"],
				desc = L["Instead of showing a solid color inside the indicator, the icon of the aura will be shown."],
				hidden = false,
			},
			duration = {
				order = 7,
				type = "toggle",
				name = L["Show aura duration"],
				desc = L["Shows a cooldown wheel on the indicator with how much time is left on the aura."],
				hidden = false,
			},
			player = {
				order = 8,
				type = "toggle",
				name = L["Only show self cast auras"],
				desc = L["Only auras you specifically cast will be shown."],
				hidden = false,
			},
			missing = {
				order = 9,
				type = "toggle",
				name = L["Only show if missing"],
				desc = L["Only active this aura inside an indicator if the group member does not have the aura."],
				hidden = false,
			},
			delete = {
				order = 10,
				type = "execute",
				name = SL["Delete"],
				hidden = false,
				confirm = true,
				confirmText = L["Are you sure you want to delete this aura?"],
				func = function(info)
					local key = info[#(info) - 1]
					local aura = auraMap[key]

					auraGroupTable.args[key] = nil
					ShadowUF.db.profile.units.raid.grid.auras[aura] = nil
					
					-- Check if the group should disappear
					local groupList = getAuraGroup(info)
					for groupID, name in pairs(groupMap) do
						if( not groupList[name] ) then
							ShadowUF.Config.options.args.grid.args.auras.args[tostring(groupID)] = nil
						end
					end
					
					ShadowUF.Layout:ReloadAll("raid")
				end,
			},
		},
	}	
	
	local indicatorTable = {
		order = 1,
		type = "group",
		name = function(info) return ShadowUF.db.profile.units.raid.grid.indicators[info[#(info)]].name end,
		args = {
			config = {
				order = 0,
				type = "group",
				inline = true,
				name = function(info) return ShadowUF.db.profile.units.raid.grid.indicators[info[#(info) - 1]].name end,
				set = function(info, value)
					local indicator = info[#(info) - 2]
					local key = info[#(info)]

					ShadowUF.db.profile.units.raid.grid.indicators[indicator][key] = value
					ShadowUF.Layout:ReloadAll("raid")
				end,
				get = function(info)
					local indicator = info[#(info) - 2]
					local key = info[#(info)]
					return ShadowUF.db.profile.units.raid.grid.indicators[indicator][key]
				end,
				args = {
					anchorPoint = {
						order = 1,
						type = "select",
						name = SL["Anchor point"],
						values = {["IBR"] = SL["Inside Bottom Right"], ["IBL"] = SL["Inside Bottom Left"], ["ITR"] = SL["Inside Top Right"], ["ITL"] = SL["Inside Top Left"], ["ICL"] = SL["Inside Center Left"], ["IC"] = SL["Inside Center"], ["ICR"] = SL["Inside Center Right"]},
					},
					sep = {
						order = 2,
						type = "description",
						name = "",
						width = "full",
						hidden = hideAdvancedOption,
					},
					height = {
						order = 4,
						name = SL["Height"],
						type = "range",
						min = 0, max = 50, step = 1,
					},
					width = {
						order = 4,
						name = SL["Width"],
						type = "range",
						min = 0, max = 50, step = 1,
					},
					x = {
						order = 5,
						type = "range",
						name = SL["X Offset"],
						min = -50, max = 50, step = 1,
					},
					y = {
						order = 6,
						type = "range",
						name = SL["Y Offset"],
						min = -50, max = 50, step = 1,
					},
					delete = {
						order = 7,
						type = "execute",
						name = SL["Delete"],
						width = "full",
						confirm = true,
						confirmText = L["Are you sure you want to delete this indicator?"],
						func = function(info)
							local indicator = info[#(info) - 2]
							
							ShadowUF.Config.options.args.grid.args.indicators.args[indicator] = nil
							ShadowUF.db.profile.units.raid.grid.indicators[indicator] = nil
							
							-- Any aura taht was set to us should be swapped back to none
							for _, aura in pairs(ShadowUF.db.profile.units.raid.grid.auras) do
								if( aura.indicator == indicator ) then
									aura.indicator = ""
								end
							end
							
							ShadowUF.Layout:ReloadAll("raid")
						end,
					},
				},
			},
		},
	}
	
	local parentLinkTable = {
		order = 3,
		type = "group",
		name = function(info) return linkMap[info[#(info)]] end,
		args = {},
	}
	
	local childLinkTable = {
		order = 1,
		name = function(info) return linkMap[info[#(info)]] end,
		hidden = function(info)
			local aura = linkMap[info[#(info)]]
			local parent = linkMap[info[#(info) - 1]]
			
			return ShadowUF.db.profile.units.raid.grid.linked[aura] ~= parent
		end,
		type = "group",
		inline = true,
		args = {
			delete = {
				type = "execute",
				name = L["Delete link"],
				hidden = false,
				func = function(info)
					local aura = linkMap[info[#(info) - 1]]
					local parent = ShadowUF.db.profile.units.raid.grid.linked[aura]
					ShadowUF.db.profile.units.raid.grid.linked[aura] = nil
					parentLinkTable.args[aura] = nil
					
					local found
					for _, to in pairs(ShadowUF.db.profile.units.raid.grid.linked) do
						if( to == parent ) then
							found = true
							break
						end
					end
					
					if( not found ) then
						for id, name in pairs(linkMap) do
							if( name == parent ) then
								ShadowUF.Config.options.args.grid.args.linked.args[tostring(id)] = nil
							end
						end
					end
					
					ShadowUF.Layout:ReloadAll("raid")
				end,
			},
		},
	}
	
	-- Actual tab view thing
	local addAura, addLink = {}, {}
	ShadowUF.Config.options.args.grid = {
		order = 1.50,
		type = "group",
		name = L["Grid"],
		childGroups = "tab",
		hidden = function(info) return not ShadowUF.db.profile.units.raid.enabled end,
		args = {
			indicators = {
				order = 0,
				type = "group",
				name = L["Indicators"],
				childGroups = "tree",
				hidden = false,
				args = {
					add = {
						order = 0,
						type = "group",
						name = L["Add indicator"],
						args = {
							add = { 
								order = 0,
								type = "group",
								inline = true,
								name = L["Add new indicator"],
								args = {
									name = {
										order = 0,
										type = "input",
										name = L["Indicator name"],
										width = "full",
										set = function(info, value)
											local id = string.format("%d", GetTime() + math.random(100))
											ShadowUF.db.profile.units.raid.grid.indicators[id] = {enabled = true, name = value, anchorPoint = "IC", anchorTo = "$parent", height = 10, width = 10, alpha = 1.0, x = 0, y = 0}
											ShadowUF.Config.options.args.grid.args.indicators.args[id] = indicatorTable

											AceDialog = AceDialog or LibStub("AceConfigDialog-3.0")
											AceRegistry = AceRegistry or LibStub("AceConfigRegistry-3.0")
											AceDialog.Status.ShadowedUF.children.grid.children.indicators.status.groups.selected = id
											AceRegistry:NotifyChange("ShadowedUF")
										end,
										get = function() return "" end,
									},
								},
							},
						},
					},
				},
			},
			auras = {
				order = 1,
				type = "group",
				name = L["Auras"],
				args = {
					add = {
						order = 0,
						type = "group",
						name = L["Add aura"],
						set = function(info, value) addAura[info[#(info)]] = value end,
						get = function(info) return addAura[info[#(info)]] end,
						args = {
							add = {
								order = 0,
								inline = true,
								type = "group",
								name = L["Add new aura"],
								args = {
									name = {
										order = 0,
										type = "input",
										name = L["Aura name"],
										desc = L["The exact buff or debuff name, this is case sensitive."],
										width = "full",
									},
									group = {
										order = 1,
										type = "select",
										name = L["Aura group"],
										desc = L["What group this aura belongs to, this is where you will find it when configuring."],
										values = getAuraGroup,
									},
									custom = {
										order = 2,
										type = "input",
										name = L["New aura group"],
										desc = L["Allows you to enter a new aura group."],
									},
									create = {
										order = 3,
										type = "execute",
										name = L["Add aura"],
										disabled = function(info) return not addAura.name or (not addAura.group and not addAura.custom) end,
										func = function(info)
											addAura.custom = string.trim(addAura.custom or "")
											addAura.custom = addAura.custom ~= "" and addAura.custom or nil
											if( addAura.group and addAura.group == "" ) then
												addAura.group = L["Miscellaneous"]
											end
											
											local group = addAura.custom or addAura.group
											
											-- Don't overwrite an existing group, but don't tell them either, mostly because I don't want to add error reporting code
											if( not ShadowUF.db.profile.units.raid.grid.auras[addAura.name] ) then
												-- Odds are, if they are saying to show it only if a buff is missing it's cause they want to know when their own class buff is not there
												-- so will cheat it, and jump start it by storing the texture if we find it from GetSpellInfo directly
												ShadowUF.db.profile.units.raid.grid.auras[addAura.name] = {indicator = "", group = group, iconTexture = select(3, GetSpellInfo(addAura.name)), priority = 0, r = 0, g = 0, b = 0}
												
												auraID = auraID + 1
												auraMap[tostring(auraID)] = addAura.name
												auraGroupTable.args[tostring(auraID)] = auraConfigTable
											end
											
											addAura.name = nil
											addAura.custom = nil
											addAura.group = nil
											
											-- Check if the group exists
											local gID
											for id, name in pairs(groupMap) do
												if( name == group ) then
													gID = id
													break
												end
											end
											
											if( not gID ) then
												groupID = groupID + 1
												groupMap[tostring(groupID)] = group
												
												ShadowUF.Config.options.args.grid.args.auras.args[tostring(groupID)] = auraGroupTable
											end
											
											-- Shunt the user to the this groups page
											AceDialog = AceDialog or LibStub("AceConfigDialog-3.0")
											AceRegistry = AceRegistry or LibStub("AceConfigRegistry-3.0")
											AceDialog.Status.ShadowedUF.children.grid.children.auras.status.groups.selected = tostring(gID or groupID)
											AceRegistry:NotifyChange("ShadowedUF")
											
											ShadowUF.Layout:ReloadAll("raid")
										end,
									},
								},
							},
						},
					},
				},
			},
			linked = {
				order = 2,
				type = "group",
				name = L["Linked spells"],
				childGroups = "tree",
				args = {
					help = {
						order = 0,
						type = "group",
						name = SL["Help"],
						inline = true,
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can link auras together using this, for example you can link Mark of the Wild to Gift of the Wild so if the player has Mark of the Wild but not Gift of the Wild, it will still show Mark of the Wild as if they had Gift of the Wild."],
								width = "full",
							},
						},
					},
					add = {
						order = 1,
						type = "group",
						name = L["Add link"],
						inline = true,
						set = function(info, value)
							addLink[info[#(info)]] = value
						end,
						get = function(info) return addLink[info[#(info)]] end,
						args = {
							from = {
								order = 0,
								type = "input",
								name = L["Link from"],
								desc = L["Spell you want to link to a primary aura, the casing must be exact."],
							},
							to = {
								order = 1,
								type = "select",
								name = L["Link to"],
								values = getAuraList,
							},
							link = {
								order = 3,
								type = "execute",
								name = L["Link"],
								disabled = function() return not addLink.from or not addLink.to or addLink.from == "" end,
								func = function(info)
									local lID, pID
									for id, name in pairs(linkMap) do
										if( name == addLink.from ) then
											lID = id
										elseif( name == addLink.to ) then
											pID = id
										end
									end
									
									if( not pID ) then
										linkID = linkID + 1
										pID = linkID
										linkMap[tostring(linkID)] = addLink.to
									end

									if( not lID ) then
										linkID = linkID + 1
										lID = linkID
										linkMap[tostring(linkID)] = addLink.from
									end
																		
									ShadowUF.db.profile.units.raid.grid.linked[addLink.from] = addLink.to
									ShadowUF.Config.options.args.grid.args.linked.args[tostring(pID)] = parentLinkTable
									parentLinkTable.args[tostring(lID)] = childLinkTable

									addLink.from = nil
									addLink.to = nil
									
									ShadowUF.Layout:ReloadAll("raid")
								end,
							},
						},
					},
				},
			},
			classes = {
				order = 3,
				type = "group",
				name = L["Enable by class"],
				childGroups = "tree",
				args = {
					help = {
						order = 0,
						type = "group",
						name = SL["Help"],
						inline = true,
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can override what aura is enabled on a per-class basis, note that if the aura is disabled through the main listing, then your class settings here will not matter."],
								width = "full",
							},
						},
					}
				},
			},
		},
	}
	
	local classTable = {
		order = 1,
		type = "group",
		name = function(info) return SL.classes[info[#(info)]] end,
		args = {},
	}
	
	local classAuraTable = {
		order = 1,
		type = "toggle",
		name = function(info) return auraMap[info[#(info)]] end,
		set = function(info, value)
			local aura = auraMap[info[#(info)]]
			local class = info[#(info) - 1]
			value = not value

			if( value == false ) then value = nil end
			ShadowUF.db.profile.units.raid.grid.disabled[class .. aura] = value
			ShadowUF.Layout:ReloadAll("raid")
		end,
		get = function(info)
			local aura = auraMap[info[#(info)]]
			local class = info[#(info) - 1]
			
			return not ShadowUF.db.profile.units.raid.grid.disabled[class .. aura]
		end,
	}
	
	-- Build links	
	local addedFrom = {}
	for from, to in pairs(ShadowUF.db.profile.units.raid.grid.linked) do
		local pID = addedFrom[to] 
		if( not pID ) then
			linkID = linkID + 1
			pID = linkID

			addedFrom[to] = pID
		end

		linkID = linkID + 1
		
		ShadowUF.db.profile.units.raid.grid.linked[from] = to
		ShadowUF.Config.options.args.grid.args.linked.args[tostring(pID)] = parentLinkTable
		parentLinkTable.args[tostring(linkID)] = childLinkTable
		
		linkMap[tostring(linkID)] = from
		linkMap[tostring(pID)] = to
	end
									
	-- Build the aura configuration
	local parents = {}
	for key, aura in pairs(ShadowUF.db.profile.units.raid.grid.auras) do
		auraMap[tostring(auraID)] = key
		auraGroupTable.args[tostring(auraID)] = auraConfigTable
		classTable.args[tostring(auraID)] = classAuraTable
		auraID = auraID + 1
		
		parents[aura.group] = true
	end
	
	-- Now create all of the parent stuff
	for group in pairs(parents) do
		groupMap[tostring(groupID)] = group
		ShadowUF.Config.options.args.grid.args.auras.args[tostring(groupID)] = auraGroupTable
		
		groupID = groupID + 1
	end
	
	-- Build class status thing
	for classToken in pairs(RAID_CLASS_COLORS) do
		ShadowUF.Config.options.args.grid.args.classes.args[classToken] = classTable
	end
	
	-- Quickly build the indicator one
	for key in pairs(ShadowUF.db.profile.units.raid.grid.indicators) do
		ShadowUF.Config.options.args.grid.args.indicators.args[key] = indicatorTable
	end
	
	-- Automatically unlock the advanced text configuration for raid frames, regardless of advanced being enabled
	local function unlockRaidText(info)
		if( info[2] ~= "raid" ) then return ShadowUF.Config.hideAdvancedOption(info) end
		return true
	end
	
	local advanceTextTable = ShadowUF.Config.advanceTextTable
	advanceTextTable.args.anchorPoint.hidden = unlockRaidText
	advanceTextTable.args.sep.hidden = unlockRaidText
	advanceTextTable.args.x.hidden = unlockRaidText
	advanceTextTable.args.y.hidden = unlockRaidText
end
