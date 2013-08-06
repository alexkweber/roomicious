class RemoveAddressFromPostings < ActiveRecord::Migration
  def up
    remove_column :postings, :address
  end

  def down
    add_column :postings, :address, :string
  end
end
