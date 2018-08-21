class AddRankToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :rank, :integer
  end
end
