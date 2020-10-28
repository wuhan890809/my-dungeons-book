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
			y = 0,
			dateFormat = "%Y-%m-%d\n%H:%M",
			timeFormat = "%M:%S",
			flattenIcons = true
		},
		verbose = {
			debug = false,
			log = true
		},
		performance = {
			collectgarbage = true,
			showdevtab = false
		}
	},
	global = {
		meta = {
			spells = {},
			npcs = {},
			mechanics = {
				["DEATHS"] = {
					id = "DEATHS"
				},
				["COMMON-INTERRUPTS"] = {
					id = "COMMON-INTERRUPTS"
				},
				["COMMON-TRY-INTERRUPT"] = {
					id = "COMMON-TRY-INTERRUPT"
				},
				["COMMON-AFFIX-QUAKING-INTERRUPTS"] = {
					id = "COMMON-AFFIX-QUAKING-INTERRUPTS"
				},
				["COMMON-DISPEL"] = {
					id = "COMMON-DISPEL"
				},
				["ALL-DAMAGE-DONE-TO-PARTY-MEMBERS"] = {
					id = "ALL-DAMAGE-DONE-TO-PARTY-MEMBERS"
				},
				["ALL-AURAS"] = {
					id = "ALL-AURAS"
				},
				["ALL-CASTS-DONE-BY-PARTY-MEMBERS"] = {
					id = "ALL-CASTS-DONE-BY-PARTY-MEMBERS"
				},
				["ALL-ENEMY-PASSED-CASTS"] = {
					id = "ALL-ENEMY-PASSED-CASTS",
					internal = true
				},
				["PARTY-MEMBERS-HEAL"] = {
					id = "PARTY-MEMBERS-HEAL"
				},
				["PARTY-MEMBERS-SUMMON"] = {
					id = "PARTY-MEMBERS-SUMMON",
					internal = true
				},
				["BFA-AVOIDABLE-SPELLS"] = {
					id = "BFA-AVOIDABLE-SPELLS"
				},
				["BFA-AVOIDABLE-AURAS"] = {
					id = "BFA-AVOIDABLE-AURAS"
				},
				["BFA-SPELLS-TO-INTERRUPT"] = {
					id = "BFA-SPELLS-TO-INTERRUPT"
				},
				["BFA-UNITS-APPEARS-IN-COMBAT"] = {
					id = "BFA-UNITS-APPEARS-IN-COMBAT"
				},
				["BFA-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS"] = {
					id = "BFA-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS"
				},
				["BFA-BUFFS-OR-DEBUFFS-ON-UNIT"] = {
					id = "BFA-BUFFS-OR-DEBUFFS-ON-UNIT"
				},
				["BFA-CASTS-DONE-BY-PARTY-MEMBERS"] = {
					id = "BFA-CASTS-DONE-BY-PARTY-MEMBERS"
				},
				["BFA-OWN-CASTS-DONE-BY-PARTY-MEMBERS"] = {
					id = "BFA-OWN-CASTS-DONE-BY-PARTY-MEMBERS"
				},
				["BFA-ITEM-USED-BY-PARTY-MEMBERS"] = {
					id = "BFA-ITEM-USED-BY-PARTY-MEMBERS"
				},
				["BFA-DAMAGE-DONE-TO-UNITS"] = {
					id = "BFA-DAMAGE-DONE-TO-UNITS"
				},
				["SL-AVOIDABLE-SPELLS"] = {
					id = "SL-AVOIDABLE-SPELLS"
				},
				["SL-AVOIDABLE-AURAS"] = {
					id = "SL-AVOIDABLE-AURAS"
				},
				["SL-SPELLS-TO-INTERRUPT"] = {
					id = "SL-SPELLS-TO-INTERRUPT"
				},
				["SL-UNITS-APPEARS-IN-COMBAT"] = {
					id = "SL-UNITS-APPEARS-IN-COMBAT"
				},
				["SL-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS"] = {
					id = "SL-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS"
				},
				["SL-BUFFS-OR-DEBUFFS-ON-UNIT"] = {
					id = "SL-BUFFS-OR-DEBUFFS-ON-UNIT"
				},
				["SL-CASTS-DONE-BY-PARTY-MEMBERS"] = {
					id = "SL-CASTS-DONE-BY-PARTY-MEMBERS"
				},
				["SL-OWN-CASTS-DONE-BY-PARTY-MEMBERS"] = {
					id = "SL-OWN-CASTS-DONE-BY-PARTY-MEMBERS"
				},
				["SL-ITEM-USED-BY-PARTY-MEMBERS"] = {
					id = "SL-ITEM-USED-BY-PARTY-MEMBERS"
				},
				["SL-DAMAGE-DONE-TO-UNITS"] = {
					id = "SL-DAMAGE-DONE-TO-UNITS"
				}
			},
		}
	}
};

MyDungeonsBook.Options = {
	type = "group",
	args = {
		ui = {
			order = 1,
			name = L["UI"],
			type="group",
			args = {
				dateAndTime = {
					type = "group",
					name = L["Date and Time"],
					inline = true,
					order = 1,
					args = {
						dateFormat = {
							order = 1,
							name = L["Date Format"],
							type = "select",
							width = "normal",
							style = "dropdown",
							values = {
								["%Y-%m-%d\n%H:%M"] = "2020-10-20 12:34",
								["%d-%m-%Y\n%H:%M"] = "20-10-2020 12:34",
								["%Y %b %d\n%H:%M"] = "2020 Oct 20 12:34",
								["%d %b %Y\n%H:%M"] = "20 Oct 2020 12:34",
							},
							get = function()
								return MyDungeonsBook.db.profile.display.dateFormat;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.display.dateFormat = v;
							end
						},
						timeFormat = {
							order = 2,
							name = L["Time Format"],
							type = "select",
							width = "normal",
							style = "dropdown",
							values = {
								["%M:%S"] = "12:34",
								["%M-%S"] = "12-34"
							},
							get = function()
								return MyDungeonsBook.db.profile.display.timeFormat;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.display.timeFormat = v;
							end
						}
					}
				},
				icons = {
					type = "group",
					inline = true,
					order = 2,
					name = L["Icons"],
					args = {
						flattenIcons = {
							order = 2,
							name = L["Flatten Icons"],
							type = "toggle",
							width = "normal",
							get = function()
								return MyDungeonsBook.db.profile.display.flattenIcons;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.display.flattenIcons = v;
							end
						}
					}
				},
			}
		},
		verbose = {
			order = 1,
			name = L["Verbose"],
			type = "group",
			args = {
				logs = {
					type = "group",
					inline = true,
					order = 1,
					name = L["Logs"],
					args = {
						debug = {
							order = 1,
							name = L["Show DEBUG messages"],
							type = "toggle",
							width = "normal",
							get = function()
								return MyDungeonsBook.db.profile.verbose.debug;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.verbose.debug = v;
							end
						},
						log = {
							order = 2,
							name = L["Show LOG messages"],
							type = "toggle",
							width = "normal",
							get = function()
								return MyDungeonsBook.db.profile.verbose.log;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.verbose.log = v;
							end
						}
					}
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
				},
				showdevtab = {
					order = 2,
					name = L["Show DEV Tab"],
					type = "toggle",
					width = "full",
					get = function()
						return MyDungeonsBook.db.profile.performance.showdevtab;
					end,
					set = function (_, v)
						MyDungeonsBook.db.profile.performance.showdevtab = v;
					end
				}
			}
		}
	}
};
