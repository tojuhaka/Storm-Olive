require 'spec_helper'

describe UsersController do
  render_views

  before (:each) do
    User.new(:firstname => "Toni",
             :lastname => "Haka-Risku",
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
      response.should have_selector("title", :content => @user.nick)
    end

    it "should include the user's name" do
      get :show, :id => @user.id
      response.should have_selector("h1", :content => @user.nick)
    end

    it "should have a profile image" do
      get :show, :id => @user.id
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :firstname => "", :lastname => "", :nick => "", :email => "", 
                  :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
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

    describe 'success' do
      before (:each) do 
        @attr = { :firstname => "New", :lastname => "User", :nick => "Exus",
                  :email => "user@example.com", :password => "foobar", 
                  :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do 
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome!/i
      end
    end
    describe "GET 'edit'"
      before (:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
    end
end
