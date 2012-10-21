-- TrinityCore\sql\updates\auth\2012_08_06_00_auth_logs.sql 
ALTER TABLE `logs` ADD COLUMN `level` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 AFTER `type`;

 
