require 'redmine'

require_dependency 'issue_category_patch'
require_dependency 'tracker_patch'

Redmine::Plugin.register :control_receiving_emails do
  name 'Control Receiveng emails plugin'
  author 'Alexandr Generalov'
  description 'A plugin for managing emails for import isses'
  version '0.0.1'

  settings :default => {:emails => []}, :partial => 'settings/control_receiving_emails_settings'

  menu :admin_menu, :control_receiving_emails, { :controller => 'import', :action => 'show' }, :caption => :menu_caption
end
