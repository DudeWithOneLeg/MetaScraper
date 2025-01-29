require 'httparty'
require 'uri'
require 'json'

class WelcomeController < ApplicationController
    def index
    end
    def request_info
        query = request.query_parameters["query"]
        limit = request.query_parameters["limit"]
        latitude = request.query_parameters["latitude"]
        longitude = request.query_parameters["longitude"]
        radius_km = request.query_parameters["radius_km"]
        max_price = request.query_parameters["max_price"]
        min_price = request.query_parameters["min_price"]
        page = request.query_parameters["page"]
        cursor = {
            pg: page,
            b2c: {
                br:"",
                it: 0,
                hmsr: false,
                tbi: 0
            },
            c2c: {
                br:"AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
                it: 13,
                rpbr: "",
                rphr:false,
                rmhr:false
            },
            ads: {
                items_since_last_ad:13,
                items_retrieved:13,
                ad_index:0,
                ad_slot:0,
                dynamic_gap_rule:0,
                counted_organic_items:0,
                average_organic_score:0,
                is_dynamic_gap_rule_set:false,
                first_organic_score:0,
                is_dynamic_initial_gap_set:false,
                iterated_organic_items:0,
                top_organic_score:0,
                feed_slice_number:0,
                feed_retrieved_items:0,
                ad_req_id:0,
                refresh_ts: 0,
                cursor_id:31979,
                mc_id:0,
                ad_index_e2e:0,
                seen_ads: {
                    ad_ids:[],
                    page_ids:[],
                    campaign_ids:[]
                },
                has_ad_index_been_reset:false,
                is_reconsideration_ads_dropped:false
            },
            irr:false,
            serp_cta:false,
            rui:[],
            mpid:[],
            ubp: nil,
            ncrnd:0,
            irsr:false,
            bmpr:[],
            bmpeid:[],
            nmbmp:false,
            skrr:false,
            ioour:false,
            ise:false
        }
        puts cursor.to_json
        variable_json = {
            count: limit,
            cursor: cursor.to_json ,
            params: {
                bqf: {
                    callsite: 'COMMERCE_MKTPLACE_WWW',
                    query: query
                },
                browse_request_params: {

                    #local
                    commerce_enable_local_pickup: true,
                    #shipping
                    commerce_enable_shipping: false,

                    commerce_search_and_rp_available: true,
                    commerce_search_and_rp_category_id: [],
                    commerce_search_and_rp_condition: nil,
                    commerce_search_and_rp_ctime_days: nil,

                    #location latitude
                    filter_location_latitude: latitude,
                    #location longitude
                    filter_location_longitude: longitude,
                    #distance-radius
                    filter_radius_km: radius_km,

                    #sort by
                    commerce_search_sort_by: "DISTANCE_ASCEND",

                    #min-price ex. $1200 = 120000
                    filter_price_lower_bound: min_price,
                    #max-price
                    filter_price_upper_bound: max_price

                },
                custom_request_params: {
                    # browse_context: nil,
                    # contextual_filters: [],
                    # referral_code: nil,
                    # saved_search_strid: nil,
                    # search_vertical: 'C2C',
                    # seo_url: nil,
                    surface: 'SEARCH',
                    virtual_contextual_filters: []
                }
            },

            #image scale
            scale: 10,
            offset: 24
        }
        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = '8558510667564038'
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
        results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["page_info"]
        results.each do |result|
            # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        end
        # render json: {results: results, search_info: {count: results.size}}
        render json: JSON.parse(res.body)["data"]["marketplace_search"]
    end
end
