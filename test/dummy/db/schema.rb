# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120327011134) do

  create_table "config_as", :force => true do |t|
    t.string "scope", :default => "default", :null => false
    t.string "key",                          :null => false
    t.text   "value"
  end

  add_index "config_as", ["key"], :name => "index_config_as_on_key"
  add_index "config_as", ["scope", "key"], :name => "index_config_as_on_scope_and_key", :unique => true

  create_table "config_bs", :force => true do |t|
    t.string "namespace", :default => "default", :null => false
    t.string "name",                             :null => false
    t.text   "value"
  end

  add_index "config_bs", ["name"], :name => "index_config_bs_on_name"
  add_index "config_bs", ["namespace", "name"], :name => "index_config_bs_on_namespace_and_name", :unique => true

  create_table "test_settings", :force => true do |t|
    t.string "namespace", :default => "default", :null => false
    t.string "name",                             :null => false
    t.text   "value"
  end

  add_index "test_settings", ["name"], :name => "index_test_settings_on_name"
  add_index "test_settings", ["namespace", "name"], :name => "index_test_settings_on_namespace_and_name", :unique => true

end
