class CreateWorkspaces < ActiveRecord::Migration[5.0]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :slug

      t.timestamps
    end
  end
end
