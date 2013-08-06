class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string 'email'
      t.string 'phone'
      t.integer 'posting_id'
      t.integer 'following_id'
      t.string 'hashed_password'
      t.string 'salt'
      t.timestamps
    end
  end
end
