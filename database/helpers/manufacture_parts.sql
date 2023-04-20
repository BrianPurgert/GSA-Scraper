CREATE TABLE IF NOT EXISTS manufacture_parts
(
    id           INT(11)                            NOT NULL AUTO_INCREMENT,
    term         varchar(255)                       null,

    gsin         varchar(255)                       null,
    mfr          varchar(255)                       null,
    mpn          varchar(255)                       not null,
    name         varchar(255)                       null,
    href_name    varchar(255)                       null,
    low_price    varchar(255)                       null,
    `desc`       text                               null,
    last_updated datetime default CURRENT_TIMESTAMP not null,
    status_id    tinyint  default '0'               not null,
    sources      int(10)  default '0'               null,
    primary key (id)

);
