class CreateDiscussionUsers < ActiveRecord::Migration
  def change
    create_table :discussion_users do |t|
      t.integer :discussion_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
