class UsersController < ApplicationController

  get '/signup' do
    redirect '/tweets' if logged_in?    

    erb :'users/create_user'
  end
  
  post '/signup' do
    redirect '/signup' if params.values.any? { |p| p.blank? }

    @params = params
    @user = User.create(params)
    session[:user_id] = @user.id
    redirect '/tweets'
  end

  get '/login' do
    redirect '/tweets' if logged_in?

    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    redirect '/signup' unless user && user.authenticate(params[:password])

    session[:user_id] = user.id
    redirect "/tweets"    
  end

  get '/logout' do
    redirect '/' unless logged_in?

    session.destroy
    redirect '/login'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
end
