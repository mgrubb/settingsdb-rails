require 'settingsdb/defaults'
require 'active_support/concern'
require 'active_support/core_ext/hash/indifferent_access'
require 'yaml'
require 'pry'

module SettingsDB
  module Settings
    extend ActiveSupport::Concern

    def destroy
      self.class.delete_from_cache(self)
      super
    end

    included do
      reset_cache!
    end

    module ClassMethods

      def [](namespace = :default, index)
        obj = get_setting(namespace, index)
        return obj.read_attribute(setting_value_field) if obj
        Defaults[namespace, index]
      end

      def []=(namespace = :default, index, value)
        #binding.pry
        obj = get_setting(namespace, index)
        if obj
          obj.write_attribute(setting_value_field, value)
          obj.save
          write_cache(obj)
        else
          obj = write_cache(self.create(setting_name_field => index, setting_namespace_field => namespace, setting_value_field => value))
        end
      end

      def delete_from_cache(setting)
        write_cache(setting,true)
      end

      def reset_cache!
        @@cache = { :default => {} }.with_indifferent_access
      end

      def cache
        # Do a deep copy
        Marshal.load(Marshal.dump(@@cache))
      end

      def cache!
        @@cache
      end

      protected

      def write_cache(setting, remove = nil)
        index, namespace = setting.read_attribute(setting_name_field), setting.read_attribute(setting_namespace_field)
        if @@cache[namespace] && @@cache[namespace].has_key?(index)
          if remove
            @@cache[namespace].delete(setting.read_attribute(setting_name_field))
          else
            @@cache[namespace][index] = setting
          end
        elsif !remove
          @@cache[namespace] = { index => setting }
          setting
        end
      end

      def read_cache(namespace, index)
        if @@cache[namespace]
          @@cache[namespace][index]
        end
      end

      def get_setting(namespace, index)
        if obj = read_cache(namespace, index)
          obj
        else
          obj = where(["#{setting_namespace_field} = ? AND #{setting_name_field} = ?", namespace, index]).first
          write_cache(obj) if obj
        end
      end
    end
  end
end
