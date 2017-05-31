SET FOREIGN_KEY_CHECKS = 0;
; DROP SCHEMA IF EXISTS `mft_data`;


CREATE SCHEMA IF NOT EXISTS `mft_data`;


CREATE TABLE IF NOT EXISTS `mft_data`.`control` (
  `stop` INT(11) NOT NULL)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS `mft_data`.`lowest_price_contractor` (
  `mpn` VARCHAR(255) NOT NULL,
  `manufacturer_name` VARCHAR(70) NULL DEFAULT NULL,
  `lowest_contractor` VARCHAR(70) NULL DEFAULT NULL,
  `lowest_contractor_price` VARCHAR(255) NULL DEFAULT NULL,
  `lowest_contractor_page_url` VARCHAR(255) NULL DEFAULT NULL,
  `mpn_page_url` VARCHAR(255) NULL DEFAULT NULL,
  `last_updated` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`mpn`),
  UNIQUE INDEX `lowest_price_contractor_mpn_uindex` (`mpn` ASC))
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  - Creating table mft_data.mfr;
CREATE TABLE IF NOT EXISTS `mft_data`.`mfr` (
  `name` VARCHAR(255) NOT NULL,
  `href_name` VARCHAR(255) NULL DEFAULT NULL,
  `last_updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_search` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `item_count` INT(10) UNSIGNED NULL DEFAULT NULL,
  `change` INT(10) NOT NULL DEFAULT '0',
  `check_out` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`name`),
  UNIQUE INDEX `manufacture_name_uindex` (`name` ASC))
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  - Creating table mft_data.mfr_part_blocks;
CREATE TABLE IF NOT EXISTS `mft_data`.`mfr_part_blocks` (
  `href_search` VARCHAR(255) NOT NULL,
  `result_block` TEXT NOT NULL,
  `href_name` VARCHAR(255) NOT NULL,
  `full_page` MEDIUMTEXT NULL DEFAULT NULL,
  `last_updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status_id` TINYINT(4) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`href_name`),
  UNIQUE INDEX `href_name` (`href_name` ASC))
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  - Creating table mft_data.mfr_parts;
CREATE TABLE IF NOT EXISTS `mft_data`.`mfr_parts` (
  `mfr` VARCHAR(255) NOT NULL,
  `mpn` VARCHAR(40) NOT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `href_name` VARCHAR(255) NULL DEFAULT NULL,
  `low_price` VARCHAR(255) NULL DEFAULT NULL,
  `desc` TEXT NULL DEFAULT NULL,
  `last_updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status_id` TINYINT(4) UNSIGNED NOT NULL DEFAULT '0',
  `sources` INT(10) NULL DEFAULT NULL,
  PRIMARY KEY (`mfr`, `mpn`))
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  - Creating table mft_data.page_mfr_list;
CREATE TABLE IF NOT EXISTS `mft_data`.`page_mfr_list` (
  `list_for` CHAR(50) NOT NULL COMMENT 'letter or 0 for manufacturer list',
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`list_for`))
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  COMMENT = 'table to save time stamps for updates on the manufacture lis' /* comment truncated */ /*t https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4*&listFor=A*/
  - Creating table mft_data.queue;
