action :create do
  # Create database if it doesn't exist
  execute "mysql-create-database: #{new_resource.name}" do
    command "mysql -e 'CREATE DATABASE #{new_resource.name} CHARACTER SET = #{new_resource.character_set} COLLATE = #{new_resource.collate};'"
    not_if "mysql -e \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '#{new_resource.name}';\" | grep -q #{new_resource.name}"
  end
  # Set character set if it differs from given
  execute "mysql-set-charset: #{new_resource.name}" do
    command "mysql -e 'ALTER DATABASE #{new_resource.name} COLLATE = #{new_resource.collate};'"
    not_if "mysql #{new_resource.name}  -N -B -e 'show variables like \"collation_database\";' | awk '{print $2}' | grep -q '^#{new_resource.collate}$'"
  end
end

action :delete do
  # Drop database if it is exists
  execute "mysql-drop-database: #{new_resource.name}" do
    command "mysql -e 'DROP DATABASE #{new_resource.name}'"
    only_if "mysql -e \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '#{new_resource.name}';\" | grep -q #{new_resource.name}"
  end
end
