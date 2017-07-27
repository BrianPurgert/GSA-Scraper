# This File was made using IMPORT.txt found in the SIP template folder after installing
# About the Schedule Input Program https://vsc.gsa.gov/sipuser/files/SIP-Instructions.pdf
# TODO: split this into multiple files
#


# GILL+MARKETING+COMPANY


# Mfr Part No.:	     DURPC1300
# Contractor Part No.:	DURPC1300
# Manufacturer:	     DURACELL U.S.A.
# Contract No.:	     GS-02F-0023X (ends: Nov 7, 2020)
# MAS Schedule/SIN:	     75/75 200
# Made In:	          UNITED STATES OF AMERICA
#
# Volume Discount Available Volume Discounts:
#   3000 - 4999 2.5%
# 5000 - 999999 3.5%

#------------------------------------------------------------------------------
# http://www.rubydoc.info/github/jeremyevans/sequel
# http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html
# --------------------------------------------------

# Array with table names used by the import program
ImportTables = [:IACCXPRO,:IBPA,:ICOLORS,:ICONTR,:ICORPET,:IMOLS,:IOPTIONS,:IPRICE,:IPROD,:IQTYVOL,:IREMITOR,:ISPECTER,:IZONE,:IFABRICS,:IMSG,:IPHOTO]

def delete_sip_tables
	puts "Delete SIP Tables? (Y/N)".colorize(:green)
	if gets.to_s.upcase.include? 'Y'
		ImportTables.each { |i_table| DB.drop_table?(i_table) }
	end
end


# Removes entries that are not distinct on
# contract number
# manufacture part number
# manufacture name
def deduplicate_table(db, table, columns)
	puts "Removing Duplicates from #{table}"
	db.create_table!(:t1, :as => db[table].distinct(columns))#:temp=>true
	db.create_table!(table, :as => db[:t1])
	puts "Duplicates Removed from #{table}"
end



DB.create_table?(:ICOLORS) do
	column :CONTNUM      ,String,           size: 12               ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40               ,null: false      #   Manufacturer part number. Must be found in Product table.
	column :MFGNAME      ,String,           size: 40               ,null: false      #   Manufacturer name. Must be found in Product table.
end

# ======================================================================================================================
# Link for accessories to products -------------------------------------------------------------------------------------

DB.create_table?(:IACCXPRO) do
	column :CONTNUM    ,String,   size: 12    ,null: false          # CONTNUM
	column :MFGPART    ,String,   size: 40    ,null: false          # Manufacturer part number. Must be found in Product table. Cannot equal accpart.
	column :PROD_MFR   ,String,   size: 40    ,null: false          # Product Manufacturer name. Must be found in Product table.
	column :ACCPART    ,String,   size: 40    ,null: false          # Accessory part number. Must be found in Product table. Cannot equal mfgpart.
	column :ACC_MFR    ,String,   size: 40    ,null: false          # Accessory Manufacturer name. Must be found in Product table.
end


# BPA Price and quantity/volume discount information table ------------------------------------------------------------------------------

