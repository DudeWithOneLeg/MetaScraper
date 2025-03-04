require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"

class InstagramController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:proxy]

  def index
  end

  def instagram_search
    query = request.query_parameters["query"]
    variables = {
      data: {
        context: "blended",
        include_reel: "true",
        query: query,
        rank_token: "",
        search_surface: "web_top_search",
      },
      hasQuery: true,
    }
    variables = variables.to_json
    puts variables
    variables = URI.encode_www_form_component(variables)
    doc_id = "8964418863643891"
    res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
    @items = JSON.parse(res.body)["data"]["xdt_api__v1__fbsearch__topsearch_connection"]["users"]
    render "instagram_search"
  end

  def instagram_profile
    id = request.query_parameters["id"]
    variables = {
      id: id,
      # render_surface: "PROFILE",
      include_clips_attribution_info: false,
      first: 12,
    }
    # "https://www.instagram.com/graphql/query/?doc_id=7950326061742207&variables={"id":"20236507","first":12}"
    variables = variables.to_json
    puts variables
    variables = URI.encode_www_form_component(variables)
    doc_id = "7950326061742207"
    res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
    puts JSON.parse(res.body)["data"]["user"]["edge_owner_to_timeline_media"]["edges"].size
    render json: JSON.parse(res.body)
  end

  def instagram_profile_reels
    id = request.query_parameters["id"]
    variables = {
      data: {
        include_feed_video: true,
        page_size: 12,
        target_user_id: id,
      },
    }
    variables = variables.to_json
    puts variables
    variables = URI.encode_www_form_component(variables)
    doc_id = "8526372674115715"
    res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
    render json: JSON.parse(res.body)
  end

  def instagram_reel
    id = request.query_parameters["id"]
    variables = {
      shortcode: id,
      fetch_tagged_user_count: nil,
      hoisted_comment_id: nil,
      hoisted_reply_id: nil,
    }
    doc_id = "8845758582119845"
    variables = variables.to_json
    puts variables
    variables = URI.encode_www_form_component(variables)
    res = HTTParty.get("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
    # puts res.body
    render json: JSON.parse(res.body)
  end

  def proxy
    url = params[:url]
    html = params[:html]
    magnet = params[:magnet]
    files = params[:files]
    link = params[:link]
    res = nil
    proxy_url = "192.168.49.1"
    proxy_port = "8000"
    # proxy_url = nil
    # proxy_port = nil
    # image = URI.open(url).read
    # send_data image, type: "image/jpeg", disposition: "inline"
    api_key = request.headers["Authorization"]
    if request.method == "GET"
        res = HTTParty.get(url, headers: { Authorization: api_key }, http_proxyaddr: proxy_url, http_proxyport: proxy_port)
    end
    if request.method == "POST"
        puts url
      res = HTTParty.post(url, headers: { Authorization: api_key }, body: (magnet != nil ? "magnet=#{URI.encode_www_form_component(magnet)}" : (files != nil ? "files=#{files}" : (link != nil ? "link=#{link}" : link))), http_proxyaddr: proxy_url, http_proxyport: proxy_port)
    end
    puts res.body
    if html
      render plain: res.body
    end

    if html == nil
        if files == nil

            render json: JSON.parse(res.body)
        end
        if files != nil
            render json: {}, status: 204 
        end
    end
  end
end