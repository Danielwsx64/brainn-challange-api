class Tag < ApplicationRecord
  has_and_belongs_to_many :repositories

  validates :name, presence: true
  validates :name, uniqueness: true
end
