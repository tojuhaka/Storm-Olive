require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/blog'" do
    get '/blog'
    response.should have_selector('title', :content => "Blog")
  end
end
