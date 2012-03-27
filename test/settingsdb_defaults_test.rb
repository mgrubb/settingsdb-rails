require 'test_helper'

class SettingsDBDefaultsTest < ActiveSupport::TestCase

  test "module exists" do
    assert_kind_of Module, SettingsDB
    assert_kind_of Class, SettingsDB::Defaults
  end

  test "non-existant defaults key returns nil" do
    assert_nil SettingsDB::Defaults[:baz]
  end

  test "reset! method clears all defaults" do
    SettingsDB::Defaults[:foo] = :bar
    assert_equal :bar, SettingsDB::Defaults[:foo]
    SettingsDB::Defaults.reset!
    assert_nil SettingsDB::Defaults[:foo]
  end

  test "create a new default with implicit namespace" do
    assert_equal SettingsDB::Defaults[:foo] = :bar, SettingsDB::Defaults[:foo]
  end

  test "create a new default with explicit namespace" do
    assert_equal SettingsDB::Defaults[:baz, :bar] = :foo, SettingsDB::Defaults[:baz, :bar]
  end

  test "config class method returns class" do
    config = SettingsDB::Defaults.config
    assert_kind_of Class, config
    assert_equal SettingsDB::Defaults.name, config.name
  end

  test "defaults class method returns defaults hash copy" do
    SettingsDB::Defaults[:foobar] = :baz
    SettingsDB::Defaults[:foo, :foobar] = :blah
    defaults = SettingsDB::Defaults.defaults
    assert_equal :baz, defaults[:default][:foobar]
    assert_equal :blah, defaults[:foo][:foobar]
    defaults[:default][:foobar] = :arg
    assert_not_equal defaults[:default][:foobar], SettingsDB::Defaults[:foobar]
  end

  test "defaults! class method returns actual defaults hash" do
    SettingsDB::Defaults[:foo] = :bar
    defaults = SettingsDB::Defaults.defaults!
    assert_equal SettingsDB::Defaults[:foo], defaults[:default][:foo]
    defaults[:default][:foo] = :baz
    assert_equal SettingsDB::Defaults[:foo], defaults[:default][:foo]
  end

  test "config method given block runs code" do
    x = 1
    prc = Proc.new { x += 1 }
    config = SettingsDB::Defaults.config do |c|
      prc.call
      c[:oof] = :rab
      c[:zab, :oof] = :arb
    end
    assert_equal 2, x
    assert_equal :rab, SettingsDB::Defaults[:oof]
    assert_equal :arb, SettingsDB::Defaults[:zab, :oof]
    assert_equal :rab, config[:oof]
  end
end
