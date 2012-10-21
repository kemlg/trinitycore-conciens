-- TrinityCore\sql\updates\world\2012_07_12_00_world_version.sql 
UPDATE `version` SET `db_version`='TDB 335.11.48', `cache_id`=48 LIMIT 1;
 
-- TrinityCore\sql\updates\world\2012_07_13_00_world_spell_proc_event.sql 
UPDATE `spell_proc_event` SET `procFlags` = 16384 WHERE `entry` in (48492,48494,48495);
 
-- TrinityCore\sql\updates\world\2012_07_13_00_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE (`spell_id`='-5570');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(-5570, 'spell_dru_insect_swarm');
 
-- TrinityCore\sql\updates\world\2012_07_14_00_world_creature_loot_template.sql 
-- Gorilla Fang should always be able to drop (Exodius)
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = ABS(`ChanceOrQuestChance`) WHERE `item`=2799;
-- Update "Count" Ungula's Mandible drop rate does not require quest to drop it starts one (gecko32)
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = ABS(`ChanceOrQuestChance`) WHERE `item`=25459;
-- Tainted Hellboar Meat fix (ZxBiohazardZx)
UPDATE `quest_template` SET `RequiredSourceItemId1`=23270,`RequiredSourceItemCount1`=8 WHERE `Id`=9361;
 
-- TrinityCore\sql\updates\world\2012_07_14_01_world_creature_loot_template.sql 
-- Hellboar shit always drops
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`= -100 WHERE `item`=23270;

-- update Al'ar loot
SET @gear := 34053; 
SET @talon := 34377; 
SET @Alar := 19514;

DELETE FROM `creature_loot_template` WHERE `entry`=@Alar;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(@Alar,29434,100,1,0,2,2), -- Badge of Justice 2x
(@Alar,1,100,1,0,-@gear,3), -- 3x Gear Reference
(@Alar,2,10,1,0,-34052,1), -- Pattern Reference
(@Alar,3,2,1,0,-34052,1); -- extra Pattern Reference (small chance)

DELETE FROM `reference_loot_template` WHERE `entry` IN (@gear,@talon);
INSERT INTO `reference_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
-- Gear Reference:
(@gear,29918,0,1,1,1,1), -- Mindstorm Wristbands
(@gear,29920,0,1,1,1,1), -- Phoenix-Ring of Rebirth
(@gear,29921,0,1,1,1,1), -- Fire Crest Breastplate
(@gear,29922,0,1,1,1,1), -- Band of Al'ar
(@gear,29923,0,1,1,1,1), -- Talisman of the Sun King
(@gear,29924,0,1,1,1,1), -- Netherbane
(@gear,29925,0,1,1,1,1), -- Phoenix-Wing Cloak
(@gear,29947,0,1,1,1,1), -- Gloves of the Searing Grip
(@gear,29948,0,1,1,1,1), -- Claw of the Phoenix
(@gear,29949,0,1,1,1,1), -- Arcanite Steam-Pistol
(@gear,30447,0,1,1,1,1), -- Tome of Fiery Redemption
(@gear,1,0,1,1,-@talon,1), -- Talonoption
-- either of the claws is selected
(@talon,30448,0,1,1,1,1), -- Talon of Al'ar
(@talon,32944,0,1,1,1,1); -- Talon of the Phoenix
 
-- TrinityCore\sql\updates\world\2012_07_16_00_world_creature_template.sql 
-- Fix the damage for Wretched mobs in Magisters' Terrace
UPDATE `creature_template` SET `dmg_multiplier`=0.6 WHERE `entry` IN (24688, 24689, 24690);
 
-- TrinityCore\sql\updates\world\2012_07_16_01_world_reference_loot_template.sql 
-- manually set the reference% for core doesnt understand how to deal with grouped references (lame)
UPDATE `reference_loot_template` SET `ChanceOrQuestChance`=8.33333333 WHERE `entry`=34053 AND `item`=1;
 
-- TrinityCore\sql\updates\world\2012_07_22_00_world_spelldifficulty_dbc.sql 
UPDATE `spelldifficulty_dbc` SET `spellid0`= 61890 WHERE `id`= 3251 AND `spellid1`= 63498;
 
-- TrinityCore\sql\updates\world\2012_07_22_01_world_conditions.sql 
-- Saronite Mine Slave conditions
SET @QUEST_A := 13300;
SET @QUEST_H := 13302;
SET @GOSSIP  := 10137;

-- Only show gossip if player is on quest Slaves to Saronite
DELETE FROM `conditions` WHERE `SourceGroup`=@GOSSIP AND `ConditionValue1` IN (@QUEST_A,@QUEST_H);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15,@GOSSIP,0,0,0,9,0,@QUEST_A,0,0,0,0,'',"Only show first gossip if player is on quest Slaves to Saronite Alliance"),
(15,@GOSSIP,0,0,1,9,0,@QUEST_H,0,0,0,0,'',"Only show first gossip if player is on quest Slaves to Saronite Horde");
 
-- TrinityCore\sql\updates\world\2012_07_22_02_world_creature_loot_template.sql 
-- Item was added to the wrong NPC
-- Source: http://old.wowhead.com/item=19364
DELETE FROM `creature_loot_template` WHERE `entry` IN (1853, 11583) AND `item`=19364;
INSERT INTO `creature_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `lootmode`, `groupid`, `mincountOrRef`, `maxcount`) VALUES
(11583, 19364, 10, 1, 0, 1, 1);
 
-- TrinityCore\sql\updates\world\2012_07_22_03_world_gossip.sql 
-- Keristrasza (26206)
UPDATE `creature_template` SET `gossip_menu_id` = 9262 WHERE `entry` = 26206;

DELETE FROM `gossip_menu` WHERE `entry`=9262 AND `text_id`=12576;
INSERT INTO `gossip_menu` (`entry`, `text_id`) VALUES (9262, 12576);

-- from sniff
DELETE FROM `gossip_menu_option` WHERE `menu_id`=9262 AND `id`=0;
DELETE FROM `gossip_menu_option` WHERE `menu_id`=9262 AND `id`=1;
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES
(9262, 0, 0, 'I am prepared to face Saragosa!', 1, 3, 0, 0, 0, 0, NULL),
(9262, 1, 0, 'Keristrasa, I am finished here. Please return me to the Transitus Shield.', 1, 3, 0, 0, 0, 0, NULL);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9262 AND `SourceEntry`=0;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9262 AND `SourceEntry`=1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 9262, 0, 0, 0, 9, 0, 11957, 0, 0, 0, 0, '', "Only show gossip if player has quest Saragosa's End"),
(15, 9262, 1, 0, 0, 9, 0, 11967, 0, 0, 0, 0, '', "Only show gossip if player has quest Mustering the Reds");
 
-- TrinityCore\sql\updates\world\2012_07_22_04_world_gossip.sql 
-- NPC Cowlen - Missing Gossip Options
SET @NPC := 17311;
DELETE FROM `creature_addon` WHERE `guid`=84415;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(84415,0,0,1,0,0,NULL);
UPDATE `creature_template` SET `gossip_menu_id`=7403, `AIName`='SmartAI' WHERE `entry`=@NPC;
DELETE FROM `gossip_menu` WHERE `entry` IN (7403,7402,7401);
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7403,8870),
(7402,8871),
(7401,8872);
DELETE FROM `gossip_menu_option` WHERE `menu_id` IN (7403,7402,7401) AND `id`=0;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`box_coded`,`box_money`,`box_text`) VALUES
(7403,0,0, 'I have not come to kill you, night elf. And the gods did not do this...',1,1,7402,0,0,0, ''),
(7402,0,0, 'I fear that my people are somewhat responsible for this destruction. We are refugees, displaced from our homes by the Burning Legion. This tragedy is a result of our latest evacuation. Our vessel crashed - this debris is a part of that vessel.',1,1,7401,0,0,0, ''),
(7401,0,0, 'We have much in common, night elf. I can''t help but feel that perhaps it was fate that brought us together. Let me help you, Cowlen. Let my people help. We will right the wrongs. This I vow.',1,1,0,0,0,0, '');
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC AND `source_type`=0 AND `id` IN (0,1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC,0,0,1,62,0,100,0,7401,0,0,0,5,18,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Cowlen - On gossip option play emote'),
(@NPC,0,1,0,61,0,100,0,7401,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Cowlen - On gossip option Close Gossip');
 
-- TrinityCore\sql\updates\world\2012_07_22_05_world_script_texts.sql 
-- Fixing wrong text in Trial of the Crusader, Twin Valkyrs
UPDATE `script_texts` SET `content_default`='%s begins to read the spell Twin''s Pact!' WHERE `entry`=-1649043;
 
-- TrinityCore\sql\updates\world\2012_07_22_06_world_gossip.sql 
-- gossip assignation from sniff
UPDATE `creature_template` SET `gossip_menu_id`=4182 WHERE `entry`=1466; -- Gretta Finespindle <Apprentice Leatherworker>
UPDATE `creature_template` SET `gossip_menu_id`=201 WHERE `entry`=3678; -- Muyoh <Disciple of Naralex>
UPDATE `creature_template` SET `gossip_menu_id`=7406 WHERE `entry`=3848; -- Kayneth Stillwind
UPDATE `creature_template` SET `gossip_menu_id`=8851 WHERE `entry`=4979; -- Theramore Guard
UPDATE `creature_template` SET `gossip_menu_id`=4862 WHERE `entry`=6771; -- Ravenholdt Assassin <Assassin's League>
UPDATE `creature_template` SET `gossip_menu_id`=3130 WHERE `entry`=10618; -- Rivern Frostwind <Wintersaber Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=3441 WHERE `entry`=10857; -- Argent Quartermaster Lightspark <The Argent Crusade>
UPDATE `creature_template` SET `gossip_menu_id`=3074 WHERE `entry`=10922; -- Greta Mosshoof <Emerald Circle>
UPDATE `creature_template` SET `gossip_menu_id`=3128 WHERE `entry`=11019; -- Jessir Moonbow
UPDATE `creature_template` SET `gossip_menu_id`=3622 WHERE `entry`=11554; -- Grazle
UPDATE `creature_template` SET `gossip_menu_id`=3602 WHERE `entry`=11609; -- Alexia Ironknife
UPDATE `creature_template` SET `gossip_menu_id`=3963 WHERE `entry`=11626; -- Rigger Gizelton
UPDATE `creature_template` SET `gossip_menu_id`=4003 WHERE `entry`=12245; -- Vendor-Tron 1000
UPDATE `creature_template` SET `gossip_menu_id`=4002 WHERE `entry`=12246; -- Super-Seller 680
UPDATE `creature_template` SET `gossip_menu_id`=4922 WHERE `entry`=13085; -- Myrokos Silentform
UPDATE `creature_template` SET `gossip_menu_id`=6531 WHERE `entry`=15182; -- Vish Kozus <Captain of the Guard>
UPDATE `creature_template` SET `gossip_menu_id`=7326 WHERE `entry`=16817; -- Festival Loremaster
UPDATE `creature_template` SET `gossip_menu_id`=7405 WHERE `entry`=17287; -- Sentinel Luciel Starwhisper <Silverwing Sentinels>
UPDATE `creature_template` SET `gossip_menu_id`=7404 WHERE `entry`=17291; -- Architect Nemos
UPDATE `creature_template` SET `gossip_menu_id`=7407 WHERE `entry`=17303; -- Vindicator Vedaar <Hand of Argus>
UPDATE `creature_template` SET `gossip_menu_id`=8080 WHERE `entry`=17310; -- Gnarl <Ancient of War>
UPDATE `creature_template` SET `gossip_menu_id`=7382 WHERE `entry`=17406; -- Artificer
UPDATE `creature_template` SET `gossip_menu_id`=7735 WHERE `entry`=18538; -- Ishanah <High Priestess of the Aldor>
UPDATE `creature_template` SET `gossip_menu_id`=7734 WHERE `entry`=18596; -- Arcanist Adyria <The Scryers>
UPDATE `creature_template` SET `gossip_menu_id`=7747 WHERE `entry`=18653; -- Seth
UPDATE `creature_template` SET `gossip_menu_id`=10459 WHERE `entry`=33746; -- Silvermoon Champion
UPDATE `creature_template` SET `gossip_menu_id`=10461 WHERE `entry`=33748; -- Thunder Bluff Champion
UPDATE `creature_template` SET `gossip_menu_id`=10462 WHERE `entry`=33749; -- Undercity Champion

-- gossip from sniff
DELETE FROM `gossip_menu` WHERE (`entry`=201 AND `text_id`=698) OR (`entry`=3074 AND `text_id`=3807) OR (`entry`=3128 AND `text_id`=3864) OR (`entry`=3130 AND `text_id`=3854) OR (`entry`=3441 AND `text_id`=4193) OR (`entry`=3602 AND `text_id`=4354) OR (`entry`=3621 AND `text_id`=4394) OR (`entry`=3622 AND `text_id`=4393) OR (`entry`=3961 AND `text_id`=4813) OR (`entry`=3963 AND `text_id`=4815) OR (`entry`=4002 AND `text_id`=4856) OR (`entry`=4003 AND `text_id`=4857) OR (`entry`=4182 AND `text_id`=5276) OR (`entry`=4862 AND `text_id`=5938) OR (`entry`=4922 AND `text_id`=5981) OR (`entry`=6531 AND `text_id`=7733) OR (`entry`=6588 AND `text_id`=7801) OR (`entry`=6587 AND `text_id`=7802) OR (`entry`=6586 AND `text_id`=7803) OR (`entry`=6585 AND `text_id`=7804) OR (`entry`=7326 AND `text_id`=8703) OR (`entry`=7382 AND `text_id`=8838) OR (`entry`=7404 AND `text_id`=8873) OR (`entry`=7405 AND `text_id`=8874) OR (`entry`=7406 AND `text_id`=8875) OR (`entry`=7407 AND `text_id`=8876) OR (`entry`=7735 AND `text_id`=9457) OR (`entry`=7734 AND `text_id`=9452) OR (`entry`=7747 AND `text_id`=9486) OR (`entry`=8080 AND `text_id`=9986) OR (`entry`=8464 AND `text_id`=10573) OR (`entry`=8851 AND `text_id`=11492) OR (`entry`=10933 AND `text_id`=15194);
INSERT INTO `gossip_menu` (`entry`, `text_id`) VALUES
(201, 698), -- 3678
(3074, 3807), -- 10922
(3128, 3864), -- 11019
(3130, 3854), -- 10618
(3441, 4193), -- 10857
(3602, 4354), -- 11609
(3621, 4394), -- 11554
(3622, 4393), -- 11554
(3961, 4813), -- 11625
(3963, 4815), -- 11626
(4002, 4856), -- 12246
(4003, 4857), -- 12245
(4182, 5276), -- 1466
(4862, 5938), -- 6771
(4922, 5981), -- 13085
(6531, 7733), -- 15182
(6588, 7801), -- 15169
(6587, 7802), -- 15169
(6586, 7803), -- 15169
(6585, 7804), -- 15169
(7326, 8703), -- 16817
(7382, 8838), -- 17406
(7404, 8873), -- 17291
(7405, 8874), -- 17287
(7406, 8875), -- 3848
(7407, 8876), -- 17303
(7735, 9457), -- 18538
(7734, 9452), -- 18596
(7747, 9486), -- 18653
(8080, 9986), -- 17310
(8464, 10573), -- 185126
(8851, 11492), -- 4979
(10933, 15194); -- 37200

-- correct npc_flags for npc from sniff
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=8151; -- Nijel's Point Guard
UPDATE `creature_template` SET `npcflag`=2 WHERE `entry`=24393; -- The Rokk <Master of Cooking>
UPDATE `creature_template` SET `npcflag`=1 WHERE `entry`=37119; -- Highlord Tirion Fordring

-- missing gossip from sniff
DELETE FROM `gossip_menu_option` WHERE (`menu_id`=3622 AND `id`=0) OR (`menu_id`=4002 AND `id`=0) OR (`menu_id`=4003 AND `id`=0) OR (`menu_id`=6586 AND `id`=0) OR (`menu_id`=6587 AND `id`=0) OR (`menu_id`=6588 AND `id`=0) OR (`menu_id`=10456 AND `id`=0) OR (`menu_id`=10457 AND `id`=0) OR (`menu_id`=10461 AND `id`=0) OR (`menu_id`=10462 AND `id`=0);
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES
(3622, 0, 0, 'How can I prove myself to the Timbermaw furbolg?', 1, 3, 3621, 0, 0, 0, ''), -- 11554
(4002, 0, 1, 'Let me take a look at what you have to offer.', 3, 387, 0, 0, 0, 0, ''), -- 12246
(4003, 0, 1, 'I am curious to see what a bucket of bolts has to offer.', 3, 131, 0, 0, 0, 0, ''), -- 12245
(6586, 0, 0, 'And what do you say?', 1, 1, 6585, 0, 0, 0, ''), -- 15169
(6587, 0, 0, 'What do they say?', 1, 1, 6586, 0, 0, 0, ''), -- 15169
(6588, 0, 0, 'How do you know?', 1, 1, 6587, 0, 0, 0, ''), -- 15169
(10456, 0, 0, 'I am ready to fight!', 1, 1, 0, 0, 0, 0, ''), -- 33743
(10457, 0, 0, 'I am ready to fight!', 1, 1, 0, 0, 0, 0, ''), -- 33744
(10461, 0, 0, 'I am ready to fight!', 1, 1, 0, 0, 0, 0, ''), -- 33748
(10462, 0, 0, 'I am ready to fight!', 1, 1, 0, 0, 0, 0, ''); -- 33749
 
-- TrinityCore\sql\updates\world\2012_07_22_07_world_sai.sql 
-- Add SAI for Liquid Pyrite ID: 33189 - remove auras to prevent exploit after used, also despawn
SET @Pyrite := 33189;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@Pyrite;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Pyrite;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Pyrite,0,0,1,8,0,100,0,67390,0,0,0,28,62494,0,0,0,0,0,1,0,0,0,0,0,0,0,'Pyrite - On hit by spell Ride Vehicle - Remove auras from Liquid Pyrite'),
(@Pyrite,0,1,0,61,0,100,0,0,0,0,0,41,15000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Pyrite - Linked with previous event - Despawn in 15 sec');
 
-- TrinityCore\sql\updates\world\2012_07_22_08_world_sai.sql 
-- Remove disables (instances scripts) for 10 and 25 version of achievement Dwarfageddon
DELETE FROM `achievement_criteria_data` WHERE  `criteria_id`=10858 AND `type`=18;
DELETE FROM `achievement_criteria_data` WHERE  `criteria_id`=10860 AND `type`=18;
-- Insert the required spell credit markers for Dwarfageddon (10/25 player) achievements
DELETE FROM `spell_dbc` WHERE `Id`=65387;
INSERT INTO `spell_dbc` (`Id`, `Dispel`, `Mechanic`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`, `AttributesEx5`, `AttributesEx6`, `AttributesEx7`, `Stances`, `StancesNot`, `Targets`, `CastingTimeIndex`, `AuraInterruptFlags`, `ProcFlags`, `ProcChance`, `ProcCharges`, `MaxLevel`, `BaseLevel`, `SpellLevel`, `DurationIndex`, `RangeIndex`, `StackAmount`, `EquippedItemClass`, `EquippedItemSubClassMask`, `EquippedItemInventoryTypeMask`, `Effect1`, `Effect2`, `Effect3`, `EffectDieSides1`, `EffectDieSides2`, `EffectDieSides3`, `EffectRealPointsPerLevel1`, `EffectRealPointsPerLevel2`, `EffectRealPointsPerLevel3`, `EffectBasePoints1`, `EffectBasePoints2`, `EffectBasePoints3`, `EffectMechanic1`, `EffectMechanic2`, `EffectMechanic3`, `EffectImplicitTargetA1`, `EffectImplicitTargetA2`, `EffectImplicitTargetA3`, `EffectImplicitTargetB1`, `EffectImplicitTargetB2`, `EffectImplicitTargetB3`, `EffectRadiusIndex1`, `EffectRadiusIndex2`, `EffectRadiusIndex3`, `EffectApplyAuraName1`, `EffectApplyAuraName2`, `EffectApplyAuraName3`, `EffectAmplitude1`, `EffectAmplitude2`, `EffectAmplitude3`, `EffectMultipleValue1`, `EffectMultipleValue2`, `EffectMultipleValue3`, `EffectMiscValue1`, `EffectMiscValue2`, `EffectMiscValue3`, `EffectMiscValueB1`, `EffectMiscValueB2`, `EffectMiscValueB3`, `EffectTriggerSpell1`, `EffectTriggerSpell2`, `EffectTriggerSpell3`, `EffectSpellClassMaskA1`, `EffectSpellClassMaskA2`, `EffectSpellClassMaskA3`, `EffectSpellClassMaskB1`, `EffectSpellClassMaskB2`, `EffectSpellClassMaskB3`, `EffectSpellClassMaskC1`, `EffectSpellClassMaskC2`, `EffectSpellClassMaskC3`, `MaxTargetLevel`, `SpellFamilyName`, `SpellFamilyFlags1`, `SpellFamilyFlags2`, `SpellFamilyFlags3`, `MaxAffectedTargets`, `DmgClass`, `PreventionType`, `DmgMultiplier1`, `DmgMultiplier2`, `DmgMultiplier3`, `AreaGroupId`, `SchoolMask`, `Comment`) VALUES
(65387, 0, 0, 545259776, 0, 5, 268697600, 128, 0, 16777216, 0, 0, 0, 0, 1, 0, 0, 101, 0, 0, 0, 0, 0, 13, 0, -1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 7, 0, 0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 'Steelforged Defender - Credit marker');
-- Add SAI support for Dwarfageddon (10 and 25 player) achievement/also SAI for the NPC connected
SET @Defender := 33236;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@Defender;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Defender;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Defender,0,0,0,6,0,100,0,0,0,0,0,11,65387,0,0,0,0,0,16,0,0,0,0,0,0,0,'Steelforged Defender - On death - Cast achievement credit'),
(@Defender,0,1,0,0,0,100,0,0,2500,9000,12000,11,62845,0,0,0,0,0,2,0,0,0,0,0,0,0,'Steelforged Defender - IC - Hamstring'),
(@Defender,0,2,0,0,0,100,0,0,2600,13000,14000,11,50370,0,0,0,0,0,2,0,0,0,0,0,0,0,'Steelforged Defender - IC - Cast Sunder armor'),
(@Defender,0,3,0,0,0,100,0,500,4000,4500,9000,11,57780,0,0,0,0,0,2,0,0,0,0,0,0,0,'Steelforged Defender - IC - Cast Lightening Bolt');
 
-- TrinityCore\sql\updates\world\2012_07_22_09_world_creature_template.sql 
-- Add spells to Salvaged Chopper - 25 version
UPDATE `creature_template` SET `spell1`=62974,`spell2`=62286,`spell3`=62299,`spell4`=64660, `mechanic_immune_mask`=344276858 WHERE `entry`=34045;
 
-- TrinityCore\sql\updates\world\2012_07_22_10_world_creature_onkill_rep.sql 
-- Critter Fire Beetle should not give reputation with Honor Hold when killed
DELETE FROM `creature_onkill_reputation` WHERE `creature_id` = 9699;
 
-- TrinityCore\sql\updates\world\2012_07_22_11_world_conditions.sql 
-- Exarch Menelaous - Missing condition for gossip 7370
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=7370 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,7370,0,0,0,9,9456,0,0,0,0,'','Exarch Menelaous - Show gossip option if player has quest 9456');
 
-- TrinityCore\sql\updates\world\2012_07_22_12_world_creature_template.sql 
-- Fix Night Elf Corpse (16804) so it can't be attacked
UPDATE `creature_template` SET `unit_flags`=768, `dynamicflags`=40 WHERE `entry` = 16804;
 
-- TrinityCore\sql\updates\world\2012_07_22_13_world_conditions.sql 
DELETE FROM conditions WHERE SourceTypeOrReferenceId=22 AND SourceEntry=160445;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, NegativeCondition, ErrorTextId, ScriptName, Comment) VALUES
(22, 1, 160445, 1, 0, 28, 0, 3821, 0, 0, 0, 0, '', 'Execute SmartAI for gameobject 160445 only if player has complete quest 3821');
 
-- TrinityCore\sql\updates\world\2012_07_22_14_world_gameobject.sql 
-- GO missing spawn
-- Zone: Tanaris, Area: Land's End Beach or Finisterrae Beach
SET @GO_ENTRY := 142189; -- GO Inconspicuous Landmark entry
SET @GO_GUID := 329; -- Need one guid
SET @POOL := 355; -- Need one entry

DELETE FROM `gameobject` WHERE `id`=@GO_ENTRY;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(17499,@GO_ENTRY,1,1,1,-10249.2,-3981.8,1.66783,-0.750491,0,0,0.366501,-0.930418,900,100,1), -- Already in TDB
(17498,@GO_ENTRY,1,1,1,-10119.7,-4052.46,5.33005,-0.366519,0,0,0.182236,-0.983255,900,100,1), -- Already in TDB
(@GO_GUID,@GO_ENTRY,1,1,1,-10154.2,-3948.635,7.744733,2.652894,0,0,0.970295,0.241925,900,100,1);

DELETE FROM `pool_template` WHERE `entry`=@POOL;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES
(@POOL,1 , 'GO Inconspicuous Landmark (142189)');

DELETE FROM `pool_gameobject` WHERE `guid` IN (17498,17499,@GO_GUID);
INSERT INTO `pool_gameobject` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(17498,@POOL,0, 'Inconspicuous Landmark'),
(17499,@POOL,0, 'Inconspicuous Landmark'),
(@GO_GUID,@POOL,0, 'Inconspicuous Landmark');
 
-- TrinityCore\sql\updates\world\2012_07_22_15_world_sai.sql 
-- SAI for quest 12150 "Reclusive Runemaster"
SET @Dregmar := 27003;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@Dregmar;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@Dregmar;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Dregmar AND `source_type`=0 AND `id` BETWEEN 0 AND 2;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Dregmar*100 AND `source_type`=9 AND `id` BETWEEN 0 AND 8;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Dregmar,0,0,0,4,0,100,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - on aggro - yell text 0'),
(@Dregmar,0,1,0,2,0,100,1,0,50,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - at 50% HP - yell text 1'),
(@Dregmar,0,2,0,2,0,100,0,0,20,0,0,80,@Dregmar*100,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - at 20% HP - run script'),
(@Dregmar*100,9,0,0,0,0,100,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - set phase 1'),
(@Dregmar*100,9,1,0,0,0,100,0,0,0,0,0,24,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - evade'),
(@Dregmar*100,9,2,0,0,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - Stop combat'),
(@Dregmar*100,9,3,0,0,0,100,0,0,0,0,0,18,33346,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - unitflags OutOfCombat'),
(@Dregmar*100,9,4,0,0,0,100,0,0,0,0,0,75,48325,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - apply aura RUNE SHIELD'),
(@Dregmar*100,9,5,0,0,0,100,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - yell text 2'),
(@Dregmar*100,9,6,0,0,0,100,0,0,14000,0,0,11,48028,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - Complete quest on player range'),
(@Dregmar*100,9,7,0,0,0,100,0,0,14000,0,0,19,514,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - unitflags reseted'),
(@Dregmar*100,9,8,0,0,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Dregmar Runebrand - force despawn');

-- creature_text
DELETE FROM `creature_ai_texts` WHERE `entry` BETWEEN -894 AND -892;
DELETE FROM `creature_text` WHERE `entry`=@Dregmar AND `groupid` BETWEEN 0 AND 2;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@Dregmar,0,0, 'I know why you''ve come - one of those foolish Magnataur on the plains meddled and managed to get the dragons involved. Do you enjoy serving them like a dog?',14,0,100,0,0,0, 'Dregmar Runebrand - yell'),
(@Dregmar,1,0, 'You seek their leader... little thing, you wage war against the clans of Grom''thar the Thunderbringer himself. Don''t be so eager to rush to your death.',14,0,100,0,0,0, 'Dregmar Runebrand yell'),
(@Dregmar,2,0, 'Hah! So be it. Blow the horn of a magnataur leader at the ring of torches south of the Azure Dragonshrine. Make peace with your gods... Grom''thar will come.',14,0,100,0,0,0, 'Dregmar Runebrand yell');
 
-- TrinityCore\sql\updates\world\2012_07_29_00_world_factionchange.sql 
-- Faction change item conversion for Reins of the Traveler's Tundra Mammoth
DELETE FROM `player_factionchange_items` WHERE `alliance_id`=44235;
INSERT INTO `player_factionchange_items` (`race_A`, `alliance_id`, `commentA`, `race_H`, `horde_id`, `commentH`) VALUES
(0,44235,'Reins of the Traveler''s Tundra Mammoth',0,44234,'Reins of the Traveler''s Tundra Mammoth');

-- Faction change spell conversion for Reins of the Traveler's Tundra Mammoth
DELETE FROM `player_factionchange_spells` WHERE `alliance_id`=61425;
INSERT INTO `player_factionchange_spells` (`alliance_id`,`horde_id`) VALUES
(61425,61447);
 
-- TrinityCore\sql\updates\world\2012_07_29_01_world_pool_quest.sql 
SET @pool_id := 356;

DELETE FROM `pool_template` WHERE `entry` IN (@pool_id, @pool_id+1);
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES
(@pool_id,1,'Wind Trader Zhareem - Daily Quests'),
(@pool_id+1,1,'Nether-Stalker Mah''duun - Daily Quests');

DELETE FROM `pool_quest` WHERE `entry` IN (11369,11384,11382,11363,11362,11375,11354,11386,11373,11378,11374,11372,11368,11388,11499,11370) AND `pool_entry` = @pool_id;
DELETE FROM `pool_quest` WHERE `entry` IN (11389,11371,11376,11383,11364,11500,11385,11387) AND `pool_entry` = @pool_id+1;
INSERT INTO `pool_quest` (`entry`,`pool_entry`,`description`) VALUES
(11369,@pool_id,'Wanted: A Black Stalker Egg'),
(11384,@pool_id,'Wanted: A Warp Splinter Clipping'),
(11382,@pool_id,'Wanted: Aeonus''s Hourglass'),
(11363,@pool_id,'Wanted: Bladefist''s Seal'),
(11362,@pool_id,'Wanted: Keli''dan''s Feathered Stave'),
(11375,@pool_id,'Wanted: Murmur''s Whisper'),
(11354,@pool_id,'Wanted: Nazan''s Riding Crop'),
(11386,@pool_id,'Wanted: Pathaleon''s Projector'),
(11373,@pool_id,'Wanted: Shaffar''s Wondrous Pendant'),
(11378,@pool_id,'Wanted: The Epoch Hunter''s Head'),
(11374,@pool_id,'Wanted: The Exarch''s Soul Gem'),
(11372,@pool_id,'Wanted: The Headfeathers of Ikiss'),
(11368,@pool_id,'Wanted: The Heart of Quagmirran'),
(11388,@pool_id,'Wanted: The Scroll of Skyriss'),
(11499,@pool_id,'Wanted: The Signet Ring of Prince Kael''thas'),
(11370,@pool_id,'Wanted: The Warlord''s Treatise'),
(11389,@pool_id+1,'Wanted: Arcatraz Sentinels'),
(11371,@pool_id+1,'Wanted: Coilfang Myrmidons'),
(11376,@pool_id+1,'Wanted: Malicious Instructors'),
(11383,@pool_id+1,'Wanted: Rift Lords'),
(11364,@pool_id+1,'Wanted: Shattered Hand Centurions'),
(11500,@pool_id+1,'Wanted: Sisters of Torment'),
(11385,@pool_id+1,'Wanted: Sunseeker Channelers'),
(11387,@pool_id+1,'Wanted: Tempest-Forge Destroyers');
 
-- TrinityCore\sql\updates\world\2012_07_29_02_world_sai.sql 
SET @Gossip :=9640;
SET @NPCText :=13047;

DELETE FROM `gossip_menu` WHERE `entry` = @Gossip;
INSERT INTO `gossip_menu` VALUES
(@Gossip,@NPCText);

DELETE FROM `gossip_menu_option` WHERE `menu_id` = @Gossip;
INSERT INTO `gossip_menu_option` VALUES
(@Gossip,0,0,"Soldier, you have new orders. You're to pull back and report to the sergeant!",1,1,0,0,0,0,NULL);

UPDATE `creature_template` SET `gossip_menu_id` = @Gossip, AIName = 'SmartAI', `npcflag` = `npcflag`|1 WHERE `entry` = 28041;

DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 28041;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 28041 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 28041*100 AND `source_type` = 9;
INSERT INTO `smart_scripts` VALUES
(28041,0,0,0,0,0,100,0,8000,10000,8000,12000,11,50370,0,0,0,0,0,2,0,0,0,0,0,0,0,'Argent Soldier - Combat - Cast Sunder Armor'),
(28041,0,1,2,62,0,100,0,@Gossip,0,0,0,33,28041,0,0,0,0,0,7,0,0,0,0,0,0,0,'Argent Soldier - On Gossip - Credit'),
(28041,0,2,3,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Argent Soldier - Event Linked - Close Gossip'),
(28041,0,3,4,61,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Argent Soldier - Event Linked - NpcFlag Remove'),
(28041,0,4,0,61,0,100,0,0,0,0,0,80,2804100,0,2,0,0,0,1,0,0,0,0,0,0,0,'Argent Soldier - Event Linked - Run Script'),
(28041*100,9,0,0,0,0,100,0,6000,6000,0,0,47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Argent Soldier - Script 6 Seconds - Unseen'),
(28041*100,9,1,0,0,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Argent Soldier - Script - Despawn');

DELETE FROM `conditions` WHERE SourceTypeOrReferenceId= 15  AND SourceGroup=@Gossip;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, @Gossip, 0, 0, 0, 9, 0, 12504, 0, 0, 0, 0, '', NULL);
 
-- TrinityCore\sql\updates\world\2012_07_29_03_world_sai.sql 
-- [Q] Truce (11989)
SET @ENTRY := 26423; -- Drakuru
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@ENTRY, 0, 0, 1, 62, 0, 100, 0, 9615, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Drakuru - On Gossip Select - Close Gossip'),
(@ENTRY, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 85, 50016, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Drakuru - On Gossip Select - Give kill credit');
 
-- TrinityCore\sql\updates\world\2012_07_29_04_world_sai.sql 
UPDATE `creature` SET `spawntimesecs`=180 WHERE `id`=23689;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (23689,24170);

DELETE FROM `creature_ai_scripts` WHERE `creature_id`=23689;

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (23689,24170) AND `source_type`=0;
insert into `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) values
(23689,0,1,2,65,0,100,0,0,0,0,0,11,36809,2,0,0,0,0,1,0,0,0,0,0,0,0,'Proto-Drake - Reach Target - Cast Spell (36809)'),
(23689,0,2,0,61,0,100,0,0,0,0,0,33,24170,0,0,0,0,0,18,35,0,0,0,0,0,0,'Draconis Gastritis Bunny - On Death - Quest Reward'),
(23689,0,3,5,1,0,100,0,10000,10000,10000,10000,29,0,0,24170,1,1,0,19,24170,75,0,0,0,0,0,'Proto-Drake - Find Target - Follow'),
(23689,0,4,0,65,0,100,0,0,0,0,0,51,0,0,0,0,0,0,19,24170,5,0,0,0,0,0,'Proto-Drake - Reach Target - Kill Dummy'),
(23689,0,5,3,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Proto-Drake - On Find Target - Set Phase 1'),
(23689,0,6,0,1,1,100,0,45000,45000,45000,45000,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Proto-Drake - Idle on Ground(Phase 1) - Despawn'),
(24170,0,0,0,54,0,100,0,0,0,0,0,50,186598,60000,0,0,0,0,1,0,0,0,0,0,0,0,'Draconis Gastritis Bunny - On Create - Spawn GO'),
(24170,0,1,0,6,0,100,0,0,0,0,0,33,24170,0,0,0,0,0,18,20,0,0,0,0,0,0,'Draconis Gastritis Bunny - On Death - Quest Reward'),
(24170,0,2,0,54,0,100,0,0,0,0,0,47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Draconis Gastritis Bunny - On Create - Hide'),
(24170,0,3,0,6,0,100,0,0,0,0,0,41,0,0,0,0,0,0,15,186598,5,0,0,0,0,0,'Draconis Gastritis Bunny - On Death - Remove Gobjects');
 
-- TrinityCore\sql\updates\world\2012_07_29_05_world_sai.sql 
-- Life or Death (12296)

SET @ENTRY := 27482; -- Wounded Westfall Infantry npc
SET @SOURCETYPE := 0;
SET @CREDIT := 27466; -- Kill Credit Bunny - Wounded Skirmishers npc
SET @ITEM := 37576; -- Renewing Bandage item

DELETE FROM `conditions` WHERE `SourceEntry`=@ITEM;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,0,@ITEM,0,24,1,@ENTRY,0,0,'', "Item Renewing Bandage target Wounded Westfall Infantry");

-- Wounded Westfall Infantry SAI
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,8,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"On creature spellhit - Set phasemask 1 - self"),
(@ENTRY,@SOURCETYPE,1,0,1,1,100,0,0,0,3000,3000,1,0,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"On OOC - Talk - Self"),
(@ENTRY,@SOURCETYPE,2,3,1,1,100,0,2000,2000,2000,2000,53,1,@ENTRY,0,12296,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"On OOC Update 2 sec - Start WP 1 - Self"),
(@ENTRY,@SOURCETYPE,3,4,61,1,100,0,0,0,0,0,18,128,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"Link - Set unit_flag 128 - Self"),
(@ENTRY,@SOURCETYPE,4,5,61,1,100,0,0,0,0,0,33,@CREDIT,0,0,0,0,0,7,0,0,0,0.0,0.0,0.0,0.0,"Link - Give credit - Invoker"),
(@ENTRY,@SOURCETYPE,5,0,61,1,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"Link - Set phasemask 2 - Self"),
(@ENTRY,@SOURCETYPE,6,0,40,2,100,0,2,@ENTRY,0,0,41,0,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"On WP 2 - Force despawn - Self");

DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0,"I'd nearly given up.You've given me new life!",12,0,50,0,0,0,"Wounded Westfall Infantry say text"),
(@ENTRY,0,1,"Bless you, friend.I nearly expired....",12,0,50,0,0,0,"Wounded Westfall Infantry say text"),
(@ENTRY,0,2,"Without your help, I surely would have died....",12,0,50,0,0,0,"Wounded Westfall Infantry say text"),
(@ENTRY,0,3,"Thank you $r.",12,0,50,0,0,0,"Wounded Westfall Infantry say text");

DELETE FROM `waypoints` WHERE `entry`=@ENTRY;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ENTRY,1,4105.278809,-2917.963867,280.320129,'Wounded Westfall Infantry'),
(@ENTRY,2,4048.682861,-2936.736572,275.191681,'Wounded Westfall Infantry');
 
-- TrinityCore\sql\updates\world\2012_07_29_06_world_sai.sql 
-- Remove previous fix
DELETE FROM `gossip_menu` WHERE `entry` = 9640;
DELETE FROM `gossip_menu_option` WHERE `menu_id` = 9640;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 28041 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 28041*100 AND `source_type` = 9;
DELETE FROM `conditions` WHERE SourceTypeOrReferenceId= 15  AND SourceGroup = 9640;

-- Argent Crusade, We Are Leaving! (12504)

SET @ENTRY := 28041; -- Argent Soldier
SET @SOURCETYPE := 0;
SET @CREDIT := 50289; -- Argent Crusade, We Are Leaving!: Argent Soldier Quest Credit
SET @MENUID := 9640;
SET @OPTION := 0;

UPDATE `creature_template` SET `gossip_menu_id`=@MENUID,`npcflag`=1,`AIName`='SmartAI' WHERE `entry`=@ENTRY;

DELETE FROM `gossip_menu_option` WHERE `menu_id`=@MENUID AND `id`=@OPTION;
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES
(@MENUID,@OPTION,0,"Soldier, you have new orders. You're to pull back and report to the sergeant!",1,1,0,0,0,0,'');

DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,0,0,100,0,8000,10000,8000,12000,11,50370,0,0,0,0,0,2,0,0,0,0,0,0,0,"IC - Cast Sunder Armor - Victim"),
(@ENTRY,@SOURCETYPE,1,2,62,0,100,0,@MENUID,@OPTION,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,"On gossip select - Close Gossip - Invoker"),
(@ENTRY,@SOURCETYPE,2,3,61,0,100,0,0,0,0,0,11,@CREDIT,0,0,0,0,0,7,0,0,0,0,0,0,0,"On link - Cast credit spell - Invoker"),
(@ENTRY,@SOURCETYPE,3,4,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0.0,0.0,0.0,0.0,"On link - Whisper - Invoker"),
(@ENTRY,@SOURCETYPE,4,0,61,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,"On link - Despawn - Self");

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=@MENUID AND `SourceEntry`=@OPTION;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,@MENUID,@OPTION,2,9,12504,0,0,0,'',"Show gossip option 0 if player has quest 12504 marked as taken");

DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0,"Careful here, $C. These trolls killed their own snake god!",15,0,50,0,0,0,"Argent Soldier whisper text"),
(@ENTRY,0,1,"Watch your back. These Drakkari are a nasty lot.",15,0,50,0,0,0,"Argent Soldier whisper text"),
(@ENTRY,0,2,"These Drakkari are just bad news. We need to leave and head back to Justice Keep!",15,0,50,0,0,0,"Argent Soldier whisper text"),
(@ENTRY,0,3,"See you around.",15,0,50,0,0,0,"Argent Soldier whisper text"),
(@ENTRY,0,4,"I wonder where we're headed to. And who's going to deal with these guys?",15,0,50,0,0,0,"Argent Soldier whisper text"),
(@ENTRY,0,5,"Right. I'd better get back to the sergeant then.",15,0,50,0,0,0,"Argent Soldier whisper text"),
(@ENTRY,0,6,"Are you $N? I heard you were dead.",15,0,50,0,0,0,"Argent Soldier whisper text");
 
-- TrinityCore\sql\updates\world\2012_07_29_07_world_sai.sql 
DELETE FROM `smart_scripts` WHERE `entryorguid`=181758 AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(181758, 1, 0, 0, 20,  0, 100, 0, 9561, 0, 0, 0, 56, 23846, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Add Nolkais Box after finishing quest: Nolkais Words');
UPDATE `gameobject_template` SET `AIName`= 'SmartGameObjectAI' WHERE `entry`=181758;
 
-- TrinityCore\sql\updates\world\2012_07_29_08_world_sai.sql 
-- Meeting at the Blackwing Coven quest fix

-- Variables
SET @QUEST := 10722;
SET @ENTRY := 22019;
SET @SPELL1:= 37704; -- Whirlwind
SET @SPELL2:= 8599; -- Enrage

-- Add SmartAI for Kolphis Darkscale
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,0,62,0,100,0,8439,0,0,0,15,@QUEST,0,0,0,0,0,7,0,0,0,0,0,0,0,'Kolphis Darkscale - On Gossip Select - Quest Credit'),
(@ENTRY,0,1,0,0,0,50,0,3000,3000,8000,8000,11,@SPELL1,0,0,0,0,0,2,0,0,0,0,0,0,0,'Kolphis Darkscale - Combat - Whirlwind'),
(@ENTRY,0,2,3,2,0,100,1,0,25,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Kolphis Darkscale - On Health level - Emote when below 25% HP'),
(@ENTRY,0,3,0,61,0,100,1,0,0,0,0,11,@SPELL2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Kolphis Darkscale - On Health level - Cast Enrage when below 25% HP');

-- add missing text to Kolphis Darkscale from sniff
DELETE FROM `npc_text` WHERE `ID`=10540;
INSERT INTO `npc_text` (`ID`,`prob0`,`text0_0`,`text0_1`,`WDBVerified`) VALUES
(10540,1,"Begone, overseer!  We've already spoken.$B$BStop dragging your feet and execute your orders at Ruuan Weald!",'',1);

-- Kolphis Darkscale emote
DELETE FROM `creature_text` WHERE `entry`=@ENTRY;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@ENTRY,0,0,'%s becomes enraged!',16,0,100,0,0,0,'Kolphis Darkscale');

-- Gossip menu insert from sniff
DELETE FROM `gossip_menu` WHERE `entry`=8436 AND `text_id`=10540;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES (8436,10540);

-- Add gossip_menu conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (14,15) AND `SourceGroup`=8436;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(15,8436,0,0,0,9,0,@QUEST,0,0,0,0,'','Kolphis Darkscale - Show Gossip Option 0 - If on Quest Meeting at the Blackwing Coven'),
(14,8436,10540,0,0,28,0,@QUEST,0,0,0,0,'','Kolphis Darkscale - Show Gossip Menu - If Quest Meeting at the Blackwing Coven is Completed');
 
-- TrinityCore\sql\updates\world\2012_07_29_09_world_gossip_menu_option.sql 
UPDATE `gossip_menu_option` SET
	`npc_option_npcflag` = 65536,
    `option_icon` = 5
WHERE
	`menu_id` = 1293 AND
	`id` = 1;

UPDATE `gossip_menu_option` SET
	`npc_option_npcflag` = 128
WHERE
	`menu_id` = 1293 AND 
	`id` = 2;
 
-- TrinityCore\sql\updates\world\2012_07_29_10_world_sai.sql 
-- [Q] Measuring Warp Energies

DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN(20333,20336,20337,20338);
UPDATE `creature_template` SET AIName='SmartAI' WHERE `entry` IN (20333,20336,20337,20338);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (20333,20336,20337,20338);
INSERT INTO `smart_scripts` VALUES
(20333,0,0,0,8,0,100,0,35113,0,0,0,33,20333,0,0,0,0,0,7,0,0,0,0,0,0,0,"Northern Pipe Credit Marker - Spellhit - Credit"),
(20336,0,0,0,8,0,100,0,35113,0,0,0,33,20336,0,0,0,0,0,7,0,0,0,0,0,0,0,"Eastern Pipe Credit Marker - Spellhit - Credit"),
(20337,0,0,0,8,0,100,0,35113,0,0,0,33,20337,0,0,0,0,0,7,0,0,0,0,0,0,0,"Southern Pipe Credit Marker - Spellhit - Credit"),
(20338,0,0,0,8,0,100,0,35113,0,0,0,33,20338,0,0,0,0,0,7,0,0,0,0,0,0,0,"Western Pipe Credit Marker - Spellhit - Credit");

-- Conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=35113;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 35113, 0, 0, 31, 0, 3, 20333, 0, 0, 0, '', "Spell Search NPC 20333"),
(13, 1, 35113, 0, 1, 31, 0, 3, 20336, 0, 0, 0, '', "Spell Search NPC 20336"),
(13, 1, 35113, 0, 2, 31, 0, 3, 20337, 0, 0, 0, '', "Spell Search NPC 20337"),
(13, 1, 35113, 0, 3, 31, 0, 3, 20338, 0, 0, 0, '', "Spell Search NPC 20338");

UPDATE `creature` SET `position_x`=3214.92, `position_y`=4065.25, `position_z`=106.16 WHERE `id`=20333;
UPDATE `creature` SET `position_x`=2755.55, `position_y`=3863.32, `position_z`=142.27 WHERE `id`=20336;
UPDATE `creature` SET `position_x`=2819.01, `position_y`=4351.10, `position_z`=144.97 WHERE `id`=20337;
UPDATE `creature` SET `position_x`=2947.31, `position_y`=4327.47, `position_z`=154.02 WHERE `id`=20338;
 
-- TrinityCore\sql\updates\world\2012_08_01_00_world_sai.sql 
-- Fix [Qs] Words of Power /11640/11942/{A/H}
-- 10x to Subv for giving me idea how to fix it
SET @BEAM := 47848;
SET @NECRO := 25378;
SET @NECROguid := 300100;
SET @NAFERSET := 26076;
SET @Blast := 15587;
SET @Renew:= 11640;
SET @Corruption := 32063;
SET @Shadow := 9613;
-- Add spawns for the three necromancers
DELETE FROM `creature` WHERE `guid` IN (@NECROguid,@NECROguid+1,@NECROguid+2);
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `MovementType`) VALUES
(@NECROguid, 25378, 571, 1, 3, 4101.931641, 3761.125000, 92.664742, 4.909590, 180, 0, 0, 0),
(@NECROguid+1, 25378, 571, 1, 3, 4133.339355, 3743.313721, 92.670166, 3.474295, 180, 0, 0, 0),
(@NECROguid+2, 25378, 571, 1, 3, 4121.242676, 3708.384766, 92.665283, 1.864472, 180, 0, 0, 0);
-- Add SAI for En"kilah Necromancer
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@NECRO;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@NECRO;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@NECRO;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NECRO,0,0,0,1,0,100,0,10000,20000,180000,200000,11,@BEAM,0,0,0,0,0,11,@NAFERSET,30,0,0,0,0,0,' En"kilah Necromancer - OOC - Cast spell Purple Beam on Naferset'),
(@NECRO,0,1,0,6,0,100,0,0,0,0,0,45,0,1,0,0,0,0,11,@NAFERSET,50,0,0,0,0,0,' En"kilah Necromancer - on death - Data set 0 1 on Hight Priest Nafarset'),
(@NECRO,0,2,0,0,0,100,0,2000,3000,15000,16000,11,@Corruption,0,0,0,0,0,2,0,0,0,0,0,0,0,' En"kilah Necromancer - IC - Corruption'),
(@NECRO,0,3,0,0,0,100,0,4000,6000,2000,6500,11,@Shadow,32,0,0,0,0,2,0,0,0,0,0,0,0, 'En"kilah Necromancer - Ic - Shadow Bolt');
--  Add SAI for Hight Priest Naferset
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@NAFERSET;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@NAFERSET;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NAFERSET,0,0,0,38,0,100,0,0,1,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,' Hight Priest Nafarset - On Data set 0 1 - Increment event phase by 1'),
(@NAFERSET,0,1,2,60,4,100,1,1000,2000,1000,2000,1,0,1000,0,0,0,0,1,0,0,0,0,0,0,0, 'Hight Priest Nafarset - On Event update /in event phase 3/ - Say text 0'),
(@NAFERSET,0,2,3,61,4,100,0,0,0,0,0,19,33555200,0,0,0,0,0,1,0,0,0,0,0,0,0,' Hight Priest Nafarset - Linked with event 1 - Set field flags to 0'),
(@NAFERSET,0,3,0,61,4,100,0,0,0,0,0,49,0,0,0,0,0,0,21,20,0,0,0,0,0,0,' Hight Priest Nafarset - Linked with event 2 - Attack start on closest player'),
(@NAFERSET,0,4,0,0,4,100,0,4000,6000,5000,8000,11,@Blast,0,0,0,0,0,2,0,0,0,0,0,0,0,' Hight Priest Nafarset - IC - Cast spell Mind Blast'),
(@NAFERSET,0,5,0,0,4,100,0,8000,12000,10000,15000,11,@Renew,0,0,0,0,0,1,0,0,0,0,0,0,0,' Hight Priest Nafarset - IC - Cast spell Renew on self'),
(@NAFERSET,0,6,7,6,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0,' Hight Priest Nafarset - On death - Data set 0 0'),
(@NAFERSET,0,7,0,61,0,100,0,0,0,0,0,78,0,0,0,0,0,0,1,0,0,0,0,0,0,0,' Hight Priest Nafarset - Linked with event 6 - Reset');
-- Hight Priest Naferset's Text
DELETE FROM `creature_text` WHERE `entry`=@NAFERSET;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NAFERSET,0,0,'What is the meaning of this?! I have not yet finished my feast!',14,0,100,1,1000,0,'Nafarset on activation');
 
-- TrinityCore\sql\updates\world\2012_08_01_01_world_creature.sql 
SET @NECROguid := 300100;
SET @NEWNECROguid := 42877;

DELETE FROM `creature` WHERE `guid` IN (@NECROguid,@NECROguid+1,@NECROguid+2);
DELETE FROM `creature` WHERE `guid` IN (@NEWNECROguid,@NEWNECROguid+1,@NEWNECROguid+2);
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `MovementType`) VALUES
(@NEWNECROguid, 25378, 571, 1, 3, 4101.931641, 3761.125000, 92.664742, 4.909590, 180, 0, 0, 0),
(@NEWNECROguid+1, 25378, 571, 1, 3, 4133.339355, 3743.313721, 92.670166, 3.474295, 180, 0, 0, 0),
(@NEWNECROguid+2, 25378, 571, 1, 3, 4121.242676, 3708.384766, 92.665283, 1.864472, 180, 0, 0, 0);
 
-- TrinityCore\sql\updates\world\2012_08_01_02_world_loot.sql 
-- Add quest item "Bleeding Hollow Torch" to "Bleeding Hollow Peon" loot template
DELETE FROM `creature_loot_template` WHERE `entry`=16907 and `item`=31347;
INSERT INTO `creature_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `lootmode`, `groupid`, `mincountOrRef`, `maxcount`) VALUES
(16907,31347,-50,1,0,1,1);
 
-- TrinityCore\sql\updates\world\2012_08_02_00_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE `spell_id`=-603;
INSERT INTO `spell_script_names` (`spell_id` ,`ScriptName`) VALUES
(-603,'spell_warl_curse_of_doom');
 
-- TrinityCore\sql\updates\world\2012_08_04_00_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (73,108,241,242,259,326,327,352,390,406,462,490,497,534,548,612,636,740,774,796,797,798,799,800,801,802,803,810,811,814,820,839,856,859,904,946,987,988,989,1128,1129,1155,1156,1157,1158,1161,1162,1163,1165,1263,1272,1277,1278,1279,1280,1281,1283,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1390,1397,1441,1443,1460,1461,1533,1537,1538,1659,1660,1662,1663,1664,2020,2971,3023,3064,3241,3383,3401,3403,3404,3405,3422,3423,3424,3425,3515,3516,3529,3530,3531,3622,3623,3624,3885,3910,4323,4541,4905,5053,5205,5207,5208,5209,5303,5304,5506,5512,5516,5520,5523,5532,5653,5659,5664,5665,5666,5667,5668,5669,5670,5671,5681,5682,5683,5684,5685,5686,5687,5688,5689,5690,5691,5692,5693,5694,5695,5696,5697,5698,5699,5700,5701,5702,5703,5704,5705,5706,5707,5708,5709,5710,5711,5712,6003,6165,6202,6702,6703,6704,6705,6706,6707,6708,6709,6710,6711,6841,6842,7069,7904,8002,8244,8245,8247,8248,8337,8339,8340,8444,8445,8448,8449,8450,8451,8452,8453,8454,8458,8459,8571,9031,9306,9307,9445,9596,9597,9599,9679,9745,10370,10402,10616,10743,10890,11127); 
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,73,0,'','','Deprecated quest: <TXT> No Reward'),
(1,108,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,241,0,'','','Deprecated quest: <TEST> HEY MISTER WILSON!'),
(1,242,0,'','','Deprecated quest: <UNUSED>'),
(1,259,0,'','','Deprecated quest: <UNUSED>'),
(1,326,0,'','','Deprecated quest: <UNUSED>'),
(1,327,0,'','','Deprecated quest: <UNUSED>'),
(1,352,0,'','','Deprecated quest: <UNUSED>'),
(1,390,0,'','','Deprecated quest: <UNUSED>'),
(1,406,0,'','','Deprecated quest: <UNUSED>'),
(1,462,0,'','','Deprecated quest: <UNUSED>'),
(1,490,0,'','','Deprecated quest: <UNUSED>'),
(1,497,0,'','','Deprecated quest: <UNUSED>'),
(1,534,0,'','','Deprecated quest: <UNUSED>'),
(1,548,0,'','','Deprecated quest: <NYI> <TXT> Bloodstone Pendant'),
(1,612,0,'','','Deprecated quest: <UNUSED>'),
(1,636,0,'','','Deprecated quest: Legends of the Earth <NYI>'),
(1,740,0,'','','Deprecated quest: <UNUSED>'),
(1,774,0,'','','Deprecated quest: <UNUSED>'),
(1,796,0,'','','Deprecated quest: <UNUSED>'),
(1,797,0,'','','Deprecated quest: <UNUSED>'),
(1,798,0,'','','Deprecated quest: <UNUSED>'),
(1,799,0,'','','Deprecated quest: <UNUSED>'),
(1,800,0,'','','Deprecated quest: <UNUSED>'),
(1,801,0,'','','Deprecated quest: <UNUSED>'),
(1,802,0,'','','Deprecated quest: <UNUSED>'),
(1,803,0,'','','Deprecated quest: <UNUSED>'),
(1,810,0,'','','Deprecated quest: <UNUSED>'),
(1,811,0,'','','Deprecated quest: <UNUSED>'),
(1,814,0,'','','Deprecated quest: <UNUSED>'),
(1,820,0,'','','Deprecated quest: <UNUSED>'),
(1,839,0,'','','Deprecated quest: <UNUSED>'),
(1,856,0,'','','Deprecated quest: <UNUSED>'),
(1,859,0,'','','Deprecated quest: <UNUSED>'),
(1,904,0,'','','Deprecated quest: <UNUSED>'),
(1,946,0,'','','Deprecated quest: <UNUSED>'),
(1,987,0,'','','Deprecated quest: <UNUSED>'),
(1,988,0,'','','Deprecated quest: <UNUSED>'),
(1,989,0,'','','Deprecated quest: <UNUSED>'),
(1,1128,0,'','','Deprecated quest: <NYI> The Gnome Pit Crew is Thirsty'),
(1,1129,0,'','','Deprecated quest: <NYI> The Goblin Pit Crew is Thirsty'),
(1,1155,0,'','','Deprecated quest: <NYI> <TXT> bug crystal side quest'),
(1,1156,0,'','','Deprecated quest: <NYI> <TXT> speak to alchemist pestlezugg'),
(1,1157,0,'','','Deprecated quest: <NYI> <TXT> pestlezugg needs items'),
(1,1158,0,'','','Deprecated quest: <NYI> <TXT> speak to rabine saturna'),
(1,1161,0,'','','Deprecated quest: <NYI> <TXT> gossip shade of ambermoon'),
(1,1162,0,'','','Deprecated quest: <NYI> <TXT> speak to hamuul runetotem'),
(1,1163,0,'','','Deprecated quest: <NYI> <TXT> speak to tyrande whisperwind'),
(1,1165,0,'','','Deprecated quest: <NYI> Ore for the Races'),
(1,1263,0,'','','Deprecated quest: The Burning Inn <CHANGE TO GOSSIP>'),
(1,1272,0,'','','Deprecated quest: Finding Reethe <CHANGE INTO GOSSIP>'),
(1,1277,0,'','','Deprecated quest: <nyi> <TXT> The Centaur Hoofprints'),
(1,1278,0,'','','Deprecated quest: <nyi> <TXT> The Grim Totem Clan'),
(1,1279,0,'','','Deprecated quest: <nyi> <TXT>The Centaur Hoofprints'),
(1,1280,0,'','','Deprecated quest: <nyi> <TXT>The Centaur Hoofprints'),
(1,1281,0,'','','Deprecated quest: Jim''s Song <CHANGE TO GOSSIP>'),
(1,1283,0,'','','Deprecated quest: Fire at the Shady Rest <CHANGE TO GOSSIP>'),
(1,1289,0,'','','Deprecated quest: <nyi> Vimes''s Report'),
(1,1290,0,'','','Deprecated quest: <nyi> Investigating Mosarn'),
(1,1291,0,'','','Deprecated quest: <nyi> <TXT> Centaur Hoofprints'),
(1,1292,0,'','','Deprecated quest: <nyi><TXT> Centaur Hoofprints'),
(1,1293,0,'','','Deprecated quest: <nyi> <TXT> Centaur Hoofprints'),
(1,1294,0,'','','Deprecated quest: <nyi> <TXT>Centaur Sympathies'),
(1,1295,0,'','','Deprecated quest: <nyi> <TXT> Course of Action'),
(1,1296,0,'','','Deprecated quest: <nyi> <TXT> Course of Action'),
(1,1297,0,'','','Deprecated quest: <nyi> <TXT> Course of Action'),
(1,1298,0,'','','Deprecated quest: <nyi> <TXT> Thrall''s Dirty Work'),
(1,1299,0,'','','Deprecated quest: <nyi> <TXT> Thrall''s Dirty Work'),
(1,1300,0,'','','Deprecated quest: <nyi> <TXT> Lorn Grim Totem'),
(1,1390,0,'','','Deprecated quest: <nyi> Oops, We Killed Them Again.'),
(1,1397,0,'','','Deprecated quest: <nyi> Saved!'),
(1,1441,0,'','','Deprecated quest: <UNUSED>'),
(1,1443,0,'','','Deprecated quest: <nyi> The Shakedown'),
(1,1460,0,'','','Deprecated quest: <UNUSED>'),
(1,1461,0,'','','Deprecated quest: <UNUSED>'),
(1,1533,0,'','','Deprecated quest: <NYI> Call of Air'),
(1,1537,0,'','','Deprecated quest: <NYI> Call of Air'),
(1,1538,0,'','','Deprecated quest: <NYI> Call of Air'),
(1,1659,0,'','','Deprecated quest: <UNUSED>'),
(1,1660,0,'','','Deprecated quest: <UNUSED>'),
(1,1662,0,'','','Deprecated quest: <UNUSED>'),
(1,1663,0,'','','Deprecated quest: <UNUSED>'),
(1,1664,0,'','','Deprecated quest: <UNUSED>'),
(1,2020,0,'','','Deprecated quest: <UNUSED>'),
(1,2971,0,'','','Deprecated quest: <UNUSED>'),
(1,3023,0,'','','Deprecated quest: <UNUSED>'),
(1,3064,0,'','','Deprecated quest: <NYI> <TXT> Pirate Hats'),
(1,3241,0,'','','Deprecated quest: <NYI> <TXT><redux> Dreadmist Peak'),
(1,3383,0,'','','Deprecated quest: <UNUSED>'),
(1,3401,0,'','','Deprecated quest: <UNUSED>'),
(1,3403,0,'','','Deprecated quest: <UNUSED>'),
(1,3404,0,'','','Deprecated quest: <UNUSED>'),
(1,3405,0,'','','Deprecated quest: <UNUSED>'),
(1,3422,0,'','','Deprecated quest: <UNUSED>'),
(1,3423,0,'','','Deprecated quest: <UNUSED>'),
(1,3424,0,'','','Deprecated quest: <UNUSED>'),
(1,3425,0,'','','Deprecated quest: <UNUSED>'),
(1,3515,0,'','','Deprecated quest: <UNUSED>'),
(1,3516,0,'','','Deprecated quest: <UNUSED>'),
(1,3529,0,'','','Deprecated quest: <UNUSED>'),
(1,3530,0,'','','Deprecated quest: <UNUSED>'),
(1,3531,0,'','','Deprecated quest: <UNUSED>'),
(1,3622,0,'','','Deprecated quest: <UNUSED>'),
(1,3623,0,'','','Deprecated quest: <UNUSED>'),
(1,3624,0,'','','Deprecated quest: <UNUSED>'),
(1,3885,0,'','','Deprecated quest: <NYI> <TXT> The Gadgetzan Run'),
(1,3910,0,'','','Deprecated quest: <NYI> <TXT> The Un''Goro Run'),
(1,4323,0,'','','Deprecated quest: <NYI> <TXT> Get those Hyenas!!!'),
(1,4541,0,'','','Deprecated quest: <NYI> <TXT>'),
(1,4905,0,'','','Deprecated quest: <UNUSED>'),
(1,5053,0,'','','Deprecated quest: <UNUSED>'),
(1,5205,0,'','','Deprecated quest: <UNUSED>'),
(1,5207,0,'','','Deprecated quest: <NYI> <TXT> The True Summoner'),
(1,5208,0,'','','Deprecated quest: <NYI> <TXT> The Blessing of Evil'),
(1,5209,0,'','','Deprecated quest: <UNUSED>'),
(1,5303,0,'','','Deprecated quest: <UNUSED>'),
(1,5304,0,'','','Deprecated quest: <UNUSED>'),
(1,5506,0,'','','Deprecated quest: <UNUSED>'),
(1,5512,0,'','','Deprecated quest: <UNUSED>'),
(1,5516,0,'','','Deprecated quest: <UNUSED>'),
(1,5520,0,'','','Deprecated quest: <UNUSED>'),
(1,5523,0,'','','Deprecated quest: <UNUSED>'),
(1,5532,0,'','','Deprecated quest: <NYI> <TXT> Ring of the Dawn'),
(1,5653,0,'','','Deprecated quest: <NYI> Hex of Weakness'),
(1,5659,0,'','','Deprecated quest: <NYI> Touch of Weakness'),
(1,5664,0,'','','Deprecated quest: <UNUSED>'),
(1,5665,0,'','','Deprecated quest: <UNUSED>'),
(1,5666,0,'','','Deprecated quest: <UNUSED>'),
(1,5667,0,'','','Deprecated quest: <UNUSED>'),
(1,5668,0,'','','Deprecated quest: <NYI> A Blessing of Light'),
(1,5669,0,'','','Deprecated quest: <NYI> A Blessing of Light'),
(1,5670,0,'','','Deprecated quest: <NYI> A Blessing of Light'),
(1,5671,0,'','','Deprecated quest: <NYI> A Blessing of Light'),
(1,5681,0,'','','Deprecated quest: <UNUSED>'),
(1,5682,0,'','','Deprecated quest: <UNUSED>'),
(1,5683,0,'','','Deprecated quest: <UNUSED>'),
(1,5684,0,'','','Deprecated quest: <UNUSED>'),
(1,5685,0,'','','Deprecated quest: <NYI> <TXT> The Light Protects You'),
(1,5686,0,'','','Deprecated quest: <NYI> The Light Protects You'),
(1,5687,0,'','','Deprecated quest: <NYI> The Light Protects You'),
(1,5688,0,'','','Deprecated quest: <NYI> <TXT> A Touch of Voodoo'),
(1,5689,0,'','','Deprecated quest: <NYI> A Touch of Voodoo'),
(1,5690,0,'','','Deprecated quest: <NYI> <TXT> A Touch of Voodoo'),
(1,5691,0,'','','Deprecated quest: <NYI> <TXT> In the Dark it was Created'),
(1,5692,0,'','','Deprecated quest: <NYI> In the Dark It was Created'),
(1,5693,0,'','','Deprecated quest: <NYI> In the Dark It was Created'),
(1,5694,0,'','','Deprecated quest: <UNUSED>'),
(1,5695,0,'','','Deprecated quest: <UNUSED>'),
(1,5696,0,'','','Deprecated quest: <UNUSED>'),
(1,5697,0,'','','Deprecated quest: <UNUSED>'),
(1,5698,0,'','','Deprecated quest: <NYI> <TXT> A Small Amount of Hope'),
(1,5699,0,'','','Deprecated quest: <NYI> A Small Amount of Hope'),
(1,5700,0,'','','Deprecated quest: <NYI> A Small Amount of Hope'),
(1,5701,0,'','','Deprecated quest: <NYI> <TXT> The Rites of Old'),
(1,5702,0,'','','Deprecated quest: <NYI> The Rites of Old'),
(1,5703,0,'','','Deprecated quest: <NYI> The Rites of Old'),
(1,5704,0,'','','Deprecated quest: <NYI> <TXT> Undead Priest Robe'),
(1,5705,0,'','','Deprecated quest: <NYI> No Longer a Shadow'),
(1,5706,0,'','','Deprecated quest: <NYI> No Longer a Shadow'),
(1,5707,0,'','','Deprecated quest: <NYI> <TXT> Flirting With Darkness'),
(1,5708,0,'','','Deprecated quest: <NYI> Flirting With Darkness'),
(1,5709,0,'','','Deprecated quest: <NYI> Flirting With Darkness'),
(1,5710,0,'','','Deprecated quest: <NYI> <TXT> Troll Priest Robe'),
(1,5711,0,'','','Deprecated quest: <NYI> The Lost Ways'),
(1,5712,0,'','','Deprecated quest: <NYI> The Lost Ways'),
(1,6003,0,'','','Deprecated quest: <nyi> <txt> Green With Envy'),
(1,6165,0,'','','Deprecated quest: <NYI> <TXT> Archmage Timolain''s Remains'),
(1,6202,0,'','','Deprecated quest: <UNUSED> Good and Evil'),
(1,6702,0,'','','Deprecated quest: <TXT> SF,RFK,GNOMER,BF'),
(1,6703,0,'','','Deprecated quest: <TXT> SF,RFK,GNOMER,BF - Repeatable'),
(1,6704,0,'','','Deprecated quest: <TXT> SM,RFD,ULD'),
(1,6705,0,'','','Deprecated quest: <TXT> SM,RFD,ULD - Repeatable'),
(1,6706,0,'','','Deprecated quest: <TXT> ZUL,ST,MAR'),
(1,6707,0,'','','Deprecated quest: <TXT> ZUL,ST,MAR - Repeatable'),
(1,6708,0,'','','Deprecated quest: <TXT> BRD,DM,BRS'),
(1,6709,0,'','','Deprecated quest: <TXT> BRD,DM,BRS - Repeatable'),
(1,6710,0,'','','Deprecated quest: <TXT> UBRS,STRATH,SCHOL'),
(1,6711,0,'','','Deprecated quest: <TXT> UBRS,STRATH,SCHOL - Repeatable'),
(1,6841,0,'','','Deprecated quest: <UNUSED>'),
(1,6842,0,'','','Deprecated quest: <UNUSED>'),
(1,7069,0,'','','Deprecated quest: <UNUSED>'),
(1,7904,0,'','','Deprecated quest: <UNUSED>'),
(1,8002,0,'','','Deprecated quest: Silverwing Sentinels <NYI> <TXT>'),
(1,8244,0,'','','Deprecated quest: <UNUSED>'),
(1,8245,0,'','','Deprecated quest: <UNUSED>'),
(1,8247,0,'','','Deprecated quest: <UNUSED>'),
(1,8248,0,'','','Deprecated quest: <UNUSED>'),
(1,8337,0,'','','Deprecated quest: <UNUSED>'),
(1,8339,0,'','','Deprecated quest: Royalty of the Council <NYI> <TXT> UNUSED'),
(1,8340,0,'','','Deprecated quest: Twilight Signet Ring <NYI> <TXT>'),
(1,8444,0,'','','Deprecated quest: <NYI> <TXT> gossip shade of ambermoon'),
(1,8445,0,'','','Deprecated quest: <NYI> <TXT> gossip shade of ambermoon'),
(1,8448,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8449,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8450,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8451,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8452,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8453,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8454,0,'','','Deprecated quest: <TXT> Mystery Reward'),
(1,8458,0,'','','Deprecated quest: <UNUSED>'),
(1,8459,0,'','','Deprecated quest: <UNUSED>'),
(1,8571,0,'','','Deprecated quest: <UNUSED> Armor Kits'),
(1,9031,0,'','','Deprecated quest: <TXT>Anthion''s Parting Words'),
(1,9306,0,'','','Deprecated quest: <DEPRECATED>Speak with Vindicator Aldar'),
(1,9307,0,'','','Deprecated quest: <DEPRECATED>Compassion'),
(1,9445,0,'','','Deprecated quest: <NYI><TXT>Placeholder: A Worthy Offering'),
(1,9596,0,'','','Deprecated quest: <DEPRECATED>Control'),
(1,9597,0,'','','Deprecated quest: <UNUSED>'),
(1,9599,0,'','','Deprecated quest: <UNUSED>'),
(1,9679,0,'','','Deprecated quest: <NYI>Return to Knight-Lord Bloodvalor'),
(1,9745,0,'','','Deprecated quest: <DEPRECATED>Suppressing the Flame'),
(1,10370,0,'','','Deprecated quest: Nazgrel''s Command <TXT>'),
(1,10402,0,'','','Deprecated quest: <TXT>'),
(1,10616,0,'','','Deprecated quest: <nyi>Breadcrumb'),
(1,10743,0,'','','Deprecated quest: [DEPRECATED]<txt>Hero of the Mok''Nathal'),
(1,10890,0,'','','Deprecated quest: [UNUSED] <NYI> '),
(1,11127,0,'','','Deprecated quest: <NYI>Thunderbrew Secrets');
 
-- TrinityCore\sql\updates\world\2012_08_04_01_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (3631,4487,4488,4489,4490,4183,4184,4185,4186,4223,4224,402,550,620,785,908,909,9662,11179,11461,12087,12103,12108,12156,12426,12682,12764,12765,24222,24227,10452,10453,11125,11179,11437,11438,11444,11445,11974,12179,12228,12233,12590,14119,14147,14148,14149,14150);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1, 402,0,'','','Deprecated quest: Sirra is Busy'), 
(1, 550,0,'','','Deprecated quest: Battle of Hillsbrad'), 
(1, 620,0,'','','Deprecated quest: The Monogrammed Sash'), 
(1, 785,0,'','','Deprecated quest: A Strategic Alliance'), 
(1, 908,0,'','','Deprecated quest: A Strategic Alliance'), 
(1, 909,0,'','','Deprecated quest: A Strategic Alliance'), 
(1,3631,0,'','','Deprecated quest: Summon Felsteed'),
(1,4487,0,'','','Deprecated quest: Summon Felsteed'),
(1,4488,0,'','','Deprecated quest: Summon Felsteed'),
(1,4489,0,'','','Deprecated quest: Summon Felsteed'),
(1,4490,0,'','','Deprecated quest: Summon Felsteed'),
(1,4183,0,'','','Deprecated quest: The True Masters'),
(1,4184,0,'','','Deprecated quest: The True Masters'),
(1,4185,0,'','','Deprecated quest: The True Masters'),
(1,4186,0,'','','Deprecated quest: The True Masters'),
(1,4223,0,'','','Deprecated quest: The True Masters'),
(1,4224,0,'','','Deprecated quest: The True Masters'),
-- some random ones:
(1, 9662,0,'','','Deprecated quest:Deprecated: Keanna''s Freedom'), 
(1,11179,0,'','','Deprecated quest:[Temporarily Deprecated Awaiting a New Mob]Finlay Is Gutless'), 
(1,11461,0,'','','Deprecated quest:DEPRECATED'), 
(1,12087,0,'','','Deprecated quest:A Little Help Here? DEPRECATED'), 
(1,12103,0,'','','Deprecated quest:DEPRECATED'), 
(1,12108,0,'','','Deprecated quest:DEPRECATED'), 
(1,12156,0,'','','Deprecated quest:DEPRECAED'), 
(1,12426,0,'','','Deprecated quest:DEPRECATED'), 
(1,12682,0,'','','Deprecated quest:Uncharted Territory (DEPRECATED)'), 
(1,12764,0,'','','Deprecated quest:The Secret to Kungaloosh (DEPRECATED)'), 
(1,12765,0,'','','Deprecated quest:Kungaloosh (DEPRECATED)'), 
(1,24222,0,'','','Deprecated quest:Call to Arms: Eye of the Storm DEPRECATED'), 
(1,24227,0,'','','Deprecated quest:DEPRECATED'), 
(1,10452,0,'','','Deprecated quest:DON''T USE [PH] Fel Orc 1'), 
(1,10453,0,'','','Deprecated quest:DON''T USE [PH] Fel Orc bread'), 
(1,11125,0,'','','Deprecated quest:[PH] New Hinterlands Quest'), 
(1,11437,0,'','','Deprecated quest:[PH] Beer Garden A'), 
(1,11438,0,'','','Deprecated quest:[PH] Beer Garden B'), 
(1,11444,0,'','','Deprecated quest:[PH] Beer Garden A'), 
(1,11445,0,'','','Deprecated quest:[PH] Beer Garden B'), 
(1,11974,0,'','','Deprecated quest:[ph] Now, When I Grow Up...'), 
(1,12179,0,'','','Deprecated quest:Specialization 1 [PH]'), 
(1,12228,0,'','','Deprecated quest:Reacquiring the Magic [PH]'), 
(1,12233,0,'','','Deprecated quest:[Depricated]Sewing Your Seed'), 
(1,12590,0,'','','Deprecated quest:Blahblah[PH]'), 
(1,14119,0,'','','Deprecated quest:Blank [PH]'), 
(1,14147,0,'','','Deprecated quest:Blank [PH]'), 
(1,14148,0,'','','Deprecated quest:Blank [PH]'), 
(1,14149,0,'','','Deprecated quest:Blank [PH]'), 
(1,14150,0,'','','Deprecated quest:Blank [PH]');
 
-- TrinityCore\sql\updates\world\2012_08_04_02_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (7790,8152,8237,8971,8972,8973,8974,8975,8976,9296,9750,10145,10207,10549,11493,11588,11589,11997,12313,13840,24797);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,7790,0,'','','Deprecated quest: REUSE'), 
(1,8152,0,'','','Deprecated quest: REUSE'), 
(1,8237,0,'','','Deprecated quest: REUSE'), 
(1,8971,0,'','','Deprecated quest: REUSE'), 
(1,8972,0,'','','Deprecated quest: REUSE'), 
(1,8973,0,'','','Deprecated quest: REUSE'), 
(1,8974,0,'','','Deprecated quest: REUSE'), 
(1,8975,0,'','','Deprecated quest: REUSE'), 
(1,8976,0,'','','Deprecated quest: REUSE'), 
(1,9296,0,'','','Deprecated quest: reuse'), 
(1,9750,0,'','','Deprecated quest: UNUSED Urgent Delivery'), 
(1,10145,0,'','','Deprecated quest: Mission: Sever the Tie UNUSED'), 
(1,10207,0,'','','Deprecated quest: Forward Base: Reaver''s Fall REUSE'), 
(1,10549,0,'','','Deprecated quest: REUSE'), 
(1,11493,0,'','','Deprecated quest: UNUSED'), 
(1,11588,0,'','','Deprecated quest: REUSE'), 
(1,11589,0,'','','Deprecated quest: REUSE'), 
(1,11997,0,'','','Deprecated quest: REUSE'), 
(1,12313,0,'','','Deprecated quest: UNUSED Save Brewfest!'), 
(1,13840,0,'','','Deprecated quest: REUSE'), 
(1,24797,0,'','','Deprecated quest: REUSE');
 
-- TrinityCore\sql\updates\world\2012_08_04_03_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (9754,9755,10215,11522,12445,12731,12923,13541,7797,7869,7870,7906,9378,9611,9880,9881,9908,9909,9949,9950,10088,10181,10214,10454,11197,11226,11577,11874,11937,12485,12600,13123,13210,13317,13990);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,9754,0,'','','Deprecated quest: '), 	
(1,9755,0,'','','Deprecated quest: '), 	
(1,10215,0,'','','Deprecated quest: '), 	
(1,11522,0,'','','Deprecated quest: '), 	
(1,12445,0,'','','Deprecated quest: '), 	
(1,12731,0,'','','Deprecated quest: '), 	
(1,12923,0,'','','Deprecated quest: '), 	
(1,13541,0,'','','Deprecated quest: '), 	
-- some others that contain a - 
(1,7797,0,'','','Deprecated quest: Dimensional Ripper - Everlook'), 
(1,7869,0,'','','Deprecated quest: test quest - do not use'), 
(1,7870,0,'','','Deprecated quest: test quest2 - do not use'), 
(1,7906,0,'','','Deprecated quest: Darkmoon Cards - Beasts'), 
(1,9378,0,'','','Deprecated quest: DND FLAG The Dread Citadel - Naxxramas'), 
(1,9611,0,'','','Deprecated quest: Azuremyst: aa - A - Quest Flag 000'), 
(1,9880,0,'','','Deprecated quest: Hellfire Penninsula: -pn - A - ToWoW - Hellfire Turnin Cap'), 
(1,9881,0,'','','Deprecated quest: Hellfire Penninsula: -pn - H - ToWoW - Hellfire Turnin Cap'), 
(1,9908,0,'','','Deprecated quest: Hellfire Penninsula: -pn - A - ToWoW - Hellfire Turnin'), 
(1,9909,0,'','','Deprecated quest: Hellfire Penninsula: -pn - H - ToWoW - Hellfire Turnin'), 
(1,9949,0,'','','Deprecated quest: A Bird''s-Eye View'), 
(1,9950,0,'','','Deprecated quest: A Bird''s-Eye View'), 
(1,10088,0,'','','Deprecated quest: When This Mine''s a-Rockin'''), 
(1,10181,0,'','','Deprecated quest: Collector''s Edition: -pn - E - FLAG'), 
(1,10214,0,'','','Deprecated quest: When This Mine''s a-Rockin'''), 
(1,10454,0,'','','Deprecated quest: FLAG - OFF THE RAILS'), 
(1,11197,0,'','','Deprecated quest: ZZOLD Upper Deck Promo - Ghost Wolf Mount OLD'), 
(1,11226,0,'','','Deprecated quest: Upper Deck Promo - Spectral Tiger Mount'), 
(1,11577,0,'','','Deprecated quest: WoW Collector''s Edition: - DEM - E - FLAG'), 
(1,11874,0,'','','Deprecated quest: Upper Deck Promo - Rocket Mount'), 
(1,11937,0,'','','Deprecated quest: FLAG - all torch return quests are complete'), 
(1,12485,0,'','','Deprecated quest: Howling Fjord: aa - A - LK FLAG'), 
(1,12600,0,'','','Deprecated quest: Upper Deck Promo - Bear Mount'), 
(1,13123,0,'','','Deprecated quest: WotLK Collector''s Edition: - DEM - E - FLAG'), 
(1,13210,0,'','','Deprecated quest: Blizzard Account: - DEM - E - FLAG'), 
(1,13317,0,'','','Deprecated quest: ----'), 
(1,13990,0,'','','Deprecated quest: Upper Deck Promo - Chicken Mount'); 
 
-- TrinityCore\sql\updates\world\2012_08_04_04_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (11335,11336,11337,11338,11339,11340,11341,11342,13405,13407,13427,13428,14163,14164,14178,14179,14180,14181,14182,14183,24216,24217,24218,24219,24220,24221,24223,24224,24225,24226,24426,24427);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,11335,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,11336,0,'','','Deprecated quest: Call to Arms: Alterac Valley'), 
(1,11337,0,'','','Deprecated quest: Call to Arms: Eye of the Storm'), 
(1,11338,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,11339,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,11340,0,'','','Deprecated quest: Call to Arms: Alterac Valley'), 
(1,11341,0,'','','Deprecated quest: Call to Arms: Eye of the Storm'), 
(1,11342,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,13405,0,'','','Deprecated quest: Call to Arms: Strand of the Ancients'), 
(1,13407,0,'','','Deprecated quest: Call to Arms: Strand of the Ancients'), 
(1,13427,0,'','','Deprecated quest: Call to Arms: Alterac Valley'), 
(1,13428,0,'','','Deprecated quest: Call to Arms: Alterac Valley'), 
(1,14163,0,'','','Deprecated quest: Call to Arms: Isle of Conquest'), 
(1,14164,0,'','','Deprecated quest: Call to Arms: Isle of Conquest'), 
(1,14178,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,14179,0,'','','Deprecated quest: Call to Arms: Eye of the Storm'), 
(1,14180,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,14181,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,14182,0,'','','Deprecated quest: Call to Arms: Eye of the Storm'), 
(1,14183,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24216,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24217,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24218,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24219,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24220,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,24221,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,24223,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,24224,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24225,0,'','','Deprecated quest: Call to Arms: Warsong Gulch'), 
(1,24226,0,'','','Deprecated quest: Call to Arms: Arathi Basin'), 
(1,24426,0,'','','Deprecated quest: Call to Arms: Alterac Valley'), 
(1,24427,0,'','','Deprecated quest: Call to Arms: Alterac Valley');
 
-- TrinityCore\sql\updates\world\2012_08_04_05_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (8384,8386,8389,8390,8391,8392,8397,8398,8404,8405,8406,8407,8408,8431,8432,8433,8434,8435,8440,8441,8442,8443,8567,8568,8569,8570);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,8384,0,'','','Deprecated quest: Claiming Arathi Basin'), 
(1,8386,0,'','','Deprecated quest: Fight for Warsong Gulch'), 
(1,8389,0,'','','Deprecated quest: Battle of Warsong Gulch'), 
(1,8390,0,'','','Deprecated quest: Conquering Arathi Basin'), 
(1,8391,0,'','','Deprecated quest: Claiming Arathi Basin'), 
(1,8392,0,'','','Deprecated quest: Claiming Arathi Basin'), 
(1,8397,0,'','','Deprecated quest: Claiming Arathi Basin'), 
(1,8398,0,'','','Deprecated quest: Claiming Arathi Basin'), 
(1,8404,0,'','','Deprecated quest: Fight for Warsong Gulch'), 
(1,8405,0,'','','Deprecated quest: Fight for Warsong Gulch'), 
(1,8406,0,'','','Deprecated quest: Fight for Warsong Gulch'), 
(1,8407,0,'','','Deprecated quest: Fight for Warsong Gulch'), 
(1,8408,0,'','','Deprecated quest: Fight for Warsong Gulch'), 
(1,8431,0,'','','Deprecated quest: Battle of Warsong Gulch'), 
(1,8432,0,'','','Deprecated quest: Battle of Warsong Gulch'), 
(1,8433,0,'','','Deprecated quest: Battle of Warsong Gulch'), 
(1,8434,0,'','','Deprecated quest: Battle of Warsong Gulch'), 
(1,8435,0,'','','Deprecated quest: Battle of Warsong Gulch'), 
(1,8440,0,'','','Deprecated quest: Conquering Arathi Basin'), 
(1,8441,0,'','','Deprecated quest: Conquering Arathi Basin'), 
(1,8442,0,'','','Deprecated quest: Conquering Arathi Basin'), 
(1,8443,0,'','','Deprecated quest: Conquering Arathi Basin'), 
(1,8567,0,'','','Deprecated quest: Past Victories in Warsong Gulch'), 
(1,8568,0,'','','Deprecated quest: Past Victories in Warsong Gulch'), 
(1,8569,0,'','','Deprecated quest: Past Efforts in Warsong Gulch'), 
(1,8570,0,'','','Deprecated quest: Past Efforts in Warsong Gulch'); 
 
-- TrinityCore\sql\updates\world\2012_08_04_06_world_quest_template.sql 
UPDATE `quest_template` SET `specialflags`= `specialflags`|8 WHERE `id` IN (
24889, -- Classic Random 5-15 (Nth)
24890, -- Classic Random 15-25 (Nth)
24891, -- Classic Random 24-34 (Nth)
24892, -- Classic Random 35-45 (Nth)
24893, -- Classic Random 46-55 (Nth)
24894, -- Classic Random 56-60 (Nth)
24895, -- Classic Random 60-64 (Nth)
24896); -- Classic Random 65-70 (Nth)

 
-- TrinityCore\sql\updates\world\2012_08_04_07_world_game_event_creature_quest.sql 
-- Hordes's Honor the Flame
-- Add missing creature_quesrelation and involvedrealation that were blocking quests
DELETE FROM `game_event_creature_quest` WHERE `quest` IN (11846,11845,11852,11839,11859,11841,11851,11855,11835,11858,11863,13500,13493,13494,13495,13496,13497,13498,13499,11850,11848,11853,11857,11837,11844,11860,11584,11862,11842,11840);
INSERT INTO `game_event_creature_quest` (`eventEntry`,`id`, `quest`) VALUES
-- Flame Keeper of Eastern Kingdom? {Achievement=1025}
(1,25933, 11850), -- Ghostland
(1,25931, 11848), -- Eversong woods
(1,25935, 11853), -- Hillsbrad Foothills
(1,25941, 11857), -- Swamp of sorrows
(1,25920, 11837), -- Cape of Stranglethorn
(1,25927, 11844), -- Burning Steppes
(1,25944, 11860), -- The Hinterlands
(1,25939, 11584), -- Silverpine Forest
(1,25946, 11862), -- Tirisfal Glades
(1,25925, 11842), -- Badlands
(1,25923, 11840), -- Arathi Highlands
-- The Flame Keeper of Kalimdore - {Achievement=1026}
(1,25929, 11846), -- Durotar
(1,25928, 11845), -- Desolace
(1,25936, 11852), -- Mulgore
(1,25922, 11839), -- Winterspring
(1,25943, 11859), -- Barrens
(1,25884, 11841), -- Ashenvale
-- The Flame Keeper of Outland - {Achievement=1027}
(1,25934, 11851), -- Hellfire Peninsula
(1,25938, 11855), -- Shadowmoon Valley
(1,25918, 11835), -- Netherstorm
(1,25942, 11858), -- Terokkar
(1,25947, 11863), -- Terokkar
-- Flame Keeper of Northrend - {Achievement=6009}
(1,32816, 13500), -- Zul'Drak
(1,32809, 13493), -- Borean Tundra
(1,32810, 13494), -- Sholazar Basin
(1,32811, 13495), -- Dragonblight
(1,32815, 13499), -- Crystalsong Forest
(1,32814, 13498), -- Storm Peaks
(1,32813, 13497), -- Grizzly Hills
(1,32812, 13496); -- Howling Fjords
-- add missing quest-involved relations
DELETE FROM `creature_involvedrelation` WHERE `quest` IN (11846,11845,11852,11839,11859,11841,11851,11855,11835,11858,11863,13500,13493,13494,13495,13496,13497,13498,13499,11850,11848,11853,11857,11837,11844,11860,11584,11862,11842,11840);
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES
(25929, 11846), -- Durotar
(25928, 11845), -- Desolace
(25936, 11852), -- Mulgore
(25922, 11839), -- Winterspring
(25943, 11859), -- Barrens
(25884, 11841), -- Ashenvale
(25934, 11851), -- Hellfire Peninsula
(25938, 11855), -- Shadowmoon Valley
(25918, 11835), -- Netherstorm
(25942, 11858), -- Terokkar
(25947, 11863), -- Terokkar
(32816, 13500), -- Zul'Drak
(32809, 13493), -- Borean Tundra
(32810, 13494), -- Sholazar Basin
(32811, 13495), -- Dragonblight
(32815, 13499), -- Crystalsong Forest
(32814, 13498), -- Storm Peaks
(32813, 13497), -- Grizzly Hills
(32812, 13496), -- Howling Fjords
(25933, 11850), -- Ghostland
(25931, 11848), -- Eversong woods
(25935, 11853), -- Hillsbrad Foothills
(25941, 11857), -- Swamp of sorrows
(25920, 11837), -- Cape of Stranglethorn
(25927, 11844), -- Burning Steppes
(25944, 11860), -- The Hinterlands
(25939, 11584), -- Silverpine Forest
(25946, 11862), -- Tirisfal Glades
(25925, 11842), -- Badlands
(25923, 11840); -- Arathi Highlands
-- update quest texts and rewardcash
UPDATE `quest_template` SET `RewardOrRequiredMoney`=37000,`RewardMoneyMaxLevel`=66300, `OfferRewardText`='Honor the Durotar flame!' WHERE `Id`=11846;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Mulgore flame!' WHERE `Id`=11852;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Barrens flame!',`RewardOrRequiredMoney`=37000, `RewardMoneyMaxLevel`=66300 WHERE `Id`=11859; -- Barrens
UPDATE `quest_template` SET `OfferRewardText`='Honor the Tanaris flame!',`RequestItemsText`='' WHERE `Id`=11838 LIMIT 1;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Ashenvale flame!' WHERE `Id`=11841;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Winterspring flame!' WHERE `Id`=11839;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Desolace flame!' WHERE `Id`=11845;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Thousand Needles flame!' WHERE `Id`=11861;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Feralas flame!' WHERE `Id`=11849;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Dustwallow Marsh flame!' WHERE `Id`=11847;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Silithus flame!' WHERE `Id`=11836;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Stonetalon Mountains flame!' WHERE `Id`=11856;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Hellfire Peninsula flame!' WHERE `Id`=11851;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Shadowmoon Valley flame!' WHERE `Id`=11855;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Nagrand flame!', `RequestItemsText`='' WHERE `Id`=11821;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Netherstorm flame!' WHERE `Id`=11835;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Blades Edge Mountains flame! ', `RequestItemsText`='' WHERE `Id`=11843;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Terokkar flame!' WHERE `Id`=11858;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Zangarmarsh flame!' WHERE `Id`=11863;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Zul''Drak flame!' WHERE `Id`=13500;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Borean Tundra flame!' WHERE `Id`=13493;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Sholazar Basin flame!' WHERE `Id`=13494;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Dragonblight flame!' WHERE `Id`=13495;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Crystalsong Forest flame!' WHERE `Id`=13499;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Storm Peaks flame!' WHERE `Id`=13498;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Grizzly Hills flame!' WHERE `Id`=13497;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Howling Fjords flame!' WHERE `Id`=13496;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Ghostland flame!' WHERE `Id`=11850;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Eversong woods flame!' WHERE `Id`=11848;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Hillsbrad Foothills flame!' WHERE `Id`=11853;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Swamp of sorrows flame!' WHERE `Id`=11857;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Cape of Stranglethorn flame!' WHERE `Id`=11837;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Burning Steppes flame!' WHERE `Id`=11844;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Hinterlands flame!' WHERE `Id`=11860;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Silverpine Forest flame!' WHERE `Id`=11584;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Tirisfal Glades flame!' WHERE `Id`=11862;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Badlands flame!' WHERE `Id`=11842;
UPDATE `quest_template` SET `OfferRewardText`='Honor the Arathi Highlands flame!' WHERE `Id`=11840;
 
-- TrinityCore\sql\updates\world\2012_08_04_08_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (9034,9036,9037,9038,9039,9040,9041,9042,9043,9044,9046,9047,9048,9049,9050,9054,9055,9056,9057,9058,9059,9060,9061,9068,9069,9070,9071,9072,9073,9074,9075,9077,9078,9079,9080,9081,9082,9083,9084,9086,9087,9088,9089,9090,9091,9092,9093,9095,9096,9097,9098,9099,9100,9101,9102,9103,9104,9105,9106,9107,9108,9109,9110);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,9034,0,'','','Deprecated quest: Dreadnaught Breastplate'),
(1,9036,0,'','','Deprecated quest: Dreadnaught Legplates'),
(1,9037,0,'','','Deprecated quest: Dreadnaught Helmet'),
(1,9038,0,'','','Deprecated quest: Dreadnaught Pauldrons'),
(1,9039,0,'','','Deprecated quest: Dreadnaught Sabatons'),
(1,9040,0,'','','Deprecated quest: Dreadnaught Gauntlets'),
(1,9041,0,'','','Deprecated quest: Dreadnaught Waistguard'),
(1,9042,0,'','','Deprecated quest: Dreadnaught Bracers'),
(1,9043,0,'','','Deprecated quest: Redemption Tunic'),
(1,9044,0,'','','Deprecated quest: Redemption Legguards'),
(1,9046,0,'','','Deprecated quest: Redemption Spaulders'),
(1,9047,0,'','','Deprecated quest: Redemption Boots'),
(1,9048,0,'','','Deprecated quest: Redemption Handguards'),
(1,9049,0,'','','Deprecated quest: Redemption Girdle'),
(1,9050,0,'','','Deprecated quest: Redemption Wristguards'),
(1,9054,0,'','','Deprecated quest: Cryptstalker Tunic'),
(1,9055,0,'','','Deprecated quest: Cryptstalker Legguards'),
(1,9056,0,'','','Deprecated quest: Cryptstalker Headpiece'),
(1,9057,0,'','','Deprecated quest: Cryptstalker Spaulders'),
(1,9058,0,'','','Deprecated quest: Cryptstalker Boots'),
(1,9059,0,'','','Deprecated quest: Cryptstalker Handguards'),
(1,9060,0,'','','Deprecated quest: Cryptstalker Girdle'),
(1,9061,0,'','','Deprecated quest: Cryptstalker Wristguards'),
(1,9068,0,'','','Deprecated quest: Earthshatter Tunic'),
(1,9069,0,'','','Deprecated quest: Earthshatter Legguards'),
(1,9070,0,'','','Deprecated quest: Earthshatter Headpiece'),
(1,9071,0,'','','Deprecated quest: Earthshatter Spaulders'),
(1,9072,0,'','','Deprecated quest: Earthshatter Boots'),
(1,9073,0,'','','Deprecated quest: Earthshatter Handguards'),
(1,9074,0,'','','Deprecated quest: Earthshatter Girdle'),
(1,9075,0,'','','Deprecated quest: Earthshatter Wristguards'),
(1,9077,0,'','','Deprecated quest: Bonescythe Breastplate'),
(1,9078,0,'','','Deprecated quest: Bonescythe Legplates'),
(1,9079,0,'','','Deprecated quest: Bonescythe Helmet'),
(1,9080,0,'','','Deprecated quest: Bonescythe Pauldrons'),
(1,9081,0,'','','Deprecated quest: Bonescythe Sabatons'),
(1,9082,0,'','','Deprecated quest: Bonescythe Gauntlets'),
(1,9083,0,'','','Deprecated quest: Bonescythe Waistguard'),
(1,9084,0,'','','Deprecated quest: Bonescythe Bracers'),
(1,9086,0,'','','Deprecated quest: Dreamwalker Tunic'),
(1,9087,0,'','','Deprecated quest: Dreamwalker Legguards'),
(1,9088,0,'','','Deprecated quest: Dreamwalker Headpiece'),
(1,9089,0,'','','Deprecated quest: Dreamwalker Spaulders'),
(1,9090,0,'','','Deprecated quest: Dreamwalker Boots'),
(1,9091,0,'','','Deprecated quest: Dreamwalker Handguards'),
(1,9092,0,'','','Deprecated quest: Dreamwalker Girdle'),
(1,9093,0,'','','Deprecated quest: Dreamwalker Wristguards'),
(1,9095,0,'','','Deprecated quest: Frostfire Robe'),
(1,9096,0,'','','Deprecated quest: Frostfire Leggings'),
(1,9097,0,'','','Deprecated quest: Frostfire Circlet'),
(1,9098,0,'','','Deprecated quest: Frostfire Shoulderpads'),
(1,9099,0,'','','Deprecated quest: Frostfire Sandals'),
(1,9100,0,'','','Deprecated quest: Frostfire Gloves'),
(1,9101,0,'','','Deprecated quest: Frostfire Belt'),
(1,9102,0,'','','Deprecated quest: Frostfire Bindings'),
(1,9103,0,'','','Deprecated quest: Plagueheart Robe'),
(1,9104,0,'','','Deprecated quest: Plagueheart Leggings'),
(1,9105,0,'','','Deprecated quest: Plagueheart Circlet'),
(1,9106,0,'','','Deprecated quest: Plagueheart Shoulderpads'),
(1,9107,0,'','','Deprecated quest: Plagueheart Sandals'),
(1,9108,0,'','','Deprecated quest: Plagueheart Gloves'),
(1,9109,0,'','','Deprecated quest: Plagueheart Belt'),
(1,9110,0,'','','Deprecated quest: Plagueheart Bindings');
 
-- TrinityCore\sql\updates\world\2012_08_04_09_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (9111,9112,9113,9114,9115,9116,9117,9118);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1,9111,0,'','','Deprecated quest: Robe of Faith'),
(1,9112,0,'','','Deprecated quest: Leggings of Faith'),
(1,9113,0,'','','Deprecated quest: Circlet of Faith'),
(1,9114,0,'','','Deprecated quest: Shoulderpads of Faith'),
(1,9115,0,'','','Deprecated quest: Sandals of Faith'),
(1,9116,0,'','','Deprecated quest: Gloves of Faith'),
(1,9117,0,'','','Deprecated quest: Belt of Faith'),
(1,9118,0,'','','Deprecated quest: Bindings of Faith');
 
-- TrinityCore\sql\updates\world\2012_08_04_10_world_disables.sql 
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (2018,5101,7681,7682,8230,8270,8274,9284,9285,9286,9577,9583,11121,11994,12015,12493,12911,13649,14106,9713,9926,11087,11115,11116,11353,11518,12186,12187,12494,12845,13807,14185,14186,14187,24808,24809,24810,24811,25238);
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
-- containing "test"
(1,2018,0,'','','Deprecated quest: Rokar''s Test'),
(1,5101,0,'','','Deprecated quest: Lee''s Ultimate Test Quest... of Doom!'),
(1,7681,0,'','','Deprecated quest: Hunter test quest'),
(1,7682,0,'','','Deprecated quest: Hunter test quest2'),
(1,8230,0,'','','Deprecated quest: Collin''s Test Quest'),
(1,8270,0,'','','Deprecated quest: test copy quest'),
(1,8274,0,'','','Deprecated quest: Test Kill Quest'),
(1,9284,0,'','','Deprecated quest: Aldor Faction Test'),
(1,9285,0,'','','Deprecated quest: Consortium Faction Test'),
(1,9286,0,'','','Deprecated quest: Scryers Faction Test'),
(1,9577,0,'','','Deprecated quest: DAILY TEST QUEST (PVP)'),
(1,9583,0,'','','Deprecated quest: Omar''s Test Quest'),
(1,11121,0,'','','Deprecated quest: DAILY TEST QUEST (RAID)'),
(1,11994,0,'','','Deprecated quest: Juno''s Flag Tester'),
(1,12015,0,'','','Deprecated quest: Test Quest for Craig'),
(1,12493,0,'','','Deprecated quest: PvP Test'),
(1,12911,0,'','','Deprecated quest: Kill Credit Test'),
(1,13649,0,'','','Deprecated quest: Justin''s Fun Test'),
(1,14106,0,'','','Deprecated quest: Na Kada''s Quest Test'), 
-- containing "flag" 
(1,9713,0,'','','Deprecated quest: Glowcap Harvesting Enabling Flag'),
(1,9926,0,'','','Deprecated quest: FLAG Shadow Council/Warmaul Questline'),
(1,11087,0,'','','Deprecated quest: HYJAL FLAG'),
(1,11115,0,'','','Deprecated quest: The Mark of Vashj (FLAG ONLY)'),
(1,11116,0,'','','Deprecated quest: Trial of the Naaru: (QUEST FLAG)'),
(1,11353,0,'','','Deprecated quest: FLAG: Got the work shirt'),
(1,11518,0,'','','Deprecated quest: Sunwell Daily Portal Flag'),
(1,12186,0,'','','Deprecated quest: FLAG: Winner'),
(1,12187,0,'','','Deprecated quest: FLAG: Participant'),
(1,12494,0,'','','Deprecated quest: FLAG: Riding Trainer Advertisement (20)'),
(1,12845,0,'','','Deprecated quest: Dalaran Teleport Crystal Flag'),
(1,13807,0,'','','Deprecated quest: FLAG: Tournament Invitation'),
(1,14185,0,'','','Deprecated quest: FLAG: Riding Trainer Advertisement (40)'),
(1,14186,0,'','','Deprecated quest: FLAG: Riding Trainer Advertisement (60)'),
(1,14187,0,'','','Deprecated quest: FLAG: Riding Trainer Advertisement (70)'),
(1,24808,0,'','','Deprecated quest: Tank Ring Flag'),
(1,24809,0,'','','Deprecated quest: Healer Ring Flag'),
(1,24810,0,'','','Deprecated quest: Melee Ring Flag'),
(1,24811,0,'','','Deprecated quest: Caster Ring Flag'),
(1,25238,0,'','','Deprecated quest: Strength Ring Flag');
 
-- TrinityCore\sql\updates\world\2012_08_04_11_world_game_event_creature_quest.sql 
--  Add all quests connected with Midsummer Fire Festival that are to be reseted on each next year to game_event_seasonal_questrelation, so players can complete them on and on... /as of different festivals/.
DELETE FROM `game_event_seasonal_questrelation` WHERE `questId` IN (11846,11845,11852,11839,11859,11841,11849,11861,11847,11836,11838,11856,11850,11848,11853,11857,11837,11844,11860,11584,11862,11842,11840,11851,11855,11835,11858,11863,11821,11854,11843,13500,13493,13494,13495,13496,13497,13498,13499,11805,11812,11815,11834,11833,11831,11817,11811,11806,11809,11826,11824,11826,11827,11819,11583,11828,11816,11810,11808,11804,11832,11813,11814,11820,11822,11823,11821,11830,11818,11825,11807,11829,13485,13487,13489,13488,13490,13486,13491,13492,11770,11769,11777,11803,11783,11773,11765,11771,11785,11800,11780,11802,11774,11772,11776,11781,11801,11768,11784,11580,11786,11766,11764,11775,11779,11799,11782,11787,11767,11778,13458,13441,13450,13451,13457,13455,13454,13453,11734,11741,11744,11763,11762,11760,11746,11740,11735,11738,11753,11755,11756,11748,11581,11757,11745,11739,11737,11732,11761,11742,11743,11749,11751,11752,11750,11759,11747,11754,11736,11758,13440,13443,13445,13444,13449,13446,13442,13447,13431,9324,11935,9326,9325,9332,9331,9330,11933,11972);
INSERT INTO `game_event_seasonal_questrelation` (`questId`, `eventEntry`) VALUES
(11846,1), -- Durotar // Honor the Flame (Horde) - Kalimdor
(11845,1), -- Desolace
(11852,1), -- Mulgore
(11839,1), -- Winterspring
(11859,1), -- Barrens
(11849,1), -- Feralas
(11841,1), -- Ashenvale
(11847,1), -- Dustwallow marsh
(11861,1), -- Thousand Needles
(11856,1), -- Stonetalon Mountains
(11836,1), -- Silithus
(11838,1), -- Tanaris
(11850,1), -- Ghostland // Honor the Flame (Horde) - Eeastern Kingdoms
(11848,1), -- Eversong woods
(11853,1), -- Hillsbrad Foothills
(11857,1), -- Swamp of sorrows
(11837,1), -- Cape of Stranglethorn
(11844,1), -- Burning Steppes
(11860,1), -- The Hinterlands
(11584,1), -- Silverpine Forest
(11862,1), -- Tirisfal Glades
(11842,1), -- Badlands
(11840,1), -- Arathi Highlands
(11851,1), -- Hellfire Peninsula // Honor the Flame (Horde) - Outland
(11855,1), -- Shadowmoon Valley
(11835,1), -- Netherstorm
(11858,1), -- Terokkar
(11863,1), -- Zangarmarsh
(11854,1), -- Nagrand
(11843,1), -- Blade''s Edge Mountains
(13500,1), -- Zul'Drak // Honor the Flame (Horde) - Northrend
(13493,1), -- Borean Tundra
(13494,1), -- Sholazar Basin
(13495,1), -- Dragonblight
(13499,1), -- Crystalsong Forest
(13498,1), -- Storm Peaks
(13497,1), -- Grizzly Hills
(13496,1), -- Howling Fjords
(11805,1), -- Ashenvale // Honor the Flame (Alliance) - Kalimdor
(11812,1), -- Desolace
(11815,1), -- Dustwallow Marsh
(11834,1), -- Winterspring
(11833,1), -- Tanaris
(11831,1), -- Silithus
(11817,1), -- Feralas
(11811,1), -- Darkshore
(11806,1), -- Azuremyst Isle
(11809,1), -- Bloodmyst Isle
(11824,1), -- Teldrassil
(11826,1), -- The Hinterlands // Honor the Flame (Alliance) - Eeastern Kingdoms
(11827,1), -- The Western Plaguelands
(11819,1), -- Hillsbrad Foothills
(11583,1), -- Westfall
(11828,1), -- Wetlands
(11816,1), -- Elwynn Forest
(11810,1), -- Burning Steppes
(11808,1), -- Blasted Lands
(11804,1), -- Arathi Highlands
(11832,1), -- Cape of Stranglethorn
(11813,1), -- Dun Morogh
(11814,1), -- Duskwood
(11820,1), -- Loch Modan
(11822,1), -- Redridge Mountains
(11823,1), -- Shadowmoon Valley // Honor the Flame (Alliance) - Outland
(11821,1), -- Nagrand
(11830,1), -- Netherstorm
(11818,1), -- Hellfire Peninsula
(11825,1), -- Terokkar
(11807,1), -- Blade's Edge
(11829,1), -- Zangarmarsh
(13485,1), -- Borean Tundra // Honor the Flame (Alliance) - Northrend
(13487,1), -- Dragonblight
(13489,1), -- Grizzly Hills
(13488,1), -- Howling Fjord
(13492,1), -- Zul'Drak
(13490,1), -- The Storm Peaks
(13486,1), -- Sholazar Basin
(13491,1), -- Crystalsong Forest
(11770,1), -- Durotar // Desecrate the Flame (Alliance) - Kalimdor
(11769,1), -- Desolace
(11777,1), -- Mulgore
(11803,1), -- Winterspring
(11783,1), -- Barrens
(11773,1), -- Feralas
(11765,1), -- Ashenvale
(11771,1), -- Dustwallow marsh
(11785,1), -- Thousand Needles
(11800,1), -- Silithus
(11780,1), -- Stonetalon Mountains
(11802,1), -- Tanaris
(11774,1), -- Ghostland // Desecrate the Flame (Alliance) - Eastern Kingdoms
(11772,1), -- Eversong woods
(11776,1), -- Hillsbrad Foothills
(11781,1), -- Swamp of sorrows
(11801,1), -- Cape of Stranglethorn
(11768,1), -- Burning Steppes
(11784,1), -- The Hinterlands
(11580,1), -- Silverpine Forest
(11786,1), -- Tirisfal Glades
(11766,1), -- Badlands
(11764,1), -- Arathi Highlands
(11775,1), -- Hellfire Peninsula // Desecrate the Flame (Alliance) - Outland
(11779,1), -- Shadowmoon Valley
(11799,1), -- Netherstorm
(11782,1), -- Terokkar
(11787,1), -- Zangarmarsh
(11767,1), -- Blade' Edge
(11778,1), -- Nagrand
(13458,1), -- Zul'Drak // Desecrate the Flame (Alliance) - Northrend
(13441,1), -- Borean Tundra
(13450,1), -- Sholazar Basin
(13451,1), -- Dragonblight
(13457,1), -- Crystalsong Forest
(13455,1), -- Storm Peaks
(13454,1), -- Grizzly Hills
(13453,1), -- Howling Fjords
(11734,1), -- Ashenvale // Desecrate the Flame (Horde) - Kalimdor
(11741,1), -- Desolace
(11744,1), -- Dustwallow Marsh
(11763,1), -- Winterspring
(11762,1), -- Tanaris
(11760,1), -- Silithus
(11746,1), -- Feralas
(11740,1), -- Darkshore
(11735,1), -- Azuremyst Isle
(11738,1), -- Bloodmyst Isle
(11753,1), -- Teldrassil
(11755,1), -- The Hinterlands // Desecrate the Flame (Horde) - Eastern Kingdoms
(11756,1), -- The Western Plaguelands
(11748,1), -- Hillsbrad Foothills
(11581,1), -- Westfall
(11757,1), -- Wetlands
(11745,1), -- Elwynn Forest
(11739,1), -- Burning Steppes
(11737,1), -- Blasted Lands
(11732,1), -- Arathi Highlands
(11761,1), -- Cape of Stranglethorn
(11742,1), -- Dun Morogh
(11743,1), -- Duskwood
(11749,1), -- Loch Modan
(11751,1), -- Redridge Mountains
(11752,1), -- Shadowmoon Valley // Desecrate the Flame (Horde) - Outland
(11750,1), -- Nagrand
(11759,1), -- Netherstorm
(11747,1), -- Hellfire Peninsula
(11754,1), -- Terokkar
(11736,1), -- Blade's Edge
(11758,1), -- Zangarmarsh
(13440,1), -- Borean Tundra // Desecrate the Flame (Horde) - Northrend
(13443,1), -- Dragonblight
(13445,1), -- Grizzly
(13444,1), -- Howling Fjord
(13449,1), -- Zul'Drak
(13446,1), -- The Storm Peaks
(13442,1), -- Sholazar Basin
(13447,1), -- Crystalsong Forest
(11972,1), -- Shards of Ahune
(9324,1), -- Stealing Orgrimmar''s Flame
(11935,1), -- Stealing Silvermoon''s Flame
(9326,1), -- Stealing the Undercity''s Flame
(9325,1), -- Stealing Thunder Bluff''s Flame
(9332,1), -- Stealing Darnassus''s Flame
(9331,1), -- Stealing Ironforge''s Flame
(9330,1), -- Stealing Stormwind''s Flame
(11933,1); -- Stealing the Exodar''s Flame
--  Add quest relations to game_event_gameobject_quest and game_event_creature_quest
DELETE FROM `game_event_creature_quest` WHERE `quest` IN (11846,11845,11852,11839,11859,11841,11849,11861,11847,11836,11838,11856,11850,11848,11853,11857,11837,11844,11860,11584,11862,11842,11840,11851,11855,11835,11858,11863,11821,11854,11843,13500,13493,13494,13495,13496,13497,13498,13499,11805,11812,11815,11834,11833,11831,11817,11811,11806,11809,11826,11824,11826,11827,11819,11583,11828,11816,11810,11808,11804,11832,11813,11814,11820,11822,11823,11821,11830,11818,11825,11807,11829,13485,13487,13489,13488,13490,13486,13491,13492,11805,11812,11815,11834,11833,11831,11817,11811,11806,11809,11824,11826,11827,11819,11583,11828,11816,11810,11808,11804,11832,11813,11814,11820,11822,13485,13487,13489,13488,13490,13486,13491,13490,11823,11821,11830,11818,11825,11807,11829,11775,11917,11947,11948,11952,11953,11954,11886,11891,12012,11955,11696,11691,11971,11970,11966,11964,11922,11923,11926,11925,11731,11657,11921,11924,9339,9365);
INSERT INTO `game_event_creature_quest` (`eventEntry`,`id`, `quest`) VALUES
(1,25929, 11846), -- Durotar // Honor the Flame (Horde) - Kalimdor
(1,25928, 11845), -- Desolace
(1,25936, 11852), -- Mulgore
(1,25922, 11839), -- Winterspring
(1,25943, 11859), -- Barrens
(1,25932, 11849), -- Feralas
(1,25884, 11841), -- Ashenvale
(1,25930, 11847), -- Dustwallow marsh
(1,25945, 11861), -- Thousand Needles
(1,25919, 11836), -- Silithus
(1,25921, 11838), -- Tanaris
(1,25940, 11856), -- Stonetalon Mountains
(1,25934, 11851), -- Hellfire Peninsula // Honor the Flame (Horde) - Outland
(1,25938, 11855), -- Shadowmoon Valley
(1,25918, 11835), -- Netherstorm
(1,25942, 11858), -- Terokkar
(1,25947, 11863), -- Zangarmarsh
(1,25937, 11854), -- Nagrand
(1,25926, 11843), -- Blade''s Edge Mountains
(1,32816, 13500), -- Zul'Drak // Honor the Flame (Horde) - Northrend
(1,32809, 13493), -- Borean Tundra
(1,32810, 13494), -- Sholazar Basin
(1,32811, 13495), -- Dragonblight
(1,32815, 13499), -- Crystalsong Forest
(1,32814, 13498), -- Storm Peaks
(1,32813, 13497), -- Grizzly Hills
(1,32812, 13496), -- Howling Fjords
(1,25933, 11850), -- Ghostland // Honor the Flame (Horde) - Eastern Kingdoms
(1,25931, 11848), -- Eversong woods
(1,25935, 11853), -- Hillsbrad Foothills
(1,25941, 11857), -- Swamp of sorrows
(1,25920, 11837), -- Cape of Stranglethorn
(1,25927, 11844), -- Burning Steppes
(1,25944, 11860), -- The Hinterlands
(1,25939, 11584), -- Silverpine Forest
(1,25946, 11862), -- Tirisfal Glades
(1,25925, 11842), -- Badlands
(1,25923, 11840), -- Arathi Highlands
(1,25883, 11805), -- Ashenvale // Honor the Flame (Alliance) - Kalimdor
(1,25894, 11812), -- Desolace
(1,25897, 11815), -- Dustwallow Marsh
(1,25917, 11834), -- Winterspring
(1,25916, 11833), -- Tanaris
(1,25914, 11831), -- Silithus
(1,25899, 11817), -- Feralas
(1,25893, 11811), -- Darkshore
(1,25888, 11806), -- Azuremyst Isle
(1,25891, 11809), -- Bloodmyst Isle
(1,25906, 11824), -- Teldrassil
(1,25908, 11826), -- The Hinterlands // Honor the Flame (Alliance) - Eeastern Kingdoms
(1,25909, 11827), -- The Western Plaguelands
(1,25901, 11819), -- Hillsbrad Foothills
(1,25910, 11583), -- Westfall
(1,25911, 11828), -- Wetlands
(1,25898, 11816), -- Elwynn Forest
(1,25892, 11810), -- Burning Steppes
(1,25890, 11808), -- Blasted Lands
(1,25887, 11804), -- Arathi Highlands
(1,25915, 11832), -- Cape of Stranglethorn
(1,25895, 11813), -- Dun Morogh
(1,25896, 11814), -- Duskwood
(1,25902, 11820), -- Loch Modan
(1,25904, 11822), -- Redridge Mountains
(1,32801, 13485), -- Borean Tundra // Honor the Flame (Alliance) - Northrend
(1,32803, 13487), -- Dragonblight
(1,32805, 13489), -- Grizzly
(1,32804, 13488), -- Howling Fjord
(1,32808, 13492), -- Zul'Drak
(1,32806, 13490), -- The Storm Peaks
(1,32802, 13486), -- Sholazar Basin
(1,32807, 13491), -- Crystalsong Forest
(1,25905, 11823), -- Shadowmoon Valley // Honor the Flame (Alliance) - Outland
(1,25903, 11821), -- Nagrand
(1,25913, 11830), -- Netherstorm
(1,25900, 11818), -- Hellfire Peninsula
(1,25907, 11825), -- Terokkar
(1,25889, 11807), -- Blade's Edge
(1,25912, 11829), -- Zangarmarsh
(1,26221, 11917), -- Striking Back
(1,26221, 11947), -- Striking Back
(1,26221, 11948), -- Striking Back
(1,26221, 11952), -- Striking Back
(1,26221, 11953), -- Striking Back
(1,26221, 11954), -- Striking Back
(1,26221, 11886), -- Unusual Activity
(1,25324, 11891), -- An Innocent Disguise
(1,25324, 12012), -- Inform the Elder
(1,26221, 11955), -- Ahune, the Frost Lord
(1,25710, 11696), -- Ahune is Here!
(1,25697, 11691), -- Summon Ahune
(1,19169, 11971), -- The Spinner of Summer Tales /Horde/
(1,19178, 11971), -- The Spinner of Summer Tales
(1,19175, 11971), -- The Spinner of Summer Tales
(1,19176, 11971), -- The Spinner of Summer Tales
(1,19177, 11971), -- The Spinner of Summer Tales
(1,20102, 11971), -- The Spinner of Summer Tales
(1,19171, 11970), -- The Master of Summer Lore /Alliance/
(1,19148, 11970), -- The Master of Summer Lore
(1,19172, 11970), -- The Master of Summer Lore
(1,18927, 11970), -- The Master of Summer Lore
(1,19173, 11970), -- The Master of Summer Lore
(1,20102, 11970), -- The Master of Summer Lore
(1,16818, 11966), -- Incense for the Festival Scorchlings
(1,16817, 11964), -- Incense for the Summer Scorchlings
(1,26113, 11922), -- Torch Tossing /H/
(1,26113, 11923), -- Torch Catching /H/
(1,26113, 11926), -- More Torch Tossing /H/
(1,26113, 11925), -- More Torch Catching /H/
(1,25975, 11731), -- Torch Tossing /A/
(1,25975, 11657), -- Torch Catching /A/
(1,25975, 11921), -- More Torch Tossing /A/
(1,25975, 11924), -- More Torch Catching /A/
(1,16818, 9339), -- A Thief''s Reward /H/
(1,16817, 9365); -- A Thief''s Reward /A/
DELETE FROM `game_event_gameobject_quest` WHERE `quest` IN (11767,11778,11787,11782,11799,11779,11775,11734,11741,11744,11763,11762,11760,11746,11740,11735,11738,11753,11755,11756,11748,11581,11757,11745,11739,11737,11732,11761,11742,11743,11749,11751,13440,13443,13445,13444,13449,13446,13442,13447,11752,11750,11759,11747,11754,11736,11758,11770,11769,11777,11803,11783,11773,11765,11771,11785,11800,11780,11802,11774,11772,11776,11781,11801,11768,11784,11580,11786,11766,11764,13458,13441,13450,13451,13457,13455,13454,13453);
INSERT INTO `game_event_gameobject_quest` (`eventEntry`,`id`, `quest`) VALUES
(1,187916, 11734), -- Ashenvale // Desecrate the Flame (Horde) - Kalimdor
(1,187924, 11741), -- Desolace
(1,187927, 11744), -- Dustwallow Marsh
(1,187946, 11763), -- Winterspring
(1,187945, 11762), -- Tanaris
(1,187943, 11760), -- Silithus
(1,187929, 11746), -- Feralas
(1,187923, 11740), -- Darkshore
(1,187917, 11735), -- Azuremyst Isle
(1,187921, 11738), -- Bloodmyst Isle
(1,187936, 11753), -- Teldrassil
(1,187938, 11755), -- The Hinterlands // Desecrate the Flame (Horde) - Eeastern Kingdoms
(1,187939, 11756), -- The Western Plaguelands
(1,187931, 11748), -- Hillsbrad Foothills
(1,187564, 11581), -- Westfall
(1,187940, 11757), -- Wetlands
(1,187928, 11745), -- Elwynn Forest
(1,187922, 11739), -- Burning Steppes
(1,187920, 11737), -- Blasted Lands
(1,187914, 11732), -- Arathi Highlands
(1,187944, 11761), -- Cape of Stranglethorn
(1,187925, 11742), -- Dun Morogh
(1,187926, 11743), -- Duskwood
(1,187932, 11749), -- Loch Modan
(1,187934, 11751), -- Redridge Mountains
(1,194032, 13440), -- Borean Tundra // Desecrate the Flame (Horde) - Northrend
(1,194036, 13443), -- Dragonblight
(1,194040, 13445), -- Grizzly
(1,194038, 13444), -- Howling Fjord
(1,194049, 13449), -- Zul'Drak
(1,194044, 13446), -- The Storm Peaks
(1,194035, 13442), -- Sholazar Basin
(1,194045, 13447), -- Crystalsong Forest
(1,187935, 11752), -- Shadowmoon Valley // Desecrate the Flame (Horde) - Outland
(1,187933, 11750), -- Nagrand
(1,187942, 11759), -- Netherstorm
(1,187930, 11747), -- Hellfire Peninsula
(1,187937, 11754), -- Terokkar
(1,187919, 11736), -- Blade's Edge
(1,187941, 11758), -- Zangarmarsh
(1,187958, 11770), -- Durotar // Desecrate the Flame (Alliance) - Kalimdor
(1,187957, 11769), -- Desolace
(1,187965, 11777), -- Mulgore
(1,187953, 11803), -- Winterspring
(1,187971, 11783), -- Barrens
(1,187961, 11773), -- Feralas
(1,187948, 11765), -- Ashenvale
(1,187959, 11771), -- Dustwallow marsh
(1,187973, 11785), -- Thousand Needles
(1,187950, 11800), -- Silithus
(1,187968, 11780), -- Stonetalon Mountains
(1,187952, 11802), -- Tanaris
(1,187962, 11774), -- Ghostland // Desecrate the Flame (Alliance) - Eeastern Kingdoms
(1,187960, 11772), -- Eversong woods
(1,187964, 11776), -- Hillsbrad Foothills
(1,187969, 11781), -- Swamp of sorrows
(1,187951, 11801), -- Cape of Stranglethorn
(1,187956, 11768), -- Burning Steppes
(1,187972, 11784), -- The Hinterlands
(1,187559, 11580), -- Silverpine Forest
(1,187974, 11786), -- Tirisfal Glades
(1,187954, 11766), -- Badlands
(1,187947, 11764), -- Arathi Highlands
(1,187963, 11775), -- Hellfire Peninsula // Desecrate the Flame (Alliance) - Outland
(1,187967, 11779), -- Shadowmoon Valley
(1,187949, 11799), -- Netherstorm
(1,187970, 11782), -- Terokkar
(1,187975, 11787), -- Zangarmarsh
(1,187955, 11767), -- Blade' Edge
(1,187966, 11778), -- Nagrand
(1,194048, 13458), -- Zul'Drak // Desecrate the Flame (Alliance) - Northend
(1,194033, 13441), -- Borean Tundra
(1,194034, 13450), -- Sholazar Basin
(1,194037, 13451), -- Dragonblight
(1,194046, 13457), -- Crystalsong Forest
(1,194043, 13455), -- Storm Peaks
(1,194042, 13454), -- Grizzly Hills
(1,194039, 13453); -- Howling Fjords
 
-- TrinityCore\sql\updates\world\2012_08_05_00_world_trinity_string.sql 
DELETE FROM `trinity_string` WHERE `entry` IN (5032,5033,5034);
INSERT INTO `trinity_string` (`entry`,`content_default`,`content_loc1`,`content_loc2`,`content_loc3`,`content_loc4`,`content_loc5`,`content_loc6`,`content_loc7`,`content_loc8`) VALUES
(5032,'No battleground found!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5033,'No achievement criteria found!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5034,'No outdoor PvP found!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
 
-- TrinityCore\sql\updates\world\2012_08_05_01_world_command.sql 
DELETE FROM `command` WHERE `name` IN (
'disable add quest','disable add map','disable add battleground','disable add achievement_criteria','disable add spell','disable add outdoorpvp','disable add vmap',
'disable remove quest','disable remove map','disable remove battleground','disable remove achievement_criteria','disable remove spell','disable remove outdoorpvp','disable remove vmap'
);
INSERT INTO `command` (`name`,`security`,`help`) VALUES
('disable add quest',3,'Syntax: .disable add quest $entry $flag $comment'),
('disable add map',3,'Syntax: .disable add map $entry $flag $comment'),
('disable add battleground',3,'Syntax: .disable add battleground $entry $flag $comment'),
('disable add achievement_criteria',3,'Syntax: .disable add achievement_criteria $entry $flag $comment'),
('disable add spell',3,'Syntax: .disable add spell $entry $flag $comment'),
('disable add outdoorpvp',3,'Syntax: .disable add outdoorpvp $entry $flag $comment'),
('disable add vmap',3,'Syntax: .disable add vmap $entry $flag $comment'),
('disable remove quest',3,'Syntax: .disable remove quest $entry'),
('disable remove map',3,'Syntax: .disable remove map $entry'),
('disable remove battleground',3,'Syntax: .disable remove battleground $entry'),
('disable remove achievement_criteria',3,'Syntax: .disable remove achievement_criteria $entry'),
('disable remove spell',3,'Syntax: .disable remove spell $entry'),
('disable remove outdoorpvp',3,'Syntax: .disable remove outdoorpvp $entry'),
('disable remove vmap',3,'Syntax: .disable remove vmap $entry');
 
-- TrinityCore\sql\updates\world\2012_08_06_00_world_command.sql 
DELETE FROM `command` WHERE `name` IN ('server togglequerylog', 'server set loglevel');

INSERT INTO `command` (`name`,`security`,`help`) VALUES
('server set loglevel',4,'Syntax: .server set loglevel $facility $name $loglevel. $facility can take the values: appender (a) or logger (l). $loglevel can take the values: disabled (0), trace (1), debug (2), info (3), warn (4), error (5) or fatal (6)');
 
-- TrinityCore\sql\updates\world\2012_08_09_00_world_creature_template.sql 
UPDATE `creature_template` SET `npcflag`=`npcflag` |2 WHERE `entry` IN (25918,25929,25931,25933,25936,25938,25946,32811,32812,32813,32816);

DELETE FROM `creature_loot_template` WHERE `entry` IN(17465,20583) AND `item`=22554;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(17465,22554,15,1,0,1,1), -- Formula: Enchant 2H Weapon - Savagery
(20583,22554,15,1,0,1,1); -- Formula: Enchant 2H Weapon - Savagery
 
-- TrinityCore\sql\updates\world\2012_08_09_01_world_sai.sql 
-- Territorial Trespass (13051)

SET @NPC_VERANUS := 30461;
SET @QUEST := 13051;
SET @EVENT := 19714;
SET @NPC_THORIM := 30462;
SET @SPELL_MOUNT := 43671;

UPDATE `creature_template` SET `HoverHeight`=10.8,`speed_walk`=3.2,`speed_run`=1.42857146263123,`VehicleId`=237,`minlevel`=80,`faction_A`=14,`faction_H`=14,`unit_flags`=0x8140,`InhabitType`=5 WHERE `entry`=@NPC_VERANUS;

DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_VERANUS;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_VERANUS,0,0x3000000,0x1,'');

DELETE FROM `creature_text` WHERE `entry` IN (@NPC_VERANUS,@NPC_THORIM);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_VERANUS,0,0,'%s lets out a bellowing roar as she descends upon the nest.',16,0,100,15,0,0,'Veranus'),
(@NPC_THORIM,0,0,'Look out below!',14,0,100,0,0,0,'Thorim'),
(@NPC_THORIM,1,0,'Easy there, girl!  Don''t you recognize your old master?',12,0,100,0,0,0,'Thorim'),
(@NPC_THORIM,2,0,'I will see you at the Temple of Storms. Looks like I''m going to have to break her in again.',12,0,100,0,0,0,'Thorim');

-- Veranus SAI
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (@NPC_VERANUS,@NPC_THORIM);
DELETE FROM `smart_scripts` WHERE (`entryorguid` IN (@NPC_VERANUS,@NPC_THORIM) AND `source_type`=0) OR (`entryorguid`=@NPC_THORIM*100 AND `source_type`=9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_VERANUS,0,0,0,54,0,100,0,0,0,0,0,53,1,@NPC_VERANUS,0,@QUEST,0,0,1,0,0,0,0,0,0,0,'Veranus - On Summoned - Start WP-Movement'),
(@NPC_VERANUS,0,1,2,58,0,100,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Veranus - On WP-End - Talk(emote)'),
(@NPC_VERANUS,0,2,3,61,0,100,0,1,0,0,0,33,@NPC_VERANUS,0,0,0,0,0,7,0,0,0,0,0,0,0,'Veranus - On WP-End - Give quest credit'),
(@NPC_VERANUS,0,3,0,61,0,100,0,0,0,0,0,12,@NPC_THORIM,8,0,0,0,0,8,0,0,0,7096.863,-904.658,1119.904,2.338741,'Veranus - On WP-End - Summon Thorim'),
(@NPC_VERANUS,0,4,5,38,0,100,0,1,1,0,0,46,100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Veranus - On data - Move forward'),
(@NPC_VERANUS,0,5,0,61,0,100,0,0,0,0,0,41,10000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Veranus - On data - despawn'),
--
(@NPC_THORIM,0,0,0,54,0,100,0,0,0,0,0,80,@NPC_THORIM*100,2,0,0,0,0,1,0,0,0,0,0,0,0,'Thorim - On Summoned - Start script'),
(@NPC_THORIM,0,1,0,38,0,100,0,1,1,0,0,41,10000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thorim - On data - despawn'),
(@NPC_THORIM*100,9,0,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thorim - On Script - Talk(yell)'),
(@NPC_THORIM*100,9,1,0,0,0,100,0,0,0,0,0,11,@SPELL_MOUNT,0,0,0,0,0,7,0,0,0,0,0,0,0,'Thorim - On Script - Cast spell mount'),
(@NPC_THORIM*100,9,2,0,0,0,100,0,10000,10000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thorim - On Script - Talk(say)'),
(@NPC_THORIM*100,9,3,0,0,0,100,0,5000,5000,0,0,1,2,1000,0,0,0,0,1,0,0,0,0,0,0,0,'Thorim - On Script - Talk(say)'),
(@NPC_THORIM*100,9,4,0,0,0,100,0,0,0,0,0,45,1,1,0,0,0,0,7,0,0,0,0,0,0,0,'Thorim - On Script - Set data'),
(@NPC_THORIM*100,9,5,0,0,0,100,0,0,0,0,0,45,1,1,0,0,0,0,1,0,0,0,0,0,0,0,'Thorim - On Script - Set data');

DELETE FROM `waypoints` WHERE `entry`=@NPC_VERANUS;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@NPC_VERANUS,1,7083.224,-912.2372,1090.213,'Veranus - WP1');

DELETE FROM `event_scripts` WHERE `id`=@EVENT;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(@EVENT,0,10,@NPC_VERANUS,600000,0,6947.481,-859.5176,1147.604,5.674867);
 
-- TrinityCore\sql\updates\world\2012_08_10_00_world_conditions.sql 
SET @ENTRY := 27482; -- Wounded Westfall Infantry npc
SET @SPELL := 48845; -- Renew Infantry spell
SET @ITEM := 37576; -- Renewing Bandage item
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceEntry`=@ITEM;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry`=@SPELL;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,@SPELL,0,31,1,3,@ENTRY,0,0,0,'', "Item Renewing Bandage target Wounded Westfall Infantry");
 
-- TrinityCore\sql\updates\world\2012_08_10_01_world_loot_template.sql 
-- Emperor Vek'nilash update loot chance based on http://old.wowhead.com/npc=15275#drops:0+1-15 by nelegalno
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=11 WHERE `entry`=15275 AND `item`=21606; -- Belt of the Fallen Emperor
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=12 WHERE `entry`=15275 AND `item`=21604; -- Bracelets of Royal Redemption
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=11 WHERE `entry`=15275 AND `item`=21605; -- Gloves of the Hidden Temple
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=11 WHERE `entry`=15275 AND `item`=21607; -- Grasp of the Fallen Emperor
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`= 7 WHERE `entry`=15275 AND `item`=21679; -- Kalimdor's Revenge
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=11 WHERE `entry`=15275 AND `item`=21609; -- Regenerating Belt of Vek'nilash
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=63 WHERE `entry`=15275 AND `item`=20726; -- Formula: Enchant Gloves - Threat

-- Emperor Vek'lor update loot chance based on http://old.wowhead.com/npc=15276#drops:0+1-15 by nelegalno
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=11 WHERE `entry`=15276 AND `item`=21600; -- Boots of Epiphany
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=13 WHERE `entry`=15276 AND `item`=21602; -- Qiraji Execution Bracers
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=13 WHERE `entry`=15276 AND `item`=21601; -- Ring of Emperor Vek'lor
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=14 WHERE `entry`=15276 AND `item`=21598; -- Royal Qiraji Belt
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`= 7 WHERE `entry`=15276 AND `item`=21597; -- Royal Scepter of Vek'lor
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=13 WHERE `entry`=15276 AND `item`=21599; -- Vek'lor's Gloves of Devastation
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=64 WHERE `entry`=15276 AND `item`=20735; -- Formula: Enchant Cloak - Subtlety

-- Princess Huhuran update loot chance based on http://old.wowhead.com/npc=15509#drops:0+1-15 by nelegalno
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=15 WHERE `entry`=15509 AND `item`=21621; -- Cloak of the Golden Hive
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=15 WHERE `entry`=15509 AND `item`=21619; -- Gloves of the Messiah
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=16 WHERE `entry`=15509 AND `item`=21618; -- Hive Defiler Wristguards
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`= 8 WHERE `entry`=15509 AND `item`=21616; -- Huhuran's Stinger
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=17 WHERE `entry`=15509 AND `item`=21620; -- Ring of the Martyr
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=14 WHERE `entry`=15509 AND `item`=21617; -- Wasphide Gauntlets
 
-- TrinityCore\sql\updates\world\2012_08_10_02_world_script_texts.sql 
UPDATE `script_texts` SET `sound`=14036 WHERE `entry` = -1619015;
UPDATE `script_texts` SET `sound`=14037 WHERE `entry` = -1619016;
UPDATE `script_texts` SET `sound`=14038 WHERE `entry` = -1619017;
UPDATE `script_texts` SET `sound`=14039 WHERE `entry` = -1619018;
UPDATE `script_texts` SET `sound`=14034 WHERE `entry` = -1619019;
UPDATE `script_texts` SET `sound`=14035 WHERE `entry` = -1619020;
 
-- TrinityCore\sql\updates\world\2012_08_10_03_world_quest_template.sql 
-- Zandalar Tribe Quests Required Class/Race fix by nelegalno

-- Maywiki of Zuldazar Quests Required Class
UPDATE `quest_template` SET `RequiredClasses` = 64 WHERE `Id` IN (8056,8074,8075,8116,8117,8118,8119); -- Shaman
UPDATE `quest_template` SET `RequiredClasses` = 1024 WHERE `Id` IN (8057,8064,8065,8110,8111,8112,8113); -- Druid

-- Al'tabim the All-Seeing Quests Required Class
UPDATE `quest_template` SET `RequiredClasses` = 16 WHERE `Id` IN (8049,8050,8051,8052,8061,8070,8071); -- Priest
UPDATE `quest_template` SET `RequiredClasses` = 128 WHERE `Id` IN (8060,8068,8069,8101,8102,8103,8104); -- Mage
UPDATE `quest_template` SET `RequiredClasses` = 256 WHERE `Id` IN (8059,8076,8077,8106,8107,8108,8109); -- Warlock

-- Falthir the Sightless Quests Required Class
UPDATE `quest_template` SET `RequiredClasses` = 4 WHERE `Id` IN (8062,8066,8067,8145,8146,8147,8148); -- Hunter
UPDATE `quest_template` SET `RequiredClasses` = 8 WHERE `Id` IN (8063,8072,8073,8141,8142,8143,8144); -- Rogue
UPDATE `quest_template` SET `RequiredRaces` = 152 WHERE `Id` = 8144; -- Night Elf, Undead and Troll

-- Jin'rokh the Breaker
UPDATE `quest_template` SET `RequiredRaces` = 513 WHERE `Id` = 8048; -- Human and Blood Elf
 
-- TrinityCore\sql\updates\world\2012_08_10_04_world_gossip.sql 
-- -18754 Barim Splithoof Leather working trainer
DELETE FROM `gossip_menu_option` WHERE `menu_id`=7816;
INSERT INTO `gossip_menu_option` VALUES
(7816,0,3, 'I would like to train.', 5,16,0,0,0,0,NULL),
(7816,1,1, 'Let me browse your goods.', 3,128,0,0,0,0,NULL);
 
-- TrinityCore\sql\updates\world\2012_08_10_05_world_quest_template.sql 
-- Change $B$$B at end of details text to $B$B 
UPDATE `quest_template` SET `Details`='Brave traveler, the centaurs have increased their attacks in this area. Freewind Post must know about this renewed harassment immediately! Seek Cliffwatcher Longhorn at Freewind Post to the southeast and give him this urgent message.$b$bBe warned, avoid the Grimtotem Clan nearby... they have been acting strange toward us lately.$B$B' WHERE `Id`=4542;
 
-- TrinityCore\sql\updates\world\2012_08_10_06_world_creature.sql 
SET @CGUID:=42571; -- Need 2
DELETE FROM `creature` WHERE `id` IN (30395,30469);
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`) VALUES 
(@CGUID+0,30395,571,1,1,0,0,8348.886,-2509.476,1147.369,3.700098,120,0,0,12600,0,0,0,0,0),
(@CGUID+1,30469,571,1,1,0,0,7620.369,-1609.421,969.6507,0.767944,120,0,0,12600,0,0,0,0,0); 

-- Template updates
UPDATE `creature_template` SET `npcflag`=`npcflag`|3 WHERE `entry`=30395; -- Chieftain Swiftspear
UPDATE `creature_template` SET `faction_A`=1978,`faction_H`=1978 WHERE `entry`=30469; -- Tracker Val'zij
-- Model data
UPDATE `creature_model_info` SET `bounding_radius`=0.6076385,`combat_reach`=2.625,`gender`=0 WHERE `modelid`=27004; -- Chieftain Swiftspear
-- Addon data
DELETE FROM `creature_template_addon` WHERE `entry`IN (30395,30469);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(30395,0,0,1,0, NULL), -- Chieftain Swiftspear
(30469,0,8,1,0, NULL); -- Tracker Val'zij
 
-- TrinityCore\sql\updates\world\2012_08_11_00_world_creature_template.sql 
UPDATE `creature_template` SET `lootid`=`entry` WHERE `entry` IN (17465,20583);
 
-- TrinityCore\sql\updates\world\2012_08_11_01_world_quest_poi.sql 
-- PK and new index for quest_poi
ALTER TABLE `quest_poi` DROP INDEX `questId`;
ALTER TABLE `quest_poi` DROP INDEX `id`;
ALTER TABLE `quest_poi` ADD PRIMARY KEY (`questId`, `id`);
ALTER TABLE `quest_poi` ADD INDEX `idx` (`questId`, `id`);

-- Correct data for quest_poi_points that violate the PK
UPDATE `quest_poi_points` SET `idx`=0 WHERE `questId`=25446 AND `id`=0 AND `x`=-1041 AND `y`=-5585;
UPDATE `quest_poi_points` SET `idx`=1 WHERE `questId`=25446 AND `id`=0 AND `x`=-1062 AND `y`=-5631;
UPDATE `quest_poi_points` SET `idx`=2 WHERE `questId`=25446 AND `id`=0 AND `x`=-1066 AND `y`=-5375;
UPDATE `quest_poi_points` SET `idx`=3 WHERE `questId`=25446 AND `id`=0 AND `x`=-1189 AND `y`=-5343;
UPDATE `quest_poi_points` SET `idx`=4 WHERE `questId`=25446 AND `id`=0 AND `x`=-1195 AND `y`=-5618;
UPDATE `quest_poi_points` SET `idx`=5 WHERE `questId`=25446 AND `id`=0 AND `x`=-1269 AND `y`=-5386;
UPDATE `quest_poi_points` SET `idx`=6 WHERE `questId`=25446 AND `id`=0 AND `x`=-1289 AND `y`=-5571;
UPDATE `quest_poi_points` SET `idx`=7 WHERE `questId`=25446 AND `id`=0 AND `x`=-1320 AND `y`=-5477;
UPDATE `quest_poi_points` SET `idx`=8 WHERE `questId`=25446 AND `id`=0 AND `x`=-1322 AND `y`=-5527;
UPDATE `quest_poi_points` SET `idx`=0 WHERE `questId`=25446 AND `id`=1 AND `x`=-1502 AND `y`=-5263;
UPDATE `quest_poi_points` SET `idx`=1 WHERE `questId`=25446 AND `id`=1 AND `x`=-1532 AND `y`=-5341;
UPDATE `quest_poi_points` SET `idx`=2 WHERE `questId`=25446 AND `id`=1 AND `x`=-1589 AND `y`=-5340;
UPDATE `quest_poi_points` SET `idx`=3 WHERE `questId`=25446 AND `id`=1 AND `x`=-1611 AND `y`=-5276;
UPDATE `quest_poi_points` SET `idx`=4 WHERE `questId`=25446 AND `id`=2 AND `x`=-1020 AND `y`=-5153;
UPDATE `quest_poi_points` SET `idx`=5 WHERE `questId`=25446 AND `id`=2 AND `x`=-1089 AND `y`=-5174;
UPDATE `quest_poi_points` SET `idx`=6 WHERE `questId`=25446 AND `id`=2 AND `x`=-1128 AND `y`=-5131;
UPDATE `quest_poi_points` SET `idx`=7 WHERE `questId`=25446 AND `id`=2 AND `x`=-0955 AND `y`=-5186;
UPDATE `quest_poi_points` SET `idx`=0 WHERE `questId`=25446 AND `id`=3 AND `x`=-0654 AND `y`=-5627;
UPDATE `quest_poi_points` SET `idx`=1 WHERE `questId`=25446 AND `id`=3 AND `x`=-0688 AND `y`=-5518;
UPDATE `quest_poi_points` SET `idx`=2 WHERE `questId`=25446 AND `id`=3 AND `x`=-0730 AND `y`=-5656;
UPDATE `quest_poi_points` SET `idx`=3 WHERE `questId`=25446 AND `id`=3 AND `x`=-0732 AND `y`=-5499;
UPDATE `quest_poi_points` SET `idx`=4 WHERE `questId`=25446 AND `id`=3 AND `x`=-0795 AND `y`=-5544;
UPDATE `quest_poi_points` SET `idx`=5 WHERE `questId`=25446 AND `id`=3 AND `x`=-0806 AND `y`=-5674;
UPDATE `quest_poi_points` SET `idx`=6 WHERE `questId`=25446 AND `id`=3 AND `x`=-0835 AND `y`=-5606;
UPDATE `quest_poi_points` SET `idx`=0 WHERE `questId`=25446 AND `id`=4 AND `x`=-0747 AND `y`=-5004;

UPDATE `quest_poi_points` SET `idx`=0  WHERE `questId`=25461 AND `x`=246 AND `y`=-4715;
UPDATE `quest_poi_points` SET `idx`=1  WHERE `questId`=25461 AND `x`=247 AND `y`=-4675;
UPDATE `quest_poi_points` SET `idx`=2  WHERE `questId`=25461 AND `x`=248 AND `y`=-4673;
UPDATE `quest_poi_points` SET `idx`=3  WHERE `questId`=25461 AND `x`=266 AND `y`=-4830;
UPDATE `quest_poi_points` SET `idx`=4  WHERE `questId`=25461 AND `x`=284 AND `y`=-4628;
UPDATE `quest_poi_points` SET `idx`=5  WHERE `questId`=25461 AND `x`=302 AND `y`=-4612;
UPDATE `quest_poi_points` SET `idx`=6  WHERE `questId`=25461 AND `x`=343 AND `y`=-4831;
UPDATE `quest_poi_points` SET `idx`=7  WHERE `questId`=25461 AND `x`=345 AND `y`=-4831;
UPDATE `quest_poi_points` SET `idx`=8  WHERE `questId`=25461 AND `x`=376 AND `y`=-4778;
UPDATE `quest_poi_points` SET `idx`=9  WHERE `questId`=25461 AND `x`=380 AND `y`=-4661;
UPDATE `quest_poi_points` SET `idx`=10 WHERE `questId`=25461 AND `x`=411 AND `y`=-4704;

UPDATE `quest_poi_points` SET `idx`=0  WHERE `questId`=25444 AND `x`=-1014 AND `y`=-4911;
UPDATE `quest_poi_points` SET `idx`=1  WHERE `questId`=25444 AND `x`=-0644 AND `y`=-4999;
UPDATE `quest_poi_points` SET `idx`=2  WHERE `questId`=25444 AND `x`=-0673 AND `y`=-4932;
UPDATE `quest_poi_points` SET `idx`=3  WHERE `questId`=25444 AND `x`=-0673 AND `y`=-5062;
UPDATE `quest_poi_points` SET `idx`=4  WHERE `questId`=25444 AND `x`=-0736 AND `y`=-5100;
UPDATE `quest_poi_points` SET `idx`=5  WHERE `questId`=25444 AND `x`=-0740 AND `y`=-4873;
UPDATE `quest_poi_points` SET `idx`=6  WHERE `questId`=25444 AND `x`=-0808 AND `y`=-4831;
UPDATE `quest_poi_points` SET `idx`=7  WHERE `questId`=25444 AND `x`=-0808 AND `y`=-5100;
UPDATE `quest_poi_points` SET `idx`=8  WHERE `questId`=25444 AND `x`=-0887 AND `y`=-5062;
UPDATE `quest_poi_points` SET `idx`=9  WHERE `questId`=25444 AND `x`=-0892 AND `y`=-4776;
UPDATE `quest_poi_points` SET `idx`=10 WHERE `questId`=25444 AND `x`=-0959 AND `y`=-4995;
UPDATE `quest_poi_points` SET `idx`=11 WHERE `questId`=25444 AND `x`=-0984 AND `y`=-4785;

-- PK for quest_poi_points
ALTER TABLE `quest_poi_points` ADD PRIMARY KEY (`questId`, `id`, `idx`);
 
-- TrinityCore\sql\updates\world\2012_08_12_00_world_conditions.sql 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=58124;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,58124,0,0,32,0,0x90,0,0,0,0,'','Mal''Ganis Kill Credit - Player target');
 
-- TrinityCore\sql\updates\world\2012_08_12_01_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE `spell_id`=36554;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(36554,'spell_rog_shadowstep');
 
-- TrinityCore\sql\updates\world\2012_08_12_02_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE `spell_id`=-32379;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(-32379,'spell_pri_shadow_word_death');
 
-- TrinityCore\sql\updates\world\2012_08_13_00_world_creature_text.sql 
DELETE FROM `script_texts` WHERE `entry` BETWEEN -1649999 AND -1649000;
DELETE FROM `creature_text` WHERE `entry` IN (34996,34990,34995,36095,34796,35144,34799,34797,34780,35458,34496,34497,16980,35877,34564,34660);
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
-- Highlord Tirion Fordring
    -- Northrend Beasts
(34996, 0, 0, 'Welcome, champions! You have heard the call of the Argent Crusade and you have boldly answered! It is here, in the Crusaders'' Coliseum, that you will face your greatest challenges. Those of you who survive the rigors of the coliseum will join the Argent Crusade on its march to Icecrown Citadel.', 14, 0, 100, 0, 0, 16036, 'Highlord Tirion Fordring - Welcome'),
(34996, 1, 0, 'Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!', 14, 0, 100, 0, 0, 16038, 'Highlord Tirion Fordring - Summing Gormok the Impaler'),
(34996, 2, 0, 'Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!', 14, 0, 100, 0, 0, 16039, 'Highlord Tirion Fordring - Summing Acidmaw and Dreadscale'),
(34996, 3, 0, 'The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!', 14, 0, 100, 0, 0, 16040, 'Highlord Tirion Fordring Summing Icehowl'),
(34996, 4, 0, 'The monstrous menagerie has been vanquished!', 14, 0, 100, 0, 0, 16041, 'Highlord Tirion Fordring - Northrend Beasts Done'),
(34996, 5, 0, 'Tragic... They fought valiantly, but the beasts of Northrend triumphed. Let us observe a moment of silence for our fallen heroes.', 14, 0, 0, 0, 0, 16042, 'Highlord Tirion Fordring - Northrend Beasts FAIL'),
    -- Lord Jaraxxus
(34996, 6, 0, 'Grand Warlock Wilfred Fizzlebang will summon forth your next challenge. Stand by for his entry.', 14, 0, 100, 0, 0, 16043, 'Highlord Tirion Fordring - Summing Wilfred Fizzlebang'),
(34996, 7, 0, 'Quickly, heroes, destroy the demon lord before it can open a portal to its twisted demonic realm!', 14, 0, 100, 5, 0, 16044, 'Highlord Tirion Fordring to Wilfred Fizzlebang - Lord Jaraxxus Intro'),
(34996, 8, 0, 'The loss of Wilfred Fizzlebang, while unfortunate, should be a lesson to those that dare dabble in dark magic. Alas, you are victorious and must now face the next challenge.', 14, 0, 100, 0, 0, 16045, 'Highlord Tirion Fordring - Lord Jaraxxus Outro'),
(34996, 9, 0, 'Everyone calm down! Compose yourselves! There is no conspiracy at play here! The warlock acted on his own volition, outside of influences from the Alliance. The tournament must go on!', 14, 0, 100, 5, 0, 16046, 'Highlord Tirion Fordring - Lord Jaraxxus Outro'),
    -- Faction Champions
(34996, 10, 0, 'The next battle will be against the Argent Crusade''s most powerful knights! Only by defeating them will you be deemed worthy...', 14, 0, 100, 0, 0, 16047, 'Highlord Tirion Fordring - Faction Champions Intro'),
(34996, 11, 0, 'Very well. I will allow it. Fight with honor!', 14, 0, 100, 1, 0, 16048, 'Highlord Tirion Fordring - Faction Champions Intro'),
(34996, 12, 0, 'A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.', 14, 0, 100, 0, 0, 16049, 'Highlord Tirion Fordring - Faction Champions Outro'),
    -- Twin Val'kyr
(34996, 13, 0, 'Only by working together will you overcome the final challenge. From the depths of Icecrown come two of the Scourge''s most powerful lieutenants: fearsome val''kyr, winged harbingers of the Lich King!', 14, 0, 100, 0, 0, 16050, 'Highlord Tirion Fordring - Twin Val''kyr Intro'),
(34996, 14, 0, 'Let the games begin!', 14, 0, 100, 0, 0, 16037, 'Highlord Tirion Fordring - Twin Val''kyr Intro'),
    -- Anub''arak
(34996, 15, 0, 'A mighty blow has been dealt to the Lich King! You have proven yourselves as able bodied champions of the Argent Crusade. Together we will strike against Icecrown Citadel and destroy what remains of the Scourge! There is no challenge that we cannot face united!', 14, 0, 100, 5, 0, 16051, 'Highlord Tirion Fordring - Anub''arak Intro'),
(34996, 16, 0, 'Arthas! You are hopelessly outnumbered! Lay down Frostmourne and I will grant you a just death.', 14, 0, 100, 25, 0, 16052, 'Highlord Tirion Fordring'),

-- King Varian Wrynn
(34990, 0, 0, 'Your beasts will be no match for my champions, Tirion!', 14, 0, 0, 0, 0, 16069, 'King Varian Wrynn'),
(34990, 1, 0, 'The Alliance doesn''t need the help of a demon lord to deal with Horde filth! Come, pig!', 14, 0, 100, 5, 0, 16064, 'King Varian Wrynn'),
(34990, 2, 0, 'Our honor has been besmirched! They make wild claims and false accusations against us. I demand justice! Allow my champions to fight in place of your knights, Tirion. We challenge the Horde!', 14, 0, 100, 5, 0, 16066, 'King Varian Wrynn'),
(34990, 3, 0, 'Fight for the glory of the Alliance, heroes! Honor your king and your people!', 14, 0, 100, 5, 0, 16065, 'King Varian Wrynn'),
(34990, 4, 0, 'GLORY TO THE ALLIANCE!', 14, 0, 0, 0, 0, 16067, 'King Varian Wrynn'),
(34990, 5, 0, 'Not even the Lich King most powerful minions can stand against the Alliance! All hail our victors!', 14, 0, 0, 0, 0, 16068, 'King Varian Wrynn'),
(34990, 6, 0, 'Hardly a challenge.', 14, 0, 100, 274, 0, 16061, 'King Varian Wrynn - Faction Champions Kill Player'),
(34990, 6, 1, 'HAH!', 14, 0, 100, 5, 0, 16060, 'King Varian Wrynn - Faction Champions Kill Player'),
(34990, 6, 2, 'Is this the best the Horde has to offer?', 14, 0, 100, 6, 0, 16063, 'King Varian Wrynn  - Faction Champions Kill Player'),
(34990, 6, 3, 'Worthless scrub.', 14, 0, 100, 25, 0, 16062, 'King Varian Wrynn  - Faction Champions Kill Player'),

-- Garrosh Hellscream
(34995, 0, 0, 'The Horde demands justice! We challenge the Alliance. Allow us to battle in place of your knights, paladin. We will show these dogs what it means to insult the Horde!', 14, 0, 100, 1, 0, 16023, 'Garrosh Hellscream'),
(34995, 1, 0, 'I''ve seen more worthy challenges in the Ring of Blood. You waste our time, paladin.', 14, 0, 100, 1, 0, 16026, 'Garrosh Hellscream'),
(34995, 2, 0, 'Treacherous Alliance dogs! You summon a demon lord against warriors of the Horde? Your deaths will be swift!', 14, 0, 100, 5, 0, 16021, 'Garrosh Hellscream'),
(34995, 3, 0, 'That was just a taste of what the future brings. FOR THE HORDE!', 14, 0, 100, 1, 0, 16024, 'Garrosh Hellscream'),
(34995, 4, 0, 'Show them no mercy, Horde champions! LOK''TAR OGAR!', 14, 0, 0, 0, 0, 16022, 'Garrosh - Faction Champions Intro'),
(34995, 5, 0, 'Do you still question the might of the Horde, paladin? We will take on all comers!', 14, 0, 100, 1, 0, 16025, 'Garrosh Hellscream'),
(34995, 6, 0, 'Weakling!', 14, 0, 0, 0, 0, 16017, 'Garrosh Hellscream - Faction Champions Kill Player'),
(34995, 6, 1, 'Pathetic!', 14, 0, 0, 0, 0, 16018, 'Garrosh Hellscream - Faction Champions Kill Player'),
(34995, 6, 2, 'Overpowered.', 14, 0, 0, 0, 0, 16019, 'Garrosh Hellscream - Faction Champions Kill Player'),
(34995, 6, 3, 'Lok''tar!', 14, 0, 0, 0, 0, 16020, 'Garrosh Hellscream - Faction Champions Kill Player'),

-- Highlord Tirion Fordring
(36095, 0, 0, 'Champions, you''re alive! Not only have you defeated every challenge of the Trial of the Crusader, but also thwarted Arthas'' plans! Your skill and cunning will prove to be a powerful weapon against the Scourge. Well done! Allow one of the Crusade''s mages to transport you to the surface!', 14, 0, 100, 5, 0, 16053, 'Highlord Tirion Fordring'),
(36095, 1, 0, 'Let me hand you the chests as a reward, and let its contents will serve you faithfully in the campaign against Arthas in the heart of the Icecrown Citadel!', 41, 0, 0, 0, 0, 0, 'Highlord Tirion Fordring'),

-- Gormok
(34796, 0, 0, 'My slaves! Destroy the enemy!', 41, 0, 0, 0, 0, 0, 'Gormok the Impaler - Snowball'),

-- Acidmaw
(35144, 0, 0, 'Upon seeing its companion perish, %s becomes enraged!', 41, 0, 100, 0, 0, 0, 'Acidmaw to Beasts Controller - Enrage'),

-- Dreadscale
(34799, 0, 0, 'Upon seeing its companion perish, %s becomes enraged!', 41, 0, 100, 0, 0, 0, 'Dreadscale to Beasts Controller - Enrage'),

-- Icehowl
(34797, 0, 0, '%s glares at $n and lets out a bellowing roar!', 41, 0, 100, 0, 0, 0, 'Icehowl - Start'),
(34797, 1, 0, '%s crashes into the Coliseum wall and is stunned!', 41, 0, 100, 0, 0, 0, 'Icehowl - Crash'),
(34797, 2, 0, 'Trampling combatants underfoot, %s goes into a frothing rage!', 41, 0, 100, 0, 0, 0, 'Icehowl - Fail'),

-- Wilfred Fizzlebang
(35458, 0, 0, 'Thank you, Highlord. Now, challengers, I will begin the ritual of summoning. When I am done a fearsome doomguard will appear!', 14, 0, 100, 2, 0, 16268, 'Wilfred Fizzlebang - Intro'),
(35458, 1, 0, 'Prepare for oblivion!', 14, 0, 100, 0, 0, 16269, 'Wilfred Fizzlebang - Intro'),
(35458, 2, 0, 'A-HA! I''ve done it! Behold the absolute power of Wilfred Fizzlebang, master summoner! You are bound to me, demon!', 14, 0, 100, 5, 0, 16270, 'Wilfred Fizzlebang to Wilfred Fizzlebang - Intro'),
(35458, 3, 0, 'But I''m in charge here...', 14, 0, 100, 5, 0, 16271, 'Wilfred Fizzlebang to Wilfred Fizzlebang - Death'),

-- Lord Jaraxxus
(34780, 0, 0, 'Trifling gnome! Your arrogance will be your undoing!', 14, 0, 100, 397, 0, 16143, 'Lord Jaraxxus to Wilfred Fizzlebang - Intro'),
(34780, 1, 0, 'You face Jaraxxus, Eredar Lord of the Burning Legion!', 14, 0, 100, 0, 0, 16144, 'Lord Jaraxxus - Aggro'),
(34780, 2, 0, '$n has |cFFFF0000Legion Flames!|r', 41, 0, 100, 0, 0, 0, 'Lord Jaraxxus - Legion Flame'),
(34780, 3, 0, '%s creates a Nether Portal!', 41, 0, 100, 0, 0, 16150, 'Lord Jaraxxus - Summing Nether Portal'),
(34780, 4, 0, 'Come forth, sister! Your master calls!', 14, 0, 100, 0, 0, 16150, 'Lord Jaraxxus - Summoning Mistress of Pain'),
(34780, 5, 0, '$n has |cFF00FFFFIncinerate Flesh!|r Heal $g him:her;!', 41, 0, 100, 0, 0, 16149, 'Lord Jaraxxus - Incinerate Flesh'),
(34780, 6, 0, 'FLESH FROM BONE!', 14, 0, 100, 0, 0, 16149, 'Lord Jaraxxus - Incinerate Flesh'),
(34780, 7, 0, '%s creates an |cFF00FF00Infernal Volcano!|r', 41, 0, 100, 0, 0, 16151, 'Lord Jaraxxus - Summoning Infernal Volcano emote'),
(34780, 8, 0, 'IN-FER-NO!', 14, 0, 100, 0, 0, 16151, 'Lord Jaraxxus - Summoning Infernals'),
(34780, 9, 0, 'Insignificant gnat!', 14, 0, 0, 0, 0, 16145, 'Lord Jaraxxus - Killing a player'),
(34780, 9, 1, 'Banished to the Nether!', 14, 0, 0, 0, 0, 16146, 'Lord Jaraxxus - Killing a player'),
(34780, 10, 0, 'Another will take my place. Your world is doomed...', 14, 0, 100, 0, 0, 16147, 'Lord Jaraxxus - Death'),
(34780, 11, 0,'<Laughs>', 14, 0, 0, 0, 0, 16148, 'Lord Jaraxxus - Berserk'),

-- Eydis Darkban
(34496, 0, 0, 'In the name of our dark master. For the Lich King. You. Will. Die.', 14, 0, 100, 0, 0, 16272, 'Eydis Darkbane - Aggro'),
(34496, 1, 0, 'Let the light consume you!', 14, 0, 100, 0, 0, 16279, 'Eydis Darkbane to Fjola Lightbane - Light Vortex'),
(34496, 2, 0, 'Let the dark consume you!', 14, 0, 100, 0, 0, 16278, 'Eydis Darkbane to Fjola Lightbane - Dark Vortex'),
(34496, 3, 0, '%s begins to cast |cFF9932CDDark Vortex!|r Switch to |cFF9932CDDark|r Essence!', 41, 0, 100, 0, 0, 16278, 'Eydis Darkbane to Fjola Lightbane - Dark Vortex emote'),
(34496, 4, 0, '%s begins to cast  |cFFFF0000Twin''s Pact!|r', 41, 0, 100, 0, 0, 16274, 'Eydis Darkbane to Fjola Lightbane - Twin''s Pact emote'),
(34496, 5, 0, 'CHAOS!', 14, 0, 100, 0, 0, 16274, 'Eydis Darkbane to Fjola Lightbane - Twin''s Pact'),
(34496, 6, 0, 'You have been measured and found wanting.', 14, 0, 100, 0, 0, 16276, 'Eydis Darkbane - Killing a player'),
(34496, 6, 1, 'UNWORTHY!', 14, 0, 100, 0, 0, 16276, 'Eydis Darkbane - Killing a player'),
(34496, 7, 0, 'YOU ARE FINISHED!', 14, 0, 0, 0, 0, 16273, 'Eydis Darkbane - Berserk'),
(34496, 8, 0, 'The Scourge cannot be stopped...', 14, 0, 100, 0, 0, 16275, 'Eydis Darkbane - Death'),

-- Fjola Lightbane
(34497, 0, 0, 'In the name of our dark master. For the Lich King. You. Will. Die.', 14, 0, 100, 0, 0, 16272, 'Fjola Lightbane - Aggro'),
(34497, 1, 0, 'Let the light consume you!', 14, 0, 100, 0, 0, 16279, 'Fjola Lightbane to Fjola Lightbane - Light Vortex'),
(34497, 2, 0, 'Let the dark consume you!', 14, 0, 100, 0, 0, 16278, 'Fjola Lightbane to Fjola Lightbane - Dark Vortex'),
(34497, 3, 0, '%s begins to cast |cFFFFFFFFLight Vortex!|r Switch to |cFFFFFFFFLight|r Essence!', 41, 0, 100, 0, 0, 16279, 'Fjola Lightbane to Fjola Lightbane - Light Vortex emote'),
(34497, 4, 0, '%s begins to cast Twin''s Pact!', 41, 0, 100, 0, 0, 16274, 'Fjola Lightbane to Fjola Lightbane - Twin''s Pact emote'),
(34497, 5, 0, 'CHAOS!', 14, 0, 100, 0, 0, 16274, 'Fjola Lightbane to Fjola Lightbane - Twin''s Pact'),
(34497, 6, 0, 'You have been measured and found wanting.', 14, 0, 100, 0, 0, 16276, 'Fjola Lightbane - Killing a player'),
(34497, 6, 1, 'UNWORTHY!', 14, 0, 100, 0, 0, 16276, 'Fjola Lightbane - Killing a player'),
(34497, 7, 0, 'YOU ARE FINISHED!', 14, 0, 0, 0, 0, 16273, 'Fjola Lightbane - Berserk'),
(34497, 8, 0, 'The Scourge cannot be stopped...', 14, 0, 100, 0, 0, 16275, 'Fjola Lightbane - Death'),

-- The Lich King
(35877, 0, 0, 'You will have your challenge, Fordring.', 14, 0, 100, 0, 0, 16321, 'The Lich King'),
(35877, 1, 0, 'The souls of your fallen champions will be mine, Fordring.', 14, 0, 100, 0, 0, 16323, 'The Lich King'),
(35877, 2, 0, 'The Nerubians built an empire beneath the frozen wastes of Northrend. An empire that you so foolishly built your structures upon. MY EMPIRE.', 14, 0, 100, 11, 0, 16322, 'The Lich King'),

-- Anub''arak
(34564, 0, 0, 'Ahhh, our guests have arrived, just as the master promised.', 14, 0, 100, 0, 0, 16235, 'Anub''arak - Intro'),
(34564, 1, 0, 'This place will serve as your tomb!', 14, 0, 100, 0, 0, 16234, 'Anub''arak - Aggro'),
(34564, 2, 0, 'Auum na-l ak-k-k-k, isshhh. Rise, minions. Devour...', 14, 0, 100, 0, 0, 16240, 'Anub''arak - Submerge'),
(34564, 3, 0, '%s burrows into the ground!', 41, 0, 100, 0, 0, 16240, 'Anub''arak - Burrows'),
(34564, 4, 0, '%s emerges from the ground!', 41, 0, 100, 0, 0, 0, 'Anub''arak - Emerge emote'),
(34564, 5, 0, 'The swarm shall overtake you!', 14, 0, 100, 0, 0, 16241, 'Anub''arak - Leeching Swarm'),
(34564, 6, 0, '%s unleashes a Leeching Swarm to heal himself!', 41, 0, 100, 0, 0, 16241, 'Anub''arak - Leeching Swarm emote'),
(34564, 7, 0, 'F-lakkh shir!', 14, 0, 100, 0, 0, 16236, 'Anub''arak - Killing a player'),
(34564, 7, 1, 'Another soul to sate the host.', 14, 0, 100, 0, 0, 16237, 'Anub''arak - Killing a player'),
(34564, 8, 0, 'I have failed you, master...', 14, 0, 100, 0, 0, 16238, 'Anub''arak - Death'),

-- Anub''arak Spike
(34660, 0, 0, '%s''s spikes pursue $n!', 41, 0, 100, 0, 0, 0, 'Anub''arak - Spike target');
 
-- TrinityCore\sql\updates\world\2012_08_13_01_world_creature.sql 
SET @GUID := 42575;
SET @ENTRY := 36095; -- Highlord Tirion Fordring

DELETE FROM `creature` WHERE `id`=@ENTRY;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`MovementType`) VALUES
(@GUID,@ENTRY,649,15,1,648.9167,131.0208,141.6161,0,7200,0,0);

DELETE FROM `creature_template_addon` WHERE `entry`=@ENTRY;
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `bytes2`, `auras`) VALUES
(@ENTRY,0,0x0,0x1,'57545');
 
-- TrinityCore\sql\updates\world\2012_08_14_00_world_creature_text.sql 
DELETE FROM `creature_text` WHERE `entry` IN (34990,34995);
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
-- King Varian Wrynn
(34990, 0, 0, 'Your beasts will be no match for my champions, Tirion!', 14, 0, 0, 0, 0, 16069, 'King Varian Wrynn - Northrend Beasts Outro'),
(34990, 1, 0, 'The Alliance doesn''t need the help of a demon lord to deal with Horde filth! Come, pig!', 14, 0, 100, 5, 0, 16064, 'King Varian Wrynn - Lord Jaraxxus Outro'),
(34990, 2, 0, 'Our honor has been besmirched! They make wild claims and false accusations against us. I demand justice! Allow my champions to fight in place of your knights, Tirion. We challenge the Horde!', 14, 0, 100, 5, 0, 16066, 'King Varian Wrynn - Faction Champions Intro'),
(34990, 3, 0, 'Fight for the glory of the Alliance, heroes! Honor your king and your people!', 14, 0, 100, 5, 0, 16065, 'King Varian Wrynn - Faction Champions Intro'),
(34990, 4, 0, 'GLORY TO THE ALLIANCE!', 14, 0, 100, 0, 0, 16067, 'King Varian Wrynn - Victory'),
(34990, 5, 0, 'Not even the Lich King most powerful minions can stand against the Alliance! All hail our victors!', 14, 0, 0, 0, 0, 16068, 'King Varian Wrynn - Faction Champions Outro'),
(34990, 6, 0, 'Hardly a challenge.', 14, 0, 100, 274, 0, 16061, 'King Varian Wrynn - Faction Champions Kill Player'),
(34990, 6, 1, 'HAH!', 14, 0, 100, 5, 0, 16060, 'King Varian Wrynn - Faction Champions Kill Player'),
(34990, 6, 2, 'Is this the best the Horde has to offer?', 14, 0, 100, 6, 0, 16063, 'King Varian Wrynn  - Faction Champions Kill Player'),
(34990, 6, 3, 'Worthless scrub.', 14, 0, 100, 25, 0, 16062, 'King Varian Wrynn  - Faction Champions Kill Player'),
-- Garrosh Hellscream
(34995, 0, 0, 'I''ve seen more worthy challenges in the Ring of Blood. You waste our time, paladin.', 14, 0, 100, 1, 0, 16026, 'Garrosh Hellscream  - Northrend Beasts Outro'),
(34995, 1, 0, 'Treacherous Alliance dogs! You summon a demon lord against warriors of the Horde? Your deaths will be swift!', 14, 0, 100, 5, 0, 16021, 'Garrosh Hellscream - Lord Jaraxxus Outro'),
(34995, 2, 0, 'The Horde demands justice! We challenge the Alliance. Allow us to battle in place of your knights, paladin. We will show these dogs what it means to insult the Horde!', 14, 0, 100, 1, 0, 16023, 'Garrosh Hellscream - Faction Champions Intro'),
(34995, 3, 0, 'Show them no mercy, Horde champions! LOK''TAR OGAR!', 14, 0, 0, 0, 0, 16022, 'Garrosh - Faction Champions Intro'),
(34995, 4, 0, 'That was just a taste of what the future brings. FOR THE HORDE!', 14, 0, 100, 1, 0, 16024, 'Garrosh Hellscream - Faction Champions Victory'),
(34995, 5, 0, 'Do you still question the might of the Horde, paladin? We will take on all comers!', 14, 0, 100, 1, 0, 16025, 'Garrosh Hellscream - Faction Champions Outro'),
(34995, 6, 0, 'Weakling!', 14, 0, 100, 0, 0, 16017, 'Garrosh Hellscream - Faction Champions Kill Player'),
(34995, 6, 1, 'Pathetic!', 14, 0, 100, 0, 0, 16018, 'Garrosh Hellscream - Faction Champions Kill Player'),
(34995, 6, 2, 'Overpowered.', 14, 0, 100, 0, 0, 16019, 'Garrosh Hellscream - Faction Champions Kill Player'),
(34995, 6, 3, 'Lok''tar!', 14, 0, 100, 0, 0, 16020, 'Garrosh Hellscream - Faction Champions Kill Player');
 
-- TrinityCore\sql\updates\world\2012_08_14_01_world_creature_text.sql 
DELETE FROM `script_texts` WHERE `npc_entry`=10184;
DELETE FROM `creature_text` WHERE `entry`=10184;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(10184, 0, 0, 'How fortuitous. Usually, I must leave my lair in order to feed.', 14, 0, 100, 0, 0, 0, 'Onyxia - Aggro'),
(10184, 1, 0, 'Learn your place mortal!', 14, 0, 100, 0, 0, 0, 'Onyxia - Kill Player'),
(10184, 2, 0, 'This meaningless exertion bores me. I''ll incinerate you all from above!', 14, 0, 100, 0, 0, 0, 'Onyxia - Phase 2'),
(10184, 3, 0, 'It seems you''ll need another lesson, mortals!', 14, 0, 100, 0, 0, 0, 'Onyxia - Phase 3'),
(10184, 4, 0, '%s takes in a deep breath...', 41, 0, 100, 0, 0, 0, 'Onyxia - Deep Breath Emote');
 
-- TrinityCore\sql\updates\world\2012_08_14_02_world_creature.sql 
SET @GUID := 42613;
SET @ENTRY := 28114; -- Mistcaller Soo-gan

DELETE FROM `creature` WHERE `id`=@ENTRY;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(@GUID,@ENTRY,571,1,1,0,0,6165.004,5092.975,-97.29356,0.7504916,120,0,0,117700,3809,0);

DELETE FROM `creature_template_addon` WHERE `entry`=@ENTRY;
INSERT INTO `creature_template_addon` (`entry`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `auras`) VALUES
(@ENTRY,0,0,0x10000,0x1,0,'51589 52215');

UPDATE `creature_template` SET `npcflag`=`npcflag` |1 WHERE `entry`=@ENTRY;
 
-- TrinityCore\sql\updates\world\2012_08_16_00_world_creature_template.sql 
-- Added trigger flags to triggers
UPDATE `creature_template` SET `flags_extra` = flags_extra | 128 WHERE `entry` = 34862;
UPDATE `creature_template` SET `unit_flags` = unit_flags | 256 WHERE `entry` = 34862;
 
-- TrinityCore\sql\updates\world\2012_08_16_00_world_spell_dbc.sql 
DELETE FROM `spell_dbc` WHERE `Id`=35009;
INSERT INTO `spell_dbc` (`Id`,`Attributes`,`AttributesEx`,`AttributesEx2`,`AttributesEx3`,`Targets`,`CastingTimeIndex`,`ProcCharges`,`SpellLevel`,`RangeIndex`,`Effect1`,`EffectDieSides1`,`EffectBasePoints1`,`EffectImplicitTargetA1`,`EffectImplicitTargetB1`,`EffectRadiusIndex1`,`SpellFamilyName`,`SpellFamilyFlags2`,`DmgMultiplier1`,`SchoolMask`,`Comment`) VALUES
(35009,134545792,1024,268435460,65536,64,1,101,1,13,125,1,-11,22,16,27,10,4,1,6,'Invisibility - Reducing threat');
 
-- TrinityCore\sql\updates\world\2012_08_17_00_world_spell_dbc.sql 
UPDATE `spell_dbc` SET `ProcChance`=101,`ProcCharges`=0,`SpellFamilyName`=3,`SpellFamilyFlags2`=0 WHERE `Id`=35009;
 
-- TrinityCore\sql\updates\world\2012_08_19_00_world_pickpocketing_loot_template.sql 
-- Pickpocketing_loot_template
UPDATE creature_template SET pickpocketloot=entry WHERE entry=28200;
DELETE FROM `pickpocketing_loot_template` WHERE entry=28200;
INSERT INTO `pickpocketing_loot_template` (`entry`,`item`,`ChanceorQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
-- Dark Necromance
(28200,37467,100,1,0,1,1),-- A Steamy Romance Novel: Forbidden Love
(28200,43575,100,1,0,1,1),-- Reinforced Junkbox
(28200,35952,30,1,0,1,1),-- Briny Hardcheese
(28200,33447,22,1,0,1,1),-- Runic Healing Potion
(28200,35948,10,1,0,1,1),-- Savory Snowplum
(28200,35950,10,1,0,1,1);-- Sweet Potato Bread
 
-- TrinityCore\sql\updates\world\2012_08_19_01_world_spell_dbc.sql 
DELETE FROM `spell_dbc` WHERE `Id` IN (68184,68620);
INSERT INTO `spell_dbc` (`Id`, `Dispel`, `Mechanic`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`, `AttributesEx5`, `AttributesEx6`, `AttributesEx7`, `Stances`, `StancesNot`, `Targets`, `CastingTimeIndex`, `AuraInterruptFlags`, `ProcFlags`, `ProcChance`, `ProcCharges`, `MaxLevel`, `BaseLevel`, `SpellLevel`, `DurationIndex`, `RangeIndex`, `StackAmount`, `EquippedItemClass`, `EquippedItemSubClassMask`, `EquippedItemInventoryTypeMask`, `Effect1`, `Effect2`, `Effect3`, `EffectDieSides1`, `EffectDieSides2`, `EffectDieSides3`, `EffectRealPointsPerLevel1`, `EffectRealPointsPerLevel2`, `EffectRealPointsPerLevel3`, `EffectBasePoints1`, `EffectBasePoints2`, `EffectBasePoints3`, `EffectMechanic1`, `EffectMechanic2`, `EffectMechanic3`, `EffectImplicitTargetA1`, `EffectImplicitTargetA2`, `EffectImplicitTargetA3`, `EffectImplicitTargetB1`, `EffectImplicitTargetB2`, `EffectImplicitTargetB3`, `EffectRadiusIndex1`, `EffectRadiusIndex2`, `EffectRadiusIndex3`, `EffectApplyAuraName1`, `EffectApplyAuraName2`, `EffectApplyAuraName3`, `EffectAmplitude1`, `EffectAmplitude2`, `EffectAmplitude3`, `EffectMultipleValue1`, `EffectMultipleValue2`, `EffectMultipleValue3`, `EffectMiscValue1`, `EffectMiscValue2`, `EffectMiscValue3`, `EffectMiscValueB1`, `EffectMiscValueB2`, `EffectMiscValueB3`, `EffectTriggerSpell1`, `EffectTriggerSpell2`, `EffectTriggerSpell3`, `EffectSpellClassMaskA1`, `EffectSpellClassMaskA2`, `EffectSpellClassMaskA3`, `EffectSpellClassMaskB1`, `EffectSpellClassMaskB2`, `EffectSpellClassMaskB3`, `EffectSpellClassMaskC1`, `EffectSpellClassMaskC2`, `EffectSpellClassMaskC3`, `MaxTargetLevel`, `SpellFamilyName`, `SpellFamilyFlags1`, `SpellFamilyFlags2`, `SpellFamilyFlags3`, `MaxAffectedTargets`, `DmgClass`, `PreventionType`, `DmgMultiplier1`, `DmgMultiplier2`, `DmgMultiplier3`, `AreaGroupId`, `SchoolMask`, `Comment`) VALUES
(68184, 0, 0, 545259904, 0, 5, 268697856, 128, 0, 16777216, 0, 0, 0, 0, 1, 0, 0, 101, 0, 0, 0, 0, 0, 1, 0, -1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 7, 0, 0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Faction Champions - credit marker'),
(68620, 0, 0, 545259904, 0, 5, 268697856, 128, 0, 16777216, 0, 0, 0, 0, 1, 0, 0, 101, 0, 0, 0, 0, 0, 1, 0, -1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 7, 0, 0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Resilience Will Fix It - achievement credit marker');
 
-- TrinityCore\sql\updates\world\2012_08_20_00_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE (`spell_id`='33695');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(33695, 'spell_pal_exorcism_and_holy_wrath_damage');
 
-- TrinityCore\sql\updates\world\2012_08_20_01_world_wintergrasp_conditions.sql 
-- Conditions
-- Add gossip_menu condition for 9904 Horde
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (14,15) AND `SourceGroup` IN (9904,9923);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`) VALUES
(14,9904,13759,0,1,33280), -- Must have Rank 1: Corporal
(14,9904,13759,1,1,55629), -- Or must have Rank 2: First Lieutenant
(14,9904,13761,0,11,33280), -- Must not have Rank 1: Corporal
(14,9904,13761,0,11,55629), -- Must not have Rank 2: First Lieutenant
-- Add gossip_menu condition for 9923 Alliance
(14,9923,13798,0,1,33280), -- Must have Rank 1: Corporal
(14,9923,13798,1,1,55629), -- Or must have Rank 2: First Lieutenant
(14,9923,14172,0,11,33280), -- Must not have Rank 1: Corporal
(14,9923,14172,0,11,55629), -- Must not have Rank 2: First Lieutenant
-- Add conditions to gossip options horde
(15,9904,0,0,1,33280), -- Must have reached Rank 1: Corporal
(15,9904,0,1,1,55629), -- Or must have reached Rank 2: First Lieutenant
(15,9904,1,0,1,55629), -- Must have reached Rank 2: First Lieutenant
(15,9904,2,0,1,55629), -- Must have reached Rank 2: First Lieutenant
-- Add conditions to gossip options alliance
(15,9923,0,0,1,33280), -- Must have reached Rank 1: Corporal
(15,9923,0,1,1,55629), -- Or must have reached Rank 2: First Lieutenant
(15,9923,1,0,1,55629), -- Must have reached Rank 2: First Lieutenant
(15,9923,2,0,1,55629); -- Must have reached Rank 2: First Lieutenant

/* Spell target conditions for spawning WG siege machines in proper place while building it */
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (56575,56661,56663,61408);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 56575, 0, 0, 31, 0, 3, 27852, 0, 0, 0, '', NULL),
(13, 1, 56661, 0, 0, 31, 0, 3, 27852, 0, 0, 0, '', NULL),
(13, 1, 56663, 0, 0, 31, 0, 3, 27852, 0, 0, 0, '', NULL),
(13, 1, 61408, 0, 0, 31, 0, 3, 27852, 0, 0, 0, '', NULL);
 
-- TrinityCore\sql\updates\world\2012_08_20_02_world_wintergrasp_creatures.sql 
UPDATE `creature_template` SET `exp`=0, `ScriptName`= 'npc_wg_spirit_guide' WHERE `entry`=31841; -- Taunka Spirit Guide
UPDATE `creature_template` SET `exp`=0, `ScriptName`= 'npc_wg_spirit_guide' WHERE `entry`=31842; -- Dwarven Spirit Guide
UPDATE `creature_template` SET `exp`=0, `ScriptName`= 'npc_wg_quest_giver' WHERE `entry`=31052; -- Bowyer Randolph
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|768 WHERE `entry`=39172; -- Marshal Magruder
UPDATE `creature_template` SET `npcflag`=`npcflag`|128 WHERE `entry`=30488; -- Travis Day
UPDATE `creature_template` SET `exp`=0, `ScriptName`= 'npc_wg_quest_giver' WHERE `entry`=31053; -- Primalist Mulfort
UPDATE `creature_template` SET `dynamicflags`=`dynamicflags`|4, `ScriptName`= 'npc_wg_quest_giver' WHERE `entry`=31107; -- Lieutenant Murp (?)
UPDATE `creature_template` SET `baseattacktime`=2000,`unit_flags`=`unit_flags`|768 WHERE `entry`=39173; -- Champion Ros'slai
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|16 WHERE `entry`=30740; -- Valiance Expedition Champion (?)
UPDATE `creature_template` SET `InhabitType`=7 WHERE `entry`=27852; -- Wintergrasp Control Arms
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216, `spell1`=51421, /* Fire Cannon */ `spell2`=0,`spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=28366; -- Wintergrasp Tower Cannon
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216,`unit_flags`=16384,`unit_class`=4,`speed_walk`=1.2,`spell1`=57609, /* Fire Cannon */ `spell2`=0,`spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=32629; -- Wintergrasp Siege Turret (H)
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216,`unit_flags`=16384,`unit_class`=4,`speed_walk`=1.2, `spell1`=57609, /* Fire Cannon */ `spell2`=0,`spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=28319; -- Wintergrasp Siege Turret (A)
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216,`unit_flags`=16384,`unit_class`=4,`speed_walk`=1.2,`speed_run`=1, `spell1`=54109, /* Ram */ `spell2`=0,`spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=32627; -- Wintergrasp Siege Engine (H)
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216,`unit_flags`=16384,`unit_class`=4,`speed_walk`=1.2,`speed_run`=1, `spell1`=54109, /* Ram */ `spell2`=0,`spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=28312; -- Wintergrasp Siege Engine (A)
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216,`unit_flags`=16384,`speed_walk`=1.2,`speed_run`=1, `spell1`=54107, /* Ram */ `spell2`=50896, /* Hurl Boulder */ `spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=28094; -- Wintergrasp Demolisher
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1735,`npcflag`=16777216,`unit_flags`=16384,`unit_class`=4,`speed_walk`=2.8,`speed_run`=1.71429, `spell1`=57606, /* Plague Barrel */ `spell2`=50989, /* Flame Breath */ `spell3`=0,`spell4`=0,`spell5`=0,`spell6`=0,`spell7`=0,`spell8`=0 WHERE `entry`=27881; -- Wintergrasp Catapult
UPDATE `creature_template` SET `ScriptName`= 'npc_wg_queue' WHERE `entry` IN (32169,32170,35599,35596,35600,35601,35598,35603,35602,35597,35612,35611); -- <Wintergrasp Battle-Master>
UPDATE `creature_template` SET `ScriptName`= 'npc_wg_demolisher_engineer' WHERE `entry` IN (30400,30499); -- Goblin Mechanic, Gnomish Engineer
UPDATE `creature_template` SET `ScriptName`= 'npc_wg_quest_giver' WHERE `entry` IN (31054,31091,31036,31101,31051,31153,31151,31102,31106);
UPDATE `creature_template` SET `gossip_menu_id`=9904 WHERE `entry`=30400;
UPDATE `creature_template` SET `gossip_menu_id`=10229 WHERE `entry`=31091;

UPDATE `creature_model_info` SET `bounding_radius`=0.3366,`combat_reach`=1.65,`gender`=0 WHERE `modelid`=27894; -- Knight Dameron
UPDATE `creature_model_info` SET `bounding_radius`=0.3366,`combat_reach`=1.65,`gender`=0 WHERE `modelid`=31346; -- Marshal Magruder
UPDATE `creature_model_info` SET `bounding_radius`=0.3366,`combat_reach`=1.65,`gender`=0 WHERE `modelid`=31347; -- Champion Ros'slai
UPDATE `creature_model_info` SET `bounding_radius`=0.305,`combat_reach`=5,`gender`=2 WHERE `modelid`=25301; -- Wintergrasp Siege Turret

DELETE FROM `creature_template_addon` WHERE `entry` IN (31841,31842,30400,30499,30489,30869,31036,31051,31052,31054,31108,31109,31153,32294,39172,30870,31053,31091,31101,31102,31106,31107,31151,32296,39173,30740,32629,28319,28366,32627,28312,28094,27881,30739);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31841,0,0,1,0, '58729'), -- Taunka Spirit Guide (Spiritual Immunity, Spirit Heal Channel) FIX: Do we need the spell that revives players here (22011)? It has a duration (found in sniffs). 
(31842,0,0,1,0, '58729'), -- Dwarven Spirit Guide                                               This spell (and the spell it triggers, are used in the "ressurect system" in Battleground.cpp
(30400,0,0,1,0, NULL), -- Goblin Mechanic
(30499,0,0,1,0, NULL), -- Gnomish Engineer
(30489,0,0,1,0, NULL), -- Morgan Day
(30869,0,0,1,0, NULL), -- Arzo Safeflight
(31036,14337,0,257,0, NULL), -- Commander Zanneth
(31051,0,0,1,0, NULL), -- Sorceress Kaylana
(31052,0,0,257,0, NULL), -- Bowyer Randolph
(31054,0,0,257,0, NULL), -- Anchorite Tessa
(31108,0,0,257,0, NULL), -- Siege Master Stouthandle
(31109,0,0,257,0, NULL), -- Senior Demolitionist Legoso
(31153,6569,0,257,0, NULL), -- Tactical Officer Ahbramis
(32294,27247,0,1,0, NULL), -- Knight Dameron
(39172,28912,0,1,0, NULL), -- Marshal Magruder
(30870,0,0,1,0, NULL), -- Herzo Safeflight
(31053,0,0,257,0, '18950'), -- Primalist Mulfort (Invisibility and Stealth Detection ... why?)
(31091,0,0,257,0, '18950'), -- Commander Dardosh (Invisibility and Stealth Detection)
(31101,0,0,1,0, NULL), -- Hoodoo Master Fu'jin
(31102,0,0,1,0, NULL), -- Vieron Blazefeather
(31106,0,0,257,0, NULL), -- Siegesmith Stronghoof
(31107,0,0,257,0, NULL), -- Lieutenant Murp
(31151,0,0,257,0, NULL), -- Tactical Officer Kilrath
(32296,27245,0,1,0, NULL), -- Stone Guard Mukar
(39173,29261,0,1,0, NULL), -- Champion Ros'slai
(30740,0,0,257,375, NULL), -- Valiance Expedition Champion
(32629,0,0,257,0, NULL), -- Wintergrasp Siege Turret
(28319,0,0,257,0, NULL), -- Wintergrasp Siege Turret
(28366,0,0,257,0, NULL), -- Wintergrasp Tower Cannon
(32627,0,0,257,0, NULL), -- Wintergrasp Siege Engine
(28312,0,0,257,0, NULL), -- Wintergrasp Siege Engine
(28094,0,0,257,0, NULL), -- Wintergrasp Demolisher
(27881,0,0,257,0, NULL), -- Wintergrasp Catapult
(30739,0,0,257,375, NULL); -- Warsong Champion
 
-- TrinityCore\sql\updates\world\2012_08_20_03_world_wintergrasp_gameobjects.sql 
UPDATE `gameobject_template` SET `faction`=114 WHERE `entry` IN (192310,192312,192313,192314,192316,192317,192318,192319,192320,192321,192322,192323,192324,192325,192326,192327,192328,192329,
192330,192331,192332,192333,192334,192335,192286,192287,192292,192299,192304,192305,192306,192307,192308,192309); -- Alliance Banner

UPDATE `gameobject_template` SET `faction`=114 WHERE `entry` IN (192269,192284,192285,192338,192339,192349,192350,192351,192352,192353,192354,192355,192356,192357,192358,192359,192360,192361,
192362,192363,192364,192366,192367,192368,192369,192370,192371,192372,192373,192374,192375,192376,192377,192378,192379,192254,
192255,192336); -- Horde Banner

UPDATE `gameobject_template` SET `faction`=114 WHERE `entry` IN (193096,193097,193098,193099,193100,193101,193102,193103,193104,193105,193106,193107,193108,193109,193124,193125,193126,193127,
193128,193129,193130,193131,193132,193133,193134,193135,193136,193137,193138,193139,193140,193141,193142,193143,193144,193145,
193146,193147,193148,193149,193150,193151,193152,193153,193154,193155,193156,193157,193158,193159,193160,193161,193162,193163,
193164,193165); -- nameless GOs

UPDATE `gameobject_template` SET `ScriptName`= 'go_wg_vehicle_teleporter' WHERE `entry`=192951; -- Vehicle Teleporter

-- Before pushing to master check if guids are free.
-- Spawns Workshop Capture Points
SET @GUID := 71385;
DELETE FROM gameobject WHERE id IN (190475,190487,194959,194962);
DELETE FROM gameobject WHERE guid BETWEEN @GUID AND @GUID+3;
INSERT INTO gameobject (guid,id,position_x,position_y,position_z,orientation,map) VALUES
(@GUID+0, 190475, 4949.344238, 2432.585693, 320.176971, 1.386214, 571), -- ne
(@GUID+1, 190487, 4948.524414, 3342.337891, 376.875366, 4.400566, 571), -- nw
(@GUID+2, 194959, 4398.076660, 2356.503662, 376.190491, 0.525406, 571), -- se
(@GUID+3, 194962, 4390.776367, 3304.094482, 372.429077, 6.097023, 571); -- sw

-- Misc objects in fortress phased properly
SET @OGUID := 71389;
DELETE FROM `gameobject` WHERE `id` IN (193096,193097,193098,193099,193100,193101,193102,193103,193104,193105,193106,193107,193108,193109,193124,193125,193126,193127,193128,193129,193130,193131,193132,193133,193134,193135,193136,193137,193138,193139,193140,193141,193142,193143,193144,193145,193146,193147,193148,193149,193150,193151,193152,193153,193154,193155,193156,193157,193158,193159,193160,193161,193162,193163,193164,193165);
DELETE FROM `gameobject` WHERE `guid` BETWEEN @OGUID AND @OGUID+55;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(@OGUID+0,193096,571,1,128,5379.885,3008.093,409.181915,-3.124123,0,0,0,0,120,0,1),
(@OGUID+1,193097,571,1,128,5381.73975,3008.15454,409.181915,2.98449826,0,0,0,0,120,0,1),
(@OGUID+2,193098,571,1,128,5383.672,3008.02783,409.181915,-3.115388,0,0,0,0,120,0,1),
(@OGUID+3,193099,571,1,128,5386.25342,3007.79614,409.181915,2.932139,0,0,0,0,120,0,1),
(@OGUID+4,193100,571,1,128,5387.354,3009.64941,409.181915,-1.30899549,0,0,0,0,120,0,1),
(@OGUID+5,193101,571,1,128,5381.12744,3010.09717,409.181915,-2.72271276,0,0,0,0,120,0,1),
(@OGUID+6,193102,571,1,128,5383.12061,3007.90967,410.8231,-2.530723,0,0,0,0,120,0,1),
(@OGUID+7,193103,571,1,128,5381.105,3007.89575,410.8231,-3.09791875,0,0,0,0,120,0,1),
(@OGUID+8,193104,571,1,128,5376.777,3010.619,409.191742,-2.60926127,0,0,0,0,120,0,1),
(@OGUID+9,193105,571,1,128,5381.47559,3010.24731,410.8231,-2.80997539,0,0,0,0,120,0,1),
(@OGUID+10,193106,571,1,128,5381.059,3009.85864,410.8231,2.66161919,0,0,0,0,120,0,1),
(@OGUID+11,193107,571,1,128,5381.038,3010.44263,410.8157,-2.0507617,0,0,0,0,120,0,1),
(@OGUID+12,193108,571,1,128,5379.83154,3007.82373,410.8161,-2.02457881,0,0,0,0,120,0,1),
(@OGUID+13,193109,571,1,128,5379.99463,3008.40356,410.815918,-3.03687477,0,0,0,0,120,0,1),
(@OGUID+14,193124,571,1,128,5293.65869,2924.44019,409.29306,1.20427489,0,0,0,0,120,0,1),
(@OGUID+15,193125,571,1,1,5293.28,2932.32813,409.065247,-2.49581814,0,0,0,0,120,0,1),
(@OGUID+16,193126,571,1,1,5292.30469,2930.5105,409.157135,-3.06302428,0,0,0,0,120,0,1),
(@OGUID+17,193127,571,1,64,5293.349,2923.712,409.844757,-1.8762306,0,0,0,0,120,0,1),
(@OGUID+18,193128,571,1,128,5293.12256,2895.22754,409.208771,-0.9861096,0,0,0,0,120,0,1),
(@OGUID+19,193129,571,1,128,5292.913,2895.54346,410.419617,-0.122171074,0,0,0,0,120,0,1),
(@OGUID+20,193130,571,1,128,5294.09473,2894.191,409.164063,-0.7330382,0,0,0,0,120,0,1),
(@OGUID+21,193131,571,1,128,5295.1875,2895.382,409.143219,-0.349065244,0,0,0,0,120,0,1),
(@OGUID+22,193132,571,1,128,5294.527,2895.57471,410.6591,-1.92858779,0,0,0,0,120,0,1),
(@OGUID+23,193133,571,1,128,5295.3916,2895.05737,410.6686,0.6894028,0,0,0,0,120,0,1),
(@OGUID+24,193134,571,1,128,5295.13525,2895.68481,410.618866,-2.22529364,0,0,0,0,120,0,1),
(@OGUID+25,193135,571,1,128,5294.97559,2895.33521,410.657684,-2.73143482,0,0,0,0,120,0,1),
(@OGUID+26,193136,571,1,128,5293.22559,2895.46436,410.413483,-0.802850962,0,0,0,0,120,0,1),
(@OGUID+27,193137,571,1,128,5295.56,2895.24146,410.628052,-2.11184788,0,0,0,0,120,0,1),
(@OGUID+28,193138,571,1,128,5293.741,2894.48169,409.183167,-2.72271276,0,0,0,0,120,0,1),
(@OGUID+29,193139,571,1,64,5294.599,2786.85254,409.8877,-2.356195,0,0,0,0,120,0,1),
(@OGUID+30,193140,571,1,64,5294.37939,2785.03833,409.175018,-2.33873963,0,0,0,0,120,0,1),
(@OGUID+31,193141,571,1,64,5293.205,2787.03052,409.218872,3.03687477,0,0,0,0,120,0,1),
(@OGUID+32,193142,571,1,64,5294.241,2786.42456,409.174347,0.0174524616,0,0,0,0,120,0,1),
(@OGUID+33,193143,571,1,64,5291.705,2785.86646,409.282135,-2.03330517,0,0,0,0,120,0,1),
(@OGUID+34,193144,571,1,64,5293.03369,2785.632,409.22522,-1.2915417,0,0,0,0,120,0,1),
(@OGUID+35,193145,571,1,64,5295.866,2787.7666,409.1923,2.155478,0,0,0,0,120,0,1),
(@OGUID+36,193146,571,1,64,5293.56445,2787.31079,410.55954,0.261798173,0,0,0,0,120,0,1),
(@OGUID+37,193147,571,1,128,5233.12061,2920.362,409.163544,-0.7243115,0,0,0,0,120,0,1),
(@OGUID+38,193148,571,1,128,5238.27539,2920.67358,409.256439,-0.418878615,0,0,0,0,120,0,1),
(@OGUID+39,193149,571,1,128,5235.902,2920.751,409.224457,-0.951203167,0,0,0,0,120,0,1),
(@OGUID+40,193150,571,1,128,5237.36963,2919.89771,409.556641,0.8202983,0,0,0,0,120,0,1),
(@OGUID+41,193151,571,1,128,5234.19775,2918.99731,409.322754,-2.33873963,0,0,0,0,120,0,1),
(@OGUID+42,193152,571,1,128,5234.52344,2921.76221,409.175781,-2.2165668,0,0,0,0,120,0,1),
(@OGUID+43,193153,571,1,128,5234.119,2918.93921,409.1339,-3.098036,0,0,0,0,120,0,1),
(@OGUID+44,193154,571,1,128,5234.26758,2919.40015,409.502869,-2.18166113,0,0,0,0,120,0,1),
(@OGUID+45,193155,571,1,128,5293.37939,2746.05566,409.22052,-0.06981169,0,0,0,0,120,0,1),
(@OGUID+46,193156,571,1,128,5293.65039,2755.67529,409.1913,-0.43633157,0,0,0,0,120,0,1),
(@OGUID+47,193157,571,1,128,5292.23535,2753.59473,409.0867,-0.357789934,0,0,0,0,120,0,1),
(@OGUID+48,193158,571,1,128,5292.42969,2748.62427,409.131042,0.253072351,0,0,0,0,120,0,1),
(@OGUID+49,193159,571,1,128,5293.384,2750.90283,409.234924,-0.0610866137,0,0,0,0,120,0,1),
(@OGUID+50,193160,571,1,64,5371.89746,2805.47583,409.3072,0.0610866137,0,0,0,0,120,0,1),
(@OGUID+51,193161,571,1,64,5376.616,2875.105,409.254822,1.59697616,0,0,0,0,120,0,1),
(@OGUID+52,193162,571,1,128,5377.54932,2870.92456,409.239166,-0.549776852,0,0,0,0,120,0,1),
(@OGUID+53,193163,571,1,128,5378.068,2813.61719,409.239166,1.55334139,0,0,0,0,120,0,1),
(@OGUID+54,193164,571,1,128,5378.921,2805.43677,409.239166,1.53588688,0,0,0,0,120,0,1),
(@OGUID+55,193165,571,1,128,5378.452,2876.67456,409.239166,1.54461825,0,0,0,0,120,0,1);
 
-- TrinityCore\sql\updates\world\2012_08_20_04_world_wintergrasp_gossips.sql 
-- Gossip Menu
DELETE FROM `gossip_menu` WHERE `entry`=9904 AND `text_id`=13759;
DELETE FROM `gossip_menu` WHERE `entry`=9904 AND `text_id`=13761;
DELETE FROM `gossip_menu` WHERE `entry`=9923 AND `text_id`=14172;
DELETE FROM `gossip_menu` WHERE `entry`=10229 AND `text_id`=14221;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(9904,13759),
(9904,13761),
(9923,14172),
(10229,14221);

-- Gossip Menu Option
DELETE FROM `gossip_menu_option` WHERE `menu_id`=9904;
DELETE FROM `gossip_menu_option` WHERE `menu_id`=10129 AND `id` IN (2,4);
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`box_coded`,`box_money`,`box_text`) VALUES
(9904,0,0, 'I would like to build a catapult.',1,1,0,0,0,0, ''),
(9904,1,0, 'I would like to build a demolisher.',1,1,0,0,0,0, ''),
(9904,2,0, 'I would like to build a siege engine.',1,1,0,0,0,0, ''),
(10129,2,0, 'Guide me to the Broken Temple Graveyard.',1,1,0,0,0,0, ''),
(10129,4,0, 'Guide me to the Eastspark Graveyard.',1,1,0,0,0,0, '');
 
-- TrinityCore\sql\updates\world\2012_08_20_05_world_wintergrasp_quests.sql 
-- Wintergrasp Quests - Horde
UPDATE `quest_template` SET `ExclusiveGroup`=13180 WHERE `id` IN (13180,13178); -- Slay them all!
UPDATE `quest_template` SET `ExclusiveGroup`=13185 WHERE `id` IN (13185,13223); -- Stop/Defend the Siege
UPDATE `quest_template` SET `ExclusiveGroup`=13201 WHERE `id` IN (13201,13194); -- Healing with Roses
UPDATE `quest_template` SET `ExclusiveGroup`=13199 WHERE `id` IN (13193,13199); -- Bones and Arrows
UPDATE `quest_template` SET `ExclusiveGroup`=13192 WHERE `id` IN (13192,13202); -- Warding/Jinxing the Walls
UPDATE `quest_template` SET `ExclusiveGroup`=13200 WHERE `id` IN (13200,13191); -- Fueling the Demolishers

-- Wintergrasp Quests - Alliance
UPDATE `quest_template` SET `ExclusiveGroup`=13179 WHERE `id` IN (13179,13177); -- No Mercy for the Merciless
UPDATE `quest_template` SET `ExclusiveGroup`=13186 WHERE `id` IN (13186,13222); -- Stop/Defend the Siege
UPDATE `quest_template` SET `ExclusiveGroup`=13195 WHERE `id` IN (13195,13156); -- A Rare Herb
UPDATE `quest_template` SET `ExclusiveGroup`=13196 WHERE `id` IN (13196,13154); -- Bones and Arrows
UPDATE `quest_template` SET `ExclusiveGroup`=13198 WHERE `id` IN (13198,13153); -- Warding the Warriors

-- Note: The offered quests (they are in pairs) depend on who controls the keep. npc_wg_quest_giver does that already?
 
-- TrinityCore\sql\updates\world\2012_08_20_06_world_wintergrasp_spells.sql 
--  54640 Teleport (Teleports defenders behind the walls on the Isle of Ulduran, Strand of the Ancients) - FIX THIS?
DELETE FROM `spell_linked_spell` WHERE `spell_trigger`=54640;
INSERT INTO `spell_linked_spell` (`spell_trigger`,`spell_effect`,`type`,`comment`) VALUES
(54640,54643,0, 'WG teleporter');

-- Spell area
DELETE FROM `spell_area` WHERE `spell` IN (58730,57940);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_start_active`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`) VALUES
(58730,4581,0,0,0,0,0,2,1), -- Restricted Flight Area (Wintergrasp Eject)
(58730,4539,0,0,0,0,0,2,1),
(58730,4197,0,0,0,0,0,2,1),
(58730,4585,0,0,0,0,0,2,1),
(58730,4612,0,0,0,0,0,2,1),
(58730,4582,0,0,0,0,0,2,1),
(58730,4583,0,0,0,0,0,2,1),
(58730,4589,0,0,0,0,0,2,1),
(58730,4575,0,0,0,0,0,2,1),
(58730,4538,0,0,0,0,0,2,1),
(58730,4577,0,0,0,0,0,2,1),
(57940,65,0,0,0,0,0,2,1), -- Essence of Wintergrasp
(57940,66,0,0,0,0,0,2,1),
(57940,67,0,0,0,0,0,2,1),
(57940,206,0,0,0,0,0,2,1),
(57940,210,0,0,0,0,0,2,1),
(57940,394,0,0,0,0,0,2,1),
(57940,395,0,0,0,0,0,2,1),
(57940,1196,0,0,0,0,0,2,1),
(57940,2817,0,0,0,0,0,2,1),
(57940,3456,0,0,0,0,0,2,1),
(57940,3477,0,0,0,0,0,2,1),
(57940,3537,0,0,0,0,0,2,1),
(57940,3711,0,0,0,0,0,2,1),
(57940,4100,0,0,0,0,0,2,1),
(57940,4196,0,0,0,0,0,2,1),
(57940,4228,0,0,0,0,0,2,1),
(57940,4264,0,0,0,0,0,2,1),
(57940,4265,0,0,0,0,0,2,1),
(57940,4272,0,0,0,0,0,2,1),
(57940,4273,0,0,0,0,0,2,1),
(57940,4395,0,0,0,0,0,2,1),
(57940,4415,0,0,0,0,0,2,1),
(57940,4416,0,0,0,0,0,2,1),
(57940,4493,0,0,0,0,0,2,1),
(57940,4494,0,0,0,0,0,2,1),
(57940,4603,0,0,0,0,0,2,1);

DELETE FROM `spell_area` WHERE `spell` IN (56618, 56617);
INSERT INTO `spell_area` (`spell`,`area`,`autocast`) VALUES
(56618, 4538, 1),
(56617, 4538, 1),
(56618, 4539, 1),
(56617, 4539, 1),
(56618, 4611, 1),
(56617, 4611, 1),
(56618, 4612, 1),
(56617, 4612, 1);

-- Spell scripts. replace with SAI
DELETE FROM `spell_scripts` WHERE `id`=49899;
INSERT INTO `spell_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(49899,0,1,406,0,0,0,0,0,0); -- Activate Robotic Arms 

-- Spell Target position for Wintergrasp Graveyard spells
DELETE FROM `spell_target_position` WHERE `id` IN (59760,59762,59763,59765,59766,59767,59769);
INSERT INTO `spell_target_position` (`id`,`target_map`,`target_position_x`,`target_position_y`,`target_position_z`,`target_orientation`) VALUES
(59760,571,5537.986,2897.493,517.057,4.819249), -- Teleport: Fortress Graveyard 
(59762,571,5104.750,2300.940,368.579,0.733038), -- Teleport: Sunken Ring "area 4538"
(59763,571,5099.120,3466.036,368.484,5.317802), -- Teleport: Broken Temple "area 4539 & 4589"
(59765,571,5032.454,3711.382,372.468,3.971623), -- Teleport: Horde Landing Zone
(59766,571,4331.716,3235.695,390.251,0.008500), -- Teleport: Westspark Factory Graveyard "area 4611"
(59767,571,4314.648,2408.522,392.642,6.268125), -- Teleport: Eastspark Factory Graveyard "area 4612"
(59769,571,5140.790,2179.120,390.950,1.972220); -- Teleport: Alliance Landing Zone

DELETE FROM `spell_script_names` WHERE `spell_id` IN (61409, 56662, 56664, 56659, 49899, 61178);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(61409, 'spell_wintergrasp_force_building'),
(56659, 'spell_wintergrasp_force_building'),
(56662, 'spell_wintergrasp_force_building'),
(56664, 'spell_wintergrasp_force_building'),
(49899, 'spell_wintergrasp_force_building'),
(61178, 'spell_wintergrasp_grab_passenger');
 
-- TrinityCore\sql\updates\world\2012_08_20_07_world_wintergrasp_texts.sql 
-- Unused yet: 
-- Wintergrasp is under attack!
-- Wintergrasp Fortress is under attack!
-- Winter's Edge Tower is under attack!
-- Eastern Bridge is under attack!
-- Western Bridge is under attack!
-- Westspark Bridge is under attack!
-- Flamewatch Tower is under attack!

-- 'You have reached Rank 1: Corporal' Sent to player by raid leader
-- 'You have reached Rank 2: First Lieutenant' Sent to player by raid leader

-- Wintergrasp coreside texts
DELETE FROM `trinity_string` WHERE `entry` BETWEEN 12050 AND 12072;
INSERT INTO `trinity_string` (`entry`,`content_default`,`content_loc1`,`content_loc2`,`content_loc3`,`content_loc4`,`content_loc5`,`content_loc6`,`content_loc7`,`content_loc8`)VALUES
(12050, '%s has been captured by %s ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12051, '%s is under attack by %s', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12052, 'The Broken Temple siege workshop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12053, 'Eastspark siege workshop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12054, 'Westspark siege workshop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12055, 'The Sunken Ring siege workshop', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12057, 'Alliance', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12056, 'Horde', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12058, 'The battle for Wintergrasp is about to begin!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12059, 'You have reached Rank 1: Corporal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12060, 'You have reached Rank 2: First Lieutenant', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12061, 'The south-eastern keep tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12062, 'The north-eastern keep tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12063, 'The south-western keep tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12064, 'The north-western keep tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12065, '%s has been damaged !', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12066, '%s has been destroyed!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12067, 'The battle for Wintergrasp begin!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12068, '%s has successfully defended the Wintergrasp fortress!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12069, 'The southern tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12070, 'The eastern tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12071, 'The western tower', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12072, 'The Wintergrasp fortress has been captured by %s !', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Wintergrasp script texts
DELETE FROM `script_texts` WHERE entry BETWEEN -1850507 AND -1850500;
INSERT INTO `script_texts` (`npc_entry`,`entry`,`content_default`,`content_loc1`,`content_loc2`,`content_loc3`,`content_loc4`,`content_loc5`,`content_loc6`,`content_loc7`,`content_loc8`,`sound`,`type`,`language`,`emote`,`comment`)VALUES
(0, -1850500, 'Guide me to the Fortress Graveyard.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850501, 'Guide me to the Sunken Ring Graveyard.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850502, 'Guide me to the Broken Temple Graveyard.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850503, 'Guide me to the Westspark Graveyard.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850504, 'Guide me to the Eastspark Graveyard.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850505, 'Guide me back to the Horde landing camp.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850506, 'Guide me back to the Alliance landing camp.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''),
(0, -1850507, 'Se mettre dans la file pour le Joug-d''hiver.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, ''); -- (Needs proper english text, maybe "Get in the queue for Wintergrasp."?)

-- New support-commands for battlefield class
DELETE FROM `command` WHERE name IN ('bf start', 'bf stop', 'bf enable', 'bf switch', 'bf timer');
INSERT INTO `command` (`name`,`security`,`help`) VALUES
('bf start',3,'Syntax: .bf start #battleid'),
('bf stop',3,'Syntax: .bf stop #battleid'),
('bf enable',3,'Syntax: .bf enable #battleid'),
('bf switch',3,'Syntax: .bf switch #battleid'),
('bf timer',3,'Syntax: .bf timer #battleid #timer');

-- NPC talk text insert from sniff
DELETE FROM `creature_text` WHERE `entry`=15214 AND `groupid` BETWEEN 0 AND 30;
DELETE FROM `creature_text` WHERE `entry` IN (31036,31091) AND `groupid` BETWEEN 0 AND 3;
DELETE FROM `creature_text` WHERE `entry` IN (31108,31109,34924) AND `groupid`=0;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(15214,0,0, 'Let the battle begin!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,1,0, 'The southern tower has been damaged!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,2,0, 'The southern tower has been destroyed!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,3,0, 'The eastern tower has been damaged!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,4,0, 'The eastern tower has been destroyed!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,5,0, 'The western tower has been damaged!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,6,0, 'The western tower has been destroyed!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,7,0, 'The north-western keep tower has been damaged!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,8,0, 'The north-western keep tower has been destroyed!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,9,0, 'The south-eastern keep tower has been damaged!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,10,0, 'The south-eastern keep tower has been destroyed!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,11,0, 'The Broken Temple siege workshop has been attacked by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,12,0, 'The Broken Temple siege workshop has been captured by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,13,0, 'The Broken Temple siege workshop has been attacked by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,14,0, 'The Broken Temple siege workshop has been captured by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,15,0, 'The Eastspark siege workshop has been attacked by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,16,0, 'The Eastspark siege workshop has been captured by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,17,0, 'The Eastspark siege workshop has been attacked by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,18,0, 'The Eastspark siege workshop has been captured by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,19,0, 'The Sunken Ring siege workshop has been attacked by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,20,0, 'The Sunken Ring siege workshop has been captured by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,21,0, 'The Sunken Ring siege workshop has been attacked by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,22,0, 'The Sunken Ring siege workshop has been captured by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,23,0, 'The Westspark siege workshop has been attacked by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,24,0, 'The Westspark siege workshop has been captured by the Alliance!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,25,0, 'The Westspark siege workshop has been attacked by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,26,0, 'The Westspark siege workshop has been captured by the Horde!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,27,0, 'The Alliance has defended Wintergrasp Fortress!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,28,0, 'The Alliance has captured Wintergrasp Fortress!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,29,0, 'The Horde has defended Wintergrasp Fortress!',3,0,100,0,0,0, 'Invisible Stalker'),
(15214,30,0, 'The Horde has captured Wintergrasp Fortress!',3,0,100,0,0,0, 'Invisible Stalker'),
-- Not sure if all Alliance text is here, need horde text
(31036,0,0, 'The first of the Horde towers has fallen! Destroy all three and we will hasten their retreat!',1,7,100,0,0,0, 'Commander Zanneth'),
(31036,1,0, 'The second tower has fallen! Destroy the final tower and we will hasten their retreat!',1,7,100,0,0,0, 'Commander Zanneth'),
(31036,2,0, 'The Horde towers have fallen! We have forced their hand. Finish off the remaining forces!',1,7,100,0,0,0, 'Commander Zanneth'),
(31036,3,0, 'Show those animals no mercy, $n!',0,7,100,0,0,0, 'Commander Zanneth'),
(31091,0,0, 'The first of the Alliance towers has fallen! Destroy all three and we will hasten their retreat!',1,7,100,0,0,0, 'Commander Dardosh'),
(31091,1,0, 'Lok''tar! The second tower falls! Destroy the final tower and we will hasten their retreat!',1,7,100,0,0,0, 'Commander Dardosh'),
(31091,2,0, 'The Alliance towers have fallen! We have forced their hand. Finish off the remaining forces!',1,7,100,0,0,0, 'Commander Dardosh'),
(31091,3,0, 'Show those animals no mercy, $n!',0,7,100,0,0,0, 'Commander Dardosh'), -- ???
(31108,0,0, 'Stop the Horde from retrieving the embers, $n. We cannot risk them having the advantage when the battle resumes!',0,7,100,0,0,0, 'Siege Master Stouthandle'),
(31109,0,0, 'Destroy their foul machines of war, $n!',0,7,100,0,0,0, 'Senior Demolitionist Legoso'),
(34924,0,0, 'The gates have been breached! Defend the keep!',1,0,100,0,0,0, 'High Commander Halford Wyrmbane');
 
-- TrinityCore\sql\updates\world\2012_08_20_08_world_achievement_criteria_data.sql 
DELETE FROM `achievement_criteria_data` WHERE criteria_id = 7703;
INSERT INTO `achievement_criteria_data` VALUES
(7703, 6, 4197, 0, ''),
(7703, 11, 0, 0, 'achievement_wg_didnt_stand_a_chance');
 
-- TrinityCore\sql\updates\world\2012_08_20_09_world_disables.sql 
DELETE FROM `disables` WHERE `entry` = 7703 AND `sourceType` = 4;
 
-- TrinityCore\sql\updates\world\2012_08_21_00_world_spell_proc_event.sql 
DELETE FROM `spell_proc_event` WHERE `entry`=64752;
INSERT INTO `spell_proc_event` (`entry`,`SchoolMask`,`SpellFamilyName`,`SpellFamilyMask0`,`SpellFamilyMask1`,`SpellFamilyMask2`,`procFlags`,`procEx`,`ppmRate`,`CustomChance`,`Cooldown`) VALUES
(64752,0,7,8392704,256,2097152,0,0,0,0,0);
 
-- TrinityCore\sql\updates\world\2012_08_21_01_world_command.sql 
DELETE FROM `command` WHERE name='quest reward';
INSERT INTO `command` (`name`,`security`,`help`) VALUES
('quest reward',3,'Syntax: .quest reward #questId\n\n\Grants quest reward to selected player and removes quest from his log (quest must be in completed state).');
 
-- TrinityCore\sql\updates\world\2012_08_21_02_world_wintergrasp_conditions.sql 
-- Conditions
-- Add gossip_menu condition for 9904 Horde
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (14,15) AND `SourceGroup` IN (9904,9923);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`NegativeCondition`) VALUES
(14,9904,13759,0,1,33280,0), -- Must have Rank 1: Corporal
(14,9904,13759,1,1,55629,0), -- Or must have Rank 2: First Lieutenant
(14,9904,13761,0,1,33280,1), -- Must not have Rank 1: Corporal
(14,9904,13761,0,1,55629,1), -- Must not have Rank 2: First Lieutenant
-- Add gossip_menu condition for 9923 Alliance
(14,9923,13798,0,1,33280,0), -- Must have Rank 1: Corporal
(14,9923,13798,1,1,55629,0), -- Or must have Rank 2: First Lieutenant
(14,9923,14172,0,1,33280,1), -- Must not have Rank 1: Corporal
(14,9923,14172,0,1,55629,1), -- Must not have Rank 2: First Lieutenant
-- Add conditions to gossip options horde
(15,9904,0,0,1,33280,0), -- Must have reached Rank 1: Corporal
(15,9904,0,1,1,55629,0), -- Or must have reached Rank 2: First Lieutenant
(15,9904,1,0,1,55629,0), -- Must have reached Rank 2: First Lieutenant
(15,9904,2,0,1,55629,0), -- Must have reached Rank 2: First Lieutenant
-- Add conditions to gossip options alliance
(15,9923,0,0,1,33280,0), -- Must have reached Rank 1: Corporal
(15,9923,0,1,1,55629,0), -- Or must have reached Rank 2: First Lieutenant
(15,9923,1,0,1,55629,0), -- Must have reached Rank 2: First Lieutenant
(15,9923,2,0,1,55629,0); -- Must have reached Rank 2: First Lieutenant
 
-- TrinityCore\sql\updates\world\2012_08_23_00_world_wintergrasp_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE `spell_id` = 54640;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(54640, 'spell_wintergrasp_defender_teleport');
 
-- TrinityCore\sql\updates\world\2012_08_23_01_world_wintergrasp_gameobject.sql 
DELETE FROM `gameobject` WHERE `guid` IN (67259,67135,60476,66674,66675,67127,67128,66728,66731,67125,66730,66732,67126,67256,67132,67133,66733,67134,67251,67255,67129,67130,67131,67253,67258,67259,67260,75975,75976,76021,76022,66729,66718,66719,66720,66721,66722,66723,66724,66725,66726);
 
-- TrinityCore\sql\updates\world\2012_08_25_00_world_creature_template.sql 
-- Wintergrasp Siege Turret
UPDATE `creature_template` SET `faction_A`=1732,`faction_H`=1732 WHERE `entry`=28319; -- Alliance
UPDATE `creature_template` SET `faction_A`=1735,`faction_H`=1735 WHERE `entry`=32629; -- Horde
 
-- TrinityCore\sql\updates\world\2012_08_25_01_world_creature_template.sql 
UPDATE `creature_template` SET `faction_A`=103,`faction_H`=103 WHERE `entry` IN (30890,31540); -- Twilight Whelp
 
-- TrinityCore\sql\updates\world\2012_08_26_00_world_conditions.sql 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=61632;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,7,61632,0,0,31,0,3,30449,0,0,0,'','Sartharion Berserk - Only hit Tenebron, Shadron & Vesperon'),
(13,7,61632,0,1,31,0,3,30451,0,0,0,'','Sartharion Berserk - Only hit Tenebron, Shadron & Vesperon'),
(13,7,61632,0,2,31,0,3,30452,0,0,0,'','Sartharion Berserk - Only hit Tenebron, Shadron & Vesperon');
 
-- TrinityCore\sql\updates\world\2012_08_26_01_world_creature.sql 
UPDATE `creature` SET `phaseMask`=256 WHERE `id`=34300;
 
-- TrinityCore\sql\updates\world\2012_08_26_02_world_spell_area.sql 
DELETE FROM `spell_area` WHERE spell=58045;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_start_active`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`) VALUES
(58045,4197,0,0,0,0,0,2,1);
 
-- TrinityCore\sql\updates\world\2012_08_26_03_world_spell_area.sql 
DELETE FROM `spell_area` WHERE spell=74411 AND `area`=4197;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_start_active`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`) VALUES
(74411,4197,0,0,0,0,0,2,1);
 
-- TrinityCore\sql\updates\world\2012_08_27_00_world_creature_template.sql 
-- NPC script linking for Wyrmrest Defender ID: 27629
UPDATE `creature_template` SET `ScriptName`='npc_wyrmrest_defender' WHERE `entry`=27629;
 
-- TrinityCore\sql\updates\world\2012_08_27_00_world_spell_script_name.sql 
-- Spell script name linking for Defending Wyrmrest Temple: Character Script Cast From Gossip ID: 49123
DELETE FROM `spell_script_names` WHERE `spell_id`=49213;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(49213,'spell_q12372_cast_from_gossip_trigger');
 
-- TrinityCore\sql\updates\world\2012_08_27_01_world_sai.sql 
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=17398;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17398;

DELETE FROM `smart_scripts` WHERE `entryorguid` IN  (-85712,-85717,-85719,-85724);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(-85724, 0, 0, 0, 6, 0, 100, 0, 0, 0, 0, 0, 9, 29607, 0, 0, 0, 0, 0, 14, 22299, 0, 0, 0, 0, 0, 0, 'Blood Furnace - First Cell'),
(-85719, 0, 0, 0, 6, 0, 100, 0, 0, 0, 0, 0, 9, 29607, 0, 0, 0, 0, 0, 14, 22297, 0, 0, 0, 0, 0, 0, 'Blood Furnace - Second Cell'),
(-85717, 0, 0, 0, 6, 0, 100, 0, 0, 0, 0, 0, 9, 29607, 0, 0, 0, 0, 0, 14, 22298, 0, 0, 0, 0, 0, 0, 'Blood Furnace - Third Cell'),
(-85712, 0, 0, 0, 6, 0, 100, 0, 0, 0, 0, 0, 9, 29607, 0, 0, 0, 0, 0, 14, 22296, 0, 0, 0, 0, 0, 0, 'Blood Furnace - Fourth Cell');

DELETE FROM `gameobject_scripts` WHERE `id`=150441;
INSERT INTO `gameobject_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `dataint`, `x`, `y`, `z`, `o`) VALUES
(150441, 3, 11, 22295, 0, 0, 0, 0, 0, 0);
 
-- TrinityCore\sql\updates\world\2012_08_27_02_world_creature.sql 
SET @GUID = 42638; -- Set by TDB team (need X)
DELETE FROM `creature` WHERE `guid`=@GUID AND `id`=7172;
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES
(@GUID,7172,70,1,1,0,0,150.466,306.014,-49.543,5.2359,300,0,0,1,0,0,0,0,0);
 
-- TrinityCore\sql\updates\world\2012_08_27_02_world_playercreateinfo_spell.sql 
DELETE FROM `playercreateinfo_spell` WHERE `Spell` IN (59221,59535,59536,59538,59539,59540,59541);
INSERT INTO `playercreateinfo_spell` (`race`, `class`, `Spell`, `Note`) VALUES
(11,1,59221,'Shadow Resistance'),
(11,2,59535,'Shadow Resistance'),
(11,3,59536,'Shadow Resistance'),
(11,5,59538,'Shadow Resistance'),
(11,6,59539,'Shadow Resistance'),
(11,7,59540,'Shadow Resistance'),
(11,8,59541,'Shadow Resistance');
 
-- TrinityCore\sql\updates\world\2012_08_27_03_world_gameobject.sql 
-- Spawn Blackened Urn (194092) GO based on sniff by Aokromes
SET @GUID := 334; -- Set by TDB team

DELETE FROM `gameobject` WHERE `id`=194092;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(@GUID,194092,532,1,1,-11126.87,-1874.455,91.47264,6.056293,0,0,-0.113203,0.9935719,180,100,1);
 
-- TrinityCore\sql\updates\world\2012_08_27_04_world_quest_template.sql 
UPDATE `quest_template` SET `NextQuestId`=12257 WHERE `ID`=12468;
 
-- TrinityCore\sql\updates\world\2012_08_27_05_world_sai.sql 
-- A Race Against Time (11671)

SET @NPC_SALRAND                := 25584; -- Inquisitor Salrand
SET @NPC_BERYL_INVISMAN         := 25594; -- Beryl Point InvisMan
SET @GOB_BERYL_SHIELD           := 187773; -- Beryl Shield
SET @GOB_BERYL_SHIELD_FOCUS     := 300176; -- TEMP Beryl Force Shield
SET @SPELL_BEAM                 := 45777; -- Salrand's Beam
SET @SPELL_THROW_DETONATOR      := 45780; -- Throw Beryl Shield Detonator
SET @SPELL_SUMMON_DETONATOR     := 45791; -- Summon Beryl Detonator
SET @SPELL_EXPLOSION            := 45796; -- Beryl Shield Explosion
SET @SPELL_LOCKBOX              := 45809; -- Summon Salrand's Lockbox
SET @GUID                       := 60441; -- used for a wrong go spawn,will reuse

UPDATE `gameobject_template` SET `data1`=80 WHERE  `entry`=300176; -- spell focus radius
UPDATE `gameobject_template` SET `flags`=32 WHERE  `entry`=187773; -- shield:nodespawn flag

-- missing spell focus
DELETE FROM `gameobject` WHERE `guid`=@GUID;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(@GUID,@GOB_BERYL_SHIELD_FOCUS,571,1,1,3392.85,6161.089,79.8313,0,0,0,0,0,300,0,1);

UPDATE `creature_template` SET `InhabitType`=0x4,`unit_flags`=0x100,`AIName`='SmartAI' WHERE `entry`=@NPC_SALRAND;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_BERYL_INVISMAN;

DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_SALRAND;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_SALRAND,0,0x0,0x1,'45775');

DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@NPC_SALRAND;
DELETE FROM `smart_scripts` WHERE (`source_type`=0 AND `entryorguid` IN (@NPC_SALRAND,@NPC_BERYL_INVISMAN)) OR (`source_type`=9 AND `entryorguid` IN (@NPC_SALRAND*100,@NPC_BERYL_INVISMAN*100));
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_SALRAND,0,0,0,38,0,100,1,1,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'On data 1 1 - Say'),
(@NPC_SALRAND,0,1,2,38,0,100,1,1,2,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'On data 1 2 - Say'),
(@NPC_SALRAND,0,2,0,61,0,100,1,0,0,0,0,80,@NPC_SALRAND*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'On link - Run script'),
(@NPC_SALRAND,0,3,4,6,0,100,1,0,0,0,0,11,@SPELL_LOCKBOX,0,0,0,0,0,1,0,0,0,0,0,0,0,'On death - Cast spell'),
(@NPC_SALRAND,0,4,0,61,0,100,1,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'On death - Say'),
(@NPC_SALRAND,0,5,0,11,0,100,1,0,0,0,0,24,0,0,0,0,0,0,15,0,0,0,0,0,0,0,'On respawn - Evade'),
(@NPC_SALRAND*100,9,0,0,0,0,100,0,0,0,0,0,60,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'On script - set fly off'),
(@NPC_SALRAND*100,9,1,0,0,0,100,0,0,0,0,0,69,0,0,0,0,0,0,8,0,0,0,3392.852,6161.092,79.83095,0,'On script - Move to pos'),
(@NPC_SALRAND*100,9,2,0,0,0,100,0,3000,3000,0,0,19,256,0,0,0,0,0,1,0,0,0,0,0,0,0,'On script - Set unit flags'),
--
(@NPC_BERYL_INVISMAN,0,0,0,8,0,100,0,@SPELL_THROW_DETONATOR,0,0,0,80,@NPC_BERYL_INVISMAN*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'On spellhit - Run Script'),
(@NPC_BERYL_INVISMAN*100,9,0,0,0,0,100,0,0,0,0,0,11,@SPELL_SUMMON_DETONATOR,0,0,0,0,0,1,0,0,0,0,0,0,0,'On script - Cast Spell'),
(@NPC_BERYL_INVISMAN*100,9,1,0,0,0,100,0,0,0,0,0,45,1,1,0,0,0,0,19,@NPC_SALRAND,100,0,0,0,0,0,'On script - Set Data'),
(@NPC_BERYL_INVISMAN*100,9,2,0,0,0,100,0,8000,8000,0,0,45,1,2,0,0,0,0,19,@NPC_SALRAND,100,0,0,0,0,0,'On script - Set Data'),
(@NPC_BERYL_INVISMAN*100,9,3,0,0,0,100,0,2000,2000,0,0,11,@SPELL_EXPLOSION,0,0,0,0,0,1,0,0,0,0,0,0,0,'On script - Cast Spell');

DELETE FROM `creature_text` WHERE `entry`=@NPC_SALRAND;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_SALRAND,0,0,'What is the meaning of this disturbance?!',14,0,100,0,0,0,'Inquisitor Salrand to Beryl Point InvisMan'),
(@NPC_SALRAND,1,0,'Who dares interrupt my work!? Show yourself, coward!',14,0,100,0,0,0,'Inquisitor Salrand to Beryl Point InvisMan'),
(@NPC_SALRAND,2,0,'I''ve destroyed the key! Your cherished archmage belongs to Malygos!',12,0,100,0,0,0,'Inquisitor Salrand');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=@SPELL_THROW_DETONATOR;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,@SPELL_THROW_DETONATOR,0,0,31,0,3,@NPC_BERYL_INVISMAN,0,0,0,'','Throw Beryl Shield Detonator target npc');
 
-- TrinityCore\sql\updates\world\2012_08_27_06_world_sai.sql 
-- Fix {Q/A} The Shining Light ID: 11288
-- Makes it blizzlike timed 10 minutes
UPDATE `quest_template` SET `LimitTime`=600 WHERE `id`=11288;
-- Decomposing Ghoul SAI
SET @Ghoul := 24177;
SET @SpellTrigger := 43202;
SET @Spell := 43203;
SET @Ares  := 24189;
UPDATE `creature_template` SET `AIname`='SmartAI' WHERE `entry`=@Ghoul;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Ghoul;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Ghoul,0,0,0,1,0,100,0,20000,300000,50000,350000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Decomposing Ghoul - Occ - Say random text'),
(@Ghoul,0,1,2,8,0,100,0,@Spell,0,0,0,18,33685506,0,0,0,0,0,1,0,0,0,0,0,0,0,'Decomposing Ghoul - On hit by spell - Set unit flag for not targetable'),
(@Ghoul,0,2,3,61,0,100,0,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,'Decomposing Ghoul - Linked with previous event - Switch faction to clear aggro'),
(@Ghoul,0,3,0,61,0,100,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Decomposing Ghoul - Linked with previous event - Say random text'),
(@Ghoul,0,4,5,1,0,100,0,3500,3500,3500,3500,19,33685506,0,0,0,0,0,1,0,0,0,0,0,0,0,'Decomposing Ghoul - OOC for 3,5 sec - Remove unit flag'),
(@Ghoul,0,5,0,61,0,100,0,0,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Decomposing Ghoul - Linked with previous event - Change faction back to 14');
-- Add SAI for Ares - quest giver
UPDATE `creature_template` SET `AIname`='SmartAI' WHERE `entry`=@Ares;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Ares;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Ares,0,0,0,19,0,100,0,11288,0,0,0,85,@SpellTrigger,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ares - On target quest accepted 11288 - Cast spell Shining Light');
-- Decomposing Ghoul texts
DELETE FROM `creature_text` WHERE `entry`=@Ghoul;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@Ghoul,0,1,'Light... light so bright...',12,0,50,0,0,0,'Decomposing Ghoul - On spell hit'),
(@Ghoul,0,2,'ARGHHHH...',12,0,50,0,0,0,'Decomposing Ghoul - On spell hit'),
(@Ghoul,0,3,'Away... go...',12,0,50,0,0,0,'Decomposing Ghoul - On spell hit'),
(@Ghoul,0,4,'Bad light... hurt...',12,0,50,0,0,0,'Decomposing Ghoul - On spell hit'),
(@Ghoul,0,5,'BURNS! IT BURNS!',12,0,50,0,0,0,'Decomposing Ghoul - On spell hit'),
(@Ghoul,1,1,'So... Hungry...',12,0,50,0,0,0,'Decomposing Ghoul - OOC'),
(@Ghoul,1,2,'Closer... come closer...',12,0,50,0,0,0,'Decomposing Ghoul - OOC'),
(@Ghoul,1,3,'FEED ME...',12,0,50,0,0,0,'Decomposing Ghoul - OOC'),
(@Ghoul,1,4,'FOOD! EAT YOU!',12,0,50,0,0,0,'Decomposing Ghoul - OOC'),
(@Ghoul,1,5,'BRAINNNS!',12,0,50,0,0,0,'Decomposing Ghoul - OOC');
-- Add conditions for spell Shining Light to hit only Ghouls
DELETE FROM `conditions` WHERE `SourceEntry`=@Spell AND `SourceTypeOrReferenceId`=13;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13,1,@Spell,0,0,31,0,3,@Ghoul,0,0,0,'', 'Shinning Light can only hit Decomposing Ghouls');
-- Add conditions for spell Shining Light to be available only, if on quest
DELETE FROM `conditions` WHERE `SourceEntry`=@Spell AND `SourceTypeOrReferenceId`=17;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(17,0,@Spell,0,0,9,0,11288,0,0,0,0,'', 'Shinning Light can only hit targets on the quest');
 
-- TrinityCore\sql\updates\world\2012_08_27_07_world_spell_area.sql 
-- Fix quest - The Angry Gorloc ID: 12578
DELETE FROM `spell_area` WHERE `spell`=54057;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_start_active`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`) VALUES
(54057, 4297, 12578, 1, 12578, 0, 0, 2, 1);
 
-- TrinityCore\sql\updates\world\2012_08_27_08_world_misc.sql 
-- Fire Upon the Waters (12243) quest fix
-- add Fire Upon the Waters Kill Credit Bunny at sail locations
SET @GUID =42887;
DELETE FROM `creature` WHERE `id`=28013;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`) VALUES
(@GUID+0,28013,571,1,1,0,0,2488.86,-400.017,19.0803,2.99498,300,0,0,42,0,0,0,33554432,0),
(@GUID+1,28013,571,1,1,0,0,2458.96,-401.066,20.7778,0.108631,300,0,0,42,0,0,0,33554432,0);

-- SAI
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 28013;
DELETE FROM `smart_scripts` WHERE `entryorguid`=28013 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(28013,0,0,0,8,0,100,0,48455,0,0,0,33,28013,0,0,0,0,0,7,0,0,0,0,0,0,0,"Fire Upon the Waters Kill Credit Bunny - On SpellHit Apothecary's Burning Water - Call KilledMonster Fire Upon the Waters Kill Credit Bunny");

-- Ensure spell only works on Fire Upon the Waters Kill Credit Bunny
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=48455;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,48455,0,0,31,0,3,28013,0,0,0,'',"Fire Upon the Waters - spell to Fire Upon the Waters Kill Credit Bunny");

-- add quest item loot to Captain Shely
DELETE FROM `creature_loot_template` WHERE `entry`=27232;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(27232,37305,-100,1,0,1,1), -- Captain Shely's Rutters
(27232,43851,25,1,0,1,1), -- Fur Clothing Scraps
(27232,33470,10,1,0,1,3), -- Frostweave Cloth
(27232,33443,5,1,0,1,1), -- Sour Goat Cheese
(27232,33444,2,1,0,1,1), -- Pungent Seal Whey
(27232,22829,1,1,0,1,1), -- Super Healing Potion
(27232,45912,0.05,1,0,1,1); -- Book Glyph of Mastery
 
-- TrinityCore\sql\updates\world\2012_08_27_09_world_conditions.sql 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (62973,62991);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13,3,62973,0,0, 1,0,62972,0,0,0,0,'','Foam Sword Attack'),
(13,3,62973,0,0,31,0,4,0,0,0,0,'','Foam Sword Attack'),
(13,3,62973,0,0,33,0,1,0,0,1,0,'','Foam Sword Attack'),
(13,3,62991,0,0, 1,0,62972,0,0,0,0,'','Bonked!'),
(13,3,62991,0,0,31,0,4,0,0,0,0,'','Bonked!'),
(13,3,62991,0,0,33,0,1,0,0,1,0,'','Bonked!');
 
-- TrinityCore\sql\updates\world\2012_08_27_10_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE `spell_id`IN (64142,62991);
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(64142,'spell_gen_upper_deck_create_foam_sword'),
(62991,'spell_gen_bonked');
 
-- TrinityCore\sql\updates\world\2012_08_28_00_world_spell_script_name.sql 
-- Spell script name linking for Defending Wyrmrest Temple: Destabilize Azure Dragonshrine Effect
DELETE FROM `spell_script_names` WHERE `spell_id`=49370 ;
INSERT INTO `spell_script_names` VALUES
(49370,'spell_q12372_destabilize_azure_dragonshrine_dummy');
 
-- TrinityCore\sql\updates\world\2012_08_28_01_world_achievement_criteria_data.sql 
DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (11478,11479,12827,12828);
INSERT INTO `achievement_criteria_data` (`criteria_id`, `type`, `value1`, `value2`, `ScriptName`) VALUES
(11478, 12, 0, 0, ''), -- Koralon the Flame Watcher (10 player)
(11479, 12, 1, 0, ''), -- Koralon the Flame Watcher (25 player)
(12827, 12, 0, 0, ''), -- Toravon the Ice Watcher (10 player)
(12828, 12, 1, 0, ''); -- Toravon the Ice Watcher (25 player)
 
-- TrinityCore\sql\updates\world\2012_08_29_00_world_blood_furnace.sql 
SET @GUID := 138106; -- 149

-- Delete old data before inserting new data. This could make trouble later on.
DELETE `creature_addon` FROM `creature_addon` INNER JOIN `creature` ON `creature`.`guid`=`creature_addon`.`guid` WHERE `map`=542;
DELETE `creature_formations` FROM `creature_formations` INNER JOIN `creature` ON `creature`.`guid`=`creature_formations`.`memberGUID` OR `creature`.`guid`=`creature_formations`.`leaderGUID` WHERE `map`=542;
DELETE `linked_respawn` FROM `linked_respawn` INNER JOIN `creature` ON `creature`.`guid`=`linked_respawn`.`linkedGuid` WHERE `map`=542;


-- CREATURE_TEMPLATE
-- Trash
UPDATE `creature_template` SET `speed_walk`=1.1 WHERE `entry`=17624;
UPDATE `creature_template` SET `AIName`='' WHERE `entry`=17398;
-- Broggok
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|256|512|2 WHERE `entry` IN(17380,18601);

-- CREATURE
DELETE FROM `creature` WHERE `guid` BETWEEN @GUID AND @GUID+148 OR `map`=542;
INSERT INTO `creature`(`guid`,`id`,`map`,`spawnMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`curhealth`,`curmana`,`MovementType`) VALUES 
(@GUID+88,17414,542,3,317.15,189.009,10.0509,1.88412,7200,10472,5875,0),
(@GUID+92,17414,542,3,436.311,198.522,11.4389,1.34468,7200,10472,5875,0),
(@GUID+91,17414,542,3,345.706,198.519,11.139,1.6879,7200,10472,5875,0),
(@GUID+96,17398,542,3,379.741,192.233,9.59787,3.36158,7200,7210,0,0),
(@GUID+103,17414,542,3,448.428,190.764,9.6054,1.01795,7200,10472,5875,0),
(@GUID+97,17395,542,3,373.636,184.777,9.59848,1.15697,7200,10472,17625,0),
(@GUID+95,17371,542,3,371.98,194.243,9.59956,5.36434,7200,10472,5875,0),
(@GUID+94,17491,542,3,480.502,180.017,9.61526,3.42991,7200,7479,0,0),
(@GUID+26,17398,542,3,412.728,85.7323,9.65141,0.141552,7200,6963,0,0),
(@GUID+125,17477,542,3,485.76,8.63405,9.54898,1.43024,7200,4126,9944,0),
(@GUID+68,17371,542,3,327.262,30.5611,9.61686,4.68833,7200,10472,5875,2),
(@GUID+124,17477,542,3,490.168,11.6964,9.54898,1.13336,7200,4126,9944,0),
(@GUID+123,17477,542,3,489.518,5.51373,9.54353,1.96038,7200,4126,9944,0),
(@GUID+122,17371,542,3,494.46,7.58925,9.54249,2.87616,7200,10472,5875,0),
(@GUID+112,17414,542,3,479.898,98.2961,9.62183,6.09707,7200,10472,5875,0),
(@GUID+120,17491,542,3,433.6,-18.2301,9.55216,0.450845,7200,7479,0,0),
(@GUID+126,17477,542,3,484.202,13.9732,9.5505,6.25258,7200,4126,9944,0),
(@GUID+128,17371,542,3,465.905,-19.9126,9.55319,5.19624,7200,10472,5875,2),
(@GUID+129,17371,542,3,476.506,-63.3028,9.54636,0,7200,10472,5875,2),
(@GUID+131,17491,542,3,495.566,-43.8895,9.5591,2.9343,7200,7479,0,0),
(@GUID+46,17477,542,3,-10.8822,-85.2033,-41.3341,2.09342,7200,4126,9944,0),
(@GUID+55,17397,542,3,224.587,-96.0037,9.61879,0.647748,7200,11965,2486,0),
(@GUID+54,17397,542,3,231.512,-91.5716,9.62435,3.65189,7200,11965,2486,0),
(@GUID+56,17477,542,3,227.94,-93.8952,9.61879,0.561355,7200,4126,9944,0),
(@GUID+53,17491,542,3,234.022,-106.406,9.61037,1.88867,7200,7479,0,0),
(@GUID+52,17477,542,3,28.2572,-85.4531,-41.0542,4.63284,7200,4126,9944,0),
(@GUID+59,17477,542,3,241.827,-68.3783,9.61987,1.82585,7200,4126,9944,0),
(@GUID+58,17397,542,3,242.883,-72.4289,9.61514,1.81799,7200,11965,2486,0),
(@GUID+57,17397,542,3,240.674,-64.4904,9.62484,5.05383,7200,11965,2486,0),
(@GUID+14,21174,542,3,320.912,-83.0625,-133.307,3.00197,7200,8338000,0,0),
(@GUID+136,17477,542,3,412.944,-83.971,9.61695,5.1156,7200,4126,9944,0),
(@GUID+137,17477,542,3,420.081,-88.5245,9.62061,0.206074,7200,4126,9944,0),
(@GUID+139,17491,542,3,404.193,-62.5071,9.61827,5.54913,7200,7479,0,0),
(@GUID+134,17477,542,3,432.656,-78.7667,9.62296,1.5821,7200,4126,9944,0),
(@GUID+140,17477,542,3,419.961,-76.9838,9.62318,5.67087,7200,4126,9944,0),
(@GUID+135,17477,542,3,427.911,-69.9011,9.61668,4.99622,7200,4126,9944,0),
(@GUID+142,18894,542,3,355.194,-175.571,-25.5497,0.0701911,7200,14958,0,0),
(@GUID+144,18894,542,3,325.278,-191.535,-25.5078,1.49412,7200,14958,0,0),
(@GUID+145,17371,542,3,312.396,-174.925,-25.5082,6.21829,7200,10472,5875,0),
(@GUID+146,18894,542,3,312.116,-179.382,-25.5071,6.20258,7200,14958,0,0),
(@GUID+147,18894,542,3,313.392,-170.618,-25.5086,6.20651,7200,14958,0,0),
(@GUID+78,17371,542,3,331.268,69.7599,9.61402,1.77024,7200,10472,5875,0),
(@GUID+70,17397,542,3,313.949,13.7401,9.61652,4.38997,7200,11965,2486,0),
(@GUID+69,17395,542,3,311.261,7.92634,9.62195,0.656179,7200,10472,17625,0),
(@GUID+71,17397,542,3,317.184,8.72084,9.6192,2.67896,7200,11965,2486,0),
(@GUID+75,17491,542,3,314.564,-7.67602,9.6169,2.30511,7200,7479,0,0),
(@GUID+77,17370,542,3,331.076,28.8939,9.62118,4.2576,7200,14958,0,0),
(@GUID+73,17395,542,3,338.84,8.10661,9.61679,5.05086,7200,10472,17625,0),
(@GUID+72,17395,542,3,338.242,1.09978,9.61664,1.01391,7200,10472,17625,0),
(@GUID+25,17398,542,3,413.285,81.8238,9.65038,0.154642,7200,6963,0,0),
(@GUID+24,17398,542,3,500.076,84.7778,9.65474,3.08941,7200,6963,0,0),
(@GUID+23,17398,542,3,502.724,82.8731,9.65935,3.08941,7200,6963,0,0),
(@GUID+22,17398,542,3,498.962,83.0695,9.6524,3.08941,7200,6963,0,0),
(@GUID+21,17398,542,3,498.393,86.641,9.65219,3.19309,7200,6963,0,0),
(@GUID+104,17414,542,3,327.172,188.393,9.61882,1.09492,7200,10472,5875,0),
(@GUID+27,17398,542,3,409.226,83.2983,9.65786,0.141552,7200,6963,0,0),
(@GUID+28,17398,542,3,412.081,112.626,9.65613,6.1865,7200,6963,0,0),
(@GUID+29,17398,542,3,412.462,116.555,9.65317,6.1865,7200,6963,0,0),
(@GUID+30,17398,542,3,411.735,114.446,9.65571,0.00803471,7200,6963,0,0),
(@GUID+31,17398,542,3,409.699,113.048,9.65731,0.0185067,7200,6963,0,0),
(@GUID+32,17398,542,3,407.17,115.172,9.66061,0.0185067,7200,6963,0,0),
(@GUID+33,17398,542,3,495.677,116.285,9.64388,3.14963,7200,6963,0,0),
(@GUID+34,17398,542,3,495.696,113.877,9.64425,3.14963,7200,6963,0,0),
(@GUID+35,17398,542,3,499.774,112.283,9.65334,3.14963,7200,6963,0,0),
(@GUID+36,17398,542,3,503.042,114.321,9.65788,3.14963,7200,6963,0,0),
(@GUID+37,17398,542,3,503.024,116.589,9.65788,3.14963,7200,6963,0,0),
(@GUID+38,17398,542,3,499.499,118.085,9.65347,3.14963,7200,6963,0,0),
(@GUID+111,17414,542,3,482.454,103.335,9.61156,5.27398,7200,10472,5875,0),
(@GUID+110,17414,542,3,458.068,92.7015,9.61519,1.89206,7200,10472,5875,0),
(@GUID+109,17414,542,3,452.317,94.5807,9.61519,0.545102,7200,10843,6015,0),
(@GUID+108,17395,542,3,457.121,99.2828,9.61496,4.44777,7200,10472,17625,0),
(@GUID+102,17370,542,3,466.171,176.663,9.6201,2.8927,7200,14958,0,2),
(@GUID+98,17371,542,3,412.814,195.493,9.60144,3.55951,7200,10472,5875,0),
(@GUID+100,17395,542,3,403.447,190.68,9.59739,0.0770466,7200,10472,17625,0),
(@GUID+99,17398,542,3,411.319,185.388,9.60154,2.28952,7200,6963,0,0),
(@GUID+101,17370,542,3,466.657,179.674,9.61915,2.88877,7200,14958,0,2),
(@GUID+76,17370,542,3,323.216,28.6452,9.62206,4.92205,7200,14958,0,0),
(@GUID+74,17397,542,3,344.219,5.00403,9.62297,3.2955,7200,11965,2486,0),
(@GUID+67,17370,542,3,286.75,-7.12364,9.33158,3.50552,7200,14958,0,0),
(@GUID+65,17370,542,3,258.511,-30.4009,6.95261,4.07258,7200,14958,0,0),
(@GUID+63,17371,542,3,246.377,-85.311,9.61661,3.04947,7200,10472,5875,2),
(@GUID+62,17477,542,3,226.371,-71.3008,9.61766,2.01394,7200,4126,9944,0),
(@GUID+60,17397,542,3,224.497,-68.0896,9.62108,5.19786,7200,11965,2486,0),
(@GUID+61,17397,542,3,227.979,-74.6894,9.61909,1.96987,7200,11965,2486,0),
(@GUID+106,17626,542,3,458.614,116.989,9.61455,3.07559,7200,14958,0,0),
(@GUID+43,17491,542,3,182.461,-68.9882,9.62108,3.98337,7200,7479,0,0),
(@GUID+42,17491,542,3,107.083,-96.6171,-14.2289,0.930522,7200,7479,0,0),
(@GUID+51,17397,542,3,27.6779,-90.5785,-40.7088,1.48496,7200,11965,2486,0),
(@GUID+82,17414,542,3,304.249,103.356,9.62076,5.61477,7200,10843,6015,0),
(@GUID+83,17371,542,3,308.919,100.519,9.62138,2.61455,7200,10472,5875,0),
(@GUID+86,17626,542,3,356.154,108.175,9.62332,4.06125,7200,14958,0,0),
(@GUID+85,17371,542,3,343.419,102.651,9.6201,5.16709,7200,10472,5875,0),
(@GUID+93,17414,542,3,346.912,193.875,9.60419,1.74602,7200,10472,5875,0),
(@GUID+115,17414,542,3,476.291,65.9018,9.60985,3.98357,7200,10472,5875,0),
(@GUID+114,17414,542,3,469.409,65.9985,9.61271,5.036,7200,10843,6015,0),
(@GUID+116,17371,542,3,472.66,59.4292,9.6097,1.58025,7200,10472,5875,0),
(@GUID+105,17624,542,3,456.429,118.903,9.61496,3.16198,7200,16023,0,0),
(@GUID+107,17626,542,3,458.704,120.842,9.61456,3.1619,7200,14958,0,2),
(@GUID+127,18894,542,3,462.905,-19.9126,9.55215,5.18053,7200,14958,0,0),
(@GUID+41,17377,542,3,325.862,-87.2087,-24.6512,5.87314,43200,34830,6156,0),
(@GUID+143,18894,542,3,333.631,-192.252,-25.5027,1.51768,7200,14958,0,0),
(@GUID+148,17371,542,3,329.584,-189.111,-25.5067,1.50511,7200,10472,5875,0),
(@GUID+132,17371,542,3,424.675,-83.9057,9.6166,0.059993,7200,10472,5875,0),
(@GUID+130,18894,542,3,475.417,-66.3289,9.54527,0,7200,14958,0,0),
(@GUID+40,18894,542,3,455.566,-79.108,9.61164,0.09548,7200,14958,0,0),
(@GUID+39,18894,542,3,455.793,-89.9999,9.60743,0.09548,7200,14958,0,0),
(@GUID+121,17371,542,3,487.933,17.2848,9.55353,4.54905,7200,10472,5875,0),
(@GUID+119,17414,542,3,445.422,63.6577,9.61209,3.54218,7200,10472,5875,0),
(@GUID+118,17371,542,3,442.237,56.965,9.61104,1.84965,7200,10472,5875,0),
(@GUID+117,17371,542,3,437.232,64.7644,9.60927,5.1656,7200,10472,5875,0),
(@GUID+113,17414,542,3,483.48,91.8948,9.62303,1.14828,7200,10472,5875,0),
(@GUID+20,17398,542,3,437.158,201.984,11.6815,4.639,7200,6963,0,0),
(@GUID+19,17398,542,3,345.078,202.309,11.6826,4.90708,7200,6963,0,0),
(@GUID+18,17398,542,3,314.478,195.642,11.6815,5.01966,7200,6963,0,0),
(@GUID+17,17381,542,3,327.17,137.816,9.61546,4.72121,43200,38722,0,0),
(@GUID+90,17370,542,3,372.443,187.252,9.59815,3.08144,7200,14958,0,2),
(@GUID+87,17491,542,3,301.987,172.031,9.61921,0.398146,7200,7479,0,0),
(@GUID+89,17370,542,3,372.443,191.252,9.59815,3.3214,7200,14958,0,2),
(@GUID+80,17626,542,3,343.075,57.8455,9.6156,0,7200,14958,0,0),
(@GUID+81,17624,542,3,327.255,54.8455,9.61645,0,7200,16023,0,2),
(@GUID+15,17414,542,3,352.426,85.7746,9.6222,6.27838,7200,10472,5875,0),
(@GUID+84,17414,542,3,346.54,96.449,9.6201,2.21792,7200,10472,5875,0),
(@GUID+16,17414,542,3,302.425,61.1739,9.61642,3.14962,7200,10472,5875,0),
(@GUID+79,17414,542,3,328.075,76.9842,9.61402,5.19851,7200,10472,5875,0),
(@GUID+133,17477,542,3,433.797,-90.9604,9.62448,1.93317,7200,4126,9944,0),
(@GUID+141,18894,542,3,355.299,-163.451,-25.5338,6.16881,7200,14958,0,0),
(@GUID+138,17477,542,3,423.255,-96.3954,9.61869,1.21688,7200,4126,9944,0),
(@GUID+66,17626,542,3,279.674,1.44232,8.11077,3.8723,7200,14958,0,0),
(@GUID+64,17626,542,3,250.468,-24.7817,6.95538,4.23202,7200,14958,0,0),
(@GUID+50,17397,542,3,29.672,-80.5135,-40.787,4.36738,7200,11965,2486,0),
(@GUID+44,17397,542,3,-12.9018,-81.3588,-41.3358,5.36252,7200,11965,2486,0),
(@GUID+47,17397,542,3,6.99569,-89.3037,-41.3305,1.28394,7200,11965,2486,0),
(@GUID+45,17397,542,3,-9.04048,-88.5931,-41.3341,1.99081,7200,11965,2486,0),
(@GUID+49,17477,542,3,8.90866,-85.0585,-41.3294,1.02944,7200,4126,9944,0),
(@GUID+48,17397,542,3,10.3856,-81.342,-41.3294,4.24882,7200,11965,2486,0),
(@GUID+9,17380,542,3,455.336,-1.82919,9.6299,1.43117,43200,30960,18468,0),
(@GUID+8,17370,542,3,7.83757,-54.6224,-41.258,1.62316,7200,14958,0,0),
(@GUID+7,17370,542,3,-4.06964,-56.7616,-41.258,1.41372,7200,14958,0,0),
(@GUID+6,17370,542,3,49.3209,-93.3478,-40.1855,2.86234,7200,14958,0,0),
(@GUID+5,17370,542,3,49.2232,-75.6242,-40.1856,2.98451,7200,14958,0,0),
(@GUID+4,17256,542,3,369.461,-118.757,-137.368,2.54818,604800,152964,1016100,0),
(@GUID+3,17256,542,3,369.15,-55.5658,-137.368,3.71755,604800,152964,1016100,0),
(@GUID+2,17256,542,3,307.784,-31.8502,-137.368,4.95674,604800,152964,1016100,0),
(@GUID+1,17256,542,3,274.133,-87.1647,-137.368,0.017453,604800,152964,1016100,0),
(@GUID+0,17256,542,3,308.203,-141.769,-137.368,1.36136,604800,152964,1016100,0);

-- GAMEOBJECT_TEMPLATE
UPDATE `gameobject_template` SET `ScriptName`='go_broggok_lever' WHERE `entry`=181982;

-- CREATURE_MODEL_INFO
-- Old modelid_other_gender 12471. Need to do this because modelid in creature uses creature_model_info, too... so it would still bug.
UPDATE `creature_model_info` SET `modelid_other_gender`=0 WHERE `modelid`=16332;

-- CREATURE_ADDON
DELETE FROM `creature_addon` WHERE `guid` BETWEEN @GUID AND @GUID+144;
INSERT INTO `creature_addon`(`guid`,`path_id`,`bytes2`) VALUES
(@GUID+0,0,4097),
(@GUID+1,0,4097),
(@GUID+2,0,4097),
(@GUID+3,0,4097),
(@GUID+4,0,4097),
(@GUID+15,856820,0),
(@GUID+63,(@GUID+63)*10,0),
(@GUID+68,(@GUID+68)*10,0),
(@GUID+81,(@GUID+81)*10,0),
(@GUID+89,(@GUID+89)*10,0),
(@GUID+90,(@GUID+90)*10,0),
(@GUID+101,(@GUID+101)*10,0),
(@GUID+102,(@GUID+102)*10,0),
(@GUID+107,(@GUID+107)*10,0),
(@GUID+128,(@GUID+128)*10,0),
(@GUID+129,(@GUID+129)*10,0);

-- CREATURE_FORMATIONS
DELETE FROM `creature_formations` WHERE `leaderGUID` BETWEEN @GUID AND @GUID+148 OR `memberGUID` BETWEEN @GUID AND @GUID+148;
INSERT INTO `creature_formations`(`leaderGUID`,`memberGUID`,`dist`,`angle`,`groupAI`) VALUES
(@GUID+81,@GUID+81,0,0,2),
(@GUID+81,@GUID+80,3,290,2),
(@GUID+107,@GUID+107,0,0,2),
(@GUID+107,@GUID+105,4,220,2),
(@GUID+107,@GUID+106,3,285,2),
(@GUID+129,@GUID+129,0,0,2),
(@GUID+129,@GUID+130,3,90,2),
(@GUID+143,@GUID+143,0,0,2),
(@GUID+143,@GUID+148,3,120,2),
(@GUID+143,@GUID+144,3,240,2),
(@GUID+146,@GUID+146,0,0,2),
(@GUID+146,@GUID+145,3,120,2),
(@GUID+146,@GUID+147,3,240,2),
(@GUID+128,@GUID+128,0,0,2),
(@GUID+128,@GUID+127,4,45,2);

-- WAYPOINT_DATA
DELETE FROM `waypoint_data` WHERE `id` BETWEEN @GUID*10 AND (@GUID+148)*10;
INSERT INTO `waypoint_data`(`id`,`point`,`position_x`,`position_y`,`position_z`) VALUES
((@GUID+63 )*10,1,247.229,-66.59,9.62258),
((@GUID+63 )*10,2,246.245,-85.1909,9.61548),
((@GUID+63 )*10,3,219.765,-84.577,9.58612),
((@GUID+63 )*10,4,246.377,-85.311,9.61661),
((@GUID+68 )*10,1,328.417,-4.58593,9.61603),
((@GUID+68 )*10,2,327.28,24.0565,9.61603),
((@GUID+81 )*10,1,327.255,54.8455,9.61346),
((@GUID+81 )*10,18,322.72,55.3961,9.6137),
((@GUID+81 )*10,17,317.328,58.7127,9.6137),
((@GUID+81 )*10,16,315.042,62.5956,9.61509),
((@GUID+81 )*10,15,312.513,72.6059,9.6179),
((@GUID+81 )*10,14,311.755,83.2112,9.6179),
((@GUID+81 )*10,13,312.519,89.5342,9.6179),
((@GUID+81 )*10,12,313.959,93.8532,9.61756),
((@GUID+81 )*10,11,317.588,98.5635,9.61631),
((@GUID+81 )*10,10,322.28,101.14,9.61572),
((@GUID+81 )*10,9,328.8,102.991,9.61528),
((@GUID+81 )*10,8,334.164,102.162,9.61808),
((@GUID+81 )*10,7,339.203,99.0606,9.61948),
((@GUID+81 )*10,6,342.812,94.2829,9.61948),
((@GUID+81 )*10,5,345.611,85.8321,9.61948),
((@GUID+81 )*10,4,344.882,74.8707,9.61869),
((@GUID+81 )*10,3,343.069,64.3213,9.61614),
((@GUID+81 )*10,2,340.959,59.932,9.61435),
((@GUID+89 )*10,1,372.443,191.252,9.59815),
((@GUID+89 )*10,2,329.021,185.273,9.61524),
((@GUID+90 )*10,1,372.443,187.252,9.59815),
((@GUID+90 )*10,2,329.021,181.273,9.61524),
((@GUID+101)*10,1,416.026,191.714,9.59825),
((@GUID+101)*10,2,466.657,179.674,9.61915),
((@GUID+102)*10,1,415.314,187.668,9.59825),
((@GUID+102)*10,2,466.171,176.663,9.6201),
((@GUID+107)*10,18,464.47,117.962,9.62),
((@GUID+107)*10,17,471.688,113.794,9.62),
((@GUID+107)*10,16,477.046,107.409,9.62),
((@GUID+107)*10,15,479.897,99.5768,9.62),
((@GUID+107)*10,14,479.897,91.2417,9.62),
((@GUID+107)*10,13,477.046,83.4093,9.62),
((@GUID+107)*10,12,471.688,77.0242,9.62),
((@GUID+107)*10,11,464.47,72.8567,9.62),
((@GUID+107)*10,10,456.261,71.4093,9.62),
((@GUID+107)*10,9,448.053,72.8567,9.62),
((@GUID+107)*10,8,440.834,77.0242,9.62),
((@GUID+107)*10,7,435.477,83.4093,9.62),
((@GUID+107)*10,6,432.626,91.2417,9.62),
((@GUID+107)*10,5,432.626,99.5768,9.62),
((@GUID+107)*10,4,435.477,107.409,9.62),
((@GUID+107)*10,3,440.834,113.794,9.62),
((@GUID+107)*10,2,448.053,117.962,9.62),
((@GUID+107)*10,1,456.261,119.409,9.62),
((@GUID+128)*10,1,475.83,-58.5353,9.5419),
((@GUID+128)*10,2,474.83,-54.6723,9.5419),
((@GUID+128)*10,3,465.9,-19.9126,9.55319),
((@GUID+128)*10,4,466.89,-23.7756,9.55319),
((@GUID+129)*10,1,482.43,-67.1466,9.56),
((@GUID+129)*10,2,486.942,-69.7513,9.56),
((@GUID+129)*10,3,490.29,-73.742,9.56),
((@GUID+129)*10,4,492.072,-78.6373,9.56),
((@GUID+129)*10,5,492.072,-83.8467,9.56),
((@GUID+129)*10,6,490.29,-88.742,9.56),
((@GUID+129)*10,7,486.942,-92.7327,9.56),
((@GUID+129)*10,8,482.43,-95.3374,9.56),
((@GUID+129)*10,9,477.3,-96.242,9.56),
((@GUID+129)*10,10,472.17,-95.3374,9.56),
((@GUID+129)*10,11,467.658,-92.7327,9.56),
((@GUID+129)*10,12,464.31,-88.742,9.56),
((@GUID+129)*10,13,462.528,-83.8467,9.56),
((@GUID+129)*10,14,462.528,-78.6373,9.56),
((@GUID+129)*10,15,464.31,-73.742,9.56),
((@GUID+129)*10,16,467.658,-69.7513,9.56),
((@GUID+129)*10,17,472.17,-67.1466,9.56),
((@GUID+129)*10,18,477.3,-66.242,9.56);

-- Revert a previous bad fix
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=17398;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN  (-85712,-85717,-85719,-85724) AND `source_type`=0;
DELETE FROM `gameobject_scripts` WHERE `id`=150441;
 
-- TrinityCore\sql\updates\world\2012_08_30_00_world_creature_template.sql 
ALTER TABLE `creature_template` ADD `unit_flags2` int(10) UNSIGNED NOT NULL DEFAULT '0' AFTER `unit_flags`;
 
-- TrinityCore\sql\updates\world\2012_08_30_00_world_spell_script_names.sql 
DELETE FROM `spell_script_names` WHERE `spell_id` IN (41054, 63418, 69893, 45205, 69896, 57594);
INSERT INTO `spell_script_names` VALUES
(41054, "spell_gen_clone_weapon_aura"),
(63418, "spell_gen_clone_weapon_aura"),
(69893, "spell_gen_clone_weapon_aura"),
(45205, "spell_gen_clone_weapon_aura"),
(69896, "spell_gen_clone_weapon_aura"),
(57594, "spell_gen_clone_weapon_aura");
 
-- TrinityCore\sql\updates\world\2012_08_31_00_world_command.sql 
DELETE FROM `command` WHERE `name`='explorecheat';
DELETE FROM `command` WHERE `name`='taxicheat';
DELETE FROM `command` WHERE `name`='waterwalk';

DELETE FROM `command` WHERE `name`='cheat' OR `name` LIKE 'cheat%';
INSERT INTO `command` (`name`, `security`, `help`) VALUES 
('cheat',           2, 'Syntax: .cheat $subcommand\r\nType .cheat to see the list of possible subcommands or .help cheat $subcommand to see info on subcommands'),
('cheat god',       2, 'Syntax: .cheat god [on/off]\r\nEnables or disables your character''s ability to take damage.'),
('cheat casttime',  2, 'Syntax: .cheat casttime [on/off]\r\nEnables or disables your character''s spell cast times.'),
('cheat cooldown',  2, 'Syntax: .cheat cooldown [on/off]\r\nEnables or disables your character''s spell cooldowns.'),
('cheat power',     2, 'Syntax: .cheat power [on/off]\r\nEnables or disables your character''s spell cost (e.g mana).'),
('cheat waterwalk', 2, 'Syntax: .cheat waterwalk on/off\r\nSet on/off waterwalk state for selected player or self if no player selected.'),
('cheat explore',   2, 'Syntax: .cheat explore #flag\r\nReveal or hide all maps for the selected player. If no player is selected, hide or reveal maps to you.\r\nUse a #flag of value 1 to reveal, use a #flag value of 0 to hide all maps.'),
('cheat taxi',      2, 'Syntax: .cheat taxi on/off\r\nTemporary grant access or remove to all taxi routes for the selected character.\r\n If no character is selected, hide or reveal all routes to you.Visited taxi nodes sill accessible after removing access.');
 
-- TrinityCore\sql\updates\world\2012_08_31_00_world_sai.sql 
-- Defending Your Title (13423)
-- Taking on All Challengers (12971)

SET @NPC_CHALLENGER      := 30012; -- Victorious Challenger
SET @QUEST1              := 12971;
SET @QUEST2              := 13423;
SET @GOSSIP_MENUID       := 9865;
SET @SPELL_SUNDER        := 11971; -- Sunder Armor
SET @SPELL_REND          := 11977; -- Rend

UPDATE `creature_template` SET `faction_A`=2109,`faction_H`=2109,`unit_flags`=0x8000,`npcflag`=0x1,`gossip_menu_id`=@GOSSIP_MENUID,`AIName`='SmartAI',`ScriptName`='' WHERE `entry`=@NPC_CHALLENGER;

DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_CHALLENGER;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_CHALLENGER,0,0x0,0x1,'');

DELETE FROM `creature_text` WHERE `entry`=@NPC_CHALLENGER;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_CHALLENGER,0,0,'You will not defeat me!',12,0,100,0,0,0,'Victorious Challenger'),
(@NPC_CHALLENGER,0,1,'You''re not worthy of Thorim!',12,0,100,0,0,0,'Victorious Challenger'),
(@NPC_CHALLENGER,0,2,'Good luck...  You''ll need it!',12,0,100,0,0,0,'Victorious Challenger'),
(@NPC_CHALLENGER,0,3,'May the best win!',12,0,100,0,0,0,'Victorious Challenger');

DELETE FROM `gossip_menu` WHERE `entry`=@GOSSIP_MENUID;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(@GOSSIP_MENUID,13660);

DELETE FROM `gossip_menu_option` WHERE `menu_id`=@GOSSIP_MENUID;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`box_coded`,`box_money`,`box_text`) VALUES
(@GOSSIP_MENUID,0,0,'Let''s do this, sister.',1,1,0,0,0,0,'');

DELETE FROM `creature_equip_template` WHERE `entry`=@NPC_CHALLENGER;
INSERT INTO `creature_equip_template` (`entry`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES
(@NPC_CHALLENGER,40542,39288,0);

DELETE FROM `smart_scripts` WHERE (`source_type`=0 AND `entryorguid`=@NPC_CHALLENGER) OR (`source_type`=9 AND `entryorguid`=@NPC_CHALLENGER*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_CHALLENGER,0,0,0,25,0,100,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Victorious Challenger - On Reset - Set Default Faction'),
(@NPC_CHALLENGER,0,1,2,62,0,100,0,@GOSSIP_MENUID,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Victorious Challenger - On Gossip - Close Gossip'),
(@NPC_CHALLENGER,0,2,0,61,0,100,0,0,0,0,0,80,@NPC_CHALLENGER*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Victorious Challenger - On Gossip - Run Timed Script'),
(@NPC_CHALLENGER,0,3,0,9,0,100,0,0,5,5000,10000,11,@SPELL_SUNDER,0,0,0,0,0,2,0,0,0,0,0,0,0,'Victorious Challenger - On Range - Cast Sunder Armor'),
(@NPC_CHALLENGER,0,4,0,0,0,100,0,10000,15000,15000,20000,11,@SPELL_REND,0,0,0,0,0,2,0,0,0,0,0,0,0,'Victorious Challenger - IC - Cast Rend'),
(@NPC_CHALLENGER*100,9,0,0,0,0,100,0,1000,1000,1000,1000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Victorious Challenger - Timed - Talk'),
(@NPC_CHALLENGER*100,9,1,0,0,0,100,0,3000,3000,3000,3000,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Victorious Challenger - Timed - Set Faction Hostile'),
(@NPC_CHALLENGER*100,9,2,0,0,0,100,0,0,0,0,0,49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Victorious Challenger - Timed - Attack Invoker');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=@GOSSIP_MENUID;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,@GOSSIP_MENUID,0,0,0,9,0,@QUEST1,0,0,0,0,'','Show gossip option 0 if player has quest Taking on All Challengers'),
(15,@GOSSIP_MENUID,0,0,1,9,0,@QUEST2,0,0,0,0,'','Show gossip option 0 if player has quest Defending Your Title');
 
-- TrinityCore\sql\updates\world\2012_09_01_00_world_spell_script_names.sql 
-- Unlocking zuluhed chains
DELETE FROM `spell_script_names` WHERE `spell_id`=38790;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(38790, 'spell_unlocking_zuluheds_chains');
 
-- TrinityCore\sql\updates\world\2012_09_02_00_world_quest_template.sql 
-- Kandrostrasz <Brood of Alexstrasza> (15503) quests RequiredClasses fix by nelegalno
UPDATE `quest_template` SET `RequiredClasses` = 1 WHERE `Id` IN (8559,8560); -- Warrior
UPDATE `quest_template` SET `RequiredClasses` = 2 WHERE `Id` IN (8629,8655); -- Paladin
UPDATE `quest_template` SET `RequiredClasses` = 4 WHERE `Id` IN (8626,8658); -- Hunter
UPDATE `quest_template` SET `RequiredClasses` = 8 WHERE `Id` IN (8637,8640); -- Rogue
UPDATE `quest_template` SET `RequiredClasses` = 16 WHERE `Id` IN (8593,8596); -- Priest
UPDATE `quest_template` SET `RequiredClasses` = 64 WHERE `Id` IN (8621,8624); -- Shaman
UPDATE `quest_template` SET `RequiredClasses` = 128 WHERE `Id` IN (8631,8634); -- Mage
UPDATE `quest_template` SET `RequiredClasses` = 256 WHERE `Id` IN (8660,8663); -- Warlock
UPDATE `quest_template` SET `RequiredClasses` = 1024 WHERE `Id` IN (8665,8668); -- Druid

-- Andorgos <Brood of Malygos> (15502) quests RequiredClasses fix by nelegalno
UPDATE `quest_template` SET `RequiredClasses` = 1 WHERE `Id` IN (8544,8561); -- Warrior
UPDATE `quest_template` SET `RequiredClasses` = 2 WHERE `Id` IN (8628,8630); -- Paladin
UPDATE `quest_template` SET `RequiredClasses` = 4 WHERE `Id` IN (8657,8659); -- Hunter
UPDATE `quest_template` SET `RequiredClasses` = 8 WHERE `Id` IN (8639,8641); -- Rogue
UPDATE `quest_template` SET `RequiredClasses` = 16 WHERE `Id` IN (8592,8594); -- Priest
UPDATE `quest_template` SET `RequiredClasses` = 64 WHERE `Id` IN (8602,8623); -- Shaman
UPDATE `quest_template` SET `RequiredClasses` = 128 WHERE `Id` IN (8625,8632); -- Mage
UPDATE `quest_template` SET `RequiredClasses` = 256 WHERE `Id` IN (8662,8664); -- Warlock
UPDATE `quest_template` SET `RequiredClasses` = 1024 WHERE `Id` IN (8667,8669); -- Druid

-- Craftsman Wilhelm <Brotherhood of the Light> (16376) NPCs quests
UPDATE `quest_template` SET `RequiredClasses` = 3 WHERE `Id` IN (9234,9235,9236); -- Warrior, Paladin
UPDATE `quest_template` SET `RequiredClasses` = 68 WHERE `Id` IN (9244,9245,9246); -- Hunter, Shaman
UPDATE `quest_template` SET `RequiredClasses` = 400 WHERE `Id` IN (9238,9239,9240); -- Priest, Mage, Warlock
UPDATE `quest_template` SET `RequiredClasses` = 1032 WHERE `Id` IN (9241,9242,9243); -- Rogue, Druid

-- Zanza the Restless (15042) NPCs quests
UPDATE `quest_template` SET `RequiredClasses` = 1 WHERE `Id` = 8184; -- Warrior
UPDATE `quest_template` SET `RequiredClasses` = 2 WHERE `Id` = 8185; -- Paladin
UPDATE `quest_template` SET `RequiredClasses` = 4 WHERE `Id` = 8187; -- Hunter
UPDATE `quest_template` SET `RequiredClasses` = 8 WHERE `Id` = 8186; -- Rogue
UPDATE `quest_template` SET `RequiredClasses` = 16 WHERE `Id` = 8191; -- Priest
UPDATE `quest_template` SET `RequiredClasses` = 64 WHERE `Id` = 8188; -- Shaman
UPDATE `quest_template` SET `RequiredClasses` = 128 WHERE `Id` = 8189; -- Mage
UPDATE `quest_template` SET `RequiredClasses` = 256 WHERE `Id` = 8190; -- Warlock
UPDATE `quest_template` SET `RequiredClasses` = 1024 WHERE `Id` = 8192; -- Druid

-- Vethsera <Brood of Ysera> (15504) quests RequiredClasses fix by nelegalno
UPDATE `quest_template` SET `RequiredClasses` = 1 WHERE `Id` = 8562; -- Warrior
UPDATE `quest_template` SET `RequiredClasses` = 2 WHERE `Id` = 8627; -- Paladin
UPDATE `quest_template` SET `RequiredClasses` = 4 WHERE `Id` = 8656; -- Hunter
UPDATE `quest_template` SET `RequiredClasses` = 8 WHERE `Id` = 8638; -- Rogue
UPDATE `quest_template` SET `RequiredClasses` = 16 WHERE `Id` = 8603; -- Priest
UPDATE `quest_template` SET `RequiredClasses` = 64 WHERE `Id` = 8622; -- Shaman
UPDATE `quest_template` SET `RequiredClasses` = 128 WHERE `Id` = 8633; -- Mage
UPDATE `quest_template` SET `RequiredClasses` = 256 WHERE `Id` = 8661; -- Warlock
UPDATE `quest_template` SET `RequiredClasses` = 1024 WHERE `Id` = 8666; -- Druid
 
-- TrinityCore\sql\updates\world\2012_09_02_01_world_sai.sql 
-- Lok'lira the Crone
SET @ENTRY := 29975;
UPDATE `creature_template` SET `AIName`='SmartAI', `ScriptName`='' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,9910,0,0,0,33,30467,0,0,0,0,0,7,0,0,0,0,0,0,0,'Loklira - gossip select 4 - The Hyldsmeet Kill credit'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Loklira - gossip select 4 - Close gossip');

UPDATE `gossip_menu_option` SET `action_menu_id`=9908 WHERE `menu_id`=9907;
UPDATE `gossip_menu_option` SET `action_menu_id`=9909 WHERE `menu_id`=9908;
UPDATE `gossip_menu_option` SET `action_menu_id`=9910 WHERE `menu_id`=9909;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9907;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,9907,0,0,9,12970,0,0,0,'','Loklira - Show gossip if quest accepted');

-- Thorim
SET @THORIM :=29445;
UPDATE `creature` SET `modelid`=0 WHERE `id`=@THORIM;
UPDATE `creature_template` SET `AIName`='SmartAI', `ScriptName`='' WHERE `entry`=@THORIM;
DELETE FROM `creature_addon` WHERE `guid`=97128;
DELETE FROM `creature_template_addon` WHERE `entry`=@THORIM;
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@THORIM,0,0,1,0,0,'');

DELETE FROM `smart_scripts` WHERE `entryorguid`=@THORIM AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@THORIM,0,0,0,62,0,100,0,9926,0,0,0,33,30514,0,0,0,0,0,7,0,0,0,0,0,0,0,'Thorim - gossip select  - give quest credit');

UPDATE `gossip_menu_option` SET `action_menu_id`=9927 WHERE `menu_id`=9924;
UPDATE `gossip_menu_option` SET `action_menu_id`=9926 WHERE `menu_id`=9927;
UPDATE `gossip_menu_option` SET `action_menu_id`=9925 WHERE `menu_id`=9926;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9924;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,9924,0,0,9,13064,0,0,0,'','Thorim - Show gossip if quest accepted');
 
-- TrinityCore\sql\updates\world\2012_09_03_00_world_misc.sql 
-- Cold Hearted (12856)

SET @NPC_CAPTIVE_DRAKE        := 29708; -- Captive Proto-Drake
SET @NPC_FREED_DRAKE          := 29709; -- Freed Proto-Drake
SET @NPC_PRISONER             := 29639; -- Brunnhildar Prisoner
SET @NPC_LIBERATED            := 29734; -- Liberated Brunnhildar

SET @SPELL_SUM_FREE_DRAKE     := 55028; -- Summon Freed Proto-Drake
SET @SPELL_ICE_SHARD          := 55046; -- Ice Shard (Rank 3)
SET @SPELL_FREE_PRISONER      := 55048; -- Free Brunnhildar Prisoner
SET @AURA_IMPRISONMENT        := 54894; -- Icy Imprisonment


UPDATE `creature_template` SET `speed_walk`=1,`speed_run`=1.14286,`spell1`=@SPELL_ICE_SHARD,`HoverHeight`=4,`unit_flags`=0x1000008,`InhabitType`=4,`ScriptName`='npc_freed_protodrake' WHERE `entry`=@NPC_FREED_DRAKE;
UPDATE `creature_template` SET `unit_flags`=33554432,`AIName`='SmartAI' WHERE `entry`=@NPC_LIBERATED;

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=@NPC_CAPTIVE_DRAKE;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES
(@NPC_CAPTIVE_DRAKE,@SPELL_SUM_FREE_DRAKE,1,0);

DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_FREED_DRAKE;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_FREED_DRAKE,0,0x3000000,0x1,'55034 61183');

DELETE FROM `creature_text` WHERE `entry`=@NPC_FREED_DRAKE;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_FREED_DRAKE,0,0,'Return to Brunnhildar Village!',42,0,100,0,0,0,'Freed Proto-Drake'),
(@NPC_FREED_DRAKE,0,1,'The proto-drake smells freedom and flies homeward!',41,0,100,0,0,0,'Freed Proto-Drake');

DELETE FROM `spell_scripts` WHERE `id`=@SPELL_FREE_PRISONER;
INSERT INTO `spell_scripts` (`id`,`effIndex`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(@SPELL_FREE_PRISONER,0,0,14,@AURA_IMPRISONMENT,0,0,0,0,0,0);

DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@NPC_LIBERATED;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_LIBERATED,0,0,0,54,0,100,0,0,0,0,0,41,30000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Liberated Brunnhildar - On Spawn - Despawn in 30 seconds');
 
-- TrinityCore\sql\updates\world\2012_09_03_01_world_gameobject_template.sql 
UPDATE `gameobject_template` SET `flags`=40 WHERE `entry`=186371; -- Zeppelin
 
-- TrinityCore\sql\updates\world\2012_09_03_02_world_quest_template.sql 
-- Stalk the Stalker (9719) quest requirements fix
UPDATE `quest_template` SET `RequiredRaces` = 0 WHERE `Id` = 9719;
 
-- TrinityCore\sql\updates\world\2012_09_07_00_world_spell_bonus_data.sql 
SET @Spell := 28715; -- Flamecap Fire
DELETE FROM `spell_bonus_data` WHERE `entry`=@Spell;
INSERT INTO `spell_bonus_data` (`entry`,`direct_bonus`,`dot_bonus`,`ap_bonus`,`ap_dot_bonus`,`comments`) VALUES
(@Spell,0,0,0,0, 'Flamecap Fire');
 
-- TrinityCore\sql\updates\world\2012_09_07_01_world_creature_template.sql 
UPDATE `creature_template` SET `unit_flags2`=`unit_flags2`|0x800; -- UNIT_FLAG2_REGENERATE_POWER
 
-- TrinityCore\sql\updates\world\2012_09_07_02_world_spell_script_names.sql 
DELETE FROM spell_script_names WHERE spell_id = -755;
INSERT IGNORE INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(-755, 'spell_warl_health_funnel');
 
-- TrinityCore\sql\updates\world\2012_09_08_00_world_achievement_criteria_data.sql 
DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (10304,10313);
INSERT INTO `achievement_criteria_data` (`criteria_id`,`type`,`value1`,`value2`,`ScriptName`) VALUES
(10304,5,62320,0,''),
(10304,12,0,0,''),
(10313,5,62320,0,''),
(10313,12,1,0,'');
 
-- TrinityCore\sql\updates\world\2012_09_08_01_world_creature_template.sql 
UPDATE `creature_template` SET `InhabitType`=4 WHERE `entry` IN (32930,33909); -- Kologarn
 
-- TrinityCore\sql\updates\world\2012_09_08_02_world_achievement_criteria_data.sql 
-- Criteria data for achievement 'Wrecking Ball'
DELETE FROM `disables` WHERE `sourceType`=4 AND `entry` IN (3368, 3369, 3370, 12578, 7623, 3371);
DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (3368, 3369, 3370, 12578, 7623, 3371);
INSERT INTO `achievement_criteria_data`(`criteria_id`,`type`,`value1`,`value2`,`ScriptName`) VALUES
(3368,2,0,0,''),
(3369,2,0,0,''),
(3370,2,0,0,''),
(12578,2,0,0,''),
(7623,2,0,0,''),
(3371,2,0,0,'');
 
-- TrinityCore\sql\updates\world\2012_09_09_00_world_command.sql 
DELETE FROM `command` WHERE `name` = 'start';
DELETE FROM `command` WHERE `name` = 'unstuck';
INSERT INTO `command` (`name`, `security`, `help`) VALUES
('unstuck', 0, 'Syntax: .unstuck $playername [inn/graveyard/startzone]\n\nTeleports specified player to specified location. Default location is player\'s current hearth location.');
 
-- TrinityCore\sql\updates\world\2012_09_09_01_world_trinity_string.sql 
DELETE FROM `trinity_string` WHERE `entry`=63; -- Existing entry 63 is not present in Language.h. It's safe to remove it.
INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(63, 'You can''t do that right now.');
 
-- TrinityCore\sql\updates\world\2012_09_09_02_world_spell_script_names.sql 
-- Gift of the Naaru
DELETE FROM `spell_script_names` WHERE `ScriptName`='spell_gen_gift_of_naaru';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(28880,'spell_gen_gift_of_naaru'), -- SPELLFAMILY_WARRIOR
(59542,'spell_gen_gift_of_naaru'), -- SPELLFAMILY_PALADIN
(59543,'spell_gen_gift_of_naaru'), -- SPELLFAMILY_HUNTER
(59544,'spell_gen_gift_of_naaru'), -- SPELLFAMILY_PRIEST
(59545,'spell_gen_gift_of_naaru'), -- SPELLFAMILY_DEATHKNIGHT
(59547,'spell_gen_gift_of_naaru'), -- SPELLFAMILY_SHAMAN
(59548,'spell_gen_gift_of_naaru'); -- SPELLFAMILY_MAGE
 
-- TrinityCore\sql\updates\world\2012_09_09_03_world_spell_bonus_data.sql 
DELETE FROM `spell_bonus_data` WHERE `entry` IN (28880,59542,59543,59544,59545,59547,59548);
INSERT INTO `spell_bonus_data` (`entry`,`direct_bonus`,`dot_bonus`,`ap_bonus`,`ap_dot_bonus`,`comments`) VALUES
(28880,0,0,0,0,'Warrior - Gift of the Naaru'),
(59542,0,0,0,0,'Paladin - Gift of the Naaru'),
(59543,0,0,0,0,'Hunter - Gift of the Naaru'),
(59544,0,0,0,0,'Priest - Gift of the Naaru'),
(59545,0,0,0,0,'Deathknight - Gift of the Naaru'),
(59547,0,0,0,0,'Shaman - Gift of the Naaru'),
(59548,0,0,0,0,'Mage - Gift of the Naaru');
 
-- TrinityCore\sql\updates\world\2012_09_09_04_world_quest_template.sql 
UPDATE `quest_template` SET `OfferRewardText`='Excellent, $N. You''ve saved me a lot of work!$b$bBut don''t think that I''m not grateful!' WHERE `Id`=6571;
 
-- TrinityCore\sql\updates\world\2012_09_10_00_world_game_event.sql 
UPDATE `game_event` SET `start_time`='2012-11-04 00:01:00' WHERE `eventEntry`=3; -- Darkmoon Faire - Terrokkar 
UPDATE `game_event` SET `start_time`='2012-12-02 00:01:00' WHERE `eventEntry`=4; -- Darkmoon Faire - Elwynn 
UPDATE `game_event` SET `start_time`='2012-10-07 00:01:00' WHERE `eventEntry`=5; -- Darkmoon Faire - Mulgore
 
-- TrinityCore\sql\updates\world\2012_09_10_01_world_quest_template.sql 
UPDATE `quest_template` SET `OfferRewardText`="What!? If I knew that Pao'ka Swiftmountain was going to snoop around Highperch, I would have chained him to a totem! His father was reluctant allowing him to come with me to Thousand Needles. We came here to study the different creatures that inhabit these beautiful lands.$b$bI appreciate the help you have shown Pao'ka. I hope this covers any misfortunes this deed has cost you." WHERE `Id`=4770;
 
-- TrinityCore\sql\updates\world\2012_09_10_02_world_creature_text.sql 
UPDATE `creature_text` SET `text`='Good news, everyone! I think I''ve perfected a plague that will destroy all life on Azeroth!' WHERE `entry`=36678 AND `groupid`=4 AND `id`=0;
 
-- TrinityCore\sql\updates\world\2012_09_10_03_world_quest_template.sql 
-- Grark Lorkrub should be available only when Kill On Sight: High Ranking Dark Iron Officials is complete
UPDATE `quest_template` SET `NextQuestId`=4122 WHERE `Id`=4082;
UPDATE `quest_template` SET `PrevQuestId`=4082 WHERE `Id`=4122;
 
-- TrinityCore\sql\updates\world\2012_09_10_04_world_quest_template.sql 
-- Fix some quest requirements
UPDATE `quest_template` SET `PrevQuestId`=3906 WHERE `Id` IN (3907,7201); -- Disharmony of Fire and The Last Element are available only, if Disharmony of Flame is completed
 
-- TrinityCore\sql\updates\world\2012_09_10_06_world_creature_template.sql 
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|256 WHERE `entry` IN (36897, 38138); -- Little Ooze
 
-- TrinityCore\sql\updates\world\2012_09_10_07_world_go_loot_template.sql 
-- Vic's Keys drop chance ( http://old.wowhead.com/object=190778 ) by nelegalno
UPDATE `gameobject_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `entry`=24861 AND `item`=39264;
 
-- TrinityCore\sql\updates\world\2012_09_10_08_world_spell_area.sql 
-- Cast Armistice in front of the pavillions as well
DELETE FROM `spell_area` WHERE `spell`=64373 AND `area` IN (4676, 4677);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_start_active`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`) VALUES
(64373,4676,0,0,0,0,0,2,1), -- Sunreaver Pavillion
(64373,4677,0,0,0,0,0,2,1); -- SIlver Covenant Pavillion
 
-- TrinityCore\sql\updates\world\2012_09_10_09_world_creature_involvedrelation.sql 
DELETE FROM creature_involvedrelation WHERE quest IN (25500, 25286);
INSERT INTO creature_involvedrelation (id, quest) VALUES
(39675, 25500),
(39675, 25286);
 
-- TrinityCore\sql\updates\world\2012_09_10_10_world_gossips.sql 
-- gossip assignation from sniff
UPDATE `creature_template` SET `gossip_menu_id`=4534 WHERE `entry`=3047; -- Archmage Shymm <Mage Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=4536 WHERE `entry`=3048; -- Ursyn Ghull <Mage Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=12670 WHERE `entry`=6328; -- Dannie Fizzwizzle <Demon Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=12670 WHERE `entry`=6373; -- Dane Winslow <Demon Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=12670 WHERE `entry`=6374; -- Cylina Darkheart <Demon Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=1622 WHERE `entry`=8965; -- Shawn
UPDATE `creature_template` SET `gossip_menu_id`=4119 WHERE `entry`=11047; -- Kray <Apprentice Alchemist>
UPDATE `creature_template` SET `gossip_menu_id`=4266 WHERE `entry`=11051; -- Vhan <Apprentice Tailor>
UPDATE `creature_template` SET `gossip_menu_id`=4154 WHERE `entry`=11065; -- Thonys Pillarstone <Apprentice Enchanter>
UPDATE `creature_template` SET `gossip_menu_id`=4158 WHERE `entry`=11071; -- Mot Dawnstrider <Apprentice Enchanter>
UPDATE `creature_template` SET `gossip_menu_id`=4204 WHERE `entry`=11081; -- Faldron <Apprentice Leatherworker>
UPDATE `creature_template` SET `gossip_menu_id`=4181 WHERE `entry`=11083; -- Darianna <Apprentice Leatherworker>
UPDATE `creature_template` SET `gossip_menu_id`=4207 WHERE `entry`=11084; -- Tarn <Apprentice Leatherworker>
UPDATE `creature_template` SET `gossip_menu_id`=5142 WHERE `entry`=13442; -- Arch Druid Renferal
UPDATE `creature_template` SET `gossip_menu_id`=5141 WHERE `entry`=13443; -- Druid of the Grove
UPDATE `creature_template` SET `gossip_menu_id`=5081 WHERE `entry`=13447; -- Corporal Noreg Stormpike
UPDATE `creature_template` SET `gossip_menu_id`=5281 WHERE `entry`=13577; -- Stormpike Ram Rider Commander
UPDATE `creature_template` SET `gossip_menu_id`=7993 WHERE `entry`=15991; -- Lady Dena Kennedy
UPDATE `creature_template` SET `gossip_menu_id`=7471 WHERE `entry`=17421; -- Clopper Wizbang <Explorers' League>
UPDATE `creature_template` SET `gossip_menu_id`=7455 WHERE `entry`=17424; -- Anchorite Paetheus <First Aid Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=7459 WHERE `entry`=17434; -- Morae <Herbalism Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=7461 WHERE `entry`=17599; -- Aonar
UPDATE `creature_template` SET `gossip_menu_id`=7462 WHERE `entry`=17649; -- Kessel <Elekk Lord>
UPDATE `creature_template` SET `gossip_menu_id`=9821 WHERE `entry`=17666; -- Astur <Stable Master>
UPDATE `creature_template` SET `gossip_menu_id`=7463 WHERE `entry`=17676; -- Achelus
UPDATE `creature_template` SET `gossip_menu_id`=7464 WHERE `entry`=17703; -- Messenger Hermesius
UPDATE `creature_template` SET `gossip_menu_id`=8298 WHERE `entry`=17712; -- Captain Edward Hanes
UPDATE `creature_template` SET `gossip_menu_id`=7835 WHERE `entry`=17927; -- Scout Jorli
UPDATE `creature_template` SET `gossip_menu_id`=7738 WHERE `entry`=18252; -- Andarl
UPDATE `creature_template` SET `gossip_menu_id`=7753 WHERE `entry`=18387; -- Bertelm
UPDATE `creature_template` SET `gossip_menu_id`=7743 WHERE `entry`=18389; -- Thander
UPDATE `creature_template` SET `gossip_menu_id`=7752 WHERE `entry`=18390; -- Ros'eleth
UPDATE `creature_template` SET `gossip_menu_id`=7695 WHERE `entry`=18416; -- Huntress Kima
UPDATE `creature_template` SET `gossip_menu_id`=7698 WHERE `entry`=18459; -- Jenai Starwhisper
UPDATE `creature_template` SET `gossip_menu_id`=7745 WHERE `entry`=18704; -- Taela Everstride
UPDATE `creature_template` SET `gossip_menu_id`=7773 WHERE `entry`=18713; -- Lieutenant Gravelhammer
UPDATE `creature_template` SET `gossip_menu_id`=7814 WHERE `entry`=18745; -- Captain Auric Sunchaser
UPDATE `creature_template` SET `gossip_menu_id`=7833 WHERE `entry`=18804; -- Prospector Nachlan <Explorers' League>
UPDATE `creature_template` SET `gossip_menu_id`=7940 WHERE `entry`=19137; -- "Shotgun" Jones <Nesingwary Safari>
UPDATE `creature_template` SET `gossip_menu_id`=8433 WHERE `entry`=19340; -- Mi'irku Farstep <Portal Trainer>
UPDATE `creature_template` SET `gossip_menu_id`=7973 WHERE `entry`=19375; -- Eli Thunderstrike <Sky'ree's Keeper>
UPDATE `creature_template` SET `gossip_menu_id`=8251 WHERE `entry`=21151; -- Borgrim Stouthammer <Explorers' League>
UPDATE `creature_template` SET `gossip_menu_id`=8247 WHERE `entry`=21158; -- Commander Skyshadow
UPDATE `creature_template` SET `gossip_menu_id`=8252 WHERE `entry`=21197; -- Bronwyn Stouthammer <Explorers' League>
UPDATE `creature_template` SET `gossip_menu_id`=8566 WHERE `entry`=22832; -- Morthis Whisperwing <Druid of the Talon>

-- gossip from sniff
DELETE FROM `gossip_menu` WHERE (`entry`=1621 AND `text_id`=2273) OR (`entry`=1622 AND `text_id`=2276) OR (`entry`=4119 AND `text_id`=5040) OR (`entry`=4154 AND `text_id`=5184) OR (`entry`=4158 AND `text_id`=5196) OR (`entry`=4181 AND `text_id`=5273) OR (`entry`=4204 AND `text_id`=5325) OR (`entry`=4207 AND `text_id`=5340) OR (`entry`=4266 AND `text_id`=5428) OR (`entry`=4534 AND `text_id`=563) OR (`entry`=4536 AND `text_id`=563) OR (`entry`=5081 AND `text_id`=6288) OR (`entry`=5141 AND `text_id`=6173) OR (`entry`=5142 AND `text_id`=6174) OR (`entry`=5281 AND `text_id`=6313) OR (`entry`=7455 AND `text_id`=9029) OR (`entry`=7459 AND `text_id`=9034) OR (`entry`=7461 AND `text_id`=9037) OR (`entry`=7462 AND `text_id`=9041) OR (`entry`=7463 AND `text_id`=9042) OR (`entry`=7464 AND `text_id`=9043) OR (`entry`=7471 AND `text_id`=9054) OR (`entry`=7695 AND `text_id`=9389) OR (`entry`=7698 AND `text_id`=9393) OR (`entry`=7738 AND `text_id`=9471) OR (`entry`=7743 AND `text_id`=9481) OR (`entry`=7745 AND `text_id`=9484) OR (`entry`=7752 AND `text_id`=9492) OR (`entry`=7753 AND `text_id`=9493) OR (`entry`=7773 AND `text_id`=9521) OR (`entry`=7814 AND `text_id`=9566) OR (`entry`=7833 AND `text_id`=9586) OR (`entry`=7835 AND `text_id`=9591) OR (`entry`=7940 AND `text_id`=9733) OR (`entry`=7973 AND `text_id`=9805) OR (`entry`=7993 AND `text_id`=9845) OR (`entry`=8247 AND `text_id`=10264) OR (`entry`=8251 AND `text_id`=10270) OR (`entry`=8252 AND `text_id`=10271) OR (`entry`=8298 AND `text_id`=10352) OR (`entry`=8432 AND `text_id`=10538) OR (`entry`=8433 AND `text_id`=10291) OR (`entry`=8433 AND `text_id`=10292) OR (`entry`=8566 AND `text_id`=10735);
INSERT INTO `gossip_menu` (`entry`, `text_id`) VALUES
(1621, 2273), -- 8962
(1622, 2276), -- 8965
(4119, 5040), -- 11047
(4154, 5184), -- 11065
(4158, 5196), -- 11071
(4181, 5273), -- 11083
(4204, 5325), -- 11081
(4207, 5340), -- 11084
(4266, 5428), -- 11051
(4534, 563), -- 3047
(4536, 563), -- 3048
(5081, 6288), -- 13447
(5141, 6173), -- 13443
(5142, 6174), -- 13442
(5281, 6313), -- 13577
(7455, 9029), -- 17424
(7459, 9034), -- 17434
(7461, 9037), -- 17599
(7462, 9041), -- 17649
(7463, 9042), -- 17676
(7464, 9043), -- 17703
(7471, 9054), -- 17421
(7695, 9389), -- 18416
(7698, 9393), -- 18459
(7738, 9471), -- 18252
(7743, 9481), -- 18389
(7745, 9484), -- 18704
(7752, 9492), -- 18390
(7753, 9493), -- 18387
(7773, 9521), -- 18713
(7814, 9566), -- 18745
(7833, 9586), -- 18804
(7835, 9591), -- 17927
(7940, 9733), -- 19137
(7973, 9805), -- 19375
(7993, 9845), -- 15991
(8247, 10264), -- 21158
(8251, 10270), -- 21151
(8252, 10271), -- 21197
(8298, 10352), -- 17712
(8432, 10538), -- 21983
(8433, 10291), -- 19340
(8433, 10292), -- 19340
(8566, 10735); -- 22832

-- correct npc_flags for npc from sniff
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=3210; -- Brave Proudsnout
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=3211; -- Brave Lightninghorn
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=3213; -- Brave Running Wolf
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=3214; -- Brave Greathoof
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=3502; -- Ratchet Bruiser
UPDATE `creature_template` SET `npcflag`=3 WHERE `entry`=21151; -- Borgrim Stouthammer <Explorers' League>
UPDATE `creature_template` SET `npcflag`=3 WHERE `entry`=21197; -- Bronwyn Stouthammer <Explorers' League>
UPDATE `creature_template` SET `npcflag`=2 WHERE `entry`=21469; -- Daranelle

-- Add condition
DELETE FROM `conditions` WHERE (`SourceTypeOrReferenceId`=14 AND `SourceGroup`=8433 AND `SourceEntry`=10291) OR (`SourceTypeOrReferenceId`=14 AND `SourceGroup`=8433 AND `SourceEntry`=10292) OR (`SourceTypeOrReferenceId`=14 AND `SourceGroup`=12670 AND `SourceEntry`=12549);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(14,8433,10291,0,0,15,0,128,0,0,1,0,'','Show gossip text if player is not a mage'),
(14,8433,10292,0,0,15,0,128,0,0,0,0,'','Show gossip text if player is a mage'),
(14,12670,12549,0,0,15,0,256,0,0,1,0,'','Show gossip text if player is not a Warlock');
 
-- TrinityCore\sql\updates\world\2012_09_10_11_world_event_scripts.sql 
-- Finding the Keymaster by nelegalno

UPDATE `quest_template` SET `SpecialFlags` = 0, `RequiredSpellCast1` = 0 WHERE `ID` = 10256;
DELETE FROM `event_scripts` WHERE id=12857;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(12857,0,10,19938,3000000,0,2248.43,2227.97,138.56,2.48121),
(12857,1,8,19938,1,0,0,0,0,0);
 
-- TrinityCore\sql\updates\world\2012_09_10_12_world_sai.sql 
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry`=20243;
DELETE FROM `smart_scripts` WHERE `entryorguid`=20243 AND `id`=0 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20243,0,0,0,8,0,100,0,256,0,0,0,19,0,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"Scrapped Fel Reaver - On Spellhit - Remove - OOC Not attackable - flags");
 
-- TrinityCore\sql\updates\world\2012_09_10_13_world_creature_model_info.sql 
UPDATE `creature_model_info` SET `modelid_other_gender`=4264 WHERE `modelid`=4261; -- Female orc grunt
UPDATE `creature_model_info` SET `modelid_other_gender`=4263 WHERE `modelid`=4262; -- Female tauren
UPDATE `creature_model_info` SET `modelid_other_gender`=4262 WHERE `modelid`=4263; -- Male tauren
UPDATE `creature_model_info` SET `modelid_other_gender`=4261 WHERE `modelid`=4264; -- Male orc grunt
 
-- TrinityCore\sql\updates\world\2012_09_11_00_world_misc.sql 
-- ToCr orbs

SET @NPC_ORB1  := 34606; -- Frost Sphere
SET @NPC_ORB2  := 34649; -- Frost Sphere

UPDATE `creature_template` SET `speed_walk`=1.2,`speed_run`=1.42,`InhabitType`=7 WHERE `entry` IN (@NPC_ORB1,@NPC_ORB2);

DELETE FROM `creature_template_addon` WHERE `entry` IN (@NPC_ORB1,@NPC_ORB2);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_ORB1,0,0x3000000,0x1,''),
(@NPC_ORB2,0,0x3000000,0x1,'');
 
-- TrinityCore\sql\updates\world\2012_09_12_00_world_misc.sql 
-- East Porticullis(195648): close and corrections
UPDATE `gameobject` SET `phaseMask`=1,`rotation2`=0.7071065,`rotation3`=0.707107,`spawntimesecs`=7200,`animprogress`=255,`state`=0 WHERE `guid`=151176;

-- North Portcullis(195650): delete extra spawn and corrections
DELETE FROM `gameobject` WHERE `guid`=150080;
UPDATE `gameobject` SET `phaseMask`=1,`rotation2`=0.7071065,`rotation3`=0.707107,`spawntimesecs`=7200,`animprogress`=255,`state`=1 WHERE `guid`=151178;

-- Web Door(195485): corrections
UPDATE `gameobject` SET `spawnMask`=15,`rotation2`=0.7071067,`rotation3`=0.7071068,`spawntimesecs`=7200,`animprogress`=255 WHERE `guid`=151192;
 
-- TrinityCore\sql\updates\world\2012_09_12_01_world_creature.sql 
DELETE FROM `creature` WHERE `id`=36095;
 
-- TrinityCore\sql\updates\world\2012_09_13_00_world_item_template.sql 
ALTER TABLE `item_template` CHANGE unk0 SoundOverrideSubclass tinyint(3) NOT NULL DEFAULT '-1';
 
-- TrinityCore\sql\updates\world\2012_09_13_01_world_fires_over_skettis.sql 
-- Add support for quest ID: 11008 - "Fires Over Skettis" based on Warpten fix and Nelegalno/shlomi1515 updates
-- Also add support for achievement - http://www.wowhead.com/achievement=1275/bombs-away
SET @TRIGGER :=  22991;
SET @EGG :=     185549;
SET @SKYBLAST := 39844;
SET @SUMMEGG :=  39843;
-- Adds SAI support for Monstrous Kaliri Egg Trigger and the GO
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@TRIGGER;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@TRIGGER AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@TRIGGER*100 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@TRIGGER,0,0,0,25,0,100,0,0,0,0,0,11,@SUMMEGG,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Monstrous Kaliri Egg Trigger - On spawn/reset - Summon Monstrous Kaliri Egg (object wild)'),
(@TRIGGER,0,1,2,8,0,100,0,@SKYBLAST,0,0,0,33,@TRIGGER,0,0,0,0,0,16,0,0,0,0,0,0,0, 'Monstrous Kaliri Egg Trigger - On Skyguard Blasting Charge hit - Give kill credit to invoker party'),
(@TRIGGER,0,2,3,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,20,@EGG,1,0,0,0,0,0, 'Monstrous Kaliri Egg Trigger - Linked with previous event - Despawn'),
(@TRIGGER,0,3,0,61,0,100,0,0,0,0,0,80,@TRIGGER*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Monstrous Kaliri Egg Trigger - Linked with previous event - Start script 0'),
(@TRIGGER*100,9,0,0,0,0,100,0,44000,44000,0,0,11,@SUMMEGG,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Monstrous Kaliri Egg Trigger /On actionlist/ - Action 0 - Cast Summon Monstrous Kaliri Egg');
-- Add SAI for Cannonball Stack
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry`=@EGG;
DELETE FROM `smart_scripts` WHERE `source_type`=1 AND `entryorguid`=@EGG;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@EGG,1,0,0,38,0,100,0,0,1,0,0,70,45,0,0,0,0,0,1,0,0,0,0,0,0,0,' Monstrous Kaliri Egg - On data set 0 1 - Respawn object /make it reappear after 45 secs/');
-- Remove achievement from disabled
DELETE FROM `disables` WHERE  `sourceType`=4 AND `entry`=3922;
-- Insert GO spawns taken directly from already spawned triggers coordinates = no need to sniff them
SET @guid := 74685;
DELETE FROM `gameobject` WHERE `id`=@EGG;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`) VALUES
(@guid+0,@EGG,530,1,1,-3857.69,3426.25,363.733,-0.087267,180),
(@guid+1,@EGG,530,1,1,-3845.16,3332.2,338.59,2.9147,180),
(@guid+2,@EGG,530,1,1,-3965.16,3232.7,347.552,-0.122173,180),
(@guid+3,@EGG,530,1,1,-3955.86,3222.16,347.503,0.244346,180),
(@guid+4,@EGG,530,1,1,-3953.3,3227.94,347.564,-0.244346,180),
(@guid+5,@EGG,530,1,1,-4044.66,3287.29,348.362,0.349066,180),
(@guid+6,@EGG,530,1,1,-4041.39,3271,346.642,-2.09439,180),
(@guid+7,@EGG,530,1,1,-4049.31,3285.9,348.335,1.43117,180),
(@guid+8,@EGG,530,1,1,-4076.99,3415.22,334.008,-2.33874,180),
(@guid+9,@EGG,530,1,1,-4076.79,3412.91,334.617,-1.0821,180),
(@guid+10,@EGG,530,1,1,-4077.92,3412.57,334.768,-0.733038,180),
(@guid+11,@EGG,530,1,1,-4107.93,3121.5,357.427,1.01229,180),
(@guid+12,@EGG,530,1,1,-4108.31,3123.66,357.633,-0.680679,180),
(@guid+13,@EGG,530,1,1,-4110.19,3122.64,358.083,-0.034907,180),
(@guid+14,@EGG,530,1,1,-3996.89,3142.12,372.729,3.05433,180),
(@guid+15,@EGG,530,1,1,-4109.06,3019.1,352.24,0.261799,180),
(@guid+16,@EGG,530,1,1,-4018.35,3076.7,375.29,-0.733038,180),
(@guid+17,@EGG,530,1,1,-4184.98,3044.71,352.394,1.81514,180),
(@guid+18,@EGG,530,1,1,-4187.52,3040.39,352.071,-0.017453,180),
(@guid+19,@EGG,530,1,1,-4189.67,3039.9,352.247,-0.785398,180),
(@guid+20,@EGG,530,1,1,-4192.61,3045.1,352.096,3.14159,180),
(@guid+21,@EGG,530,1,1,-4192.02,3046.91,352.297,2.46091,180),
(@guid+22,@EGG,530,1,1,-4186.47,3047.19,352.316,2.60054,180),
(@guid+23,@EGG,530,1,1,-3915.67,2983.4,396.957,-1.91986,180),
(@guid+24,@EGG,530,1,1,-3883.21,3004.11,399.738,-1.64061,180),
(@guid+25,@EGG,530,1,1,-3883.26,3001.55,399.431,-2.3911,180),
(@guid+26,@EGG,530,1,1,-3884.29,3003.3,400.063,-1.88496,180),
(@guid+27,@EGG,530,1,1,-3903.02,3095.85,383.783,-2.28638,180),
(@guid+28,@EGG,530,1,1,-3898.45,3093.06,383.667,2.53073,180),
(@guid+29,@EGG,530,1,1,-3900.75,3100.75,383.795,-0.436333,180),
(@guid+30,@EGG,530,1,1,-4107.81,3023.42,352.142,1.06465,180),
(@guid+31,@EGG,530,1,1,-4113.58,3022.4,352.157,-0.645772,180),
(@guid+32,@EGG,530,1,1,-3893.09,3677.17,374.516,-1.23918,180),
(@guid+33,@EGG,530,1,1,-3892.47,3674,374.478,-2.14675,180),
(@guid+34,@EGG,530,1,1,-4198.53,3168.91,355.847,-0.383972,180),
(@guid+35,@EGG,530,1,1,-4197.01,3170.04,356.117,-1.15192,180),
(@guid+36,@EGG,530,1,1,-4196.54,3167.69,356.348,-0.541052,180),
(@guid+37,@EGG,530,1,1,-4020.07,3077.84,374.391,1.53589,180),
(@guid+38,@EGG,530,1,1,-4019.32,3079.74,375.109,-1.25664,180),
(@guid+39,@EGG,530,1,1,-3917.21,2981.62,396.483,0.733038,180),
(@guid+40,@EGG,530,1,1,-3918.45,2982.44,397.24,-1.72788,180),
(@guid+41,@EGG,530,1,1,-3839.35,3344.85,337.834,2.75762,180),
(@guid+42,@EGG,530,1,1,-3835.3,3344.77,338.155,-0.767945,180),
(@guid+43,@EGG,530,1,1,-3846.43,3430.29,363.729,0.488692,180),
(@guid+44,@EGG,530,1,1,-3864.13,3439.06,363.679,-0.05236,180),
(@guid+45,@EGG,530,1,1,-3863.24,3440.42,363.655,0.349066,180),
(@guid+46,@EGG,530,1,1,-3846.35,3439.34,363.628,-0.122173,180),
(@guid+47,@EGG,530,1,1,-3847.32,3441.39,363.648,0.453786,180),
(@guid+48,@EGG,530,1,1,-3686.21,3301,320.513,0.837758,180),
(@guid+49,@EGG,530,1,1,-3687.77,3299.85,320.307,2.75762,180),
(@guid+50,@EGG,530,1,1,-3692.64,3302.07,320.396,-0.226893,180),
(@guid+51,@EGG,530,1,1,-3661.91,3379.15,320.377,0.890118,180),
(@guid+52,@EGG,530,1,1,-3660.65,3381.9,320.182,1.18682,180),
(@guid+53,@EGG,530,1,1,-3665.48,3380.11,320.365,-0.471239,180),
(@guid+54,@EGG,530,1,1,-3685.07,3305.97,320.198,-2.87979,180),
(@guid+55,@EGG,530,1,1,-3688.3,3308.93,320.337,1.65806,180),
(@guid+56,@EGG,530,1,1,-3690.65,3306.77,320.43,-2.79253,180),
(@guid+57,@EGG,530,1,1,-3879.37,3665.22,374.393,-2.30383,180),
(@guid+58,@EGG,530,1,1,-3990.42,3139.13,372.878,-2.61799,180),
(@guid+59,@EGG,530,1,1,-3991.59,3134.33,372.703,-0.017453,180),
(@guid+60,@EGG,530,1,1,-3884.89,3684.98,374.492,-2.53073,180),
(@guid+61,@EGG,530,1,1,-3800.8,3789.62,314,6.0912,180),
(@guid+62,@EGG,530,1,1,-3799.02,3788.06,314.158,3.19395,180),
(@guid+63,@EGG,530,1,1,-3798.91,3790.61,313.852,3.63029,180);
 
-- TrinityCore\sql\updates\world\2012_09_13_01_world_ogrila.sql 
-- Quest support for http://www.wowhead.com/quest=11010 "Bombing Run", http://www.wowhead.com/quest=11102 "Bombing Run" /druid/ and http://www.wowhead.com/quest=11023 "Bomb Them Again!"
-- Achievement support for http://www.wowhead.com/achievement=1282 and http://www.wowhead.com/achievement=1276,
-- Based on Warpten Script
SET @SKYGUARD_BOMB       := 32456;
SET @Run_Dummy           := 23118;
SET @Explosion_Bunny     := 23119;
SET @Flak_Cannon         := 23076;
SET @Flak_Cannon2        := 23082;
SET @Fel_Cannon_Dummy    := 23077;
SET @RUN_MARK            := 40196;
SET @THROW_BOMB          := 40160;
SET @EXPLOSION_VISUAL    := 40162;
SET @See_Invisibility    := 40195;
SET @Invisibility        := 40194;
SET @CANNONBALL_STACK   := 185861;
-- Add class requirements for druid version of "Bombing Run"
UPDATE `quest_template` SET `RequiredClasses`=1024 WHERE `Id`=11102;
-- Add SAI support for Bombing Run Target Dummy
UPDATE `creature_template` SET `AIName`='SmartAI',`flags_extra`=`flags_extra`|128 WHERE `entry`=@Run_Dummy;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@Run_Dummy;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Run_Dummy;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=@Run_Dummy*100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Run_Dummy,0,0,1,8,0,100,0,@THROW_BOMB,0,1000,1000,33,@Run_Dummy,0,0,0,0,0,16,0,0,0,0,0,0,0, 'Run Target Dummy - On spell Throw Bomb hit - Give kill credit to invoker party'),
(@Run_Dummy,0,1,2,61,0,100,0,0,0,0,0,28,@RUN_MARK,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Run Target Dummy - Linked with previous event - Remove auras from hunter mark'),
(@Run_Dummy,0,2,3,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,20,@CANNONBALL_STACK,3,0,0,0,0,0, 'Run Target Dummy - Linked with previous event - Data set 0 1 on Cannonball Stack'),
(@Run_Dummy,0,3,4,61,0,100,0,0,0,0,0,45,0,1,0,0,0,0,19,@Explosion_Bunny,3,0,0,0,0,0, 'Run Target Dummy - Linked with previous event - Data set 0 1 on Explosion Bunny'),
(@Run_Dummy,0,4,0,61,0,100,0,0,0,0,0,80,@Run_Dummy*100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Run Target Dummy - Linked with previous event - Start script 0'),
(@Run_Dummy*100,9,0,0,0,0,100,0,29000,29000,0,0,11,@RUN_MARK,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Run Target Dummy - Action 0 - Cast run mark on self');
-- Add SAI for Cannonball Stack
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry`=@CANNONBALL_STACK;
DELETE FROM `smart_scripts` WHERE `source_type`=1 AND `entryorguid`=@CANNONBALL_STACK;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@CANNONBALL_STACK,1,0,0,38,0,100,0,0,1,0,0,70,30,0,0,0,0,0,1,0,0,0,0,0,0,0,' Cannonball Stack - On data set 0 1 - Respawn object /make it reappear after 30 secs/');
-- Add SAI support for Bombing Run Fel Cannon Dummy
UPDATE `creature_template` SET `AIName`='SmartAI',`unit_flags`=4,`flags_extra`=`flags_extra`|128 WHERE `entry`=@Fel_Cannon_Dummy;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Fel_Cannon_Dummy;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Fel_Cannon_Dummy,0,0,0,8,0,100,0,40110,0,4350,5000,11,40119,0,0,0,0,0,19,@Flak_Cannon,5,0,0,0,0,0, 'Fel Cannon Dummy - On spell hit by Cannon trigger - Cast Aggro Burst on Flak Cannon');
-- Add SAI support for Bombing Run Flak Cannon
UPDATE `creature_template` SET `AIName`='SmartAI',`unit_flags`=`unit_flags`|4|256|131072,`flags_extra`=`flags_extra`|2 WHERE `entry`=@Flak_Cannon;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Flak_Cannon;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Flak_Cannon,0,0,0,25,0,100,0,0,0,0,0,11,40111,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Flak Cannon - On reset - Cast The Aggro Bunnies'),
(@Flak_Cannon,0,1,2,8,0,100,0,41598,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Flak Cannon - On hit by Bolt Pair - Set orientation to invoker'),
(@Flak_Cannon,0,2,0,61,0,100,0,0,0,0,0,11,40109,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Flak Cannon - Linked with previous event - Cast spell The Bolt');
-- Add SAI support for Bombing Run Flak Cannon 2 /target bunny/
UPDATE `creature_template` SET `AIName`='SmartAI',`flags_extra`=`flags_extra`|128,`InhabitType`=4 WHERE `entry`=@Flak_Cannon2;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Flak_Cannon2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Flak_Cannon2,0,0,0,54,0,100,0,0,0,0,0,11,41598,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Flak Cannon 2 - On just summoned - Cast The Bolt Pair on invoker'),
(@Flak_Cannon2,0,1,2,8,0,100,0,40109,0,0,0,11,40075,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Flak Cannon 2 - On spell hit Cannon Bolt - Cast on self Fel Flak Fire'),
(@Flak_Cannon2,0,2,0,61,0,100,0,0,0,0,0,41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Flak Cannon 2 - Linked with previous event - Despawn in 5 sec');
-- Add SAI support for Explosion Bunny
UPDATE `creature_template` SET `AIName`='SmartAI',`flags_extra`=`flags_extra`|128,`unit_flags`=0 WHERE `entry`=@Explosion_Bunny;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@Explosion_Bunny;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@Explosion_Bunny,0,0,0,38,0,100,0,0,1,0,0,11,@EXPLOSION_VISUAL,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Explosion Bunny - On data set 0 1 - Cast Explosion Visual on self');
-- Add conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (@THROW_BOMB,40110,40112,40075);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry` IN (@THROW_BOMB,40200,41598,40111);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=@Fel_Cannon_Dummy;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`Comment`) VALUES
(17,0,@THROW_BOMB,0,29,0,@Run_Dummy,35,0,0,0,'Throw Bomb requires Run Target Dummy within 35y'),
(13,1,@THROW_BOMB,0,31,0,3,@Run_Dummy,0,0,0,'Throw Bomb implicit effect 0 can hit only Run Target Dummy'),
(13,1,@THROW_BOMB,0,1,0,@RUN_MARK,0,0,0,0,'Throw Bomb can hit only targets under the aura of 40196'),
(17,0,40200,0,9,0,11010,0,0,1,0,'To cast remove see invisibility player must not be on quest 11010'),
(17,0,40200,0,9,0,11102,0,0,1,0,'To cast remove see invisibility player must not be on quest 11102'),
(17,0,40200,0,9,0,11023,0,0,1,0,'To cast remove see invisibility player must not be on quest 11023'),
(13,1,40110,0,31,0,3,23077,0,0,0,'Cannon Trigger implicit targets can be only Fel Cannon Dummies'),
(13,1,40110,0,35,0,1,65,2,0,0,'Cannon Trigger implicit hit can happen only on targets under 65 yards range'),
(17,0,40111,0,29,0,@Fel_Cannon_Dummy,10,0,1,0,'The Aggro Bunnies caster should not be around Fel Cannon Dummies to cast'),
(13,1,40112,0,31,0,4,0,0,0,0,'Bombing Run Dummy aggro check can hit players'),
(13,3,40075,0,31,0,4,0,0,0,0,'Fel Flak Fire effect 2 can hit only players'),
(22,1,@Fel_Cannon_Dummy,0,1,1,40119,0,0,1,0,'Fel Cannon Dummy event 0 will happen only if target is missing aura from aggro burst');
-- Insert addon data
DELETE FROM `creature_template_addon` WHERE `entry` IN (@Run_Dummy,@Explosion_Bunny,@Fel_Cannon_Dummy);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@Run_Dummy,0,0,0,0,'40196 40194 40195'), -- Mark, See Invisibility, Invisibility
(@Explosion_Bunny,0,0,0,0,'40194 40195'), -- See Invisibility, Invisibility
(@Fel_Cannon_Dummy,0,0,0,0,'40113'); -- The Aggro Check Aura
-- Remove achievement from disabled
DELETE FROM `disables` WHERE `sourceType`=4 AND `entry`=3923;
-- Add missing spell from dbc
DELETE FROM `spell_dbc` WHERE `Id`=40200;
INSERT INTO `spell_dbc` (`Id`,`Dispel`,`Mechanic`,`Attributes`,`AttributesEx`,`AttributesEx2`,`AttributesEx3`,`AttributesEx4`,`AttributesEx5`,`AttributesEx6`,`AttributesEx7`,`Stances`,`StancesNot`,`Targets`,`CastingTimeIndex`,`AuraInterruptFlags`,`ProcFlags`,`ProcChance`,`ProcCharges`,`MaxLevel`,`BaseLevel`,`SpellLevel`,`DurationIndex`,`RangeIndex`,`StackAmount`,`EquippedItemClass`,`EquippedItemSubClassMask`,`EquippedItemInventoryTypeMask`,`Effect1`,`Effect2`,`Effect3`,`EffectDieSides1`,`EffectDieSides2`,`EffectDieSides3`,`EffectRealPointsPerLevel1`,`EffectRealPointsPerLevel2`,`EffectRealPointsPerLevel3`,`EffectBasePoints1`,`EffectBasePoints2`,`EffectBasePoints3`,`EffectMechanic1`,`EffectMechanic2`,`EffectMechanic3`,`EffectImplicitTargetA1`,`EffectImplicitTargetA2`,`EffectImplicitTargetA3`,`EffectImplicitTargetB1`,`EffectImplicitTargetB2`,`EffectImplicitTargetB3`,`EffectRadiusIndex1`,`EffectRadiusIndex2`,`EffectRadiusIndex3`,`EffectApplyAuraName1`,`EffectApplyAuraName2`,`EffectApplyAuraName3`,`EffectAmplitude1`,`EffectAmplitude2`,`EffectAmplitude3`,`EffectMultipleValue1`,`EffectMultipleValue2`,`EffectMultipleValue3`,`EffectMiscValue1`,`EffectMiscValue2`,`EffectMiscValue3`,`EffectMiscValueB1`,`EffectMiscValueB2`,`EffectMiscValueB3`,`EffectTriggerSpell1`,`EffectTriggerSpell2`,`EffectTriggerSpell3`,`EffectSpellClassMaskA1`,`EffectSpellClassMaskA2`,`EffectSpellClassMaskA3`,`EffectSpellClassMaskB1`,`EffectSpellClassMaskB2`,`EffectSpellClassMaskB3`,`EffectSpellClassMaskC1`,`EffectSpellClassMaskC2`,`EffectSpellClassMaskC3`,`MaxTargetLevel`,`SpellFamilyName`,`SpellFamilyFlags1`,`SpellFamilyFlags2`,`SpellFamilyFlags3`,`MaxAffectedTargets`,`DmgClass`,`PreventionType`,`DmgMultiplier1`,`DmgMultiplier2`,`DmgMultiplier3`,`AreaGroupId`,`SchoolMask`,`Comment`) VALUES
(40200,0,0,256,0,0,0,0,0,0,0,0,0,0,1,0,0,101,0,0,0,0,26,1,0,-1,0,0,164,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40195,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,'Bombing Run: See Invisibility Aura Remover');
-- Spell area - Check to cast remove aura /against see invisibility aura/, if having it and not on quest
DELETE FROM `spell_area` WHERE `spell`=40200;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_start_active`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`) VALUES
(40200,3522,0,0,0,@See_Invisibility,0,2,1);
-- Insert cannonballs spawns /based on sniffs/
SET @guid := 14811;
DELETE FROM `gameobject` WHERE `guid` BETWEEN @guid+0 AND @guid+13;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(@guid+0,@CANNONBALL_STACK,530,1,1,2825.11,7024.05,369.982,5.69617,0,0,0.289313,-0.957235,300,0,1),
(@guid+1,@CANNONBALL_STACK,530,1,1,2938.26,7094.72,369.413,2.78314,0,0,0.983982,0.178267,300,0,1),
(@guid+2,@CANNONBALL_STACK,530,1,1,2924.84,7031.46,367.857,4.26205,0,0,0.847134,-0.53138,300,0,1),
(@guid+3,@CANNONBALL_STACK,530,1,1,2938.02,7015.59,365.75,3.65778,0,0,0.966879,-0.255237,300,0,1),
(@guid+4,@CANNONBALL_STACK,530,1,1,2998.57,7043.55,368.539,5.91266,0,0,0.184206,-0.982888,300,0,1),
(@guid+5,@CANNONBALL_STACK,530,1,1,2982,7054.94,368.32,4.99766,0,0,0.599411,-0.800442,300,0,1),
(@guid+6,@CANNONBALL_STACK,530,1,1,2978.73,6889.19,369.701,0.689745,0,0,0.338077,0.941119,300,0,1),
(@guid+7,@CANNONBALL_STACK,530,1,1,2941.56,6827.17,367.3,4.08109,0,0,0.891683,-0.452661,300,0,1),
(@guid+8,@CANNONBALL_STACK,530,1,1,2953.55,6859.3,369.954,6.14433,0,0,0.0693712,-0.997591,300,0,1),
(@guid+9,@CANNONBALL_STACK,530,1,1,3023.13,6799.74,374.46,1.58666,0,0,0.712695,0.701474,300,0,1),
(@guid+10,@CANNONBALL_STACK,530,1,1,3028.3,6824.84,373.591,5.0275,0,0,0.587401,-0.809296,300,0,1),
(@guid+11,@CANNONBALL_STACK,530,1,1,3022.15,6859.05,369.546,3.44885,0,0,0.988222,-0.153025,300,0,1),
(@guid+12,@CANNONBALL_STACK,530,1,1,3016.28,6876.11,370.188,3.47791,0,0,0.985895,-0.167365,300,0,1),
(@guid+13,@CANNONBALL_STACK,530,1,1,2940.6,7106.65,370.123,0.88561,0,0,0.428475,0.903553,300,0,1);
-- Insert spawns for Fel Flak Cannons, Run Target Dummies and Explosion Bunnies /based on sniffs/
SET @guid := 85656;
DELETE FROM `creature` WHERE `guid` BETWEEN @guid+0 AND @guid+44;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`) VALUES
(@guid+0,23118,530,1,1,0,0,2764.71,7024.45,370.203,0,300,0,0,42,0,0,0,33554432,0),
(@guid+1,23119,530,1,1,0,0,2764.71,7024.45,370.203,0,300,0,0,6986,0,0,0,33554432,0),
(@guid+2,23118,530,1,1,0,0,2786.61,7036.28,370.686,0,300,0,0,42,0,0,0,33554432,0),
(@guid+3,23119,530,1,1,0,0,2786.61,7036.28,370.686,0,300,0,0,6986,0,0,0,33554432,0),
(@guid+4,23118,530,1,1,0,0,2824.71,7044.79,369.877,0,300,0,0,42,0,0,0,33554432,0),
(@guid+5,23119,530,1,1,0,0,2824.71,7044.79,369.877,0,300,0,0,6986,0,0,0,33554432,0),
(@guid+6,23076,530,1,1,0,0,2775.81,7030.75,370.337,1.85606,300,0,0,22140,0,0,0,0,0),
(@guid+7,23076,530,1,1,0,0,2933.28,7103.93,369.209,2.58129,300,0,0,21543,0,0,0,0,0),
(@guid+8,23119,530,1,1,0,0,2940.82,7107.17,370.115,4.65944,300,0,0,6986,0,0,0,33554432,0),
(@guid+9,23118,530,1,1,0,0,2940.82,7107.17,370.115,4.65944,300,0,0,42,0,0,0,33554432,0),
(@guid+10,23118,530,1,1,0,0,2825.11,7024.05,369.982,5.69617,300,0,0,42,0,0,0,33554432,0),
(@guid+11,23119,530,1,1,0,0,2825.11,7024.05,369.982,5.69617,300,0,0,6986,0,0,0,33554432,0),
(@guid+12,23076,530,1,1,0,0,2834.14,7018.43,368.459,5.42992,300,0,0,21543,0,0,0,0,0),
(@guid+13,23119,530,1,1,0,0,2938.84,7094.48,371.493,0.242375,300,0,0,6986,0,0,0,33554432,0),
(@guid+14,23118,530,1,1,0,0,2938.84,7094.48,371.493,0.242375,300,0,0,42,0,0,0,33554432,0),
(@guid+15,23076,530,1,1,0,0,2925.49,7021.72,367.007,3.59446,300,0,0,22140,0,0,0,0,0),
(@guid+16,23119,530,1,1,0,0,2924.84,7031.46,367.857,4.26205,300,0,0,6986,0,0,0,33554432,0),
(@guid+17,23118,530,1,1,0,0,2924.84,7031.46,367.857,4.26205,300,0,0,42,0,0,0,33554432,0),
(@guid+18,23119,530,1,1,0,0,2938.02,7015.59,366.54,3.65778,300,0,0,6986,0,0,0,33554432,0),
(@guid+19,23118,530,1,1,0,0,2938.02,7015.59,366.54,3.65778,300,0,0,42,0,0,0,33554432,0),
(@guid+20,23076,530,1,1,0,0,2994.48,7039.91,369.42,5.26077,300,0,0,22140,0,0,0,0,0),
(@guid+21,23119,530,1,1,0,0,2998.57,7043.55,368.539,5.91266,300,0,0,6986,0,0,0,33554432,0),
(@guid+22,23118,530,1,1,0,0,2998.57,7043.55,368.539,5.91266,300,0,0,42,0,0,0,33554432,0),
(@guid+23,23119,530,1,1,0,0,2982,7054.94,368.82,4.99766,300,0,0,6986,0,0,0,33554432,0),
(@guid+24,23118,530,1,1,0,0,2982,7054.94,368.82,4.99766,300,0,0,42,0,0,0,33554432,0),
(@guid+25,23076,530,1,1,0,0,2982.59,6886.5,370.082,0.831123,300,0,0,22140,0,0,0,0,0),
(@guid+26,23118,530,1,1,0,0,2978.74,6889.12,371.288,0.897875,300,0,0,42,0,0,0,33554432,0),
(@guid+27,23119,530,1,1,0,0,2978.74,6889.12,371.288,0.897875,300,0,0,6986,0,0,0,33554432,0),
(@guid+28,23118,530,1,1,0,0,2941.56,6827.17,367.3,4.54054,300,0,0,42,0,0,0,33554432,0),
(@guid+29,23119,530,1,1,0,0,2941.56,6827.17,367.3,4.54054,300,0,0,6986,0,0,0,33554432,0),
(@guid+30,23076,530,1,1,0,0,2938.19,6818.01,366.959,3.31926,300,0,0,21543,0,0,0,0,0),
(@guid+31,23076,530,1,1,0,0,2946.3,6875.71,370.04,3.2148,300,0,0,22140,0,0,0,0,0),
(@guid+32,23118,530,1,1,0,0,2953.55,6859.3,369.954,6.14433,300,0,0,42,0,0,0,33554432,0),
(@guid+33,23119,530,1,1,0,0,2953.55,6859.3,369.954,6.14433,300,0,0,6986,0,0,0,33554432,0),
(@guid+34,23119,530,1,1,0,0,3023.13,6799.74,374.46,1.58666,300,0,0,6986,0,0,0,33554432,0),
(@guid+35,23118,530,1,1,0,0,3023.13,6799.74,374.46,1.58666,300,0,0,42,0,0,0,33554432,0),
(@guid+36,23076,530,1,1,0,0,3028.22,6807.09,374.075,5.94641,300,0,0,22140,0,0,0,0,0),
(@guid+37,23118,530,1,1,0,0,3028.3,6824.84,373.591,5.0275,300,0,0,42,0,0,0,33554432,0),
(@guid+38,23119,530,1,1,0,0,3028.3,6824.84,373.591,5.0275,300,0,0,6986,0,0,0,33554432,0),
(@guid+39,23119,530,1,1,0,0,3022.15,6859.05,369.546,3.44885,300,0,0,6986,0,0,0,33554432,0),
(@guid+40,23118,530,1,1,0,0,3022.15,6859.05,369.546,3.44885,300,0,0,42,0,0,0,33554432,0),
(@guid+41,23076,530,1,1,0,0,3022.21,6864.61,369.93,0.100696,300,0,0,22140,0,0,0,0,0),
(@guid+42,23118,530,1,1,0,0,3016.28,6876.11,370.188,3.47791,300,0,0,42,0,0,0,33554432,0),
(@guid+43,23119,530,1,1,0,0,3016.28,6876.11,370.188,3.47791,300,0,0,6986,0,0,0,33554432,0),
(@guid+44,23076,530,1,1,0,0,2816.74,7057.61,369.779,1.4555,300,0,0,21543,0,0,0,0,0);
 
-- TrinityCore\sql\updates\world\2012_09_13_01_world_spell_script_name.sql 
-- Add spell script name for Fires Over Skettis and Bombing Run quests
DELETE FROM `spell_script_names` WHERE `spell_id`=40113;
DELETE FROM `spell_script_names` WHERE `spell_id`=40160;
DELETE FROM `spell_script_names` WHERE `spell_id`=39844;
DELETE FROM `spell_script_names` WHERE `spell_id`=40056;
DELETE FROM `spell_script_names` WHERE `spell_id`=40112;
DELETE FROM `spell_script_names` WHERE `spell_id`=40119;
INSERT INTO `spell_script_names` VALUES
(39844,'spell_q11010_q11102_q11023_q11008_check_fly_mount'),
(40160,'spell_q11010_q11102_q11023_q11008_check_fly_mount'),
(40113,'spell_q11010_q11102_q11023_aggro_check_aura'),
(40056,'spell_q11010_q11102_q11023_choose_loc'),
(40112,'spell_q11010_q11102_q11023_aggro_check'),
(40119,'spell_q11010_q11102_q11023_aggro_burst');
 
-- TrinityCore\sql\updates\world\2012_09_13_01_world_spell_target_position.sql 
DELETE FROM `spell_target_position` WHERE `id` IN (60323,60324,60325,60326,60327,60328,60329,60330,60331,60332,60333,60334,60335);
INSERT INTO `spell_target_position` (`id`, `target_map`, `target_position_x`, `target_position_y`, `target_position_z`, `target_orientation`) VALUES
(60323,0,-5506.339,-704.348,392.686,0.595), -- Steelgrills Depot
(60324,0,-9470.760,3.909,49.794,4.802), -- Lions Pride Inn, Goldshire
(60325,1,-3721.306,-4411.906,25.247,0.831), -- Theramore isle, Dustwallow Marsh
(60326,0,286.314,-2184.086,122.612,2.271), -- Aerie Peak, The Hinterlands
(60327,1,6395.708,433.256,33.260,0.566), -- Auberdine, Darkshore
(60328,0,-14412.923,692.017,22.248,1.231), -- Boote Bay
(60329,1,-7135.717,-3787.769,8.799,5.992), -- Tanaris, Gadgetzan
(60330,0,-10336.138,-2934.057,116.723,4.523), -- Swamp of Sorrows, Z coord is intended
(60331,0,-10446.900,-3261.909,20.179,5.875), -- Stonard, Swamp of Sorrows
(60332,0,-103.988,-902.795,55.534,5.924), -- Tarren Mill, Hillsbrad Foothils
(60333,0,1804.836,196.322,70.399,1.572), -- Undercity
(60334,1,-1060.266,23.137,141.455,5.967), -- Thunder Bluff
(60335,1,-506.224,-2590.084,113.150,2.445); -- Barrens, The Crossroads
 
-- TrinityCore\sql\updates\world\2012_09_13_02_world_trinity_string.sql 
DELETE FROM `command` WHERE `name` = 'cheat status';
INSERT INTO `command` (`name`, `security`, `help`) VALUES
('cheat status', 2, 'Syntax: .cheat status \n\nShows the cheats you currently have enabled.');

DELETE FROM `trinity_string` WHERE `entry` BETWEEN 357 AND 362;
INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(357, 'Cheat Command Status:'),
(358, 'Godmode: %s.'),
(359, 'Casttime: %s.'),
(360, 'Cooldown: %s.'),
(361, 'Power: %s.'),
(362, 'Waterwalk: %s.');
 
-- TrinityCore\sql\updates\world\2012_09_14_00_world_creature_template.sql 
UPDATE `creature_template` SET `lootid`=18604 WHERE `entry`=17400;
UPDATE `creature_template` SET `lootid`=18605 WHERE `entry`=17401;
UPDATE `creature_template` SET `lootid`=19884 WHERE `entry`=17816;
UPDATE `creature_template` SET `lootid`=19885 WHERE `entry`=17957;
UPDATE `creature_template` SET `lootid`=19886 WHERE `entry`=17958;
UPDATE `creature_template` SET `lootid`=19887 WHERE `entry`=17961;
UPDATE `creature_template` SET `lootid`=19888 WHERE `entry`=17938;
UPDATE `creature_template` SET `lootid`=19889 WHERE `entry`=17959;
UPDATE `creature_template` SET `lootid`=19890 WHERE `entry`=17960;
UPDATE `creature_template` SET `lootid`=19891 WHERE `entry`=17940;
UPDATE `creature_template` SET `lootid`=19892 WHERE `entry`=17817;
UPDATE `creature_template` SET `lootid`=19902 WHERE `entry`=17963;
UPDATE `creature_template` SET `lootid`=19903 WHERE `entry`=17962;
UPDATE `creature_template` SET `lootid`=19904 WHERE `entry`=17964;
UPDATE `creature_template` SET `lootid`=20164 WHERE `entry`=17723;
UPDATE `creature_template` SET `lootid`=20173 WHERE `entry`=17731;
UPDATE `creature_template` SET `lootid`=20174 WHERE `entry`=19632;
UPDATE `creature_template` SET `lootid`=20175 WHERE `entry`=17732;
UPDATE `creature_template` SET `lootid`=20177 WHERE `entry`=17730;
UPDATE `creature_template` SET `lootid`=20179 WHERE `entry`=17771;
UPDATE `creature_template` SET `lootid`=20180 WHERE `entry`=17729;
UPDATE `creature_template` SET `lootid`=20181 WHERE `entry`=17728;
UPDATE `creature_template` SET `lootid`=20185 WHERE `entry`=17724;
UPDATE `creature_template` SET `lootid`=20187 WHERE `entry`=17734;
UPDATE `creature_template` SET `lootid`=20188 WHERE `entry`=17725;
UPDATE `creature_template` SET `lootid`=20190 WHERE `entry`=17871;
UPDATE `creature_template` SET `lootid`=20191 WHERE `entry`=17726;
UPDATE `creature_template` SET `lootid`=20192 WHERE `entry`=17727;
UPDATE `creature_template` SET `lootid`=20193 WHERE `entry`=17735;
UPDATE `creature_template` SET `lootid`=20255 WHERE `entry`=18311;
UPDATE `creature_template` SET `lootid`=20256 WHERE `entry`=18331;
UPDATE `creature_template` SET `lootid`=20257 WHERE `entry`=18317;
UPDATE `creature_template` SET `lootid`=20258 WHERE `entry`=18309;
UPDATE `creature_template` SET `lootid`=20259 WHERE `entry`=18313;
UPDATE `creature_template` SET `lootid`=20260 WHERE `entry`=18312;
UPDATE `creature_template` SET `lootid`=20261 WHERE `entry`=18315;
UPDATE `creature_template` SET `lootid`=20263 WHERE `entry`=19306;
UPDATE `creature_template` SET `lootid`=20264 WHERE `entry`=18314;
UPDATE `creature_template` SET `lootid`=20265 WHERE `entry`=19307;
UPDATE `creature_template` SET `lootid`=20298 WHERE `entry`=18524;
UPDATE `creature_template` SET `lootid`=20299 WHERE `entry`=18497;
UPDATE `creature_template` SET `lootid`=20300 WHERE `entry`=18702;
UPDATE `creature_template` SET `lootid`=20301 WHERE `entry`=18493;
UPDATE `creature_template` SET `lootid`=20302 WHERE `entry`=18495;
UPDATE `creature_template` SET `lootid`=20309 WHERE `entry`=18503;
UPDATE `creature_template` SET `lootid`=20310 WHERE `entry`=18557;
UPDATE `creature_template` SET `lootid`=20311 WHERE `entry`=18556;
UPDATE `creature_template` SET `lootid`=20312 WHERE `entry`=18558;
UPDATE `creature_template` SET `lootid`=20313 WHERE `entry`=18559;
UPDATE `creature_template` SET `lootid`=20315 WHERE `entry`=18521;
UPDATE `creature_template` SET `lootid`=20320 WHERE `entry`=18500;
UPDATE `creature_template` SET `lootid`=20321 WHERE `entry`=18498;
UPDATE `creature_template` SET `lootid`=20322 WHERE `entry`=18499;
UPDATE `creature_template` SET `lootid`=20323 WHERE `entry`=18501;
UPDATE `creature_template` SET `lootid`=20525 WHERE `entry`=18934;
UPDATE `creature_template` SET `lootid`=20526 WHERE `entry`=17820;
UPDATE `creature_template` SET `lootid`=20527 WHERE `entry`=17819;
UPDATE `creature_template` SET `lootid`=20528 WHERE `entry`=17840;
UPDATE `creature_template` SET `lootid`=20529 WHERE `entry`=17860;
UPDATE `creature_template` SET `lootid`=20530 WHERE `entry`=17833;
UPDATE `creature_template` SET `lootid`=20532 WHERE `entry`=18171;
UPDATE `creature_template` SET `lootid`=20533 WHERE `entry`=18172;
UPDATE `creature_template` SET `lootid`=20534 WHERE `entry`=18170;
UPDATE `creature_template` SET `lootid`=20537 WHERE `entry`=17815;
UPDATE `creature_template` SET `lootid`=20538 WHERE `entry`=17814;
UPDATE `creature_template` SET `lootid`=20543 WHERE `entry`=17846;
UPDATE `creature_template` SET `lootid`=20545 WHERE `entry`=18092;
UPDATE `creature_template` SET `lootid`=20546 WHERE `entry`=18094;
UPDATE `creature_template` SET `lootid`=20547 WHERE `entry`=18093;
UPDATE `creature_template` SET `lootid`=20620 WHERE `entry`=17721;
UPDATE `creature_template` SET `lootid`=20621 WHERE `entry`=17800;
UPDATE `creature_template` SET `lootid`=20622 WHERE `entry`=17803;
UPDATE `creature_template` SET `lootid`=20623 WHERE `entry`=17801;
UPDATE `creature_template` SET `lootid`=20624 WHERE `entry`=17805;
UPDATE `creature_template` SET `lootid`=20625 WHERE `entry`=17722;
UPDATE `creature_template` SET `lootid`=20626 WHERE `entry`=17802;
UPDATE `creature_template` SET `lootid`=20627 WHERE `entry`=17917;
UPDATE `creature_template` SET `lootid`=20628 WHERE `entry`=17799;
UPDATE `creature_template` SET `lootid`=20638 WHERE `entry`=18633;
UPDATE `creature_template` SET `lootid`=20639 WHERE `entry`=18636;
UPDATE `creature_template` SET `lootid`=20640 WHERE `entry`=18631;
UPDATE `creature_template` SET `lootid`=20641 WHERE `entry`=18635;
UPDATE `creature_template` SET `lootid`=20642 WHERE `entry`=18632;
UPDATE `creature_template` SET `lootid`=20643 WHERE `entry`=18641;
UPDATE `creature_template` SET `lootid`=20644 WHERE `entry`=18830;
UPDATE `creature_template` SET `lootid`=20645 WHERE `entry`=18794;
UPDATE `creature_template` SET `lootid`=20646 WHERE `entry`=18637;
UPDATE `creature_template` SET `lootid`=20647 WHERE `entry`=18639;
UPDATE `creature_template` SET `lootid`=20648 WHERE `entry`=18634;
UPDATE `creature_template` SET `lootid`=20649 WHERE `entry`=18640;
UPDATE `creature_template` SET `lootid`=20650 WHERE `entry`=18638;
UPDATE `creature_template` SET `lootid`=20651 WHERE `entry`=18642;
UPDATE `creature_template` SET `lootid`=20652 WHERE `entry`=18796;
UPDATE `creature_template` SET `lootid`=20655 WHERE `entry`=18663;
UPDATE `creature_template` SET `lootid`=20656 WHERE `entry`=18848;
UPDATE `creature_template` SET `lootid`=20660 WHERE `entry`=19208;
UPDATE `creature_template` SET `lootid`=20661 WHERE `entry`=19209;
UPDATE `creature_template` SET `lootid`=20686 WHERE `entry`=19429;
UPDATE `creature_template` SET `lootid`=20688 WHERE `entry`=19428;
UPDATE `creature_template` SET `lootid`=20691 WHERE `entry`=18327;
UPDATE `creature_template` SET `lootid`=20692 WHERE `entry`=18323;
UPDATE `creature_template` SET `lootid`=20693 WHERE `entry`=18318;
UPDATE `creature_template` SET `lootid`=20694 WHERE `entry`=18328;
UPDATE `creature_template` SET `lootid`=20695 WHERE `entry`=18325;
UPDATE `creature_template` SET `lootid`=20696 WHERE `entry`=18322;
UPDATE `creature_template` SET `lootid`=20697 WHERE `entry`=18319;
UPDATE `creature_template` SET `lootid`=20698 WHERE `entry`=18320;
UPDATE `creature_template` SET `lootid`=20699 WHERE `entry`=18326;
UPDATE `creature_template` SET `lootid`=20701 WHERE `entry`=18321;
UPDATE `creature_template` SET `lootid`=20993 WHERE `entry`=20923;
UPDATE `creature_template` SET `lootid`=21522 WHERE `entry`=19510;
UPDATE `creature_template` SET `lootid`=21523 WHERE `entry`=20990;
UPDATE `creature_template` SET `lootid`=21524 WHERE `entry`=19167;
UPDATE `creature_template` SET `lootid`=21527 WHERE `entry`=19231;
UPDATE `creature_template` SET `lootid`=21528 WHERE `entry`=19712;
UPDATE `creature_template` SET `lootid`=21531 WHERE `entry`=19716;
UPDATE `creature_template` SET `lootid`=21532 WHERE `entry`=19713;
UPDATE `creature_template` SET `lootid`=21539 WHERE `entry`=19168;
UPDATE `creature_template` SET `lootid`=21540 WHERE `entry`=20988;
UPDATE `creature_template` SET `lootid`=21541 WHERE `entry`=20059;
UPDATE `creature_template` SET `lootid`=21542 WHERE `entry`=19735;
UPDATE `creature_template` SET `lootid`=21543 WHERE `entry`=19166;
UPDATE `creature_template` SET `lootid`=21585 WHERE `entry`=20857;
UPDATE `creature_template` SET `lootid`=21586 WHERE `entry`=20869;
UPDATE `creature_template` SET `lootid`=21587 WHERE `entry`=20859;
UPDATE `creature_template` SET `lootid`=21588 WHERE `entry`=20911;
UPDATE `creature_template` SET `lootid`=21589 WHERE `entry`=20905;
UPDATE `creature_template` SET `lootid`=21591 WHERE `entry`=20867;
UPDATE `creature_template` SET `lootid`=21593 WHERE `entry`=20868;
UPDATE `creature_template` SET `lootid`=21594 WHERE `entry`=20880;
UPDATE `creature_template` SET `lootid`=21595 WHERE `entry`=20879;
UPDATE `creature_template` SET `lootid`=21596 WHERE `entry`=20896;
UPDATE `creature_template` SET `lootid`=21597 WHERE `entry`=20897;
UPDATE `creature_template` SET `lootid`=21598 WHERE `entry`=20898;
UPDATE `creature_template` SET `lootid`=21601 WHERE `entry`=20912;
UPDATE `creature_template` SET `lootid`=21604 WHERE `entry`=20875;
UPDATE `creature_template` SET `lootid`=21605 WHERE `entry`=20873;
UPDATE `creature_template` SET `lootid`=21606 WHERE `entry`=20906;
UPDATE `creature_template` SET `lootid`=21607 WHERE `entry`=20865;
UPDATE `creature_template` SET `lootid`=21608 WHERE `entry`=20864;
UPDATE `creature_template` SET `lootid`=21610 WHERE `entry`=20901;
UPDATE `creature_template` SET `lootid`=21611 WHERE `entry`=20902;
UPDATE `creature_template` SET `lootid`=21613 WHERE `entry`=20882;
UPDATE `creature_template` SET `lootid`=21614 WHERE `entry`=20866;
UPDATE `creature_template` SET `lootid`=21615 WHERE `entry`=20883;
UPDATE `creature_template` SET `lootid`=21616 WHERE `entry`=20909;
UPDATE `creature_template` SET `lootid`=21617 WHERE `entry`=20908;
UPDATE `creature_template` SET `lootid`=21618 WHERE `entry`=20910;
UPDATE `creature_template` SET `lootid`=21619 WHERE `entry`=20881;
UPDATE `creature_template` SET `lootid`=21621 WHERE `entry`=20900;
UPDATE `creature_template` SET `lootid`=21842 WHERE `entry`=21126;
UPDATE `creature_template` SET `lootid`=21843 WHERE `entry`=21127;
UPDATE `creature_template` SET `lootid`=21914 WHERE `entry`=21694;
UPDATE `creature_template` SET `lootid`=21916 WHERE `entry`=21696;
UPDATE `creature_template` SET `lootid`=21917 WHERE `entry`=21695;
UPDATE `creature_template` SET `lootid`=21989 WHERE `entry`=21891;
UPDATE `creature_template` SET `lootid`=21990 WHERE `entry`=21904;
UPDATE `creature_template` SET `lootid`=22129 WHERE `entry`=22128;
UPDATE `creature_template` SET `lootid`=22162 WHERE `entry`=18983;
UPDATE `creature_template` SET `lootid`=22163 WHERE `entry`=17952;
UPDATE `creature_template` SET `lootid`=22173 WHERE `entry`=18982;
UPDATE `creature_template` SET `lootid`=22346 WHERE `entry`=21702;
UPDATE `creature_template` SET `lootid`=22530 WHERE `entry`=13536;
UPDATE `creature_template` SET `lootid`=22532 WHERE `entry`=13539;
UPDATE `creature_template` SET `lootid`=22533 WHERE `entry`=13424;
UPDATE `creature_template` SET `lootid`=22534 WHERE `entry`=13542;
UPDATE `creature_template` SET `lootid`=22535 WHERE `entry`=13554;
UPDATE `creature_template` SET `lootid`=22536 WHERE `entry`=13545;
UPDATE `creature_template` SET `lootid`=22537 WHERE `entry`=13557;
UPDATE `creature_template` SET `lootid`=22538 WHERE `entry`=13425;
UPDATE `creature_template` SET `lootid`=22539 WHERE `entry`=13155;
UPDATE `creature_template` SET `lootid`=22543 WHERE `entry`=14770;
UPDATE `creature_template` SET `lootid`=22547 WHERE `entry`=14768;
UPDATE `creature_template` SET `lootid`=22550 WHERE `entry`=13378;
UPDATE `creature_template` SET `lootid`=22555 WHERE `entry`=603;
UPDATE `creature_template` SET `lootid`=22565 WHERE `entry`=13377;
UPDATE `creature_template` SET `lootid`=22576 WHERE `entry`=13416;
UPDATE `creature_template` SET `lootid`=22578 WHERE `entry`=13151;
UPDATE `creature_template` SET `lootid`=22579 WHERE `entry`=14767;
UPDATE `creature_template` SET `lootid`=22587 WHERE `entry`=13526;
UPDATE `creature_template` SET `lootid`=22592 WHERE `entry`=13530;
UPDATE `creature_template` SET `lootid`=22595 WHERE `entry`=14769;
UPDATE `creature_template` SET `lootid`=22607 WHERE `entry`=13527;
UPDATE `creature_template` SET `lootid`=22612 WHERE `entry`=13531;
UPDATE `creature_template` SET `lootid`=22613 WHERE `entry`=13140;
UPDATE `creature_template` SET `lootid`=22614 WHERE `entry`=13319;
UPDATE `creature_template` SET `lootid`=22615 WHERE `entry`=13320;
UPDATE `creature_template` SET `lootid`=22616 WHERE `entry`=13154;
UPDATE `creature_template` SET `lootid`=22617 WHERE `entry`=13152;
UPDATE `creature_template` SET `lootid`=22618 WHERE `entry`=13318;
UPDATE `creature_template` SET `lootid`=22619 WHERE `entry`=13153;
UPDATE `creature_template` SET `lootid`=22620 WHERE `entry`=13139;
UPDATE `creature_template` SET `lootid`=22621 WHERE `entry`=13446;
UPDATE `creature_template` SET `lootid`=22623 WHERE `entry`=13597;
UPDATE `creature_template` SET `lootid`=22624 WHERE `entry`=13357;
UPDATE `creature_template` SET `lootid`=22628 WHERE `entry`=13841;
UPDATE `creature_template` SET `lootid`=22634 WHERE `entry`=13598;
UPDATE `creature_template` SET `lootid`=22635 WHERE `entry`=13356;
UPDATE `creature_template` SET `lootid`=22639 WHERE `entry`=13449;
UPDATE `creature_template` SET `lootid`=22640 WHERE `entry`=13840;
UPDATE `creature_template` SET `lootid`=22645 WHERE `entry`=12048;
UPDATE `creature_template` SET `lootid`=22649 WHERE `entry`=12052;
UPDATE `creature_template` SET `lootid`=22657 WHERE `entry`=12047;
UPDATE `creature_template` SET `lootid`=22662 WHERE `entry`=13325;
UPDATE `creature_template` SET `lootid`=22663 WHERE `entry`=13327;
UPDATE `creature_template` SET `lootid`=22664 WHERE `entry`=13330;
UPDATE `creature_template` SET `lootid`=22667 WHERE `entry`=13335;
UPDATE `creature_template` SET `lootid`=22668 WHERE `entry`=13336;
UPDATE `creature_template` SET `lootid`=22669 WHERE `entry`=13337;
UPDATE `creature_template` SET `lootid`=22671 WHERE `entry`=13426;
UPDATE `creature_template` SET `lootid`=22672 WHERE `entry`=13427;
UPDATE `creature_template` SET `lootid`=22673 WHERE `entry`=13428;
UPDATE `creature_template` SET `lootid`=22676 WHERE `entry`=13528;
UPDATE `creature_template` SET `lootid`=22679 WHERE `entry`=13440;
UPDATE `creature_template` SET `lootid`=22687 WHERE `entry`=13324;
UPDATE `creature_template` SET `lootid`=22688 WHERE `entry`=13329;
UPDATE `creature_template` SET `lootid`=22689 WHERE `entry`=13524;
UPDATE `creature_template` SET `lootid`=22691 WHERE `entry`=13576;
UPDATE `creature_template` SET `lootid`=22700 WHERE `entry`=13298;
UPDATE `creature_template` SET `lootid`=22701 WHERE `entry`=13145;
UPDATE `creature_template` SET `lootid`=22702 WHERE `entry`=13296;
UPDATE `creature_template` SET `lootid`=22703 WHERE `entry`=13147;
UPDATE `creature_template` SET `lootid`=22704 WHERE `entry`=13299;
UPDATE `creature_template` SET `lootid`=22705 WHERE `entry`=13300;
UPDATE `creature_template` SET `lootid`=22706 WHERE `entry`=13146;
UPDATE `creature_template` SET `lootid`=22707 WHERE `entry`=13137;
UPDATE `creature_template` SET `lootid`=22708 WHERE `entry`=13138;
UPDATE `creature_template` SET `lootid`=22709 WHERE `entry`=13297;
UPDATE `creature_template` SET `lootid`=22710 WHERE `entry`=13143;
UPDATE `creature_template` SET `lootid`=22711 WHERE `entry`=13144;
UPDATE `creature_template` SET `lootid`=22713 WHERE `entry`=13525;
UPDATE `creature_template` SET `lootid`=22718 WHERE `entry`=13529;
UPDATE `creature_template` SET `lootid`=22719 WHERE `entry`=13333;
UPDATE `creature_template` SET `lootid`=22725 WHERE `entry`=10984;
UPDATE `creature_template` SET `lootid`=22736 WHERE `entry`=13776;
UPDATE `creature_template` SET `lootid`=22754 WHERE `entry`=13537;
UPDATE `creature_template` SET `lootid`=22759 WHERE `entry`=13777;
UPDATE `creature_template` SET `lootid`=22764 WHERE `entry`=13676;
UPDATE `creature_template` SET `lootid`=22765 WHERE `entry`=13618;
UPDATE `creature_template` SET `lootid`=22768 WHERE `entry`=13150;
UPDATE `creature_template` SET `lootid`=22769 WHERE `entry`=13149;
UPDATE `creature_template` SET `lootid`=22774 WHERE `entry`=13541;
UPDATE `creature_template` SET `lootid`=22776 WHERE `entry`=13544;
UPDATE `creature_template` SET `lootid`=22788 WHERE `entry`=12156;
UPDATE `creature_template` SET `lootid`=22789 WHERE `entry`=12158;
UPDATE `creature_template` SET `lootid`=22790 WHERE `entry`=13956;
UPDATE `creature_template` SET `lootid`=22791 WHERE `entry`=13958;
UPDATE `creature_template` SET `lootid`=22792 WHERE `entry`=12157;
UPDATE `creature_template` SET `lootid`=22794 WHERE `entry`=10983;
UPDATE `creature_template` SET `lootid`=22795 WHERE `entry`=13957;
UPDATE `creature_template` SET `lootid`=22796 WHERE `entry`=11679;
UPDATE `creature_template` SET `lootid`=25548 WHERE `entry`=24976;
UPDATE `creature_template` SET `lootid`=25551 WHERE `entry`=24698;
UPDATE `creature_template` SET `lootid`=29274 WHERE `entry`=16506;
UPDATE `creature_template` SET `lootid`=29833 WHERE `entry`=16156;
UPDATE `creature_template` SET `lootid`=30759 WHERE `entry`=22262;
UPDATE `creature_template` SET `lootid`=30760 WHERE `entry`=22261;
UPDATE `creature_template` SET `lootid`=30761 WHERE `entry`=22263;
UPDATE `creature_template` SET `lootid`=30763 WHERE `entry`=23174;
UPDATE `creature_template` SET `lootid`=30773 WHERE `entry`=23386;
UPDATE `creature_template` SET `lootid`=30822 WHERE `entry`=26690;
UPDATE `creature_template` SET `lootid`=30823 WHERE `entry`=26691;
UPDATE `creature_template` SET `lootid`=31178 WHERE `entry`=27729;
UPDATE `creature_template` SET `lootid`=31179 WHERE `entry`=28249;
UPDATE `creature_template` SET `lootid`=31180 WHERE `entry`=27732;
UPDATE `creature_template` SET `lootid`=31184 WHERE `entry`=28200;
UPDATE `creature_template` SET `lootid`=31187 WHERE `entry`=27734;
UPDATE `creature_template` SET `lootid`=31188 WHERE `entry`=28199;
UPDATE `creature_template` SET `lootid`=31199 WHERE `entry`=27736;
UPDATE `creature_template` SET `lootid`=31200 WHERE `entry`=28201;
UPDATE `creature_template` SET `lootid`=31201 WHERE `entry`=27731;
UPDATE `creature_template` SET `lootid`=31202 WHERE `entry`=27742;
UPDATE `creature_template` SET `lootid`=31203 WHERE `entry`=27744;
UPDATE `creature_template` SET `lootid`=31206 WHERE `entry`=27743;
UPDATE `creature_template` SET `lootid`=33391 WHERE `entry`=32915;
UPDATE `creature_template` SET `lootid`=33773 WHERE `entry`=33772;
UPDATE `creature_template` SET `lootid`=34106 WHERE `entry`=33432;
UPDATE `creature_template` SET `lootid`=34108 WHERE `entry`=33651;
UPDATE `creature_template` SET `lootid`=35306 WHERE `entry`=35305;
UPDATE `creature_template` SET `lootid`=35308 WHERE `entry`=35307;
UPDATE `creature_template` SET `lootid`=35310 WHERE `entry`=35309;
UPDATE `creature_template` SET `lootid`=35359 WHERE `entry`=35143;
UPDATE `creature_template` SET `lootid`=38151 WHERE `entry`=37532;
UPDATE `creature_template` SET `lootid`=39805 WHERE `entry`=39946;
UPDATE `creature_template` SET `lootid`=39823 WHERE `entry`=39948;
UPDATE `creature_template` SET `lootid`=39920 WHERE `entry`=39947;
UPDATE `creature_template` SET `lootid`=40420 WHERE `entry`=40419;
 
-- TrinityCore\sql\updates\world\2012_09_14_00_world_sai.sql 
UPDATE `smart_scripts` SET `event_param1` = 35282, `action_param1` = 256, `comment` = 'Scrapped Fel Reaver - On Spellhit - Remove - OOC Not attackable - flags'  WHERE `entryorguid` = 20243;
 
-- TrinityCore\sql\updates\world\2012_09_14_01_world_creature_loot_template.sql 
DELETE FROM `creature_loot_template` WHERE `entry` = 37126;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(37126, 49426, 100, 1, 0, 1, 1),
(37126, 1, 100, 1, 0, -100002, 1);
UPDATE `creature_template` SET `lootid` = 37126 WHERE `entry` IN (37126,38258);
 
-- TrinityCore\sql\updates\world\2012_09_15_00_world_achievement_criteria_data.sql 
-- Insert achievement instance criteria data scripts
DELETE FROM `achievement_criteria_data` WHERE `type`=11 and `criteria_id` IN (7323,7324,7325);
INSERT INTO `achievement_criteria_data` (`criteria_id`, `type`, `value1`, `value2`, `ScriptName`) VALUES
(7323,11,0,0,'achievement_ruby_void'),
(7324,11,0,0,'achievement_emerald_void'),
(7325,11,0,0,'achievement_amber_void');
 
-- TrinityCore\sql\updates\world\2012_09_15_00_world_creature_template.sql 
UPDATE `creature_template` SET `lootid`=`entry` WHERE `entry` IN (17400,17401,17816,17957,17958,17961,17938,17959,17960,17940,17817,17963,17962,17964,17723,17731,19632,17732,17730,17771,17729,17728,17724,17734,17725,17871,17726,17727,17735,18311,18331,18317,18309,18313,18312,18315,19306,18314,19307,18524,18497,18702,18493,18495,18503,18557,18556,18558,18559,18521,18500,18498,18499,18501,18934,17820,17819,17840,17860,17833,18171,18172,18170,17815,17814,17846,18092,18094,18093,17721,17800,17803,17801,17805,17722,17802,17917,17799,18633,18636,18631,18635,18632,18641,18830,18794,18637,18639,18634,18640,18638,18642,18796,18663,18848,19208,19209,19429,19428,18327,18323,18318,18328,18325,18322,18319,18320,18326,18321,20923,19510,20990,19167,19231,19712,19716,19713,19168,20988,20059,19735,19166,20857,20869,20859,20911,20905,20867,20868,20880,20879,20896,20897,20898,20912,20875,20873,20906,20865,20864,20901,20902,20882,20866,20883,20909,20908,20910,20881,20900,21126,21127,21694,21696,21695,21891,21904,22128,18983,17952,18982,21702,13536,13539,13424,13542,13554,13545,13557,13425,13155,14770,14768,13378,603,13377,13416,13151,14767,13526,13530,14769,13527,13531,13140,13319,13320,13154,13152,13318,13153,13139,13446,13597,13357,13841,13598,13356,13449,13840,12048,12052,12047,13325,13327,13330,13335,13336,13337,13426,13427,13428,13528,13440,13324,13329,13524,13576,13298,13145,13296,13147,13299,13300,13146,13137,13138,13297,13143,13144,13525,13529,13333,10984,13776,13537,13777,13676,13618,13150,13149,13541,13544,12156,12158,13956,13958,12157,10983,13957,11679,24976,24698,16506,16156,22262,22261,22263,23174,23386,26690,26691,27729,28249,27732,28200,27734,28199,27736,28201,27731,27742,27744,27743,32915,33772,33432,33651,35305,35307,35309,35143,37532,39946,39948,39947,40419);
UPDATE `creature_template` SET `lootid`=17400 WHERE `entry`=18604;
UPDATE `creature_template` SET `lootid`=17401 WHERE `entry`=18605;
UPDATE `creature_template` SET `lootid`=17816 WHERE `entry`=19884;
UPDATE `creature_template` SET `lootid`=17957 WHERE `entry`=19885;
UPDATE `creature_template` SET `lootid`=17958 WHERE `entry`=19886;
UPDATE `creature_template` SET `lootid`=17961 WHERE `entry`=19887;
UPDATE `creature_template` SET `lootid`=17938 WHERE `entry`=19888;
UPDATE `creature_template` SET `lootid`=17959 WHERE `entry`=19889;
UPDATE `creature_template` SET `lootid`=17960 WHERE `entry`=19890;
UPDATE `creature_template` SET `lootid`=17940 WHERE `entry`=19891;
UPDATE `creature_template` SET `lootid`=17817 WHERE `entry`=19892;
UPDATE `creature_template` SET `lootid`=17963 WHERE `entry`=19902;
UPDATE `creature_template` SET `lootid`=17962 WHERE `entry`=19903;
UPDATE `creature_template` SET `lootid`=17964 WHERE `entry`=19904;
UPDATE `creature_template` SET `lootid`=17723 WHERE `entry`=20164;
UPDATE `creature_template` SET `lootid`=17731 WHERE `entry`=20173;
UPDATE `creature_template` SET `lootid`=19632 WHERE `entry`=20174;
UPDATE `creature_template` SET `lootid`=17732 WHERE `entry`=20175;
UPDATE `creature_template` SET `lootid`=17730 WHERE `entry`=20177;
UPDATE `creature_template` SET `lootid`=17771 WHERE `entry`=20179;
UPDATE `creature_template` SET `lootid`=17729 WHERE `entry`=20180;
UPDATE `creature_template` SET `lootid`=17728 WHERE `entry`=20181;
UPDATE `creature_template` SET `lootid`=17724 WHERE `entry`=20185;
UPDATE `creature_template` SET `lootid`=17734 WHERE `entry`=20187;
UPDATE `creature_template` SET `lootid`=17725 WHERE `entry`=20188;
UPDATE `creature_template` SET `lootid`=17871 WHERE `entry`=20190;
UPDATE `creature_template` SET `lootid`=17726 WHERE `entry`=20191;
UPDATE `creature_template` SET `lootid`=17727 WHERE `entry`=20192;
UPDATE `creature_template` SET `lootid`=17735 WHERE `entry`=20193;
UPDATE `creature_template` SET `lootid`=18311 WHERE `entry`=20255;
UPDATE `creature_template` SET `lootid`=18331 WHERE `entry`=20256;
UPDATE `creature_template` SET `lootid`=18317 WHERE `entry`=20257;
UPDATE `creature_template` SET `lootid`=18309 WHERE `entry`=20258;
UPDATE `creature_template` SET `lootid`=18313 WHERE `entry`=20259;
UPDATE `creature_template` SET `lootid`=18312 WHERE `entry`=20260;
UPDATE `creature_template` SET `lootid`=18315 WHERE `entry`=20261;
UPDATE `creature_template` SET `lootid`=19306 WHERE `entry`=20263;
UPDATE `creature_template` SET `lootid`=18314 WHERE `entry`=20264;
UPDATE `creature_template` SET `lootid`=19307 WHERE `entry`=20265;
UPDATE `creature_template` SET `lootid`=18524 WHERE `entry`=20298;
UPDATE `creature_template` SET `lootid`=18497 WHERE `entry`=20299;
UPDATE `creature_template` SET `lootid`=18702 WHERE `entry`=20300;
UPDATE `creature_template` SET `lootid`=18493 WHERE `entry`=20301;
UPDATE `creature_template` SET `lootid`=18495 WHERE `entry`=20302;
UPDATE `creature_template` SET `lootid`=18503 WHERE `entry`=20309;
UPDATE `creature_template` SET `lootid`=18557 WHERE `entry`=20310;
UPDATE `creature_template` SET `lootid`=18556 WHERE `entry`=20311;
UPDATE `creature_template` SET `lootid`=18558 WHERE `entry`=20312;
UPDATE `creature_template` SET `lootid`=18559 WHERE `entry`=20313;
UPDATE `creature_template` SET `lootid`=18521 WHERE `entry`=20315;
UPDATE `creature_template` SET `lootid`=18500 WHERE `entry`=20320;
UPDATE `creature_template` SET `lootid`=18498 WHERE `entry`=20321;
UPDATE `creature_template` SET `lootid`=18499 WHERE `entry`=20322;
UPDATE `creature_template` SET `lootid`=18501 WHERE `entry`=20323;
UPDATE `creature_template` SET `lootid`=18934 WHERE `entry`=20525;
UPDATE `creature_template` SET `lootid`=17820 WHERE `entry`=20526;
UPDATE `creature_template` SET `lootid`=17819 WHERE `entry`=20527;
UPDATE `creature_template` SET `lootid`=17840 WHERE `entry`=20528;
UPDATE `creature_template` SET `lootid`=17860 WHERE `entry`=20529;
UPDATE `creature_template` SET `lootid`=17833 WHERE `entry`=20530;
UPDATE `creature_template` SET `lootid`=18171 WHERE `entry`=20532;
UPDATE `creature_template` SET `lootid`=18172 WHERE `entry`=20533;
UPDATE `creature_template` SET `lootid`=18170 WHERE `entry`=20534;
UPDATE `creature_template` SET `lootid`=17815 WHERE `entry`=20537;
UPDATE `creature_template` SET `lootid`=17814 WHERE `entry`=20538;
UPDATE `creature_template` SET `lootid`=17846 WHERE `entry`=20543;
UPDATE `creature_template` SET `lootid`=18092 WHERE `entry`=20545;
UPDATE `creature_template` SET `lootid`=18094 WHERE `entry`=20546;
UPDATE `creature_template` SET `lootid`=18093 WHERE `entry`=20547;
UPDATE `creature_template` SET `lootid`=17721 WHERE `entry`=20620;
UPDATE `creature_template` SET `lootid`=17800 WHERE `entry`=20621;
UPDATE `creature_template` SET `lootid`=17803 WHERE `entry`=20622;
UPDATE `creature_template` SET `lootid`=17801 WHERE `entry`=20623;
UPDATE `creature_template` SET `lootid`=17805 WHERE `entry`=20624;
UPDATE `creature_template` SET `lootid`=17722 WHERE `entry`=20625;
UPDATE `creature_template` SET `lootid`=17802 WHERE `entry`=20626;
UPDATE `creature_template` SET `lootid`=17917 WHERE `entry`=20627;
UPDATE `creature_template` SET `lootid`=17799 WHERE `entry`=20628;
UPDATE `creature_template` SET `lootid`=18633 WHERE `entry`=20638;
UPDATE `creature_template` SET `lootid`=18636 WHERE `entry`=20639;
UPDATE `creature_template` SET `lootid`=18631 WHERE `entry`=20640;
UPDATE `creature_template` SET `lootid`=18635 WHERE `entry`=20641;
UPDATE `creature_template` SET `lootid`=18632 WHERE `entry`=20642;
UPDATE `creature_template` SET `lootid`=18641 WHERE `entry`=20643;
UPDATE `creature_template` SET `lootid`=18830 WHERE `entry`=20644;
UPDATE `creature_template` SET `lootid`=18794 WHERE `entry`=20645;
UPDATE `creature_template` SET `lootid`=18637 WHERE `entry`=20646;
UPDATE `creature_template` SET `lootid`=18639 WHERE `entry`=20647;
UPDATE `creature_template` SET `lootid`=18634 WHERE `entry`=20648;
UPDATE `creature_template` SET `lootid`=18640 WHERE `entry`=20649;
UPDATE `creature_template` SET `lootid`=18638 WHERE `entry`=20650;
UPDATE `creature_template` SET `lootid`=18642 WHERE `entry`=20651;
UPDATE `creature_template` SET `lootid`=18796 WHERE `entry`=20652;
UPDATE `creature_template` SET `lootid`=18663 WHERE `entry`=20655;
UPDATE `creature_template` SET `lootid`=18848 WHERE `entry`=20656;
UPDATE `creature_template` SET `lootid`=19208 WHERE `entry`=20660;
UPDATE `creature_template` SET `lootid`=19209 WHERE `entry`=20661;
UPDATE `creature_template` SET `lootid`=19429 WHERE `entry`=20686;
UPDATE `creature_template` SET `lootid`=19428 WHERE `entry`=20688;
UPDATE `creature_template` SET `lootid`=18327 WHERE `entry`=20691;
UPDATE `creature_template` SET `lootid`=18323 WHERE `entry`=20692;
UPDATE `creature_template` SET `lootid`=18318 WHERE `entry`=20693;
UPDATE `creature_template` SET `lootid`=18328 WHERE `entry`=20694;
UPDATE `creature_template` SET `lootid`=18325 WHERE `entry`=20695;
UPDATE `creature_template` SET `lootid`=18322 WHERE `entry`=20696;
UPDATE `creature_template` SET `lootid`=18319 WHERE `entry`=20697;
UPDATE `creature_template` SET `lootid`=18320 WHERE `entry`=20698;
UPDATE `creature_template` SET `lootid`=18326 WHERE `entry`=20699;
UPDATE `creature_template` SET `lootid`=18321 WHERE `entry`=20701;
UPDATE `creature_template` SET `lootid`=20923 WHERE `entry`=20993;
UPDATE `creature_template` SET `lootid`=19510 WHERE `entry`=21522;
UPDATE `creature_template` SET `lootid`=20990 WHERE `entry`=21523;
UPDATE `creature_template` SET `lootid`=19167 WHERE `entry`=21524;
UPDATE `creature_template` SET `lootid`=19231 WHERE `entry`=21527;
UPDATE `creature_template` SET `lootid`=19712 WHERE `entry`=21528;
UPDATE `creature_template` SET `lootid`=19716 WHERE `entry`=21531;
UPDATE `creature_template` SET `lootid`=19713 WHERE `entry`=21532;
UPDATE `creature_template` SET `lootid`=19168 WHERE `entry`=21539;
UPDATE `creature_template` SET `lootid`=20988 WHERE `entry`=21540;
UPDATE `creature_template` SET `lootid`=20059 WHERE `entry`=21541;
UPDATE `creature_template` SET `lootid`=19735 WHERE `entry`=21542;
UPDATE `creature_template` SET `lootid`=19166 WHERE `entry`=21543;
UPDATE `creature_template` SET `lootid`=20857 WHERE `entry`=21585;
UPDATE `creature_template` SET `lootid`=20869 WHERE `entry`=21586;
UPDATE `creature_template` SET `lootid`=20859 WHERE `entry`=21587;
UPDATE `creature_template` SET `lootid`=20911 WHERE `entry`=21588;
UPDATE `creature_template` SET `lootid`=20905 WHERE `entry`=21589;
UPDATE `creature_template` SET `lootid`=20867 WHERE `entry`=21591;
UPDATE `creature_template` SET `lootid`=20868 WHERE `entry`=21593;
UPDATE `creature_template` SET `lootid`=20880 WHERE `entry`=21594;
UPDATE `creature_template` SET `lootid`=20879 WHERE `entry`=21595;
UPDATE `creature_template` SET `lootid`=20896 WHERE `entry`=21596;
UPDATE `creature_template` SET `lootid`=20897 WHERE `entry`=21597;
UPDATE `creature_template` SET `lootid`=20898 WHERE `entry`=21598;
UPDATE `creature_template` SET `lootid`=20912 WHERE `entry`=21601;
UPDATE `creature_template` SET `lootid`=20875 WHERE `entry`=21604;
UPDATE `creature_template` SET `lootid`=20873 WHERE `entry`=21605;
UPDATE `creature_template` SET `lootid`=20906 WHERE `entry`=21606;
UPDATE `creature_template` SET `lootid`=20865 WHERE `entry`=21607;
UPDATE `creature_template` SET `lootid`=20864 WHERE `entry`=21608;
UPDATE `creature_template` SET `lootid`=20901 WHERE `entry`=21610;
UPDATE `creature_template` SET `lootid`=20902 WHERE `entry`=21611;
UPDATE `creature_template` SET `lootid`=20882 WHERE `entry`=21613;
UPDATE `creature_template` SET `lootid`=20866 WHERE `entry`=21614;
UPDATE `creature_template` SET `lootid`=20883 WHERE `entry`=21615;
UPDATE `creature_template` SET `lootid`=20909 WHERE `entry`=21616;
UPDATE `creature_template` SET `lootid`=20908 WHERE `entry`=21617;
UPDATE `creature_template` SET `lootid`=20910 WHERE `entry`=21618;
UPDATE `creature_template` SET `lootid`=20881 WHERE `entry`=21619;
UPDATE `creature_template` SET `lootid`=20900 WHERE `entry`=21621;
UPDATE `creature_template` SET `lootid`=21126 WHERE `entry`=21842;
UPDATE `creature_template` SET `lootid`=21127 WHERE `entry`=21843;
UPDATE `creature_template` SET `lootid`=21694 WHERE `entry`=21914;
UPDATE `creature_template` SET `lootid`=21696 WHERE `entry`=21916;
UPDATE `creature_template` SET `lootid`=21695 WHERE `entry`=21917;
UPDATE `creature_template` SET `lootid`=21891 WHERE `entry`=21989;
UPDATE `creature_template` SET `lootid`=21904 WHERE `entry`=21990;
UPDATE `creature_template` SET `lootid`=22128 WHERE `entry`=22129;
UPDATE `creature_template` SET `lootid`=18983 WHERE `entry`=22162;
UPDATE `creature_template` SET `lootid`=17952 WHERE `entry`=22163;
UPDATE `creature_template` SET `lootid`=18982 WHERE `entry`=22173;
UPDATE `creature_template` SET `lootid`=21702 WHERE `entry`=22346;
UPDATE `creature_template` SET `lootid`=13536 WHERE `entry`=22530;
UPDATE `creature_template` SET `lootid`=13539 WHERE `entry`=22532;
UPDATE `creature_template` SET `lootid`=13424 WHERE `entry`=22533;
UPDATE `creature_template` SET `lootid`=13542 WHERE `entry`=22534;
UPDATE `creature_template` SET `lootid`=13554 WHERE `entry`=22535;
UPDATE `creature_template` SET `lootid`=13545 WHERE `entry`=22536;
UPDATE `creature_template` SET `lootid`=13557 WHERE `entry`=22537;
UPDATE `creature_template` SET `lootid`=13425 WHERE `entry`=22538;
UPDATE `creature_template` SET `lootid`=13155 WHERE `entry`=22539;
UPDATE `creature_template` SET `lootid`=14770 WHERE `entry`=22543;
UPDATE `creature_template` SET `lootid`=14768 WHERE `entry`=22547;
UPDATE `creature_template` SET `lootid`=13378 WHERE `entry`=22550;
UPDATE `creature_template` SET `lootid`=603 WHERE `entry`=22555;
UPDATE `creature_template` SET `lootid`=13377 WHERE `entry`=22565;
UPDATE `creature_template` SET `lootid`=13416 WHERE `entry`=22576;
UPDATE `creature_template` SET `lootid`=13151 WHERE `entry`=22578;
UPDATE `creature_template` SET `lootid`=14767 WHERE `entry`=22579;
UPDATE `creature_template` SET `lootid`=13526 WHERE `entry`=22587;
UPDATE `creature_template` SET `lootid`=13530 WHERE `entry`=22592;
UPDATE `creature_template` SET `lootid`=14769 WHERE `entry`=22595;
UPDATE `creature_template` SET `lootid`=13527 WHERE `entry`=22607;
UPDATE `creature_template` SET `lootid`=13531 WHERE `entry`=22612;
UPDATE `creature_template` SET `lootid`=13140 WHERE `entry`=22613;
UPDATE `creature_template` SET `lootid`=13319 WHERE `entry`=22614;
UPDATE `creature_template` SET `lootid`=13320 WHERE `entry`=22615;
UPDATE `creature_template` SET `lootid`=13154 WHERE `entry`=22616;
UPDATE `creature_template` SET `lootid`=13152 WHERE `entry`=22617;
UPDATE `creature_template` SET `lootid`=13318 WHERE `entry`=22618;
UPDATE `creature_template` SET `lootid`=13153 WHERE `entry`=22619;
UPDATE `creature_template` SET `lootid`=13139 WHERE `entry`=22620;
UPDATE `creature_template` SET `lootid`=13446 WHERE `entry`=22621;
UPDATE `creature_template` SET `lootid`=13597 WHERE `entry`=22623;
UPDATE `creature_template` SET `lootid`=13357 WHERE `entry`=22624;
UPDATE `creature_template` SET `lootid`=13841 WHERE `entry`=22628;
UPDATE `creature_template` SET `lootid`=13598 WHERE `entry`=22634;
UPDATE `creature_template` SET `lootid`=13356 WHERE `entry`=22635;
UPDATE `creature_template` SET `lootid`=13449 WHERE `entry`=22639;
UPDATE `creature_template` SET `lootid`=13840 WHERE `entry`=22640;
UPDATE `creature_template` SET `lootid`=12048 WHERE `entry`=22645;
UPDATE `creature_template` SET `lootid`=12052 WHERE `entry`=22649;
UPDATE `creature_template` SET `lootid`=12047 WHERE `entry`=22657;
UPDATE `creature_template` SET `lootid`=13325 WHERE `entry`=22662;
UPDATE `creature_template` SET `lootid`=13327 WHERE `entry`=22663;
UPDATE `creature_template` SET `lootid`=13330 WHERE `entry`=22664;
UPDATE `creature_template` SET `lootid`=13335 WHERE `entry`=22667;
UPDATE `creature_template` SET `lootid`=13336 WHERE `entry`=22668;
UPDATE `creature_template` SET `lootid`=13337 WHERE `entry`=22669;
UPDATE `creature_template` SET `lootid`=13426 WHERE `entry`=22671;
UPDATE `creature_template` SET `lootid`=13427 WHERE `entry`=22672;
UPDATE `creature_template` SET `lootid`=13428 WHERE `entry`=22673;
UPDATE `creature_template` SET `lootid`=13528 WHERE `entry`=22676;
UPDATE `creature_template` SET `lootid`=13440 WHERE `entry`=22679;
UPDATE `creature_template` SET `lootid`=13324 WHERE `entry`=22687;
UPDATE `creature_template` SET `lootid`=13329 WHERE `entry`=22688;
UPDATE `creature_template` SET `lootid`=13524 WHERE `entry`=22689;
UPDATE `creature_template` SET `lootid`=13576 WHERE `entry`=22691;
UPDATE `creature_template` SET `lootid`=13298 WHERE `entry`=22700;
UPDATE `creature_template` SET `lootid`=13145 WHERE `entry`=22701;
UPDATE `creature_template` SET `lootid`=13296 WHERE `entry`=22702;
UPDATE `creature_template` SET `lootid`=13147 WHERE `entry`=22703;
UPDATE `creature_template` SET `lootid`=13299 WHERE `entry`=22704;
UPDATE `creature_template` SET `lootid`=13300 WHERE `entry`=22705;
UPDATE `creature_template` SET `lootid`=13146 WHERE `entry`=22706;
UPDATE `creature_template` SET `lootid`=13137 WHERE `entry`=22707;
UPDATE `creature_template` SET `lootid`=13138 WHERE `entry`=22708;
UPDATE `creature_template` SET `lootid`=13297 WHERE `entry`=22709;
UPDATE `creature_template` SET `lootid`=13143 WHERE `entry`=22710;
UPDATE `creature_template` SET `lootid`=13144 WHERE `entry`=22711;
UPDATE `creature_template` SET `lootid`=13525 WHERE `entry`=22713;
UPDATE `creature_template` SET `lootid`=13529 WHERE `entry`=22718;
UPDATE `creature_template` SET `lootid`=13333 WHERE `entry`=22719;
UPDATE `creature_template` SET `lootid`=10984 WHERE `entry`=22725;
UPDATE `creature_template` SET `lootid`=13776 WHERE `entry`=22736;
UPDATE `creature_template` SET `lootid`=13537 WHERE `entry`=22754;
UPDATE `creature_template` SET `lootid`=13777 WHERE `entry`=22759;
UPDATE `creature_template` SET `lootid`=13676 WHERE `entry`=22764;
UPDATE `creature_template` SET `lootid`=13618 WHERE `entry`=22765;
UPDATE `creature_template` SET `lootid`=13150 WHERE `entry`=22768;
UPDATE `creature_template` SET `lootid`=13149 WHERE `entry`=22769;
UPDATE `creature_template` SET `lootid`=13541 WHERE `entry`=22774;
UPDATE `creature_template` SET `lootid`=13544 WHERE `entry`=22776;
UPDATE `creature_template` SET `lootid`=12156 WHERE `entry`=22788;
UPDATE `creature_template` SET `lootid`=12158 WHERE `entry`=22789;
UPDATE `creature_template` SET `lootid`=13956 WHERE `entry`=22790;
UPDATE `creature_template` SET `lootid`=13958 WHERE `entry`=22791;
UPDATE `creature_template` SET `lootid`=12157 WHERE `entry`=22792;
UPDATE `creature_template` SET `lootid`=10983 WHERE `entry`=22794;
UPDATE `creature_template` SET `lootid`=13957 WHERE `entry`=22795;
UPDATE `creature_template` SET `lootid`=11679 WHERE `entry`=22796;
UPDATE `creature_template` SET `lootid`=24976 WHERE `entry`=25548;
UPDATE `creature_template` SET `lootid`=24698 WHERE `entry`=25551;
UPDATE `creature_template` SET `lootid`=16506 WHERE `entry`=29274;
UPDATE `creature_template` SET `lootid`=16156 WHERE `entry`=29833;
UPDATE `creature_template` SET `lootid`=22262 WHERE `entry`=30759;
UPDATE `creature_template` SET `lootid`=22261 WHERE `entry`=30760;
UPDATE `creature_template` SET `lootid`=22263 WHERE `entry`=30761;
UPDATE `creature_template` SET `lootid`=23174 WHERE `entry`=30763;
UPDATE `creature_template` SET `lootid`=23386 WHERE `entry`=30773;
UPDATE `creature_template` SET `lootid`=26690 WHERE `entry`=30822;
UPDATE `creature_template` SET `lootid`=26691 WHERE `entry`=30823;
UPDATE `creature_template` SET `lootid`=27729 WHERE `entry`=31178;
UPDATE `creature_template` SET `lootid`=28249 WHERE `entry`=31179;
UPDATE `creature_template` SET `lootid`=27732 WHERE `entry`=31180;
UPDATE `creature_template` SET `lootid`=28200 WHERE `entry`=31184;
UPDATE `creature_template` SET `lootid`=27734 WHERE `entry`=31187;
UPDATE `creature_template` SET `lootid`=28199 WHERE `entry`=31188;
UPDATE `creature_template` SET `lootid`=27736 WHERE `entry`=31199;
UPDATE `creature_template` SET `lootid`=28201 WHERE `entry`=31200;
UPDATE `creature_template` SET `lootid`=27731 WHERE `entry`=31201;
UPDATE `creature_template` SET `lootid`=27742 WHERE `entry`=31202;
UPDATE `creature_template` SET `lootid`=27744 WHERE `entry`=31203;
UPDATE `creature_template` SET `lootid`=27743 WHERE `entry`=31206;
UPDATE `creature_template` SET `lootid`=32915 WHERE `entry`=33391;
UPDATE `creature_template` SET `lootid`=33772 WHERE `entry`=33773;
UPDATE `creature_template` SET `lootid`=33432 WHERE `entry`=34106;
UPDATE `creature_template` SET `lootid`=33651 WHERE `entry`=34108;
UPDATE `creature_template` SET `lootid`=35305 WHERE `entry`=35306;
UPDATE `creature_template` SET `lootid`=35307 WHERE `entry`=35308;
UPDATE `creature_template` SET `lootid`=35309 WHERE `entry`=35310;
UPDATE `creature_template` SET `lootid`=35143 WHERE `entry`=35359;
UPDATE `creature_template` SET `lootid`=37532 WHERE `entry`=38151;
UPDATE `creature_template` SET `lootid`=39946 WHERE `entry`=39805;
UPDATE `creature_template` SET `lootid`=39948 WHERE `entry`=39823;
UPDATE `creature_template` SET `lootid`=39947 WHERE `entry`=39920;
UPDATE `creature_template` SET `lootid`=40419 WHERE `entry`=40420;
 
-- TrinityCore\sql\updates\world\2012_09_15_00_world_disables.sql 
-- Remove achievements from disables
DELETE FROM `disables` WHERE  `sourceType`=4 AND `entry`=7323; -- Ruby Void
DELETE FROM `disables` WHERE  `sourceType`=4 AND `entry`=7324; -- Emerald Void
DELETE FROM `disables` WHERE  `sourceType`=4 AND `entry`=7325; -- Amber Void
 
-- TrinityCore\sql\updates\world\2012_09_15_01_world_creature_loot_template.sql 
SET @SisterSvalna := 37126; -- Sister Svalna

CALL `sp_get_ref_id`('RAID_CRE',@Reference);
SET @RefSisterSvalna := @Reference+1;

DELETE FROM `creature_loot_template` WHERE `entry`=@SisterSvalna;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(@SisterSvalna,49426,100,1,0,1,1),-- Sister Svalna dropping 1 Emblem of Frost
(@SisterSvalna,1,100,1,0,-@RefSisterSvalna,1);

DELETE FROM `reference_loot_template` WHERE `entry`=@RefSisterSvalna;
INSERT INTO `reference_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(@RefSisterSvalna,50452,6,1,1,1,1), -- Wodin's Lucky Necklace
(@RefSisterSvalna,50453,5,1,1,1,1); -- Ring of Rotting Sinew

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=10 AND `SourceGroup`=@RefSisterSvalna;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(10,@RefSisterSvalna,50452,0,0,19,0,3,0,0,0,0,'', 'Wodin''s Lucky Necklace only 25 heroic'),
(10,@RefSisterSvalna,50453,0,0,19,0,3,0,0,0,0,'', 'Ring of Rotting Sinew only 25 heroic');
 
