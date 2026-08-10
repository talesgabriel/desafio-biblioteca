class CreateLibraryUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :library_users do |t|
      t.string :full_name, null: false
      t.string :cpf, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :loan_password_digest, null: false

      t.timestamps
    end
    add_index :library_users, :cpf, unique: true
    add_index :library_users, :email, unique: true
  end
end
