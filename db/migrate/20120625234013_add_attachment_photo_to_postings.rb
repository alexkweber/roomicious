class AddAttachmentPhotoToPostings < ActiveRecord::Migration
  def self.up
    change_table :postings do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :postings, :photo
  end
end
