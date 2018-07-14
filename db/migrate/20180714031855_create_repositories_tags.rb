class CreateRepositoriesTags < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories_tags, id: false do |t|
      t.belongs_to :repository, index: true
      t.belongs_to :tag, index: true
    end
  end
end
