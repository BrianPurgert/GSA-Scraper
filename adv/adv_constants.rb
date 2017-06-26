
IGNORE_CAT        = true
Mechanized        = false
Dev_mode          = false
IS_PROD           = true  # Check out items if true

Proxy_list        = YAML::load_file(File.join(__dir__, '../config/proxy.yml'))
Proxy_list1       = YAML::load_file(File.join(__dir__, '../config/proxy1.yml'))
Socks_list        = YAML::load_file(File.join(__dir__, '../config/socks5_proxy.yml'))
Socks_port        = 61336

Catalog_hudson    = '//192.168.1.104/gsa_price/'
RX_mfr            = /(?<=\q=..:.).*/                                      # Regex selects manufacture name after link
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil

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








