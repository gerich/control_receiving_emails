class CreateIssuesImportServers < ActiveRecord::Migration
  def change
    create_table :issues_import_servers do |t|
      t.string :address, :limit => 120, :null => false
      t.integer :port, :limit => 5, :null => false
      t.boolean :ssl, :default => false, :null => false
    end
  end
end
