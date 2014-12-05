class AddActiveEmailColumn < ActiveRecord::Migration
  def change
    add_column :issues_import_emails, :active, :boolean, :default => true, :null => false;
  end
end
