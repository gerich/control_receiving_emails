class ChangeWrongDefaultValues < ActiveRecord::Migration
  def change
    change_column_default :issues_import_emails, :category_id, 0
    change_column_default :issues_import_emails, :issues_import_server_id, nil
  end
end
