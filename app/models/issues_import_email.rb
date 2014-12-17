class IssuesImportEmail < ActiveRecord::Base
  unloadable

  scope :active, -> { where(active: true) }
  scope :has_project, -> { where('projects.id is not null') }
  scope :has_user, -> { where('users.id is not null') }

  attr_accessor :project_id
  attr_accessor :user_id

  validates :tracker, presence: true
  validates :issues_import_server, presence: true

  validates :user, :presence => true
  validates :project, :presence => true

  validates :login, presence: true
  validates :password, presence: true

  belongs_to :issue_category
  belongs_to :project
  belongs_to :tracker
  belongs_to :issues_import_server

  before_validation :set_category

  def attributes
    hash = super
    hash[:user_id] = user_id
    hash[:project_id] = project_id
    hash
  end

  def user_id
    return self.issue_category.assigned_to_id unless self.issue_category.nil?
    0
  end

  def project_id
    return self.issue_category.project_id unless self.issue_category.nil?
    0
  end

  def user
    self.issue_category.assigned_to  unless self.issue_category.nil?
  end

  def project
    self.issue_category.project unless self.issue_category.nil?
  end

  private 
  
  def set_category
    return if @user_id.to_i.nonzero?.nil? or @project_id.to_i.nonzero?.nil?
    name = "user: " + @user_id.to_s + " project: " + @project_id.to_s
    category = IssueCategory.where(project_id: @project_id, assigned_to_id: @user_id, name: name).first
    if category.nil? 
      category = IssueCategory.create(project_id: @project_id, assigned_to_id: @user_id, name: name)
    end
    self.issue_category = category
    self.issue_category_id = category.id
  end
end
