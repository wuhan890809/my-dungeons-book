### v2.0.0

* [#43](https://github.com/onechiporenko/my-dungeons-book/issues/43) Add spells to interrupt for Necrotic Wake
* [#44](https://github.com/onechiporenko/my-dungeons-book/issues/44) Add spells to interrupt for Plaguefall
* [#45](https://github.com/onechiporenko/my-dungeons-book/issues/45) Add spells to interrupt for De Other Side
* [#46](https://github.com/onechiporenko/my-dungeons-book/issues/46) Add spells to interrupt for Halls of Atonement
* [#47](https://github.com/onechiporenko/my-dungeons-book/issues/47) Add spells to interrupt for Spires of Ascension
* [#48](https://github.com/onechiporenko/my-dungeons-book/issues/48) Add spells to interrupt for Theater of Pain
* [#49](https://github.com/onechiporenko/my-dungeons-book/issues/49) Add spells to interrupt for Mists of Tirna Scithe
* [#50](https://github.com/onechiporenko/my-dungeons-book/issues/50) Add spells to interrupt for Sanguine Depths
* [#28](https://github.com/onechiporenko/my-dungeons-book/issues/28) Add avoidable spells and debuffs for Plaguefall
* [#94](https://github.com/onechiporenko/my-dungeons-book/issues/94) Add units to track taken damage for Plaguefall
* [#92](https://github.com/onechiporenko/my-dungeons-book/issues/92) Track main covenant's abilities
* Version `9.0.2` is for SL now
* [#91](https://github.com/onechiporenko/my-dungeons-book/issues/91) Update format for buffs and debuffs stored for party members and units

### v1.9.0

* [#21](https://github.com/onechiporenko/my-dungeons-book/issues/21) Separate all buffs and all debuffs for each player and show their duration
* [#90](https://github.com/onechiporenko/my-dungeons-book/issues/90) Add version `9.0.2` to BfA
* Add more spells to track like party member's own casts
* [#89](https://github.com/onechiporenko/my-dungeons-book/issues/89) Improve pet's owner tracking

### v1.8.1

* [#88](https://github.com/onechiporenko/my-dungeons-book/issues/88) Routing on Summary table is broken

### v1.8.0

* [#87](https://github.com/onechiporenko/my-dungeons-book/issues/87) Use `PARTY-MEMBERS-SUMMON` to check pets and summoned units in the all trackers
* [#86](https://github.com/onechiporenko/my-dungeons-book/issues/86) Add percentage columns for Summary Table
* [#85](https://github.com/onechiporenko/my-dungeons-book/issues/85) Make Summary table interactable
* [#84](https://github.com/onechiporenko/my-dungeons-book/issues/84) Add spell filter for own casts timeline
* [#16](https://github.com/onechiporenko/my-dungeons-book/issues/16) Reformat "Details"-tab to "Summary"-tab
* [#82](https://github.com/onechiporenko/my-dungeons-book/issues/82) MDB window should be closable via ESC pressing
* [#83](https://github.com/onechiporenko/my-dungeons-book/issues/83) Add percentage column for tables "Heal by Spell" and "All Damage Done"

### v1.7.0

* [#78](https://github.com/onechiporenko/my-dungeons-book/issues/78) Row with currently viewed challenge should be highlighted
* [#81](https://github.com/onechiporenko/my-dungeons-book/issues/81) Show interrupts done by Quaking affix
* [#80](https://github.com/onechiporenko/my-dungeons-book/issues/80) Deaths count is not set when challenge is abandoned
* [#79](https://github.com/onechiporenko/my-dungeons-book/issues/79) Add extra settings for verbose options for mechanics

### v1.6.0

* [#77](https://github.com/onechiporenko/my-dungeons-book/issues/77) Don't track heal done to enemy units
* [#76](https://github.com/onechiporenko/my-dungeons-book/issues/76) Shield/offhand item sometimes is shifted to the second row
* [#74](https://github.com/onechiporenko/my-dungeons-book/issues/74) Reset viewed challenge info when MDB is closed
* [#73](https://github.com/onechiporenko/my-dungeons-book/issues/73) Show heal done by each spell
* [#64](https://github.com/onechiporenko/my-dungeons-book/issues/64) Don't store challenges info uncompressed

### v1.5.0

* [#72](https://github.com/onechiporenko/my-dungeons-book/issues/72) Add missing AceHook lib to embeds.xml
* [#71](https://github.com/onechiporenko/my-dungeons-book/issues/71) Duration for 60+ minutes is shown incorrectly

### v1.4.0

* [#63](https://github.com/onechiporenko/my-dungeons-book/issues/63) Track pets damage and show it on the UI
* [#69](https://github.com/onechiporenko/my-dungeons-book/issues/69) Add toggle to show counts for all casts
* [#68](https://github.com/onechiporenko/my-dungeons-book/issues/68) Don't save "0" for party member spec 
* [#67](https://github.com/onechiporenko/my-dungeons-book/issues/67) "infM" is shown when there are no crits 
* [#66](https://github.com/onechiporenko/my-dungeons-book/issues/66) Don't track **-MISSED for party damage

### v1.3.0

* [#15](https://github.com/onechiporenko/my-dungeons-book/issues/15) Track all damage done by party members
* [#7](https://github.com/onechiporenko/my-dungeons-book/issues/7) Add trackable own casts ("OwnCastsDoneByPartyMembers") for party members
* [#26](https://github.com/onechiporenko/my-dungeons-book/issues/26) Add icons for the new affixes

### v1.2.1

* Fix path for external libs

### v1.2.0

* [#25](https://github.com/onechiporenko/my-dungeons-book/issues/25) Use `externals` and don't publish "public" libs
* Force to update players info on challenge start
* [#24](https://github.com/onechiporenko/my-dungeons-book/issues/24) Show each party member's race
* [#23](https://github.com/onechiporenko/my-dungeons-book/issues/23) Add filters for challenges table
* [#22](https://github.com/onechiporenko/my-dungeons-book/issues/22) Add date for challenge details title
* [#2](https://github.com/onechiporenko/my-dungeons-book/issues/2) Add custom changelog and not use git commits
* [#1](https://github.com/onechiporenko/my-dungeons-book/issues/1) Allow to delete challenges
* Make Debug-messages disabled by default

### v1.1.0

* Add Race Specific spells to be tracked via "OWN-CASTS-DONE-BY-PARTY-MEMBERS"
* 1st stage of heal tracking done by party members
* Fix pet tracking via tooltip
* Fix Solar Beam tracking
* Track party member casts and not npcs
* Add missing L-entries for help-messages
* Fix label for "Time Format" option
* Add options for date and time formats. Add option for icons format (flatten or not)
