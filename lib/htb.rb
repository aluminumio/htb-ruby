# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "json"

require_relative "htb/version"
require_relative "htb/config"
require_relative "htb/client"
require_relative "htb/machines"
require_relative "htb/users"
require_relative "htb/vm"
require_relative "htb/challenges"
require_relative "htb/vpn"

module HTB
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class RateLimitError < Error; end
  class NotFoundError < Error; end

  # Base URI for HTB API v4
  # Note: The base URI changed from www.hackthebox.com to labs.hackthebox.com
  BASE_URI = "https://labs.hackthebox.com"
  API_VERSION = "v4"

  class << self
    attr_accessor :api_token

    def configure
      yield self
    end

    def client
      @client ||= Client.new(api_token: api_token)
    end

    def reset_client!
      @client = nil
    end
  end
end
