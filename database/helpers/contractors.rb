# DB.create_table :contractors do
# 	primary_key :id
# 	String :name
# 	Float :price
# end
#
# class Contractors < Sequel::Model(:contractors)
# end
	# Scraping Vendor information table -------------------------------------------------------------------------------
	

	#
	# CREATE TABLE IF NOT EXISTS contractors
	# (
	# name varchar(255) not null,
	# href_name varchar(255) null,
	# category varchar(255) null,
	# last_updated datetime default CURRENT_TIMESTAMP not null,
	# last_search datetime default CURRENT_TIMESTAMP not null,
	# item_count int(10) unsigned null,
	#                             check_out tinyint default '0' not null,
	# id int not null auto_increment
	# primary key,
	#         priority int(10) default '10' not null
	# );
	#
	# DB.create_table?(:contractors) do
	# 	column :VENDNAME     ,String,           size: 35              ,null: false      #   Vendor name.
	# 	column :DIVISION     ,String,           size: 35              ,null: true       #    Corporate/division name.
	# 	column :V_STR1       ,String,           size: 35              ,null: false      #   Corporate/division headquarters address 1.
	# 	column :V_STR2       ,String,           size: 35              ,null: true       #    Corporate/division headquarters address 2.
	# 	column :V_CITY       ,String,           size: 30              ,null: false      #   Corporate/division headquarters city.
	# 	column :V_STATE      ,String,           size: 2               ,null: false      #   Corporate/division headquarters state. In SIP help(SIP contents/Import data/SIP lookup tables/State and country code table).
	# 	column :V_CTRY       ,String,           size: 2               ,null: false      #   Corporate/division headquarters country. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
	# 	column :V_ZIP        ,String,           size: 11              ,null: false      #   Corporate/division headquarters zip code.
	# 	column :V_PHONE      ,String,           size: 30              ,null: false      #   Corporate/division headquarters telephone number. Must be numbers.
	# 	column :V_FAX        ,String,           size: 30              ,null: false      #   Corporate/division headquarters fax number. Must be numbers.
	# 	column :V_WWW        ,String,           size: 80              ,null: false      #   Corporate/division headquarters www address. First 7 char = 'http://'.
	# 	column :V_EMAIL      ,String,           size: 80              ,null: false      #   Email address that can accept GSA Advantage purchase order.
	# 	column :PASSWORD     ,String,           size: 30              ,null: false      #   Vendor support center provided password. Given out by the GSA help desk.
	# 	column :DUNS_NO      ,String,           size: 9               ,null: false      #   DUNS number. Must be 9 digits.
	# end
# end