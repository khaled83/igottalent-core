class AddLiveToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :live, :boolean, default:false
    add_index :videos, :live
  end
end
