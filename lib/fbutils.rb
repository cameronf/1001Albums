module FBUtils
  def self.get_friends(graph)
    # getting connections - need to page through them unfortunately
    fb_friends = []
    g = graph.get_connections("me","friends")
    begin
      fb_friends += g
      g = g.next_page
    end while g != []
    
    fb_friends = [graph.get_object("me")] + fb_friends
    fwas = User.where(:fb_user_id => fb_friends.map {|obj| obj["id"]})
    fwa_ids = fwas.map(&:fb_user_id)
    friends_with_app = fb_friends.select {|x| fwa_ids.include? x["id"].to_i}

    pictures = graph.batch do |batch_api|
      friends_with_app.each do |fwa|
        batch_api.get_picture(fwa["id"])
      end
    end

    friends_with_app.each_with_index do |fwa,i|
      fwa["image"] = pictures[i]
      fwa["user_id"] = fwas.select {|x| x.fb_user_id == fwa["id"].to_i}.first.id
    end

    return friends_with_app
  end
end
