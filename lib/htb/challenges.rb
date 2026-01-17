# frozen_string_literal: true

module HTB
  class Challenges
    def initialize(client)
      @client = client
    end

    # List all challenges
    # GET /api/v4/challenge/list
    def list
      @client.get("/challenge/list")
    end

    # Get challenge info by ID
    # GET /api/v4/challenge/info/{challenge_id}
    def info(challenge_id)
      @client.get("/challenge/info/#{challenge_id}")
    end

    # Get active challenge
    # GET /api/v4/challenge/active
    def active
      @client.get("/challenge/active")
    end

    # Start a challenge
    # POST /api/v4/challenge/start/{challenge_id}
    def start(challenge_id)
      @client.post("/challenge/start/#{challenge_id}")
    end

    # Stop a challenge
    # POST /api/v4/challenge/stop/{challenge_id}
    def stop(challenge_id)
      @client.post("/challenge/stop/#{challenge_id}")
    end

    # Submit flag for challenge
    # POST /api/v4/challenge/own
    # @param challenge_id [Integer] Challenge ID
    # @param flag [String] The flag to submit
    # @param difficulty [Integer] Difficulty rating
    def own(challenge_id:, flag:, difficulty: 50)
      @client.post("/challenge/own", {
        id: challenge_id,
        flag: flag,
        difficulty: difficulty
      })
    end

    # Download challenge files
    # GET /api/v4/challenge/download/{challenge_id}
    def download(challenge_id)
      @client.get("/challenge/download/#{challenge_id}")
    end

    # Get challenge categories
    # GET /api/v4/challenge/categories/list
    def categories
      @client.get("/challenge/categories/list")
    end

    # Get retired challenges
    # GET /api/v4/challenge/list/retired
    def retired
      @client.get("/challenge/list/retired")
    end

    # Get challenge activity
    # GET /api/v4/challenge/activity/{challenge_id}
    def activity(challenge_id)
      @client.get("/challenge/activity/#{challenge_id}")
    end

    # Submit challenge review
    # POST /api/v4/challenge/review
    def review(challenge_id:, stars:, headline:, review:)
      @client.post("/challenge/review", {
        id: challenge_id,
        stars: stars,
        headline: headline,
        review: review
      })
    end

    # Get recommended challenges
    # GET /api/v4/challenge/recommended
    def recommended
      @client.get("/challenge/recommended")
    end

    # Get challenge todo status
    # GET /api/v4/challenge/todo/{challenge_id}
    def todo(challenge_id)
      @client.get("/challenge/todo/#{challenge_id}")
    end

    # Spawn challenge instance
    # POST /api/v4/challenge/spawn
    def spawn(challenge_id)
      @client.post("/challenge/spawn", { challenge_id: challenge_id })
    end

    # Terminate challenge instance
    # POST /api/v4/challenge/terminate
    def terminate(challenge_id)
      @client.post("/challenge/terminate", { challenge_id: challenge_id })
    end
  end
end
