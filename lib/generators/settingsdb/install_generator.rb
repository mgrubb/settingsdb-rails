require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'
require 'active_record'
require 'settingsdb/generators/generated_attribute'

module SettingsDB::Generators # :nodoc: all
  class InstallGenerator < Rails::Generators::NamedBase
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration

    namespace "settingsdb:install"
    argument :name, :type => :string, :default => 'settings'
    argument :attributes, :type => :array, :default => [], :banner => "field:type[[:index][:default]] ..."
    source_root File.expand_path('../templates', __FILE__)


    desc "Creates a SettingsDB initializer, Model, and Migration"
    class_option :model, :desc => 'Generate the model', :type => :boolean, :default => true
    class_option :migration, :desc => 'Generate the migration', :type => :boolean, :default => true

    def add_settingsdb_model
      return if !options.model? || model_exists?
      invoke 'active_record:model', [name.singularize], :migration => false
    end

    def inject_settingsdb_content
      return if !options.model?
      inject_into_class(model_path, model_class, "  acts_as_setting\n")
    end

    def add_settingsdb_migration
      return if !options.migration?
      if migration_exists?
        migration_template 'migration_exists.rb', "db/migrate/settingsdb_add_settings_columns_to_#{table_name}"
      else
        migration_template 'migration.rb', "db/migrate/settingsdb_create_#{table_name}"
      end
    end

    def add_settingsdb_initializer
      return if initializer_exists?
      template 'initializer.rb', 'config/initializers/settingsdb.rb'
    end

    protected
    # override Rails::Generators::NamedBase#parse_attributes! to customize attribute parsing
    def parse_attributes!
      self.attributes = (attributes || []).map do |key_value|
        name, type, index, default = key_value.split(/:/)
        opts = {}
        if default
          opts[:default] = default
        end
        if index
          index_type, constraint = index.split(/,/)
          if constraint == 'not_null'
            opts[:null] = false
          end
        end
        create_attribute(name, type, index_type, opts)
      end
    end

    def create_attribute(*args)
      if Rails.version[0,3].to_f >= 3.2
        Rails::Generators::GeneratedAttribute.new(*args)
      else
        SettingsDB::Generators::GeneratedAttribute.new(*args)
      end
    end

    # Helper methods shamelessly copied from Devise
    def file_name
      name.underscore
    end

    def model_class
      class_name.singularize
    end

    def model_path
      @model_path ||= File.join('app', 'models', class_path, "#{file_name.singularize}.rb")
    end

    def migration_path
      @migration_path ||= File.join("db", "migrate")
    end

    def model_exists?
      File.exists?(File.join(destination_root, model_path))
    end

    def migration_exists?
      Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/settingsdb_create_#{table_name}.rb$/).first
    end

    def initializer_exists?
      File.exists?(File.join(destination_root, File.join(%w(config initializers settingsdb.rb))))
    end

  end
end
