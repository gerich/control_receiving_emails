class DeleteProjectId < ActiveRecord::Migration
  def change
    remove_column :issues_import_emails, :project_id
  end
end
