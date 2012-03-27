class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :namespace, :string, :null => false, :default => 'default'
    add_column :<%= table_name %>, :name, :string, :null => false
    add_column :<%= table_name %>, :value, :text

    add_index :<%= table_name %>, [:namespace, :name], :unique => true
    add_index :<%= table_name %>, :name
  end
end
