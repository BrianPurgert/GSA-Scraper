create table manufacture_parts
(
  mfr varchar(255) not null,
  mpn varchar(40) not null,
  name varchar(255) null,
  href_name varchar(255) null,
  low_price varchar(255) null,
  `desc` text null,
  last_updated datetime default CURRENT_TIMESTAMP not null,
  status_id tinyint default '0' not null,
  sources int(10) null,
  id int not null auto_increment
    primary key
)
;

create table mfr
(
  name varchar(255) not null,
  href_name varchar(255) null,
  last_updated datetime default CURRENT_TIMESTAMP not null,
  last_search datetime default CURRENT_TIMESTAMP not null,
  item_count int(10) unsigned null,
  check_out bit default b'0' not null,
  id int not null auto_increment
    primary key,
  priority int(10) default '0' not null
)
;

