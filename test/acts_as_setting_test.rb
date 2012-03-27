require 'test_helper'

class ActsAsSettingTest < ActiveSupport::TestCase

  setup do
    ConfigA.destroy_all
    ConfigA.reset_cache!
    ConfigB.destroy_all
    ConfigB.reset_cache!
  end

  test "modules exists" do
    assert_kind_of Module, SettingsDB
    assert_kind_of Module, SettingsDB::ActsAsSetting
    assert_kind_of Class, ConfigA
    assert_kind_of Class, ConfigB
  end

  test "config_a_setting_name_field should be key" do
    assert_equal :key, ConfigA.setting_name_field
  end

  test "config_b_setting_name_field should be name" do
    assert_equal :name, ConfigB.setting_name_field
  end

  test "config_a_setting_namespace_field should be scope" do
    assert_equal :scope, ConfigA.setting_namespace_field
  end

  test "config_b_setting_namespace_field should be namespace" do
    assert_equal :namespace, ConfigB.setting_namespace_field
  end

  test "config_a model creates a new setting when key is assigned" do
    ConfigA[:foo] = :bar
    item = ConfigA.where(:key => :foo, :scope => :default).first
    assert_not_nil item
    assert_equal :bar, item.value
    assert_equal :bar, ConfigA[:foo]
  end

  test "config_b model creates a new setting when key is assigned" do
    ConfigB[:foo] = :bar
    item = ConfigB.where(:name => :foo, :namespace => :default).first
    assert_not_nil item
    assert_equal :bar, item.value
    assert_equal :bar, ConfigB[:foo]
  end

  test "settings model gives distinct values from different namespaces" do
    ConfigB[:foo] = :bar
    ConfigB[:plugin, :foo] = :baz
    obj = ConfigB.where(:name => :foo, :namespace => :default).first
    assert_not_nil obj
    assert_equal :bar, obj.value
    obj = ConfigB.where(:name => :foo, :namespace => :plugin).first
    assert_not_nil obj
    assert_equal :baz, obj.value
  end

  test "settings model does not cache using create" do
    obj = ConfigB.create(:name => 'foo', :namespace => 'default', :value => :bar)
    cache = ConfigB.cache!
    assert_nil cache[:default][:foo]
  end

  test "settings model caches on array index" do
    obj = ConfigB.create(:name => :foo, :namespace => :default, :value => :bar)
    cache = ConfigB.cache!
    assert_nil cache[:default][:foo]
    assert_equal :bar, ConfigB[:foo]
    assert_equal :bar, cache[:default][:foo].value
  end

  test "settings model removes cache entry on destroy" do
    ConfigB[:foo] = :bar
    cache = ConfigB.cache!
    assert_equal :bar, cache[:default][:foo].value
    cache[:default][:foo].destroy
    assert_nil cache[:default][:foo]
  end
end
