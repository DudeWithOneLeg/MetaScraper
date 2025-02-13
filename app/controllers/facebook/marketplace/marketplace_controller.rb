require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"

module Facebook
  module Marketplace
    class MarketplaceController < ApplicationController
      # @@proxy_url = "192.168.49.1"
      # @@proxy_port = "8000"
      @@proxy_url = nil
      @@proxy_port = nil

      def marketplace_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          count: limit,
          cursor: cursor.to_json,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_WWW",
              query: query,
            },
            browse_request_params: {

              # local
              commerce_enable_local_pickup: true,
              # shipping
              commerce_enable_shipping: false,

              # Availability
              # false => sold
              # true => available
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [],

              # Condition: seperated by commas
              # new
              # use_like_new
              # used_good
              # used_fair
              commerce_search_and_rp_condition: nil,

              # Date Listed
              # last 24 hours => 20117;20116
              # last week => 20117;20116;20115;20114;20113;20112;20111;20110
              # last 30 days => 20117;20116;20115;20114;20113;20112;20111;20110;20109;20108;20107;20106;20105;20104;20103;20102;20101;20100;20099;20098;20097;20096;20095;20094;20093;20092;20091;20090;20089;20088;20087
              commerce_search_and_rp_ctime_days: nil,

              # location latitude
              filter_location_latitude: latitude,
              # location longitude
              filter_location_longitude: longitude,
              # distance-radius
              filter_radius_km: radius_km,

              # sort by
              # sort by
              # nearest first => DISTANCE_ASCEND
              # newest frist => CREATION_TIME_DESCEND
              # lowest price => PRICE_ASCEND
              # highest price first => PRICE_DESCEND
              commerce_search_sort_by: "DISTANCE_ASCEND",

              # min-price ex. $1200 = 120000
              filter_price_lower_bound: min_price,
              # max-price
              filter_price_upper_bound: max_price,

            },
            custom_request_params: {
              # browse_context: nil,
              # contextual_filters: [],
              # referral_code: nil,
              # saved_search_strid: nil,
              # search_vertical: 'C2C',
              # seo_url: nil,
              surface: "SEARCH",
              virtual_contextual_filters: [],
            },
          },

          # image scale
          scale: 10,
          offset: 24,
        }
        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8558510667564038"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        results.each do |result|
          # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
      end

      def marketplace_vehicle_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: { latitude: 33.046289, longitude: -96.994123 },
          categoryIDArray: [807311116002614],

          # MAKE && model && body type (seperate bodytype by comma, no space)
          # Acura => [{"name":"make","value":"make_id"},{"name":"model","value":"\"754638875658882\""},{"name":"body_style","value":""}]
          contextual_data: [],

          # TYPES
          # convertible
          # coupe
          # hatchback
          # minivan
          # sedan
          # station wagon => wagon
          # suv
          # truck
          # small_car
          # other => other_body_style

          # MAKE && model && body type (seperate bodytype by comma, no space)
          # [{"name":"canonical_make_id","value":"make_id"},{"name":"canonical_model_id","value":"754638875658882"},{"name":"vehicle_type","value":"convertible,coupe"}]

          # HISTORY (string, comma seperated)
          # includes free carfax report
          # 1 no accidents or damage reported
          # 2 only one owner
          # 3 personal use
          # 4 service records available
          # carfax
          # {"name":"carfax_history","value":"0,1,2,3,4"}

          # COLORS (string, comma seperated) exteriror_colors interiror_colors
          # black
          # charcoal
          # grey
          # silver
          # off_white
          # tan
          # beige
          # yellow
          # gold
          # brown
          # orange
          # red
          # burgundy
          # pink
          # purple
          # blue
          # turqoise
          # green
          # other
          # {"name":"exterior_colors","value":"black,charcoal,off_white"}
          stringVerticalFields: [],

          count: 24,
          cursor: nil,

          # SORT
          # price lowest => {"sort_by_filter":"PRICE_AMOUNT","sort_order":"ASCEND"}
          # price highest => {"sort_by_filter":"PRICE_AMOUNT","sort_order":"DESCEND"}
          # date old => {"sort_by_filter":"CREATION_TIME","sort_order":"ASCEND"}
          # date new => {"sort_by_filter":"CREATION_TIME","sort_order":"DESCEND"}
          # distance near => {"sort_by_filter":"DISTANCE","sort_order":"ASCEND"}
          # distance far => {"sort_by_filter":"DISTANCE","sort_order":"DESCEND"}
          # mileage low => {"sort_by_filter":"VEHICLE_MILEAGE","sort_order":"ASCEND"}
          # mileage high => {"sort_by_filter":"VEHICLE_MILEAGE","sort_order":"DESCEND"}
          # year old => {"sort_by_filter":"VEHICLE_YEAR","sort_order":"ASCEND"}
          # year new => {"sort_by_filter":"VEHICLE_YEAR","sort_order":"DESCEND"}
          filterSortingParams: nil,

          marketplaceBrowseContext: "CATEGORY_FEED",

          # OWNER
          # dealership owned => [{"name":"is_dealership_owned","value":1}]
          # individual owned => [{"name":"is_dealership_owned","value":0}]
          numericVerticalFields: [],

          # YEAR
          # [{"max":2001,"min":2000,"name":"year"}]

          # MILEAGE
          # {"max":2147483647,"min":200000,"name":"odometer"}
          # TRANSMISSION
          # all => nil
          # {"name":"is_manual_transmission","value":0} or 1
          numericVerticalFieldsBetween: [],

          # PRICE => num + 00
          priceRange: [0, 214748364700],
          radius: 64000,
          scale: 1,

          # VEHICLE TYPE (body style)
          # cars & trucks => [{"name":"vehicle_type","value":"car_truck"}]
          # motorcycle => [{"name":"vehicle_type","value":"motorcycle"}]
          # powersport => [{"name":"vehicle_type","value":"powersport"}]
          # rvs & campers => [{"name":"vehicle_type","value":"rv_camper"}]
          # boats => [{"name":"vehicle_type","value":"boat"}]
          # commercial & industrial => [{"name":"vehicle_type","value":"commercial"}]
          # trailer => [{"name":"vehicle_type","value":"trailer"}]
          # other => [{"name":"vehicle_type","value":"other"}]
          #
          topicPageParams: { location_id: 2069149989834376, url: "vehicles" },
        }
        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8964905813540955"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def test_scrape
        driver = Selenium::WebDriver.for :chrome
        driver.navigate.to "https://www.facebook.com/marketplace"

        # Get the body of the response
        # body = driver.execute_script("return document.body.innerHTML;")
        actions = driver.action
        actions.key_down(:shift).send_keys(:tab).key_up(:shift).send_keys(:enter).perform
        search = driver.find_element(:xpath, "//*[@aria-label='Search Marketplace']").send_keys("test", :enter)
        # search.click
        card_class = ".x1lliihq.x1iyjqo2"

        cards = driver.find_elements(:css, card_class)
        cards.each { |card| puts card.text }
        driver.quit
        # actions

        # el.click

        # puts element

        render html: body.html_safe
      end

      def fetch_apparel_categories
        # VEHICLE_DATA_FILE = 'vehicle_make_ids.json'
        # OUTPUT_SLUG_FILE = 'slug_data.json'
        # OUTPUT_VALUE_FILE = 'value_data.json'
        # API_URL = 'https://www.facebook.com/api/graphql'
        # DOC_ID = '6978471575593570'
        begin
          # Read the JSON file
          # file_path = File.join(__dir__, 'vehicle_make_ids.json')
          # file = File.read(file_path)
          # vehicles = JSON.parse(file)

          slug_map = {}
          value_map = {}
          categories = [
            "action-figures",
            "building-toys",
            "dollhouses",
            "dolls",
            "educational-toys",
            "math-toys",
            "model-kits",
            "outdoor-toys",
            "pretend-play-toys",
            "puzzles",
            "remote-control-toys",
            "robot-toys",
            "stuffed-animals",
            "toy-vehicles",
          ]

          categories.each do |category|
            # slug = vehicle['slug']
            # value = vehicle['value']
            # next if slug.nil? || value.nil?

            # Construct the variables object
            variables = {
              buyLocation: {
                latitude: 33.046289,
                longitude: -96.994123,
              },
              category_ids: [],
              category_ranking_enabled: true,
              contextual_data: [{ name: "seo_url", value: "\"#{category}\"" }],
              hide_l2_cats: true,
              params: nil,
              savedSearchID: "",
              savedSearchQuery: nil,
              sellerID: nil,
              shouldIncludePopularSearches: false,
              surface: "CATEGORY_FEED",
              topicPageParams: {
                location_id: "category",
                url: category,
              },
              virtual_category_ids: [],
            }

            variables2 = {
              buyLocation: {
                latitude: 33.046289,
                longitude: -96.994123,
              },
              contextual_data: nil,
              count: 24,
              cursor: nil,
              params: {
                bqf: {
                  callsite: "COMMERCE_MKTPLACE_SEO",
                  query: "",
                },
                browse_request_params: {
                  commerce_enable_local_pickup: true,
                  commerce_enable_shipping: true,
                  commerce_search_and_rp_available: true,
                  commerce_search_and_rp_category_id: [],
                  commerce_search_and_rp_condition: nil,
                  commerce_search_and_rp_ctime_days: nil,
                  filter_location_latitude: 33.046289,
                  filter_location_longitude: -96.994123,
                  filter_price_lower_bound: 0,
                  filter_price_upper_bound: 214748364700,
                  filter_radius_km: 64,
                },
                custom_request_params: {
                  browse_context: nil,
                  contextual_filters: [],
                  referral_code: nil,
                  saved_search_strid: nil,
                  search_vertical: nil,
                  seo_url: category,
                  surface: "TOPIC_PAGE",
                  virtual_contextual_filters: [],
                },
              },
              savedSearchID: nil,
              savedSearchQuery: nil,
              scale: 2,
              shouldIncludePopularSearches: false,
              topicPageParams: {
                location_id: "category",
                url: category,
              },
            }

            # Encode the variables for the request
            encoded_variables = URI.encode_www_form_component(variables.to_json)
            encoded_variables2 = URI.encode_www_form_component(variables2.to_json)

            # Make the request
            response = HTTParty.post(
              "https://www.facebook.com/api/graphql?variables=#{encoded_variables}&doc_id=6978471575593570",
              headers: { "Content-Type" => "application/json" },
            )
            response2 = HTTParty.post(
              "https://www.facebook.com/api/graphql?variables=#{encoded_variables2}&doc_id=8996372187041574",
              headers: { "Content-Type" => "application/json" },
            )
            # Parse the response
            result = JSON.parse(response.body) rescue {}
            result2 = JSON.parse(response2.body) rescue {}
            # puts result
            sub_categories = result2.dig("data", "marketplace_seo_page", "seo_navigation")
            sizes = result.dig("data", "viewer", "marketplace_structured_fields")
            sizes = sizes.filter { |el| el["filter_key"] != "price" && el["filter_key"] != "deliveryMethodSERP" && el["filter_key"] != "itemCondition" }

            if sub_categories != nil
              sub_categories.each_index do |category_index|
                puts sub_categories[category_index]["seo_url"]
                variables = {
                  buyLocation: {
                    latitude: 33.046289,
                    longitude: -96.994123,
                  },
                  category_ids: [],
                  category_ranking_enabled: true,
                  contextual_data: [{ name: "seo_url", value: "\"#{sub_categories[category_index]["seo_url"]}\"" }],
                  hide_l2_cats: true,
                  params: nil,
                  savedSearchID: "",
                  savedSearchQuery: nil,
                  sellerID: nil,
                  shouldIncludePopularSearches: false,
                  surface: "CATEGORY_FEED",
                  topicPageParams: {
                    location_id: "category",
                    url: sub_categories[category_index]["seo_url"],
                  },
                  virtual_category_ids: [],
                }

                variables2 = {
                  buyLocation: {
                    latitude: 33.046289,
                    longitude: -96.994123,
                  },
                  contextual_data: nil,
                  count: 24,
                  cursor: nil,
                  params: {
                    bqf: {
                      callsite: "COMMERCE_MKTPLACE_SEO",
                      query: "",
                    },
                    browse_request_params: {
                      commerce_enable_local_pickup: true,
                      commerce_enable_shipping: true,
                      commerce_search_and_rp_available: true,
                      commerce_search_and_rp_category_id: [],
                      commerce_search_and_rp_condition: nil,
                      commerce_search_and_rp_ctime_days: nil,
                      filter_location_latitude: 33.046289,
                      filter_location_longitude: -96.994123,
                      filter_price_lower_bound: 0,
                      filter_price_upper_bound: 214748364700,
                      filter_radius_km: 64,
                    },
                    custom_request_params: {
                      browse_context: nil,
                      contextual_filters: [],
                      referral_code: nil,
                      saved_search_strid: nil,
                      search_vertical: nil,
                      seo_url: category,
                      surface: "TOPIC_PAGE",
                      virtual_contextual_filters: [],
                    },
                  },
                  savedSearchID: nil,
                  savedSearchQuery: nil,
                  scale: 2,
                  shouldIncludePopularSearches: false,
                  topicPageParams: {
                    location_id: "category",
                    url: sub_categories[category_index]["seo_url"],
                  },
                }

                # Encode the variables for the request
                encoded_variables = URI.encode_www_form_component(variables.to_json)
                encoded_variables2 = URI.encode_www_form_component(variables2.to_json)

                # Make the request
                response = HTTParty.post(
                  "https://www.facebook.com/api/graphql?variables=#{encoded_variables}&doc_id=6978471575593570",
                  headers: { "Content-Type" => "application/json" },
                )
                # response2 = HTTParty.post(
                #   "https://www.facebook.com/api/graphql?variables=#{encoded_variables2}&doc_id=8996372187041574",
                #     headers: { 'Content-Type' => 'application/json' })
                # Parse the response
                # result = JSON.parse(response.body) rescue {}
                result2 = JSON.parse(response2.body) rescue {}
                # puts result
                # sub_categories = result2.dig('data', 'marketplace_seo_page', 'seo_navigation')
                sizes = result.dig("data", "viewer", "marketplace_structured_fields")
                sizes = sizes.filter { |el| el["filter_key"] != "price" && el["filter_key"] != "deliveryMethodSERP" && el["filter_key"] != "itemCondition" }
                sub_categories[category_index][:fields] = sizes
                # sub_categories[category_index][:sub_categories] = sub_categories
              end
            end

            slug_map[category] = { sub_categories: sub_categories, fields: sizes }
          end
          render json: slug_map

          # Write results to JSON files
          File.write("toys_games_slug_data.json", JSON.pretty_generate(slug_map))
          # File.write("value_data.json", JSON.pretty_generate(value_map))

          puts "Data successfully saved!"
        rescue StandardError => e
          puts "Error fetching data: #{e.message}"
        end
      end

      # FETCHES VEHICLE MAKE BY MODEL AND WRITES TO JSON
      # def fetch_data
      #   # VEHICLE_DATA_FILE = 'vehicle_make_ids.json'
      #   # OUTPUT_SLUG_FILE = 'slug_data.json'
      #   # OUTPUT_VALUE_FILE = 'value_data.json'
      #   # API_URL = 'https://www.facebook.com/api/graphql'
      #   # DOC_ID = '6978471575593570'
      #   begin
      #     # Read the JSON file
      #     file_path = File.join(__dir__, 'vehicle_make_ids.json')
      #     file = File.read(file_path)
      #     vehicles = JSON.parse(file)

      #     slug_map = {}
      #     value_map = {}

      #     vehicles.each do |vehicle|
      #       slug = vehicle['slug']
      #       value = vehicle['value']
      #       next if slug.nil? || value.nil?

      #       # Construct the variables object
      #       variables = {
      #         buyLocation: {
      #           latitude: 33.046289,
      #           longitude: -96.994123
      #         },
      #         category_ids: [],
      #         category_ranking_enabled: true,
      #         contextual_data: [{ name: 'seo_url', value: "\"#{slug}\"" }],
      #         hide_l2_cats: true,
      #         params: nil,
      #         savedSearchID: '',
      #         savedSearchQuery: nil,
      #         sellerID: nil,
      #         shouldIncludePopularSearches: false,
      #         surface: 'CATEGORY_FEED',
      #         topicPageParams: {
      #           location_id: 'category',
      #           url: slug
      #         },
      #         virtual_category_ids: []
      #       }

      #       # Encode the variables for the request
      #       encoded_variables = URI.encode_www_form_component(variables.to_json)

      #       # Make the request
      #       response = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{encoded_variables}&doc_id=6978471575593570",
      #                               headers: { 'Content-Type' => 'application/json' })

      #       # Parse the response
      #       result = JSON.parse(response.body) rescue {}
      #       choices = result.dig('data', 'viewer', 'marketplace_structured_fields', 6, 'choices')

      #       if choices
      #         slug_map[slug] = choices
      #         value_map[value] = choices
      #       end
      #     end

      #     # Write results to JSON files
      #     File.write("slug_data.json", JSON.pretty_generate(slug_map))
      #     File.write("value_data.json", JSON.pretty_generate(value_map))

      #     puts 'Data successfully saved!'
      #   rescue StandardError => e
      #     puts "Error fetching data: #{e.message}"
      #   end
      # end

      def marketplace_property_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          categoryIDArray: [1468271819871448],
          count: 24,
          cursor: nil,
          marketplaceBrowseContext: "CATEGORY_FEED",

          # LISTINGS FROM INDIVIDUALS
          # {"name":"is_c2c_listing_only","value":1}
          numericVerticalFields: [],

          # NUM BEDROOMS
          # 1+ - 6+ => [{"max":120,"min":1,"name":"bedrooms"}]
          # NUM BATHROOMS 1 => 4, 1.5 => 6, 2 => 8, 3 => 12, 4 => 16, 5 => 20
          # 1+ - 6+ => [{"max":120,"min":6,"name":"bathrooms"}]
          # SQ FEET
          # {"max":2147483647,"min":3000,"name":"area_size"}
          numericVerticalFieldsBetween: [],

          # amount + 00
          priceRange: [0, 214748364700],
          radius: 64000,
          savedSearchID: "",
          scale: 1,

          # RENTAL TYPE [{"name":"property_type","value":"apartment-condo"}]
          # comma seperated
          # apt-condo => apartment-condo
          # house => house
          # townhouse => townhouse
          # PRIVATE ROOM => {"name":"rental_room_type","value":"private_room"}
          stringVerticalFields: [],

          # SORT
          # price low => { sort_by_filter: "PRICE_AMOUNT", sort_order: "ASCEND" }
          # price high => { sort_by_filter: "PRICE_AMOUNT", sort_order: "DESCEND" }
          # distance near => { sort_by_filter: "DISTANCE", sort_order: "ASCEND" }
          # distance far => { sort_by_filter: "DISTANCE", sort_order: "DESCEND" }
          # date-listed-new => { sort_by_filter: "CREATION_TIME", sort_order: "DESCEND" }
          filterSortingParams: nil,
          topicPageParams: {
            location_id: "category",
            url: "propertyrentals",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8785063341556521"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_apparel_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # LOCAL PICKUP
              commerce_enable_local_pickup: true,
              # SHIPPING
              commerce_enable_shipping: true,

              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1266429133383966,
                931157863635831,
                214968118845643,
                1567543000236608,
                836969846440937,
              ],

              # CONDITION (string, comma seperated)
              # new => new
              # used like new => used_like_new
              # used good => used_good
              # used fair => used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,

              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "apparel",
              surface: "TOPIC_PAGE",

              # BRANDS (sub-array, comma seperated)
              # abercombie & finch => [499554926467420]
              # banana republic => [2710634839246754]
              # chicos => [2710634839246754]
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "apparel",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8785063341556521"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_classifieds_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: true,

              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1834536343472201,
                895487550471874,
                288273351613190,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new,used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "classifieds",
              surface: "TOPIC_PAGE",
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "classifieds",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_entertainment_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "entertainment",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "entertainment",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_electronics_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "electronics",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "electronics",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_family_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "family",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "family",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_garden_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "garden",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "garden",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "6978471575593570"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_free_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: true,

              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1834536343472201,
                895487550471874,
                288273351613190,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new,used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "free",
              surface: "TOPIC_PAGE",
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "free",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_hobbies_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "hobbies",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "hobbies",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "6978471575593570"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_home_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "home",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "home",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "6978471575593570"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_home_improvement_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "home-improvements",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "home-improvements",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_musical_instrument_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "instruments",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "instruments",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_office_supplies_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "office-supplies",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "office-supplies",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_pet_supplies_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: false,
              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1792291877663080,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new, used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "pets",
              surface: "TOPIC_PAGE",

              # BRANDS (SUB ARRAY)
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "pets",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_home_sales_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          categoryIDArray: [821056594720130],
          count: 24,
          cursor: nil,

          # SORT
          # price low => { sort_by_filter: "PRICE_AMOUNT", sort_order: "ASCEND" }
          # price high => { sort_by_filter: "PRICE_AMOUNT", sort_order: "DESCEND" }
          # distance near => { sort_by_filter: "DISTANCE", sort_order: "ASCEND" }
          # distance far => { sort_by_filter: "DISTANCE", sort_order: "DESCEND" }
          # date-listed-new => { sort_by_filter: "CREATION_TIME", sort_order: "DESCEND" }
          filterSortingParams: nil,
          marketplaceBrowseContext: "CATEGORY_FEED",
          numericVerticalFields: [],
          numericVerticalFieldsBetween: [],

          # PRICE
          # amount + 00
          priceRange: [0, 214748364700],
          radius: 64000,
          savedSearchID: "",
          scale: 2,
          stringVerticalFields: [],
          topicPageParams: {
            location_id: "category",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8785063341556521"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_sporting_goods_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: true,

              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1834536343472201,
                895487550471874,
                288273351613190,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new,used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "sports",
              surface: "TOPIC_PAGE",
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "sports",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end

      def marketplace_toys_games_search
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
          # b2c: {
          #     br:"",
          #     it: 0,
          #     hmsr: false,
          #     tbi: 0
          # },
          c2c: {
            br: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
          # it: 13,
          # rpbr: "",
          # rphr:false,
          # rmhr:false
          },
        # irr:false,
        # serp_cta:false,
        # rui:[],
        # mpid:[],
        # ubp: nil,
        # ncrnd:0,
        # irsr:false,
        # bmpr:[],
        # bmpeid:[],
        # nmbmp:false,
        # skrr:false,
        # ioour:false,
        # ise:false
        }
        puts cursor.to_json
        variable_json = {
          buyLocation: {
            latitude: 33.046289,
            longitude: -96.994123,
          },
          contextual_data: nil,
          count: 24,
          cursor: nil,
          params: {
            bqf: {
              callsite: "COMMERCE_MKTPLACE_SEO",
              query: "",
            },
            browse_request_params: {

              # SHIPPING AND LOCAL PICKUP
              commerce_enable_local_pickup: true,
              commerce_enable_shipping: true,

              commerce_search_and_rp_available: true,
              commerce_search_and_rp_category_id: [
                1834536343472201,
                895487550471874,
                288273351613190,
              ],

              # CONDITION (comma seperated)
              # used,used_like_new,used_good,used_fair
              commerce_search_and_rp_condition: nil,
              commerce_search_and_rp_ctime_days: nil,
              filter_location_latitude: 33.046289,
              filter_location_longitude: -96.994123,

              # PRICE
              # amount + 00
              filter_price_lower_bound: 0,
              filter_price_upper_bound: 214748364700,
              filter_radius_km: 64,
            },
            custom_request_params: {
              browse_context: nil,
              contextual_filters: [],
              referral_code: nil,
              saved_search_strid: nil,
              search_vertical: nil,
              seo_url: "toys",
              surface: "TOPIC_PAGE",
              virtual_contextual_filters: [],
            },
          },
          savedSearchID: nil,
          savedSearchQuery: nil,
          scale: 1,
          shouldIncludePopularSearches: false,
          topicPageParams: {
            location_id: "category",
            url: "toys",
          },
        }

        variable_json = variable_json.to_json
        variables = URI.encode_www_form_component(variable_json)
        doc_id = "8996372187041574"
        # puts variable_json
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
        # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
        # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        # results.each do |result|
        # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
        # end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)
      end
    end
  end
end
