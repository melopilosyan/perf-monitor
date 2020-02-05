module PageSpeedApi
  URL = 'https://www.googleapis.com/pagespeedonline/v5/runPagespeed'.freeze
  KEY = ENV['PAGE_SPEED_API_KEY']
  REQUEST_URL_TEMPLATE = "#{URL}?key=#{KEY}&url=%s".freeze

  def self.process(url)
    uri = URI(REQUEST_URL_TEMPLATE % URI.decode(url))
    JSON.parse Net::HTTP.get_response(uri).body
  end
end
