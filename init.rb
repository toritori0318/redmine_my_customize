require 'redmine'

Rails.configuration.to_prepare do
  unless MyHelper.included_modules.include?(RedmineMyCustomize::Patches::MyHelper)
    MyHelper.send(:include, RedmineMyCustomize::Patches::MyHelper)
  end
end

Redmine::Plugin.register :redmine_my_customize do
  name 'Redmine My Customize plugin'
  author 'toritori0318'
  description 'This is a plugin for Redmine. additional widgets for My page.'
  version '0.1.0'
  requires_redmine :version_or_higher => '3.0.0'
end
