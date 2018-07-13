describe Repository, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:html_url) }
    it { is_expected.to validate_presence_of(:language) }
  end

  describe '#as_json' do
    it 'returns a hash without created_at and updated_at keys' do
      repository = create(:repository)

      repository_as_json = repository.as_json

      expect(repository_as_json).to_not have_key('created_at')
      expect(repository_as_json).to_not have_key('updated_at')
    end
  end
end
