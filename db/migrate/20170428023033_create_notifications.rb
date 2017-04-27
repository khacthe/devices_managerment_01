class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :activity
      t.string :notifications
      t.boolean :read
      t.boolean :checked

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
