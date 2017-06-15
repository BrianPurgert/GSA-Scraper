require_relative '../../adv/gsa_advantage'

def export(table_name)
	@DB[table_name]
	@DB[:manufacture_parts]
end