--[[--
@module MyDungeonsBook
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

MyDungeonsBook.OptionsDefaults = {
	char = {
		activeChallengeId = nil,
		challenges = {},
		filters = {
			challenges = {
				inTime = "ALL",
				keyLevel = "ALL",
				dungeon = "ALL",
				affixes = "ALL",
				deaths = "ALL",
				currentWeek = false
			},
			units = {
				npc = "ALL",
			},
			unitAuras = {
				npc = "ALL",
				aura = "ALL",
				guid = "ALL"
			},
			brokenAuras = {
				npc = "ALL",
				aura = "ALL"
			},
			ownCasts = {
				spellId = "ALL"
			}
		}
	},
	profile = {
		display = {
			x = 0,
			y = 0,
			dateFormat = "%Y-%m-%d\n%H:%M",
			timeFormat = "%M:%S",
			flattenIcons = true,
			scale = 1
		},
		verbose = {
			debug = false,
			log = true
		},
		performance = {
			collectgarbage = true,
			showdevtab = false,
			compress = true
		},
		dev = {
			mechanics = {
				["ALL-ENEMY-AURAS"] = {
					enabled = false
				}
			}
		}
	},
	global = {
		meta = {
			spells = {},
			npcs = {},
			addons = {
				mythicDungeonTools = {
					npcs = {
						[162099] = {
							id = 162099,
							mustDieToCount = false,
							displayId = 95721,
							isBoss = true,
							count = 0,
						},
						[162133] = {
							id = 162133,
							mustDieToCount = false,
							count = 0
						},
						[162692] = {
							id = 162692,
							displayId = 94926,
							isBoss = true,
							count = 0,
						},
						[164555] = {
							id = 164555,
							displayId = 67422,
							isBoss = true,
							count = 0,
							mustDieToCount = false
						},
						[164556] = {
							id = 164556,
							displayId = 68818,
							isBoss = true,
							count = 0,
							mustDieToCount = false
						},
						[164561] = {
							ignored = true,
						},
						[164568] = {
							ignored = true,
						},
						[165108] = {
                            ignored = true
                        },
						[164929] = {
                            id = 164929,
                            mustDieToCount = false,
                            count = 7,
                            displayId = 95618
                        },
                        [165251] = {
                            ignored = true
                        },
						[166608] = {
							id = 166608,
							displayId = 96358,
							isBoss = true,
							count = 0,
							mustDieToCount = false
						},
						[167615] = {
							id = 167615,
							displayId = 93074,
							count = 4,
						},
						[167966] = {
							ignored = true,
						},
						[168393] = {
							id = 168393,
							count = 12,
							displayId = 96244
						},
						[168396] = {
							id = 168396,
							count = 12,
							displayId = 96244
						},
						[169753] = {
						    id = 169753,
						    count = 1,
						    displayId = 94227
						},
						[170486] = {
							id = 170486,
							count = 2,
							displayId = 97298
						},
						[171772] = {
						    id = 171772,
						    count = 4,
						    displayId = 95256
						},
						[171805] = {
							id = 171805,
							count = 4,
							displayId = 97622
						},
						[174175] = {
							id = 174175,
							count = 4,
							displayId = 95706,
							mustDieToCount = true
						},
						[180786] = {
						    ignored = true
						}
					},
				}
			},
			npcToTrackSwingDamage = {
				[174773] = {
					icon = 135945
				}
			},
			mechanics = {
				["DEATHS"] = {
					id = "DEATHS",
					verbose = true
				},
				["COMMON-INTERRUPTS"] = {
					id = "COMMON-INTERRUPTS",
					verbose = true
				},
				["COMMON-TRY-INTERRUPT"] = {
					id = "COMMON-TRY-INTERRUPT"
				},
				["COMMON-AFFIX-QUAKING-INTERRUPTS"] = {
					id = "COMMON-AFFIX-QUAKING-INTERRUPTS"
				},
				["COMMON-DISPEL"] = {
					id = "COMMON-DISPEL",
					verbose = true
				},
				["ALL-DAMAGE-DONE-TO-PARTY-MEMBERS"] = {
					id = "ALL-DAMAGE-DONE-TO-PARTY-MEMBERS",
					verbose = true
				},
				["ALL-AURAS"] = {
					id = "ALL-AURAS"
				},
				["ALL-ENEMY-AURAS"] = {
					id = "ALL-ENEMY-AURAS",
					internal = true
				},
				["ALL-CASTS-DONE-BY-PARTY-MEMBERS"] = {
					id = "ALL-CASTS-DONE-BY-PARTY-MEMBERS"
				},
				["ALL-DAMAGE-DONE-BY-PARTY-MEMBERS"] = {
					id = "ALL-DAMAGE-DONE-BY-PARTY-MEMBERS"
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
					id = "BFA-AVOIDABLE-SPELLS",
					verbose = true
				},
				["BFA-SPELLS-TO-INTERRUPT"] = {
					id = "BFA-SPELLS-TO-INTERRUPT",
					verbose = true
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
					id = "SL-AVOIDABLE-SPELLS",
					verbose = true
				},
				["SL-SPELLS-TO-INTERRUPT"] = {
					id = "SL-SPELLS-TO-INTERRUPT",
					verbose = true
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
				},
				["PARTY-MEMBER-DEATH-LOGS"] = {
					id = "PARTY-MEMBER-DEATH-LOGS",
					timeBeforeDeathToTrack = 15
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
				scale = {
					type = "group",
					inline = true,
					order = 3,
					name = L["Scale"],
					args = {
						ui = {
							order = 1,
							name = L["Window scale"],
							type = "range",
							width = "normal",
							min = 1,
							max = 1.5,
							step = 0.05,
							get = function()
								return MyDungeonsBook.db.profile.display.scale;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.display.scale = v;
							end
						}
					}
				}
			}
		},
		verbose = {
			order = 2,
			name = L["Verbose"],
			type = "group",
			args = {
				logs = {
					type = "group",
					inline = true,
					order = 1,
					name = L["Logging Levels"],
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
				},
				logDetailsDescription = {
					order = 2,
					type = "description",
					name = L["Options below are global. However they are overridden by LOG-option above. E.g. when \"Show LOG messages\" is disabled, no log messages will be printed independently of settings below."]
				},
				logDetails = {
					type = "group",
					inline = true,
					order = 3,
					name = L["Logs"],
					args = {
						avoidableSpells = {
							order = 1,
							name = L["Show LOG messages about avoidable DAMAGE taken"],
							type = "toggle",
							width = "full",
							get = function()
								-- Doesn't metter which one to use. Both BFA and SL have the same value
								return MyDungeonsBook.db.global.meta.mechanics["BFA-AVOIDABLE-SPELLS"].verbose;
							end,
							set = function(_, v)
								for _, key in pairs({"BFA-AVOIDABLE-SPELLS", "SL-AVOIDABLE-SPELLS"}) do
									MyDungeonsBook.db.global.meta.mechanics[key].verbose = v;
								end
							end
						},
						interrupts = {
							order = 3,
							name = L["Show LOG messages about INTERRUPTS"],
							type = "toggle",
							width = "full",
							get = function()
								return MyDungeonsBook.db.global.meta.mechanics["COMMON-INTERRUPTS"].verbose;
							end,
							set = function(_, v)
								MyDungeonsBook.db.global.meta.mechanics["COMMON-INTERRUPTS"].verbose = v;
							end
						},
						notInterrupted = {
							order = 4,
							name = L["Show LOG messages about NOT INTERRUPTED casts"],
							type = "toggle",
							width = "full",
							get = function()
								-- Doesn't metter which one to use. Both BFA and SL have the same value
								return MyDungeonsBook.db.global.meta.mechanics["BFA-SPELLS-TO-INTERRUPT"].verbose;
							end,
							set = function(_, v)
								for _, key in pairs({"BFA-SPELLS-TO-INTERRUPT", "SL-SPELLS-TO-INTERRUPT"}) do
									MyDungeonsBook.db.global.meta.mechanics[key].verbose = v;
								end
							end
						},
						dispels = {
							order = 5,
							name = L["Show LOG messages about DISPELS"],
							type = "toggle",
							width = "full",
							get = function()
								return MyDungeonsBook.db.global.meta.mechanics["COMMON-DISPEL"].verbose;
							end,
							set = function(_, v)
								MyDungeonsBook.db.global.meta.mechanics["COMMON-DISPEL"].verbose = v;
							end
						},
						deaths = {
							order = 6,
							name = L["Show LOG messages about DEATHS"],
							type = "toggle",
							width = "full",
							get = function()
								return MyDungeonsBook.db.global.meta.mechanics["DEATHS"].verbose;
							end,
							set = function(_, v)
								MyDungeonsBook.db.global.meta.mechanics["DEATHS"].verbose = v;
							end
						}
					}
				}
			}
		},
		performance = {
			order = 3,
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
				compress = {
					order = 2,
					name = L["Compress saved data after challenge is completed"],
					desc = L["May cause small lag on challenge end"],
					type = "toggle",
					width = "full",
					get = function()
						return MyDungeonsBook.db.profile.performance.compress;
					end,
					set = function(_, v)
						MyDungeonsBook.db.profile.performance.compress = v;
					end
				},
				showdevtab = {
					order = 3,
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
		},
		dev = {
			order = 4,
			name = L["Dev"],
			type = "group",
			args = {
				mechanics = {
					name = L["Mechanics"],
					inline = true,
					type = "group",
					args = {
						description = {
							order = 1,
							type = "description",
							name = L["There is a list of internal trackers. Their info is not used directly on the UI and is useful only for devs. No sense to enable it."]
						},
						["ALL-ENEMY-AURAS"] = {
							order = 2,
							name = "ALL-ENEMY-AURAS",
							type = "toggle",
							width = "full",
							get = function()
								return MyDungeonsBook.db.profile.dev.mechanics["ALL-ENEMY-AURAS"].enabled;
							end,
							set = function(_, v)
								MyDungeonsBook.db.profile.dev.mechanics["ALL-ENEMY-AURAS"].enabled = v;
							end
						}
					}
				}
			}
		},
		mechanics = {
			order = 5,
			name = L["Mechanics"],
			type = "group",
			args = {
				deathlogs = {
					name = L["Death logs"],
					type = "group",
					args = {
						timeBeforeDeathToTrack = {
							order = 1,
							name = L["Time before death to track"],
							type = "range",
							width = "full",
							min = 5,
							max = 15,
							step = 1,
							get = function()
								return MyDungeonsBook.db.global.meta.mechanics["PARTY-MEMBER-DEATH-LOGS"].timeBeforeDeathToTrack;
							end,
							set = function(_, v)
								MyDungeonsBook.db.global.meta.mechanics["PARTY-MEMBER-DEATH-LOGS"].timeBeforeDeathToTrack = v;
							end
						}
					}
				}
			}
		}
	}
};
