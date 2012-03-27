class SettingsdbCreateConfigAs < ActiveRecord::Migration
  def change
    create_table :config_as do |t|
      t.string :scope, :null => false, :default => 'default'
      t.string :key, :null => false
      t.text :value
    end

    add_index :config_as, [:scope, :key], :unique => true
    add_index :config_as, :key
  end
end
