Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # get "welcome/index"
  # get "/request_info", to: "my_controller#request_info"

  # Instagram Routes
  get "/instagram_profile", to: "instagram#instagram_profile"
  get "/instagram_profile_reels", to: "instagram#instagram_profile_reels"
  get "/instagram_reel", to: "instagram#instagram_reel"
  get "/instagram_search", to: "instagram#instagram_search"
  get "/proxy_image", to: "instagram#proxy"

  # Facebook Routes
  get "/marketplace_search", to: "facebook#marketplace_search"
  get "/marketplace_listing", to: "facebook#marketplace_listing"
  get "/facebook_user_search", to: "facebook#facebook_user_search"
  get "/facebook_image_search", to: "facebook#facebook_image_search"
  get "/facebook_post_search", to: "facebook#facebook_post_search"
  get "/facebook_video_search", to: "facebook#facebook_video_search"
  get "/facebook_vehicle_search", to: "facebook#marketplace_vehicle_search"
  get "/facebook_property_search", to: "facebook#marketplace_property_search"
  get "/facebook_apparel_search", to: "facebook#marketplace_apparel_search"
  get "/facebook_electronics_search", to: "facebook#marketplace_electronics_search"
  get "/facebook_company_search", to: "facebook#facebook_company_search"
  get "/facebook_classifieds_search", to: "facebook#marketplace_classifieds_search"
  get "/facebook_entertainment_search", to: "facebook#marketplace_entertainment_search"
  get "/facebook_family_search", to: "facebook#marketplace_family_search"
  get "/facebook_free_search", to: "facebook#marketplace_free_search"
  get "/facebook_garden_search", to: "facebook#marketplace_garden_search"
  get "/facebook_hobbies_search", to: "facebook#marketplace_hobbies_search"
  get "/facebook_profile", to: "facebook#facebook_profile"
  get "/facebook_friends", to: "facebook#facebook_friends"
  get "/facebook_location_id_search", to: "facebook#facebook_location_id_search"


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
