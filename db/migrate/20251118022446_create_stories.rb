class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.string :name
      t.string :theme
      t.integer :age
      t.text :system_prompt
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
