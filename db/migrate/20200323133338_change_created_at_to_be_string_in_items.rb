class ChangeCreatedAtToBeStringInItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :created_at, :string
  end
end
