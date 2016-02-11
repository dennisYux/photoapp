require 'uri'
require 'net/http'
require 'ostruct'

class PhotosController < ApplicationController

  def index
    # Request 500px API for popular photos stream
    uri = URI.parse(FiveHundredPX_API_URL + '/photos?' + 
      {feature: 'popular', image_size: 3, rpp: 100, consumer_key: FiveHundredPX_API_CONSUMER_KEY}.to_query
    )
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(req)
    end
    # Parse response string
    ret_hash = begin
      JSON.parse(res.body)
    rescue Exception => e
      puts e.message
      puts e.backtrace.join("\n")
      {}
    end
    # Enable dot notation with openstruct object
    ret = OpenStruct.new(ret_hash)
    @photos = ret.photos

    render :index
  end
end
