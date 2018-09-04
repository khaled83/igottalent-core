class AddApprovedAdminToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :approved_admin, :boolean
  end
end
