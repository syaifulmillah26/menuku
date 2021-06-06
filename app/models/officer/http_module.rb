# frozen_string_literal: true

require 'net/http'

# Module
module HttpModule
  def call(uri, request, headers)
    retries   = 0
    http      = nil

    begin
      http       ||= Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.port == 443
      request      = headers(request, headers)

      http.request(request)
    rescue Errno::ECONNREFUSED, Net::ReadTimeout => e
      raise if (retries += 1) <= 3

      Rails.logger.info "Timeout (#{e}), retrying in 1 second..."
      sleep(retries)
      retry
    ensure
      if http.started?
        Rails.logger.info 'Closing the TCP connection...'
        http.finish
      end
    end
  end

  def headers(request, headers)
    headers.each do |key, value|
      request[key.to_s] = value.to_s
    end
    request
  end

  def url_parse(url, query)
    url       = normalize_url(url)
    uri       = URI.parse(url)
    uri.query = URI.encode_www_form(query)
    uri
  end

  def url_parse_raw(url, query)
    url       = normalize_url(url)
    uri       = URI.parse(url)
    uri.query = query
    uri
  end

  def get(url, query = {}, headers = { 'Content-Type': 'application/json' })
    uri     = url_parse(url, query)
    request = Net::HTTP::Get.new(uri.request_uri)

    call(uri, request, headers)
  end

  def get_raw_query(url, query = {}, headers = { 'Content-Type': 'application/json' })
    uri     = url_parse_raw(url, query)
    request = Net::HTTP::Get.new(uri.request_uri)

    call(uri, request, headers)
  end

  def post(url, body = {}, query = {}, headers = { 'Content-Type': 'application/json' })
    uri          = url_parse(url, query)
    request      = Net::HTTP::Post.new(uri.request_uri)
    request.body = body.to_json

    call(uri, request, headers)
  end

  def put(url, body = {}, query = {}, headers = { 'Content-Type': 'application/json' })
    uri          = url_parse(url, query)
    request      = Net::HTTP::Put.new(uri.request_uri)
    request.body = body.to_json

    call(uri, request, headers)
  end

  def patch(url, body = {}, query = {}, headers = { 'Content-Type': 'application/json' })
    uri          = url_parse(url, query)
    request      = Net::HTTP::Patch.new(uri.request_uri)
    request.body = body.to_json

    call(uri, request, headers)
  end

  def delete(url, body = {}, query = {}, headers = { 'Content-Type': 'application/json' })
    uri          = url_parse(url, query)
    request      = Net::HTTP::Delete.new(uri.request_uri)
    request.body = body.to_json

    call(uri, request, headers)
  end

  def normalize_url(url)
    uri  = URI.parse url
    host = uri.host

    uri = URI.parse "http://#{url}" if host.blank?

    scheme = uri.scheme
    port   = uri.port.to_i

    if port == 443 && scheme == 'http'
      uri = URI.parse "https://#{url}"
    elsif port == 80 && scheme == 'https'
      uri = URI.parse "http://#{url}"
    end

    uri.to_s
  end
end
