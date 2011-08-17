require 'spec_helper'

describe UsersController do
  render_views

  before (:each) do
    User.new(:name => "Toni Haka-Risku",
             :email => "tojuhaka@gmail.com").save
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user.id
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user.id
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user.id
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not chante(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'ne' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should render the 'ne' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  end
end
