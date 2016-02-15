require 'uri'
require 'net/http'

class PhotosController < ApplicationController
  before_filter :authenticate_fivehundredpx_access!, except: [:index]

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
    # In case network error
    res = begin
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        req = Net::HTTP::Get.new(uri.request_uri)
        res = http.request(req)
      end
    rescue Exception => e
      puts e.message
      puts e.backtrace.join("\n")
      {}
    end
    # Parse response string
    ret_hash = if res.kind_of?(Net::HTTPResponse)
      begin
        JSON.parse(res.body)
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
        {}
      end
    else
      {}
    end
    ret = ActiveSupport::HashWithIndifferentAccess.new(ret_hash)

    # Although for task 1 there's no need to go further by creating/contructing Photo objects
    # We do it for forward-compatibility
    @photos = ret[:photos].to_a.map do |fivehundredpx_photo|
      photo = Photo.new
      photo.setup_from_fivehundredpx fivehundredpx_photo
      photo
    end

    render :index
  end

  # Idealy we should have current user's vote/unvote state for each photo once user signed in
  # However it seems there's no easy way to do it.
  # We have to query /photos/:id/votes for each photo and check whether current user has voted
  # It should be out of the task 2 scope
  # We assume current user does not vote any photo yet
  # We report success even if the vote action is forbidden due to already voted
  def vote
    if params[:source].blank? || params[:source_id].blank?
      render :json => {message: 'Missing image info'}, :status => 400
      return
    end

    # Process 500px photo vote request
    if params[:source] == Photo::FivehundredPX
      res = begin
        current_fivehundredpx_access_token.post("/photos/#{params[:source_id]}/vote?vote=1")
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
        {}
      end
      if !res.kind_of?(Net::HTTPSuccess) && !res.kind_of?(Net::HTTPForbidden)
        render :json => {message: "Failed to vote."}, :status => 404
        return
      end
    end
    # Return success response
    render :json => {message: "Successfully vote!"}
  end

  def cancel_vote
    if params[:source].blank? || params[:source_id].blank?
      render :json => {message: 'Missing image info'}, :status => 400
      return
    end

    # Process 500px photo cancel vote request
    if params[:source] == Photo::FivehundredPX
      res = begin
        current_fivehundredpx_access_token.delete("/photos/#{params[:source_id]}/vote")
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
        {}
      end
      if !res.kind_of?(Net::HTTPSuccess) && !res.kind_of?(Net::HTTPForbidden)
        render :json => {message: "Failed to cancel vote."}, :status => 404
        return
      end
    end
    # Return success response
    render :json => {message: "Successfully cancel vote!"}
  end
end
