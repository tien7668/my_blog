class CreateDefaultPost
  def call
    users = User.where("username like ? ","%seed_user_%" )
    users.each do |u|
      if (u.posts.length == 0 )
          (1..2).each do |i|
            post = Post.create({title: u.username + " Post " + i.to_s, user_id: u.id, content:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."})
          end
      end
    end
  end
end