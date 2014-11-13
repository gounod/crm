class AddYubikeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :yubikey, :string
  end
end
