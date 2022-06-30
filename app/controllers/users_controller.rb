require 'json'

class UsersController < ApplicationController
  
  # /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def create
    @user = User.create!(user_params)
    render json: { user: { _id: @user[:_id].to_s, name: @user[:name] } }, status: :ok
  rescue Mongoid::Errors::Validations => e
    render json: { errors: e.message.errors }, status: :unprocessable_entity
  end

  # /user/:_id
  def show 
    @user = User.find(params[:_id])
    render json: { user: { _id: @user[:_id].to_s, name: @user[:name] } }, status: :ok
  rescue Mongoid::Errors::DocumentNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  private
  def user_params
    params.require(:user).permit(:_id, :name)
  end
end
