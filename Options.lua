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
			debug = true,
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
			npcs = {}
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
