require_relative './import'


path1 = File.join(__dir__, 'test/Test File 1.xlsx')
path2 = File.join(__dir__, 'test/Test File 2.xlsx')
puts path1
import_products path1, :test1
import_products path2, :test2



#
# puts xlsx.info
# import_price_list xlsx