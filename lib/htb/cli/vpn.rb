# frozen_string_literal: true

module HTB
  module CLI
    class VPN < Thor
      def self.exit_on_failure?
        true
      end

      desc "status", "Show VPN connection status"
      def status
        client = CLI.client
        data = CLI.spinner("Fetching VPN status...") { client.vpn.status }

        if data
          puts CLI.pastel.bold("\n=== VPN Status ===")
          if data["data"]
            d = data["data"]
            CLI.print_table(
              ["Field", "Value"],
              [
                ["Connected", d["connection"] ? CLI.pastel.green("Yes") : CLI.pastel.red("No")],
                ["Server", d["server"] || "N/A"],
                ["IP", d["ip"] || "N/A"],
                ["Location", d["location"] || "N/A"]
              ]
            )
          else
            CLI.print_info("Not connected")
          end
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "servers", "List VPN servers"
      def servers
        client = CLI.client
        data = CLI.spinner("Fetching servers...") { client.vpn.servers }

        if data && data["data"]
          rows = data["data"].map do |s|
            [
              s["id"],
              s["friendly_name"] || s["name"],
              s["location"] || "N/A",
              s["current_clients"] || 0,
              s["status"] || "N/A"
            ]
          end

          puts CLI.pastel.bold("\nVPN Servers:")
          CLI.print_table(["ID", "Name", "Location", "Clients", "Status"], rows)
        else
          CLI.print_info("No servers found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "switch SERVER_ID", "Switch to a different VPN server"
      def switch(server_id)
        client = CLI.client
        result = CLI.spinner("Switching server...") { client.vpn.switch(server_id) }

        if result && result["success"]
          CLI.print_success("Switched to server #{server_id}")
        else
          CLI.print_info(result["message"] || "Switch request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "regenerate", "Regenerate VPN config"
      def regenerate
        client = CLI.client
        result = CLI.spinner("Regenerating VPN config...") { client.vpn.regenerate }

        if result && result["success"]
          CLI.print_success("VPN config regenerated!")
        else
          CLI.print_info(result["message"] || "Regeneration request sent")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "labs", "List available labs"
      def labs
        client = CLI.client
        data = CLI.spinner("Fetching labs...") { client.vpn.labs }

        if data && data["data"]
          rows = data["data"].map do |l|
            [l["id"], l["name"], l["description"] || "N/A"]
          end

          puts CLI.pastel.bold("\nLabs:")
          CLI.print_table(["ID", "Name", "Description"], rows)
        else
          CLI.print_info("No labs found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "prolabs", "List Pro Labs"
      def prolabs
        client = CLI.client
        data = CLI.spinner("Fetching Pro Labs...") { client.vpn.prolabs }

        if data && data["data"]
          rows = data["data"].map do |p|
            [
              p["id"],
              p["name"],
              p["difficulty"] || "N/A",
              p["machines_count"] || 0,
              p["flags"] || 0
            ]
          end

          puts CLI.pastel.bold("\nPro Labs:")
          CLI.print_table(["ID", "Name", "Difficulty", "Machines", "Flags"], rows)
        else
          CLI.print_info("No Pro Labs found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "endgames", "List Endgames"
      def endgames
        client = CLI.client
        data = CLI.spinner("Fetching Endgames...") { client.vpn.endgames }

        if data && data["data"]
          rows = data["data"].map do |e|
            [
              e["id"],
              e["name"],
              e["difficulty"] || "N/A",
              e["flags"] || 0
            ]
          end

          puts CLI.pastel.bold("\nEndgames:")
          CLI.print_table(["ID", "Name", "Difficulty", "Flags"], rows)
        else
          CLI.print_info("No Endgames found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end

      desc "fortresses", "List Fortresses"
      def fortresses
        client = CLI.client
        data = CLI.spinner("Fetching Fortresses...") { client.vpn.fortresses }

        if data && data["data"]
          rows = data["data"].map do |f|
            [
              f["id"],
              f["name"],
              f["company"] || "N/A",
              f["flags"] || 0
            ]
          end

          puts CLI.pastel.bold("\nFortresses:")
          CLI.print_table(["ID", "Name", "Company", "Flags"], rows)
        else
          CLI.print_info("No Fortresses found")
        end
      rescue HTB::Error => e
        CLI.print_error(e.message)
      end
    end
  end
end
