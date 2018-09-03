class RenameApprovedToApprovedAdmin < ActiveRecord::Migration[5.2]
  def change
    rename_column :videos, :approved, :approved_admin
  end
end
