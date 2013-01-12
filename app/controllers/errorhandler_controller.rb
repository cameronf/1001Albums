class ErrorhandlerController < ApplicationController
	def unknownaction
		@error_message = "Sorry, that URL doesn't exist on this server."

		respond_to do |format|
			format.fbml
			format.html 
		 	format.xml { render :xml => @error_message }
		end
		
	end
end
