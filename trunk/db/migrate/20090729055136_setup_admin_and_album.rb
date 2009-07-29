class SetupAdminAndAlbum < ActiveRecord::Migration
  def self.up
    root = User.create :uname => 'root', :passwd => 'admin1234',
        :email => 'webmaster@hhac.com', :utype => 'administrator'
    if root   # root.id = 1
      Album.create :title => 'default', :user_id => root.id
    end
  end

  def self.down
    Album.find(1).destroy   # the 'default' album
    User.find(1).destroy    # the 'root' user
  end
end
