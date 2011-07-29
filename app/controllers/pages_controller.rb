class PagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def about
    @title = 'About'
  end

  def blog
    @title = "Blog"
  end

end
