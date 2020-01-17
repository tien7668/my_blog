json.id               @post.id
json.title            @post.title
json.content          (ActionController::Base.helpers.sanitize @post.content.gsub("\n", "<br />")[0..500], tags: %w(strong br))
json.photo            @post.photo.try(:url)
json.categories       @post.categories.map{|i| i.name}
json.tag_list         @post.tag_list
json.user             @post.user
json.created_at       @post.created_at.strftime("%d-%m-%Y")