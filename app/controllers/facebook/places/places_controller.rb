require "httparty"
require "uri"
require "json"
require "open-uri"
require "nokogiri"
require "selenium-webdriver"

module Facebook
  module Places
    class PlacesController < ApplicationController
      @@proxy_url = "192.168.49.1"
      @@proxy_port = "8000"
    #   @@proxy_url = nil
    #   @@proxy_port = nil

      def places_search
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
            context: {
              bsid: "7a93dec2-c4fd-4621-9fae-8fb7a4857c28",
              tsid: nil,
            },
            experience: {
              client_defined_experiences: [
                "ADS_PARALLEL_FETCH",
              ],
              encoded_server_defined_params: nil,
              fbid: nil,
              type: "PLACES_TAB",
            },
            # open now => ["{\"name\":\"place_open_at\",\"args\":\"1\"}"]
            # delivery => ["{\"name\":\"place_delivery\",\"args\":\"delivery\"}"]
            # takeout => ["{\"name\":\"place_takeout\",\"args\":\"takeout\"}"]
            # location => "{\"name\":\"place_location\",\"args\":\"114148045261892\"}"
            # STATUS
                # new hours => "{\"name\":\"place_status\",\"args\":\"differently_open\"}"
                # temporarily closed => temporarily_closed
                # normal hours => operating_as_usual
            # PRICE
                # $ => "{\"name\":\"place_price\",\"args\":\"1\"}"
                # $$ => "{\"name\":\"place_price\",\"args\":\"2\"}"
                # $$$ => "{\"name\":\"place_price\",\"args\":\"3\"}"
                # $$$$ => "{\"name\":\"place_price\",\"args\":\"4\"}"
            filters: [],
            text: "gary",
          },
          count: 5,
          cursor: "AboI49hNbOy1fhNg5xCQC1dLqj0R5Ft-W4EINr0xLMf36kbyEoK9IFB5So0pBoY6RBqz4qXgQsCMu-gIjt3FkwoUAniGungp4sYCQ1_0dB0TtwogAgz3HEdQf-B5A15p83lbfHYInzNdM5xa45R9bBI9JRNr5XARSHIQKYCBON1K0f4FsJL96ObMePecDp-zlxoLdLiaPW5WUdS3byZxBIlP1d9VwVVzailVBu8dbdpnF_LY-AQC3ZXsV5VsnJW6-kfcbeV78vFuHPo86QrlpldCHS9nvj-ki7Bls2vU9rZh1LjaX2bPV2j4TVB2D78XfGARP7Yscl5eFjM_PL3fPHmNi0lvBirk1oZbqVZhAG7YTtY4zrLYlmNc5xmKB8j3j0328LDEKvuqcMII9MMKLXJFzU0hG8vVLN9fU1gFIPPS874p1DSXmmYF4WMHIofiovoMXcG6zAwl4_rs7eKFVsgK_oFLS--zf1lHex8x9FFqwlkvbzHJrQClxOev1RzFthtqq9yzvkUKd4xfv1uP6R2J6VRrhTnXT6sEWh1_xsPc_XKcdpWYMK3NlU2qc0L0IqG7KfitFL9u-RBaViIQB9KeYo4E-ONmt8PkxW0UxDgAnsGkd3uMPm3V6GHoDTESujJH3yT2X34QD3olHhBEybN2paaLiEUfCEWQglYD3ouqiGdyPiiRnPVM9v8MIK9qVYOP8DTTjqqSHA3tezggb7nWgrY9WCCTt5VbeWqiqnqdtm1DHEDZWw_0-H0IcsWnrOb7R2-PcTCGguc4Efe3lVzS246WlHG0j-77ATT0ADCz7r_2utGgVESOh4vQBGZEbeRKKvyazKhUAcxyfBhLlmGe662I_wdhLDLha4DP4jrlmAYsra0BB1Tp6uyVgE9hLnw-Nw8Ou4Io4pWys7J2EtKn27lWfek5pvWhQdtbUckmanDFjXRKkbtmTqALjgDtA3AaOYjs3xKvYI9BtSy5Ph4mWwzxis_X_IhagL8kQOugIx3La_oceKfwCa5_eJBcDke-ydNnJ2BoZiF62MDXNdllNCwFSn2RFf6OFYZGpsDCiZTpQLIArS6kgVvdo7XM3s2GC3tiB_mRGVybty22MXbm1bQpuW0aMfmIQntOCwVKNjL2n34Q_S3qu_J-QrLwuJzfW1blHrS1oooidSWcPvS_EGU90s3E73_Cwqps80nqo2xe6Jc-CpPOSpHiuKs-1E5rfLq0L18JA8simPgkVfT8kgtNXAeyBVx4-KsmBZdMv5T1iNADfFyJryc72wYurlStJsYBuNj0dbUBZXImIrl3ggIeshmoOIR3gvAA_wF_MS-OOmQCHIdmGCDHEEWHI45xJw08_ipIg1pZBGAY-3n-_UFYVu73jNmg7QVgyEIBc-LLb_Js4WQhRG-8yMAR3m5iAYe3LAGIJNDSYvONbjTu8ji7e0I9svouJ5HkJadCttsvOdDnJ49m9FUbtGUoo247SmYMrzmbo9RZHGUu5dQTNsyy2Yq_nraX4nDignleirLh6RBr-yznMSqegjMu-iCs277v7dOAz76oEGqDG1eP2UBE5pDP6A19K3dDtkDe5TC9rvp0mHb5Lkc4HCD1xAvi5CaqQE9pJovtizyf0lXv",
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

        response = HTTParty.post("https://www.facebook.com/api/graphql?variables=#{variables}&doc_id=#{doc_id}", http_proxyaddr: @@proxy_url, http_proxyport: @@proxy_port)

        render json: JSON.parse(response.body)
      end
    end
  end
end
