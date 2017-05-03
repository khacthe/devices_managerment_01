class CreateBorrowDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :borrow_devices do |t|
      t.datetime :borrow_date_from
      t.datetime :borrow_date_to
      t.integer :status, default: 1
      t.boolean :borrow_type

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
