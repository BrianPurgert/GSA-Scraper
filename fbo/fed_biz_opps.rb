# Start here:       https://opendata.stackexchange.com/questions/4164/fedbizopps-raw-data-api
# ftp works at the root directory ftp://ftp.fbo.gov/
# FedBizOpps data:  ftp://ftp.fbo.gov/FBOFeed20091012


class FedBizOpps
	
	# Page 59 shows an example in php
	# https://www.fbo.gov/downloads/fbo_web_services_technical_documentation.pdf
	      Base = 'ftp://ftp.fbo.gov/'
		Feed = 'FBOFeed'
		Date = ""   # Format YYYYMMDD
	
	def initialize(date = Time.now.strftime("%Y%m%d"))
		# yday = Time.now - (3600 * 24)
		# puts Time.now - 1.day
		#
			puts "#{Base}#{Feed}#{date}"
		end
		

end

FedBizOpps.new
# fbo_files
