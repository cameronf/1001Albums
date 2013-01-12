namespace :main do
	desc "iterate over all the displaynames to create a sortname"
	task :addsortname => :environment do

	require "highline/system_extensions"
	include HighLine::SystemExtensions

		# default options; will be camelized and converted 
		# to REST request parameters.
	
		puts("Enter the album number you want to start with")
		album_num = STDIN.gets.to_i

		while(album_num <= 1001)
			album = Album.find_by_id(album_num)
			print(album.id.to_s + " - Artist is " + album.artist)
			word_num = get_character
	
			if (word_num == 127)
				puts('')
				puts("Going back to last entry")
				album_num = album_num - 1
			else
				if (word_num.chr == 'x'|| word_num.chr =='q')
					break
				else
					if (word_num.chr =='m')
						print(" DO IT MANUALLY")
						album.sortname = 'MANUAL'
						album.save
						album_num = album_num + 1
					else
						word_num = word_num.chr.to_i - 1
						if (word_num < 0 or word_num > 8)
							print(" *** Out Of Range ***")
						else
							if word_num == 0
								album.sortname = album.artist
								album.save
								album_num = album_num + 1
							else
								word_chunks = Array.new(album.artist.split)
								# puts(word_chunks.length.to_s)
								arranged_chunks = Array.new(word_chunks.last(word_chunks.length - word_num) + word_chunks.first(word_num)) 
								# arranged_chunks = Array.new(word_chunks.first(word_chunks.length-word_num)) 
								# arranged_chunk2 = Array.new(word_chunks.last(word_num)) 
								# arranged_chunks = Array.new(word_chunks.first(word_chunks.length-word_num) << word_chunks.last(word_num)) 
								album.sortname = String.new
								arranged_chunks.each do |s|
									album.sortname = album.sortname + s.to_s
									album.sortname = album.sortname + ' '
								end	
								album.sortname.rstrip!
								print(" Sortname = " + album.sortname)
								album.save	
								album_num = album_num + 1
							end
						end
					end
				end
			end

			puts('')
		end

		puts('')
		puts('Quitting')
	end
end
