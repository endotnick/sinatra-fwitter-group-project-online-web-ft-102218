class TweetsController < ApplicationController

  get '/tweets' do
    redirect '/login' unless logged_in?

    @user = User.find_by(session[:user_id])
    @tweets = Tweet.all
    erb :'tweets/tweets'
  end

  post '/tweets' do 
    redirect '/tweets/new' if params.values.any? { |p| p.blank? }

    tweet = Tweet.new(params)
    tweet.user_id = session[:user_id]
    tweet.save
    redirect '/tweets'
  end

  get '/tweets/new' do
    redirect '/login' unless logged_in?

    erb :'tweets/new'
  end

  get '/tweets/:id' do
    redirect '/login' unless logged_in?

    @tweet = Tweet.find_by(params[:id])
    erb :'tweets/show_tweet'
  end
  
  delete '/tweets/:id' do
    redirect '/login' unless logged_in?

    tweet = Tweet.find_by_id(params[:id])
    tweet.delete if tweet && tweet.user == current_user
    redirect to '/tweets'
  end

  get '/tweets/:id/edit' do
    redirect '/login' unless logged_in?

    @tweet = Tweet.find_by(params[:id])
    erb :'tweets/edit_tweet'
  end

  patch '/tweets/:id' do
    redirect "/tweets/#{params[:id]}/edit" if params[:content].blank?

    tweet = Tweet.find_by(params[:id])
    tweet.content = params[:content]
    tweet.save
    redirect "/tweets/#{tweet.id}"
  end
end
