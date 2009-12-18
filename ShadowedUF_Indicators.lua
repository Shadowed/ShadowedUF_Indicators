--[[ 
	Shadow Unit Frames (Aura Indicators), Mayen of Mal'Ganis (US) PvP
]]

local L = SUFIndicatorsLocals
local SL = ShadowUFLocals
local Indicators = {}
local AceDialog, AceRegistry
local playerClass = select(2, UnitClass("player"))

ShadowUF:RegisterModule(Indicators, "auraIndicators", L["Aura indicators"])

-- Aura cache loader, converts them into tables
Indicators.auraConfig = setmetatable({}, {
	__index = function(tbl, index)
		local aura = ShadowUF.db.profile.auraIndicators.auras[index]
		if( not aura ) then
			tbl[index] = false
		else
			local func, msg = loadstring("return " .. aura)
			if( func ) then
				func = func()
			elseif( msg ) then
				error(msg, 3)
			end
			
			tbl[index] = func
			tbl[index].group = tbl[index].group or L["Miscellaneous"]
		end
		
		return tbl[index]
end})

function Indicators:OnInitialize()
	if( ShadowUF.db.profile.auraIndicators and ShadowUF.db.profile.auraIndicators.updated ) then return end

	if( not ShadowUF.db.profile.units.auraIndicators ) then
		ShadowUF.db.profile.units.raid.auraIndicators = {enabled = true}
	end

	for _, unit in pairs(ShadowUF.units) do
		if( not string.match(unit, "(%w+)target") ) then
			ShadowUF.db.profile.units[unit].auraIndicators = ShadowUF.db.profile.units[unit].auraIndicators or {enabled = false}
		end
	end

	local defaults = {
		updated = true,
		disabled = {},
		missing = {},
		indicators = {
			["tl"] = {name = SL["Top Left"], anchorPoint = "TLI", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = 4, y = -3, friendly = true, hostile = true},
			["tr"] = {name = SL["Top Right"], anchorPoint = "TRI", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = -3, y = 3, friendly = true, hostile = true},
			["bl"] = {name = SL["Bottom Left"], anchorPoint = "BLI", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = 4, y = 4, friendly = true, hostile = true},
			["br"] = {name = SL["Bottom Right"], anchorPoint = "CRI", anchorTo = "$parent", height = 8, width = 8, alpha = 1.0, x = -4, y = -4, friendly = true, hostile = true},
			["c"] = {name = SL["Center"], anchorPoint = "C", anchorTo = "$parent", height = 20, width = 20, alpha = 1.0, x = 0, y = 0, friendly = true, hostile = true},
		},
		linked = {
			[GetSpellInfo(976)] = GetSpellInfo(27683), -- Shadow Protection -> Prayer of Shadow Protection
			[GetSpellInfo(1459)] = GetSpellInfo(43002), -- Arcane Intelligent -> Arcane Brilliance
			[GetSpellInfo(61316)] = GetSpellInfo(43002), -- Dalaran Brilliance -> Arcane Brilliance
			[GetSpellInfo(1126)] = GetSpellInfo(21849), -- Mark of the Wild -> Gift of the Wild
			[GetSpellInfo(1243)] = GetSpellInfo(21562), -- Power Word: Fortitude -> Prayer of Fortitude
		},
		auras = {
			[GetSpellInfo(774)] = [[{indicator = '', group = "Druid", priority = 10, r = 0.66, g = 0.66, b = 1.0}]], -- Rejuvenation
			[GetSpellInfo(8936)] = [[{indicator = '', group = "Druid", priority = 10, r = 0.50, g = 1.0, b = 0.63}]], -- Regrowth
			[GetSpellInfo(33763)] = [[{indicator = '', group = "Druid", priority = 10, r = 0.07, g = 1.0, b = 0.01}]], -- Lifebloom
			[GetSpellInfo(53248)] = [[{indicator = '', group = "Druid", priority = 10, r = 0.51, g = 0.72, b = 0.77}]], -- Wild Growth
			[GetSpellInfo(21849)] = [[{indicator = '', group = "Druid", priority = 10, r = 1.0, g = 0.33, b = 0.90}]], -- Gift of the Wild
			[GetSpellInfo(2893)] = [[{indicator = '', group = "Druid", priority = 10, r = 0.40, g = 1.0, b = 0.45}]], -- Abolish Poison
			[GetSpellInfo(139)] = [[{indicator = '', group = "Priest", priority = 10, r = 1, g = 0.62, b = 0.88}]], -- Renew
			[GetSpellInfo(17)] = [[{indicator = '', group = "Priest", priority = 10, r = 0.55, g = 0.69, b = 1.0}]], -- Power Word: Shield
			[GetSpellInfo(21562)] = [[{indicator = '', group = "Priest", priority = 10, r = 0.58, g = 1.0, b = 0.50}]], -- Prayer of Fortitude
			[GetSpellInfo(552)] = [[{indicator = '', group = "Priest", priority = 10, r = 1.0, g = 0.79, b = 0.67}]], -- Abolish Disease
			[GetSpellInfo(27683)] = [[{indicator = '', group = "Priest", priority = 10, r = 0.60, g = 0.18, b = 1.0}]], -- Prayer of Shadow Protection
			[GetSpellInfo(53601)] = [[{indicator = '', group = "Paladin", priority = 10, r = 0.90, g = 1.0, b = 0.37}]], -- Sacred Shield
			[GetSpellInfo(49284)] = [[{indicator = '', group = "Shaman", priority = 10, r = 0.26, g = 1.0, b = 0.26}]], -- Earth Shield
			[GetSpellInfo(61301)] = [[{indicator = '', group = "Shaman", priority = 10, r = 0.30, g = 0.24, b = 1.0}]], -- Riptide
			[GetSpellInfo(54648)] = [[{indicator = '', group = "Mage", priority = 10, r = 0.67, g = 0.76, b = 1.0}]], -- Focus Magic
			[GetSpellInfo(43002)] = [[{indicator = '', group = "Mage", priority = 10, r = 0.10, g = 0.68, b = 0.88}]], -- Arcane Brilliance
			[GetSpellInfo(20707)] = [[{indicator = '', group = "Warlock", priority = 10, r = 0.42, g = 0.21, b = 0.65}]], -- Soulstone Ressurection
			[GetSpellInfo(63337)] = [[{indicator = 'c', icon = true, group = "General Vezax", priority = 50, r = 0, g = 0, b = 0}]], -- Saronite Vapors
			[GetSpellInfo(62659)] = [[{indicator = 'c', icon = true, group = "General Vezax", priority = 5, r = 0, g = 0, b = 0}]], -- Shadow Crash
			[GetSpellInfo(62282)] = [[{indicator = 'c', icon = true, group = "Freya", priority = 0, r = 0, g = 0, b = 0}]], -- Iron Roots
			[GetSpellInfo(63571)] = [[{indicator = 'c', icon = true, group = "Freya", priority = 100, r = 0, g = 0, b = 0}]], -- Nature's Fury
			[GetSpellInfo(62717)] = [[{indicator = 'c', icon = true, group = "Ignis the Furnace Master", priority = 0, r = 0, g = 0, b = 0}]], -- Slag Pot
			[GetSpellInfo(64389)] = [[{indicator = 'c', icon = true, group = "Auriaya", priority = 20, r = 0, g = 0, b = 0}]], -- Sentinel Blast
			[GetSpellInfo(64667)] = [[{indicator = 'c', icon = true, group = "Auriaya", priority = 0, r = 0, g = 0, b = 0}]], -- Rip Flesh
			[GetSpellInfo(64374)] = [[{indicator = 'c', icon = true, group = "Auriaya", priority = 10, r = 0, g = 0, b = 0}]], -- Savage Pounce
			[GetSpellInfo(64478)] = [[{indicator = 'c', icon = true, group = "Auriaya", priority = 5, r = 0, g = 0, b = 0}]], -- Feral Pounce
			[GetSpellInfo(64733)] = [[{indicator = 'c', icon = true, group = "Razorscale", priority = 10, r = 0, g = 0, b = 0}]], -- Devouring Flame
			[GetSpellInfo(62055)] = [[{indicator = 'c', icon = true, group = "Kologarn", priority = 0, r = 0, g = 0, b = 0}]], -- Brittle Skin
			[GetSpellInfo(63981)] = [[{indicator = 'c', icon = true, group = "Kologarn", priority = 10, r = 0, g = 0, b = 0}]], -- Stone Grip
			[GetSpellInfo(61969)] = [[{indicator = 'c', icon = true, group = "Hodir", priority = 0, r = 0, g = 0, b = 0}]], -- Flash Freeze
			[GetSpellInfo(62376)] = [[{indicator = '', icon = true, group = "Flame Leviathan", priority = 0, r = 0, g = 0, b = 0}]], -- Battering Ram
			[GetSpellInfo(64637)] = [[{indicator = 'c', icon = true, group = "Assembly of Iron", priority = 0, r = 0, g = 0, b = 0}]], -- Overwhelming Power
			[GetSpellInfo(63493)] = [[{indicator = 'c', icon = true, group = "Assembly of Iron", priority = 0, r = 0, g = 0, b = 0}]], -- Fusion Punch
			[GetSpellInfo(63018)] = [[{indicator = 'c', icon = true, group = "XT-002 Deconstructor", priority = 0, r = 0, g = 0, b = 0}]], -- Searing Light
			[GetSpellInfo(64234)] = [[{indicator = 'c', icon = true, group = "XT-002 Deconstructor", priority = 0, r = 0, g = 0, b = 0}]], -- Gravity Bomb
			[GetSpellInfo(63830)] = [[{indicator = '', icon = true, group = "Yogg-Saron", priority = 50, r = 0, g = 0, b = 0}]], -- Malady of the Mind
			[GetSpellInfo(64152)] = [[{indicator = 'c', icon = true, group = "Yogg-Saron", priority = 5, r = 0, g = 0, b = 0}]], -- Draining Poison
			[GetSpellInfo(63038)] = [[{indicator = 'c', icon = true, group = "Yogg-Saron", priority = 0, r = 0, g = 0, b = 0}]], -- Dark Volley
			[GetSpellInfo(63134)] = [[{indicator = 'c', icon = true, group = "Yogg-Saron", priority = 25, r = 0, g = 0, b = 0}]], -- Sara's Blessing
			[GetSpellInfo(63713)] = [[{indicator = 'c', icon = true, group = "Yogg-Saron", priority = 100, r = 0, g = 0, b = 0}]], -- Dominate Mind
			[GetSpellInfo(36655)] = [[{indicator = '', icon = true, group = "Yogg-Saron", priority = 1, r = 0, g = 0, b = 0}]], -- Drain Life
			[GetSpellInfo(63147)] = [[{indicator = '', icon = true, group = "Yogg-Saron", priority = 50, r = 0, g = 0, b = 0}]], -- Sara's Anger
			[GetSpellInfo(30910)] = [[{indicator = '', icon = true, group = "Yogg-Saron", priority = 100, r = 0, g = 0, b = 0}]], -- Curse of Doom
			[GetSpellInfo(63120)] = [[{indicator = 'c', icon = true, group = "Yogg-Saron", priority = 100, r = 0, g = 0, b = 0}]], -- Insane
			[GetSpellInfo(64125)] = [[{indicator = 'c', icon = true, group = "Yogg-Saron", priority = 75, r = 0, g = 0, b = 0}]], -- Squeeze
			[GetSpellInfo(66331)] = [[{indicator = 'c', icon = true, group = "Gormok the Impaler", priority = 50, r = 0, g = 0, b = 0}]], -- Impale
			[GetSpellInfo(66406)] = [[{indicator = 'c', icon = true, group = "Gormok the Impaler", priority = 25, r = 0, g = 0, b = 0}]], -- Snobolled
			[GetSpellInfo(66823)] = [[{indicator = 'c', icon = true, group = "Acidmaw & Dreadscale", priority = 5, r = 0, g = 0, b = 0}]], -- Paralytic Toxin
			[GetSpellInfo(66870)] = [[{indicator = 'c', icon = true, group = "Acidmaw & Dreadscale", priority = 5, r = 0, g = 0, b = 0}]], -- Burning Bile
			[GetSpellInfo(66237)] = [[{indicator = 'c', icon = true, group = "Lord Jaraxxus", priority = 100, r = 0, g = 0, b = 0}]], -- Incinerate Flesh
			[GetSpellInfo(66197)] = [[{indicator = 'c', icon = true, group = "Lord Jaraxxus", priority = 75, r = 0, g = 0, b = 0}]], -- Legion Flames
			[GetSpellInfo(66001)] = [[{indicator = 'c', icon = true, group = "Twin Valkyrs", priority = 75, r = 0, g = 0, b = 0}]], -- Touch of Darkness
			[GetSpellInfo(65950)] = [[{indicator = 'c', icon = true, group = "Twin Valkyrs", priority = 75, r = 0, g = 0, b = 0}]], -- Touch of Light
			[GetSpellInfo(65775)] = [[{indicator = 'c', icon = true, group = "Anub'arak", priority = 75, r = 0, g = 0, b = 0}]], -- Acid-Drenched Mandibles
			[GetSpellInfo(66013)] = [[{indicator = 'c', icon = true, group = "Anub'arak", priority = 75, r = 0, g = 0, b = 0}]], -- Penetrating Cold
		}
	}
	
	for classToken in pairs(RAID_CLASS_COLORS) do
		defaults.disabled[classToken] = {}
	end
	
	if( not ShadowUF.db.profile.auraIndicators ) then
		ShadowUF.db.profile.auraIndicators = defaults
	else
		ShadowUF.db.profile.auraIndicators.updated = true
		
		for key, data in pairs(defaults) do
			if( not ShadowUF.db.profile.auraIndicators[key] ) then
				ShadowUF.db.profile.auraIndicators[key] = defaults
			elseif( type(data) == "table" ) then
				for subKey, subData in pairs(data) do
					if( ShadowUF.db.profile.auraIndicators[key][subKey] == nil ) then
						ShadowUF.db.profile.auraIndicators[key][subKey] = subData
					end
				end
			end
		end
	end
