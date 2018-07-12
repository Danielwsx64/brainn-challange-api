FactoryBot.define do
  factory :repository do
    github_id 1
    name 'repo_name'
    description 'my awesome repo'
    html_url 'https://github.com/user/repo'
    language 'assembly'
    user nil
  end
end
