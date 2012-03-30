require 'settingsdb/defaults'
require 'active_support/concern'
require 'active_support/core_ext/hash/indifferent_access'
require 'yaml'

module SettingsDB::Settings # :nodoc:
  extend ActiveSupport::Concern

  included do
    reset_cache!
  end

  def remove_from_cache # :nodoc:
    self.class.delete_from_cache(self)
  end

  module ClassMethods

    ##
    # :call-seq:
    #   Model[:key] -> value
    #   Model[:namespace, :key] -> value
    #
    # Returns the value for the given key.
    # If a namespace is given then the key lookup is restricted
    # to that namespace. Unqualified keys are looked up in the
    # +:default+ namespace.
    def [](namespace = :default, index)
      obj = get_setting(namespace, index)
      return obj.read_attribute(setting_value_field) if obj
      SettingsDB::Defaults[namespace, index]
    end


    ##
    # :call-seq:
    #   Model[:key] = value -> value
    #   Model[:namespace, :key] = value -> value
    #
    # Sets the value for +:key+ to +value+ and commits the new value to
    # the database. If +:namespace+ is given, the key is set in that
    # namespace only, if +:namespace+ is not given then +:default+ is
    # used.
    def []=(namespace = :default, index, value)
      obj = get_setting(namespace, index)
      if obj
        obj.write_attribute(setting_value_field, value)
        obj.save
        write_cache(obj)
      else
        obj = write_cache(self.create(setting_name_field => index, setting_namespace_field => namespace, setting_value_field => value))
      end
    end

    def delete_from_cache(setting) # :nodoc:
      write_cache(setting,true)
    end

    ##
    # :call-seq:
    #   reset_cache! -> true
    #
    # Resets the internal setting cache
    def reset_cache!
      @@cache = { :default => {} }.with_indifferent_access
      true
    end

    ##
    # :call-seq:
    #   cache -> hash
    #
    # Returns a deep copy of the internal setting cache
    def cache
      # Do a deep copy
      Marshal.load(Marshal.dump(@@cache))
    end

    ##
    # :call-seq:
    #   cache! -> hash
    #
    # Returns a reference to the internal setting cache.
    # USE WITH CAUTION!
    def cache!
      @@cache
    end

    protected
    def write_cache(setting, remove = nil) # :nodoc:
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

    def read_cache(namespace, index) # :nodoc:
      if @@cache[namespace]
        @@cache[namespace][index]
      end
    end

    def get_setting(namespace, index) # :nodoc:
      if obj = read_cache(namespace, index)
        obj
      else
        obj = where(["#{setting_namespace_field} = ? AND #{setting_name_field} = ?", namespace, index]).first
        write_cache(obj) if obj
      end
    end
  end
end
