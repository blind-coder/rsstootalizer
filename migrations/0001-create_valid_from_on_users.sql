ALTER TABLE `users` ADD `valid_from` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `session_id`;
UPDATE `users` SET `valid_from` = NOW();
