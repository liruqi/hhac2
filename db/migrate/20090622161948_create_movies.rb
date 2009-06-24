class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
      t.string :tags
      t.string :info
      t.string :path
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
