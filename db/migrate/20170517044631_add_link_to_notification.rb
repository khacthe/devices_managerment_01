class AddLinkToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :link, :string
  end
end