DB.create_table?(:IBPA) do
	column :CONTNUM      ,String,            size: 12     ,null: false # Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,            size: 40     ,null: false # Manufacturer part number. In PROD.TXT.
	column :MFGNAME      ,String,            size: 40     ,null: false # Manufacturer name. Must be found in Product table.
	column :BPANUM       ,String,            size: 30     ,null: false # BPA number.
	column :BLIN         ,String,            size: 10     ,null: true  # BPA line item number from BPA document. Else blank.
	column :BPAPRICE     ,BigDecimal,       size: [15,4] ,null: false # BPA price.
	column :MLP          ,BigDecimal,       size: [12,4] ,null: false # GSA Price or Manufacturer List price if no GSA price.
	column :DISC_TYPE    ,Integer,          size: 1      ,null: false # Discount type. 0= no volume discounts offered. 1= volume discounts are by quantity range. 2= discount ranges are by dollar range.
	
	column :ST_RANGE1    ,Integer,          size: 8      ,null: true  # Beginning range for the first break. If DISC_TYPE =1 then it must be greater than 1. If DISC_TYPE=2 then it must be greater than the BPAPRICE. If DISC_TYPE=0 then it must be 0.
	column :END_RANGE1   ,Integer,          size: 8      ,null: true  # Ending range for the first break. It must be greater than the beginning range.
	column :PR_BREAK1    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the first break.
	column :DISC_PCT1    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the first break.
	
	column :ST_RANGE2    ,Integer,          size: 8      ,null: true  # Beginning range for the 2nd break. It must be 1 greater than the previous ending range.
	column :END_RANGE2   ,Integer,          size: 8      ,null: true  # Ending range for the 2nd break. It must be greater than the beginning range.
	column :PR_BREAK2    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the 2nd break. It must be less than the previous break.
	column :DISC_PCT2    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the 2nd break. It must be greater than the previous break.
	
	column :ST_RANGE3    ,Integer,          size: 8      ,null: true  # Beginning range for the 3rd break. It must be 1 greater than the previous ending range.
	column :END_RANGE3   ,Integer,          size: 8      ,null: true  # Ending range for the 3rd break. It must be greater than the beginning range.
	column :PR_BREAK3    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the 3rd break. It must be less than the previous break.
	column :DISC_PCT3    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the 3rd break. It must be greater than the previous break.
	
	column :ST_RANGE4    ,Integer,          size: 8      ,null: true  # Beginning range for the 4th break. It must be 1 greater than the previous ending range.
	column :END_RANGE4   ,Integer,          size: 8      ,null: true  # Ending range for the 4th break. It must be greater than the beginning range.
	column :PR_BREAK4    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the 4th break. It must be less than the previous break.
	column :DISC_PCT4    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the 4th break. It must be greater than the previous break.
	
	column :ST_RANGE5    ,Integer,          size: 8      ,null: true  # Beginning range for the 5th break. It must be 1 greater than the previous ending range.
	column :END_RANGE5   ,Integer,          size: 8      ,null: true  # Ending range for the 5th break. It must be greater than the beginning range.
	column :PR_BREAK5    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the 5th break. It must be less than the previous break.
	column :DISC_PCT5    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the 5th break. It must be greater than the previous break.
	
	column :ST_RANGE6    ,Integer,          size: 8      ,null: true  # Beginning range for the 6th break. It must be 1 greater than the previous ending range.
	column :END_RANGE6   ,Integer,          size: 8      ,null: true  # Ending range for the 6th break. It must be greater than the beginning range.
	column :PR_BREAK6    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the 6th break. It must be less than the previous break.
	column :DISC_PCT6    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the 6th break. It must be greater than the previous break.
	
	column :ST_RANGE7    ,Integer,          size: 8      ,null: true  # Beginning range for the 7th break. It must be 1 greater than the previous ending range.
	column :END_RANGE7   ,Integer,          size: 8      ,null: true  # Ending range for the 7th break. It must be greater than the beginning range.
	column :PR_BREAK7    ,BigDecimal,       size: [12,4] ,null: true  # Discount BPA price for the 7th break. It must be less than the previous break.
	column :DISC_PCT7    ,Float,            size: [6,4]  ,null: true  # Percentage off of the regular BPA price for the 7th break. It must be greater than the previous break.
end

# Color information for product ------------------------------------------------------------------------------

DB.create_table?(:ICOLORS) do
	column :CONTNUM      ,String,           size: 12               ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40               ,null: false      #   Manufacturer part number. Must be found in Product table.
	column :MFGNAME      ,String,           size: 40               ,null: false      #   Manufacturer name. Must be found in Product table.
	column :COLOR        ,String,           size: 40               ,null: false      #   Color. Must be unique.
end


# Contract information table ------------------------------------------------------------------------------

DB.create_table?(:ICONTR) do
	column :CONTNUM      ,String,           size: 12               ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 'for VA contract), unique.
	column :SCHEDCAT     ,String,           size: 10               ,null: false      #   Schedule category number.
	column :A_NAME       ,String,           size: 35               ,null: false      #   Contract administrator name.
	column :A_PHONE      ,String,           size: 30               ,null: false      #   Contract administrator phone number. Must be numbers.
	column :A_FAX        ,String,           size: 30               ,null: false      #   Contract administrator fax number. Must be numbers.
	column :C_DELIV      ,Integer,          size: 8                ,null: false      #   Number of days for contract delivery.  < 999 days.
	column :MIN_ORD      ,BigDecimal,       size: [12,4]           ,null: false      #   Minimum dollar order that is authorized.
	column :PRMPT_DISC   ,Float,            size: [8,4]            ,null: true       #   Prompt payment discount as a percentage value.  >0 if PRMPT_PAY, < 100.00.
	column :PRMPT_DAYS   ,Integer,          size: 3                ,null: true       #   Number of days considered to be prompt payment.  >0 if PRMPT_PAY, < 31.
	column :PPOINT       ,String,           size: 2                ,null: false      #   Production point country code. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
	column :PPOINT2      ,String,           size: 2                ,null: true       #   Second production point country code. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
	column :FOB_AK       ,String,           size: 1                ,null: false      #   Freight-on-board for Alaska. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery.
	column :FOB_HI       ,String,           size: 1                ,null: false      #   Freight-on-board for Hawaii. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery
	column :FOB_PR       ,String,           size: 1                ,null: false      #   Freight-on-board for Puerto Rico. ‘D’- destination. ‘O’ – origin buyer pays shipping cost), ‘N’-no delivery.
	column :FOB_US       ,String,           size: 1                ,null: false      #   Freight-on-board for CONUS. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘W’-worldwide (CONUS= dest, outside CONUS = origin.
	column :EFF_DATE     ,Date                                     ,null: false      #   Catalog effective start date.
	column :WARNUMBER    ,String,           size: 3                ,null: false      #   Time period for warranty. Must be between 1 and 999. 0 if warperiod is 'NONE', 'LIFE', 'STND'.
	column :WARPERIOD    ,String,           size: 5                ,null: false      #   Unit of time for warranty. Value should be 'DAY', 'WEEK', 'MONTH', 'YEAR', 'NONE', 'LIFE' or 'STND'.
	column :REV_NUM      ,String,           size: 6                ,null: false      #   Revision number.
	column :CAT_MODS     ,String,           size: 30               ,null: true       #    Modification number for the contract, if any.
	column :LEADTIME     ,String,           size: 2                ,null: false      #   Code to explain C_DELIV. 'AF' for time delivered after receipt of order, 'AE' for time shipped after receipt, 'AX' for award date to completion date.
	column :A_EMAIL      ,String,           size: 80               ,null: false      #   Contract administrator e-mail address.
	column :REF_FILE     ,String,           size: 80               ,null: true       #    File name of reference file which can be attached to contract to describe products under it.
