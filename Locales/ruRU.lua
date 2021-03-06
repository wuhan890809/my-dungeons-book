local L = LibStub("AceLocale-3.0"):NewLocale("MyDungeonsBook", "ruRU");
if not L then return end

-- UI start
L["My Dungeons Book"] = true;
L["Filters"] = "Фильтры";
L["%s died"] = "%s погибает";
L["%s got hit by %s for %s (%s)"] = "%s получил урон от %s на %s (%s)";
L["%s got debuff by %s"] = "%s получил дебаф %s";
L["%s interrupted %s %s using %s"] = "%s прервал %s %s с помощью %s";
L["%s +%s is completed"] = "%s +%s пройдено";
L["%s +%s is reset"] = "%s +%s сброшено";
L["%s +%s is started"] = "%s +%s начато";
L["%s %s's cast %s is passed"] = "%s %s успешно завершил чтение способности %s";
L["Close"] = "Закрыть";
L["Date"] = "Дата";
L["Time"] = "Время";
L["Version"] = "Версия";
L["Dungeon"] = "Подземелье";
L["Key"] = "Ключ";
L["Affixes"] = "Аффиксы";
L["Not Found"] = "Не найдено";
L["Yes"] = "Да";
L["No"] = "Нет";
L["Reset"] = "Сбросить";
L["Deaths"] = "Смерти";
L["Fortified"] = "Укрепленный";
L["Tyrannical"] = "Тиранический";
L["In Time"] = "Во время";
L["Not In Time"] = "Не во время";
L["All"] = "Все";
L["Race: %s"] = "Раса: %s";
L["Hits"] = "Удары";
L["Spell"] = "Способность";
L["Spells"] = "Способности";
L["DEV"] = "DEV";
L["Dev"] = "Dev";
L["Mechanics"] = "Механики";
L["Interrupts"] = "Прерывания";
L["Encounters"] = "Боссы";
L["Details"] = "Подробности";
L["Avoidable Debuffs"] = "Избегаемые дебафы";
L["Avoidable Damage"] = "Избегаемый урон";
L["Roster"] = "Ростер";
L["ID"] = "ID";
L["HPS"] = "ЛВС";
L["Heal"] = "Лечение";
L["DPS"] = "УВС";
L["Damage"] = "Урон";
L["Player"] = "Игрок";
L["Sum"] = "Сумма";
L["Num"] = "Кол-во";
L["Kicks"] = "Прерывания";
L["Passed"] = "Не сбито";
L["Kicked"] = "Сбито";
L["After"] = "После";
L["While"] = "В течение";
L["Before"] = "До";
L["Duration"] = "Продолжительность";
L["End Time"]= "Конец";
L["Start Time"]= "Начало";
L["Name"] = "Имя";
L["Over"] = "Сверх";
L["Amount"] = "Кол-во";
L["Damage Done To Units"] = "Урон по врагам";
L["Friendly Fire"] = "Урон по своим";
L["Special Casts"] = "Особые способности"
L["Own Casts"] = "Свои способности";
L["Buffs Or Debuffs On Units"] = "Бафы и дебафы на врагах";
L["Special Buffs Or Debuffs"] = "Особые эффекты";
L["Casts"] = "Способности";
L["Casted"] = "Произнесено";
L["NPC"] = "НИП";
L["Count"] = "Кол-во";
L["%s (%s) %s"] = "%s (%s) %s";
L["Time lost: %ss"] = "Времени потеряно: %sc";
L["Time: %s / %s (%s%s) %.1f%%"] = "Время: %s / %s (%s%s) %.1f%%";
L["Key HP bonus: %s%%"] = "Бонус к здоровью от ключа: %s%%";
L["Key damage bonus: %s%%"] = "Бонус к урону от ключа: %s%%";
L["Dungeon: %s (+%s)"] = "Подземелье: %s (+%s)";
L["Used Items"] = "Расходуемые предметы";
L["Item"] = "Предмет";
L["%s dispelled %s %s using %s"] = "%s рассеял %s %s используя %s";
L["Effects and Auras"] = "Эффекты и ауры";
L["All Buffs"] = "Все бафы";
L["All Debuffs"] = "Все дебафы";
L["Time"] = "Время";
L["Target?"] = "Цель?";
L["Swing Damage"] = "Урон с руки";
L["Result"] = "Результат";
L["All damage taken"] = "Весь полученный урон";
L["All damage done"] = "Весь нанесенный урон";
L["Dispels"] = "Рассеивания";
L["Are you sure you want to delete info about challenge?"] = "Вы точно хотите удалить информацию о данном прохождении?";
L["Challenge #%s is deleted successfully"] = "Прохождение #%s успешно удалено";
L["Min Not Crit"] = "Мин не крит";
L["Hits Not Crit"] = "Удары не крит";
L["Max Not Crit"] = "Макс не крит";
L["Min Crit"] = "Мин крит";
L["Max Crit"] = "Макс крит";
L["Crit, %"] = "Крит, %";
L["Hits Crit"] = "Удары крит";
L["Show All Casts"] = "Показать все способности";
L["By Spell"] = "По способностям";
L["To Each Party Member"] = "По игрокам";
L["Quaked"] = "Сотрясающий";
L["%"] = "%";
L["Summary"] = "Сводка";
L["Not all spells have usage timestamps"] = "Не у всех способностей есть временные метки их применения";
L["All Buffs & Debuffs"] = "Все бафы и дебафы";
L["Uptime, %"] = "Uptime, %";
L["Max Stacks"] = "Макс зарядов";
L["Type"] = "Тип";
L["Avoidable"] = "Избегаемый";
L["Talents"] = "Таланты";
L["Covenant"] = "Ковенант";
L["Equipment"] = "Экипировка";
L["Info"] = "Инфо";
L["Covenant info is available only about players with installed MyDungeonsBook."] = "Covenant info is available only about players with installed MyDungeonsBook.";
L["WowHead"] = "WowHead";
L["WowHead Link for %s"] = "WowHead ссылка для %s";
L["Report"] = "Отчет";
L["To Self"] = "Отправить себе";
L["To Target"] = "Отправить цели";
L["To Group/Raid"] = "Отправить в группу/рейд";
L["MyDungeonsBook %s Usage:"] = "MyDungeonsBook Использование %s:";
L["MyDungeonsBook %s Interrupted:"] = "MyDungeonsBook Прервано %s:";
L["MyDungeonsBook %s Casts:"] = "MyDungeonsBook Прочитано %s:";
L["MyDungeonsBook Damage taken by party from %s:"] = "MyDungeonsBook Урон по группе от %s:";
L["MyDungeonsBook Heal done by %s with %s:"] = "MyDungeonsBook Лечение от %s с помощью %s:";
L["MyDungeonsBook Damage done by party to %s:"] = "MyDungeonsBook Урон группы по %s:";
L["MyDungeonsBook %s Dispelled:"] = "MyDungeonsBook Рассеяно %s:";
L["MyDungeonsBook Debuff %s hits:"] = "MyDungeonsBook Дебаф %s:";
L["MyDungeonsBook Heal stats by %s with %s:"] = "MyDungeonsBook Лечение от %s с помощью %s:";
L["MyDungeonsBook Damage stats by %s with %s:"] = "MyDungeonsBook Урон от %s с помощью %s:";
L["Amount - %s (%s%%), over - %s, crit - %s%%, max - %s (%s)"] = "Кол-во - %s (%s%%), сверх - %s, крит - %s%%, макс - %s (%s)";
L["Combat Time"] = "Время в бою";
L["Scale"] = "Масштаб";
L["Window scale"] = "Масштаб окна";
L["Timeline"] = "Время";
L["Overall Idle Time - %s"] = "Всего времени вне боя - %s";
L["Delete"] = "Удалить";
L["MyDungeonsBook Challenge summary for %s:"] = "MyDungeonsBook Отчет по %s:";
L["Units"] = "Единицы";
L["Combat Start"] = "Бой начат";
L["Combat End"] = "Бой закончен";
L["Combat Duration"] = "Время боя";
L["MyDungeonsBook Encounter %s (%s) for %s (%s) at %s:"] = "MyDungeonsBook Босс %s (%s) в %s (%s) %s:";
L["Casters"] = "Кастеры";
L["Secondary stats"] = "Вторичные навыки";
L["Critical Strike"] = "Критический удар";
L["Haste"] = "Скорость";
L["Mastery"] = "Искусность";
L["Versatility"] = "Универсальность";
L["Event"] = "Событие";
L["Source"] = "Источник";
L["HP"] = "Здоровье";
L["Enemy Forces"] = "Войска противника";
L["This week"] = "Эта неделя";
L["Progress"] = "Прогресс";
L["Target"] = "Цель";
L["Broken Auras"] = "Сбитые эффекты";
L["Broken By"] = "Сбито";
L["%s broke %s on %s using %s"] = "%s сбил %s с %s используя %s";
L["Not tanking anything"] = "Никого не танкует";
L["Not tanking anything, but have higher threat than tank on at least one unit"] = "Никого не танкует, но уровень угрозы выше чем у танка как минимум на одной вражеской единице";
L["Insecurely tanking at least one unit, but not securely tanking anything"] = "Небезопасно танкует как минимум одну вражескую единицу, но уверенно не танкует никого";
L["Securely tanking at least one unit"] = "Уверенно танкует как минимум одну вражескую единицу";
L["Enemies Friendly Fire"] = "Урон врагов по своим";
L["%s got %s damage from %s with %s"] = "%s получил %s урона от %s из-за %s";
L["Misc"] = "Разное";
L["Anima Powers"] = "Способности анимы";
-- UI end

