describe User, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:repository) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
