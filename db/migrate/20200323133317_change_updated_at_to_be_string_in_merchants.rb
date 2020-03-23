class ChangeUpdatedAtToBeStringInMerchants < ActiveRecord::Migration[5.2]
  def change
    change_column :merchants, :updated_at, :string
  end
end
