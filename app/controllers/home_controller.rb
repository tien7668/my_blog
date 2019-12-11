class HomeController < ApplicationController
  def index
    @posts = Post.all.order("created_at desc")
  end

  def about_us
    @post = Post.find_by("static_id = 'about_us' ")
  end

  def service
  end

end
