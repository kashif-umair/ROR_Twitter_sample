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

    @pageTitle= "My Tweets"
     @tweets = Tweet.where user_id: current_user.id
     if @tweets.empty? 
      flash[:alert]="No tweets to show"
    else
      flash[:alert]=nil
    end
     @tweet=Tweet.new
     @page=2
      @button_text= "Tweet" 
     render "index.html.erb"
  end

  def search
    @pageTitle= "search results for  <small> #{params[:q]} </small>"
    @tweets = Tweet.where "content LIKE ?" ,"%#{params[:q]}%"
    if @tweets.empty? 
      flash[:alert]="No tweets found"
     else
      flash[:alert]=nil
    end
     @page=0
     @tweet=Tweet.new
     @button_text= "Tweet" 
     render "index.html.erb"
     
  end


  def index
    @pageTitle= "Public Tweets"
     @tweet = Tweet.new
     @tweets = Tweet.all
     if @tweets.empty? 
      flash[:alert]="No tweets to show"
      else
      flash[:alert]=nil
    end
     @page=1
      @button_text= "Tweet" 
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
    authorize! :edit, @tweet
    @button_text= "Update" 
  end

  # POST /tweets
  # POST /tweets.json
  def create

    @tweet = Tweet.new(tweet_params)
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
      params[:tweet][:user_id]=current_user.id
      params.require(:tweet).permit(:content, :user_id)
    end
end
