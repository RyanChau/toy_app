class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commenter_id
      t.integer :micropost_id

      t.timestamps null: false
    end
    add_index :comments, :micropost_id
    add_index :comments, :commenter_id
  end
end
