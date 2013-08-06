ENV['FACEBOOK_APP_ID'] = '155087377961375'
ENV['FACEBOOK_SECRET'] = '91b264c1e15ad9c9673a4f4da53d31d7'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],
            { :scope => 'email,user_birthday', :display => 'popup' }
end