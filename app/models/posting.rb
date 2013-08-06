class Posting < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :rent, :street, :city, :state, :photo, :property_type, :message
  validates :street, :city, :state, presence: true
  validates :rent, presence: true, numericality: true

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  
  geocoded_by :address
  after_validation :geocode
  
  belongs_to :user
  has_attached_file :photo,
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    :styles => { :small => "150x150>", :medium => "300x300>" },
                    :path => "postings/:id/:style/:basename.:extension"

  default_scope order: "postings.created_at DESC"
  
  scope :sounds_like, lambda { |keyword| where("postings.city LIKE ?", "%#{keyword}%") }
  scope :apartments, where("property_type LIKE ?", "apartment")
  scope :houses, where("property_type LIKE ?", "house")
  scope :rooms , where("property_type LIKE ?", "room")
  scope :shared, where("property_type LIKE ?", "shared")

  def self.pricebetween(pricemin, pricemax)
    pricemin = 0 if pricemin.empty?
    pricemax = 10000 if pricemax.empty?
    where("rent > ? AND rent < ?", pricemin, pricemax)
  end
  
  def address
    [street, city, state].join(', ')
  end
end