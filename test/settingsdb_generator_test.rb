require 'test_helper'
require 'rails/generators/test_case'
require 'generators/settingsdb/install_generator'

class SettingsDBGeneratorTest < Rails::Generators::TestCase
  tests SettingsDB::Generators::InstallGenerator
  destination File.expand_path('../tmp', File.dirname(__FILE__))
  setup :prepare_destination

  test "Assert all files are properly created with default options" do
    run_generator
    assert_migration "db/migrate/settingsdb_create_settings.rb" do |migration|
      assert_match migration, /t\.string\s+:namespace\s*,\s*:null\s*=>\s*false\s*,\s*:default\s*=>\s*'default'/
      assert_match migration, /t\.string\s+:name\s*,\s*:null\s*=>\s*false/
      assert_match migration, /t\.text\s+:value/
      assert_match migration, /add_index\s+:settings\s*,\s*\[:namespace\s*,\s*:name\]\s*,\s*:unique\s*=>\s*true/
      assert_match migration, /add_index\s+:settings\s*,\s*:name/
    end
    assert_file "app/models/setting.rb" do |model|
      assert_match model, /include SettingsDB::Settings/
    end
  end

  test "assert model and migration has custom table name when given" do
    run_generator %w(my_setting)
    assert_migration "db/migrate/settingsdb_create_my_settings.rb" do |migration|
      assert_match migration, /create_table\s+:my_settings/
      assert_match migration, /add_index\s+:my_settings/
    end
    assert_file "app/models/my_setting.rb" do |model|
      assert_match model, /class\s+MySetting/
    end
  end

  test "assert model and migration with custom attributes" do
    run_generator %w(setting mycolumn:string)
    assert_migration "db/migrate/settingsdb_create_settings.rb" do |migration|
      assert_match migration, /t\.string\s+:mycolumn/
    end
  end

end
