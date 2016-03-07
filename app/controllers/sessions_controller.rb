class SessionsController < ApplicationController
  def new
  end

  def create_oauth
    user = User.find_by(username: env['omniauth.auth'].info.nickname)
    if user
      if !user.password_digest.nil?
        redirect_to :back, notice: "Username is take. You can't sign in with your GitHub account"
      elsif user.active
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      end
    else
      user = User.new(username: env['omniauth.auth'].info.nickname)
      user.active = true
      user.save(validate: false)
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome!"
    end
  end

  def create
    user = User.find_by username: params[:username]
    if user.password_digest.nil?
      redirect_to :back, notice: "You need to sign in with GitHub"
    else
      if user && user.authenticate(params[:password])
        if user.active
          session[:user_id] = user.id
          redirect_to user_path(user), notice: "Welcome back!"
        else
          redirect_to :back, notice: "Your account is frozen, please contact admin"
        end
      else
        redirect_to :back, notice: "Username and/or password mismatch"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end