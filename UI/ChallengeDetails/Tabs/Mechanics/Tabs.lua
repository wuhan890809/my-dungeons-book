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
		{value = "effectsAndAuras", text = L["Effects and Auras"]}
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "usedItems") then
			self:UsedItemsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "casts") then
			self:CastsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "heal") then
			self:HealByPartyMembersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "damage") then
			self:DamageFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "effectsAndAuras") then
			self:EffectsAndAurasFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(578);
	return tabs;
end
