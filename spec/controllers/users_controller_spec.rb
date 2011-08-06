require 'spec_helper'

describe UsersController do
  render_views

  before (:each) do
    User.new(:name => "Toni Haka-Risku", 
             :email => "tojuhaka@gmail.com").save
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end


end
