class User < ApplicationRecord
  has_many :repository

  validates :name, presence: true
end
