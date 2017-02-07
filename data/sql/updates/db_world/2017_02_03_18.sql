-- DB update 2017_02_03_17 -> 2017_02_03_18
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
START TRANSACTION;
ALTER TABLE version_db_world CHANGE COLUMN 2017_02_03_17 2017_02_03_18 bit;
SELECT sql_rev INTO OK FROM version_db_world WHERE sql_rev = '1485431395889581500'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--
INSERT INTO version_db_world (`sql_rev`) VALUES ('1485431395889581500');
UPDATE `creature` SET `spawndist`=0, `MovementType`=0, `unit_flags`=`unit_flags`|536870912|32770, `dynamicflags`=32 WHERE  `guid`=116778;

DELETE FROM `creature_addon` WHERE `guid` IN (113320, 116778);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES 
(113320,0,0,0,1,233, ''),
(116778,0,0,7,1,0, '29266');

-- Ironwool Mammoth, Part 2, patrolling event
DELETE FROM `creature` WHERE `guid` IN (116895, 116892, 116894, 116891);
UPDATE `creature` SET `spawndist`=0, `MovementType`=0, `position_x`=6459.656738, `position_y`=-1248.93371, `position_z`=459.40695, `orientation`=2.7473 WHERE  `guid` IN (116907, 116911, 116910, 116908, 116909);
UPDATE `creature` SET `position_x`=6479.30419, `position_y`=-1257.4559, `position_z`= 468.8983, `orientation`=5.98313 WHERE  `guid`=116908;
UPDATE `creature_template` SET `speed_run`=1.5 WHERE  `entry`=29402;

DELETE FROM `creature_formations` WHERE `leaderGUID`=116908;
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES 
(116908, 116908, 0, 0, 2, 0, 0),
(116908, 116907, 8, 30, 2, 0, 0),
(116908, 116911, 8, 60, 2, 0, 0),
(116908, 116910, 8, 300, 2, 0, 0),
(116908, 116909, 8, 330, 2, 0, 0);

SET @NPC := 116908;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,0,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_type`, `action`, `action_chance`, `wpguid`) VALUES 
(@PATH, 1, 6435.16, -1239.87, 447.581, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 2, 6396.64, -1223.13, 430.318, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 3, 6380.58, -1209.6, 426.213, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 4, 6368.91, -1176.6, 427.008, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 5, 6358.24, -1131.07, 423.253, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 6, 6336.66, -1037.79, 416.366, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 7, 6328.1, -1003.7, 415.253, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 8, 6317.85, -975.257, 409.725, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 9, 6291.93, -925.632, 409.592, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 10, 6268.17, -896.997, 407.157, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 11, 6232.51, -856.589, 405.761, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 12, 6205.65, -821.214, 401.573, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 13, 6197.91, -784.789, 402.398, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 14, 6172.17, -737.765, 398.054, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 15, 6173.12, -682.006, 398.173, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 16, 6178.15, -638.913, 405.172, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 17, 6181.84, -609.178, 407.013, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 18, 6158.61, -566.177, 402.071, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 19, 6124.7, -514.61, 396.071, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 20, 6113.01, -498.197, 395.71, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 21, 6078.05, -503.076, 381.885, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 22, 6039.49, -514.377, 364.875, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 23, 6004.76, -523.171, 347.563, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 24, 5976.67, -507.53, 336.84, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 25, 5941.96, -495.75, 317.882, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 26, 5925.45, -490.855, 308.241, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 27, 5905.03, -485.92, 297.25, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 28, 5886.99, -480.799, 286.995, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 29, 5849.22, -468.861, 267.261, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 30, 5815.16, -457.732, 251.466, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 31, 5777.5, -444.971, 234.154, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 32, 5796.25, -451.588, 242.775, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 33, 5813.78, -456.937, 250.769, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 34, 5829.77, -461.747, 257.881, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 35, 5866.75, -475.495, 275.778, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 36, 5935.89, -493.427, 314.012, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 37, 5977.02, -505.339, 336.79, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 38, 6022.89, -509.131, 356.888, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 39, 6076.86, -503.914, 381.206, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 40, 6105.04, -501.556, 392.878, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 41, 6129.72, -536.563, 393.466, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 42, 6162.83, -582.65, 402.332, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 43, 6179.94, -607.92, 406.712, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 44, 6181.06, -671.131, 402.657, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 45, 6169.77, -717.892, 397.477, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 46, 6187.36, -766.508, 401.148, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 47, 6221.8, -832.298, 404.688, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 48, 6258.85, -887.193, 406.175, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 49, 6306.02, -941.727, 410.591, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 50, 6329.22, -995.427, 414.636, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 51, 6341.63, -1093.04, 416.601, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 52, 6351.8, -1161.35, 426.35, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 53, 6390.75, -1220.95, 428.485, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 54, 6438.53, -1244.41, 449.509, 0, 0, 0, 0, 100, 0),                                                               
(@PATH, 55, 6473.51, -1253.46, 465.931, 0, 0, 0, 0, 100, 0);    

UPDATE `waypoint_data` SET `move_type`=1 WHERE `id`=@PATH;--
-- END UPDATING QUERIES
--
COMMIT;
END;
//
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;