-- Help start
L["alias for previous word"] = "псевдоним для предыдущего слова";
L["update info about party member for current challenge. unitId must be 'player' or 'party1..4'."] = "обновить данные по игроку в текущем прохождении. unitId должен быть 'player' или 'party1..4'.";
L["print this text."] = "выводит это сообщение.";
L["send some message via comm to other MDB user. unitId must be 'party1..4'."] = "отправить сообщение другому игроку в группе, который тоже использует MDB. unitId должен быть 'party1..4'.";
-- Help end

-- Settings start
L["Performance"] = "Производительность";
L["Run garbage collector on close"] = "Выполнять сборку мусора при закрытии MDB";
L["Show DEV Tab"] = "Выводить DEV-вкладку";
L["Verbose"] = "Verbose";
L["Show DEBUG messages"] = "Выводить DEBUG-сообщения";
L["Show LOG messages"] = "Выводить LOG-сообщения";
L["UI"] = "UI";
L["Date Format"] = "Формат даты";
L["Time Format"] = "Формат времени";
L["Icons"] = "Иконки";
L["Flatten Icons"] = "Плоские иконки";
L["Date and Time"] = "Дата и время";
L["Logging Levels"] = "Уровни логирования";
L["Logs"] = "Логи";
L["Show LOG messages about avoidable DEBUFFS"] = "Выводить LOG-сообщения про избегаемые ДЕБАФЫ";
L["Show LOG messages about avoidable DAMAGE taken"] = "Выводить LOG-сообщения про полученный избегаемый УРОН";
L["Show LOG messages about INTERRUPTS"] = "Выводить LOG-сообщения про ПРЕРЫВАНИЯ";
L["Show LOG messages about DISPELS"] = "Выводить LOG-сообщения про DISPELS";
L["Show LOG messages about DEATHS"] = "Выводить LOG-сообщения про СМЕРТИ";
L["Show LOG messages about NOT INTERRUPTED casts"] = "Выводить LOG-сообщения про НЕ ПРЕРВАННЫЕ способности";
L["Options below are global. However they are overridden by LOG-option above. E.g. when \"Show LOG messages\" is disabled, no log messages will be printed independently of settings below."] = "Опции ниже являются глобальными. Однако, они зависят от LOG-опции выше. Другими словами, если \"Выводить LOG-сообщения\" выключено, то никакие LOG-сообщения выводиться не будут, независимо от значений опций ниже.";
L["There is a list of internal trackers. Their info is not used directly on the UI and is useful only for devs. No sense to enable it."] = "There is a list of internal trackers. Their info is not used directly on the UI and is useful only for devs. No sense to enable it.";
L["Aura"] = "Аура";
L["MyDungeonsBook %s %s for %s"] = "MyDungeonsBook %s %s на %s";
L["GUID"] = "GUID";
L["Death Time"] = "Время смерти";
L["Release Time"] = "Время воскрешения";
L["Time dead"] = "Время мертвым";
L["%s (start)"] = "%s (начало)";
L["%s (end)"] = "%s (конец)";
L["Death logs"] = "Логи смертей";
L["Time before death to track"] = "Сколько записывать времени перед смертью";
L["Compress saved data after challenge is completed"] = "Ужимать сохраненные после прохождения данные";
L["May cause small lag on challenge end"] = "Может вызывать небольшой пролаг по завершению прохождения";
-- Settings end

