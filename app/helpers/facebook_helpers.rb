module FacebookHelpers
  def listing_restruct(response, type)
    results = []

    if type == 1
      listings = response.dig("data", "viewer", "marketplace_feed_stories", "edges")
      listings.each do |listing|
        info = listing.dig("node", "listing")
        results.push(info)
      end
    end
    if type == 2
      listings = response.dig("data", "marketplace_search", "feed_units", "edges")
      listings.each do |listing|
        info = listing.dig("node", "listing")
        results.push(info)
      end
    end

    results
  end
end
