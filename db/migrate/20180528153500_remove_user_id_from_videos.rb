class RemoveUserIdFromVideos < ActiveRecord::Migration[5.2]
  def change
    remove_column :videos, :user_id, :integer
  end
end
