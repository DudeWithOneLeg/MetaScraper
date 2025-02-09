require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"

module Facebook
    module Groups
        class GroupsController < ApplicationController

            @@proxy_url = "192.168.49.1"
            @@proxy_port = "8000"
            # @@proxy_url = nil
            # @@proxy_port = nil

            def groups_search

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
                        bsid: "7991c4b1-67c7-4c29-936d-7f91ebc244fc",
                        tsid: nil
                      },
                      experience: {
                        client_defined_experiences: [
                          "ADS_PARALLEL_FETCH"
                        ],
                        encoded_server_defined_params: nil,
                        fbid: nil,
                        type: "GROUPS_TAB"
                      },
                        # location => "{\"name\":\"filter_groups_location\",\"args\":\"104060076298330\"}"
                        # near me => "{\"name\":\"filter_groups_local\",\"args\":\"\"}"
                        # public groups => "{\"name\":\"public_groups\",\"args\":\"\"}"
                        filters: [
                          "{\"name\":\"public_groups\",\"args\":\"\"}"

                        
                      ],
                      text: "food"
                    },
                    cursor: nil,
                    feedbackSource: 23,
                    fetch_filters: true,
                    renderLocation: "search_results_page",
                    scale: 2,
                    stream_initial_count: 0,
                    useDefaultActor: false,
                    # __relay_internal__pv__GHLShouldChangeAdIdFieldNamerelayprovider: false,
                    # __relay_internal__pv__GHLShouldChangeSponsoredDataFieldNamerelayprovider: true,
                    # __relay_internal__pv__IsWorkUserrelayprovider: false,
                    # __relay_internal__pv__CometFeedStoryDynamicResolutionPhotoAttachmentRenderer_experimentWidthrelayprovider: 600,
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
                variables = URI.encode_www_form_component(variables)

                doc_id = "8870508706394436"

                response = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}",
                http_proxyaddr: @@proxy_url, 
                http_proxyport: @@proxy_port)

                render json: JSON.parse(response.body)

            end
        
        end
    end
end