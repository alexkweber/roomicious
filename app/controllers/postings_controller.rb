class PostingsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  
  def index
    if params[:keyword]
      coord = $PLACES[params[:keyword]] || Geocoder.coordinates("#{params[:keyword]} near CA, USA")
      @coord_str = "#{coord[0]}, #{coord[1]}"
      @postings = Posting.near(@coord_str.split(", "), 5)
    elsif params[:pricemin] || params[:pricemax]
      @postings = Posting.pricebetween(params[:pricemin], params[:pricemax])
    elsif params[:commit]
      @postings = case params[:commit]
                  when "All"            then Posting.all
                  when "Apartments"     then Posting.apartments
                  when "Houses"         then Posting.houses
                  when "Rooms"          then Posting.rooms
                  when "Shared-Rooms"   then Posting.shared
                  end
    else
      @postings = Posting.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @postings }
      if params[:keyword]
        format.js { render 'index_map' }
      else
        format.js
      end
    end
  end

  def show
    @posting = Posting.find(params[:id])
    @geo = "#{@posting.latitude},#{@posting.longitude}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posting }
      format.js
    end
  end

  def new
    @posting = current_user.postings.new

    respond_to do |format|
      format.html
      format.json { render json: @posting }
      format.js
    end
  end

  def edit
    @posting = current_user.postings.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @posting = current_user.postings.new(params[:posting])

    respond_to do |format|
      if @posting.save
        format.html { render @posting, notice: 'Posting was successfully created.' }
        format.json { render json: @posting, status: :created, location: @posting }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
        format.js   { redirect_to new_posting_path, alert: "#{ @posting.errors.full_messages.each {|msg| "<p>#{msg}</p>"} }" }
      end
    end
  end

  def update
    @posting = current_user.postings.find(params[:id])

    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        format.html { redirect_to @posting, notice: 'Posting was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
        format.js   { redirect_to edit_posting_path(@posting), alert: 'Something went wrong...' }
      end
    end
  end

  def destroy
    @posting = current_user.postings.find(params[:id])
    @posting.destroy

    respond_to do |format|
      format.html { redirect_to user_url(current_user) }
      format.json { head :no_content }
    end
  end
end
