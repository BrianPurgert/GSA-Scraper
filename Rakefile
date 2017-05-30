require 'bundler'
require "bundler/setup"

# Bundler::Install.options




desc 'Default Tasks'
task default: [:install,:get_products]

desc "Install Gems"
task(:install) { exec("cd #{Dir.getwd} && bundle install") }

desc "Generate Manufacture Product Search  Page"
task(:gsa_advantage_manufacture_products) do
	:install
	ruby 'gsa_advantage_manufacture_products.rb'
end

task(:get_products)                             { ruby 'gsa_advantage_manufacture_products.rb' }
task(:dl_product_pages)                         { ruby 'gsa_advantage_product_detail.rb' }
task(:gsa_search)                               { ruby 'gsa_advantage_search.rb' }

task(:gsa_advantage_manufactures)               { ruby 'gsa_advantage_manufactures.rb' }
task(:gsa_advantage_product_detail)             { ruby 'gsa_advantage_product_detail.rb' }

# Rake.application.options.trace = true


