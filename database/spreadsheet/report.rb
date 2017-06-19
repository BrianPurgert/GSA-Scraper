require_relative './import'
require_relative './export'
loop do
basedir                     = File.join(__dir__,'test/')
files                       = Dir.glob(basedir+"*.xlsx")

@DB.tables.each do |table|
	puts "#{table}"
	puts "\t#{@DB[table].columns.inspect}".colorize(:blue)
end


# File.write('what_is_pcp.csv', result.all.to_csv(:write_headers=>true))
tables = [:client1,:client2,:client3,:client4,:client5]

files.each_with_index do |file, num|
		begin
			puts "#{num}\t#{file}\t".colorize(:green)
			import_products file, tables[num]
			excel tables[num]
		rescue Exception => e
			puts e.message
		end
end






# begin
# 	import_products files[gets.to_i], :test1
# rescue Exception => e
# 	puts e.message
# end

end
# import_products path2, :test2



#
# puts xlsx.info
# import_price_list xlsx