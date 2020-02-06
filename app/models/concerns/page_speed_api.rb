module PageSpeedApi
  URL = 'https://www.googleapis.com/pagespeedonline/v5/runPagespeed'.freeze
  KEY = ENV['PAGE_SPEED_API_KEY']
  REQUEST_URL_TEMPLATE = "#{URL}?key=#{KEY}&url=%s".freeze

  ATTRS_MAP = {
    ttfp: 'first-meaningful-paint',
    ttfb: 'time-to-first-byte',
    tti: 'interactive',
    speed_index: 'speed-index'
  }.freeze

  class << self
    def insights_for(url)
      json = JSON.parse http_response(url).body
      return simplify_error_message json['error'] if json['error']

      hash_needed_values json['lighthouseResult']['audits']
    end

    def http_response(url)
      Net::HTTP.get_response URI(REQUEST_URL_TEMPLATE % URI.decode(url))
    end

    def hash_needed_values(json)
      ATTRS_MAP.map { |k, v| [k, json[v]['numericValue']] }.to_h
    end

    def simplify_error_message(json)
      { error: json['errors'].map { |err| err['message'] }.join('. ') }
    end
  end
end
