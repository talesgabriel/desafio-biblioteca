class CreateLibrarians < ActiveRecord::Migration[8.1]
  def change
    create_table :librarians do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :must_change_password, null: false, default: false
      t.string :auth_token

      t.timestamps
    end
    add_index :librarians, :email, unique: true
    add_index :librarians, :auth_token, unique: true
  end
end
