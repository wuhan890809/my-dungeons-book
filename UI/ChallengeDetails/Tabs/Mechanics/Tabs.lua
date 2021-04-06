--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Mechanics frame.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:MechanicsFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	tabs:SetTabs({
		{value = "usedItems", text = L["Used Items"]},
		{value = "casts", text = L["Casts"]},
		{value = "heal", text = L["Heal"]},
		{value = "damage", text = L["Damage"]},
		{value = "effectsAndAuras", text = L["Effects and Auras"]},
		{value = "deaths", text = L["Deaths"]}
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "usedItems") then
			self.usedItemsFrame = self:UsedItemsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "casts") then
			self.castsFrame = self:CastsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "heal") then
			self.healByPartyMembersFrameFrame = self:HealByPartyMembersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "damage") then
			self.damageFrame = self:DamageFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "effectsAndAuras") then
			self.effectsAndAurasFrame = self:EffectsAndAurasFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "deaths") then
			self.deathsFrame = self:DeathsFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(622);
	return tabs;
end
