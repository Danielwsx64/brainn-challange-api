describe Tag, type: :model do
  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:repositories) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe '#as_json' do
    it 'returns a hash without created_at and updated_at keys' do
      tag = create(:tag)

      tag_as_json = tag.as_json

      expect(tag_as_json).to_not have_key('created_at')
      expect(tag_as_json).to_not have_key('updated_at')
    end
  end
end
