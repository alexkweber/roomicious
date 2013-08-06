require 'digest/sha2'
class User < ActiveRecord::Base
  attr_accessible :email, :phone, :password, :provider, :uid, :name, :oauth_token, :oauth_expires_at
  attr_reader :password
  attr_accessor :password_confirmation
  
  has_many :postings, :dependent => :destroy
  validates :email, uniqueness: true, :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
  
  def email_added
    Notifier.delay.email_added(self)
  end
  
  def self.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + 'kishin' + salt)
  end
    
  def self.authenticate( email, password )
    if user = find_by_email(email)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.hashed_password = User.encrypt_password(password, salt)
    end
  end
  
  private
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end