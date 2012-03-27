module SettingsDB
  module ActsAsSetting
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_setting(options = {})
        cattr_accessor :setting_name_field, :setting_namespace_field, :setting_value_field
        self.setting_name_field = (options[:setting_name_field] || :name).to_sym
        self.setting_namespace_field = (options[:setting_namespace_field] || :namespace).to_sym
        self.setting_value_field = (options[:setting_value_field] || :value).to_sym
        class_eval(<<-BLOCK, __FILE__, __LINE__ + 1)
  include SettingsDB::Settings
  serialize :#{setting_value_field}

BLOCK
      end
    end

  end
end

ActiveRecord::Base.send :include, SettingsDB::ActsAsSetting
