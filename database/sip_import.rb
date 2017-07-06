# IMPORT FILES SETUP AND TEST REQUIREMENTS
#
# THE IBPA TABLE CAN NOW BE IMPORTED WITHIN SIP IMPORT!!!
#
# If a field is a number it must conform the setup ie. 8.2 must
# look like '12345.78'.  Only numbers and a period at the proper place can
# be allowed. fields without a decimal or decimal = 0 should not have a
# decimal in the string ie. 8.0 must look like '12345678'.
#
# If a field is required, a value must be entered.
#
# *****MFGNAME field was added to iprice, iqtyvol,.imsg, iaccxpro, ibpa, icolors, iphoto, and ioptions tables*****
#
# If a field is a boolean, it must be 'Y', 'N', 'T', or 'F'.
#
# If a field is a date, it must be in the format 'MM/DD/YY' or 'MM/DD/YYYY'
#
# If a field is a character field, the system will automatically change all the alpha characters to upper case.  The only exception should be the WWW address, E-mail address, and Product/Accessory Description.
#
# * Note for importing excel files: ' " ' can not be used in import data. Cell formatting is not required.
#
# * Note: The ' ~ ' character at the end of each file is required for text files only. It does not apply to excel or dbf files.

#COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
#------------------------------------------------------------------------------
# IACCXPRO   Link for accessories to products
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13- 52   MFGPART      Text   40    Yes   Manufacturer part number. Must be found in Product table. Cannot equal accpart.
#  53- 92   PROD_MFR     Text   40    Yes   Product Manufacturer name. Must be found in Product table.
#  93- 132  ACCPART      Text   40    Yes   Accessory part number. Must be found in Product table. Cannot equal mfgpart.
#  133-172  ACC_MFR      Text   40    Yes   Accessory Manufacturer name. Must be found in Product table.
#  173      '~'                       Yes
#
#
#  COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IBPA  BPA Price and quantity/volume discount information table
#
#  1 -12    CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13-52    MFGPART      Text   40    Yes   Manufacturer part number. In PROD.TXT.
#  53-92    MFGNAME      Text   40    Yes   Manufacturer name. Must be found in Product table.
#  93-122   BPANUM       Text   30    Yes   BPA number.
# 123-132   BLIN         Text   10    No    BPA line item number from BPA document. Else blank.
# 133-149   BPAPRICE     Numb   17.4  Yes   BPA price.
# 150-166   MLP          Numb   17.4  Yes   GSA Price or Manufacturer List price if no GSA price.
# 167-167   DISC_TYPE    Numb   1     Yes   Discount type. 0= no volume discounts offered. 1= volume discounts are by quantity range. 2= discount ranges are by dollar range.
#
# 168-175   ST_RANGE1    Numb   8     No    Beginning range for the first break. If DISC_TYPE =1 then it must be greater than 1. If DISC_TYPE=2 then it must be greater than the BPAPRICE. If DISC_TYPE=0 then it must be 0.
# 176-183   END_RANGE1   Numb   8     No    Ending range for the first break. It must be greater than the beginning range.
# 184-200   PR_BREAK1    Numb   17.4  No    Discount BPA price for the first break.
# 201-208   DISC_PCT1    Numb   8.4   No    Percentage off of the regular BPA price for the first break.
#
# 209-216   ST_RANGE2    Numb   8     No    Beginning range for the 2nd break. It must be 1 greater than the previous ending range.
# 217-224   END_RANGE2   Numb   8     No    Ending range for the 2nd break. It must be greater than the beginning range.
# 225-241   PR_BREAK2    Numb   17.4  No    Discount BPA price for the 2nd break. It must be less than the previous break.
# 242-249   DISC_PCT2    Numb   8.4   No    Percentage off of the regular BPA price for the 2nd break. It must be greater than the previous break.
#
# 250-257   ST_RANGE3    Numb   8     No    Beginning range for the 3rd break. It must be 1 greater than the previous ending range.
# 258-265   END_RANGE3   Numb   8     No    Ending range for the 3rd break. It must be greater than the beginning range.
# 266-282   PR_BREAK3    Numb   17.4  No    Discount BPA price for the 3rd break. It must be less than the previous break.
# 283-290   DISC_PCT3    Numb   8.4   No    Percentage off of the regular BPA price for the 3rd break. It must be greater than the previous break.
#
# 291-298   ST_RANGE4    Numb   8     No    Beginning range for the 4th break. It must be 1 greater than the previous ending range.
# 299-306   END_RANGE4   Numb   8     No    Ending range for the 4th break. It must be greater than the beginning range.
# 307-323   PR_BREAK4    Numb   17.4  No    Discount BPA price for the 4th break. It must be less than the previous break.
# 324-331   DISC_PCT4    Numb   8.4   No    Percentage off of the regular BPA price for the 4th break. It must be greater than the previous break.
#
# 332-339   ST_RANGE5    Numb   8     No    Beginning range for the 5th break. It must be 1 greater than the previous ending range.
# 340-347   END_RANGE5   Numb   8     No    Ending range for the 5th break. It must be greater than the beginning range.
# 348-364   PR_BREAK5    Numb   17.4  No    Discount BPA price for the 5th break. It must be less than the previous break.
# 365-372   DISC_PCT5    Numb   8.4   No    Percentage off of the regular BPA price for the 5th break. It must be greater than the previous break.
#
# 373-380   ST_RANGE6    Numb   8     No    Beginning range for the 6th break. It must be 1 greater than the previous ending range.
# 381-388   END_RANGE6   Numb   8     No    Ending range for the 6th break. It must be greater than the beginning range.
# 389-405   PR_BREAK6    Numb   17.4  No    Discount BPA price for the 6th break. It must be less than the previous break.
# 406-413   DISC_PCT6    Numb   8.4   No    Percentage off of the regular BPA price for the 6th break. It must be greater than the previous break.
#
# 414-421   ST_RANGE7    Numb   8     No    Beginning range for the 7th break. It must be 1 greater than the previous ending range.
# 422-429   END_RANGE7   Numb   8     No    Ending range for the 7th break. It must be greater than the beginning range.
# 430-446   PR_BREAK7    Numb   17.4  No    Discount BPA price for the 7th break. It must be less than the previous break.
# 447-454   DISC_PCT7    Numb   8.4   No    Percentage off of the regular BPA price for the 7th break. It must be greater than the previous break.
# 455-455   '~'
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# ICOLORS   Color information for product
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13- 52   MFGPART      Text   40    Yes   Manufacturer part number. Must be found in Product table.
#  53- 92   MFGNAME      Text   40    Yes   Manufacturer name. Must be found in Product table.
#  93-132   COLOR        Text   40    Yes   Color. Must be unique.
#  133      '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# ICONTR   Contract information table
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 'for VA contract), unique.
#  13- 22   SCHEDCAT     Text   10    Yes   Schedule category number.
#  23- 57   A_NAME       Text   35    Yes   Contract administrator name.
#  58- 87   A_PHONE      Text   30    Yes   Contract administrator phone number. Must be numbers.
#  88-117   A_FAX        Text   30    Yes   Contract administrator fax number. Must be numbers.
# 118-125   C_DELIV      Numb   8.0   Yes   Number of days for contract delivery.  < 999 days.
# 126-142   MIN_ORD      Numb   17.4  Yes   Minimum dollar order that is authorized.
# 143-150   PRMPT_DISC   Numb   8.4   No    Prompt payment discount as a percentage value.  >0 if PRMPT_PAY, < 100.00.
# 151-153   PRMPT_DAYS   Numb   3     No    Number of days considered to be prompt payment.  >0 if PRMPT_PAY, < 31.
# 154-155   PPOINT       Text   2     Yes   Production point country code. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
# 156-157   PPOINT2      Text   2     No    Second production point country code. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
# 158-128   FOB_AK       Text   1     Yes   Freight-on-board for Alaska. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery.
# 159-159   FOB_HI       Text   1     Yes   Freight-on-board for Hawaii. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery
# 160-160   FOB_PR       Text   1     Yes   Freight-on-board for Puerto Rico. ‘D’- destination. ‘O’ – origin buyer pays shipping cost), ‘N’-no delivery.
# 161-161   FOB_US       Text   1     Yes   Freight-on-board for CONUS. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘W’-worldwide (CONUS= dest, outside CONUS = origin.
# 162-171   EFF_DATE     Date   10    Yes   Catalog effective start date.
# 172-174   WARNUMBER    Text   3     Yes   Time period for warranty. Must be between 1 and 999. 0 if warperiod is 'NONE', 'LIFE', 'STND'.
# 175-179   WARPERIOD    Text   5     Yes   Unit of time for warranty. Value should be 'DAY', 'WEEK', 'MONTH', 'YEAR', 'NONE', 'LIFE' or 'STND'.
# 180-185   REV_NUM      Text   6     Yes   Revision number.
# 186-215   CAT_MODS     Text   30    No    Modification number for the contract, if any.
# 216-217   LEADTIME     Text   2     Yes   Code to explain C_DELIV. 'AF' for time delivered after receipt of order, 'AE' for time shipped after receipt, 'AX' for award date to completion date.
# 218-297   A_EMAIL      Text   80    Yes   Contract administrator e-mail address.
# 298-377   REF_FILE     Text   80    No    File name of reference file which can be attached to contract to describe products under it.
# 378       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# -------------------------------------------------------------------------------
# ICORPET  Vendor information table
#
#   1- 35   VENDNAME     Text   35    Yes   Vendor name.
#  36- 70   DIVISION     Text   35    No    Corporate/division name.
#  71-105   V_STR1       Text   35    Yes   Corporate/division headquarters address 1.
# 106-140   V_STR2       Text   35    No    Corporate/division headquarters address 2.
# 141-170   V_CITY       Text   30    Yes   Corporate/division headquarters city.
# 171-172   V_STATE      Text   2     Yes   Corporate/division headquarters state. In SIP help(SIP contents/Import data/SIP lookup tables/State and country code table).
# 173-174   V_CTRY       Text   2     Yes   Corporate/division headquarters country. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
# 175-185   V_ZIP        Text   11    Yes   Corporate/division headquarters zip code.
# 186-215   V_PHONE      Text   30    Yes   Corporate/division headquarters telephone number. Must be numbers.
# 216-245   V_FAX        Text   30    Yes   Corporate/division headquarters fax number. Must be numbers.
# 246-325   V_WWW        Text   80    Yes   Corporate/division headquarters www address. First 7 char = 'http://'.
# 326-405   V_EMAIL      Text   80    Yes   Email address that can accept GSA Advantage purchase order.
# 406-435   PASSWORD     Text   30    Yes   Vendor support center provided password. Given out by the GSA help desk.
# 436-444   DUNS_NO      Text   9     Yes   DUNS number. Must be 9 digits.
# 445       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IMOLS - Contract Special Item Number (SIN) Table
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
# 13-27    SIN           Text    15      Yes     Special item number. In help(SIP help contents/Import data/SIP lookup tables/Special item number table) for current SCHEDCAT.
# 28-35    MOL           Numb    8.0     Yes     Maximum order limit for special item number. In SIP help(SIP help contents/Import data/SIP lookup tables/Maximum order Limit table) for current SIN.
# 36       '~'                           Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IOPTIONS - Product Options (allows you to enter any options, colors, components or upgrades, so that customers may configure a product by selecting from available options)
#
#  1 -12    CONTNUM      Text    12   Yes     Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13-52    MFGPART      Text    40   Yes     Manufacturer part number. In PROD.TXT
#  53-92    MFGNAME      Text    40   Yes     Manufacturer name of attached product. Must be found in Product table.
#  93-132   OPT_PART     Text    40   Yes     Option part. Must be unique for a product
# 133-152   GROUP        Text    20   Yes     Option group. Name option groups so that similar options can be kept together. For example, if a computer has 3 available monitor sizes (e.g., 14", 15", 17"), each of these monitor options should be grouped together under the group name "monitors."
# 153-153   OPT_CODE     Text    1    Yes     Option code. 'I'-option INCLUDED as feature of product, 'S'-option can be SUBSTITUTED, 'A'-option can be ADDED, or 'O'-None can be selected.
# 154-161   OPT_QTY      Numb    8.0  Yes     Option quantity. Must be greater than 0.
# 162-163   OPT_UNIT     Text    2    Yes     Option unit. In SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
# 164-180   OPT_PRICE    Numb    17.4 Yes     Option price.
# 181-260   OPT_DESC     Text    80   Yes     Option description.
# 261-300   OPT_MFG      Text    40   Yes     Option manufacturer.
# 301-301   IS_DELETED   Y/N     1    No      If options is deletable and if Opt_Code is "I".
# 302       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IPRICE   Product specific price information table
#
#  1 - 12  CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#   13-52  MFGPART      Text   40    Yes   Manufacturer part number. In PROD.TXT.
#   53-92  MFGNAME      Text    40   Yes   Manufacturer name. Must be found in Product table.
#  93-109  GSAPRICE     Numb   17.4  Yes   GSA price.
# 110-126  TEMPRICE     Numb   17.4  No    Temporary GSA price reduction.
# 127-136  TPRSTART     Date   10    No    Temporary price start date. Required if TEMPRICE has a value
# 137-146  TPRSTOP      Date   10    No    Temporary price end date. Required if TEMPRICE has a value.
# 147-163  MLP          Numb   17.4  Yes   Manufacturer list price.
# 164-165  ZONE_NUM     Text   2     Yes   Zone number to which price applies. Zones are assigned at IZONE. '00' If there are no zones.
# 166      '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IPROD - Product Information Table
#
#  1 - 12    CONTNUM      Text   12     Yes     Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#   13-52    MFGPART      Text   40     Yes     Manufacturer part number. Must be unique for a contract.
#   53-92    MFGNAME      Text   40     Yes     Manufacturer name.
#  93-132    PRODNAME     Text   40     Yes     Product name.
# 133-172    VENDPART     Text   40     No      Vendor part number.
# 173-422    PRODDESC     Text   250    Yes     product description.
# 423-672    PRODDESC2    Text   250    No      Second description. Not until PRODDESC is full.
# 673-922    PRODDESC3    Text   250    No      Third description. Not until PRODDESC2 is full.
# 923-1172   PRODDESC4    Text   250    No      Forth description. Not until PRODDESC3 is full.
# 1173-1188  NSN          Text   16     No      National stock number. Format '9999-99-999-9999'.
# 1189-1201  VALUE1       Numb   13.4   No      Dimension value 1. Required if UNIT1 has a value.
# 1202 1214  VALUE2       Numb   13.4   No      Dimension value 2. Required if UNIT2 has a value.
# 1215-1227  VALUE3       Numb   13.4   No      Dimension value 3. Required if UNIT3 has a value.
# 1228-1241  DVOLUME      Numb   14.4   No      Dimension volume. Only used if FOB = 'O'
# 1242-1243  D_VUNIT      Text   2      No      Dimension unit volume. Only used if FOB = 'O'. Always "CF" cubic feet.
# 1244-1245  ISSCODE      Text   2      Yes     Unit of issue code. SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
# 1246-1257  QTY_UNIT     Text   12     No      Quantity per unit package. Required if ISSFLAG=.T. ISSFLAG is in ILISSUE lookup table.
# 1258-1259  QP_UNIT      Text   2      No      Quantity of product per unit package. Required if ISSFLAG=.T. in SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
# 1260-1279  STDPACK      Text   20     No      Standard package size.
# 1280-1293  WEIGHT       Numb   14.4   No      Weight of product.
# 1294-1308  SIN          Text   15     Yes     Special item number. In . SIP help(SIP help contents/Import data/SIP lookup tables/Special item number table) and in related SCHEDCAT.
# 1309-1310  PPOINT       Text   2      Yes     Production point country code. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table)
# 1311-1330  INCR_OF      Text   20     No      Increments that products can be purchased in
# 1331-1410  P_WWW        Text   80     No      WWW address for this specific product. First 7 char = 'http://'.
# 1411-1413  WARNUMBER    Text   3      Yes     Time period for warranty. Must be between 1 and 999. 0 if warperiod is 'NONE', 'LIFE', 'STND'.
# 1414-1418  WARPERIOD    Text   5      Yes     Unit of time for warranty. Value should be 'DAY', 'WEEK', 'MONTH', 'YEAR', 'NONE', 'LIFE' or 'STND'.
# 1419-1426  P_DELIV      Numb   8.0    Yes     Product delivery.  < 999 days.
# 1427-1428  LEADTIME     Text   2      Yes     Code to explain P_DELIV. 'AF' for time delivered after receipt of order, 'AE' for time shipped after receipt, 'AX' for award date to completion date.
# 1419-1430  UNIT1        Text   2      No      Dimension unit 1. Required if there is a value in VALUE1. in . SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
# 1431-1432  UNIT2        Text   2      No      Dimension unit 2. Required if there is a value in VALUE2. in . SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
# 1433-1434  UNIT3        Text   2      No      Dimension unit 3. Required if there is a value in VALUE3. in . SIP help(SIP help contents/Import data/SIP lookup tables/Unit of issue table).
# 1435-1436  TYPE1        Text   2      No      Dimension type 1. Required if UNIT1 or VALUE1 has a value. Must be 'LN'.
# 1437-1438  TYPE2        Text   2      No      Dimension type 2. Required if UNIT2 or VALUE2 has a value. Must be 'WD'.
# 1439-1440  TYPE3        Text   2      No      Dimension type 3. Required if UNIT3 or VALUE3 has a value. Must be 'HT'.
# 1441-1441  ITEMTYPE     Text   1      Yes     Item type. Must be 'P' or 'A'. P=Product, A=Accessory.
# 1442-1455  UPC		    Text   14     *Yes    UPC must be12 digits (you may enter 11 and will assume UPC has leading zero).  You may enter EAN8, EAN13, GTIN14, or ISBN13 (for books) if you use these identifiers instead of a UPC.  ISBN13 must start with 978 or 979.  You may pad any of these identifies with zero(s) to make a 14 digit GTIN. *UPC required for some SINs. See SIP Help for SINs requiring UPC for associated products (SIP contents/Import data/SIP lookup tables/ Special item number table).
# 1456-1463  UNSPSC       Text   8      No      UNSPSC must be 8 digits all numeric and not start with 0.
# 1464-1464  FOB_AK       Text   1      Yes     Freight-on-board for Alaska. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery.
# 1465-1465  FOB_HI       Text   1      Yes     Freight-on-board for Hawaii. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘N’-no delivery.
# 1466-1466  FOB_PR       Text   1      Yes     Freight-on-board for Puerto Rico. ‘D’- destination. ‘O’ – origin buyer pays shipping cost), ‘N’-no delivery
# 1467-1467  FOB_US       Text   1      Yes     Freight-on-board for CONUS. ‘D’- destination. ‘O’ – origin (buyer pays shipping cost), ‘W’-worldwide (CONUS= dest, outside CONUS = origin.
# 1468-1471  PSC_CODE		Text   4      No      Product Service Code. Must be 4 characters and can only contain letters and numbers.
# 1472       '~'                        Yes
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IQTYVOL  Product quantity/volume discount information table
#
#  1 -12    CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13-52    MFGPART      Text   40    Yes   Manufacturer part number. In PROD.TXT.
#  53-92    MFGNAME      Text    40   Yes   Manufacturer name. Must be found in Product table.
#  93-109   BREAK1       Numb   17.4  Yes   Discount GSA price for the first break. If not temp discount record.
# 110-117   DISC_PCT1    Numb   8.4   Yes   Percentage off of the regular GSA price for the first break.
# 118-125   RANGE1       Numb   8.0   Yes   Beginning range for the first break. If IS_QTY='Y' then it must be greater than 1. If IS_QTY=’N’ then it must be greater than the GSAPRICE.
# 126-133   ENDRANGE1    Numb   8.0   Yes   Ending range for the first break. It must be greater than the beginning range.
# 134-150   BREAK2       Numb   17.4  No    Discount GSA price for the 2nd break. It must be less than the previous break.
# 151-168   DISC_PCT2    Numb   8.4   No    Percentage off of the regular GSA price for the 2nd break. It must be greater than the previous break.
# 159-166   RANGE2       Numb   8.0   No    Beginning range for the 2nd break. It must be 1 greater than the previous ending range.
# 167-174   ENDRANGE2    Numb   8.0   No    Ending range for the 2nd break. It must be greater than the beginning range.
# 175-191   BREAK3       Numb   17.4  No    Discount GSA price for the 3rd break. It must be less than the previous break.
# 192-199   DISC_PCT3    Numb   8.4   No    Percentage off of the regular GSA price for the 3rd break. It must be greater than the previous break.
# 200-207   RANGE3       Numb   8.0   No    Beginning range for the 3rd break. It must be 1 greater than the previous ending range.
# 208-215   ENDRANGE3    Numb   8.0   No    Ending range for the 3rd break. It must be greater than the beginning range.
# 216-232   BREAK4       Numb   17.4  No    Discount GSA price for the 4th break. It must be less than the previous break.
# 233-240   DISC_PCT4    Numb   8.4   No    Percentage off of the regular GSA price for the 4th break. It must be greater than the previous break.
# 241-248   RANGE4       Numb   8.0   No    Beginning range for the 4th break. It must be 1 greater than the previous ending range.
# 249-256   ENDRANGE4    Numb   8.0   No    Ending range for the 4th break. It must be greater than the beginning range.
# 257-273   BREAK5       Numb   17.4  No    Discount GSA price for the 5th break. It must be less than the previous break.
# 274-281   DISC_PCT5    Numb   8.4   No    Percentage off of the regular GSA price for the 5th break. It must be greater than the previous break.
# 282-289   RANGE5       Numb   8.0   No    Beginning range for the 5th break. It must be 1 greater than the previous ending range.
# 290-297   ENDRANGE5    Numb   8.0   No    Ending range for the 5th break. It must be greater than the beginning range.
# 298-314   BREAK6       Numb   17.4  No    Discount GSA price for the 6th break. It must be less than the previous break.
# 315-322   DISC_PCT6    Numb   8.4   No    Percentage off of the regular GSA price for the 6th break. It must be greater than the previous break.
# 323-330   RANGE6       Numb   8.0   No    Beginning range for the 6th break. It must be 1 greater than the previous ending range.
# 331-338   ENDRANGE6    Numb   8.0   No    Ending range for the 6th break. It must be greater than the beginning range.
# 339-355   BREAK7       Numb   17.4  No    Discount GSA price for the 7th break. It must be less than the previous break.
# 356-363   DISC_PCT7    Numb   8.4   No    Percentage off of the regular GSA price for the 7th break. It must be greater than the previous break.
# 364-371   RANGE7       Numb   8.0   No    Beginning range for the 7th break. It must be 1 greater than the previous ending range.
# 372-379   ENDRANGE7    Numb   8.0   No    Ending range for the 7th break. It must be greater than the beginning range.
# 380-459   QMSG         Text   80    No    Enter any terms applicable to quantity discounts.
# 460-460   IS_QTY       Text   1     Yes   Yes/no field. ‘Y’ if discounts are based on the quantity of the product purchased. ‘N’ if discounts are based on the total purchase price of the product.
# 461-461   IS_TEMP      Text   1     Yes   Yes/no field. Is this a temporary price? Must be 'Y' or 'N'.
# 462-463   ZONE_NUM     Text   2     Yes   Zone number. Zone to which the price applies. (Zones are assigned at IZONE.) '00' if there are no zones.
# 464       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IREMITOR Contract order address information table
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13-47    R_NAME       Text   35    Yes   Contact name for order address.
#  48-82    R_STR1       Text   35    Yes   Street address for order address.
#  83-117   R_STR2       Text   35    No    Street address 2 for order address.
# 118-147   R_CITY       Text   30    Yes   City for order address.
# 148-149   R_STATE      Text   2     Yes   State for order address. In SIP help(SIP contents/Import data/SIP lookup tables/State and country code table).
# 150-151   R_CTRY       Text   2     Yes   Country for remittance order. In SIP help(SIP contents/Import data/SIP lookup tables/Point of production table).
# 152-162   R_ZIP        Text   11    Yes   Zip code for order address.
# 163-192   R_PHONE      Text   30    Yes   Telephone number for order address. Must be numbers.
# 193-222   R_FAX        Text   30    Yes   Fax number for order address. Must be numbers.
# 223-302   R_EMAIL      Text   80    Yes   Send orders to this email address.
# 303       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# ISPECTER Product/contract special terms & conditions table
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13-37    SPECNAME     Text   25    Yes   Special term name. In . SIP help(SIP help contents/Import data/SIP lookup tables/Special charges table).
#  38-54    CHARGE       Numb   17.4  Yes   Special term charge.
#  55-134   SPECDESC     Text   80    No    Special term description.
# 135-136   S_PER        Text   2     Yes   Unit of special term measurement. SIP help(SIP contents/Import data/SIP lookup tables/unit of issue table).
# 137       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IZONE     Contract Zone table. If prices vary by geographic zone, assign zone numbers to each state, up to 10 zones, numbered 1-10. AK, HI, PR and VI must >= 0. All others > 0.
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13-14    AK           Numb   2     No    Alaska zone number. Required if you have zones.
#  15-16    AL           Numb   2     No    Alabama zone number. Required if you have zones.
#  17-18    AR           Numb   2     No    Arkansas zone number. Required if you have zones.
#  19-20    AZ           Numb   2     No    Arizona zone number. Required if you have zones.
#  21-22    CA           Numb   2     No    California zone number. Required if you have zones.
#  23-24    CO           Numb   2     No    Colorado zone number. Required if you have zones.
#  25-26    CT           Numb   2     No    Connecticut zone number. Required if you have zones.
#  27-28    DC           Numb   2     No    District of Colombia zone number. Required if you have zones.
#  29-30    DE           Numb   2     No    Delaware zone number. Required if you have zones.
#  31-32    FL           Numb   2     No    Florida zone number. Required if you have zones.
#  33-34    GA           Numb   2     No    Georgia zone number. Required if you have zones.
#  35-36    HI           Numb   2     No    Hawaii zone number. Required if you have zones.
#  37-38    IA           Numb   2     No    Iowa zone number. Required if you have zones.
#  39-40    ID           Numb   2     No    Idaho zone number. Required if you have zones.
#  41-42    IL           Numb   2     No    Illinois zone number. Required if you have zones.
#  43-44    IN           Numb   2     No    Indiana zone number. Required if you have zones.
#  45-46    KS           Numb   2     No    Kansas zone number. Required if you have zones.
#  47-48    KY           Numb   2     No    Kentucky zone number. Required if you have zones
#  49-50    LA           Numb   2     No    Louisiana zone number. Required if you have zones.
#  51-52    MA           Numb   2     No    Massachusetts zone number. Required if you have zones.
#  53-54    MD           Numb   2     No    Maryland zone number. Required if you have zones.
#  55-56    ME           Numb   2     No    Maine zone number. Required if you have zones.
#  57-58    MI           Numb   2     No    Michigan zone number. Required if you have zones.
#  59-60    MN           Numb   2     No    Minnesota zone number. Required if you have zones.
#  61-62    MO           Numb   2     No    Missouri zone number. Required if you have zones.
#  63-64    MS           Numb   2     No    Mississippi zone number. Required if you have zones.
#  65-66    MT           Numb   2     No    Montana zone number. Required if you have zones.
#  67-68    NC           Numb   2     No    North Carolina zone number. Required if you have zones.
#  69-70    ND           Numb   2     No    North Dakota zone number. Required if you have zones.
#  71-72    NE           Numb   2     No    Nebraska zone number. Required if you have zones.
#  73-74    NH           Numb   2     No    New Hampshire zone number. Required if you have zones.
#  75-76    NJ           Numb   2     No    New Jersey zone number. Required if you have zones.
#  77-78    NM           Numb   2     No    New Mexico zone number. Required if you have zones.
#  79-80    NV           Numb   2     No    Nevada zone number. Required if you have zones.
#  81-82    NY           Numb   2     No    New York zone number. Required if you have zones.
#  83-84    OH           Numb   2     No    Ohio zone number. Required if you have zones.
#  85-86    OK           Numb   2     No    Oklahoma zone number. Required if you have zones.
#  87-88    OR           Numb   2     No    Oregon zone number. Required if you have zones.
#  89-90    PA           Numb   2     No    Pennsylvania zone number. Required if you have zones.
#  91-92    PR           Numb   2     No    Puerto Rico zone number. Required if you have zones.
#  93-94    RI           Numb   2     No    Rhode Island zone number. Required if you have zones.
#  95-96    SC           Numb   2     No    South Carolina zone number. Required if you have zones.
#  97-98    SD           Numb   2     No    south Dakota zone number. Required if you have zones.
#  99-100   TN           Numb   2     No    Tennessee zone number. Required if you have zones.
# 101-102   TX           Numb   2     No    Texas zone number. Required if you have zones.
# 103-104   UT           Numb   2     No    Utah zone number. Required if you have zones.
# 105-106   VA           Numb   2     No    Virginia zone number. Required, if you have zones.
# 107-108   VI           Numb   2     No    Virgin Islands zone number. Required if you have zones.
# 109-110   VT           Numb   2     No    Vermont zone number. Required if you have zones.
# 111-112   WA           Numb   2     No    Washington zone number. Required if you have zones.
# 113-114   WI           Numb   2     No    Wisconsin zone number. Required if you have zones.
# 115-116   WV           Numb   2     No    West Virginia zone number. Required if you have zones.
# 117-118   WY           Numb   2     No    Wyoming zone number. Required if you have zones.
# 119       '~'                       Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IFABRICS   Fabric information for contract. If many of your products have fabrics choices, this table is useful.
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13- 27   FABTYPE      Text   15    Yes   Fabric type.
#  28- 67   COLOR        Text   40    Yes   Color.
#  68-107   COLOR_NUM    Text   40    Yes   Color number.
#  108      '~'                      Yes
#
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IMSG   Environmental message information for product.
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13- 52   MFGPART      Text   40    Yes   Manufacturer part number. In PROD.TXT.
#  53- 92   MFGNAME      Text   40    Yes   Manufacturer name. Must be found in Product table.
#  93- 94   EMSGCODE     Text    2    Yes   Environmental message code. SIP help(SIP help contents/Import data/SIP lookup tables/Environmental Message Table).
#  95-174   RECYCLED     Text   80    No    Recycled content for mfrpart. Example: Contains 50% recovered meterial which includes 20% post consumer meterial.
# 175-254   URL          Text   80    No    URL having Section 508 accessibility info for this product
# 255-294   SCANCODE     Text   40    No    Scan code related to GSA Parallel Contracting program.
# 295-300   HAZMAT       Text    6    No    Item has hazardous material. Enter United Nations Identification Number (UNID). First two characters must start with UN or NA or enter “MSDS” in the first 4 positions.
# 301       '~'                       Yes
#
# COLUMNS     FIELD      TYPE   SIZE  REQ'D      DESCRIPTION
# ------------------------------------------------------------------------------
# IPHOTO   photo information for product
#
#  1 - 12   CONTNUM      Text   12    Yes   Contract number. Format 'GS-99F-9999A' or GS-'GS-99F-999AA' ('V999P-99999 ' or 'V999D-99999 ' for VA contract) in CONTR.TXT.
#  13- 52   MFGPART      Text   40    Yes   Manufacturer part number. Must be found in Product table.
#  53- 92   MFGNAME      Text   40    Yes   Manufacturer name. Must be found in Product table.
#  93-172   DEF_PHOTO    Text   80    *Yes  Filename of first photo. This is the default photo that will be shown with product/accessory. This should be the largest and best photo.*DEF_PHOTO required for some SINs.  See SIP Help for SINs requiring DEF_PHOTO for associated products (SIP contents/Import data/SIP lookup tables/ Special item number table)
# 173-252   PHOTO2       Text   80    No    Filename of second photo.
# 253-332   PHOTO3       Text   80    No    Filename of third photo.
# 333-412   PHOTO4       Text   80    No    filename of fourth photo.
# 413-413   '~'                       Yes