-- Regex start (thanks to Exorsus Raid Tools)
L["%+(%d+) Haste"] = "%+(%d+)%s+к скорости%s*$";
L["%+(%d+) Haste (Gem)"] = "НЕ НУЖЕН";
L["%+(%d+) Mastery"] = "%+(%d+) к искусности";
L["%+(%d+) Mastery (Gem)"] = "НЕ НУЖЕН";
L["%+(%d+) Critical Strike"] = "%+(%d+) к критическому удару";
L["%+(%d+) Critical Strike (Gem)"] = "%+(%d+) к вероятности критического удара";
L["%+(%d+) Versatility"] = "%+(%d+) к универсальности";
L["%+(%d+) Versatility (Gem)"] = "НЕ НУЖЕН";
-- Regex end

-- BfA start
-- NPCs start
L["Explosives"] = "Explosives";
L["Blood Tick"] = "Blood Tick";
L["Inconspicuous Plant"] = "Inconspicuous Plant";
L["Earthrager"] = "Earthrager";
L["Animated Gold"] = "Animated Gold";
L["Reban"] = "Reban";
L["T'zala"] = "T'zala";
L["Reanimated Raptor"] = "Reanimated Raptor";
L["Wasting Servant"] = "Wasting Servant";
L["Soul Thorns"] = "Soul Thorns";
L["Blood Visage"] = "Blood Visage";
L["Blood Effigy"] = "Blood Effigy";
L["A Knot of Snakes"] = "A Knot of Snakes";
L["Buzzing Drone"] = "Buzzing Drone";
L["Gripping Terror"] = "Gripping Terror";
L["Hull Cracker"] = "Hull Cracker";
L["Ashvane Cannoneer"] = "Ashvane Cannoneer";
L["Venture Co. Skyscorcher"] = "Venture Co. Skyscorcher";
L["Deathtouched Slaver"] = "Deathtouched Slaver";
L["Mindrend Tentacle"] = "Mindrend Tentacle";
-- NPCs end
-- BfA end

-- SL start
-- NPCs start
-- NPCs end
-- SL end

-- Race start
L["Human"] = "Человек";
L["Orc"] = "Орк";
L["Dwarf"] = "Дворф";
L["NightElf"] = "Ночной эльф";
L["Scourge"] = "Нежить";
L["Tauren"] = "Таурен";
L["Gnome"] = "Гном";
L["Troll"] = "Тролль";
L["Goblin"] = "Гоблин";
L["BloodElf"] = "Кровавый эльф";
L["Draenei"] = "Дреней";
L["Worgen"] = "Ворген";
L["Pandaren"] = "Пандарен";
L["Nightborne"] = "Ночнорожденный";
L["HighmountainTauren"] = "Таурен Крутогорья";
L["VoidElf"] = "Эльф Бездны";
L["LightforgedDraenei"] = "Озаренный дреней";
L["ZandalariTroll"] = "Зандаларский тролль";
L["KulTiran"] = "Култирасец";
L["DarkIronDwarf"] = "Дворф Черного Железа";
L["MagharOrc"] = "Маг'хар";
L["Mechagnome"] = "Механогном";
L["Vulpera"] = "Вульпера";
-- Race end
