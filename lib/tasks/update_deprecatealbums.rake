namespace :update do
  desc "hardcode an array of IDs and set the delta to deleted"
  task :deprecatealbums => :environment do
  
    deprecatedalbums = [972,963,1000,980,964,956,959,998,968,999,986,962,987,965,961,989,969,960,1001,996]
    deprecatedalbums.each do |id|
      a = Album.find(id)
      a.delta = "Deleted 2008"
      a.save
    end 
  end
end
