require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"
require_relative "../facebook_controller"

module Facebook
  module Events
    class EventsController < ApplicationController
      def listing_restruct(response, type)
        Facebook.listing_restruct(response, type)
      end

      def events_search
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
              type: "EVENTS_TAB",
            },

            # today, tomorrow (yyyy-mm-dd) => "{\"name\":\"filter_events_date\",\"args\":\"2025-02-09\"}", this week, etc => 2025-02-10~2025-02-16
            # location => "{\"name\":\"filter_events_location\",\"args\":\"104060076298330\"}"
            # category => "{\"name\":\"filter_events_category\",\"args\":\"1118260531654782\"}"
            # online => "{\"name\":\"filter_events_online\",\"args\":\"\"}"
            # paid => "{\"name\":\"filter_paid_events\",\"args\":\"\"}"
            # family friendly =>  "{\"name\":\"filter_events_kids_friendly\",\"args\":\"\"}"
            filters: [],
            text: "music",
          },
          count: 5,
          cursor: "AbrsTR4C578vU7pyVvbzE93mfOWWem0X4Ckh0ldZ2Cn3ww6mYEReG6XCySgC1_wBTcxK5JOKbhzl6LTZKUTvZhQXVq0rqwobJW46QmyBZqH11LqWSTa6HzxUHuh-jwdIb00sNwD0XLP_JaEg-aJW3OgXxmaGaBXc1RVGTOCO7G6ss43vPpwzVHHm-...",
          feedLocation: "SEARCH",
          feedbackSource: 23,
          fetch_filters: true,
          focusCommentID: nil,
          locale: nil,
          privacySelectorRenderLocation: "COMET_STREAM",
          renderLocation: "search_results_page",
          scale: 2,
          stream_initial_count: 0,
          useDefaultActor: false,
        }

        variables = variables.to_json
        variables = URI.encode_www_form_component(variables)

        doc_id = "9506048516125027"

        response = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")
        body = JSON.parse(response.body)
        
        results = listing_restruct(body, 4)

        render json: results
      end
    end
  end
end
