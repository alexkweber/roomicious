class SessionsController < ApplicationController
  def new
    respond_to do |format|
      if logged_in? 
        format.html { redirect_to( root_url, :notice => "You're already logged in!" ) }
      else
        format.html
        format.js
      end
    end        
  end

  def create
    respond_to do |format|
      if user = User.authenticate(params[:email], params[:password])
        session[:user_id] = user.id
        format.html do
          redirect_to root_url, :notice => "Welcome back <%= user.name || user.email %>!"
        end
        format.js   { render :js => "window.location = '/'" }
      else
        format.html { redirect_to login_url, :notice => "Invalid email/password combination." }
        format.js   { redirect_to login_url, :notice => "Invalid email/password combination." }
      end
    end
  end
  
  def fbcreate
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    
    respond_to do |format|
      format.html { redirect_to root_path, notice:"Logged in!" }
      format.js   { render :js => "window.location = '/'" }
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out."
  end
end
