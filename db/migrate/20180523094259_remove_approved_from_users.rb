class RemoveApprovedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :approved, :boolean
  end
end
