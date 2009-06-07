--[[ 
	Shadow Unit Frames (Grid), Mayen/Selari from Illidan (US) PvP
]]

local L = SUFGridLocals
local Grid = {}
ShadowUF:RegisterModule(Grid, "grid")

function Grid:OnDefaultsSet()
	ShadowUF.defaults.profile.units.raid.grid = {enabled = true, cursed = false, vertical = false, indicators = {}, auras = {}}
	
	-- Hook into the coloring to make sure our color override is set if needed.
	local UpdateColor = ShadowUF.modules.healthBar.UpdateColor
	ShadowUF.modules.healthBar.UpdateColor = function(self, frame, ...)
		-- Check if the unit is cursed, and we need to force it to color it by the debuff
		if( frame.unitType == "raid" and frame.grid and frame.grid.activeCurse ) then
			local color = DebuffTypeColor[button.activeCurse]
			if( color ) then
				bar:SetStatusBarColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.alpha)
				bar.background:SetVertexColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.backgroundAlpha)
				return
			end
		end
		
		return UpdateColor(self, frame, ...)
	end
end

function Grid:OnConfigurationLoad()
	ShadowUF.Config.unitTable.args.bars.args.healthBar.args.vertical = {
		order = 0,
		type = "toggle",
		name = L["Enable vertical health"],
		desc = L["Changes the health bar to go from top -> bottom instead of right -> left when players lose health."],
		arg = "grid.vertical",
		width = "full",
		hidden = ShadowUF.Config.hideRestrictedOption,
	}
end

function Grid:OnEnable(frame)
	-- Force a check cures check in case every aura is disabled
	ShadowUF.modules.auras:CheckCures()

	-- Not going to create the indicators we want here, will do that when we do the layout stuff
	frame.grid = frame.grid or CreateFrame("Frame", nil, frame)
	frame.grid.indicators = frame.grid.indicators or {}

	-- Set orientation of bars
	if( frame.healthBar ) then
		local orientation = ShadowUF.db.profile.units[frame.unitType].grid.vertical and "VERTICAL" or "HORIZONTAL"
		frame.healthBar:SetOrientation(orientation)
		
		if( frame.incHeal ) then
			frame.incHeal:SetOrientation(orientation)
		end
	end
	
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

function Grid:OnLayoutApplied(frame)
	if( not frame.grid ) then return end
	
	-- Create any indicators we haven't already
	for i=#(frame.grid.indicators) + 1, #(ShadowUF.db.profile.units[frame.unitType].grid.indicators) do
		local indicator = CreateFrame("Frame", nil, frame.grid)
		indicator:SetFrameLevel(frame.topFrameLevel)
		indicator.texture = indicator:CreateTexture(nil, "OVERLAY")
		indicator.texture:SetAllPoints(indicator)
		
		indicator.cooldown = CreateFrame("Cooldown", nil, indicator, "CooldownFrameTemplate")
		indicator.cooldown:SetReverse(true)
		indicator.cooldown:SetPoint("CENTER", 0, -1)
		
		table.insert(frame.grid.indicators, indicator)
	end

	-- Set enabled status of all the indicators now
	for id, indicator in pairs(frame.grid.indicators) do
		local config = ShadowUF.db.profile.units[frame.unitType].grid.indicators[id]
		indicator.enabled = config and config.enabled
		if( indicator.enabled ) then
			indicator:SetHeight(config.height)
			indicator:SetWidth(config.width)
			ShadowUF.Layout:AnchorFrame(frame, indicator, config)
		else
			indicator:Hide()
		end
	end
end

local function scanAura(frame, unit, filter)
	local index = 1
	while( true ) do
		local name, rank, texture, count, debuffType, duration, endTime, caster, isStealable = UnitAura(unit, index, filter)
		if( not name ) then break end

		-- Setup the auras in the indicators baserd on priority
		local auraConfig = ShadowUF.db.profile.units[frame.unitType].grid.auras[name]
		local indicator = auraConfig and frame.grid.indicators[auraConfig.indicator]
		if( indicator and indicator.enabled and auraConfig.priority > indicator.priority and ( not auraConfig.player or caster == "player" or caster == "vehicle" ) ) then
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

		index = index + 1
	end
end

function Grid:UpdateIndicators(indicators)
	for id, indicator in pairs(indicators) do
		if( indicator.enabled and indicator.priority > -1 ) then
			-- Show a cooldown ring
			if( indicator.showDuration ) then
				indicator.cooldown:SetCooldown(indicator.spellEnd - indicator.spellDuration, indicator.spellDuration)
			else
				indicator.cooldown:Hide()
			end
			
			-- Show either the icon, or a solid color
			if( indicator.showIcon ) then
				indicator.texture:SetTexture(indicator.spellIcon)
			else
				indicator.texture:SetTexture(indicator.colorR, indicator.colorG, indicator.colorB)
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
	
	frame.grid.currentCurse = nil
	
	-- Scan auras
	scanAura(frame, frame.unit, "HELPFUL")
	scanAura(frame, frame.unit, "HARMFUL")
	
	-- Active curse changed, make sure we update coloring
	if( frame.grid.currentCurse ~= frame.grid.activeCurse ) then
		ShadowUF.modules.healthBar:UpdateColor(frame)
	end
	
	-- Now force the indicators to update
	self:UpdateIndicators(frame.grid.indicators)
end









