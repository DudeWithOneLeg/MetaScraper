require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"

module Facebook
  module Pages
    class PagesController < ApplicationController
      def pages_search
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
                    bsid: "ccbb2454-11c9-4062-a0c4-6b163875c3cc", 
                    tsid: "0.12328843705219938" 
                }, 
                experience: { 
                    client_defined_experiences: ["ADS_PARALLEL_FETCH"], 
                    encoded_server_defined_params: nil, 
                    fbid: nil, 
                    type: "PAGES_TAB" 
                }, 
                # {
                #     [
                #         {{
                #     "text":"Local Business or Place",
                #     "value":"{\"name\":\"pages_category\",\"args\":\"1006\"}",
                #     "value_type":"RADIO"
                #     }},
                #     {"node": {
                #         "text":"Company, 
                #         Organization or Institution",
                #         "value":"{\"name\":\"pages_category\",\"args\":\"1013\"}",
                #         "value_type":"RADIO"
                #         }
                #     },
                #     {"node": {
                #         "text":"Brand or Product",
                #         "value":"{\"name\":\"pages_category\",\"args\":\"1009\"}",
                #         "value_type":"RADIO"
                #         }
                #     },
                #     {"node": {
                #         "text":"Artist, Band or Public Figure",
                #         "value":"{\"name\":\"pages_category\",\"args\":\"1007,180164648685982\"}",
                #         "value_type":"RADIO"
                #         }
                #     },
                #     {"node": {
                #         "text":"Entertainment",
                #         "value":"{\"name\":\"pages_category\",\"args\":\"1019\"}",
                #         "value_type":"RADIO"
                #         }
                #     },
                #     {"node": {
                #         "text":"Cause or Community",
                #         "value":"{\"name\":\"pages_category\",\"args\":\"2612\"}",
                #         "value_type":"RADIO"
                #         }
                #     }]}
                # filters: ["{\"name\":\"pages_category\",\"args\":\"1013\"}"], 
                text: "gary"
             }, 
             count: 5, 
             cursor: "AbrzTuSMWQE3SRoQMoPms2mLnEVbBk4GJjGBp0MRJ7SrTSimFU0f3DVmpYFMskkPG6xJpD8OwhZEPCS9ZIamb8WQLZbqBS1JiMacGoidjqFrqwe0VYap1jOia8KWA3My4BLsEj6CdCFWqr7tsN6Re3BP0WaLWwTQYmLp7K0amHeWoDamXUnSvUtMZzD93B6ksLXfORcqQgW14caKt3fOFlmoDgpK73DJ8oQWox4PnhWaEHaARuddSc42PRsIFNBKONRvGRc07fys1_UYz3JfuA2b8nDNbu_SwfcjhEmhkMgWYOnWLCFP64g3ExIRIpXAIytn40nBiVgs7fVS3Bc-PSPoJXagmm2TH66YfNLBXf9jxKg58EjJJtc9dr_6wgqzrDm2rCrMLN0ZOGshLOhE7C4CCqtq77C4O5n6MpDCR6FWKrU7QmdLMjtuWl2WuLXdAR4HNSxIyaN_NG3SaEKUAPw2paDggpDfZ0Z1a3x1ohsf_2VHYE3L9MAzbjlgIZOQOF6LNC_xK580-1KrqXx6U4AwuxmbkZ018mgzDAUymJRATNESJgvL-NDhUvu9hFjthHC-Jhinr7h-A_HJAkk6NuP-Q61LxgeelRV4fQQNKJYmjqhe2vko48PUj7Aol5RafINmdfIMneXXcN2_WxuQESCZLsgTiE-19gcA3GOG6wGtV0fzZGuzfrLDU9RskoN0pEznlwnTmIK3mhRRDQiryxD6Rr3NpFOBeDH6mhSghhnVgVTZOrSTJZDjPFnJDoODLij5eENlkFlSRQNLmBsas5b-Pbxt8DUSCinzvzqEmyy0KDOnOYpbiZHCJuRHr2f7U-oserYKEnnTFqaL-KoT5SdhvKf8sQUSykjHjNeKC-1BZTaW_HXGCQG8FDZPP_-_y59J4x4njrRzb4a4WHou6Y9J5OSYR7zGx9t2WWXjKfRoIWqm2Z5jfJ5bDKK7z7EwjBYewjgH4k1y-ukc3I8oVXR4w6ys1Jqb1xcLLtIjAH9YlOVYz_GwHEA7KLklvfHe23YlW6wfvzJKfNhjFNmHuTrKHNcdPMXx6TQ5VGpA8a19RBUUP0q6_UyKqm6D7wu4Bc1sEo5mK-V4zELaFJfasJB4diQvkQDHOFBeOWgriEqmKCvywDg9bS761Wx54PRbUfedo_VlkLLoZB5TI0cwGwBYXEtrscQjdOnazmb4-5ty1idkCz2txPbWqTnr8mVE0Dzsw4M-DYqJ9VXCWHCxlL7IvaZymBMC2tVdX9CfVX0j3FislURwo-zSXAWn5j98Medw-htjfOrEWDgyslcANEBs2RqUdnOASzi7bFHBeZMmVYfaqO8XS7FaZ8GHOuuW61ktdphCFodeAJm6f93o4yMfmeOYhjDAEoe8Bfwaj3KqUe9fsHm9Y3TDxdzPU18NYVcmEGfJ4tz36lRPXAxrsxxCWegFK2_xGPbAPsNKxMP9xqveApi0kqG-E30AV3LS7-SY5xTWH5lo75Edy5JOJRhrZiCw2SQNamXdu2bkufAZ2PouCsWWNzDsrXXUWOieuF384Yb2yqiJ3nzgXmRx2UO7cg6QQk0mQYoxE8u_5Zgg5w", 
             feedLocation: "SEARCH", 
             feedbackSource: 23, 
             fetch_filters: true, 
             focusCommentID: nil, 
             locale: nil, 
             rivacySelectorRenderLocation: "COMET_STREAM", 
             renderLocation: "search_results_page", 
             scale: 2, 
             stream_initial_count: 0, 
             useDefaultActor: false, 
            #  __relay_internal__pv__GHLShouldChangeAdIdFieldNamerelayprovider: false, 
            #  __relay_internal__pv__GHLShouldChangeSponsoredDataFieldNamerelayprovider: true, 
            #  __relay_internal__pv__IsWorkUserrelayprovider: false, 
            #  __relay_internal__pv__CometFeedStoryDynamicResolutionPhotoAttachmentRenderer_experimentWidthrelayprovider: 600, 
            #  __relay_internal__pv__CometImmersivePhotoCanUserDisable3DMotionrelayprovider: false, 
            #  __relay_internal__pv__WorkCometIsEmployeeGKProviderrelayprovider: false, 
            #  __relay_internal__pv__IsMergQAPollsrelayprovider: false, 
            #  __relay_internal__pv__FBReelsMediaFooter_comet_enable_reels_ads_gkrelayprovider: false, 
            #  __relay_internal__pv__CometUFIReactionsEnableShortNamerelayprovider: false, 
            #  __relay_internal__pv__CometUFIShareActionMigrationrelayprovider: true, 
            #  __relay_internal__pv__StoriesArmadilloReplyEnabledrelayprovider: true, 
            #  __relay_internal__pv__EventCometCardImage_prefetchEventImagerelayprovider: false 
        }

        variables = variables.to_json
        variables = URI.encode_www_form_component(variables)
        doc_id = "9506048516125027"

        response = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
        puts response.body

        render json: JSON.parse(response.body)
      end
    end
  end
end
