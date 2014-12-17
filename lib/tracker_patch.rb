require_dependency 'tracker'

module TrackerPath
  def self.included(base)
    base.class_eval do
      unloadable
      has_many :issues_import_email, :dependent => :nullify
    end
  end
end

Tracker.send(:include, TrackerPath)
