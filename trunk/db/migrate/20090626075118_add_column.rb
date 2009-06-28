class AddColumn < ActiveRecord::Migration
  def self.up
    add_column :movies, :album_id, :integer
#    Movie.update_all("album_id=1")
  end

  def self.down
  end
end
