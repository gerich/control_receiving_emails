class CreateIssuesImportEmails < ActiveRecord::Migration
  def change
    create_table :issues_import_emails do |t|
      t.string :login, :limit => 120, :null => false
      t.string :password, :null => false
      t.integer :tracker_id, :default => 0, :null => false
      t.integer :project_id, :default => 0, :null => false
      t.integer :server_id, :default => 0, :null => false
      t.integer :category_id, :null => false
    end
  end
end