end

# Vendor information table -------------------------------------------------------------------------------

DB.create_table?(:ICORPET) do
	column :VENDNAME     ,String,           size: 35              ,null: false      #   Vendor name.
	column :DIVISION     ,String,           size: 35              ,null: true       #    Corporate/division name.
	column :V_STR1       ,String,           size: 35              ,null: false      #   Corporate/division headquarters address 1.
	column :V_STR2       ,String,           size: 35              ,null: true       #    Corporate/division headquarters address 2.
	column :V_CITY       ,String,           size: 30              ,null: false      #   Corporate/division headquarters city.
	column :V_STATE      ,String,           size: 2               ,null: false      #   Corporate/division headquarters state. In SIP help(SIP contents/Import data/SIP lookup tables/State and country code table).
	column :V_CTRY       ,String,           size: 2               ,null: false      #   Corporate/division headquarters country. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
	column :V_ZIP        ,String,           size: 11              ,null: false      #   Corporate/division headquarters zip code.
	column :V_PHONE      ,String,           size: 30              ,null: false      #   Corporate/division headquarters telephone number. Must be numbers.
	column :V_FAX        ,String,           size: 30              ,null: false      #   Corporate/division headquarters fax number. Must be numbers.
	column :V_WWW        ,String,           size: 80              ,null: false      #   Corporate/division headquarters www address. First 7 char = 'http://'.
	column :V_EMAIL      ,String,           size: 80              ,null: false      #   Email address that can accept GSA Advantage purchase order.
	column :PASSWORD     ,String,           size: 30              ,null: false      #   Vendor support center provided password. Given out by the GSA help desk.
	column :DUNS_NO      ,String,           size: 9               ,null: false      #   DUNS number. Must be 9 digits.
end


# Contract Special Item Number (SIN) Table ------------------------------------------------------------------------------

DB.create_table?(:IMOLS) do
	column :CONTNUM      ,String,           size: 12              ,null: false        #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :SIN          ,String,           size: 15              ,null: false        #     Special item number. In help(SIP help contents/Import data/SIP lookup tables/Special item number table) for current SCHEDCAT.
	column :MOL          ,Integer,          size: 8               ,null: false        #     Maximum order limit for special item number. In SIP help(SIP help contents/Import data/SIP lookup tables/Maximum order Limit table) for current SIN.
end


# Product Options (allows you to enter any options, colors, components or upgrades, so that customers may configure a product by selecting from available options)

DB.create_table?(:IOPTIONS) do
	column :CONTNUM      ,String,           size: 12              ,null: false      #     Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40              ,null: false      #     Manufacturer part number. In PROD.TXT
	column :MFGNAME      ,String,           size: 40              ,null: false      #     Manufacturer name of attached product. Must be found in Product table.
	column :OPT_PART     ,String,           size: 40              ,null: false      #     Option part. Must be unique for a product
	column :GROUP        ,String,           size: 20              ,null: false      #     Option group. Name option groups so that similar options can be kept together. For example, if a computer has 3 available monitor sizes (e.g., 14", 15", 17"), each of these monitor options should be grouped together under the group name "monitors."
	column :OPT_CODE     ,String,           size: 1               ,null: false      #     Option code. 'I'-option INCLUDED as feature of product, 'S'-option can be SUBSTITUTED, 'A'-option can be ADDED, or 'O'-None can be selected.
	column :OPT_QTY      ,Integer,          size: 8               ,null: false      #     Option quantity. Must be greater than 0.
	column :OPT_UNIT     ,String,           size: 2               ,null: false      #     Option unit. In SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
	column :OPT_PRICE    ,Float,            size: [15,4]          ,null: false      #     Option price.
	column :OPT_DESC     ,String,           size: 80              ,null: false      #     Option description.
	column :OPT_MFG      ,String,           size: 40              ,null: false      #     Option manufacturer.
	column :IS_DELETED   ,TrueClass                               ,null: true       #      If options is deletable and if Opt_Code is "I".
