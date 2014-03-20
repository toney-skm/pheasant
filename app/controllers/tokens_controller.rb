class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user_from_token!

  # before_action :user_params, only: [:create]

  def create
    # email = user_params[:email]
    # password = user_params[:password]
    email = params[:email]
    password = params[:password]

    if email.nil? or password.nil?
      render status: 400, json: {message: "The request must contain the user email and password."}
      return
    end

    @user = User.find_by email: email.downcase

    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render status: 401, json: {message: "Invalid email or passoword."}
      return
    end

    @user.ensure_authentication_token!

    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render status: 401, json: {message: "Invalid email or passoword."}
    else
      render status: 200, json: {token: @user.authentication_token}
    end
  end

  def destroy
    @user = User.find_by authentication_token: params[:token]
    if @user.nil?
      logger.info("Token not found.")
      render status: 404, json: {message: "Invalid token."}
    else
      @user.reset_authentication_token!
      render status: 200, json: {token: params[:token]}
    end
  end

  def options
    head :ok
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
