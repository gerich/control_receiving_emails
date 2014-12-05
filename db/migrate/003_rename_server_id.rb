class RenameServerId < ActiveRecord::Migration
  def change
   rename_column :issues_import_emails, :server_id, :issues_import_server_id
   rename_column :issues_import_emails, :category_id, :issue_category_id
  end
end
