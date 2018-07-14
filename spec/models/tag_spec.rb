describe Tag, type: :model do
  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:repositories) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
