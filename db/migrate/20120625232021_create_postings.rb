class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.string 'address'
      t.decimal 'rent',           :precision => 8, :scale => 2
      t.integer 'user_id'
      t.string 'property_type'
      t.float 'latitude'
      t.float 'longitude'
      t.timestamps
    end
  end
end
