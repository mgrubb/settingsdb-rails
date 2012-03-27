class SettingsdbCreateTestSettings < ActiveRecord::Migration
  def change
    create_table :test_settings do |t|
      t.string :namespace, :null => false, :default => 'default'
      t.string :name, :null => false
      t.text :value
    end

    add_index :test_settings, [:namespace, :name], :unique => true
    add_index :test_settings, :name
  end
end
