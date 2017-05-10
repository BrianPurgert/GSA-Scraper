desc 'Default Tasks'

task default: %w[get_products]

task(:get_products)     { ruby 'gsa_advantage_manufacture_products.rb' }
task(:gsa_mft)          { ruby 'gsa_advantage_single.rb' }
task(:gsa_search)       { ruby 'gsa_advantage_search.rb' }
task(:get_manufactures) { ruby 'gsa_advantage_search.rb' }
