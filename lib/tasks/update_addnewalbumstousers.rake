namespace :update do
  desc "New albums need to be added to the details join table, first & last are the indexes of the new albums"
  task :addnewalbumstousers => :environment do
  
    users = User.find(:all)
    users.each do |user|
      (ENV['first']..ENV['last']).each do |i|
        detail = Detail.new
        detail.user_id = user.id
        detail.album_id = i
        detail.save
      end
    end
  end
end 
