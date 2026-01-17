# frozen_string_literal: true

module HTB
  module CLI
    class Challenges < Thor
      def self.exit_on_failure?
        true
      end

      desc "list", "List all challenges"
      option :retired, type: :boolean, desc: "Show retired challenges"
      def list
        client = CLI.client

        data = CLI.spinner("Fetching challenges...") do
          if options[:retired]
            client.challenges.retired
          else
            client.challenges.list
          end
        end

        if data && data["challenges"]
          rows = data["challenges"].map do |c|
            [
              c["id"],
              c["name"],
              c["category_name"] || c["category"] || "N/A",
              c["difficulty"] || "N/A",
              c["solves"] || 0,
              c["points"] || 0
            ]
          end

          puts CLI.pastel.bold("\nChallenges:")
          CLI.print_table(
            ["ID", "Name", "Category", "Difficulty", "Solves", "Points"],
            rows
          )
          puts "\nTotal: #{rows.size} challenges"
        else
          CLI.print_info("No challenges found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "info CHALLENGE_ID", "Show challenge details"
      def info(challenge_id)
        client = CLI.client
        data = CLI.spinner("Fetching challenge...") { client.challenges.info(challenge_id) }

        if data && data["challenge"]
          c = data["challenge"]
          puts CLI.pastel.bold("\n=== #{c['name']} ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["ID", c["id"]],
              ["Name", c["name"]],
              ["Category", c["category_name"] || c["category"]],
              ["Difficulty", c["difficulty"]],
              ["Points", c["points"]],
              ["Solves", c["solves"]],
              ["Rating", "#{c['stars']}/5.0"],
              ["Released", c["release_date"]],
              ["Retired", c["retired"] ? "Yes" : "No"]
            ]
          )

          if c["description"]
            puts CLI.pastel.bold("\nDescription:")
            puts "  #{c['description']}"
          end

          if c["maker"]
            puts CLI.pastel.bold("\nCreator:")
            puts "  #{c['maker']['name']}"
          end
        else
          CLI.print_error("Challenge not found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "start CHALLENGE_ID", "Start a challenge"
      def start(challenge_id)
        client = CLI.client
        result = CLI.spinner("Starting challenge...") { client.challenges.start(challenge_id) }

        if result && result["success"]
          CLI.print_success("Challenge started!")
          if result["ip"] || result["port"]
            puts "  Connection: #{result['ip']}:#{result['port']}"
          end
        else
          CLI.print_info(result["message"] || "Start request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "stop CHALLENGE_ID", "Stop a challenge"
      def stop(challenge_id)
        client = CLI.client
        result = CLI.spinner("Stopping challenge...") { client.challenges.stop(challenge_id) }

        if result && result["success"]
          CLI.print_success("Challenge stopped!")
        else
          CLI.print_info(result["message"] || "Stop request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "spawn CHALLENGE_ID", "Spawn a challenge instance"
      def spawn(challenge_id)
        client = CLI.client
        result = CLI.spinner("Spawning challenge...") { client.challenges.spawn(challenge_id) }

        if result
          CLI.print_success("Challenge instance spawning!")
          CLI.print_info(result["message"]) if result["message"]
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "own CHALLENGE_ID --flag FLAG", "Submit a flag"
      option :flag, required: true, desc: "The flag to submit"
      option :difficulty, type: :numeric, default: 50, desc: "Difficulty rating"
      def own(challenge_id)
        client = CLI.client
        result = CLI.spinner("Submitting flag...") do
          client.challenges.own(
            challenge_id: challenge_id.to_i,
            flag: options[:flag],
            difficulty: options[:difficulty]
          )
        end

        if result && result["success"]
          CLI.print_success("Flag accepted! #{result['message']}")
        else
          CLI.print_error(result["message"] || "Flag rejected")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "categories", "List challenge categories"
      def categories
        client = CLI.client
        data = CLI.spinner("Fetching categories...") { client.challenges.categories }

        if data && data["info"]
          puts CLI.pastel.bold("\nChallenge Categories:")
          data["info"].each do |cat|
            puts "  #{CLI.pastel.cyan(cat['name'])} (#{cat['challenges_count']} challenges)"
          end
        else
          CLI.print_info("No categories found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "active", "Show active challenge"
      def active
        client = CLI.client
        data = CLI.spinner("Fetching active challenge...") { client.challenges.active }

        if data && data["info"]
          info = data["info"]
          puts CLI.pastel.bold("\n=== Active Challenge ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["Name", info["name"]],
              ["Category", info["category_name"] || info["category"]],
              ["IP", info["ip"] || "N/A"],
              ["Port", info["port"] || "N/A"]
            ]
          )
        else
          CLI.print_info("No active challenge")
        end
      rescue HTB::Error => e
        CLI.print_info("No active challenge")
      end
    end
  end
end
