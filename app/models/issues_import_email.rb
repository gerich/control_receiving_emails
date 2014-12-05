class IssuesImportEmail < ActiveRecord::Base
  unloadable

  validates :project, presence: true
  validates :tracker, presence: true
  validates :issues_import_server, presence: true

  validates :login, presence: true
  validates :password, presence: true

  belongs_to :issue_category
  belongs_to :project
  belongs_to :tracker
  belongs_to :issues_import_server
end
