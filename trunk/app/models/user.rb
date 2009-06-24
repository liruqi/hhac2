class User < ActiveRecord::Base
  has_many :movies, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  validates_presence_of   :uname
  validates_uniqueness_of :uname

  attr_accessor :passwd_confirmation
  validates_presence_of     :passwd
  validates_confirmation_of :passwd

  validates_presence_of   :email

  def self.authenticate(uname, passwd)
    user = self.find_by_uname uname
    if user
      user = nil if user.passwd != passwd
    end
    user
  end

  def privilege
    case utype
      when 'administrator' then 3
      when 'manager'       then 2
      when 'member'        then 1
      else                      0
    end
  end
end
