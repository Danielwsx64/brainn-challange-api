FactoryBot.define do
  factory :repository do
    github_id 1
    name 'repo_name'
    description 'my awesome repo'
    html_url 'https://github.com/user/repo'
    language 'assembly'
    user

    factory :repository_with_tags do
      transient do
        tags_count 2
      end

      after(:create) do |repository, evaluator|
        create_list(:tag, evaluator.tags_count, repositories: [repository])
      end
    end
  end
end
