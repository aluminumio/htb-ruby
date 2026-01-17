# frozen_string_literal: true

module HTB
  class Client
    attr_reader :api_token

    def initialize(api_token: nil)
      @api_token = api_token || HTB.api_token
      raise AuthenticationError, "API token is required" unless @api_token
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URI) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.headers["Authorization"] = "Bearer #{api_token}"
        conn.headers["Accept"] = "application/json, text/plain, */*"
        conn.headers["Content-Type"] = "application/json"
        conn.headers["User-Agent"] = "htb-ruby/#{VERSION}"
        conn.adapter Faraday.default_adapter
      end
    end

    def get(path, params = {})
      handle_response(connection.get("/api/#{API_VERSION}#{path}", params))
    end

    def post(path, body = {})
      handle_response(connection.post("/api/#{API_VERSION}#{path}", body))
    end

    def put(path, body = {})
      handle_response(connection.put("/api/#{API_VERSION}#{path}", body))
    end

    def delete(path, params = {})
      handle_response(connection.delete("/api/#{API_VERSION}#{path}", params))
    end

    # Module accessors
    def machines
      @machines ||= Machines.new(self)
    end

    def users
      @users ||= Users.new(self)
    end

    def vm
      @vm ||= VM.new(self)
    end

    def challenges
      @challenges ||= Challenges.new(self)
    end

    def vpn
      @vpn ||= VPN.new(self)
    end

    private

    def handle_response(response)
      case response.status
      when 200..299
        response.body
      when 401
        raise AuthenticationError, "Invalid or expired API token"
      when 404
        raise NotFoundError, "Resource not found: #{response.body}"
      when 429
        raise RateLimitError, "Rate limit exceeded"
      else
        raise Error, "API error (#{response.status}): #{response.body}"
      end
    end
  end
end
