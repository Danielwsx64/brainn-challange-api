class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.integer :github_id
      t.string :name
      t.string :description
      t.string :html_url
      t.string :language
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