end
# Product specific price information table ------------------------------------------------------------------------------

DB.create_table?(:IPRICE) do
	column :CONTNUM      ,String,           size: 12              ,null: false       #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40              ,null: false       #   Manufacturer part number. In PROD.TXT.
	column :MFGNAME      ,String,           size: 40              ,null: false       #   Manufacturer name. Must be found in Product table.
	column :GSAPRICE     ,BigDecimal,       size: [12,4]          ,null: false       #   GSA price.
	column :TEMPRICE     ,BigDecimal,       size: [12,4]          ,null: true        #   Temporary GSA price reduction.
	column :TPRSTART     ,Date                                    ,null: true        #   Temporary price start date. Required if TEMPRICE has a value
	column :TPRSTOP      ,Date                                    ,null: true        #   Temporary price end date. Required if TEMPRICE has a value.
	column :MLP          ,BigDecimal,       size: [12,4]          ,null: false       #   Manufacturer list price.
	column :ZONE_NUM     ,String,           size: 2               ,null: false       #   Zone number to which price applies. Zones are assigned at IZONE. '00' If there are no zones.
end


# Product Information Table ------------------------------------------------------------------------------
DB.create_table?(:IPROD) do
	column :CONTNUM      ,String,           size: 12             ,null: false     # Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40             ,null: false     # Manufacturer part number. Must be unique for a contract.
	column :MFGNAME      ,String,           size: 40             ,null: false     # Manufacturer name.
	column :PRODNAME     ,String,           size: 40             ,null: false     # Product name.
	column :VENDPART     ,String,           size: 40             ,null: true      # Vendor part number.
	column :PRODDESC     ,String,           size: 250            ,null: false     # product description.
	column :PRODDESC2    ,String,           size: 250            ,null: true      # Second description. Not until PRODDESC is full.
	column :PRODDESC3    ,String,           size: 250            ,null: true      # Third description. Not until PRODDESC2 is full.
	column :PRODDESC4    ,String,           size: 250            ,null: true      # Forth description. Not until PRODDESC3 is full.
	column :NSN          ,String,           size: 16             ,null: true      # National stock number. Format '9999-99-999-9999'.
	column :VALUE1       ,Float,            size: [13,4]         ,null: true      # Dimension value 1. Required if UNIT1 has a value.
	column :VALUE2        ,Float,           size: [13,4]         ,null: true      # Dimension value 2. Required if UNIT2 has a value.
	column :VALUE3       ,Float,            size: [13,4]         ,null: true      # Dimension value 3. Required if UNIT3 has a value.
	column :DVOLUME      ,Float,            size: [14,4]         ,null: true      # Dimension volume. Only used if FOB = 'O'
	column :D_VUNIT      ,String,           size: 2              ,null: true      # Dimension unit volume. Only used if FOB = 'O'. Always "CF" cubic feet.
	column :ISSCODE      ,String,           size: 2              ,null: false     # Unit of issue code. SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
	column :QTY_UNIT     ,String,           size: 12             ,null: true      # Quantity per unit package. Required if ISSFLAG=.T. ISSFLAG is in ILISSUE lookup table.
	column :QP_UNIT      ,String,           size: 2              ,null: true      # Quantity of product per unit package. Required if ISSFLAG=.T. in SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
	column :STDPACK      ,String,           size: 20             ,null: true      # Standard package size.
	column :WEIGHT       ,Float,            size: [14,4]         ,null: true      # Weight of product.
	column :SIN          ,String,           size: 15             ,null: false     # Special item number. In . SIP help(SIP help contents/Import data/SIP lookup tables/Special item number table) and in related SCHEDCAT.
	column :PPOINT       ,String,           size: 2              ,null: false     # Production point country code. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table)
	column :INCR_OF      ,String,           size: 20             ,null: true      # Increments that products can be purchased in
	column :P_WWW        ,String,           size: 80             ,null: true      # WWW address for this specific product. First 7 char = 'http://'.
	column :WARNUMBER    ,String,           size: 3              ,null: false     # Time period for warranty. Must be between 1 and 999. 0 if warperiod is 'NONE', 'LIFE', 'STND'.
	column :WARPERIOD    ,String,           size: 5              ,null: false     # Unit of time for warranty. Value should be 'DAY', 'WEEK', 'MONTH', 'YEAR', 'NONE', 'LIFE' or 'STND'.
	column :P_DELIV      ,Float,            size: [8,0]          ,null: false     # Product delivery.  < 999 days.
	column :LEADTIME     ,String,           size: 2              ,null: false     # Code to explain P_DELIV. 'AF' for time delivered after receipt of order, 'AE' for time shipped after receipt, 'AX' for award date to completion date.
	column :UNIT1        ,String,           size: 2              ,null: true      # Dimension unit 1. Required if there is a value in VALUE1. in . SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
	column :UNIT2        ,String,           size: 2              ,null: true      # Dimension unit 2. Required if there is a value in VALUE2. in . SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
	column :UNIT3        ,String,           size: 2              ,null: true      # Dimension unit 3. Required if there is a value in VALUE3. in . SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
	column :TYPE1        ,String,           size: 2              ,null: true      # Dimension type 1. Required if UNIT1 or VALUE1 has a value. Must be 'LN'.
	column :TYPE2        ,String,           size: 2              ,null: true      # Dimension type 2. Required if UNIT2 or VALUE2 has a value. Must be 'WD'.
	column :TYPE3        ,String,           size: 2              ,null: true      # Dimension type 3. Required if UNIT3 or VALUE3 has a value. Must be 'HT'.
	column :ITEMTYPE     ,String,           size: 1              ,null: false     # Item type. Must be 'P' or 'A'. P=Product, A=Accessory.
	column :UPC		 ,String,           size: 14             ,null: false     # UPC must be12 digits (you may enter 11 and will assume UPC has leading zero).  You may enter EAN8, EAN13, GTIN14, or ISBN13 (for books) if you use these identifiers instead of a UPC.  ISBN13 must start with 978 or 979.  You may pad any of these identifies with zero(s) to make a 14 digit GTIN. *UPC required for some SINs. See SIP Help for SINs requiring UPC for associated products (SIP contents/Import data/SIP lookup tables/ Special item number table).
	column :UNSPSC       ,String,           size: 8              ,null: true      # UNSPSC must be 8 digits all numeric and not start with 0.
	column :FOB_AK       ,String,           size: 1              ,null: false     # Freight-on-board for Alaska. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery.
	column :FOB_HI       ,String,           size: 1              ,null: false     # Freight-on-board for Hawaii. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery.
	column :FOB_PR       ,String,           size: 1              ,null: false     # Freight-on-board for Puerto Rico. ‘D’- destination. ‘O’ – origin buyer pays shipping cost), ‘N’-no delivery
	column :FOB_US       ,String,           size: 1              ,null: false     # Freight-on-board for CONUS. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘W’-worldwide (CONUS= dest, outside CONUS = origin.
	column :PSC_CODE	 ,String,           size: 4              ,null: true      # Product Service Code. Must be 4 characters and can only contain letters and numbers.
