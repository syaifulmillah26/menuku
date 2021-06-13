# frozen_string_literal: true

require 'httparty'

# midtrans helper
module MidtransHelper
  def http_get(url, body)
    HTTParty.get(
      midtrans_url(url),
      headers: url_header,
      body: body
    )&.parsed_response
  end

  def http_post(url, body)
    HTTParty.post(
      midtrans_url(url),
      headers: url_header,
      body: body
    )&.parsed_response
  end

  def midtrans_url(endpoint)
    ENV['MIDTRANS_API_SANDBOX_URL'] + endpoint
  end

  def encoded
    Base64.encode64(ENV['VERITRANS_SERVER_KEY'] + ':')
  end

  def url_header
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Authorization' => "Basic #{encoded}"
    }
  end
end
