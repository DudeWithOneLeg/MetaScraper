Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # get "welcome/index"
  # get "/request_info", to: "my_controller#request_info"

  get "/instagram_profile", to: "welcome#instagram_profile"
  get "/instagram_profile_reels", to: "welcome#instagram_profile_reels"
  get "/instagram_reel", to: "welcome#instagram_reel"
  get "/marketplace_search", to: "welcome#marketplace_search"
  get "/marketplace_listing", to: "welcome#marketplace_listing"
  get "/instagram_search", to: "welcome#instagram_search"
  get "/facebook_user_search", to: "welcome#facebook_user_search"
  get "/facebook_image_search", to: "welcome#facebook_image_search"
  get "/facebook_post_search", to: "welcome#facebook_post_search"
  get "/facebook_video_search", to: "welcome#facebook_video_search"
  get "/facebook_company_search", to: "welcome#facebook_company_search"
  get "/facebook_profile", to: "welcome#facebook_profile"
  get "/proxy_image", to: "welcome#proxy"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