end

# Product quantity/volume discount information table ------------------------------------------------------------------------------
DB.create_table?(:IQTYVOL) do
	column :CONTNUM      ,String,           size: 12            ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40            ,null: false      #   Manufacturer part number. In PROD.TXT.
	column :MFGNAME      ,String,           size: 40            ,null: false      #   Manufacturer name. Must be found in Product table.
	column :BREAK1       ,BigDecimal,       size: [12,4]        ,null: false      #   Discount GSA price for the first break. If not temp discount record.
	column :DISC_PCT1    ,Float,            size: [8,4]         ,null: false      #   Percentage off of the regular GSA price for the first break.
	column :RANGE1       ,Float,            size: [8,0]         ,null: false      #   Beginning range for the first break. If IS_QTY='Y' then it must be greater than 1. If IS_QTY=’N’ then it must be greater than the GSAPRICE.
	column :ENDRANGE1    ,Float,            size: [8,0]         ,null: false      #   Ending range for the first break. It must be greater than the beginning range.
	column :BREAK2       ,BigDecimal,       size: [12,4]        ,null: true       #   Discount GSA price for the 2nd break. It must be less than the previous break.
	column :DISC_PCT2    ,Float,            size: [8,4]         ,null: true       #   Percentage off of the regular GSA price for the 2nd break. It must be greater than the previous break.
	column :RANGE2       ,Float,            size: [8,0]         ,null: true       #   Beginning range for the 2nd break. It must be 1 greater than the previous ending range.
	column :ENDRANGE2    ,Float,            size: [8,0]         ,null: true       #   Ending range for the 2nd break. It must be greater than the beginning range.
	column :BREAK3       ,BigDecimal,       size: [12,4]        ,null: true       #   Discount GSA price for the 3rd break. It must be less than the previous break.
	column :DISC_PCT3    ,Float,            size: [8,4]         ,null: true       #   Percentage off of the regular GSA price for the 3rd break. It must be greater than the previous break.
	column :RANGE3       ,Float,            size: [8,0]         ,null: true       #   Beginning range for the 3rd break. It must be 1 greater than the previous ending range.
	column :ENDRANGE3    ,Float,            size: [8,0]         ,null: true       #   Ending range for the 3rd break. It must be greater than the beginning range.
	column :BREAK4       ,BigDecimal,       size: [12,4]        ,null: true       #   Discount GSA price for the 4th break. It must be less than the previous break.
	column :DISC_PCT4    ,Float,            size: [8,4]         ,null: true       #   Percentage off of the regular GSA price for the 4th break. It must be greater than the previous break.
	column :RANGE4       ,Float,            size: [8,0]         ,null: true       #   Beginning range for the 4th break. It must be 1 greater than the previous ending range.
	column :ENDRANGE4    ,Float,            size: [8,0]         ,null: true       #   Ending range for the 4th break. It must be greater than the beginning range.
	column :BREAK5       ,BigDecimal,       size: [12,4]        ,null: true       #   Discount GSA price for the 5th break. It must be less than the previous break.
	column :DISC_PCT5    ,Float,            size: [8,4]         ,null: true       #   Percentage off of the regular GSA price for the 5th break. It must be greater than the previous break.
	column :RANGE5       ,Float,            size: [8,0]         ,null: true       #   Beginning range for the 5th break. It must be 1 greater than the previous ending range.
	column :ENDRANGE5    ,Float,            size: [8,0]         ,null: true       #   Ending range for the 5th break. It must be greater than the beginning range.
	column :BREAK6       ,BigDecimal,       size: [12,4]        ,null: true       #   Discount GSA price for the 6th break. It must be less than the previous break.
	column :DISC_PCT6    ,Float,            size: [8,4]         ,null: true       #   Percentage off of the regular GSA price for the 6th break. It must be greater than the previous break.
	column :RANGE6       ,Float,            size: [8,0]         ,null: true       #   Beginning range for the 6th break. It must be 1 greater than the previous ending range.
	column :ENDRANGE6    ,Float,            size: [8,0]         ,null: true       #   Ending range for the 6th break. It must be greater than the beginning range.
	column :BREAK7       ,BigDecimal,       size: [12,4]        ,null: true       #   Discount GSA price for the 7th break. It must be less than the previous break.
	column :DISC_PCT7    ,Float,            size: [8,4]         ,null: true       #   Percentage off of the regular GSA price for the 7th break. It must be greater than the previous break.
	column :RANGE7       ,Float,            size: [8,0]         ,null: true       #   Beginning range for the 7th break. It must be 1 greater than the previous ending range.
	column :ENDRANGE7    ,Float,            size: [8,0]         ,null: true       #   Ending range for the 7th break. It must be greater than the beginning range.
	column :QMSG         ,String,           size: 80            ,null: true       #    Enter any terms applicable to quantity discounts.
	column :IS_QTY       ,String,           size: 1             ,null: false      #   ,null: false      #/no field. ‘Y’ if discounts are based on the quantity of the product purchased. ‘N’ if discounts are based on the total purchase price of the product.
	column :IS_TEMP      ,String,           size: 1             ,null: false      #   ,null: false      #/no field. Is this a temporary price? Must be 'Y' or 'N'.
	column :ZONE_NUM     ,String,           size: 2             ,null: false      #   Zone number. Zone to which the price applies. (Zones are assigned at IZONE.) '00' if there are no zones.
