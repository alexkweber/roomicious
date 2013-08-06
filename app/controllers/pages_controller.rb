class PagesController < ApplicationController
  def about
  end

  def contact
  end

  def service
    respond_to do |format|
      format.html
      format.js
    end
  end
end
