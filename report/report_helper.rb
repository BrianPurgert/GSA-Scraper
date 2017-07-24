module ReportHelper
	def list_files(files)
		files.each_with_index do |file, num|
			puts "#{num}\t#{file}"
		end
	end
	
	def import_spreadsheets(files)
		puts "Import Spreadsheets? (Y/N)"
		if gets.to_s.upcase.include? 'Y'
			puts "#{files.size} files importing"
			threads = []
			files.each_with_index do |file|
				 threads << Thread.new {
						import_products(file)
				 }
			end
			 threads.each { |thr| thr.join }
			puts "Imports Complete"
		end
	end


	
	def export_price_comparisons(files)
		puts "Generate Price Comparisons? (Y/N)"
		if gets.to_s.upcase.include? 'Y'
			excel :iprod
			# threads = []
			# files.each_with_index do |file, num|
			# 	threads << Thread.new { excel tables[num] }
			# end
			# threads.each { |thr| thr.join }
		end
	end



end