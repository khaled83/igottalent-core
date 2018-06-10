class AddApprovedUserToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :approved_user, :boolean
  end
end
