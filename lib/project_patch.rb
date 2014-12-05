require_dependency 'project'

module ProjectPath
  def self.included(base)
    base.class_eval do
      unloadable
      has_many :issues_import_email, :dependent => :destroy    
    end
  end
end

Project.send(:include, ProjectPath)
