class AddReactionCountToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :reaction_count, :integer
  end
end
