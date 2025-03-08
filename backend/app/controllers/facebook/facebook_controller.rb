require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"

module Facebook

  def self.parse_photo_attachment(attachment)
    type = "Photo"
    media = attachment.dig("styles", "attachment", "media")
    id = media.dig("id")
    url = media.dig("url")
    image = media.dig("comet_photo_attachment_resolution_renderer", "image")
    accessibility_caption = media.dig( "accessibility_caption")

  end

  def self.parse_post_attachment(attachment)
    type = target.dig("target", "__typename")
  end

  def self.parse_post_ranges(attachment)
    type = target.dig("target", "__typename")
  end

  def self.listing_restruct(response, type)
    results = []
    page_info = {}

    if type == 1
      listings = response.dig("data", "viewer", "marketplace_feed_stories", "edges")
      page_info = response.dig("data", "viewer", "marketplace_feed_stories", "page_info")
      listings.each do |listing|
        info = listing.dig("node", "listing")
        results.push(info)
      end
    end
    if type == 2
      listings = response.dig("data", "marketplace_search", "feed_units", "edges")
      page_info = response.dig("data", "marketplace_search", "feed_units", "page_info")
      listings.each do |listing|
        info = listing.dig("node", "listing")
        if info != nil
          results.push(info)
        end
      end
    end

    if type == 3
      listings = response.dig("data", "serpResponse", "results", "edges")
      page_info = response.dig("data", "serpResponse", "results", "page_info")

      listings.each_with_index do |result, index|
        info = result.dig("rendering_strategy", "view_model")
        id = info.dig("video_metadata_model", "video", "id")
        title = info.dig("video_metadata_model", "title")
        description = info.dig("video_metadata_model", "save_description")
        relative_time_string = info.dig("video_metadata_model", "relative_time_string").split(" · ")
        upload_date = relative_time_string[0]
        views = relative_time_string[1]
        author_profile = info.dig("video_metadata_model", "video_owner_profile")
        author = author_profile["name"]
        author_id = author_profile["id"]
        thumbnail_url = info.dig("video_thumbnail_model", "thumbnail_image", "uri")
        duration = info.dig("video_thumbnail_model", "video_duration_text")
        results.push({
          title: title,
          description: description,
          upload_date: upload_date,
          views: views,
          author: {
            id: id,
            name: author,
          },
          thumbnail_url: thumbnail_url,
          duration: duration,
        })
      end

    end
    if type == 4
      listings = response.dig("data", "serpResponse", "results", "edges")
      page_info = response.dig("data", "serpResponse", "results", "page_info")

      listings.each do |result|
        info = result.dig("rendering_strategy", "view_model", "profile")
        id = info.dig("id")
        name = info.dig("name")
        url = info.dig("url")
        profile_url = info.dig("profile_url")
        profile_picture = info.dig("profile_picture")

        results.push({
          id: id,
          name: name,
          url: url,
          profile_url: profile_url,
          profile_picture: profile_picture,
        })
      end
    end

    if type == 5
      listings = response.dig("data", "serpResponse", "results", "edges")
      page_info = response.dig("data", "serpResponse", "results", "page_info")

      listings.each do |result|
        info = result.dig("rendering_strategy", "view_model", "click_model", "story", "comet_sections", "content", "story")

        post_id = info.dig("post_id")
        ranges = info.dig("comet_sections", "message", "story", "message", "ranges")
        text = info.dig("message", "text")
        attachments = info.dig("attachments")

        feedback = result.dig("rendering_strategy", "view_model", "click_model", "story", "comet_sections", "feedback", "story", "story_ufi_container", "story")
        reactions = feedback.dig("feedback_context", "feedback_target_with_context", "comet_ufi_summary_and_actions_renderer", "feedback")

        total_reaction_count = reactions.dig("reaction_count", "count")
        top_reaction_count = reactions.dig("top_reactions", "count")
        top_reactions = reactions.dig("top_reactions", "edges")
        share_count = reactions.dig("share_count", "count")
        comment_count = reactions.dig("comments_count_summary_renderer", "feedback", "comment_rendering_instance", "comments", "total_count")
        actors = result.dig("rendering_strategy", "view_model", "click_model", "story", "comet_sections", "context_layout", "story", "comet_sections", "actor_photo", "story", "actors")
        metadata = result.dig("rendering_strategy", "view_model", "click_model", "story", "comet_sections", "context_layout", "story", "comet_sections", "metadata")[1].dig("story")
        post_url = metadata.dig("url")
        creation_time = metadata.dig("creation_time")

        top_reactions.map! do |reaction|
          id = reaction.dig("node", "id")
          name = reaction.dig("node", "localized_name")
          count = reaction["reaction_count"]
          {id: id, name: name, count: count}
        end
        
        actors.map! do |actor|
          name = actor["name"]
          id = actor["id"]
          profile_url = actor["profile_url"]
          profile_picture = actor["profile_picture"]
          {
            name: name,
            profile_url: profile_url,
            profile_picture: profile_picture
          }
        end

        attachments.map! do |attachment|

        end

        user = actors[0]

        results.push({
          post_id: post_id,
          ranges: ranges,
          text: text,
          attachments: attachments,
          feedback: {
            reactions: {
              total_reaction_count: total_reaction_count,
              top_reactions: top_reactions,
              top_reaction_count: top_reaction_count
            },
            share_count: share_count,
            comment_count: comment_count
          },
          actors: actors,
          user: actors[0]
        })
      end
    end

    {results: results, page_info: page_info}
  end

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
            watch_config: nil,
          },
          experience: {
            client_defined_experiences: ["ADS_PARALLEL_FETCH"],
            encoded_server_defined_params: "AbqYQQCuIq_5M5MKYA4Iw2z-7xyPApveqAXCe28_Flb57xRVS02IPjGGG4DWRathWwaD0uN042zmnORXBhq4wEPf",
            fbid: nil,
            type: "PEOPLE_TAB",
          },
          filters: [],
          text: query,
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
      doc_id = "28131523769829398"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      body = JSON.parse(res.body)
      results = Facebook.listing_restruct(body, 4)
      render json: results
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
        __relay_internal__pv__CometFeedStoryDynamicResolutionPhotoAttachmentRenderer_experimentWidthrelayprovider: 500,
      }

      variables = variables.to_json
      puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "8795610053899267"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      body = res.body
      puts JSON.parse(body)
      render json: JSON.parse(body)
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
        __relay_internal__pv__IsWorkUserrelayprovider: false,
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
            watch_config: nil,
          },
          experience: {
            encoded_server_defined_params: "Abq_qBUYGcG6-WLu7nIlwAoUfoW3d2rn7Gn9QsTMg8TXhuMQLoXyzesw563bhT1RGyyr2E5L-DvhFjaDMOHaO20p1mVfnVMWUx1l77tUdk9JDw",
            type: "SERVER_DEFINED",
          },

          # location => "{\"name\":\"location\",\"args\":\"104060076298330\"}"
          # year 2025 => ["{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-1\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-12\\\",\\\"start_day\\\":\\\"2025-1-1\\\",\\\"end_day\\\":\\\"2025-12-31\\\"}\"}"]
          filters: [],
          text: query,
        },
        cursor: nil,
        feedbackSource: 23,
        fetch_filters: true,
        renderLocation: "search_results_page",
        scale: 1,
        stream_initial_count: 0,
        useDefaultActor: false,
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
            watch_config: nil,
          },
          experience: {
            client_defined_experiences: ["ADS_PARALLEL_FETCH"],
            encoded_server_defined_params: nil,
            fbid: nil,
            type: "POSTS_TAB",
          },
          # recent => ["{\"name\":\"recent_posts\",\"args\":\"\"}"]
          filters: [],
          text: query,
        },
        count: 24,
        cursor: "Abr9OdH5ykreV_CMOjXxRDpi6i4VakeOQvuCGsJxvEBuLp125HkTt3aAEjxwMjhX33Qw_H5J1JYN_j48ReiLURgAhRs-hRKl3OI9u4FHBYsu3u5pz0LIs3QVyNCOX6Knap2auqE5jWaJR7ZaLLoGX-oPuV3vaoHEiDJdTHOj-1V0jd24MIBJy72bJAUZCrKpetgL--fhqYPRIzn8pOtIuv7vQWiwQkLghtEeo4NKVtdCwLW8fR0r8r9_e3JeWHiotObh0ixGWLyRGXp7ZGl-sraTnd3cXmwhvzbKYhlXeHB819AuADuhNQNf5ozC_DxXLE4wsIV6-umuse352NdylG4zaGznZon4At1E3gApsa62f6MNaSnKsUN5xESXPdy-DUwfIqSPKRxqj_kW7s6tE8-jeMxNGzzJajKGkjZJy-YNePp30Qn5e2kH1PW06VTAnCvgiCbg-ZngoR8Hk3KWC3FYpXQ09ndWmkWEUr3r1uJakpJ6-wedviUGxmqdddhSagZQCa8XOGsyRKuDDaU3NYA4EdR_QsfYZbTzwFe1fLQQ3PWsv6WVHAjWA1JtFvJSzckPivwRvOfiSbeVVTg-j_7IYFJe2Se6kgeaSXAifYmA7EA4eEswQ9S7GH6yPRxi_gnddnTzBOA9tI-hzHbr50bchtIDCP6no0hC1Mf2nWGghr54g9u7rwnds8Pv_ll-FdasWqSZpnkMo92F2vL3zyfNDahY-lW4iuQEUJgsGIAVzF8ap3azZppy0FsCLMgrvEKOBr1g4eTLg9sjA__hfhuPzqQHil5VeJ5JTmACsSBo5ZVgbOHVGpGwTsDBc9MfDlNNdoRwIq1_ke7oDvr1Hi5kfhoLZqis0DLzwRMkI4-BIS1yNGTn_4fO3aIi3jDkwUvt1YKVB2lOilT-ArS0BHp3gJRpiNCsKe4tc18ft8p4XzxCosBTG_-uIJ0hisMePuHi1IOQRZHLqNLqiIz1RQOt1dtf3zNj74ZLSW20Xg_as3WDMZDG502NG6ACRv1HLc3LnzAnPRYQHQOl2GzSr-SolWPCbZrWk3r3QVWIUXWV6Ff_TthcDw8RFOzP9BnnTJ4qvaGHoNq1YYZC4UeB9nwXdHo-r57D2qEu4dpbfHQYz5AzM-kcOvARz5EHvZ4UGZ5iCOsKMawzWAKvIckWD6cZcJXKFEBseQsNFKb0TZ7RaT025VQvKpQt7o5OzVN3py_Ml9Ipn7tcfX1woIlxPunOy0vNIn-z8Ir07sJIFN2ZnkfnCb7eE8WtHAZ2B40iy4DoLtbyYt-Lt14cZekR0W6TeQVJnFtkVTYO2bmSJz0Y-0xa1_U09oFXscAAk9lFX-9zMrkgAIuFtUEWY2LNuuEAJogSKT7crBsBUxiZj7YhQ2rqbKH7vdDBiRwo9sFvmPFhL9YHWgiVJWAr5LxYlgEsd2kaGo8Dfq06Q283oAdC2Qv6Pg6LXWm1jzS7rshrmIsVcSQx6zswzN3XUgYM-qD2DXdkCoGpG3zMsZLxcCU2tOBIoVKBGKwdb-CyvnsfC_dlJPASe68fQeu4T9aOKbEAZl2sQ1csD9opbpWhkfAHfbLq9MNlrP2QJSexocCTysWgB1-ms6TxDaTghiinhEmQQvLFNixXkrVRzavWDKKB-xmCWOQara3gBf83UhzGAXL0N9VquvlI76oG-79U1KSCGCchAXFPyYWm0AFFDIE5bQ",

        feedLocation: "SEARCH",
        feedbackSource: 23,
        fetch_filters: true,
        focusCommentID: nil,
        locale: nil,
        privacySelectorRenderLocation: "COMET_STREAM",
        renderLocation: "search_results_page",
        scale: 2,
      stream_initial_count: 10,
      # useDefaultActor: false,
      }

      variables = variables.to_json
      # puts variables
      variables = URI.encode_www_form_component(variables)
      doc_id = "9310443525686377"
      res = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)
      # puts res.body
      body = JSON.parse(res.body.split("\r\n")[0])
      results = Facebook.listing_restruct(body, 5)
      render json: body
    end

    def facebook_company_search
      query = request.query_parameters["query"]
      variables = {
        count: 8,
        filterID: "Z3NxZjp7IjAiOiJicm93c2VfaW5zdGFudF9maWx0ZXIiLCIxIjoia2V5d29yZHNfdXNlcnMoZ2FyeSkiLCIzIjoiZmFjY2UwMzgtMzc0MS00NDkzLWEyMzYtZGVlMTQwNDY2NDU1IiwiY3VzdG9tX3ZhbHVlIjoiQnJvd3NlVXNlcnNTY2hvb2xJbnN0YW50RmlsdGVyQ3VzdG9tVmFsdWUifQ==",
        query: query,
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
            watch_config: nil,
          },
          experience: {
            type: "VIDEOS_TAB",
          },

          # relavance => []
          # most recent => "{\"name\":\"videos_sort_by\",\"args\":\"Most Recent\"}"
          # today => "{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-01\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-01\\\",\\\"start_day\\\":\\\"2025-01-30\\\",\\\"end_day\\\":\\\"2025-01-30\\\"}\"}"
          # this week => "{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-01\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-02\\\",\\\"start_day\\\":\\\"2025-01-27\\\",\\\"end_day\\\":\\\"2025-02-02\\\"}\"}"
          # this month => "{\"name\":\"creation_time\",\"args\":\"{\\\"start_year\\\":\\\"2025\\\",\\\"start_month\\\":\\\"2025-01\\\",\\\"end_year\\\":\\\"2025\\\",\\\"end_month\\\":\\\"2025-01\\\",\\\"start_day\\\":\\\"2025-01-01\\\",\\\"end_day\\\":\\\"2025-01-31\\\"}\"}"
          # live => "{\"name\":\"videos_live\",\"args\":\"\"}"
          filters: [],
          text: query,
        },
        cursor: cursor,
        feedbackSource: 23,
        fetch_filters: true,
        renderLocation: "search_results_page",
        scale: 1,
        stream_initial_count: 0,
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
          page_category: ["CITY", "SUBCITY", "NEIGHBORHOOD", "POSTAL_CODE"],
          query: "Lewisville, Texas",
          search_type: "PLACE_TYPEAHEAD",
          viewer_coordinates: { latitude: 33.046289, longitude: -96.994123 },
        },
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

