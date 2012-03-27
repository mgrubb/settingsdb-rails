class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
      t.string :namespace, :null => false, :default => 'default'
      t.string :name, :null => false
      t.text :value
<% attributes.each do |attr| -%>
      t.<%= attr.type %> :<%= attr.name %><%= attr.inject_options %>
<% end -%>
    end

    add_index :<%= table_name %>, [:namespace, :name], :unique => true
    add_index :<%= table_name %>, :name
<% attributes.reject {|attr| !attr.has_index?}.each do |attr| -%>
    add_index :<%= table_name %>, :<%= attr.name %><%= attr.inject_index_options %>
<% end -%>
  end
end