end

function Indicators:OnEnable(frame)
	-- Upgrade if needed
	for _, indicator in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		if( string.match(indicator.anchorPoint, "^I") ) then
			indicator.anchorPoint = string.gsub(indicator.anchorPoint, "^I([A-Z][A-Z])", "%1I")
		end
	end

	-- Not going to create the indicators we want here, will do that when we do the layout stuff
	frame.auraIndicators = frame.auraIndicators or CreateFrame("Frame", nil, frame)
	frame.auraIndicators:SetFrameLevel(4)
	frame.auraIndicators:Show()
			
	-- Of course, watch for auras
	frame:RegisterUnitEvent("UNIT_AURA", self, "UpdateAuras")
	frame:RegisterUpdateFunc(self, "UpdateAuras")
end

function Indicators:OnDisable(frame)
	frame:UnregisterAll(self)
	frame.auraIndicators:Hide()
end

local backdropTbl = {
	bgFile = "Interface\\Addons\\ShadowedUF_Indicators\\backdrop",
	edgeFile = "Interface\\Addons\\ShadowedUF_Indicators\\backdrop",
	tile = true,
	tileSize = 1,
	edgeSize = 1,
}

function Indicators:OnLayoutApplied(frame)
	if( not frame.auraIndicators ) then return end
		
	-- Create indicators
	local id = 1
	for key, indicatorConfig in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		-- Create indicator as needed
		local indicator = frame.auraIndicators["indicator-" .. id]
		if( not indicator ) then
			indicator = CreateFrame("Frame", nil, frame.auraIndicators)
			indicator:SetFrameLevel(frame.topFrameLevel + 1)
			indicator.texture = indicator:CreateTexture(nil, "OVERLAY")
			indicator.texture:SetPoint("CENTER", indicator)
			indicator:SetAlpha(indicatorConfig.alpha)
			indicator:SetBackdrop(backdropTbl)
			indicator:SetBackdropColor(0, 0, 0, 1)
			
			indicator.cooldown = CreateFrame("Cooldown", nil, indicator, "CooldownFrameTemplate")
			indicator.cooldown:SetReverse(true)
			indicator.cooldown:SetPoint("CENTER", 0, -1)

			indicator.stack = indicator:CreateFontString(nil, "OVERLAY")
			indicator.stack:SetFont("Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf", 12, "OUTLINE")
			indicator.stack:SetShadowColor(0, 0, 0, 1.0)
			indicator.stack:SetShadowOffset(0.8, -0.8)
			indicator.stack:SetPoint("BOTTOMRIGHT", indicator, "BOTTOMRIGHT", 1, 0)
			indicator.stack:SetWidth(18)
			indicator.stack:SetHeight(10)
			indicator.stack:SetJustifyH("RIGHT")
			
			frame.auraIndicators["indicator-" .. id] = indicator
		end
		
		-- Set up the sizing options
		indicator:SetHeight(indicatorConfig.height)
		indicator.texture:SetWidth(indicatorConfig.width - 1)
		indicator:SetWidth(indicatorConfig.width)
		indicator.texture:SetHeight(indicatorConfig.height - 1)
		
		ShadowUF.Layout:AnchorFrame(frame, indicator, indicatorConfig)
		
		-- Let the auras module quickly access indicators without having to use index
		frame.auraIndicators[key] = indicator
		
		id = id + 1
	end