end


# Contract order address information table ------------------------------------------------------------------------------

DB.create_table?(:IREMITOR) do
	column :CONTNUM      ,String,           size: 12           ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :R_NAME       ,String,           size: 35           ,null: false      #   Contact name for order address.
	column :R_STR1       ,String,           size: 35           ,null: false      #   Street address for order address.
	column :R_STR2       ,String,           size: 35           ,null: true       #    Street address 2 for order address.
	column :R_CITY       ,String,           size: 30           ,null: false      #   City for order address.
	column :R_STATE      ,String,           size: 2            ,null: false      #   State for order address. In SIP help(SIP contents/Import data/SIP lookup tables/State and country code table).
	column :R_CTRY       ,String,           size: 2            ,null: false      #   Country for remittance order. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
	column :R_ZIP        ,String,           size: 11           ,null: false      #   Zip code for order address.
	column :R_PHONE      ,String,           size: 30           ,null: false      #   Telephone number for order address. Must be numbers.
	column :R_FAX        ,String,           size: 30           ,null: false      #   Fax number for order address. Must be numbers.
	column :R_EMAIL      ,String,           size: 80           ,null: false      #   Send orders to this email address.
end


# Product/contract special terms & conditions table ------------------------------------------------------------------------------

DB.create_table?(:ISPECTER) do
	column :CONTNUM      ,String,           size: 12           ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :SPECNAME     ,String,           size: 25           ,null: false      #   Special term name. In . SIP help(SIP help contents/Import data/SIP lookup tables/Special charges table).
	column :CHARGE       ,BigDecimal,       size: [12,4]       ,null: false      #   Special term charge.
	column :SPECDESC     ,String,           size: 80           ,null: true       #    Special term description.
	column :S_PER        ,String,           size: 2            ,null: false      #   Unit of special term measurement. SIP help(SIP contents/Import data/SIP lookup tables/unit of issue table).
