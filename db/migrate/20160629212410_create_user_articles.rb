class CreateUserArticles < ActiveRecord::Migration
  def change
    create_table :user_articles do |t|
      t.integer :user_id
      t.integer :article_id
      t.integer :state, default: 0

      t.timestamps null: false
    end
  end
end