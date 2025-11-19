class AddSummaryToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :summary, :text
  end
end