end


# Contract Zone table. If prices vary by geographic zone, assign zone numbers to each state, up to 10 zones, numbered 1-10. AK, HI, PR and VI must >= 0. All others > 0.-----------------------

DB.create_table?(:IZONE) do
	column :CONTNUM      ,String,           size: 12           ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :AK           ,Integer,          size: 2            ,null: true       #    Alaska zone number. Required if you have zones.
	column :AL           ,Integer,          size: 2            ,null: true       #    Alabama zone number. Required if you have zones.
	column :AR           ,Integer,          size: 2            ,null: true       #    Arkansas zone number. Required if you have zones.
	column :AZ           ,Integer,          size: 2            ,null: true       #    Arizona zone number. Required if you have zones.
	column :CA           ,Integer,          size: 2            ,null: true       #    California zone number. Required if you have zones.
	column :CO           ,Integer,          size: 2            ,null: true       #    Colorado zone number. Required if you have zones.
	column :CT           ,Integer,          size: 2            ,null: true       #    Connecticut zone number. Required if you have zones.
	column :DC           ,Integer,          size: 2            ,null: true       #    District of Colombia zone number. Required if you have zones.
	column :DE           ,Integer,          size: 2            ,null: true       #    Delaware zone number. Required if you have zones.
	column :FL           ,Integer,          size: 2            ,null: true       #    Florida zone number. Required if you have zones.
	column :GA           ,Integer,          size: 2            ,null: true       #    Georgia zone number. Required if you have zones.
	column :HI           ,Integer,          size: 2            ,null: true       #    Hawaii zone number. Required if you have zones.
	column :IA           ,Integer,          size: 2            ,null: true       #    Iowa zone number. Required if you have zones.
	column :ID           ,Integer,          size: 2            ,null: true       #    Idaho zone number. Required if you have zones.
	column :IL           ,Integer,          size: 2            ,null: true       #    Illinois zone number. Required if you have zones.
	column :IN           ,Integer,          size: 2            ,null: true       #    Indiana zone number. Required if you have zones.
	column :KS           ,Integer,          size: 2            ,null: true       #    Kansas zone number. Required if you have zones.
	column :KY           ,Integer,          size: 2            ,null: true       #    Kentucky zone number. Required if you have zones
	column :LA           ,Integer,          size: 2            ,null: true       #    Louisiana zone number. Required if you have zones.
	column :MA           ,Integer,          size: 2            ,null: true       #    Massachusetts zone number. Required if you have zones.
	column :MD           ,Integer,          size: 2            ,null: true       #    Maryland zone number. Required if you have zones.
	column :ME           ,Integer,          size: 2            ,null: true       #    Maine zone number. Required if you have zones.
	column :MI           ,Integer,          size: 2            ,null: true       #    Michigan zone number. Required if you have zones.
	column :MN           ,Integer,          size: 2            ,null: true       #    Minnesota zone number. Required if you have zones.
	column :MO           ,Integer,          size: 2            ,null: true       #    Missouri zone number. Required if you have zones.
	column :MS           ,Integer,          size: 2            ,null: true       #    Mississippi zone number. Required if you have zones.
	column :MT           ,Integer,          size: 2            ,null: true       #    Montana zone number. Required if you have zones.
	column :NC           ,Integer,          size: 2            ,null: true       #    North Carolina zone number. Required if you have zones.
	column :ND           ,Integer,          size: 2            ,null: true       #    North Dakota zone number. Required if you have zones.
	column :NE           ,Integer,          size: 2            ,null: true       #    Nebraska zone number. Required if you have zones.
	column :NH           ,Integer,          size: 2            ,null: true       #    New Hampshire zone number. Required if you have zones.
	column :NJ           ,Integer,          size: 2            ,null: true       #    New Jersey zone number. Required if you have zones.
	column :NM           ,Integer,          size: 2            ,null: true       #    New Mexico zone number. Required if you have zones.
	column :NV           ,Integer,          size: 2            ,null: true       #    Nevada zone number. Required if you have zones.
	column :NY           ,Integer,          size: 2            ,null: true       #    New York zone number. Required if you have zones.
	column :OH           ,Integer,          size: 2            ,null: true       #    Ohio zone number. Required if you have zones.
	column :OK           ,Integer,          size: 2            ,null: true       #    Oklahoma zone number. Required if you have zones.
	column :OR           ,Integer,          size: 2            ,null: true       #    Oregon zone number. Required if you have zones.
	column :PA           ,Integer,          size: 2            ,null: true       #    Pennsylvania zone number. Required if you have zones.
	column :PR           ,Integer,          size: 2            ,null: true       #    Puerto Rico zone number. Required if you have zones.
	column :RI           ,Integer,          size: 2            ,null: true       #    Rhode Island zone number. Required if you have zones.
	column :SC           ,Integer,          size: 2            ,null: true       #    South Carolina zone number. Required if you have zones.
	column :SD           ,Integer,          size: 2            ,null: true       #    south Dakota zone number. Required if you have zones.
	column :TN           ,Integer,          size: 2            ,null: true       #    Tennessee zone number. Required if you have zones.
	column :TX           ,Integer,          size: 2            ,null: true       #    Texas zone number. Required if you have zones.
	column :UT           ,Integer,          size: 2            ,null: true       #    Utah zone number. Required if you have zones.
	column :VA           ,Integer,          size: 2            ,null: true       #    Virginia zone number. Required, if you have zones.
	column :VI           ,Integer,          size: 2            ,null: true       #    Virgin Islands zone number. Required if you have zones.
	column :VT           ,Integer,          size: 2            ,null: true       #    Vermont zone number. Required if you have zones.
	column :WA           ,Integer,          size: 2            ,null: true       #    Washington zone number. Required if you have zones.
	column :WI           ,Integer,          size: 2            ,null: true       #    Wisconsin zone number. Required if you have zones.
	column :WV           ,Integer,          size: 2            ,null: true       #    West Virginia zone number. Required if you have zones.
	column :WY           ,Integer,          size: 2            ,null: true       #    Wyoming zone number. Required if you have zones.
