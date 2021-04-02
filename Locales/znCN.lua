local L = LibStub("AceLocale-3.0"):NewLocale("MyDungeonsBook", "zhCN");
if not L then return end

-- UI start
L["My Dungeons Book"] = true;
L["Filters"] = "过滤器";
L["%s died"] = "%s 死亡";
L["%s got hit by %s for %s (%s)"] = "%s 被 %s 击中，受到 %s (%s) 点伤害";
L["%s got debuff by %s"] = "%s 受到了来自 %s 的Debuff影响";
L["%s interrupted %s using %s"] = "%s 打断了 %s ，通过 %s";
L["%s +%s is completed"] = "%s +%s 已完成";
L["%s +%s is reset"] = "%s +%s 已重置";
L["%s +%s is started"] = "%s +%s 已开始";
L["%s's cast %s is passed"] = "%s 的施法 %s 被漏断"; --needs review
L["Date"] = "日期";
L["Time"] = "时间";
L["Version"] = "版本";
L["Dungeon"] = "地下城";
L["Key"] = "钥石";
L["Affixes"] = "词缀";
L["Not Found"] = "未找到";
L["Yes"] = "是";
L["No"] = "否";
L["Reset"] = "重置";
L["Deaths"] = "死亡";
L["Fortified"] = "强韧";
L["Tyrannical"] = "残暴";
L["In Time"] = "成功限时";
L["Not In Time"] = "未成功限时";
L["All"] = "全部";
L["Race: %s"] = "种族: %s";
L["Hits"] = "命中";
L["Spell"] = "法术";
L["DEV"] = "开发";
L["Dev"] = "开发";
L["Mechanics"] = "战斗机制";
L["Interrupts"] = "打断";
L["Encounters"] = "战斗";
L["Details"] = "详情";
L["Avoidable Debuffs"] = "可规避的Debuff";
L["Avoidable Damage"] = "可规避的伤害";
L["Roster"] = "成员";
L["ID"] = "ID";
L["HPS"] = "HPS";
L["Heal"] = "治疗";
L["DPS"] = "DPS";
L["Damage"] = "伤害输出";
L["Player"] = "玩家";
L["Sum"] = "合计";
L["Num"] = "数值";
L["Kicks"] = "打断";
L["Passed"] = "漏断"; --needs review
L["Kicked"] = "断中";
L["After"] = "战斗后";
L["While"] = "战斗中";
L["Before"] = "战斗前";
L["Duration"] = "战斗时长";
L["End Time"]= "结束时间";
L["Start Time"]= "开始时间";
L["Name"] = "名称";
L["Over"] = "过量"; --needs review
L["Amount"] = "数量";
L["Damage Done To Units"] = "对单位造成伤害";
L["Special Casts"] = "特殊施法"
L["Own Casts"] = "自身施法";
L["Buffs Or Debuffs On Units"] = "对单位施放的Buff或Debuff";
L["Special Buffs Or Debuffs"] = "特殊Buff或Debuff";
L["Casts"] = "施法"
L["NPC"] = "NPC";
L["Count"] = "计数";
L["%s (%s) %s"] = "%s (%s) %s";
L["Time lost: %ss"] = "时间损失: %s秒";
L["Time: %s / %s (%s%s) %.1f%%"] = "用时: %s / %s (%s%s) %.1f%%";
L["Key HP bonus: %s%%"] = "钥石血量加成: %s%%";
L["Key damage bonus: %s%%"] = "钥石伤害加成: %s%%";
L["Dungeon: %s (+%s)"] = "地下城: %s (+%s)";
L["Used Items"] = "已使用物品";
L["Item"] = "物品";
L["%s dispelled %s using %s"] = "%s 驱散了 %s，通过 %s";
L["Effects and Auras"] = "效果和光环";
L["All Buffs"] = "所有Buff";
L["All Debuffs"] = "所有Debuff";
L["Time"] = "时间";
L["Target?"] = "目标？";
L["Swing Damage"] = "平砍伤害";
L["Result"] = "结果";
L["All damage taken"] = "全部承受伤害";
L["All damage done"] = "全部输出伤害";
L["Dispels"] = "驱散";
L["Are you sure you want to delete info about challenge?"] = "你确定要删除此次挑战记录？";
L["Challenge #%s is deleted successfully"] = "挑战记录 #%s 已成功删除";
L["Min Not Crit"] = "最小非暴击";
L["Hits Not Crit"] = "非暴击数";
L["Max Not Crit"] = "最大非暴击";
L["Min Crit"] = "最小暴击";
L["Max Crit"] = "最大暴击";
L["Crit, %"] = "暴击率, %";
L["Hits Crit"] = "暴击数";
L["Show All Casts"] = "显示所有施法";
L["By Spell"] = "按法术";
L["To Each Party Member"] = "对每个队友";
L["Quaked"] = "被震荡打断";
L["%"] = "%";
L["Summary"] = "总结";
L["Not all spells have usage timestamps"] = "并非所有法术都有时间戳来标识其使用";
L["All Buffs & Debuffs"] = "所有Buff及Debuff";
L["Uptime, %"] = "覆盖率, %";
L["Max Stacks"] = "最大层数";
L["Type"] = "类型";
L["Avoidable"] = "可规避";
L["Talents"] = "天赋";
L["Covenant"] = "盟约";
L["Equipment"] = "装备";
L["Info"] = "信息";
L["Covenant info is available only about players with installed MyDungeonsBook."] = "只能显示安装了MyDungeonsBook的玩家的盟约信息。";
L["WowHead"] = "WowHead";
L["WowHead Link for %s"] = "%s的WowHead链接";
L["Report"] = "报告";
L["To Self"] = "向自己";
L["To Target"] = "向目标";
L["To Group/Raid"] = "向小队/团队";
L["MyDungeonsBook %s Usage:"] = "MyDungeonsBook %s 使用:";
L["MyDungeonsBook %s Interrupted:"] = "MyDungeonsBook %s 打断:";
L["MyDungeonsBook %s Casts:"] = "MyDungeonsBook %s 施法:";
L["MyDungeonsBook Damage taken by party from %s:"] = "MyDungeonsBook 小队承受来自 %s 的伤害:";
L["MyDungeonsBook Heal done by %s with %s:"] = "MyDungeonsBook 来自 %s 的治疗，通过 %s:";
L["MyDungeonsBook Damage done by party to %s:"] = "MyDungeonsBook 小队向 %s 输出的伤害:";
L["MyDungeonsBook %s Dispelled:"] = "MyDungeonsBook %s 驱散:";
L["MyDungeonsBook Debuff %s hits:"] = "MyDungeonsBook Debuff %s 命中:";
-- UI end

