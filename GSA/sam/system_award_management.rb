# SAM is basically the GSA's directory for business entity’s
#
# System for Award Management API
# API             https://github.com/GSA/sam_api
# Docs            http://gsa.github.io/sam_api/sam/
# GSA Database    http://gsa.github.io/sam_api/sam/SAM_Functional_Data_Dictionary_v7_Public.pdf
# SAM API is a GET API which has one operation. (retrieve an entity’s public information)
# Its endpoint is:
# https://api.data.gov/sam/v1/registrations/
#
#
# System for Award Management Data Extracts
# https://gw.sam.gov/SAMWS/1.0/Entity?wsdl
# https://gw.sam.gov/SAMWS/1.0/Entity
# https://www.sam.gov/sam/transcript/SAM_Entity_Management_Public_Extract_Layout_v1.1.pdf

class SystemAwardManagement

	# Probably should just scrape the json urls and map them to tables

	'http://gsa.github.io/sam_api/static/businessTypes.json'
	'http://gsa.github.io/sam_api/static/purpose.json'
	'http://gsa.github.io/sam_api/static/country.json'
	'http://gsa.github.io/sam_api/static/county.json'
	'http://gsa.github.io/sam_api/static/far.json'
	'http://gsa.github.io/sam_api/static/dfar.json'
	'http://gsa.github.io/sam_api/static/discipline.json'
	'http://gsa.github.io/sam_api/static/experience.json'
	'http://gsa.github.io/sam_api/static/revenue.json'
end