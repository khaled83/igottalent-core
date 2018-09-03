class ChangeColumnsInVideosTotalCountsDefaultsToZero < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:videos, :reaction_count, 0)
    change_column_default(:videos, :comment_count, 0)
  end
end
