require 'uri'
require 'net/http'

class PhotosController < ApplicationController

  # Here we request photo stream from server side and then push it to front end
  # Apparently we could do this in front end with Javascript directly (via cross site ajax)
  # The assumption is that we might integrate with other photo share communities in future and
  # also we might have our own photo database
  # These will increase the complexity front end javascript has to handle with
  # While, server side is meant to do these heavy lifting works
 
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
    ret = ActiveSupport::HashWithIndifferentAccess.new(ret_hash)

    # Although for task 1 there's no need to go further by creating/contructing Photo objects
    # We do it for forward-compatibility
    @photos = ret[:photos].map do |fivehundredpx_photo|
      photo = Photo.new
      photo.setup_from_fivehundredpx fivehundredpx_photo
      photo
    end

    render :index
  end
end
