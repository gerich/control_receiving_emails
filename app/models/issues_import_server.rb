class IssuesImportServer < ActiveRecord::Base
  unloadable
  validates :address, :presence => true, length: { maximum: 120 }
  validates :port, :presence => true, numericality: { only_integer: true, greater_than: 1, less_than: 64 * 1024 }

  has_many :issues_import_email, :dependent => :destroy 
end
