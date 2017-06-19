require_relative '../../adv/gsa_advantage'
# todo: join user table on manufacture table
def export(table_name)
	@DB[table_name]
	@DB[:manufacture_parts]
end