require 'ruby-debug'

class UsersController < ApplicationController
  def new
    @title = "Sign up"
  end
  
  def show
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @user = User.new(:name => "Not found",
                       :email => "notfound@error.com")
    end
  end
end
