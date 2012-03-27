require 'active_support/core_ext/hash/indifferent_access'
module SettingsDB
  class Defaults

    def self.[](namespace = :default, index)
      @@defaults[namespace][index] if @@defaults[namespace]
    end

    def self.[]=(namespace = :default, index, value)
      if @@defaults[namespace] && @@defaults[namespace].has_key?(index)
        @@defaults[namespace][index] = value
      else
        @@defaults[namespace] = { index => value }
        value
      end
    end

    def self.config
      if block_given?
        yield self
      end
      self
    end

    def self.reset!
      @@defaults = { :default => {} }.with_indifferent_access
      self
    end

    def self.defaults!
      @@defaults
    end

    def self.defaults
      # Do a deep copy
      Marshal.load(Marshal.dump(@@defaults))
    end

    reset!
  end
end
