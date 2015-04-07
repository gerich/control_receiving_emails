require_dependency 'mail_handler'

# from https://github.com/edavis10/redmine-budget-plugin/
# /lib/issue_path.rb

module MailHandlerPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end

  # class (static) methods
  module ClassMethods
  end

  # object methods
  module InstanceMethods
  end 

end

IssueCategory.send(:include, MailHandlerPatch)
