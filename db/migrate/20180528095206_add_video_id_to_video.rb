class AddVideoIdToVideo < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :video_id, :integer
  end
end
