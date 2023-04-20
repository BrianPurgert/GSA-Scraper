CREATE TABLE IF NOT EXISTS controller
(
    id    int             not null auto_increment
        primary key,
    `key` varchar(255)    null,
    value int default '0' null
)
;


