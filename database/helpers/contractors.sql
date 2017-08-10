CREATE TABLE IF NOT EXISTS contractors
		(
  name varchar(255) not null,
  href_name varchar(255) null,
  category varchar(255) null,
  capture_time DATETIME default CURRENT_TIMESTAMP not null,
  item_count int(10) unsigned null,
  check_out tinyint default '0' not null,
  id int not null auto_increment
    primary key,
  priority int(10) default '0' null
	);
