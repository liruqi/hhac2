class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :uname
      t.string :passwd
      t.string :email
      t.string :utype

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
