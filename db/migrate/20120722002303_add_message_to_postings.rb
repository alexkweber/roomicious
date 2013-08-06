class AddMessageToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :message, :text
  end
end
