class AddFollowToUser < ActiveRecord::Migration
  def change
    add_column :users, :auto_follow, :boolean, default: true
  end
end
