require 'rest-client'
require 'json'

class NomadController < ApplicationController

	def cities
		url = 'https://nomadlist.com/api/v2/list/cities'
		res = RestClient.get(url, headers={})
		dict = JSON.parse(res.body)
		cities = dict["result"].map{ |item| item["info"]["city"]["name"] }
		render json: cities
	end
end
