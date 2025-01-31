require 'httparty'
require 'uri'
require 'json'
require 'open-uri'
require 'nokogiri'

class WelcomeController < ApplicationController
    def index
    end
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
                br:"AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8",
                # it: 13,
                # rpbr: "",
                # rphr:false,
                # rmhr:false
            },
            # ads: {
            #     items_since_last_ad:13,
            #     items_retrieved:13,
            #     ad_index:0,
            #     ad_slot:0,
            #     dynamic_gap_rule:0,
            #     counted_organic_items:0,
            #     average_organic_score:0,
            #     is_dynamic_gap_rule_set:false,
            #     first_organic_score:0,
            #     is_dynamic_initial_gap_set:false,
            #     iterated_organic_items:0,
            #     top_organic_score:0,
            #     feed_slice_number:0,
            #     feed_retrieved_items:0,
            #     ad_req_id:0,
            #     refresh_ts: 0,
            #     cursor_id:31979,
            #     mc_id:0,
            #     ad_index_e2e:0,
            #     seen_ads: {
            #         ad_ids:[],
            #         page_ids:[],
            #         campaign_ids:[]
            #     },
            #     has_ad_index_been_reset:false,
            #     is_reconsideration_ads_dropped:false
            # },
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

                    #location latitude
                    filter_location_latitude: latitude,
                    #location longitude
                    filter_location_longitude: longitude,
                    #distance-radius
                    filter_radius_km: radius_km,

                    #sort by
                    #sort by
                    # nearest first => DISTANCE_ASCEND
                    # newest frist => CREATION_TIME_DESCEND
                    # lowest price => PRICE_ASCEND
                    # highest price first => PRICE_DESCEND
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
        puts JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]
        results.each do |result|
            # puts result["node"]["listing"]["primary_listing_photo"]["image"]["uri"]

        end
        # render json: {results: results, search_info: {count: results.size}}
        # puts [].methods
        render json: JSON.parse(res.body)["data"]["marketplace_search"]["feed_units"]["edges"]
    end

    def marketplace_listing
        targetId = request.query_parameters["targetId"]
        variables = {targetId: targetId}
        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        puts variables
        doc_id = '7820841627934041'
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
        render json: JSON.parse(res.body)["data"]["viewer"]["marketplace_product_details_page"]
    end

    def instagram_search
        query = request.query_parameters["query"]
        variables = {
            data: {
                context: "blended",
                include_reel: "true",
                query: query,
                rank_token: "",
                search_surface: "web_top_search"
          },
          hasQuery: true
        }
        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        doc_id = '8964418863643891'
        res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
        @items = JSON.parse(res.body)["data"]["xdt_api__v1__fbsearch__topsearch_connection"]["users"]
        render "instagram_search"
    end
    def instagram_profile
        id = request.query_parameters["id"]
        variables = {
            id: id,
            # render_surface: "PROFILE",
            include_clips_attribution_info:false,
            first: 12
        }
        'https://www.instagram.com/graphql/query/?doc_id=7950326061742207&variables={"id":"20236507","first":12}'
        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        doc_id = '7950326061742207'
        res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
        puts JSON.parse(res.body)["data"]["user"]["edge_owner_to_timeline_media"]["edges"].size
        render json: JSON.parse(res.body)
    end
    def instagram_profile_reels
        id = request.query_parameters["id"]
        variables = {
            data: {
                include_feed_video:true,
                page_size:12,
                target_user_id:id
                }
            }
        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        doc_id = '8526372674115715'
        res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
        render json: JSON.parse(res.body)
    end
    def instagram_reel
        id = request.query_parameters["id"]
        variables = {
            shortcode: id,
            fetch_tagged_user_count:nil,
            hoisted_comment_id:nil,
            hoisted_reply_id:nil
        }
        doc_id = '8845758582119845'
        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        res = HTTParty.get("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
        # puts res.body
        render json: JSON.parse(res.body)
    end
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
                # context: {
                #     bsid: "0f42a9ed-184f-4fa1-8d28-e955a3fa8a3a",
                #     tsid: nil
                # },
                experience: {
                    client_defined_experiences: ["ADS_PARALLEL_FETCH"],
                    encoded_server_defined_params: "AbqYQQCuIq_5M5MKYA4Iw2z-7xyPApveqAXCe28_Flb57xRVS02IPjGGG4DWRathWwaD0uN042zmnORXBhq4wEPf",
                    fbid: nil,
                    type: "SERVER_DEFINED"
                },
                filters: [],
                text: query
            },
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
        doc_id = '28131523769829398'
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
        puts JSON.parse(res.body)["data"]["serpResponse"]["results"]["edges"].size
        render json: JSON.parse(res.body)
    end
    def facebook_image_search
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
              context: {
                bsid: "699f5f57-b477-4ce6-a88c-b64bd0fadcde",
                tsid: nil
              },
              experience: {
                client_defined_experiences: ["ADS_PARALLEL_FETCH"],
                encoded_server_defined_params: "Abq_qBUYGcG6-WLu7nIlwAoUfoW3d2rn7Gn9QsTMg8TXhuMQLoXyzesw563bhT1RGyyr2E5L-DvhFjaDMOHaO20p1mVfnVMWUx1l77tUdk9JDw",
                fbid: nil,
                type: "SERVER_DEFINED"
              },
              filters: [],
              text: "gary"
            },
            cursor: nil,
            feedbackSource: 23,
            fetch_filters: true,
            renderLocation: "search_results_page",
            scale: 1,
            stream_initial_count: 0,
            useDefaultActor: false,
            __relay_internal__pv__GHLShouldChangeAdIdFieldNamerelayprovider: false,
            __relay_internal__pv__GHLShouldChangeSponsoredDataFieldNamerelayprovider: false,
            __relay_internal__pv__IsWorkUserrelayprovider: false,
            __relay_internal__pv__CometFeedStoryDynamicResolutionPhotoAttachmentRenderer_experimentWidthrelayprovider: 500,
            __relay_internal__pv__CometImmersivePhotoCanUserDisable3DMotionrelayprovider: false,
            __relay_internal__pv__WorkCometIsEmployeeGKProviderrelayprovider: false,
            __relay_internal__pv__IsMergQAPollsrelayprovider: false,
            __relay_internal__pv__FBReelsMediaFooter_comet_enable_reels_ads_gkrelayprovider: false,
            __relay_internal__pv__CometUFIReactionsEnableShortNamerelayprovider: false,
            __relay_internal__pv__CometUFIShareActionMigrationrelayprovider: true,
            __relay_internal__pv__StoriesArmadilloReplyEnabledrelayprovider: true,
            __relay_internal__pv__EventCometCardImage_prefetchEventImagerelayprovider: false
          }



        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        doc_id = '9310443525686377'
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
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
              context: {
                bsid: "96101292-4031-450e-9e8e-59af9173a9cd",
                tsid: "0.7572968350475595"
              },
              experience: {
                client_defined_experiences: ["ADS_PARALLEL_FETCH"],
                encoded_server_defined_params: nil,
                fbid: nil,
                type: "POSTS_TAB"
              },
              filters: [],
              text: "gary"
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
            scale: 1,
            # stream_initial_count: 0,
            # useDefaultActor: false,
            # __relay_internal__pv__GHLShouldChangeAdIdFieldNamerelayprovider: false,
            # __relay_internal__pv__GHLShouldChangeSponsoredDataFieldNamerelayprovider: false,
            # __relay_internal__pv__IsWorkUserrelayprovider: false,
            # __relay_internal__pv__CometFeedStoryDynamicResolutionPhotoAttachmentRenderer_experimentWidthrelayprovider: 500,
            # __relay_internal__pv__CometImmersivePhotoCanUserDisable3DMotionrelayprovider: false,
            # __relay_internal__pv__WorkCometIsEmployeeGKProviderrelayprovider: false,
            # __relay_internal__pv__IsMergQAPollsrelayprovider: false,
            # __relay_internal__pv__FBReelsMediaFooter_comet_enable_reels_ads_gkrelayprovider: false,
            # __relay_internal__pv__CometUFIReactionsEnableShortNamerelayprovider: false,
            # __relay_internal__pv__CometUFIShareActionMigrationrelayprovider: true,
            # __relay_internal__pv__StoriesArmadilloReplyEnabledrelayprovider: true,
            # __relay_internal__pv__EventCometCardImage_prefetchEventImagerelayprovider: false
          }



        variables = variables.to_json
        # puts variables
        variables = URI.encode_www_form_component(variables)
        doc_id = '9310443525686377'
        res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
        # puts res.body
        body = res.body
        render json: JSON.parse(body.split("\r\n")[0])["data"]["serpResponse"]["results"]["edges"]
    end
    def facebook_profile
        query = request.query_parameters["query"]
        variables = {
            reel_ids_arr:[]
        }



        variables = variables.to_json
        puts variables
        variables = URI.encode_www_form_component(variables)
        doc_id = '27760393576942150'
        res = HTTParty.post("https://www.instagram.com/graphql/query?variables=#{variables}&doc_id=#{doc_id}")
        puts res.body
        render json: JSON.parse(res.body)
    end
    def proxy
        url = params[:url]
        image = URI.open(url).read
        send_data image, type: "image/jpeg", disposition: "inline"
    end
end
