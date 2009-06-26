class Movie < ActiveRecord::Base
  belongs_to :user
  belongs_to :album
  has_many :comments, :dependent => :destroy
end
