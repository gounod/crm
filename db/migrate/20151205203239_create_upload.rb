class CreateUpload < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.attachment :image
      t.integer :discussion_id
      t.timestamps null: false
    end
  end
end
