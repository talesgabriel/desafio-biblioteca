class CreateLoans < ActiveRecord::Migration[8.1]
  def change
    create_table :loans do |t|
      t.references :book, null: false, foreign_key: true
      t.references :library_user, null: false, foreign_key: true
      t.references :librarian, null: false, foreign_key: true
      t.date :loan_date, null: false
      t.date :due_date, null: false
      t.date :return_date
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :loans, :status
    add_index :loans, :due_date
  end
end
