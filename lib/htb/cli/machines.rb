# frozen_string_literal: true

module HTB
  module CLI
    class Machines < Thor
      def self.exit_on_failure?
        true
      end

      desc "list", "List all active machines"
      option :retired, type: :boolean, desc: "Show retired machines instead"
      option :sp, type: :boolean, desc: "Show Starting Point machines"
      def list
        client = CLI.client

        machines = CLI.spinner("Fetching machines...") do
          if options[:retired]
            client.machines.retired
          elsif options[:sp]
            client.machines.starting_point
          else
            client.machines.list
          end
        end

        if machines && machines["info"]
          rows = machines["info"].map do |m|
            difficulty = m["difficultyText"] || m["difficulty"] || "N/A"
            os = m["os"] || "N/A"
            [
              m["id"],
              m["name"],
              os,
              difficulty,
              m["user_owns_count"] || 0,
              m["root_owns_count"] || 0,
              m["release"] || "N/A"
            ]
          end

          puts CLI.pastel.bold("\nMachines:")
          CLI.print_table(
            ["ID", "Name", "OS", "Difficulty", "User Owns", "Root Owns", "Released"],
            rows
          )
          puts "\nTotal: #{rows.size} machines"
        else
          CLI.print_info("No machines found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "info MACHINE", "Show machine details (by ID or name)"
      def info(machine)
        client = CLI.client
        data = CLI.spinner("Fetching machine info...") { client.machines.profile(machine) }

        if data && data["info"]
          m = data["info"]
          puts CLI.pastel.bold("\n=== #{m['name']} ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["ID", m["id"]],
              ["Name", m["name"]],
              ["OS", m["os"]],
              ["Difficulty", m["difficultyText"] || m["difficulty"]],
              ["Points", m["points"]],
              ["User Owns", m["user_owns_count"]],
              ["Root Owns", m["root_owns_count"]],
              ["Rating", "#{m['stars']}/5.0"],
              ["Released", m["release"]],
              ["Retired", m["retired"] ? "Yes" : "No"],
              ["Free", m["free"] ? "Yes" : "No"]
            ]
          )

          if m["ip"]
            puts CLI.pastel.bold("\nConnection:")
            puts "  IP: #{CLI.pastel.green(m['ip'])}"
          end

          if m["maker"]
            puts CLI.pastel.bold("\nCreator:")
            puts "  #{m['maker']['name']}"
          end
        else
          CLI.print_error("Machine not found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "active", "Show currently active machine"
      def active
        client = CLI.client
        data = CLI.spinner("Fetching active machine...") { client.machines.active }

        if data && data["info"]
          m = data["info"]
          puts CLI.pastel.bold("\n=== Active Machine ===")
          CLI.print_table(
            ["Field", "Value"],
            [
              ["Name", m["name"]],
              ["IP", m["ip"] || "N/A"],
              ["OS", m["os"]],
              ["Difficulty", m["difficultyText"] || m["difficulty"]]
            ]
          )
        else
          CLI.print_info("No active machine")
        end
      rescue HTB::Error => e
        CLI.print_info("No active machine")
      end

      desc "play MACHINE_ID", "Start playing a machine (free VPN)"
      def play(machine_id)
        client = CLI.client
        result = CLI.spinner("Starting machine...") { client.machines.play(machine_id) }

        if result && result["success"]
          CLI.print_success("Machine started successfully!")
        else
          CLI.print_error(result["message"] || "Failed to start machine")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "stop", "Stop current machine"
      def stop
        client = CLI.client
        result = CLI.spinner("Stopping machine...") { client.machines.stop }

        if result && result["success"]
          CLI.print_success("Machine stopped!")
        else
          CLI.print_error(result["message"] || "Failed to stop machine")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "own MACHINE_ID --flag FLAG", "Submit a flag for ownership"
      option :flag, required: true, desc: "The flag to submit"
      option :difficulty, type: :numeric, default: 50, desc: "Difficulty rating (10-100)"
      def own(machine_id)
        client = CLI.client
        result = CLI.spinner("Submitting flag...") do
          client.machines.own(
            machine_id: machine_id.to_i,
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

      desc "search QUERY", "Search for machines"
      def search(query)
        client = CLI.client
        results = CLI.spinner("Searching...") { client.machines.search(query) }

        if results && results["machines"]
          rows = results["machines"].map do |m|
            [m["id"], m["name"], m["os"], m["difficulty"]]
          end
          CLI.print_table(["ID", "Name", "OS", "Difficulty"], rows)
        else
          CLI.print_info("No results found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "recommended", "Show recommended machines"
      def recommended
        client = CLI.client
        data = CLI.spinner("Fetching recommendations...") { client.machines.recommended }

        if data && data["info"]
          rows = data["info"].map do |m|
            [m["id"], m["name"], m["os"], m["difficultyText"] || m["difficulty"]]
          end
          puts CLI.pastel.bold("\nRecommended Machines:")
          CLI.print_table(["ID", "Name", "OS", "Difficulty"], rows)
        else
          CLI.print_info("No recommendations available")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end
    end
  end
end