end

local auraList = {}
local function scanAura(frame, filter)
	local index = 1
	while( true ) do
		local name, rank, texture, count, debuffType, duration, endTime, caster, isStealable = UnitAura(frame.unit, index, filter)
		if( not name ) then break end
			
		-- Setup the auras in the indicators based on priority
		name = ShadowUF.db.profile.auraIndicators.linked[name] or name
		local auraConfig = Indicators.auraConfig[name]
		local indicator = auraConfig and frame.auraIndicators[auraConfig.indicator]
		
		if( indicator and indicator.enabled and 
			not ShadowUF.db.profile.auraIndicators.disabled[playerClass][name] and not ShadowUF.db.profile.units[frame.unitType].auraIndicators[auraConfig.group] and
			not auraConfig.missing and ( not auraConfig.player or caster == ShadowUF.playerUnit ) ) then
			
			-- If the indicator is not restricted to the player only, then will give the player a slightly higher priority
			local priority = auraConfig.priority
			local color = auraConfig
			if( not auraConfig.player and caster == ShadowUF.playerUnit ) then
				priority = priority + 0.1
				color = auraConfig.selfColor or auraConfig
			end

			if( priority > indicator.priority ) then
				indicator.showStack = ShadowUF.db.profile.auraIndicators.indicators[auraConfig.indicator].showStack
				indicator.priority = priority
				indicator.showIcon = auraConfig.icon
				indicator.showDuration = auraConfig.duration
				indicator.spellDuration = duration
				indicator.spellEnd = endTime
				indicator.spellIcon = texture
				indicator.spellName = name
				indicator.spellStack = count
				indicator.colorR = color.r
				indicator.colorG = color.g
				indicator.colorB = color.b
			end
		end

		-- Save a small list that we can duplicate check, and figure out whats missing
		auraList[name] = true

		index = index + 1
	end
