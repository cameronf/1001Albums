module FBUtils
  def self.get_friends(graph)
    fb_friends_ids = graph.get_connections("me", "friends").map {|obj| obj['id'] }
    friends_with_app = User.where(:fb_user_id => fb_friends_ids)
    return friends_with_app
  end
end
