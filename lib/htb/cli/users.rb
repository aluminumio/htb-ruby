# frozen_string_literal: true

module HTB
  module CLI
    class Users < Thor
      def self.exit_on_failure?
        true
      end

      desc "me", "Show your profile"
      def me
        client = CLI.client
        data = CLI.spinner("Fetching profile...") { client.users.me }

        if data && data["info"]
          info = data["info"]
          puts CLI.pastel.bold("\n=== Your Profile ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["Username", info["name"] || "N/A"],
              ["ID", info["id"] || "N/A"],
              ["Rank", info["rank"] || "N/A"],
              ["Ranking", info["ranking"] || "N/A"],
              ["Points", info["points"] || 0],
              ["User Owns", info["user_owns"] || 0],
              ["Root Owns", info["root_owns"] || 0],
              ["Challenge Owns", info["challenge_owns"] || 0],
              ["Respect", info["respects"] || 0],
              ["Country", info["country_name"] || "N/A"]
            ]
          )
        else
          CLI.print_error("Could not fetch profile")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "info USER_ID", "Show user profile by ID"
      def info(user_id)
        client = CLI.client
        data = CLI.spinner("Fetching user...") { client.users.profile(user_id) }

        if data && data["profile"]
          info = data["profile"]
          puts CLI.pastel.bold("\n=== #{info['name']} ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["ID", info["id"] || "N/A"],
              ["Rank", info["rank"] || "N/A"],
              ["Ranking", info["ranking"] || "N/A"],
              ["Points", info["points"] || 0],
              ["User Owns", info["user_owns"] || 0],
              ["Root Owns", info["root_owns"] || 0],
              ["Respect", info["respects"] || 0],
              ["Country", info["country_name"] || "N/A"]
            ]
          )
        else
          CLI.print_error("User not found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "activity USER_ID", "Show user activity"
      def activity(user_id)
        client = CLI.client
        data = CLI.spinner("Fetching activity...") { client.users.activity(user_id) }

        if data && data["profile"] && data["profile"]["activity"]
          activities = data["profile"]["activity"]
          puts CLI.pastel.bold("\n=== Recent Activity ===")

          activities.first(10).each do |act|
            type = act["type"] || "unknown"
            name = act["name"] || "N/A"
            date = act["date"] || "N/A"
            puts "  #{CLI.pastel.cyan(type)}: #{name} (#{date})"
          end
        else
          CLI.print_info("No activity found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "bloods USER_ID", "Show user's first bloods"
      def bloods(user_id)
        client = CLI.client
        data = CLI.spinner("Fetching bloods...") { client.users.bloods(user_id) }

        if data && data["profile"]
          bloods = data["profile"]
          puts CLI.pastel.bold("\n=== First Bloods ===")

          if bloods["bloods"] && !bloods["bloods"].empty?
            rows = bloods["bloods"].map do |b|
              [b["name"], b["type"], b["date"]]
            end
            CLI.print_table(["Name", "Type", "Date"], rows)
          else
            CLI.print_info("No first bloods")
          end
        else
          CLI.print_info("No bloods found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "badges USER_ID", "Show user's badges"
      def badges(user_id)
        client = CLI.client
        data = CLI.spinner("Fetching badges...") { client.users.badges(user_id) }

        if data && data["badges"]
          puts CLI.pastel.bold("\n=== Badges ===")
          data["badges"].each do |badge|
            puts "  #{CLI.pastel.yellow('★')} #{badge['name']}"
          end
        else
          CLI.print_info("No badges found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "subscriptions", "Show your subscriptions"
      def subscriptions
        client = CLI.client
        data = CLI.spinner("Fetching subscriptions...") { client.users.subscriptions }

        if data
          puts CLI.pastel.bold("\n=== Subscriptions ===")
          puts "  Plan: #{data['plan'] || 'Free'}"
          puts "  VIP: #{data['vip'] ? 'Yes' : 'No'}"
          puts "  Expires: #{data['expires_at'] || 'N/A'}"
        else
          CLI.print_info("No subscription info")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end
    end
  end
end
