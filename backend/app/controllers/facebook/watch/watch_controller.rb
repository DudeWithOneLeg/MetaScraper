# require "stitch"
# require "execjs"
require "selenium-webdriver"
require_relative "../facebook_controller"

module Facebook
  module Watch
    class WatchController < ApplicationController
      def listing_restruct(response, type)
        Facebook.listing_restruct(response, type)
      end

      def watch_search
        variables = {
          allow_streaming: false,
          args: {
            callsite: "comet:watch_search",
            config: {
              exact_match: false,
              high_confidence_config: nil,
              intercept_config: nil,
              sts_disambiguation: nil,
              watch_config: {
                watch_serp_type: 1,
              },
            },
            #   context: {
            #     bsid: "bc75cc7e-6d2f-4a27-a060-e09fd0e896fc",
            #     tsid: "0.015726948262904106"
            #   },
            experience: {
              # client_defined_experiences: ["ADS_PARALLEL_FETCH"],
              # encoded_server_defined_params: nil,
              # fbid: nil,
              type: "WATCH_TAB_GLOBAL",
            },

            # live => "{\"name\":\"videos_live\",\"args\":\"\"}"
            # recent => "{\"name\":\"videos_sort_by\",\"args\":\"Most Recent\"}"
            filters: [],
            text: "hi",
          },
          count: 5,
          # cursor: "AbqO4AZSWggLvvL8k0MTo8UfIOwM-ymlWEaSl9HzsCDnC0jWxdmsUvLqN9ljSIuBwSeKJe6X8FJ3_zAcYvzGFvMNv7fPxcrqzIxFWmKBW9cGP2RtoUXiNwro8ZP6SErjd05cx-3kEaVeUrYUIDeJay6zpMclq94o9EplBFzhUdNUVA60PuUEj_97ZeYgWCX2EPO3X-ON5puVwUYU8QjcVlk4Sld9qi82YABXO8PoVeYN8s5Y9G7g049RpY9YP7TKNC85waWujerbZx-IZvMljDrJZeoQDPMHLr7cyRM8uW_AdGIFp2yun0xKjsZXmk-YWle7tbj0uZRseBxW6wN4UlcZs-PTvbbG1FMqvPFDQcQKhy94eWwYgFjdZdWaQUf2G8opHde6G7TJd_x-rZA6pJqWR7nQoEE24_UcnwbfvGc2iXgh-Ft1DlUGi2Y_KCeqWyPNWlyaOEhfWfodUV5BzajLHiDi0fxcY9q7mzEmNQf8UXk3WiZFBqyYfWrBX_voPKxbBPbWu9-m13q7cW3cjcPavkKBUa3D_KbVFFLntojv56_gNssNcK6v8uGOA2l_Qa8FChwTD-jCviH_5vvj6Hz0wmg2wP57z142q7InkDPKTRsjlo02LGEhFAv6-1IBmHw8b78WefLIxP2oBZszwCci6XX10IiWC_pdIQ0CvWxOH1Ux-pCwxIE1XI2-t3g0iLrtCPoEmgnbFMwNEmcN_iHIfr3pyOLZ9sa0fWUQjElycJ4lGye3iDzkxgxUt2Cww_1TbMP30wyvIsI3ISPEWNPMbMBDCmI79KXRh4X1l-xGHdrr4FudawEWVoC_LlCUepmlmRe95UGDdO-xa_MyGGpTiuAdfDClvwWWHFEZJ-D0pHT0u0GOoIckf5ST1tQ-MGk27Q1_wGPw_F9A92GtpnLo_qQ3Vpsq4Zfev5xRM5Qj3r8mGf6V3EFCFYo1T6-Ke7-WaWaWwyO7_UghgXc4d060N57NV6PjEpjgDxpLMxrc_c88DXCBuxeoffgu0BbSAcNPBe4jfdWchuccI5EC4s1Kc23h5PqJGh9-aQ6Lge7UqyfjPOcg9dzvAamsXuv6-_dMM3Yich05ITE40BAp3WzBFBGpXbLhpsOBkwoBaBBduMuFkMe1D4_597O_JsWmujNFZj93w1691ENoF1XovDvVS6k56RWCYfDywi55knCMHdBFf_HVE1LPRO15tMqueG4Knn7JOpKVItF6iCVzkDsGBiQs5Ir2-zki9N-O0LcoxiASFxmOqtFjcyG2Qlbb4fpK37soKTpEd4HktoNet0YanpmisRepIAcqUclgXBlq3LEUlfyGg7sRye4i2QOoBvXTFtUyCobglcIMxQrDsdBLxvrfAy1n3VMAjiTDIrAgElHdboB51PPdrsVaAoZcmbYGm3H_MdQsnWJM8ldEyr3S2rOs7ng7NRxXUNmMCNLvFiSQfp_2bfcda5Ps7mgd9D1l-Nrzgj70LwMqRyPd-O2gg5k4WBgL-ODg0g8RTE4TfIo-A_Qwx_qsYfxNIgYEV3YH7wK_-Jo2NQaRq2-ZRBmleuGxVUAnLn9nCk2U88GFLFOHcdTWAMAzCoLFV7miAwF3YqPUItO4JlB9GCENOfO3WBFg-YuRgUn7WGad9h2igJfVMmH_K16LqyRSFNGWlNQ28ZupYXfm7Alby2cBaef2PXUzjJFIC8pXqG97Psr6MLTSfSByq_zbcDKJ63xzi-s",
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

        results = listing_restruct(body, 3)

        render json: results
      end

      def watch_video
        # variables = { scale: 2, videoId: "1864880327319690" }
        # variables = variables.to_json
        # variables = URI.encode_www_form_component(variables)

        # doc_id = "9280890455288670"
        # js_code = File.read(File.expand_path("../web_driver.js", __FILE__))

        # Compile and execute
        # puts ExecJS.runtime.name

        # context = ExecJS.compile(js_code)
        # puts context.call("interceptRequests", "https://www.facebook.com/watch?v=1864880327319690")
        # options = Selenium::WebDriver::Options.chrome
        # options.web_socket_url = true
        options = Selenium::WebDriver::Chrome::Options.new
        # options.add_argument("--headless") # Optional
        service = Selenium::WebDriver::Chrome::Service.new

        driver = Selenium::WebDriver.for :chrome, options: options, service: service
        devtools = driver.devtools

        # Connect to Chrome DevTools Protocol
        devtools.connect!

        # Enable necessary domains
        devtools.execute_cdp("Network.enable")
        driver.execute_cdp("Network.setRequestInterception", patterns: [{
                                                               urlPattern: "*",
                                                               resourceType: "XHR",
                                                               interceptionStage: "Request",
                                                             }])
        devtools.on_cdp_event("Network.responseReceived") do |params|
          response = params["response"]
          puts "\nIncoming Response:"
          puts "URL: #{response["url"]}"
          puts "Status: #{response["status"]}"
          puts "Headers: #{response["headers"]}"

          # Get response body if needed
          if response["status"] != 304 # Skip 304 Not Modified
            begin
              body = devtools.execute_cdp("Network.getResponseBody", requestId: params["requestId"])
              puts "Body: #{body["body"][0..200]}..." # Show first 200 chars
            rescue => e
              puts "Couldn't get response body: #{e.message}"
            end
          end
        end
        driver.get("https://www.facebook.com/watch?v=1864880327319690")
        # devtools.on
        # requests.on(:before_request) do |event|
        #     puts "Intercepted request: #{event['url']}"
        #     # You can modify the request here if necessary
        #   end

        # response = HTTParty.get("https://m.facebook.com/1864880327319690")
        # body = JSON.parse(response.body)
        # File.write(File.expand_path("../test.html", __FILE__), response.body)

        render json: {}
      end

      #fetches each category and grabs sub categories
      def watch_categories
        path = File.expand_path("../watch_categories.json", __FILE__)

        begin
          categories = JSON.parse(File.read(path))
        rescue JSON::ParserError, Errno::ENOENT => e
          return render json: { error: "Failed to load categories: #{e.message}" }, status: :unprocessable_entity
        end

        data = {}

        categories.each do |category|
          next unless category && category["node_id"]

          variables = build_variables(category["node_id"])
          sub_categories = fetch_subcategories(variables)

          if sub_categories
            # Convert sub_categories array to hash
            sub_categories_hash = {}

            sub_categories.each do |sub_category|
              next unless sub_category && sub_category["node_id"]

              variables = build_variables(sub_category["node_id"])
              sub_sub_categories = fetch_subcategories(variables)

              if sub_sub_categories
                # Convert sub_sub_categories array to hash
                sub_sub_categories_hash = {}

                sub_sub_categories.each do |sub_sub_category|
                  next unless sub_sub_category && sub_sub_category["node_id"]

                  variables = build_variables(sub_sub_category["node_id"])
                  sub_sub_sub_categories = fetch_subcategories(variables)

                  if sub_sub_sub_categories
                    # Convert sub_sub_sub_categories array to hash
                    sub_sub_sub_categories_hash = {}

                    sub_sub_sub_categories.each do |sub_sub_sub_category|
                      next unless sub_sub_sub_category && sub_sub_sub_category["node_id"]
                      sub_sub_sub_categories_hash[sub_sub_sub_category["node_id"]] = sub_sub_sub_category
                    end

                    sub_sub_category["sub_categories"] = sub_sub_sub_categories_hash
                  end

                  sub_sub_categories_hash[sub_sub_category["node_id"]] = sub_sub_category
                end

                sub_category["sub_categories"] = sub_sub_categories_hash
              end

              sub_categories_hash[sub_category["node_id"]] = sub_category
            end

            category["sub_categories"] = sub_categories_hash
          end

          data[category["node_id"]] = category
        end

        File.write(File.expand_path("../watch_categories_with_sub.json", __FILE__), JSON.pretty_generate(data))
        render json: data
      rescue StandardError => e
        render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
      end

      private

      def build_variables(channel_id)
        variables = {
          channelID: channel_id,
          isCrawler: false,
          mainTopicNumVideosToShow: 12,
          page: 1,
          scale: 2,
          triggerData: {
            channel_id: "dmg6NjU3MDUxNDE4MDM4MDgyOjEwMTU1ODY4ODAyMTk1NzI3",
          },
        }
        URI.encode_www_form_component(variables.to_json)
      end

      def fetch_subcategories(variables)
        doc_id = "9336810399733077"
        response = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}")

        return nil unless response&.success?

        begin
          body = JSON.parse(response.body)
          sub_categories = body.dig("data", "video_home_www_subtopic_info_list")
          sub_categories.present? ? sub_categories : nil
        rescue JSON::ParserError
          nil
        end
      end
    end
  end
end
