SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;

CREATE TABLE `pitu_multijob_money` (
  `id` int(11) NOT NULL,
  `jobname` varchar(64) NOT NULL,
  `black` int(11) NOT NULL DEFAULT 0,
  `cash` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pitu_multijob_storage` (
  `jobname` varchar(64) NOT NULL,
  `item` varchar(64) NOT NULL,
  `amount` int(11) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pitu_multijob_users` (
  `identifier` varchar(64) NOT NULL,
  `jobname` varchar(64) NOT NULL,
  `jobgrade` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Pitu7944''s MultiJob, users table';

ALTER TABLE `pitu_multijob_money`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pitu_multijob_storage`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pitu_multijob_users`
  ADD PRIMARY KEY (`identifier`);

ALTER TABLE `pitu_multijob_money`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `pitu_multijob_storage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;