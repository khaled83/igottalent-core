class RemoveVideoIdFromVideos < ActiveRecord::Migration[5.2]
  def change
    remove_column :videos, :video_id, :integer
  end
end