-- Help start
L["alias for previous word"] = "前面单词的缩写";
L["update info about party member for current challenge. unitId must be 'player' or 'party1..4'."] = "更新本次挑战成员的信息. 单位ID(unitId)必须是'player'或者'party1..4'这种形式";
L["print this text."] = "显示这段文字。";
L["send some message via comm to other MDB user. unitId must be 'party1..4'."] = "通过聊天向其他MDB用户发送信息。单位ID(unitId)必须是'party1..4'这种形式";
-- Help end

-- Settings start
L["Performance"] = "性能";
L["Run garbage collector on close"] = "退出时运行垃圾收集";
L["Show DEV Tab"] = "显示开发者功能表";
L["Verbose"] = "杂项";
L["Show DEBUG messages"] = "显示故障排查(DEBUG)信息";
L["Show LOG messages"] = "显示日志(LOG)信息";
L["UI"] = "用户界面";
L["Date Format"] = "日期格式";
L["Time Format"] = "时间格式";
L["Icons"] = "图标";
L["Flatten Icons"] = "扁平化图标";
L["Date and Time"] = "日期和时间";
L["Logging Levels"] = "日志等级";
L["Logs"] = "日志";
L["Show LOG messages about avoidable DEBUFFS"] = "显示关于可规避DEBUFF的日志信息";
L["Show LOG messages about avoidable DAMAGE taken"] = "显示关于可规避伤害的日志信息";
L["Show LOG messages about INTERRUPTS"] = "显示关于打断的日志信息";
L["Show LOG messages about DISPELS"] = "显示关于驱散的日志信息";
L["Show LOG messages about DEATHS"] = "显示关于死亡的日志信息";
L["Show LOG messages about NOT INTERRUPTED casts"] = "显示关于施法未打断的日志信息";
L["Options below are global. However they are overridden by LOG-option above. E.g. when \"Show LOG messages\" is disabled, no log messages will be printed independently of settings below."] = "下面为全局选项。但是它们会被上面的日志选项覆盖。比如当\"显示日志(LOG)信息\"被禁用时，下面任意选项都不能独立显示日志信息。";
L["There is a list of internal trackers. Their info is not used directly on the UI and is useful only for devs. No sense to enable it."] = "以下是一份内置追踪列表。它们的信息仅对开发者十分有用，不会直接应用在用户界面上。所以你没道理启用它。";
-- Settings end

-- BfA start
-- NPCs start
L["Explosives"] = "爆炸物";
L["Blood Tick"] = "血虱";
L["Inconspicuous Plant"] = "不起眼的盆栽";
L["Earthrager"] = "地怒者";
L["Animated Gold"] = "活性黄金";
L["Reban"] = "莱班";
L["T'zala"] = "提扎拉";
L["Reanimated Raptor"] = "复生的迅猛龙";
L["Wasting Servant"] = "大手大脚的仆从";
L["Soul Thorns"] = "灵魂荆棘";
L["Blood Visage"] = "血面兽";
L["Blood Effigy"] = "鲜血雕像";
L["A Knot of Snakes"] = "缠绕的蛇群";
L["Buzzing Drone"] = "嗡鸣的寄生虫";
L["Gripping Terror"] = "攫握恐魔";
L["Hull Cracker"] = "甲板破碎者";
L["Ashvane Cannoneer"] = "艾什凡炮手";
L["Venture Co. Skyscorcher"] = "风险投资公司灼天者";
L["Deathtouched Slaver"] = "亡触奴隶主";
L["Mindrend Tentacle"] = "裂魂触须";
-- NPCs end
-- BfA end

-- SL start
-- NPCs start
-- NPCs end
-- SL end

-- Race start
L["Human"] = "人类";
L["Orc"] = "兽人";
L["Dwarf"] = "矮人";
L["NightElf"] = "暗夜精灵";
L["Scourge"] = "亡灵";
L["Tauren"] = "牛头人";
L["Gnome"] = "侏儒";
L["Troll"] = "巨魔";
L["Goblin"] = "地精";
L["BloodElf"] = "血精灵";
L["Draenei"] = "德莱尼";
L["Worgen"] = "狼人";
L["Pandaren"] = "熊猫人";
L["Nightborne"] = "夜之子";
L["HighmountainTauren"] = "至高岭牛头人";
L["VoidElf"] = "虚空精灵";
L["LightforgedDraenei"] = "光铸德莱尼";
L["ZandalariTroll"] = "赞达拉巨魔";
L["KulTiran"] = "库尔提拉斯人";
L["DarkIronDwarf"] = "黑铁矮人";
L["MagharOrc"] = "玛格汉兽人";
L["Mechagnome"] = "机械侏儒";
L["Vulpera"] = "狐人";
-- Race end
