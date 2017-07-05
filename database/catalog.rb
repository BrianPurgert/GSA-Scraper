require_relative '../report/import'
# http://sequel.jeremyevans.net/rdoc/classes/Sequel/Dataset.html
def run_sample
	
	sample_table_join
	# puts sample_having.inspect
	
	
	
	
	
end

def clean_copy_parts
	pp @DB.schema(:manufactures).inspect
	pp @DB.schema(:manufacture_parts)
	@DB[:manufacture_parts].order(:last_updated).reverse.distinct(:href_name)
end

def sample_having
	# Returns a copy of the dataset with the HAVING conditions changed. See #where for argument types.
	#
	   @DB[:manufacture_parts].group(:sum).having(:sum=>10)
	   # SELECT * FROM items GROUP BY sum HAVING (sum = 10)
end

def sample_join
	@DB[:test1].join_table(:cross, :manufactures)
	# SELECT * FROM a CROSS JOIN b
end



def sample_table_join
	@DB[:test1].print
	# r = @DB[:test1].join_table(:left, manufacture_parts, [:manufacture_part])
	# r.print
	exit
	color_p part.pretty_inspect
	result = @DB[:test1].join_table(:inner, @DB[:manufacture_parts], manufacture_name: 'name')
	puts result.inspect
		# SELECT * FROM a INNER JOIN (SELECT * FROM b) AS t1 ON (t1.c = a.d)
	# @DB[:test1].join_table(:left, :b___c, [:d])
		# SELECT * FROM a LEFT JOIN b AS c USING (d)
end


# SELECT * FROM a NATURAL JOIN b INNER JOIN c
#   ON ((c.d > b.e) AND (c.f IN (SELECT g FROM b)))
def sample_natural_join
	@DB[:test1].natural_join(:b).join_table(:inner, :c) { |ta, jta, js|
		(Sequel.qualify(ta, :d) > Sequel.qualify(jta, :e)) &
		{Sequel.qualify(ta, :f) => @DB.from(js.first.table).select(:g)} }
end


def sample_grep dataset
	dataset.grep(:a, '%test%')
	# SELECT * FROM items WHERE (a LIKE '%test%' ESCAPE '\')
	
	dataset.grep([:a, :b], %w'%test% foo')
	# SELECT * FROM items WHERE ((a LIKE '%test%' ESCAPE '\') OR (a LIKE 'foo' ESCAPE '\')
	#   OR (b LIKE '%test%' ESCAPE '\') OR (b LIKE 'foo' ESCAPE '\'))
	
	dataset.grep([:a, :b], %w'%foo% %bar%', :all_patterns => true)
	# SELECT * FROM a WHERE (((a LIKE '%foo%' ESCAPE '\') OR (b LIKE '%foo%' ESCAPE '\'))
	#   AND ((a LIKE '%bar%' ESCAPE '\') OR (b LIKE '%bar%' ESCAPE '\')))
	
	dataset.grep([:a, :b], %w'%foo% %bar%', :all_columns => true)
	# SELECT * FROM a WHERE (((a LIKE '%foo%' ESCAPE '\') OR (a LIKE '%bar%' ESCAPE '\'))
	#   AND ((b LIKE '%foo%' ESCAPE '\') OR (b LIKE '%bar%' ESCAPE '\')))
	
	dataset.grep([:a, :b], %w'%foo% %bar%', :all_patterns => true, :all_columns => true)
	# SELECT * FROM a WHERE ((a LIKE '%foo%' ESCAPE '\') AND (b LIKE '%foo%' ESCAPE '\')
	#   AND (a LIKE '%bar%' ESCAPE '\') AND (b LIKE '%bar%' ESCAPE '\'))
end


def sample_group
	@DB[:manufacture_parts].group(:id) # SELECT * FROM items GROUP BY id
	@DB[:items].group(:id, :name) # SELECT * FROM items GROUP BY id, name
	@DB[:items].group { [a, sum(b)] } # SELECT * FROM items GROUP BY a, sum(b)
	
	@DB[:items].group_and_count(:name).all
	# SELECT name, count(*) AS count FROM items GROUP BY name
	# => [{:name=>'a', :count=>1}, ...]
	
	@DB[:items].group_and_count(:first_name, :last_name).all
	# SELECT first_name, last_name, count(*) AS count FROM items GROUP BY first_name, last_name
	# => [{:first_name=>'a', :last_name=>'b', :count=>1}, ...]
	
	@DB[:items].group_and_count(:first_name___name).all
	# SELECT first_name AS name, count(*) AS count FROM items GROUP BY first_name
	# => [{:name=>'a', :count=>1}, ...]
	
	@DB[:items].group_and_count { substr(first_name, 1, 1).as(initial) }.all
	# SELECT substr(first_name, 1, 1) AS initial, count(*) AS count FROM items GROUP BY substr(first_name, 1, 1)
	# => [{:initial=>'a', :count=>1}, ...]
end

def rename_table
	# rename_table (name, new_name)
	DB.tables #=> [:items]
	DB.rename_table :items, :old_items
	DB.tables #=> [:old_items]
end

def limit
	@DB[:items].limit(10) # SELECT * FROM items LIMIT 10
	@DB[:items].limit(10, 20) # SELECT * FROM items LIMIT 10 OFFSET 20
	@DB[:items].limit(10...20) # SELECT * FROM items LIMIT 10 OFFSET 10
	@DB[:items].limit(10..20) # SELECT * FROM items LIMIT 11 OFFSET 10
	@DB[:items].limit(nil, 20) # SELECT * FROM items OFFSET 20
end


run_sample
