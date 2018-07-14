class Repository < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :github_id, :name, :html_url, presence: true

  def as_json(*)
    super.except('created_at', 'updated_at')
  end
end
