class ChangeCreatedAtToBeStringInMerchants < ActiveRecord::Migration[5.2]
  def change
    change_column :merchants, :created_at, :string
  end
end
