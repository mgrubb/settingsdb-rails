require 'active_support/core_ext/hash/indifferent_access'
class SettingsDB::Defaults

  ##
  # :call-seq:
  #   Defaults[:key] -> value (from :default namespace)
  #   Defaults[:p1, :key] -> value (from :p1 namespace)
  #
  # Returns the value for the index. If namespace is given
  # returns the value for the index in that namespace.
  # When no namespace is given, the :default namespace is used.
  def self.[](namespace = :default, index)
    @@defaults[namespace][index] if @@defaults[namespace]
  end

  ##
  # :call-seq:
  #   Defaults[:key] = value -> 'value' (in :default namespace)
  #   Defaults[:p1, :key] = value -> 'value' (in :p1 namespace)
  #
  # Sets the value for the index.
  # If a namespace is given then the index is set in that namespace
  # else it is set in the default namespace.
  def self.[]=(namespace = :default, index, value)
    if @@defaults[namespace] && @@defaults[namespace].has_key?(index)
      @@defaults[namespace][index] = value
    else
      @@defaults[namespace] = { index => value }
      value
    end
  end

  ##
  # :call-seq:
  #   Defaults.config -> hash
  #   Defaults.config {|config| ...}
  #
  # If given a block yields self. If no block is given
  # the hash of default values is returned.
  # === Example
  #   Defaults.config do |conf|
  #     conf[:key1] = value1
  #     conf[:ns1, :key1] = value2
  #   end
  #
  # If no block is given the default hash is returned and
  # can be manipulated directly:
  #
  #   default_hash = Defaults.config
  #   default_hash[:default][:key1] = value1
  #   default_hash[:ns1] = { :key1 => value2 }
  def self.config # :yields: config
    if block_given?
      yield self
    end
    defaults!
  end

  ##
  # :call-seq:
  #   reset! -> Defaults
  #
  # Deletes all the default settings.
  def self.reset!
    @@defaults = { :default => {} }.with_indifferent_access
    self
  end

  ##
  # :call-seq:
  #   defaults! -> hash
  #
  # Returns the actual reference to the internal defaults hash.
  # USE THIS WITH CARE!
  def self.defaults!
    @@defaults
  end

  ##
  # :call-seq:
  #   defaults -> hash
  #
  # Returns a deep copy of the defaults hash, modifying this will
  # have no impact on Defaults[] results.
  def self.defaults
    # Do a deep copy
    Marshal.load(Marshal.dump(@@defaults))
  end

  reset!
end
