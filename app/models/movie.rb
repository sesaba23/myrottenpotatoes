class Movie < ActiveRecord::Base

	# This method gets a list of distinct type of rating that are inside the 'rating'
	# column of the 'Movies' table
	def self.get_list_of_ratings
		ratings = select(:rating).distinct
		ratings.collect do |rating|
			rating.rating
		end
	end
end
