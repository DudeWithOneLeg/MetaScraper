require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"

module Facebook
  class FacebookController < ApplicationController
  
    
    # @@proxy_url = "192.168.49.1"
    # @@proxy_port = "8000"
    @@proxy_url = nil
    @@proxy_port = nil
  
  
    # userId is in user[logging_model][tapped_result_id]
    def facebook_user_search
      query = request.query_parameters["query"]
      variables = {
          allow_streaming: false,
          args: {
              callsite: "COMET_GLOBAL_SEARCH",
              config: {
                  exact_match: false,
                  high_confidence_config: nil,
                  intercept_config: nil,
                  sts_disambiguation: nil,
                  watch_config: nil
              },
              experience: {
                  client_defined_experiences: [ "ADS_PARALLEL_FETCH" ],
                  encoded_server_defined_params: "AbqYQQCuIq_5M5MKYA4Iw2z-7xyPApveqAXCe28_Flb57xRVS02IPjGGG4DWRathWwaD0uN042zmnORXBhq4wEPf",
                  fbid: nil,
                  type: "PEOPLE_TAB"
              },
              filters: [],
              text: query
          }
        # count: 10,
        # cursor: "AbrLrqsgax7OZMBwm4d6FOl3UDjgJURfb2iSnp0JPtDEo8Rm3msD2XJpdYhzLc3o1fYFQYw9w1E6Zkb-_Hp_E4zstjSR9Q5TavTcigMmO0kfF6QbMEz5vM5JrdzOaVk9L8r47gHpRqkFdZ_pL24qTrhM0uk89eVxEWAYEKCMYEwhRvmCS7u7Oas-Z9kAIcynYDtonVrA26LER886NublXlgWXcCmStEF35sN29HX6YpibTVz2Yh7dV9SWrJbejVlbMqFWM_RNy3Lv-Q294V1_kSlTOpltx_g9_32y5mhpK1XBiqg3DXS1JlF1dNZLRoUp9nGlL_2jR2sYH7Vxdz7H6ipfxxSPHvvao1a7UZhw-X3graf7Y-f_iaCIZOdTF3wNKSZAInybV6ygiWUJeLWpao6gn697QLKyz6ZI9c43GqqbLC4Ooi9twQK8-4T-J1i2-b542Nj97sG-uWcctstmo2icb6pexYD861olWCk6p18yFJZw1hKEzmWxycqJ-tmIk1AHXyMCVZItgMufDMnUOMtgPDYKVKEs-MTyxDgie_2SqQN9pX8zzvFK9goanWvPMVe3t-KwQZH4dwWm8TCw4USiJbi55elrXxhyiQ-uWhh-R1m9gkj5BOAu8TYRC7mmYD2t7hvxhrzqNRG7f4OKKQfED2D8hs6_f9YCow0XdSEdt5QEn13k9U9Y6csCPJiFtwCunMccYTcGV9FNrdNjwrYJFjK0eFsunPdbfyZYSnksaamEO2-OCQbHQdXaxFiB_wBIZgkW-Am6_pdf4UAjoeJ8Eeq5GkEn1H3HuI5-HmqcNzJXFVYSgaHLCOcPkKjEqXPEKUV0CwIGNpAOfqmNRx2uKbqgWaBKIKQmo0C3gK0X0IO36jYR48jnSLo0z_DTZuUiF9lFTmi65F39wsiMiofpRFOB1YsSbtaAm7fSaLt2B63Wq18D7GQeu8qsHfDjnExjg2eDmVBiJ_VdIDsj4j7BJkScr0ntX6eH0CmigB4ttc5c9GDyeCw31vTzL0itgq7C0Sk06VeP1gEXedCzl0ZCCgHG3AQ8qUCXrJUvAwWPT_eIe9JEE1ZRo8RGHhDL_Jb8bQCxwGnrgXZ9n2qfQJmDya0QqIoQ8q4B5j9xrfe3YCfc-i9Ha3eTqoAIr7PGb9JCEY-MItpeWuocCiEssXGuHAqHn4ZieOEPGKIa-LvxdZHKwwJmMcMkZ9_lRcDHHFq4U0jlJWRnH02HX0pS2ozR9OPR6C0cAySTEOJhgCQnmONjRlkXZYOVeIeVLm8y2AetdRC-aiVh8aVwhkK4eFBMBsCYfEefBpfW2LHvxyaKvlYeS636aLNRBCxwo-MwSSQMgbjInQmDe5P1XNrqzWDH90Jz7YhnPUiu1qJCfbdQruZm2wM3ZuFbRkL4q3jsEqA9mQ5oKtCm1AdbdRPYIhiGLDWq29JsJ2JlmO5aE-EQZv9xCvdESbzlh-s9UL-fa3B-fSy0wnrH_U4MUZG6WoIU6E2qgoR5Ole2MvuFaT6BCJqlg_lOtQTmhtW8wgP1bXnc4fwZLYb155uIrc6SkaP3OBMhHVtNETPUQHiGO5awPjl9fdR7TB58nmStpe7E5YPsDy0xSc1gfsS_ki1yXBstO5EzWk1RUbumnFUkutBvQ",
        # feedLocation: "SEARCH",
        # feedbackSource: 23,
        # fetch_filters: true,
        # focusCommentID: nil,
        # locale: nil,
        # privacySelectorRenderLocation: "COMET_STREAM",
        # renderLocation: "search_results_page",
        # scale: 3,
        # stream_initial_count: 0,
        # useDefaultActor: false,
      }
      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "28131523769829398"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      puts JSON.parse(res.body)
      render json: JSON.parse(res.body)
    end
  
    def facebook_profile_bio_photos
      id = request.query_parameters["id"]
      variables = {
        privacySelectorRenderLocation: "COMET_STREAM",
        renderLocation: "timeline",
        scale: 2,
        userID: "761932066",
        __relay_internal__pv__GHLShouldChangeSponsoredDataFieldNamerelayprovider: false,
        __relay_internal__pv__GHLShouldChangeAdIdFieldNamerelayprovider: false,
        __relay_internal__pv__WorkCometIsEmployeeGKProviderrelayprovider: false,
        __relay_internal__pv__GroupsCometGroupChatLazyLoadLastMessageSnippetrelayprovider: false,
        __relay_internal__pv__CometFeedStoryDynamicResolutionPhotoAttachmentRenderer_experimentWidthrelayprovider: 500
      }
      
  
      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "8795610053899267"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      body = res.body
      puts JSON.parse(body)
      render json:JSON.parse(body)
    end
  
    def facebook_profile
      id = request.query_parameters["id"]
      variables = {
          afterTime: nil,
          beforeTime: nil,
          count: 3,
          cursor: "Cg8Ob3JnYW5pY19jdXJzb3IJAAABhEFRSFJMVTh0bnhQYTRETUppdjVVT0hxeDdqRERCdjZveFJKUmJjR2lrVUdQbGFBLWlqWTlLVEtabkIyRzM1Z1dGSGZrTXFBMGxubWxhX1dpRjJzZDJPUmE3YTFRVTlwNkFha1g3TDlOVloyU01OR2s4YlR1ZVdmZzdQb1J6aFE1Xzlyb1lUVjJPenpTcFdRM1ROT3FlOHgwb0VQenp0UndtY0R4YVNvWU1FWVZCYV9XeGs2dTAzblpoSlB2ckhlTEdQemVJbWkzUC01anhXd1pRMXd3TzNwVWtOT2lhcVNVczhtb2NfZUE4S3Q1dEEzcmNUTlpveDY2akFhSzdHOGk5RXJrNjBxOFhzUS12V3VGZVo0bjlSaEotaWFFRHdwaFRSc1VKWTFUekt3cjNublB6Nl9CdlpUaDdhOExDeXd6Q3hWTHp0YXNmYVRhOVVzSmVDTXJONUs1NG9tRDRoU0doQzA5WVQ0UXJIX2xwUlZBQUtyQ1BuU2pIdFIzY1VWaGlKdU4PCWFkX2N1cnNvcg4PD2dsb2JhbF9wb3NpdGlvbgIADwZvZmZzZXQCAA8QbGFzdF9hZF9wb3NpdGlvbgL/AQ==",
          feedLocation: "TIMELINE",
          feedbackSource: 0,
          focusCommentID: nil,
          memorializedSplitTimeFilter: nil,
          omitPinnedPost: true,
          postedBy: nil,
          privacy: nil,
          privacySelectorRenderLocation: "COMET_STREAM",
          renderLocation: "timeline",
          scale: 5,
          stream_count: 10,
          taggedInOnly: nil,
          trackingCode: nil,
          useDefaultActor: false,
          # id: id
        }
  
      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "9132077713517532"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      body = res.body
      puts JSON.parse(body.split("\r\n")[0])["data"]["node"]["timeline_list_feed_units"]["edges"].size
      render json: JSON.parse(body.split("\r\n")[0])
    end
  
    def facebook_friends
      id = request.query_parameters["id"]
      variables = {
        collectionToken: nil,
        feedbackSource: 65,
        feedLocation: "COMET_MEDIA_VIEWER",
        scale: 1,
        sectionToken: "YXBwX3NlY3Rpb246MTAwMDAwMzUxMTI2NDUwOjIzNTYzMTgzNDk=",
        userID: "100000351126450",
        __relay_internal__pv__CometUFIReactionsEnableShortNamerelayprovider: false,
        __relay_internal__pv__FBReelsMediaFooter_comet_enable_reels_ads_gkrelayprovider: false,
        __relay_internal__pv__IsWorkUserrelayprovider: false
    }
  
      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "28459325330380447"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      body = res.body
      # puts JSON.parse(body.split("\r\n")[0])["data"]["node"]["timeline_list_feed_units"]["edges"].size
      render json: JSON.parse(body)
    end
  
    def facebook_photo_search
      query = request.query_parameters["query"]
      variables = {
          count: 5,
          allow_streaming: false,
          args: {
            callsite: "COMET_GLOBAL_SEARCH",
            config: {
              exact_match: false,
              high_confidence_config: nil,
              intercept_config: nil,
              sts_disambiguation: nil,
              watch_config: nil
            },
            experience: {
              encoded_server_defined_params: "Abq_qBUYGcG6-WLu7nIlwAoUfoW3d2rn7Gn9QsTMg8TXhuMQLoXyzesw563bhT1RGyyr2E5L-DvhFjaDMOHaO20p1mVfnVMWUx1l77tUdk9JDw",
              type: "SERVER_DEFINED"
            },
  
            # location => "{\"name\":\"location\",\"args\":\"104060076298330\"}"
            # year 2025 => ["{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-1\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-12\\\",\\\"start_day\\\":\\\"2025-1-1\\\",\\\"end_day\\\":\\\"2025-12-31\\\"}\"}"]
            filters: [],
            text: query
          },
          cursor: nil,
          feedbackSource: 23,
          fetch_filters: true,
          renderLocation: "search_results_page",
          scale: 1,
          stream_initial_count: 0,
          useDefaultActor: false
        }
  
  
  
      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "9310443525686377"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      puts res.body
      render json: JSON.parse(res.body)
    end
    def facebook_post_search
      query = request.query_parameters["query"]
      variables = {
          allow_streaming: false,
          args: {
            callsite: "COMET_GLOBAL_SEARCH",
            config: {
              exact_match: false,
              high_confidence_config: nil,
              intercept_config: nil,
              sts_disambiguation: nil,
              watch_config: nil
            },
            experience: {
              client_defined_experiences: [ "ADS_PARALLEL_FETCH" ],
              encoded_server_defined_params: nil,
              fbid: nil,
              type: "POSTS_TAB"
            },
            # recent => ["{\"name\":\"recent_posts\",\"args\":\"\"}"]
            filters: [],
            text: query
          },
          count: 5,
          cursor: "AbrhgcZx6B316gYy3QbJXihFGndOEnsX6Gibb-AZn7YXwl4WxITa7pbP8t1eAT9IyGlK3hWCrcOGrQYX6HNG0uxarTyFDrZQBnoYeVMmCY875LsXZef012_7r7lTnaNCwWMJuGRwiCaf6MHVgVLf-uC0sYis8pPblb1snWRJCim-PQgtb5WsQbgRHPqDjxELUyZZPd4MphXkX6pwSHVUAKDk4qn0LWnDJMqDtq2iqRQfjDxim2rGTRBRMpxf9Uu-gHKV8K_gk3sPDkSHP1fClCjwVSFq5ZVKuG3L3PHq_9ToxJmu_RNwSvUENmcZRHWM-FYbsmYW7RdNxrrw9MhC5Zi4dWuNae2uYlko_E8TJS9YTyMXGS3JqSFGC2KGcmNiMwqBfSFuE5rSarB2YF_nT_-pDdzqj8WKBskWf5QCoEQRjCzCRGiyF-iVYzFXGF1ZpItpBI9rK4D8MYOxhrtsYH-aLMfJKon3U9dvG0A5xqX_0mBd8Mmo6Vq7WQke6GPezHD1y_RNUfOU1e27r_P_HNH7b2TRXV81XKfid6u0HHPAgqZsn4tlpGtZxk1YkoiSMoP1uuA0EMGIhLIlEqw9NL1jQWUR9hin2CvE_64tm28Rcl45oV2mj_n22PlNmGS1EKoTNFxH_B0Fc905KU_SdDjYg3MXNlF2mKBqGYpuZGzg_xcf7vb-M1UEjjS9NNWD_LuLJrPy97gOR8sDG4zkj44Lh9Ez7eX4xsmA5s3ycWefPq8O4gKZEUTTNCA7Nm9yifKCtOUbgJ95txaHg--6KSmf9DtrJXD4FP7I_e_xFesP3W-F7n8NB7vwVkspJ2BDf3uw2OqYi5wikfHk6ZHm-qbt09yqQ4zByIza1-tqQRnMfx0BoCzQ24o3GH4fJUO2k2n7LrXdnnCg9qAfndXcNJzrcanbMJr8Cv955nAPtywk9kbUjciGlmw4P-eYMDciNt5fy01AUBtGtqapAQGkt6eNQsKXXuixvgT5vCwXrzICU_a1ZcvvpcofWtorLpjKsEYymLHK9DaWQl5mBGqBn8JdOJ-rh4VBitcW6XFX4GRvPd2h37q-T2vyuBCcQ4qnFARe5gwP2qi6nfirnaamLcAt2wUQKLdw-RElY7ZUun7KB72HJZgl26reGNj1aQM4WYjM4qKXlXJZ8cZrh71oZjZQRoMxSGPAmDcaTi706w9GUv03g6K8Ntg_yWIrN0kqo0TDYmZaV5gOf-PsKqHXLFNggkKOfUeBvM2ugm4uV8JFx_Xki0nl6OqFi8WKoyDUI2t4madDGdrZVDmrgHGEF-tsSTltuM-BS_zPq-StsN0q5_RB82D4Am6ejMYcg4YUQITqWlZjQ5ZL0s6uIRK3IOrRu-_E9JDFbwOfjup685I2Q6Fqa9Gos8d1QRo0HfsE92ZlKA-Pi9oc8Jdz4tlipslkHLA68QHVaRYwoMvhGNMIFYBmMksJ9yeNe4gpjLxfdablz1nePLj0P9HuHSQSJLufZb3DGKh5JT2uPXqCCpyt2y14JhSOcvpm3QU8JQkawW1y-6bUlNyZWcbkDEuCWr4XFE2YX9IdnfKgCQDDHwkpt6gOgDwQGeiq8pRwv8zBnvn3AsbnjQhPK5o-M4r1gQ8tm4no5I2dp9sBH_9ISrDJiTu70BpTUPTbEznhKzEEA1wO_NCx7geRujHL5LjCL-UxlGsFMYh_nxgsBXxuyJ-uZA",
          feedLocation: "SEARCH",
          feedbackSource: 23,
          fetch_filters: true,
          focusCommentID: nil,
          locale: nil,
          privacySelectorRenderLocation: "COMET_STREAM",
          renderLocation: "search_results_page",
          scale: 1
          # stream_initial_count: 0,
          # useDefaultActor: false,
        }
  
  
  
      variables = variables.to_json
      # puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "9310443525686377"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      # puts res.body
      body = res.body
      render json: JSON.parse(body.split("\r\n")[0])["data"]["serpResponse"]["results"]["edges"]
    end
    def facebook_company_search
    query = request.query_parameters["query"]
    variables = {
      count: 8,
      filterID: "Z3NxZjp7IjAiOiJicm93c2VfaW5zdGFudF9maWx0ZXIiLCIxIjoia2V5d29yZHNfdXNlcnMoZ2FyeSkiLCIzIjoiZmFjY2UwMzgtMzc0MS00NDkzLWEyMzYtZGVlMTQwNDY2NDU1IiwiY3VzdG9tX3ZhbHVlIjoiQnJvd3NlVXNlcnNTY2hvb2xJbnN0YW50RmlsdGVyQ3VzdG9tVmFsdWUifQ==",
      query: query
    }
  
  
  
    variables = variables.to_json
    # puts variables
    variables = URI.encode_www_form_component(variables)
    doc_id = "8960381707365732"
    res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
    puts "https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port
    # puts res.body
    body = res.body
    render json: JSON.parse(body)
    end
    
    def facebook_video_search
      query = request.query_parameters["query"]
      cursor = request.query_parameters["cursor"]
      variables = {
          count: 5,
          allow_streaming: false,
          args: {
            callsite: "COMET_GLOBAL_SEARCH",
            config: {
              exact_match: false,
              high_confidence_config: nil,
              intercept_config: nil,
              sts_disambiguation: nil,
              watch_config: nil
            },
            experience: {
              type: "VIDEOS_TAB"
            },
  
            # relavance => []
            # most recent => "{\"name\":\"videos_sort_by\",\"args\":\"Most Recent\"}"
            # today => "{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-01\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-01\\\",\\\"start_day\\\":\\\"2025-01-30\\\",\\\"end_day\\\":\\\"2025-01-30\\\"}\"}"
            # this week => "{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-01\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-02\\\",\\\"start_day\\\":\\\"2025-01-27\\\",\\\"end_day\\\":\\\"2025-02-02\\\"}\"}"
            # this month => "{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-01\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-01\\\",\\\"start_day\\\":\\\"2025-01-01\\\",\\\"end_day\\\":\\\"2025-01-31\\\"}\"}"
            # live => "{\"name\":\"videos_live\",\"args\":\"\"}"
            filters: [],
            text: query
          },
          cursor: cursor,
          feedbackSource: 23,
          fetch_filters: true,
          renderLocation: "search_results_page",
          scale: 1,
          stream_initial_count: 0
          # useDefaultActor: false,
        }
  
      variables = variables.to_json
      # puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "9310443525686377"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      # puts res.body
      body = res.body
      render json: JSON.parse(body.split("\r\n")[0])["data"]["serpResponse"]["results"]
    end
    
    
    def facebook_location_id_search
      variables = {
        params: {
            caller: "MARKETPLACE",
            country_filter: nil,
            integration_strategy: "STRING_MATCH",
            page_category: [ "CITY", "SUBCITY", "NEIGHBORHOOD", "POSTAL_CODE" ],
            query: "Lewisville, Texas",
            search_type: "PLACE_TYPEAHEAD",
            viewer_coordinates: { latitude: 33.046289, longitude: -96.994123 }
        }
      }
      variables = variables.to_json
      variables = URI.encode_www_form_component(variables)
      doc_id = "7321914954515895"
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
  
    # UNAUTHORIZED
    # def facebook_school_id_search
    #   variables = {
    #     "count":8,
    #     # "filterID":"Z3NxZjp7IjAiOiJicm93c2VfaW5zdGFudF9maWx0ZXIiLCIxIjoia2V5d29yZHNfdXNlcnMoZ2FyeSticmlhbikiLCIzIjoiYjFjOTJjMzQtNTViOC00ODIwLTk5NzMtZmU1ODkxOWY2ZGY4IiwiY3VzdG9tX3ZhbHVlIjoiQnJvd3NlVXNlcnNTY2hvb2xJbnN0YW50RmlsdGVyQ3VzdG9tVmFsdWUifQ==",
    #     "query":"somewthing"
    # }
    #   variables = variables.to_json
    #   variables = URI.encode_www_form_component(variables)
    #   doc_id = "8960381707365732"
    #   # puts variable_json
    #   res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
    #   # results = JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
    #   # puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
    #   # results.each do |result|
    #   # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]
    #   # end
    #   # render json: {results: results, search_info: {count: results.size}}
    #   # puts [].methods
    #   render json: JSON.parse(res.body)
    # end
  
    def marketplace_listing
      targetId = request.query_parameters["targetId"]
      variables = { targetId: targetId }
      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      puts variables
      doc_id = "7820841627934041"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      render json: JSON.parse(res.body)["data"]["viewer"]["marketplace_product_details_page"]
    end
  end
end

