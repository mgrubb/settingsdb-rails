class SettingsdbCreateConfigBs < ActiveRecord::Migration
  def change
    create_table :config_bs do |t|
      t.string :namespace, :null => false, :default => 'default'
      t.string :name, :null => false
      t.text :value
    end

    add_index :config_bs, [:namespace, :name], :unique => true
    add_index :config_bs, :name
  end
end