end

function Indicators:UpdateIndicators(frame)
	for key, indicatorConfig in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		local indicator = frame.auraIndicators[key]
		if( indicator and indicator.enabled and indicator.priority > -1 ) then
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
			
			-- Show aura stack
			if( indicator.showStack and indicator.spellStack > 1 ) then
				indicator.stack:SetText(indicator.spellStack)
				indicator.stack:Show()
			else
				indicator.stack:Hide()
			end
			
			indicator:Show()
		else
			indicator:Hide()
		end
	end
end

function Indicators:UpdateAuras(frame)
	for k in pairs(auraList) do auraList[k] = nil end
	for key, config in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		local indicator = frame.auraIndicators[key]
		if( indicator ) then
			indicator.priority = -1
			
			if( UnitIsFriend("player", frame.unit) ) then
				indicator.enabled = config.friendly
			else
				indicator.enabled = config.hostile
			end
		end
	end
	
	-- If they are dead, don't bother showing any indicators yet
	if( UnitIsDeadOrGhost(frame.unit) or not UnitIsConnected(frame.unit) ) then
		self:UpdateIndicators(frame)
		return
	end
	
	-- Scan auras
	scanAura(frame, "HELPFUL")
	scanAura(frame, "HARMFUL")
	
	-- Check for any indicators that are triggered due to something missing
	for name in pairs(ShadowUF.db.profile.auraIndicators.missing) do
		if( not auraList[name] ) then
			local aura = self.auraConfig[name]
			local indicator = frame.auraIndicators[aura.indicator]
			if( indicator and indicator.enabled and aura.priority > indicator.priority and not ShadowUF.db.profile.auraIndicators.disabled[playerClass][name] ) then
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
	
	-- Now force the indicators to update
	self:UpdateIndicators(frame)
end


