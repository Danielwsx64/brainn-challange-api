module Services
  module Repository
    class UpdateTags
      FailureOnUpdate = Class.new(StandardError)

      def initialize(repository:, tags:)
        @repository = repository
        @tags = tags
      end

      def execute
        remove_unwanted_tags

        repository.tags << sanitized_tags

        true
      rescue StandardError => exception
        raise FailureOnUpdate, exception.message
      end

      private

      attr_reader :repository, :tags

      def sanitized_tags
        @sanitized_tags ||= tags
          .map(&:downcase)
          .uniq
          .map(&find_or_create)
      end

      def find_or_create
        lambda do |tag_name|
          tag = Tag.find_by(name: tag_name)

          return tag if tag.present?

          Tag.create(name: tag_name)
        end
      end

      def wanted_tags_id
        sanitized_tags.map(&:id)
      end

      def unwanted_tags
        repository.tags.where.not(id: wanted_tags_id)
      end

      def remove_unwanted_tags
        repository.tags.delete(unwanted_tags)
      end
    end
  end
end
