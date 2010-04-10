require 'redmine'

Redmine::Plugin.register :redmine_my_customize do
  name 'Redmine My Customize plugin'
  author 'toritori0318'
  description 'This is a plugin for Redmine. additional widgets for My page.'
  version '0.0.3'
  requires_redmine :version_or_higher => '0.9.0'
end
