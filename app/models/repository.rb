class Repository < ApplicationRecord
  belongs_to :user

  validates :github_id, :name, :html_url, :language, presence: true

  def as_json(*)
    super.except('created_at', 'updated_at')
  end
end
