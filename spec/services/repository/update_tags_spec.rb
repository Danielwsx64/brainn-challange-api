describe Services::Repository::UpdateTags do
  describe '#execute' do
    it 'update repositories tags and return true' do
      repository = create(:repository)

      tags = %w[docker devops]

      service = described_class.new(
        repository: repository,
        tags: tags
      )

      expect(service.execute).to be(true)
    end

    it 'update repository tags' do
      repository = create(:repository)

      tags = %w[docker devops]

      service = described_class.new(
        repository: repository,
        tags: tags
      )

      expect { service.execute }.to change(
        repository.tags,
        :count
      ).from(0).to(2)
    end

    it 'update repository to keep just new tags' do
      repository = create(:repository_with_tags)

      new_tags = %w[docker devops]

      described_class.new(
        repository: repository,
        tags: new_tags
      ).execute

      repository_tags_names = repository.tags.map(&:name)

      expect(repository_tags_names).to eq(new_tags)
    end

    context 'When repository already has tag' do
      it 'not duplicate association' do
        tag = create(:tag)

        repository = create(:repository, tags: [tag])

        new_tags = [tag.name]

        expect do
          described_class.new(
            repository: repository,
            tags: new_tags
          ).execute
        end.to_not change(repository.tags, :count)
      end
    end

    context 'When can not update repositories tags' do
      it 'raise a error' do
        repository = create(:repository)

        tags = 'invalid params to raise error'

        service = described_class.new(repository: repository, tags: tags)

        expect { service.execute }.to raise_error(
          Services::Repository::UpdateTags::FailureOnUpdate
        )
      end
    end
  end
end
