class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :thumnail
      t.text :informations
      t.boolean :borrowed
      t.text :status
      t.string :slug

      t.references :workspace, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
