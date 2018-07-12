class Repository < ApplicationRecord
  belongs_to :user

  validates :github_id, :name, :html_url, :language, presence: true
end
