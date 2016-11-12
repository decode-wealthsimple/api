require 'rest-client'
require 'json'

class NomadController < ApplicationController

	#returns full URL for the image of chosen city
	def image
		city_url = params[:url]

		res = RestClient.get('https://nomadlist.com/api/v2/list/cities/' + city_url, headers={})
		json = JSON.parse(res.body)
		image = json["result"][0]["media"]["image"]["1500"]
		image = "https://nomadlist.com" + image
		render json: { "image": image}
	end

end
