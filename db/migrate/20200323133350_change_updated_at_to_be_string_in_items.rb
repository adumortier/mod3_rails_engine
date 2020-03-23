class ChangeUpdatedAtToBeStringInItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :updated_at, :string
  end
end
