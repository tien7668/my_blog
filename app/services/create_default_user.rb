class CreateDefaultUser
  def call
    (1..10).each do |i|
      temp = 'user_'+i.to_s
      user = User.find_or_create_by!(username: temp) do |user|
        user.email = temp+'@gmail.com'
        user.password = temp
        user.password_confirmation = temp
        user.name = temp
        user.username = temp
        user.slug = temp
        user.role = :user
      end
    end
  end
end