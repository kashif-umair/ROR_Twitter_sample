class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end 
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, :alert => "Record Not Found"
  end
  # GET /tweets
  # GET /tweets.json
  def mytweets
    authorize! :mytweets, Tweet
     @tweets = Tweet.where user_id: current_user.id
     @tweet=current_user.tweets.new
     @page=2
   end

  def search
    authorize! :search ,Tweet
    @tweets = Tweet.where "content LIKE ?" ,"%#{params[:q]}%"
    @page=0
  end


  def index
     @tweet = current_user.tweets.new
     @tweets = Tweet.all
     @page=1
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
     
  end

  # GET /tweets/new
  def new
    authorize! :new, @tweet
    @tweet = current_user.tweets.new

  end

  # GET /tweets/1/edit
  def edit
    authorize! :edit, @tweet
  end

  # POST /tweets
  # POST /tweets.json
  def create
 
     @tweet = current_user.tweets.new(tweet_params)
     authorize! :create, @tweet
     respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweets_url}
        format.json { render action: 'show', status: :created, location: @tweet }
      else
        format.html { render action: 'new' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    authorize! :update, @tweet
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    authorize! :destroy, @tweet
    @tweet.destroy
    respond_to do |format|
    format.html { redirect_to tweets_url }
    format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:content, :user_id)
    end
 
end