end

# Fabric information for contract. If many of your products have fabrics choices, this table is useful. ------------------------------------
DB.create_table?(:IFABRICS) do
	column :CONTNUM      ,String,           size: 12           ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :FABTYPE      ,String,           size: 15           ,null: false      #   Fabric type.
	column :COLOR        ,String,           size: 40           ,null: false      #   Color.
	column :COLOR_NUM    ,String,           size: 40           ,null: false      #   Color number.
end

# Environmental message information for product. ------------------------------------------------------------------------------

DB.create_table?(:IMSG) do
	column :CONTNUM      ,String,           size: 12           ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40           ,null: false      #   Manufacturer part number. In PROD.TXT.
	column :MFGNAME      ,String,           size: 40           ,null: false      #   Manufacturer name. Must be found in Product table.
	column :EMSGCODE     ,String,           size: 2            ,null: false      #   Environmental message code. SIP help(SIP help contents/Import data/SIP lookup tables/Environmental Message Table).
	column :RECYCLED     ,String,           size: 80           ,null: true       #   Recycled content for mfrpart. Example: Contains 50% recovered meterial which includes 20% post consumer meterial.
	column :URL          ,String,           size: 80           ,null: true       #   URL having Section 508 accessibility info for this product
	column :SCANCODE     ,String,           size: 40           ,null: true       #   Scan code related to GSA Parallel Contracting program.
	column :HAZMAT       ,String,           size: 6            ,null: true       #   Item has hazardous material. Enter United Nations Identification Number (UNID). First two characters must start with UN or NA or enter “MSDS” in the first 4 positions.
end


# photo information for product ------------------------------------------------------------------------------

DB.create_table?(:IPHOTO) do
	column :CONTNUM      ,String,           size: 12           ,null: false      #   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
	column :MFGPART      ,String,           size: 40           ,null: false      #   Manufacturer part number. Must be found in Product table.
	column :MFGNAME      ,String,           size: 40           ,null: false      #   Manufacturer name. Must be found in Product table.
	column :DEF_PHOTO    ,String,           size: 80           ,null: false      #    Filename of first photo. This is the default photo that will be shown with product/accessory. This should be the largest and best photo.*DEF_PHOTO required for some SINs.  See SIP Help for SINs requiring DEF_PHOTO for associated products (SIP contents/Import data/SIP lookup tables/ Special item number table)
	column :PHOTO2       ,String,           size: 80           ,null: true       #    Filename of second photo.
	column :PHOTO3       ,String,           size: 80           ,null: true       #    Filename of third photo.
	column :PHOTO4       ,String,           size: 80           ,null: true       #    filename of fourth photo.
end