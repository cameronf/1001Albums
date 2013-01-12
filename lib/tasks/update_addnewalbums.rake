namespace :update do
  desc "take a csv file and add the new albums from it, fname contains the CSV file, delta contains the string indicating the change year"
  task :addnewalbums => :environment do
  
    require 'csv'

    CSV.open(RAILS_ROOT + "/lib/tasks/#{ENV['fname']}", 'r') do |album|
      Album.create( :year => album[0],
                    :title => album[1],
                    :artist => album[2],
                    :asin => album[3],
                    :apple_id => album[4],
                    :sortname => album[5],
                    :delta => ENV['delta'] )
    end 
  end
end
