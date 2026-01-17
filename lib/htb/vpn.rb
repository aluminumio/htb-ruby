# frozen_string_literal: true

module HTB
  class VPN
    def initialize(client)
      @client = client
    end

    # Get VPN server list
    # GET /api/v4/connections/servers
    def servers
      @client.get("/connections/servers")
    end

    # Get current VPN connection status
    # GET /api/v4/connection/status
    def status
      @client.get("/connection/status")
    end

    # Switch VPN server
    # POST /api/v4/connections/servers/switch/{server_id}
    def switch(server_id)
      @client.post("/connections/servers/switch/#{server_id}")
    end

    # Regenerate VPN config
    # POST /api/v4/connections/regenerate
    def regenerate
      @client.post("/connections/regenerate")
    end

    # Download VPN config
    # GET /api/v4/access/ovpnfile/{server_id}/{tcp_or_udp}
    # @param server_id [Integer] VPN server ID
    # @param protocol [String] "tcp" or "udp" (default: "udp")
    def download_config(server_id, protocol: "udp")
      @client.get("/access/ovpnfile/#{server_id}/#{protocol}")
    end

    # Get labs list
    # GET /api/v4/labs/list
    def labs
      @client.get("/labs/list")
    end

    # Get available labs for user
    # GET /api/v4/labs/available
    def available_labs
      @client.get("/labs/available")
    end

    # Get lab info
    # GET /api/v4/lab/info/{lab_id}
    def lab_info(lab_id)
      @client.get("/lab/info/#{lab_id}")
    end

    # Get prolabs list
    # GET /api/v4/prolab/list
    def prolabs
      @client.get("/prolab/list")
    end

    # Get prolab info
    # GET /api/v4/prolab/info/{prolab_id}
    def prolab_info(prolab_id)
      @client.get("/prolab/info/#{prolab_id}")
    end

    # Get fortress list
    # GET /api/v4/fortress/list
    def fortresses
      @client.get("/fortress/list")
    end

    # Get endgame list
    # GET /api/v4/endgame/list
    def endgames
      @client.get("/endgame/list")
    end
  end
end
