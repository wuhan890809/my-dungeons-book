--[[--
@module MyDungeonsBook
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

MyDungeonsBook.OptionsDefaults = {
	char = {
		activeChallengeId = nil,
		challenges = {},
		filters = {
			inTime = nil,
			level = nil,
			version = nil,
		}
	},
	profile = {
		display = {
			x = 0,
			y = 0
		},
		verbose = {
			debug = true,
			log = true
		},
		performance = {
			collectgarbage = true
		}
	},
	global = {
		meta = {
			spells = {},
			npcs = {}
		}
	}
};

MyDungeonsBook.Options = {
	type = "group",
	args = {
		verbose = {
			order = 1,
			name = L["Verbose"],
			type = "group",
			args = {
				debug = {
					order = 1,
					name = L["MainFrame_Show DEBUG messages"],
					type = "toggle",
					width = "full",
					get = function()
						return MyDungeonsBook.db.profile.verbose.debug;
					end,
					set = function(_, v)
						MyDungeonsBook.db.profile.verbose.debug = v;
					end
				},
				log = {
					order = 2,
					name = L["MainFrame_Show LOG messages"],
					type = "toggle",
					width = "full",
					get = function()
						return MyDungeonsBook.db.profile.verbose.log;
					end,
					set = function(_, v)
						MyDungeonsBook.db.profile.verbose.log = v;
					end
				}
			}
		},
		performance = {
			order = 2,
			name = L["Performance"],
			type = "group",
			args = {
				collectgarbage = {
					order = 1,
					name = L["Run garbage collector on close"],
					type = "toggle",
					width = "full",
					get = function()
						return MyDungeonsBook.db.profile.performance.collectgarbage;
					end,
					set = function (_, v)
						MyDungeonsBook.db.profile.performance.collectgarbage = v;
					end
				}
			}
		}
	}
};
