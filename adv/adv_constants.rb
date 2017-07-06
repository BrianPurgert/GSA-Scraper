# ============= Environment Variables ============= #
ENV['MYSQL_HOST']         = 'gcs-data.mysql.database.azure.com'
ENV['MYSQL_HOST_ALT']     = 'gcs-data0.mysql.database.azure.com'
ENV['MYSQL_USER']         = 'BrianPurgert@gcs-data'
ENV['MYSQL_PASS']         = 'GoV321CoN'

# ===================================== Execution Configurations
Thread.abort_on_exception = false
PROXY_LIST                = YAML::load_file(File.join(__dir__, '../config/proxy.yml'))

# ===================================== Constants
DOWNLOAD                  = false
IGNORE_CAT                = true
MECHANIZED                = true
LOG_DATABASE              = true
LOGWEB                    = false
DEV_MODE                  = false
IS_PROD                   = true
HUDSON_LOCAL              = '//192.168.1.104/gsa_price/'

# ===================================== Constants
REGEX_QUERY               = /(?<=\q=..:.).*/

GSA_ADVANTAGE  = 'https://gsaadvantage.gov'
PRODUCT_DETAIL = "/advantage/catalog/product_detail.do?"
OUTAGE         = "/outage.html"
OUTAGE_IP      = "104.160.239.120:60099"
# contractNumber            = GS-07F-0100W&itemNumber=10942B&mfrName=E.K.+EKCESSORIES
# contractNumber=GS-07F-0100W&itemNumber=10942B&mfrName=E.K.+EKCESSORIES
# contractNumber=GS-07F-0100W&itemNumber=10942B&mfrName=E.K.+EKCESSORIES
# /advantage/catalog/product_detail.do?contractNumber=GS-25F-0139M&itemNumber=10942B&mfrName=EK+EKCESSORIES

module ADV
	FSSI        = "a[href*='#fssi']"
	SUB_CAT     = "a[href*='/advantage/s/search.do?q=1:4ADV.']"
	CAT         = "a[href*='/advantage/department/main.do?cat=ADV.']"       # a[href*='cat=']
	Lists          =  ["vnd.do?", "mfr.do?"]
	# 0	Building & Industrial
	# 1	Electronics & Technology
	# 2	Facilities & Supplies
	# 3	Furniture & Furnishings
	# 4	Law Enforcement, Fire & Security
	# 5	Office Equipment
	# 6	Office Supplies
	# 7	Office Supplies & Equipment FSSI
	# 8	Scientific & Medical
	# 9	Tools, Paint & Recreational
	# 10	Vehicles & Equipment
	Categories   = ["ADV.BUI", "ADV.ELE", "ADV.FAC", "ADV.FUR", "ADV.LAW", "ADV.OEQ", "ADV.OFF", "ADV.FSSI", "ADV.SCI", "ADV.TOO", "ADV.VEH"]
   end

# ===================================== OVERRIDES
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
OpenSSL::SSL::VERIFY_PEER                                   = OpenSSL::SSL::VERIFY_NONE






