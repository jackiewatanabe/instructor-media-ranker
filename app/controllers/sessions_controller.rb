class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def login_form
  end

  def create
    auth_hash = request.env['omniauth.auth']

    user = User.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])


    if user.nil?
      user = User.create_from_github(auth_hash)
      # raise
      if user.nil?
        flash[:error] = "Could not log in successfully"
        redirect_to root_path
      end
    end

    session[:user_id] = user.id
      flash[:success] = "Logged in successfully!"
    # end
      redirect_to root_path
  end

  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
