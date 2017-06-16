require_relative './import'


path = File.join(__dir__, 'test/Test File 1.xlsx')
puts path
import_products path, :test1
# import_products "./test/Test File 2.xlsx", :test2



#
# puts xlsx.info
# import_price_list xlsx