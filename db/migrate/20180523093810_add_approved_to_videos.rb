class AddApprovedToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :approved, :boolean, default: false
  end
end
