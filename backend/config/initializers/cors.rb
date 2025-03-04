Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'localhost:3001', 'another-origin.com' # Specify allowed origins
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true # Allows cookies and other credentials
    end
  end