class AddColumn < ActiveRecord::Migration
  def self.up
    add_column :movies, :album_id, :integer
  end

  def self.down
  end
end