CREATE TABLE IF NOT EXISTS `mft_data`.`queue` (
  `data` LONGTEXT NOT NULL,
  `type` INT(10) UNSIGNED NULL DEFAULT NULL,
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  - Creating table mft_data.testuser;
CREATE TABLE IF NOT EXISTS `mft_data`.`testuser` (
  `GCS_Lookup_Key` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`GCS_Lookup_Key`))
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8
  Scripts for 8 tables, 0 views and 0 routines were executed for schema mft_data
  - Executing postamble script...; SET FOREIGN_KEY_CHECKS = 1
  - Schema created
  Creating target schema finished
  Selecting tables to copy done
  Counting table rows to copy....
  wbcopytables.exe --count-only --passwords-from-stdin --mysql-source="mft_data@70.61.131.180:3306" --table-file=c:\users\brian\appdata\local\temp\tmpbj_bnn
  16:04:23 [INF][      copytable]: --table `mft_data`	`mfr_parts`
  16:04:23 [INF][      copytable]: --table `mft_data`	`page_mfr_list`
  16:04:23 [INF][      copytable]: --table `mft_data`	`queue`
  16:04:23 [INF][      copytable]: --table `mft_data`	`testuser`
  16:04:23 [INF][      copytable]: --table `mft_data`	`mfr_part_blocks`
  16:04:23 [INF][      copytable]: --table `mft_data`	`lowest_price_contractor`
  16:04:23 [INF][      copytable]: --table `mft_data`	`control`
  16:04:23 [INF][      copytable]: --table `mft_data`	`mfr`
  16:04:23 [INF][      copytable]: Connecting to MySQL server at 70.61.131.180:3306 with user mft_data
  16:04:23 [INF][      copytable]: Connection to MySQL opened

  1639693 total rows in 8 tables need to be copied:
  Counting table rows to copy finished
  Copying table data....
  - Data copy starting

  Migrating data...
  wbcopytables.exe --mysql-source="mft_data@70.61.131.180:3306" --target="root@localhost:3306" --progress --passwords-from-stdin --thread-count=2 --source-rdbms-type=Mysql --table-file=c:\users\brian\appdata\local\temp\tmpfgwwup
  Loading table information from file c:\users\brian\appdata\local\temp\tmpfgwwup

  `mft_data`.`page_mfr_list`:Copying 2 columns of 27 rows from table `mft_data`.`page_mfr_list`
  `mft_data`.`page_mfr_list`:Finished copying 27 rows in 0m00s
  `mft_data`.`queue`:Copying 3 columns of 8 rows from table `mft_data`.`queue`
  `mft_data`.`queue`:Finished copying 8 rows in 0m00s
  `mft_data`.`testuser`:Copying 1 columns of 436 rows from table `mft_data`.`testuser`
  `mft_data`.`testuser`:Finished copying 436 rows in 0m00s
  `mft_data`.`mfr_part_blocks`:Copying 6 columns of 3339 rows from table `mft_data`.`mfr_part_blocks`
  `mft_data`.`mfr_parts`:Copying 9 columns of 1596627 rows from table `mft_data`.`mfr_parts`
  `mft_data`.`mfr_part_blocks`:Finished copying 3339 rows in 0m01s
  `mft_data`.`lowest_price_contractor`:Copying 7 columns of 5584 rows from table `mft_data`.`lowest_price_contractor`
  `mft_data`.`lowest_price_contractor`:Finished copying 5584 rows in 0m01s
  `mft_data`.`control`:Copying 1 columns of 1 rows from table `mft_data`.`control`
  `mft_data`.`control`:Finished copying 1 rows in 0m01s
  `mft_data`.`mfr`:Copying 7 columns of 33671 rows from table `mft_data`.`mfr`
  `mft_data`.`mfr`:Finished copying 33671 rows in 0m04s
  `mft_data`.`mfr_parts`:Finished copying 1596627 rows in 2m50s
  FINISHED

  16:04:24 [INF][      copytable]: --table `mft_data`	`mfr_parts`	`mft_data`	`mfr_parts`	`mfr`,`mpn`	`mfr`,`mpn`	`mfr`, `mpn`, `name`, `href_name`, `low_price`, `desc`, `last_updated`, `status_id`, `sources`

  16:04:24 [INF][      copytable]: --table `mft_data`	`page_mfr_list`	`mft_data`	`page_mfr_list`	`list_for`	`list_for`	`list_for`, `last_update`

  16:04:24 [INF][      copytable]: --table `mft_data`	`queue`	`mft_data`	`queue`			`data`, `type`, `created`

  16:04:24 [INF][      copytable]: --table `mft_data`	`testuser`	`mft_data`	`testuser`	`GCS_Lookup_Key`	`GCS_Lookup_Key`	`GCS_Lookup_Key`

  16:04:24 [INF][      copytable]: --table `mft_data`	`mfr_part_blocks`	`mft_data`	`mfr_part_blocks`	`href_name`	`href_name`	`href_search`, `result_block`, `href_name`, `full_page`, `last_updated`, `status_id`

  16:04:24 [INF][      copytable]: --table `mft_data`	`lowest_price_contractor`	`mft_data`	`lowest_price_contractor`	`mpn`	`mpn`	`mpn`, `manufacturer_name`, `lowest_contractor`, `lowest_contractor_price`, `lowest_contractor_page_url`, `mpn_page_url`, `last_updated`

  16:04:24 [INF][      copytable]: --table `mft_data`	`control`	`mft_data`	`control`			`stop`

  16:04:24 [INF][      copytable]: --table `mft_data`	`mfr`	`mft_data`	`mfr`	`name`	`name`	`name`, `href_name`, `last_updated`, `last_search`, `item_count`, `change`, `check_out`

  16:04:24 [INF][      copytable]: Connecting to MySQL server at localhost:3306 with user root

  16:04:24 [INF][      copytable]: Connection to MySQL opened

  16:04:24 [INF][      copytable]: Connecting to MySQL server at 70.61.131.180:3306 with user mft_data

  16:04:24 [INF][      copytable]: Connection to MySQL opened

  16:04:24 [INF][      copytable]: Connecting to MySQL server at localhost:3306 with user root

  16:04:24 [INF][      copytable]: Connection to MySQL opened

  16:04:24 [INF][      copytable]: Connecting to MySQL server at 70.61.131.180:3306 with user mft_data

  16:04:25 [INF][      copytable]: Connection to MySQL opened

  16:04:25 [INF][      copytable]: Connecting to MySQL server at localhost:3306 with user root

  16:04:25 [INF][      copytable]: Connection to MySQL opened

  16:07:14 [INF][      copytable]: Re-enabling triggers for schema 'mft_data'

  16:07:14 [INF][      copytable]: No triggers found for 'mft_data'







Copy helper has finished

Data copy results:
  - `mft_data`.`mfr_parts` has succeeded (1596627 of 1596627 rows copied)
  - `mft_data`.`page_mfr_list` has succeeded (27 of 27 rows copied)
  - `mft_data`.`queue` has succeeded (8 of 8 rows copied)
  - `mft_data`.`testuser` has succeeded (436 of 436 rows copied)
  - `mft_data`.`mfr_part_blocks` has succeeded (3339 of 3339 rows copied)
  - `mft_data`.`lowest_price_contractor` has succeeded (5584 of 5584 rows copied)
  - `mft_data`.`control` has succeeded (1 of 1 rows copied)
  - `mft_data`.`mfr` has succeeded (33671 of 33671 rows copied)
  8 tables of 8 were fully copied
  Copying table data finished
  Finished performing tasks.
