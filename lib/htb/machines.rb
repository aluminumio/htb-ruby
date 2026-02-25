# frozen_string_literal: true

module HTB
  class Machines
    def initialize(client)
      @client = client
    end

    # List active machines (current season)
    # GET /api/v4/machine/paginated
    def list
      paginate("/machine/paginated")
    end

    # List all retired machines (full VIP+ back catalog)
    # GET /api/v4/machine/list/retired/paginated
    def retired
      paginate("/machine/list/retired/paginated")
    end

    # Get machine profile by ID or name
    # GET /api/v4/machine/profile/{id_or_name}
    def profile(id_or_name)
      @client.get("/machine/profile/#{id_or_name}")
    end

    # Get active machine
    # GET /api/v4/machine/active
    def active
      @client.get("/machine/active")
    end

    # Play/start a machine (free VPN users)
    # POST /api/v4/machine/play/{machine_id}
    def play(machine_id)
      @client.post("/machine/play/#{machine_id}")
    end

    # Stop a machine
    # POST /api/v4/machine/stop
    def stop
      @client.post("/machine/stop")
    end

    # Submit flag for machine ownership
    # POST /api/v4/machine/own
    def own(machine_id:, flag:, difficulty: 50)
      @client.post("/machine/own", {
        id: machine_id,
        flag: flag,
        difficulty: difficulty
      })
    end

    # Submit user flag
    # POST /api/v4/machine/own/user/{machine_id}
    def own_user(machine_id, flag:, difficulty: 50)
      @client.post("/machine/own/user/#{machine_id}", {
        flag: flag,
        difficulty: difficulty
      })
    end

    # Submit root flag
    # POST /api/v4/machine/own/root/{machine_id}
    def own_root(machine_id, flag:, difficulty: 50)
      @client.post("/machine/own/root/#{machine_id}", {
        flag: flag,
        difficulty: difficulty
      })
    end

    # Get machine activity
    # GET /api/v4/machine/activity/{machine_id}
    def activity(machine_id)
      @client.get("/machine/activity/#{machine_id}")
    end

    # Get todo list for machine
    # GET /api/v4/machine/todo/{machine_id}
    def todo(machine_id)
      @client.get("/machine/todo/#{machine_id}")
    end

    # Update todo status for machine
    # POST /api/v4/machine/todo/update/{machine_id}
    def update_todo(machine_id, flag_type:)
      @client.post("/machine/todo/update/#{machine_id}", { flag_type: flag_type })
    end

    # Submit machine review
    # POST /api/v4/machine/review
    def review(machine_id:, stars:, headline:, review:)
      @client.post("/machine/review", {
        id: machine_id,
        stars: stars,
        headline: headline,
        review: review
      })
    end

    # Get recommended machines
    # GET /api/v4/machine/recommended
    def recommended
      @client.get("/machine/recommended")
    end

    # Get spawned machines
    # GET /api/v4/machine/spawned
    def spawned
      @client.get("/machine/spawned")
    end

    # Get starting point machines
    # GET /api/v4/machine/list/sp
    def starting_point
      @client.get("/machine/list/sp")
    end

    # Search machines
    # GET /api/v4/search/fetch?query={query}&tags=[]
    def search(query, tags: [])
      @client.get("/search/fetch", { query: query, tags: tags })
    end

    private

    # Fetch all pages from a paginated endpoint and return unified hash
    # with "info" key for CLI compatibility
    def paginate(path)
      all_machines = []
      page = 1
      loop do
        result = @client.get(path, { page: page, per_page: 100 })
        data = result["data"] || []
        break if data.empty?

        all_machines.concat(data)
        last_page = result.dig("meta", "last_page") || 1
        break if page >= last_page

        page += 1
      end
      { "info" => all_machines }
    end
  end
end