function Indicators:OnConfigurationLoad()
	-- Kill old settings
	ShadowUF.db.profile.units.raid.grid = nil
	
	local groupList = {}
	local function getAuraGroup(info)
		for k in pairs(groupList) do groupList[k] = nil end
		for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
			local aura = Indicators.auraConfig[name]
			groupList[aura.group] = aura.group
		end
	
		return groupList
	end

	local auraList = {}
	local function getAuraList(info)
		for k in pairs(auraList) do auraList[k] = nil end
		for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
			auraList[name] = name
		end
	
		return auraList
	end

	local indicatorList = {}
	local function getIndicatorList(info)
		for k in pairs(indicatorList) do indicatorList[k] = nil end
		indicatorList[""] = L["None (Disabled)"]
		for key, indicator in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
			indicatorList[key] = indicator.name
		end
		
		return indicatorList
	end
		
	local function writeTable(tbl)
		local data = ""

		for key, value in pairs(tbl) do
			local valueType = type(value)
			
			-- Wrap the key in brackets if it's a number
			if( type(key) == "number" ) then
				key = string.format("[%s]", key)
			-- Wrap the string with quotes if it has a space in it
			elseif( string.match(key, " ") ) then
				key = string.format("[\"%s\"]", key)
			end
			
			-- foo = {bar = 5}
			if( valueType == "table" ) then
				data = string.format("%s%s=%s;", data, key, writeTable(value))
			-- foo = true / foo = 5
			elseif( valueType == "number" or valueType == "boolean" ) then
				data = string.format("%s%s=%s;", data, key, tostring(value))
			-- foo = "bar"
			else
				data = string.format("%s%s=\"%s\";", data, key, tostring(value))
			end
		end
		
		return "{" .. data .. "}"
	end

	local function writeAuraTable(name)
		ShadowUF.db.profile.auraIndicators.auras[name] = writeTable(Indicators.auraConfig[name])
	end
	
	local groupMap, auraMap, linkMap = {}, {}, {}
	local groupID, auraID, linkID = 0, 0, 0
	
	-- Actual aura configuration
	local auraGroupTable = {
		order = 1,
		type = "group",
		name = function(info) return groupMap[info[#(info)]] end,
		desc = function(info)
			local group = groupMap[info[#(info)]]
			local totalInGroup = 0
			for _, aura in pairs(Indicators.auraConfig) do
				if( type(aura) == "table" and aura.group == group ) then
					totalInGroup = totalInGroup + 1
				end
			end
			
			return string.format(L["%d auras in group"], totalInGroup)
		end,
		args = {},
	}
	
	local auraConfigTable = {
		order = 0,
		type = "group",
		inline = true,
		name = function(info) return auraMap[info[#(info)]] end,
		hidden = function(info)
			local group = groupMap[info[#(info) - 1]]
			local aura = Indicators.auraConfig[auraMap[info[#(info)]]]
			return aura.group ~= group
		end,
		set = function(info, value, g, b, a)
			local aura = auraMap[info[#(info) - 1]]
			local key = info[#(info)]

			-- So I don't have to load every aura to see if it only triggers if it's missing
			if( key == "missing" ) then
				ShadowUF.db.profile.auraIndicators.missing[aura] = value and true or nil
			-- Changing the color
			elseif( key == "color" ) then
				Indicators.auraConfig[aura].r = value
				Indicators.auraConfig[aura].g = g
				Indicators.auraConfig[aura].b = b
				Indicators.auraConfig[aura].alpha = a

				writeAuraTable(aura)
				ShadowUF.Layout:Reload()
				return
			elseif( key == "selfColor" ) then
				Indicators.auraConfig[aura].selfColor = Indicators.auraConfig[aura].selfColor or {}
				Indicators.auraConfig[aura].selfColor.r = value
				Indicators.auraConfig[aura].selfColor.g = g
				Indicators.auraConfig[aura].selfColor.b = b
				Indicators.auraConfig[aura].selfColor.alpha = a

				writeAuraTable(aura)
				ShadowUF.Layout:Reload()
				return
			end

			Indicators.auraConfig[aura][key] = value
			writeAuraTable(aura)
			ShadowUF.Layout:Reload()
		end,
		get = function(info)
			local aura = auraMap[info[#(info) - 1]]
			local key = info[#(info)]
			local config = Indicators.auraConfig[aura]			
			if( key == "color" ) then
				return config.r, config.g, config.b, config.alpha
			elseif( key == "selfColor" ) then
				if( not config.selfColor ) then return 0, 0, 0, 1 end
				return config.selfColor.r, config.selfColor.g, config.selfColor.b, config.selfColor.alpha
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
			priority = {
				order = 2,
				type = "range",
				name = L["Priority"],
				desc = L["If multiple auras are shown in the same indicator, the higher priority one is shown first."],
				min = 0, max = 100, step = 1,
				hidden = false,
			},
			sep1 = {
				order = 3,
				type = "description",
				name = "",
				width = "full",
				hidden = false,
			},
			color = {
				order = 4,
				type = "color",
				name = L["Indicator color"],
				desc = L["Solid color to use in the indicator, only used if you do not have use aura icon enabled."],
				disabled = function(info) return Indicators.auraConfig[auraMap[info[#(info) - 1]]].icon end,
				hidden = false,
				hasAlpha = true,
			},
			selfColor = {
				order = 4.5,
				type = "color",
				name = L["Your aura color"],
				desc = L["This color will be used if the indicator shown is your own, only applies if icons are not used.\nHandy if you want to know if a target has a Rejuvenation on them, but you also want to know if you were the one who casted the Rejuvenation."],
				hidden = false,
				disabled = function(info) 
					if( Indicators.auraConfig[auraMap[info[#(info) - 1]]].icon ) then return true end
					return Indicators.auraConfig[auraMap[info[#(info) - 1]]].player
				end,
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
					ShadowUF.db.profile.auraIndicators.auras[aura] = nil
					ShadowUF.db.profile.auraIndicators.missing[aura] = nil
					Indicators.auraConfig[aura] = nil
					
					-- Check if the group should disappear
					local groupList = getAuraGroup(info)
					for groupID, name in pairs(groupMap) do
						if( not groupList[name] ) then
							unitTable.args[tostring(groupID)] = nil
							ShadowUF.Config.options.args.auraIndicators.args.auras.args[tostring(groupID)] = nil
							groupMap[groupID] = nil
						end
					end
					
					ShadowUF.Layout:Reload()
				end,
			},
		},
	}	
	
	local indicatorTable = {
		order = 1,
		type = "group",
		name = function(info) return ShadowUF.db.profile.auraIndicators.indicators[info[#(info)]].name end,
		args = {
			config = {
				order = 0,
				type = "group",
				inline = true,
				name = function(info) return ShadowUF.db.profile.auraIndicators.indicators[info[#(info) - 1]].name end,
				set = function(info, value)
					local indicator = info[#(info) - 2]
					local key = info[#(info)]

					ShadowUF.db.profile.auraIndicators.indicators[indicator][key] = value
					ShadowUF.Layout:Reload()
				end,
				get = function(info)
					local indicator = info[#(info) - 2]
					local key = info[#(info)]
					return ShadowUF.db.profile.auraIndicators.indicators[indicator][key]
				end,
				args = {
					showStack = {
						order = 1,
						type = "toggle",
						name = L["Show auras stack"],
						desc = L["Any auras shown in this indicator will have their total stack displayed."],
						width = "full",
					},
					friendly = {
						order = 2,
						type = "toggle",
						name = L["Enable for friendlies"],
						desc = L["Unchecking this will disable the indicator for all friendly units."],
					},
					hostile = {
						order = 3,
						type = "toggle",
						name = L["Enable for hostiles"],
						desc = L["Unchecking this will disable the indicator for all hostile units."],
					},
					anchorPoint = {
						order = 4,
						type = "select",
						name = SL["Anchor point"],
						values = {["BRI"] = L["Inside Bottom Right"], ["BLI"] = L["Inside Bottom Left"], ["TRI"] = SL["Inside Top Right"], ["TLI"] = SL["Inside Top Left"], ["CLI"] = SL["Inside Center Left"], ["C"] = SL["Center"], ["CRI"] = SL["Inside Center Right"]},
					},
					size = {
						order = 5,
						name = SL["Size"],
						type = "range",
						min = 0, max = 50, step = 1,
						set = function(info, value)
							local indicator = info[#(info) - 2]
							ShadowUF.db.profile.auraIndicators.indicators[indicator].height = value
							ShadowUF.db.profile.auraIndicators.indicators[indicator].width = value
							ShadowUF.Layout:Reload()
						end,
						get = function(info)
							local indicator = info[#(info) - 2]
							-- Upgrade code, force them to be the same size
							if( ShadowUF.db.profile.auraIndicators.indicators[indicator].height ~= ShadowUF.db.profile.auraIndicators.indicators[indicator].width ) then
								local size = max(ShadowUF.db.profile.auraIndicators.indicators[indicator].height, ShadowUF.db.profile.auraIndicators.indicators[indicator].width)
								
								ShadowUF.db.profile.auraIndicators.indicators[indicator].height = size
								ShadowUF.db.profile.auraIndicators.indicators[indicator].width = size
							end
							
							return ShadowUF.db.profile.auraIndicators.indicators[indicator].height
						end,
					},
					x = {
						order = 6,
						type = "range",
						name = SL["X Offset"],
						min = -50, max = 50, step = 1,
					},
					y = {
						order = 7,
						type = "range",
						name = SL["Y Offset"],
						min = -50, max = 50, step = 1,
					},
					delete = {
						order = 8,
						type = "execute",
						name = SL["Delete"],
						confirm = true,
						confirmText = L["Are you sure you want to delete this indicator?"],
						func = function(info)
							local indicator = info[#(info) - 2]
							
							ShadowUF.Config.options.args.auraIndicators.args.indicators.args[indicator] = nil
							ShadowUF.db.profile.auraIndicators.indicators[indicator] = nil
							
							-- Any aura taht was set to us should be swapped back to none
							for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
								local aura = Indicators.auraConfig[name]
								if( aura.indicator == indicator ) then
									aura.indicator = ""
									writeAuraTable(name)
								end
							end
							
							ShadowUF.Layout:Reload()
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
			
			return ShadowUF.db.profile.auraIndicators.linked[aura] ~= parent
		end,
		type = "group",
		inline = true,
		args = {
			delete = {
				type = "execute",
				name = L["Delete link"],
				hidden = false,
				func = function(info)
					local auraID = info[#(info) - 1]
					local aura = linkMap[auraID]
					local parent = ShadowUF.db.profile.auraIndicators.linked[aura]
					ShadowUF.db.profile.auraIndicators.linked[aura] = nil
					parentLinkTable.args[auraID] = nil
					
					local found
					for _, to in pairs(ShadowUF.db.profile.auraIndicators.linked) do
						if( to == parent ) then
							found = true
							break
						end
					end
					
					if( not found ) then
						for id, name in pairs(linkMap) do
							if( name == parent ) then
								ShadowUF.Config.options.args.auraIndicators.args.linked.args[tostring(id)] = nil
								linkMap[id] = nil
							end
						end
					end
					
					ShadowUF.Layout:Reload()
				end,
			},
		},
	}

	local addAura, addLink, setGlobalUnits, globalConfig = {}, {}, {}, {}

	-- Per unit enabled status
	local unitTable = {
		order = ShadowUF.Config.getUnitOrder or 1,
		type = "group",
		name = function(info) return SL.units[info[3]] end,
		desc = function(info)
			local totalDisabled = 0
			for key, enabled in pairs(ShadowUF.db.profile.units[info[3]].auraIndicators) do
				if( key ~= "enabled" and enabled ) then
					totalDisabled = totalDisabled + 1
				end
			end
			
			return totalDisabled > 0 and string.format(L["%s aura groups disabled"], totalDisabled) or L["All aura groups enabled for unit."]
		end,
		args = {
			enabled = {
				order = 1,
				inline = true,
				type = "group",
				name = function(info) return string.format(L["Indicator status for %s"], SL.units[info[3]]) end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable indicators"],
						desc = function(info) return string.format(L["Unchecking this will completely disable the aura indicators mod for %s."], SL.units[info[3]]) end,
						set = function(info, value) ShadowUF.db.profile.units[info[3]].auraIndicators.enabled = value; ShadowUF.Layout:Reload() end,
						get = function(info) return ShadowUF.db.profile.units[info[3]].auraIndicators.enabled end,
					},
				},
			},
			groups = {
				order = 2,
				inline = true,
				type = "group",
				name = L["Enabled aura groups"],
				disabled = function(info) return not ShadowUF.db.profile.units[info[3]].auraIndicators.enabled end,
				args = {},
			},
		}
	}
	
	local unitGroupTable = {
		order = 1,
		type = "toggle",
		name = function(info) return groupMap[info[#(info)]] end,
		desc = function(info)
			local auraIndicators = ShadowUF.db.profile.units[info[3]].auraIndicators
			local group = groupMap[info[#(info)]]
			
			return auraIndicators[group] and string.format(L["Disabled for %s."], SL.units[info[3]]) or string.format(L["Enabled for %s."], SL.units[info[3]])
		end,
		set = function(info, value) ShadowUF.db.profile.units[info[3]].auraIndicators[groupMap[info[#(info)]]] = not value and true or nil end,
		get = function(info, value) return not ShadowUF.db.profile.units[info[3]].auraIndicators[groupMap[info[#(info)]]] end,
	}

	local globalUnitGroupTable = {
		order = 1,
		type = "toggle",
		name = function(info) return groupMap[info[#(info)]] end,
		disabled = function(info) for unit in pairs(setGlobalUnits) do return false end return true end,
		set = function(info, value)
			local auraGroup = groupMap[info[#(info)]]
			globalConfig[auraGroup] = not value and true or nil
			
			for unit in pairs(setGlobalUnits) do
				ShadowUF.db.profile.units[unit].auraIndicators[auraGroup] = globalConfig[auraGroup]
			end
		end,
		get = function(info, value) return not globalConfig[groupMap[info[#(info)]]] end,
	}
	
	local enabledUnits = {}
	local function getEnabledUnits()
		table.wipe(enabledUnits)
		for unit, config in pairs(ShadowUF.db.profile.units) do
			if( config.auraIndicators and config.auraIndicators.enabled ) then
				enabledUnits[unit] = SL.units[unit]
			end
		end
		
		return enabledUnits
	end
			
	-- Actual tab view thing
	ShadowUF.Config.options.args.auraIndicators = {
		order = 4.5,
		type = "group",
		name = L["Aura indicators"],
		desc = L["For configuring the aura indicators module."],
		childGroups = "tab",
		hidden = false,
		args = {
			indicators = {
				order = 1,
				type = "group",
				name = L["Indicators"],
				childGroups = "tree",
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
											ShadowUF.db.profile.auraIndicators.indicators[id] = {enabled = true, friendly = true, hostile = true, name = value, anchorPoint = "C", anchorTo = "$parent", height = 10, width = 10, alpha = 1.0, x = 0, y = 0}
											ShadowUF.Config.options.args.auraIndicators.args.indicators.args[id] = indicatorTable

											AceDialog = AceDialog or LibStub("AceConfigDialog-3.0")
											AceRegistry = AceRegistry or LibStub("AceConfigRegistry-3.0")
											AceDialog.Status.ShadowedUF.children.auraIndicators.children.indicators.status.groups.selected = id
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
				order = 2,
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
											if( addAura.group and string.trim(addAura.group) == "" ) then
												addAura.group = L["Miscellaneous"]
											end
											
											local group = addAura.custom or addAura.group
											
											-- Don't overwrite an existing group, but don't tell them either, mostly because I don't want to add error reporting code
											if( not ShadowUF.db.profile.auraIndicators.auras[addAura.name] ) then
												-- Odds are, if they are saying to show it only if a buff is missing it's cause they want to know when their own class buff is not there
												-- so will cheat it, and jump start it by storing the texture if we find it from GetSpellInfo directly
												Indicators.auraConfig[addAura.name] = {indicator = "", group = group, iconTexture = select(3, GetSpellInfo(addAura.name)), priority = 0, r = 0, g = 0, b = 0}
												ShadowUF.db.profile.auraIndicators.auras[addAura.name] = "{}"
												
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

												unitTable.args.groups.args[tostring(groupID)] = unitGroupTable
												ShadowUF.Config.options.args.auraIndicators.args.units.args.global.args.groups.args[tostring(groupID)] = globalUnitGroupTable
												ShadowUF.Config.options.args.auraIndicators.args.auras.args[tostring(groupID)] = auraGroupTable
											end
											
											-- Shunt the user to the this groups page
											AceDialog = AceDialog or LibStub("AceConfigDialog-3.0")
											AceRegistry = AceRegistry or LibStub("AceConfigRegistry-3.0")
											AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras.status.groups.selected = tostring(gID or groupID)
											AceRegistry:NotifyChange("ShadowedUF")
											
											ShadowUF.Layout:Reload()
										end,
									},
								},
							},
						},
					},
				},
			},
			linked = {
				order = 3,
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
																		
									ShadowUF.db.profile.auraIndicators.linked[addLink.from] = addLink.to
									ShadowUF.Config.options.args.auraIndicators.args.linked.args[tostring(pID)] = parentLinkTable
									parentLinkTable.args[tostring(lID)] = childLinkTable

									addLink.from = nil
									addLink.to = nil
									
									ShadowUF.Layout:Reload()
								end,
							},
						},
					},
				},
			},
			units = {
				order = 4,
				type = "group",
				name = L["Enable by unit"],
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
								name = L["You can disable aura groups for units here. For example, you could set an aura group that shows DPS debuffs to only show on the target."],
								width = "full",
							},
						},
					},
					global = {
						order = 0,
						type = "group",
						name = SL["Global"],
						desc = L["Global configurating will let you mass enable or disable aura groups for multiple units at once."],
						args = {
							units = {
								order = 0,
								type = "multiselect",
								name = L["Units to change"],
								desc = L["Units that should have the aura groups settings changed below."],
								values = getEnabledUnits,
								set = function(info, unit, enabled) setGlobalUnits[unit] = enabled or nil end,
								get = function(info, unit) return setGlobalUnits[unit] end,
							},
							groups = {
								order = 1,
								type = "group",
								inline = true,
								name = L["Aura groups"],
								args = {},
							},
						},
					},
				},
			},
			classes = {
				order = 5,
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
		name = function(info) return LOCALIZED_CLASS_NAMES_MALE[info[#(info)]] end,
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
			ShadowUF.db.profile.auraIndicators.disabled[class][aura] = value
			ShadowUF.Layout:Reload()
		end,
		get = function(info)
			local aura = auraMap[info[#(info)]]
			local class = info[#(info) - 1]
			
			return not ShadowUF.db.profile.auraIndicators.disabled[class][aura]
		end,
	}
		
	-- Build links	
	local addedFrom = {}
	for from, to in pairs(ShadowUF.db.profile.auraIndicators.linked) do
		local pID = addedFrom[to] 
		if( not pID ) then
			linkID = linkID + 1
			pID = linkID

			addedFrom[to] = pID
		end

		linkID = linkID + 1
		
		ShadowUF.db.profile.auraIndicators.linked[from] = to
		ShadowUF.Config.options.args.auraIndicators.args.linked.args[tostring(pID)] = parentLinkTable
		parentLinkTable.args[tostring(linkID)] = childLinkTable
		
		linkMap[tostring(linkID)] = from
		linkMap[tostring(pID)] = to
	end
		
	-- Build the aura configuration
	local parents = {}
	for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
		local aura = Indicators.auraConfig[name]
		if( aura.group ) then
			auraMap[tostring(auraID)] = name
			auraGroupTable.args[tostring(auraID)] = auraConfigTable
			classTable.args[tostring(auraID)] = classAuraTable
			auraID = auraID + 1
			
			parents[aura.group] = true
		end
	end
	
	-- Now create all of the parent stuff
	for group in pairs(parents) do
		groupMap[tostring(groupID)] = group
		unitTable.args.groups.args[tostring(groupID)] = unitGroupTable
		ShadowUF.Config.options.args.auraIndicators.args.units.args.global.args.groups.args[tostring(groupID)] = globalUnitGroupTable
		ShadowUF.Config.options.args.auraIndicators.args.auras.args[tostring(groupID)] = auraGroupTable
		
		groupID = groupID + 1
	end

	-- Aura status by unit
	for unit, config in pairs(ShadowUF.db.profile.units) do
		if( config.auraIndicators ) then
			ShadowUF.Config.options.args.auraIndicators.args.units.args[unit] = unitTable
		end
	end
	
	-- Build class status thing
	for classToken in pairs(RAID_CLASS_COLORS) do
		ShadowUF.Config.options.args.auraIndicators.args.classes.args[classToken] = classTable
	end
	
	-- Quickly build the indicator one
	for key in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		ShadowUF.Config.options.args.auraIndicators.args.indicators.args[key] = indicatorTable
	end
	
	-- Automatically unlock the advanced text configuration for raid frames, regardless of advanced being enabled
	local advanceTextTable = ShadowUF.Config.advanceTextTable
	local originalHidden = advanceTextTable.args.sep.hidden
	local function unlockRaidText(info)
		if( info[2] == "raid" ) then return false end
		return originalHidden(info)
	end
	
	advanceTextTable.args.anchorPoint.hidden = unlockRaidText
	advanceTextTable.args.sep.hidden = unlockRaidText
	advanceTextTable.args.x.hidden = unlockRaidText
	advanceTextTable.args.y.hidden = unlockRaidText
end