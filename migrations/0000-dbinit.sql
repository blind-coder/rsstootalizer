SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `apps` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `instance` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL,
  `instance_id` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL,
  `instance_client_id` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL,
  `instance_client_secret` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `entries` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `feed_id` bigint(20) UNSIGNED NOT NULL,
  `entry_link` text NOT NULL,
  `posted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `feeds` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `username` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL,
  `instance` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8_unicode_ci NOT NULL,
  `format` varchar(500) NOT NULL DEFAULT '{Title} - {Link} by {Author} -- posted at {Issued} with #RSSTootalizer',
  `enabled` enum('0','1') NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `filters` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `feed_id` bigint(20) UNSIGNED NOT NULL,
  `field` text NOT NULL,
  `regex` text NOT NULL,
  `type` enum('white','black') NOT NULL,
  `match` enum('positive','negative') NOT NULL DEFAULT 'positive'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `migrations` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `ID` bigint(20) NOT NULL,
  `username` text NOT NULL,
  `username_sha256` varchar(128) NOT NULL,
  `instance` text NOT NULL,
  `instance_sha256` varchar(128) NOT NULL,
  `access_token` text NOT NULL,
  `session_id` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


ALTER TABLE `apps`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `entries`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `feed_id` (`feed_id`);

ALTER TABLE `feeds`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `filters`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `feed_id` (`feed_id`);

ALTER TABLE `migrations`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `user` (`username_sha256`,`instance_sha256`);


ALTER TABLE `apps`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `entries`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `feeds`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `filters`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `migrations`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `users`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `entries`
  ADD CONSTRAINT `feed_id` FOREIGN KEY (`feed_id`) REFERENCES `feeds` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `filters`
  ADD CONSTRAINT `filters_ibfk_1` FOREIGN KEY (`feed_id`) REFERENCES `feeds` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
