class AddPublicToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :public, :boolean, default: true
    add_column :discussions, :selected_user_list, :text
  end
end
