describe User, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:repositories) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe '#as_json' do
    it 'returns a hash without created_at and updated_at keys' do
      user = create(:user)

      user_as_json = user.as_json

      expect(user_as_json).to_not have_key('created_at')
      expect(user_as_json).to_not have_key('updated_at')
    end
  end
end
