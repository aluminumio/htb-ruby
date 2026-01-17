# frozen_string_literal: true

module HTB
  class VM
    def initialize(client)
      @client = client
    end

    # Spawn a machine (VIP/Starting Point)
    # POST /api/v4/vm/spawn
    # @param machine_id [Integer] The machine ID to spawn
    # @return [Hash] Response containing spawn status
    #
    # @example
    #   client.vm.spawn(811)
    #   # => { "success" => "1", "message" => "Machine is being spawned..." }
    #
    # Note: This endpoint is used for VIP and Starting Point machines.
    # The base URI changed from www.hackthebox.com to labs.hackthebox.com
    def spawn(machine_id)
      @client.post("/vm/spawn", { machine_id: machine_id })
    end

    # Terminate a running machine
    # POST /api/v4/vm/terminate
    # @param machine_id [Integer] The machine ID to terminate
    def terminate(machine_id)
      @client.post("/vm/terminate", { machine_id: machine_id })
    end

    # Reset a machine
    # POST /api/v4/vm/reset
    # @param machine_id [Integer] The machine ID to reset
    def reset(machine_id)
      @client.post("/vm/reset", { machine_id: machine_id })
    end

    # Extend machine time
    # POST /api/v4/vm/extend
    # @param machine_id [Integer] The machine ID to extend
    def extend(machine_id)
      @client.post("/vm/extend", { machine_id: machine_id })
    end

    # Get VM status
    # GET /api/v4/vm/status
    def status
      @client.get("/vm/status")
    end

    # Get active VM
    # GET /api/v4/vm/active
    def active
      @client.get("/vm/active")
    end

    # Transfer VM to another lab
    # POST /api/v4/vm/transfer
    def transfer(machine_id:, lab_id:)
      @client.post("/vm/transfer", { machine_id: machine_id, lab_id: lab_id })
    end
  end
end
