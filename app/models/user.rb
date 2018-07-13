class User < ApplicationRecord
  has_many :repositories

  validates :name, presence: true

  def as_json(*)
    super.except('created_at', 'updated_at')
  end
end
