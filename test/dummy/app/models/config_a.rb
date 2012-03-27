class ConfigA < ActiveRecord::Base
  acts_as_setting :setting_name_field => :key, :setting_namespace_field => :scope
end
