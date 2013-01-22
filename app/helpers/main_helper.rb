module MainHelper
	def fast_ltr_details(details_title, details_name, details_value, album_id)
		"<a href=\"javascript:void(0)\", class=\"#{details_name}-#{details_value.to_s}\", onclick=\"do_js_set_#{details_name}(#{album_id.to_s},#{details_value.to_s})\", title=\"#{details_title}\"></a>".html_safe
	end

	def fast_ltr_clear(album_id)
		"<a href=\"javascript:void(0)\", class=\"clear_button\", onclick=\"do_js_clear_details(#{album_id.to_s})\", title=\"Reset Selections\"></a>".html_safe
	end

end
