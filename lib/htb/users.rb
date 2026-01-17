# frozen_string_literal: true

module HTB
  class Users
    def initialize(client)
      @client = client
    end

    # Get current user info
    # GET /api/v4/user/info
    def info
      @client.get("/user/info")
    end

    # Get user profile by ID
    # GET /api/v4/user/profile/basic/{user_id}
    def profile(user_id)
      @client.get("/user/profile/basic/#{user_id}")
    end

    # Get current user's profile
    # GET /api/v4/user/profile/basic/me
    def me
      @client.get("/user/profile/basic/me")
    end

    # Get user's activity
    # GET /api/v4/user/profile/activity/{user_id}
    def activity(user_id)
      @client.get("/user/profile/activity/#{user_id}")
    end

    # Get user's bloods (first solves)
    # GET /api/v4/user/profile/bloods/{user_id}
    def bloods(user_id)
      @client.get("/user/profile/bloods/#{user_id}")
    end

    # Get user's progress
    # GET /api/v4/user/profile/progress/machines/os/{user_id}
    def machine_progress(user_id)
      @client.get("/user/profile/progress/machines/os/#{user_id}")
    end

    # Get user's challenge progress
    # GET /api/v4/user/profile/progress/challenges/{user_id}
    def challenge_progress(user_id)
      @client.get("/user/profile/progress/challenges/#{user_id}")
    end

    # Get user's content (writeups, etc.)
    # GET /api/v4/user/profile/content/{user_id}
    def content(user_id)
      @client.get("/user/profile/content/#{user_id}")
    end

    # Update user settings
    # PUT /api/v4/user/settings
    def update_settings(settings)
      @client.put("/user/settings", settings)
    end

    # Get user's connections (followers/following)
    # GET /api/v4/user/profile/connections/{user_id}
    def connections(user_id)
      @client.get("/user/profile/connections/#{user_id}")
    end

    # Follow a user
    # POST /api/v4/user/follow/{user_id}
    def follow(user_id)
      @client.post("/user/follow/#{user_id}")
    end

    # Unfollow a user
    # DELETE /api/v4/user/follow/{user_id}
    def unfollow(user_id)
      @client.delete("/user/follow/#{user_id}")
    end

    # Get user's badges
    # GET /api/v4/user/profile/badges/{user_id}
    def badges(user_id)
      @client.get("/user/profile/badges/#{user_id}")
    end

    # Get subscriptions info
    # GET /api/v4/user/subscriptions
    def subscriptions
      @client.get("/user/subscriptions")
    end

    # Get user's rank history
    # GET /api/v4/user/profile/graph/{period}/{user_id}
    # period: 1M, 3M, 6M, 1Y
    def rank_history(user_id, period: "1Y")
      @client.get("/user/profile/graph/#{period}/#{user_id}")
    end
  end
end
