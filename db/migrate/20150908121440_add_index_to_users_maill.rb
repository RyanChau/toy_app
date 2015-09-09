class AddIndexToUsersMaill < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true

    # This uses a Rails method called add_index to add an index on the email column of the users table.
    # The index by itself doesn’t enforce uniqueness, but the option unique: true does.
  end
end
