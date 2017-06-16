require 'bundler'
require 'bundler/setup'

# Bundler::GemHelper.install_tasks
# Bundler::Install.options


desc 'Default Tasks'
task(default: [:install])

desc 'Build tables from Manufactures/Vendor lists(1)'
task(:get_manufactures) do
	ruby 'gsa_advantage_manufactures.rb'
end


desc 'Price Comparisons from spreadsheet(2)'
task(:pcp) do
	ruby 'database/spreadsheet/report.rb'
end

desc 'Find products and related data(2)'
task(:gsa_advantage_manufacture_products) do
	ruby 'gsa_advantage_manufacture_products.rb'
end


task(:get_products)                     { ruby 'gsa_advantage_manufacture_products.rb' }
task(:dl_product_pages)                 { ruby 'gsa_advantage_product_detail.rb' }

task(:gsa_advantage_manufactures)       { ruby 'gsa_advantage_manufactures.rb' }
task(:gsa_advantage_product_detail)     { ruby 'gsa_advantage_product_detail.rb' }


desc 'Install Gems'
task(:install) do
	exec("cd #{Dir.getwd} && bundle clean && bundle update && bundle install")
end

# Rake.application.options.trace = true


