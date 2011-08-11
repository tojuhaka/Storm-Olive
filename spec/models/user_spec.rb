# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
  before (:each) do
    @attr = {:name => "Example user", 
             :email => "user@example.com", 
             :password => "foobar", 
             :password_confirmation => "foobar"}
  end

  it "Should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require length for name" do
    long_name = "s" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end 

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should valid email addresses" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |addr|
      invalid_email_user = User.new(@attr.merge(:email => addr))
      invalid_email_user.should be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject duplicate email addresses with case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require a matchin password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid"))
        .should_not be_valid
    end

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => ""))
        .should_not be_valid
    end

    it "should reject long passwords" do
      long = "a"*41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a"*5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before (:each) do
      @user = User.create!(@attr)
    end
    
    it "should have and encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
       @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the password doesn't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password = User.authenticate(@attr[:email], "wrongpass")
        wrong_password.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return user on email/password match" do
        user = User.authenticate(@attr[:email], @attr[:password])
        user.should == @user
      end
    end
  end
end
