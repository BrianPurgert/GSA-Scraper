desc 'Default Tasks'

task default: [:get_products]

task(:get_products)                 { ruby 'gsa_advantage_manufacture_products.rb' }
task(:dl_product_pages)             { ruby 'gsa_advantage_product_detail.rb' }
task(:gsa_search)                   { ruby 'gsa_advantage_search.rb' }
task(:get_manufactures)             { ruby 'gsa_advantage_search.rb' }
