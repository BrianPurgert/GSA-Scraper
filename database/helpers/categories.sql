CREATE TABLE IF NOT EXISTS categories
		(
  department varchar(255) not null,
  category varchar(255) not null,
  id varchar(255) not null
    primary key,
  priority int(10) default '0' null
	);
