--[[--
@module MyDungeonsBook
]]

--[[--
Mechanics
@section Mechanics
]]

local SLSpells = {};

local SLSpellsNoTank = {};

local SLAuras = {};

local SLAurasNoTank = {};

local SLSpellsToInterrupt = {};

local SLUnitsAppearsInCombat = {};

local SLSpecificBuffOrDebuffOnPartyMembers = {};

local SLSpecificBuffOrDebuffOnUnit = {};

local SLSpecificCastsDoneByPartyMembers = {};

local SLSpecificItemsUsedByPartyMembers = {};

local SLDamageDoneToSpecificUnits = {};

function MyDungeonsBook:GetSLDamageDoneToSpecificUnits()
	return SLDamageDoneToSpecificUnits;
end

function MyDungeonsBook:TrackSLAvoidableSpells(damagedUnit, spellId, amount)
	self:TrackAvoidableSpells("SL-AVOIDABLE-SPELLS", SLSpells, SLSpellsNoTank, damagedUnit, spellId, amount);
end

function MyDungeonsBook:TrackSLAvoidableAuras(damagedUnit, spellId)
	self:TrackAvoidableAuras("SL-AVOIDABLE-AURAS", SLAuras, SLAurasNoTank, damagedUnit, spellId);
end

function MyDungeonsBook:TrackSLPassedCasts(caster, spellId)
	self:TrackPassedCasts("SL-SPELLS-TO-INTERRUPT", SLSpellsToInterrupt, caster, spellId);
end

function MyDungeonsBook:TrackSLUnitsAppearsInCombat(sourceUnitGUID, targetUnitGUID)
	self:TrackUnitsAppearsInCombat("SL-UNITS-APPEARS-IN-COMBAT", SLUnitsAppearsInCombat, sourceUnitGUID, targetUnitGUID);
end

function MyDungeonsBook:TrackSLSpecificBuffOrDebuffOnPartyMembers(unit, spellId)
	self:TrackSpecificBuffOrDebuffOnPartyMembers("SL-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS", SLSpecificBuffOrDebuffOnPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackSLSpecificBuffOrDebuffOnUnit(unit, spellId)
	self:TrackSpecificBuffOrDebuffOnUnit("SL-BUFFS-OR-DEBUFFS-ON-UNIT", SLSpecificBuffOrDebuffOnUnit, unit, spellId);
end

function MyDungeonsBook:TrackSLSpecificCastDoneByPartyMembers(unit, spellId)
	self:TrackSpecificCastDoneByPartyMembers("SL-CASTS-DONE-BY-PARTY-MEMBERS", SLSpecificCastsDoneByPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackSLSpecificItemUsedByPartyMembers(unit, spellId)
	self:TrackSpecificItemUsedByPartyMembers("SL-ITEM-USED-BY-PARTY-MEMBERS", SLSpecificItemsUsedByPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackSLDamageDoneToSpecificUnits(sourceName, sourceGUID, spellId, amount, overkill, targetName, targetGUID)
	self:TrackDamageDoneToSpecificUnits("SL-DAMAGE-DONE-TO-UNITS", SLDamageDoneToSpecificUnits, sourceName, sourceGUID, spellId, amount, overkill, targetName, targetGUID);
end
