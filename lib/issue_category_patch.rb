require_dependency 'issue_category'

# from https://github.com/edavis10/redmine-budget-plugin/
# /lib/issue_path.rb

module IssueCategoryPath
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      has_one :issues_import_email, :dependent => :nullify
    end
  end

  # class (static) methods
  module ClassMethods
  end

  # object methods
  module InstanceMethods
  end 

end

IssueCategory.send(:include, IssueCategoryPath)
