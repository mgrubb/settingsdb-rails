module SettingsDB::ActsAsSetting # :nodoc:
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    ##
    # This method causes the model to import the SettingsDB behavior
    # A SettingsDB enabled modle requires 3 fields: name, namespace, and value
    # This method also takes options to override the default names of these fields.
    # === Options
    # *:setting_namespace_field*:: Override namespace field-name (default: +:namespace+)
    # *:setting_name_field*:: Override name field-name (default: +:name+)
    # *:setting_value_field*:: Override value field-name (default: +:value+)
    #
    # === Examples
    #
    # To use the default field names in your model, no options are needed:
    #
    #   class Setting < ActiveRecord::Base
    #     acts_as_setting
    #   end
    #
    # If your model needs to rename a setting field's name pass them as options
    # to +acts_as_settings+.  Here the +Configuration+ model keeps the namespace
    # value in the +:scope+ field, and the setting name value in the +:key+ field:
    #
    #   class Configuration < ActiveRecord::Base
    #     acts_as_setting :setting_namespace_field => :scope, :setting_name_field => :key
    #   end
    #
    def acts_as_setting(options = {})
      cattr_accessor :setting_namespace_field, :setting_name_field, :setting_value_field
      self.setting_name_field = (options[:setting_name_field] || :name).to_sym
      self.setting_namespace_field = (options[:setting_namespace_field] || :namespace).to_sym
      self.setting_value_field = (options[:setting_value_field] || :value).to_sym
      class_eval(<<-BLOCK, __FILE__, __LINE__ + 1)
  include SettingsDB::Settings
  serialize :#{setting_value_field}
  before_destroy :remove_from_cache

BLOCK
    end
  end
end

ActiveRecord::Base.send :include, SettingsDB::ActsAsSetting
