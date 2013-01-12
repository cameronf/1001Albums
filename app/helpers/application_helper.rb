# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def home_url()
		return $FB_APP_ROOT+"/showmyalbumstab"
	end

	def build_image_link(album)
		"<a href=\"http://www.amazon.com/gp/product/#{album.asin}?ie=UTF8&tag=1001album-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=#{album.asin}\" target=\"_blank\" title=\"Buy From Amazon\"><img height=\"100\" src=\"http://1001Albums.fisheyedev.com/images/#{album.id.to_s}.jpg\" width=\"100\" /></a>"
	end

	def build_amazon_link(asin)
		"<a href=\"http://www.amazon.com/gp/product/#{asin}?ie=UTF8&tag=1001album-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=#{asin}\" target=\"_blank\" title=\"Buy From Amazon\" class=\"amazon_link\" ></a>"
	end

	def build_apple_link(apple_id)
		"<a href=\"http://click.linksynergy.com/fs-bin/stat?id=fYzKU2MsuSo&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252FWebObjects%252FMZStore.woa%252Fwa%252FviewAlbum%253Fid%253D#{apple_id}%2526s%253D143441%2526partnerId%253D30\" class=\"apple_link\" title=\"Buy From iTunes\" target=\"_blank\"></a>"
	end

	def build_wanted_amazon_link(asin)
		"<a href=\"http://www.amazon.com/gp/product/#{asin}?ie=UTF8&tag=1001album-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=#{asin}\" target=\"_blank\" title=\"Buy From Amazon\" class=\"wanted_amazon_link\" ></a>"
	end

	def build_wanted_apple_link(apple_id)
		"<a href=\"http://click.linksynergy.com/fs-bin/stat?id=fYzKU2MsuSo&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252FWebObjects%252FMZStore.woa%252Fwa%252FviewAlbum%253Fid%253D#{apple_id}%2526s%253D143441%2526partnerId%253D30\" class=\"wanted_apple_link\" title=\"Buy From iTunes\" target=\"_blank\"></a>"
	end

end
